import os
import subprocess


# Convert raw xlxx files to csv files and add them to csv_files directory
# define the path to the sample_script.py file
script_path = "./convert_to_csv_pandas.py"

# run the script using the subprocess module
subprocess.run(["python", script_path])



# Run PowerShell script to convert csv files to flat csv, and add them to the raw_files/csv_files directory
# define the PowerShell script file path
ps_file_path = "x.ps1"

# get the path to the csv_files directory
csv_dir = "./csv_files"

# loop through all .csv files in the directory
for filename in os.listdir(csv_dir):
    if filename.endswith(".csv"):
        # define the path parameter for the current file
        path = os.path.join(csv_dir, filename)

        # define the PowerShell command to execute the script with the path parameter
        ps_command = f"powershell.exe -file {ps_file_path} -path {path}"

        # run the PowerShell command and capture the output
        process = subprocess.Popen(ps_command, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        stdout, stderr = process.communicate()

        # print the output for the current file
        print(f"Output for {filename}:")
        print(stdout.decode())
