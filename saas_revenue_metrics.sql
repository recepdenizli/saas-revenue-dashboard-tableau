WITH monthly_user_revenue AS (
    -- Kullanıcı ödemelerini demografik verilerle birleştiriyorum
    SELECT 
        DATE_TRUNC('month', p.payment_date) AS month,
        p.user_id,
        u.language,
        u.age,
        u.has_older_device_model,
        SUM(p.revenue_amount_usd) AS revenue,
        MIN(DATE_TRUNC('month', p.payment_date)) OVER (PARTITION BY p.user_id) AS first_payment_month
    FROM project.games_payments p
    LEFT JOIN project.games_paid_users u ON p.user_id = u.user_id
    GROUP BY 1, 2, 3, 4, 5
),
calendar AS (
    SELECT DISTINCT month FROM monthly_user_revenue
),
user_grid AS (
    -- Kullanıcının ödeme yapmadığı ayları da (Churn tespiti için) hayali olarak dolduruyorum
    SELECT 
        c.month, 
        u.user_id, 
        u.language, 
        u.age, 
        u.has_older_device_model, 
        u.first_payment_month,
        COALESCE(r.revenue, 0) AS revenue,
        LAG(COALESCE(r.revenue, 0)) OVER (PARTITION BY u.user_id ORDER BY c.month) AS prev_revenue
    FROM calendar c
    CROSS JOIN (SELECT DISTINCT user_id, language, age, has_older_device_model, first_payment_month FROM monthly_user_revenue) u
    LEFT JOIN monthly_user_revenue r ON c.month = r.month AND u.user_id = r.user_id
    WHERE c.month >= u.first_payment_month
),
metrics_raw AS (
    -- Tableau'daki barlar için metrikleri tek tek ayırıyorum
    SELECT 
        month, language, age, has_older_device_model, user_id, revenue, prev_revenue,
        -- 1. New MRR
        CASE WHEN month = first_payment_month THEN revenue ELSE 0 END AS new_mrr,
        -- 2. Expansion MRR
        CASE WHEN revenue > prev_revenue AND prev_revenue > 0 THEN (revenue - prev_revenue) ELSE 0 END AS expansion_mrr,
        -- 3. Contraction MRR (Negatif değer)
        CASE WHEN revenue < prev_revenue AND revenue > 0 THEN -(prev_revenue - revenue) ELSE 0 END AS contraction_mrr,
        -- 4. Churn Revenue (Negatif değer)
        CASE WHEN prev_revenue > 0 AND revenue = 0 THEN -prev_revenue ELSE 0 END AS churn_revenue,
        -- 5. Back from Churn (Reactivation)
        CASE WHEN prev_revenue = 0 AND revenue > 0 AND month > first_payment_month THEN revenue ELSE 0 END AS back_from_churn_mrr
    FROM user_grid
)
SELECT 
    month::DATE AS "Period", -- ::DATE ile Tableau'nun tarih olarak tanımasını zorluyorum
    COALESCE(language, 'Unknown') AS language,
    age,
    has_older_device_model,
    user_id,
    revenue AS total_revenue,
    new_mrr,
    expansion_mrr,
    contraction_mrr,
    churn_revenue,
    back_from_churn_mrr
FROM metrics_raw
WHERE revenue > 0 OR prev_revenue > 0 -- Sadece hareket olan satırları getiriyoruz
ORDER BY month, user_id;