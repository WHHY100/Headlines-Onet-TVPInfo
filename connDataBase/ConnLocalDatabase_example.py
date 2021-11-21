import pyodbc
server = ''
database = ''
username = ''
password = ''
cnxn = pyodbc.connect('DRIVER={ODBC Driver 17 for SQL Server};SERVER='+server+';DATABASE='+database+';UID='+username+
                      ';PWD='+ password)
cursor = cnxn.cursor()

print("Successfully connected to database")
