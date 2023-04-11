import pandas as pd

# Load the Excel file into a pandas dataframe
df = pd.read_excel('data.xlsx')

# Export the dataframe to a CSV file
df.to_csv('data.csv', index=False)
