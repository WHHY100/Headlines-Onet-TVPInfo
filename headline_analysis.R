# library
library("stringr")
library("glue")

#paths
pathImportCsv = "C:/Users/doria/PycharmProjects/pythonProject/CSV_FILE/headlines.csv"
pathExportImg = "C:/Users/doria/PycharmProjects/pythonProject/img"

# read CSV
headlines <- read.csv(pathImportCsv,
                      encoding = "UTF-8", 
                      header = FALSE, 
                      stringsAsFactors = FALSE,
                      sep = ';',
                      quote = "")

# change title of cols in df
colnames(headlines) <- c('ID', 'SOURCE', 'DATETIME', 'TITLE')

# create function to get filter data
select_rows <- function(word){
  dataframe <-headlines[grep(word, toupper(headlines$TITLE)), ]
  return(dataframe)
}

# get lines
rows_kaczynski <- select_rows('KACZYŃSKI')
rows_tusk <- select_rows('TUSK')
rows_inflation <- select_rows('INFLACJ')
rows_morawiecki <- select_rows('MORAWIECKI')
rows_government <- select_rows('RZĄD')
rows_aborcja <- select_rows('ABORCJ')
rows_TVN <- select_rows('TVN')
rows_TVP <- select_rows('TVP')
rows_imigr <- select_rows('IMIGRAN')

# count of titles by source
count_ONET_rows = nrow(headlines[which(headlines$SOURCE=='ONET'),])
count_TVP_rows = nrow(headlines[which(headlines$SOURCE=='TVP'),])

# % specific words in total per group
summary_percent <- function(name_station, total_station)
{
  values = c(
    paste(name_station, '%', sep=' '),
    round((nrow(rows_kaczynski[which(rows_kaczynski$SOURCE==name_station),])/total_station)*100, 2),
    round((nrow(rows_tusk[which(rows_tusk$SOURCE==name_station),])/total_station)*100, 2),
    round((nrow(rows_inflation[which(rows_inflation$SOURCE==name_station),])/total_station)*100, 2),
    round((nrow(rows_morawiecki[which(rows_morawiecki$SOURCE==name_station),])/total_station)*100, 2),
    round((nrow(rows_government[which(rows_government$SOURCE==name_station),])/total_station)*100, 2),
    round((nrow(rows_aborcja[which(rows_aborcja$SOURCE==name_station),])/total_station)*100, 2),
    round((nrow(rows_TVN[which(rows_TVN$SOURCE==name_station),])/total_station)*100, 2),
    round((nrow(rows_TVP[which(rows_TVP$SOURCE==name_station),])/total_station)*100, 2),
    round((nrow(rows_imigr[which(rows_imigr$SOURCE==name_station),])/total_station)*100, 2)
  )
  
  return(values)
}

# count specific words in total per group
summary_count <- function(name_station, total_station)
{
  values = c(
    paste(name_station, 'liczba tytulow', sep=' '),
    nrow(rows_kaczynski[which(rows_kaczynski$SOURCE==name_station),]),
    nrow(rows_tusk[which(rows_tusk$SOURCE==name_station),]),
    nrow(rows_inflation[which(rows_inflation$SOURCE==name_station),]),
    nrow(rows_morawiecki[which(rows_morawiecki$SOURCE==name_station),]),
    nrow(rows_government[which(rows_government$SOURCE==name_station),]),
    nrow(rows_aborcja[which(rows_aborcja$SOURCE==name_station),]),
    nrow(rows_TVN[which(rows_TVN$SOURCE==name_station),]),
    nrow(rows_TVP[which(rows_TVP$SOURCE==name_station),]),
    nrow(rows_imigr[which(rows_imigr$SOURCE==name_station),])
  )
  
  return(values)
}

summary_onet <- summary_percent('ONET', count_ONET_rows)
summary_TVP <- summary_percent('TVP', count_TVP_rows)
summary_count_ONET <- summary_count('ONET', count_TVP_rows)
summary_count_TVP <- summary_count('TVP', count_TVP_rows)
df_colnames <- c(
  'NAZWA STACJI',
  'SLOWO: KACZYNSKI',
  'SLOWO: TUSK',
  'SLOWO: INFLACJA',
  'SLOWO: MORAWIECKI',
  'SLOWO: RZAD',
  'SLOWO: ABORCJA',
  'SLOWO: TVN',
  'SLOWO: TVP',
  'SLOWO: IMIGRANCI'
)

stats <- rbind.data.frame(summary_onet, summary_TVP, summary_count_ONET, summary_count_TVP)
colnames(stats) <- df_colnames

# get percent rows from df stats

stats_ONET_PERCENT <- stats[grep('ONET %', toupper(stats$`NAZWA STACJI`)), ]
stats_TVP_PERCENT <- stats[grep('TVP %', toupper(stats$`NAZWA STACJI`)), ]

# put df together

stats_PERCENT <- rbind(stats_ONET_PERCENT, stats_TVP_PERCENT)

# remove '%' from data names
stats_PERCENT[1,1] <- str_replace(stats_PERCENT[1,1], '%', '')
stats_PERCENT[2,1] <- str_replace(stats_PERCENT[2,1], '%', '')

# add colnames with no spaces
stats_colnames <- colnames(stats_PERCENT)
stats_colnames <- str_replace(stats_colnames, 'SLOWO: ', '')
stats_colnames <- str_replace(stats_colnames, ' ', '_')
colnames(stats_PERCENT) <- stats_colnames

# plots function
draw_plot <- function(i)
{
  word_vect <- colnames(stats_PERCENT)
  
  barplot(as.numeric(stats_PERCENT[,i]), 
            height = as.numeric(stats_PERCENT[,i]),
            width = c(1,1),
            space = 0.1,
            names = stats_PERCENT$`NAZWA_STACJI`,
            main=glue('Artykuly ze slowem ', word_vect[i], ' (w procentach)'),
            col = c('#000066', '#660066'),
            col.main = '#000033',
            legend=FALSE)
}

# draw all plots

draw_vect <- c(2:ncol(stats_PERCENT))
i = 1;
for (j in draw_vect){
  pathExp = str_replace_all(paste(pathExportImg,"/plot_", i, ".jpg"), " ", "")
  draw_plot(j)
  jpeg(file=pathExp, width=600, height=350)
  draw_plot(j)
  dev.off()
  i = i + 1;
}

View(stats)