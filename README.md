##Pens and Prnters Project

**Data validation: **  
1.Describe validation and cleaning steps for every column in the data

The data has 15,000 rows and 8 columns before cleaning and validation. 

<img width="806" alt="Screenshot 2023-08-07 at 7 32 57 PM" src="https://github.com/Alisa-HP/R-Programming/assets/142073343/96b16d16-1a6d-4243-a276-da16e01b716c">

1.1) week: the week that sale was made after lauching the product.

The sales were made during 1-6 weeks. The data is numeric and, there is not any missing value. Therefore, no action is required.

1.2) sales_method: the three sales method that employees appoach each group of customers

There are three categories of methods: Call, Email, and Call + Email. Although there are no missing values, there are some duplicate categories. The 'email' category is replaced by 'Email', and 'em + call' is replaced by 'Email and Call', as they are the same categories.

1.3) customer_id: this column is a primary key for each customer.

This column contains character values, and they are all 15,000 unique values. Hence, no action is required.

1.4) nb_sold: number of porduct sold

This column contains all numeric values. There are no missing values, hence no action is required.

1.5) revenue: revenue from the sales, rounded to 2 decimal places.

Change data from character to numeric values and replace null values by the median value which is 89.5.

1.6) year_as_customer: number of years customer has been buying from us (company founded in 1984).

This column contains all numerical values. Since 2023, the company has been founded for 39 years. There are some outliers, which are 47 and 63 years; hence, these two rows were dropped.

1.7) nb_site_visits: number of times the customer has visited our website in the last 6 months.

This column contains all numerical values, and there are no missing values. Hence, no action is required.

1.8) state: locations where ordered are shipped. This column contains all character values, and there are no missing values. Hence, no action is required. (total of 50 states)

After the validation and cleaning, the data has 14,998 rows and 9 columns without missing values.

![Unknown](https://github.com/Alisa-HP/R-Programming/assets/142073343/ba146888-a387-4bb0-870a-acabd85fad54)


For the last six weeks, we have employed each sales method to approach customers. The results have shown that the email method reached the highest number of customers, totaling 7,465 people. This was followed by the call method, which accounted for nearly 5,000 people. The smallest group of customers contacted by our sales specialists utilized the call + email method, accounting for approximately 50% of the call method.

![numbercusteachsales](https://github.com/Alisa-HP/R-Programming/assets/142073343/0cfcb378-95ff-4f2f-9f03-010ba9f7a403)

Let's review the performance of each week. We've observed that the beginning of the week marked the peak of sales, while the sixth week of the campaign had the lowest number of sales. Therefore, if we could motivate the staff to engage customers more actively during the final week of the project, we might be able to generate more sales, as there is room for improvement. The performance during the last week accounted for only half of the performance in other weeks, and it represented only 30% of the peak performance seen in the first week.


<img width="911" alt="Screenshot 2023-08-18 at 3 36 54 PM" src="https://github.com/Alisa-HP/R-Programming/assets/142073343/2f06cfff-e4a8-46c6-9c02-851a7709f42f">

What does the spread of the revenue look like overall? And for each method?

The spread of the revenue is likely to be the right skewed distribution and there are two peaks.

