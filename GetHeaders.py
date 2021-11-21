# import library
import requests
import time
from bs4 import BeautifulSoup
from pandas import read_sql
import numpy as np

# conn to database
from connDataBase.ConnLocalDatabase import cursor, cnxn

# name table in database
name_table = 'TAB_HEADLINES_MEDIA'

# define csv path
path_csv = 'C:/Users/doria/PycharmProjects/pythonProject/CSV_FILE/headlines.csv'

# definition of tags TVP


def get_headers(tag, url, el_soup_1, el_soup_2):
    # content from website -> TVP
    page = requests.get(url, allow_redirects=True)
    soup = BeautifulSoup(page.content, 'html.parser')

    titles = soup.findAll(tag, {el_soup_1: el_soup_2})

    fin_tab = []
    for word in titles:
        word = str(word)
        start_word = word.find(">")
        word = word[start_word + 1:len(word)]
        end_word = word.find("<")
        word = word[0:end_word]
        # problems with ' in database
        word = word.replace("'", "")
        fin_tab.append(word.strip())

    return fin_tab


tag_TVP_1 = get_headers('h3', 'https://www.tvp.info/', 'class', 'news__title')
tag_TVP_2 = get_headers('h2', 'https://www.tvp.info/', 'class', 'news__title')

tag_TVP = tag_TVP_1 + tag_TVP_2

tag_ONET = get_headers('span', 'https://www.onet.pl/', 'class', 'title')

# check exist of the table, if not create one

db_cmd = "select count(*) as count_tables from sys.tables where upper(name) = '" + name_table + "'"
res = cursor.execute(db_cmd)
result = cursor.fetchone()

if result[0] == 0:
    db_cmd = "create table " + name_table + "(" \
                                            "id int identity(1,1) primary key," \
                                            "TV_station varchar(20)," \
                                            "Datetime_header datetime not null," \
                                            "Header nvarchar(max));"
    cursor.execute(db_cmd)
    cursor.commit()

# if headline exists in table then delete him -> no duplicates on table

tag_all = ''

for i in tag_ONET:
    tag_all = tag_all + "'" + i + "'" + ','

for i in tag_TVP:
    tag_all = tag_all + "'" + i + "'" + ','

# delete last semicolon on string
tag_all = tag_all[0:len(tag_all) - 1]

db_cmd = "delete from " + name_table + " where upper(Header) in (" + tag_all.upper() + ")"

cursor.execute(db_cmd)
cursor.commit()

# insert headlines to table


def insert_headlines(tv_station, tv_station_name, act_date):
    try:
        for LIST in tv_station:
            sql = "insert into " + name_table + "(TV_station, Datetime_header, Header) VALUES" \
                                                "('" + tv_station_name + "','" + str(act_date) + "'," + "'" + LIST \
                                                + "')"
            cursor.execute(sql)
            cursor.commit()

    except (RuntimeError, TypeError, NameError):

        return 1

    return 0


insert_headlines(tag_TVP, 'TVP', time.strftime('%Y-%m-%d %H:%M:%S'))
insert_headlines(tag_ONET, 'ONET', time.strftime('%Y-%m-%d %H:%M:%S'))

db_cmd = "select * from " + name_table

headlines_df = read_sql(db_cmd, cnxn)

# export headlines to CSV
headlines_df_num = headlines_df.to_numpy()
np.savetxt(path_csv, headlines_df_num, fmt='%s', delimiter=';', encoding='utf-8-sig')

print('Script end task')
