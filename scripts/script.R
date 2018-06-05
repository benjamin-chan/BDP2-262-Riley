setwd("C:/Users/chanb/Box Sync/Share/BDP2-262 Riley")

library(checkpoint)
checkpoint("2018-04-01", use.knitr = TRUE)

Sys.time0 <- Sys.time()

# sink(file.path("output", "script.log"))
files <- c("header.yaml",
           "preamble.Rmd",
           "importData.Rmd")
f <- file("master.Rmd", open = "w")
for (i in 1:length(files)) {
    x <- readLines(file.path("scripts", files[i]))
    writeLines(x, f)
    writeLines("\n\n", f)
}
close(f)
library(knitr)
library(rmarkdown)
opts_chunk$set(echo = FALSE, fig.path = "figures/", dpi = 300)
knit("master.Rmd", output = "docs/BDP2-262_Riley.md")
# pandoc("docs/BDP2-262_Riley.md", format = "docx")
# system("pandoc --template=GitHub.html5 --self-contained docs/BDP2-262_Riley.md -o docs/BDP2-262_Riley.html")
file.remove("master.Rmd")
# sink()

sink("output/session.log")
list(completionDateTime = Sys.time(),
     executionTime = Sys.time() - Sys.time0,
     sessionInfo = sessionInfo())
sink()
