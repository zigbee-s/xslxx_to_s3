import csv
import sqlite3

# connect to the database
with sqlite3.connect('mydatabase.db') as conn:
    # set up a cursor object
    cursor = conn.cursor()

    # create a new table
    cursor.execute('''CREATE TABLE IF NOT EXISTS t
                     (Instances TEXT, Current_Status TEXT, Outages INT, Downtime INT,
                      Uptime INT, Total_Time INT, Availability FLOAT, Tags TEXT)''')

    # add columns to the table
    cursor.execute("PRAGMA table_info(t)")
    table_info = cursor.fetchall()
    column_names = [column[1] for column in table_info]

    if 'month_year' not in column_names:
        cursor.execute('ALTER TABLE t ADD COLUMN month_year TEXT')
    if 'vendor' not in column_names:
        cursor.execute('ALTER TABLE t ADD COLUMN vendor TEXT')

    # import CSV file into the table
    with open('test-flat.csv') as f:
        reader = csv.DictReader(f)
        for row in reader:
            instances = row['Instances']
            current_status = row['Current_Status']
            outages = row['Outages']
            downtime = row['Downtime']
            uptime = row['Uptime']
            total_time = row['Total_Time']
            availability = row['Availability']
            tags = row['Tags']

            # insert the extracted fields into the database table
            cursor.execute('INSERT INTO t (Instances, Current_Status, Outages, Downtime, Uptime, Total_Time, Availability, Tags) VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
                        (instances, current_status, outages, downtime, uptime, total_time, availability, tags))

    # update values in the table
    cursor.execute("UPDATE t SET month_year = '04-2023', vendor = 'aws'")

    # select data from the table and save to a CSV file
    with open('aws_availability.csv', 'w') as f:
        cursor.execute("SELECT Instances, Current_Status, Outages, Downtime, Uptime, Total_Time, Availability, Tags, month_year, vendor FROM t;")
        f.write(','.join([col[0] for col in cursor.description]) + '\n')
        for row in cursor.fetchall():
            f.write(','.join(map(str, row)) + '\n')
