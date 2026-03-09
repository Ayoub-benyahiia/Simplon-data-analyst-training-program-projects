Hospital Data Analysis Project - SQL Server
🏥 Context
This project focuses on managing and analyzing a complex hospital database. The dataset reflects the complete patient journey: Medical Care → Billing → Insurance Payment → Adjustments → Accounts Receivable.

Working with a Fact Table and 8 Dimension Tables, this project aims to simulate a real-world Data Analyst environment within the healthcare financial sector.

🎯 Objectives
Database Architecture: Design and structure a relational database in SQL Server.

Data Engineering: Import Excel datasets and maintain data integrity.

SQL Mastery: Apply advanced joins, aggregations, and business logic calculations.

Business Intelligence: Translate complex medical/financial questions into efficient SQL queries.

🗂️ Project Roadmap
Phase 1: Environment Setup
Creation of the database schema in SQL Server.

Definition of the FactTable and the 8 Dimension Tables.

Data import from Excel source files.

Phase 2: Data Integrity & Relationships
Setting up Primary Keys (PK) for all dimension tables.

Establishing Foreign Keys (FK) in the Fact Table to create a robust Star Schema.

Data validation to ensure consistency after import.

Phase 3: Data Exploration & Joins
Initial exploratory data analysis (EDA) using simple SELECT statements.

Complex multi-table joins to reconstruct the patient's financial and clinical journey (Patient info, Physician charges, Diagnostic codes, and Insurance adjustments).

🔍 SQL Analysis & Business Logic
The project includes the resolution of 10 key business questions, ranging from basic counts to complex demographic reporting:

High-Value Charges: Filtering rows with Gross Charges > $100.

Patient Metrics: Identification of unique patients within the system.

CPT Cataloging: Distribution of CPT (Current Procedural Terminology) codes by group.

Medicare Analysis: Identifying physicians involved in Medicare claims.

Volume Analysis: CPT codes exceeding 100 units.

Revenue by Specialty: Identifying the top-earning specialty with monthly payment trends.

Diagnostic Filtering: Units assigned to "J-code" diagnostics (often related to drugs/injections).

Demographic Segmentation: Categorizing patients into age brackets (<18, 18-65, >65) with full contact details.

Credentialing Adjustments: * Total financial loss due to credentialing issues.

Identification of the most affected clinics.

Impact assessment on the medical staff.

🛠️ Tech Stack
Database Engine: Microsoft SQL Server

Tools: SQL Server Management Studio (SSMS)

Languages: T-SQL (Transact-SQL)

Data Source: Excel / CSV

💡 Key Concept: Credentialing Adjustments
In this project, we analyze "Credentialing" adjustments. In a real hospital setting, this usually means the provider (doctor) was not properly registered or "credentialed" with the insurance company at the time of service, leading to denied payments and financial loss for the hospital.

Projet réalisé dans le cadre du bootcamp Data Analyst @ Simplon.