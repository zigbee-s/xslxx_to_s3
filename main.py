import subprocess

# define the PowerShell script file path
ps_file_path = "x.ps1"

# define the PowerShell command to execute the script
ps_command = f"powershell.exe -file {ps_file_path}"

# run the PowerShell command and capture the output
process = subprocess.Popen(ps_command, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
stdout, stderr = process.communicate()

# print the output
print(stdout.decode())
