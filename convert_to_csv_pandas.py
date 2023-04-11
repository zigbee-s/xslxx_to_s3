import os
import pandas as pd

# Set the path of the folder containing the Excel files
raw_files_folder = 'raw_files'
csv_files_folder = 'csv_files'

# Loop through all Excel files in the folder
for file_name in os.listdir(raw_files_folder):
    if file_name.endswith('.xlsx'):
        # Load the Excel file into a pandas dataframe
        excel_path = os.path.join(raw_files_folder, file_name)
        df = pd.read_excel(excel_path)

        # Generate the path for the corresponding CSV file
        csv_path = os.path.join(csv_files_folder, os.path.splitext(file_name)[0] + '.csv')

        # Export the dataframe to a CSV file
        df.to_csv(csv_path, index=False)
