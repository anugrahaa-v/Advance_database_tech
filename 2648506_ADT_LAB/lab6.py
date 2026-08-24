# Lab 6: Simulation of Timestamp Ordering (TO) Concurrency Control Algorithm using Python
# Business Domain: Online Shopping System
# NOTE: This lab's code is Python, not SQL (extracted exactly as it appears in the manual).

# Create the Data Item Class
class DataItem:
    def __init__(self, value):
        self.value = value
        self.read_ts = 0
        self.write_ts = 0

# Create Read Operation
def read_item(transaction_name, transaction_ts, data):


    print(f"{transaction_name} wants to READ Product_Stock")

    if transaction_ts < data.write_ts:
        print("Read Rejected")

    else:
        data.read_ts = max(data.read_ts, transaction_ts)

        print("Read Successful")
        print("Current Stock =", data.value)
        print("Read Timestamp =", data.read_ts)

# Create Write Operation
def write_item(transaction_name, transaction_ts, data, new_value):

    print(f"{transaction_name} wants to WRITE Product_Stock")

    if transaction_ts < data.read_ts or transaction_ts < data.write_ts:
        print("Write Rejected")

    else:
        data.value = new_value
        data.write_ts = transaction_ts

        print("Write Successful")
        print("Updated Stock =", data.value)
        print("Write Timestamp =", data.write_ts)

# Create the Data Item
product = DataItem(50)

print("Initial Data")
print("Stock =", product.value)
print("Read Timestamp =", product.read_ts)
print("Write Timestamp =", product.write_ts)

# Initial Data
# Stock = 50
# Read Timestamp = 0
# Write Timestamp = 0

# Create Transaction T1
T1_TS = 5

print("Transaction T1 Created")
print("Timestamp =", T1_TS)

# Transaction T1 Created
# Timestamp = 5

# Create Transaction T2
T2_TS = 10

print("Transaction T2 Created")
print("Timestamp =", T2_TS)

# Transaction T2 Created
# Timestamp = 10

# Perform Read Operation for T1
read_item("T1", T1_TS, product)

# --------------------------------
# T1 wants to READ Product_Stock
# Read Successful
# Current Stock = 50
# Read Timestamp = 5

# Perform Write Operation for T1
write_item("T1", T1_TS, product, 40)

# --------------------------------
# T1 wants to WRITE Product_Stock
# Write Successful
# Updated Stock = 40
# Write Timestamp = 5

# Perform Read Operation for T2
read_item("T2", T2_TS, product)

# --------------------------------
# T2 wants to READ Product_Stock
# Read Successful
# Current Stock = 40
# Read Timestamp = 10

# Perform Write Operation for T2
write_item("T2", T2_TS, product, 30)

# --------------------------------
# T2 wants to WRITE Product_Stock
# Write Successful
# Updated Stock = 30
# Write Timestamp = 10

# Display Final State
print("--------------------------------")
print("Final Data Item")
print("Stock =", product.value)
print("Read Timestamp =", product.read_ts)
print("Write Timestamp =", product.write_ts)

# --------------------------------
# Final Data Item
# Stock = 30
# Read Timestamp = 10
# Write Timestamp = 10

#Write the complete Python code to simulate the Timestamp Ordering (TO) Concurrency Control Algorithm for an Online Shopping System.
