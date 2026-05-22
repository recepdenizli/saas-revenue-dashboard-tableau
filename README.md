# Tableau Subscription Analytics Dashboard

Interactive Tableau dashboard project focused on subscription business metrics such as MRR, churn, LTV, ARPPU, and paid user behavior analysis.

## Dashboard Link

Tableau Public Dashboard:
https://public.tableau.com/app/profile/recep.denizli/viz/GoIT-FinalProjesi-Recep-Denizli/FinalProject2?publish=yes

---

## Project Overview

This project analyzes subscription-based gaming revenue using SQL and Tableau Public.

The dashboard was built by querying tables located in the `project` schema and visualizing the results with interactive filters and KPI tracking.

The goal was to monitor revenue growth, customer retention, and churn dynamics through monthly recurring revenue analytics.

---

## KPIs Included

The dashboard includes:

* Monthly Recurring Revenue (MRR)
* Paid Users
* ARPPU
* New Paid Users
* New MRR
* Churned Revenue
* Expansion MRR
* Contraction MRR
* Customer Lifetime Value (LTV)
* Revenue Churn Indicators

---

## Dashboard Features

* Interactive filters:

  * Date
  * User language
  * User age

* Multiple visualizations:

  * Revenue trends
  * Paid user trends
  * Churn analysis
  * Revenue movement analysis
  * Expansion vs contraction behavior

* Month-over-month change tracking for:

  * Revenue
  * Paid users

---

## SQL Logic

The SQL pipeline was designed using multiple CTEs:

1. Monthly revenue aggregation
2. User-month calendar generation
3. Churn detection using missing-payment months
4. Revenue movement classification:

   * New MRR
   * Expansion MRR
   * Contraction MRR
   * Churn Revenue
   * Reactivation Revenue

Key SQL techniques used:

* Window Functions
* LAG()
* DATE_TRUNC()
* CTE-based transformations
* Cohort-style revenue tracking

---

## Technologies Used

* PostgreSQL
* Tableau Public
* SQL
* Data Visualization
* Revenue Analytics

---

## Business Insights

The dashboard helps identify:

* Customer churn patterns
* Revenue expansion opportunities
* Retention performance
* User monetization behavior
* Subscription business health

---

## Author

Recep Denizli
