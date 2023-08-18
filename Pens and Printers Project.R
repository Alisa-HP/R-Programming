library(readr)
library(dplyr)
library()

le
read_xlsx("data-pens and printer.xlsx")

n_distinct(data_pens_and_printer$customer_id)
summary(data_pens_and_printer)
View(data_pens_and_printer)

n_distinct((data_pens_and_printer$sales_method))

data_pens_and_printer%>%
  select(sales_method)%>%
  distinct()

library(stringr)
data_pens_and_printer$sales_method<-str_replace(data_pens_and_printer$sales_method,'em + call','Email + Call')

data_pens_and_printer%>%
  summarize(revenue = median(revenue, na.rm = TRUE))

data_pens_and_printer$revenue<- as.numeric(data_pens_and_printer$revenue)

data_pens_and_printer$revenue[is.na(data_pens_and_printer$revenue)] <- median(data_pens_and_printer$revenue, na.rm = T)

drop(data_pens_and_printer)
______
summary(penandprinter)
View(penandprinter)

penandprinter%>%
  select(sales_method)%>%
  distinct()

n_distinct((penandprinter$sales_method))

penandprinter$revenue<- as.numeric(penandprinter$revenue)

penandprinter$revenue[is.na(penandprinter$revenue)] <- median(penandprinter$revenue, na.rm = T)


ggplot(penandprinter, aes(revenue))+geom_boxplot()

class(penandprinter$week)

unique_state<-penandprinter%>%
  select(state)%>%
  distinct()

unique_state%>%arrange(desc(unique_state)) %>%print(n=100) 


#NAME?
penandprint2<-penandprinter[!(penandprinter$years_as_customer==63 | penandprinter$years_as_customer==47),]

---------------
  ggplot(test1, aes(week))+geom_bar()


ggplot(penandprint2, aes(sales_method, revenue))+geom_boxplot()+ 
  labs(x ='Sales Method', y = 'Revenue', title = 'Revenue By Each Sales Method')+
  stat_summary(fun.y="mean", color = 'blue')

quan_call<-penandprint2%>%
  filter(sales_method == 'Call')%>%
  select(revenue)

quan_email<-penandprint2%>%
  filter(sales_method == 'Email')%>%
  select(revenue)

quan_email_call<-penandprint2%>%
  filter(sales_method == 'Email + Call')%>%
  select(revenue)


summary(quan_email_call)

ggplot(penandprint2, aes(revenue))+geom_qq()

ggplot(penandprint2, aes(sales_method, nb_sold))+geom_col()
ggplot(penandprint2, aes(week))+geom_histogram()+labs(title = "Number of Sales Per Week")
ggplot(test1, aes(week, revenue))+geom_col()

ggplot(test2, aes(week, revenue), fill = week)+
  geom_boxplot()+facet_wrap(~week)+  
  labs(x = 'Week', y = 'Revenue', title = 'Revenue Over Time for each of Method')+
  stat_summary(fun.y="mean")

ggplot(penandprint2, aes(sales_method, years_as_customer))+geom_boxplot()+
  facet_wrap(~sales_method)+labs(title = 'Number of Week Sale Was Made')

ggplot(penandprint2, aes(week), color = sales_method) + geom_bar()

test1<- penandprint2 %>%
  group_by(sales_method)%>%
  summarize(revenue = sum(revenue))

test2<- penandprint2 %>%
  filter(sales_method=='Call')

unique_state<- penandprint2 %>%
  filter(sales_method=='Email + Call')

num_cus_each_app<-penandprint2%>%
  group_by(state)%>%
  summarize(sum_sale = sum(revenue))%>%
  arrange(desc(sum_sale))

num_web_each_method<-penandprint2%>%
  count()

View(num_web_each_method)

View(num_cus_each_app)

View(test1)
View(test2)
View(num_web_each_method
     
     View(num_cus_each_app)
     
     penandprint2%>%filter(sales_method == 'Email + Call')%>%count()
     
     ggplot() +
       geom_col(data = test1, aes(x = week, y = revenue ), color = "blue", position = 'jitter') + # must include argument label "data"
       geom_col(data = test2, aes(x = week, y = revenue), color = 'red', position = 'jitter')
     
     ggplot(penandprint2, aes(revenue), fill = "Density") + 
       geom_density() +
       scale_fill_manual(values = "blue") + labs(title = 'Spread of the Revenue')
     ----------------------------------
       ggplot(penandprint2, aes(sales_method))  
     
     
     
     penandprint2%>%
       group_by(sales_method)%>% 
       count()
     
     
     
     
     
     
     
     
     