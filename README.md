#  Product-Level Loss Driver Analysis (Superstore Dataset)

##  Project Overview
This project analyzes **product-level profitability** using the Superstore dataset, with the goal of identifying **why certain products generate losses** despite overall positive performance.

Rather than stopping at surface-level KPIs, the analysis drills down into **pricing behavior, customer concentration, time patterns, and operational factors** to identify the **true root causes** of losses.

The project combines **SQL-based exploratory analysis** with **Power BI dashboards** designed for clear business storytelling and decision-making.

---

##  Dataset
- Source: Superstore Dataset (Kaggle)
- Grain: Order line–level transactional data
- Key fields:**  
  `order_date`, `product_id`, `product_name`, `customer_id`,  
  `sales`, `profit`, `discount`, `ship_mode`, `region`

---

## 🎯 Business Questions
1. Are losses driven by unprofitable products**, or by specific commercial conditions?
2. Are loss-making products:
   - unprofitable for all customers?
   - or only under certain pricing scenarios?
3. Do losses persist over time, or are they episodic?
4. Do operational factors (e.g., delivery speed) contribute to losses?

---

## Tools & Skills Used
- SQL (SQLite)
  - Aggregations (`SUM`, `AVG`)
  - Product-, customer-, order-, and time-level analysis
- Power BI
  - Measures (Profit Margin, Average Discount)
  - Interactive visuals and cross-filtering
- Analytical Skills
  - Root-cause analysis
  - Hypothesis testing
  - Dashboard storytelling
  - Business interpretation

---

##  Analytical Approach

###  Executive Overview
A high-level assessment of:
- Total sales, profit, and profit margin
- Profitability by product category
- Sales and profit by region


![tab1_executive_overwiew](https://github.com/user-attachments/assets/9f9fc26c-f101-41f1-8d44-de204baaf337)


Insight: 
Overall performance is positive; however, profitability varies significantly across categories and regions, indicating potential risk areas that require deeper investigation.

---

### Product-Level Profitability Funnel
Products were compared using:
- Total Sales
- Total Profit
- Profit Margin

A Sales vs Profit Margin scatter plot was used to identify high-impact loss-making products, highlighting products that generate significant losses despite meaningful sales volume.

![tab2_product_profitability](https://github.com/user-attachments/assets/b1967967-c037-4809-ba89-05273747c051)
 

Outcome:  
Product OFF-BI-10004995 was selected for deeper analysis due to:
- Repeated loss behavior
- Non-trivial sales volume
- Visibility as a high-risk product

---

### Loss Driver Analysis (Focused Product)

This section investigates why the selected product generates losses.

---

#### Discounting vs Profitability
SQL analysis revealed a strong negative relationship between discount levels and profit margins.

![SQL_Discount_and_Profitability](https://github.com/user-attachments/assets/41a5e9d4-afec-4f35-96f5-c532d9bfe0fd)

![tab3_loss_driver_analysis](https://github.com/user-attachments/assets/159fbf71-1422-4c45-9967-6034a0019906)


Conclusion:  
Losses are driven by aggressive discounting, not by inherent product cost structure.

---

#### Customer Concentration (Top Loss Contributors)
A focused view of the lowest profit margin customers shows that a small number of customers account for the most severe losses.

![tab3_loss_driver_analysis](https://github.com/user-attachments/assets/add35c7e-f6a0-43d0-b6a0-7e118641fb0e)


Conclusion: 
Losses are commercially driven by pricing conditions applied to specific customers rather than widespread customer behavior issues.

---

#### Time Trend Validation
Time-based analysis was conducted to determine whether losses are persistent or episodic.

![SQL_Time_Based_Aggregation](https://github.com/user-attachments/assets/b00c5ecd-ce5c-4233-8579-b48b2a6a0c64)

![tab3_loss_driver_analysis](https://github.com/user-attachments/assets/35f69d94-9bdf-43bc-9aa3-af729d96d84a)


Conclusion:
Losses occur during specific time periods and align with discount spikes, confirming that losses are not structural.

---

####  Delivery Speed vs Profitability
Delivery speed (ship mode) was evaluated as a potential operational driver.

![tab3_loss_driver_analysis](https://github.com/user-attachments/assets/22d26d43-1350-4dc3-bc90-d44ab2414e18)


Conclusion:
Delivery speed has no significant impact on profitability, ruling out operational inefficiencies as a root cause.

---

##  Key Findings
- The analyzed product is profitable under normal pricing conditions
- Losses occur only during periods of extreme discounting (70–80%)
- Losses are:
  - Not structural
  - Not operational
  - Not persistent over time
- The root cause is pricing policy, not product design or logistics

---

##  Business Recommendations
- Cap maximum discount levels for the product
- Introduce margin-based approval thresholds for promotions
- Monitor customers receiving extreme discounts
- Track product margins over time to detect early warning signals

---

##  Deliverables
- **Power BI Dashboard**
  - Tab 1: Executive Overview
  - Tab 2: Product-Level Profitability
  - Tab 3: Loss Driver Analysis
- SQL file containing all exploratory queries with clear documentation
- README documentation explaining analytical reasoning and conclusions

---

##  Why This Project Matters
This project demonstrates the ability to:
- Move from symptoms to root causes
- Apply analytical judgment (including removing low-value visuals)
- Translate data into clear, actionable business insights
- Build dashboards that support decision-making, not just reporting

---

## Notes
Additional assumptions and limitations are documented in  
`assumptions_and_limitations.md`.


