# Load Required Libraries
library(dplyr)
library(ggplot2)
library(tidyr)
library(lubridate)
library(readr)

# Load Dataset
data <- read_csv("E-commerce Dataset.csv")

# View first few rows
head(data)

# Structure
str(data)

# Summary statistics
summary(data)

# Check dimensions
dim(data)

# Column names
colnames(data)

# Remove rows with NA values
data_clean <- na.omit(data)

# Check new dimensions
dim(data_clean)

# Check duplicates
sum(duplicated(data_clean))

data_clean <- data_clean %>%
  mutate(Total_Spending = Sales * Quantity)

head(data_clean)

customer_data <- data_clean %>%
  group_by(Customer_Id) %>%
  summarise(
    Total_Orders = n(),
    Total_Quantity = sum(Quantity),
    Total_Revenue = sum(Total_Spending),
    Avg_Discount = mean(Discount),
    Avg_Profit = mean(Profit),
    Avg_Shipping = mean(Shipping_Cost)
  )

head(customer_data)
dim(customer_data)

# Find most recent date in dataset
max_date <- max(data_clean$Order_Date)

# Add Recency (days since last purchase)
recency_data <- data_clean %>%
  group_by(Customer_Id) %>%
  summarise(
    Last_Purchase = max(Order_Date)
  ) %>%
  mutate(
    Recency = as.numeric(max_date - Last_Purchase)
  ) %>%
  select(Customer_Id, Recency)

# Merge with customer_data
customer_data <- left_join(customer_data, recency_data, by = "Customer_Id")

head(customer_data)

# Keep copy with ID
customer_final <- customer_data

# Remove Customer_Id for clustering dataset
customer_model <- customer_data %>%
  select(-Customer_Id)

head(customer_model)

summary(customer_model)

write.csv(customer_model, "customer_segmentation_clean.csv", row.names = FALSE)

write.csv(customer_final, "customer_segmentation_with_id.csv", row.names = FALSE)