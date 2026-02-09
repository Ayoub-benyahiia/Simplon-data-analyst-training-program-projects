📊 Tableau Dashboard Project — README
📝 Project Overview

Analyze company data (sales, returns, customers, products, satisfaction) to create an interactive dashboard for business decisions.

💾 Data Sources

🛒 Sales (Achats)

⭐ Customer Ratings (Évaluations)

🔄 Returns (Retours)

👤 Customer Info (Personnes)

🔗 Data Connections

🔹 LEFT JOIN: Sales ↔ Ratings

🔹 LEFT JOIN: Sales ↔ Returns

🔹 INNER JOIN: Sales ↔ Customers

🔹 Logical Relationship: Sales ↔ Ratings (for satisfaction per order)

🧹 Data Preparation

Clean data & set formats:

💰 Sales & Profit = currency

🔢 Quantity = integer

📊 Satisfaction = %

Create hierarchies:

📦 Product: Category → Sub-category → Product Name

🌍 Geography: Country → Region → City

📈 Visualizations

Sales by Sub-category, Segment & Product Hierarchy

Customer Satisfaction per Order

Sales over Time (Day / Month / Year)

Advanced: 🗺️ Map, 🔵 Bubble Chart, 📊 Dual Axis, 🔢 Small Multiples, 📏 Reference Lines

Tables: Simple, Multi-dimension, Pivot, Multi-measure

🧮 Calculations & Parameters

📌 Profit % of Sales

♻️ Eco-tax 5% for tech products (exclude recycled)

⚠️ Flag for low sales (<1000)

🔧 Parameter: % Profit Increase

📊 Dashboard

Interactive dashboard with:

🔎 Filters (Region, Date, Segment)

⚙️ Parameters for profit adjustment

👀 Hover for detailed info

📦 Deliverables

📂 Tableau Workbook (.twbx)

📝 Worksheets for each visualization

📊 Interactive dashboard

🗒️ This README