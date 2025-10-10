library(dplyr)
library(readr)
library(chromote)
library(rvest)

# navigate to page
b <- ChromoteSession$new()
b$Page$navigate("https://eopacodeblue.org/superfund/")
Sys.sleep(5)

# get first table
html <- b$DOM$getDocument()
content <- b$DOM$getOuterHTML(html$root$nodeId)

page <- read_html(content$outerHTML)
table <- page |> 
  html_element("#footable_709") |> 
  html_table()

names(table) <- as.character(table[1, ])
table <- table[3:nrow(table), ]

# get number of table pages
page_buttons_selector <- "#footable_709 > tfoot > tr > td > div > ul"

page_buttons <- page |> 
  html_element(page_buttons_selector)

n_pages <- page_buttons |> 
  html_elements("li") |> 
  length() - 6

page_button_indinces <- seq(4, (4 + n_pages))

for (i in page_button_indinces) {
  next_page_selector <- paste0("#footable_709 > tfoot > tr > td > div > ul > li:nth-child(", i, ") > a")

  b$Runtime$evaluate(
    expression = paste0("document.querySelector('", next_page_selector, "').click();")
  )

  Sys.sleep(3)

  html <- b$DOM$getDocument()
  content <- b$DOM$getOuterHTML(html$root$nodeId)

  page <- read_html(content$outerHTML)
  cur_table <- page |> 
    html_element("#footable_709") |>
    html_table()
  
  names(cur_table) <- as.character(cur_table[1, ])
  cur_table <- cur_table[3:nrow(cur_table), ]

  table <- table |> 
    bind_rows(cur_table)
}

table <- table |> 
  distinct()

write_csv(table, "data/temp/letters_of_support.csv")
