# https://cran.r-project.org/web/packages/RISmed/RISmed.pdf

# 関係パッケージのインストール
if(!require("tidyverse")){install.packages("tidyverse")}; library(tidyverse)
if(!require("RISmed")){install.packages("RISmed")}; library(RISmed)
if(!require("magrittr")){install.packages("magrittr")}; library(magrittr)
if(!require("purrr")){install.packages("purrr")}; library(purrr)
if(!require("plotly")){install.packages("plotly")}; library(plotly)
if(!require("progress")){install.packages("progress")}; library(progress)
if(!require("reticulate")){install.packages("reticulate")}; library(reticulate)

# 検索語句の指定
search_word <- 'micro plastic'

# EUtilsSummary:米国国立生物工学情報センター(NCBI)の任意のデータベースに対するクエリ結果のサマリ情報を得るメソッド
# query: 検索語句
# type: https://www.ncbi.nlm.nih.gov/books/NBK25499/ を参照
# db: どのデータベースから検索するか
# retmax: 最大の取得件数
search_result <- search_word %>% EUtilsSummary(query = .,
                                                type = 'esearch',
                                                db = 'pubmed',
                                                retmax = 10000)
# 検索結果のサマリ
summary(search_result)


# PMIDを用いた論文情報の抽出
# PMIDはPubMed上で各論文にふられた一意なID
pubmed_ids <- QueryId(search_result)

# 論文情報の格納
# ちょっと時間かかるので気長に待つ
pubmed_extract_results <- EUtilsGet(pubmed_ids, type = 'efetch', db = 'pubmed')

# データフレームに格納
# pm_ids: PubMedID
# pub_year/month/date: 出版年月日
# article_titles: 論文のタイトル
# abstract_texts: アブスト
pm_ids <- pubmed_extract_results@PMID
pub_year <- pubmed_extract_results@YearPubDate
pub_month <- pubmed_extract_results@MonthPubDate
pub_date <- pubmed_extract_results@DayPubDate
article_titles <- pubmed_extract_results@ArticleTitle
abstract_texts <- pubmed_extract_results@AbstractText

result_df <- data.frame(PMID = pm_ids,
                        PublishedYear = pub_year,
                        PublishedMonth = pub_month,
                        PublishedDate = pub_date,
                        ArticleTitle = article_titles,
                        AbstractText = abstract_texts)

# CSVに変換
write_csv(result_df, 'result.csv')
