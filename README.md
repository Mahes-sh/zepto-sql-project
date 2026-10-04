# 🛒 Zepto Inventory Analysis — SQL Data Analyst Project



## 📌 Project Overview

Zepto is one of India's fastest-growing quick-commerce platforms, delivering groceries in minutes. Behind every 10-minute delivery sits a huge catalogue of products, prices, discounts and stock levels.

This project is a **hands-on SQL analysis of Zepto's product inventory**. I take a raw CSV scraped from the platform, load it into PostgreSQL, clean it, and then answer real business questions an analyst would face:

- Which products give customers the best discounts?
- Which expensive products are going out of stock?
- Which categories bring in the most revenue?
- Which products are actually the best value per gram?

---

## 🎯 Objectives

1. **Set up** a relational database schema for inventory data.
2. **Explore** the dataset: size, categories, stock status, duplicates and nulls.
3. **Clean** the data: remove invalid prices and fix the unit of currency.
4. **Analyse** pricing, discounts, stock and weight with SQL to generate business insights.

---

## 📂 Dataset

| Detail | Info |
|---|---|
| **File** | `zepto_v2.csv` |
| **Rows** | 3,732 SKUs |
| **Columns** | 9 |
| **Categories** | 14 (Fruits & Vegetables, Munchies, Dairy Bread & Batter, Beverages, Biscuits, Personal Care, Home & Cleaning, and more) |

### Column Description

| Column | Type | Description |
|---|---|---|
| `sku_id` | SERIAL (PK) | Unique ID for every product entry (auto-generated) |
| `category` | VARCHAR(120) | Product category |
| `name` | VARCHAR(150) | Product name |
| `mrp` | NUMERIC(8,2) | Maximum Retail Price (originally in paise, converted to ₹) |
| `discountPercent` | NUMERIC(5,2) | Discount offered on MRP |
| `availableQuantity` | INTEGER | Units available in inventory |
| `discountedSellingPrice` | NUMERIC(8,2) | Final price after discount (converted to ₹) |
| `weightInGms` | INTEGER | Product weight in grams |
| `outOfStock` | BOOLEAN | Whether the product is out of stock |
| `quantity` | INTEGER | Number of units per package |

---

## 🛠️ Tools & Skills Used

- **PostgreSQL** (any SQL client works: pgAdmin, DBeaver, etc.)
- **SQL concepts:** `GROUP BY`, `HAVING`, `CASE WHEN`, aggregate functions, `DISTINCT`, `ROUND`, `UPDATE`, `DELETE`, filtering and sorting

---

## 🔄 Project Workflow

```
Raw CSV  →  Create Table  →  Import Data  →  Explore  →  Clean  →  Analyse  →  Insights
```

### 1️⃣ Database Setup
Created the `zepto` table with a `SERIAL` primary key and properly typed columns, then imported the CSV.

```sql
DROP TABLE IF EXISTS zepto;

CREATE TABLE zepto (
    sku_id SERIAL PRIMARY KEY,
    category VARCHAR(120),
    name VARCHAR(150) NOT NULL,
    mrp NUMERIC(8,2),
    discountPercent NUMERIC(5,2),
    availableQuantity INTEGER,
    discountedSellingPrice NUMERIC(8,2),
    weightInGms INTEGER,
    outOfStock BOOLEAN,
    quantity INTEGER
);
```

### 2️⃣ Data Exploration 🔍
Before touching anything, I got to know the data:

- ✅ Total **row count**
- ✅ **Sample records** to understand structure
- ✅ **Null value checks** across all columns
- ✅ List of **distinct product categories**
- ✅ **In-stock vs out-of-stock** split
- ✅ **Duplicate product names** (same product, multiple SKUs/sizes)

### 3️⃣ Data Cleaning 🧹
Real-world data is messy. Two issues were fixed:

| Problem | Fix |
|---|---|
| Products with `MRP = 0` (invalid pricing) | Identified and **deleted** |
| Prices stored in **paise** instead of **rupees** | Divided `mrp` and `discountedSellingPrice` by 100 |

