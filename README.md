# ❄️ Snowflake ETL Analytics - Power BI Dashboard Project

This project demonstrates how I built an end-to-end business intelligence solution using **Snowflake** for data warehousing and **Power BI** for visualization. It includes the creation of **data models**, **fact and dimension tables**, and fully integrated **Power BI dashboards** designed to support business users with clear, actionable insights.

---

## 📊 Project Overview

The goal of this project was to transform raw business data into a **structured Snowflake data warehouse** and use **Power BI** to create dashboards that support decision-making across Finance, Product, and Operations teams. The dashboards are designed to provide visibility into **warehouse compute costs**, **ETL job performance**, **user activity**, and **SaaS product usage**.

---

## 🧱 Key Components

### 1. **Snowflake Data Modeling**

* Designed and implemented **fact and dimension tables** based on the **star schema** to support reporting efficiency and query performance.
* Created **fact tables** for usage metrics (e.g., query execution times, compute consumption, user access).
* Developed **dimension tables** such as `dim_user`, `dim_warehouse`, `dim_product`, and `dim_time` to support flexible slicing and filtering in Power BI.
* Leveraged **Snowflake’s views and CTEs** to simplify complex logic and enable downstream BI integration.

### 2. **Data Transformation**

* Performed transformations using **Power Query** within Power BI to shape and cleanse data pulled from Snowflake.
* Applied filters, column renaming, calculated columns, and data type conversions before loading into the Power BI data model.

### 3. **Power BI Integration**

* Established a **direct Snowflake-to-Power BI connection** for real-time data access and scheduled refreshes.
* Created **dynamic dashboards** using **DAX** and **Power BI visuals** to track:

  * ❄️ **Snowflake Warehouse Usage** – compute time, query costs, and storage trends
  * 📈 **User Activity Dashboards** – session counts, query frequency, most active users
  * ⚙️ **ETL & Pipeline Monitoring** – load times, errors, and success rates across jobs

---

## 💡 Key Highlights

* Successfully integrated Snowflake with Power BI using native connectors and ensured secure, performant access.
* Built reusable data models with clearly defined **relationships**, **metrics**, and **hierarchies**.
* Enabled cross-team insights that helped stakeholders understand **compute cost allocation**, **optimize performance**, and **monitor usage trends** effectively.

---

## 🛠️ Tech Stack

* **Snowflake** – Data warehouse, SQL scripting, data modeling
* **Power BI** – Dashboard creation, DAX, Power Query
* **SQL** – Complex queries, joins, CTEs, performance tuning
* **Star Schema** – Fact/dim modeling
* **DirectQuery/Import** – For optimized performance 
---