```sql
DELETE FROM zepto WHERE mrp = 0;

UPDATE zepto
SET mrp = mrp / 100.0,
    discountedSellingPrice = discountedSellingPrice / 100.0;
```

---

## 📊 Business Questions Answered

| # | Business Question | Key SQL Concepts |
|---|---|---|
| **Q1** | Top 10 best-value products by discount % | `ORDER BY`, `LIMIT` |
| **Q2** | High-MRP products (> ₹300) that are out of stock | `WHERE`, `DISTINCT` |
| **Q3** | Estimated revenue for each category | `SUM`, `GROUP BY` |
| **Q4** | Premium products (MRP > ₹500) with discount < 10% | Multi-condition `WHERE` |
| **Q5** | Top 5 categories with the highest average discount | `AVG`, `ROUND`, `LIMIT` |
| **Q6** | Price per gram for products ≥ 100g, sorted by best value | Calculated columns |
| **Q7** | Classify products as Low / Medium / Bulk by weight | `CASE WHEN` |
| **Q8** | Total inventory weight per category | `SUM`, arithmetic on columns |

### Sample Queries

**Q1: 🏷️ Best discounts on the platform**
```sql
SELECT name, mrp, discountPercent
FROM zepto
ORDER BY discountPercent DESC
LIMIT 10;
```

**Q2: 🚨 Expensive products going out of stock (lost-sales risk)**
```sql
SELECT DISTINCT name, mrp, outOfStock
FROM zepto
WHERE outOfStock = TRUE AND mrp > 300
ORDER BY mrp DESC;
```

**Q6: ⚖️ Which products give the most for your money?**
```sql
SELECT DISTINCT name, weightInGms, discountedSellingPrice,
       ROUND(discountedSellingPrice / weightInGms, 2) AS price_per_gram
FROM zepto
WHERE weightInGms >= 100
ORDER BY price_per_gram;
```

**Q7: 📦 Weight-based product segmentation**
```sql
SELECT DISTINCT name, weightInGms,
  CASE
    WHEN weightInGms < 1000 THEN 'Low'
    WHEN weightInGms < 5000 THEN 'Medium'
    ELSE 'Bulk'
  END AS weight_category
FROM zepto;
```

> 📄 The full script is in [`zeptoProject.sql`](./zeptoProject.sql).

---

## 💡 Key Insights & Takeaways

> *Fill in the exact numbers from your own query results to make this section stand out.*

- 🔥 **Discounts vary a lot by category.** Some categories consistently offer deeper discounts than others (Q5), which hints at where Zepto competes hardest on price.
- 🚫 **Out-of-stock premium items** (Q2) represent potential lost revenue and are a prime target for better inventory planning.
- 💰 **Revenue is concentrated** in a handful of categories (Q3), so stocking decisions there matter the most.
- ⚖️ **Bigger isn't always cheaper.** Price-per-gram analysis (Q6) shows that some small packs can be better value than larger ones, and vice versa.
- 🧾 **Premium products with low discounts** (Q4) are items where customers pay close to full price, which is a sign of strong brand pull.
- 🏋️ **Weight-based segmentation** (Q7, Q8) helps logistics teams understand which categories carry the heaviest inventory load.

---

## 🚀 How to Run This Project

1. **Clone the repository**
   ```bash
   git clone https://github.com/<your-username>/zepto-sql-analysis.git
   ```
2. **Create the database** in PostgreSQL.
3. **Run the `CREATE TABLE` script** from `zepto_analysis.sql`.
4. **Import the dataset** (`zepto_v2.csv`). In pgAdmin: *Right-click table → Import/Export Data*. Make sure the encoding is set to **LATIN1** if you get an encoding error.
5. **Run the cleaning and analysis queries** section by section and explore the results.

---

## 📁 Repository Structure

```
zepto-sql-analysis/
│
├── zepto_v2.csv           # Raw dataset
├── zeptoProject.sql       # Schema, exploration, cleaning & analysis 
└── README.md              # Project documentation
```




