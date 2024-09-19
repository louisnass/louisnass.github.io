#-------------------------------------------------------------------------------
#
# Title: Sample of Selenium Scraping for Volleyball Statistics
#
#-------------------------------------------------------------------------------
#
# Description: We use Selenium to webdrive and convert JavaScript documents into
# readable HTML documents for data collection. We demonstrate a small example that 
# collects data from VolleyMetrics (which requires a login and password). Given a
# collection of teams, we can implement this methodology to expedite data collection
#
#-------------------------------------------------------------------------------

#Loading necessary libraries
library(RSelenium)
library(wdman)
library(netstat)
#Useing selenium to scrape data from Javascript sites
selenium()
selenium_object<-selenium(retcommand = TRUE,check = FALSE)
binman::list_versions("chromedriver")
remote_driver<-rsDriver(browser = "chrome", chromever = "116.0.5845.96", verbose = F, port = free_port())
remDr<-remote_driver$client
#Open webdriver
remDr$open()
#Go to the site
remDr$navigate("https://portal.volleymetrics.hudl.com/?utm_content=volleymetrics_primary&utm_source=www.hudl.com&utm_medium=login_dropdown&utm_campaign=platform_logins#/auth/login")
#Input user name and pasword information via XPATH              
username <- remDr$findElement(using = "xpath", value = '//*[@id="username"]')
username$sendKeysToElement(list("insertUsername here"))
password <-remDr$findElement(using = "xpath", value = '//*[(@id = "password")]')
password$sendKeysToElement(list("insertPassword here"))
login<-remDr$findElement(using = "xpath", value = "//button[text()='LOGIN']")
login$clickElement()


#Find interesting stats
stats<-remDr$findElement(using = "xpath", value = "/html/body/div[2]/div[2]/div/div/div/div[3]/div[1]/left-menu/div/div[1]/left-menu-button[5]/a/div/div[2]/span[text()='Stats']")

stats$clickElement()

#Input year of interest
year<-remDr$findElement(using = "xpath", value = "/html/body/div[2]/div[2]/div/div/div/div[3]/div[2]/div[1]/div/div[1]/vm-input-box[3]/div/div/input")
year$clearElement()
year$sendKeysToElement(list("2022"))
year$sendKeysToElement(list(key = "enter"))


#Find team input
team<-remDr$findElement(using = "xpath", value = "/html/body/div[2]/div[2]/div/div/div/div[3]/div[2]/div[1]/div/div[1]/vm-input-box[2]/div/div/input")
#Clear the box for input
team$sendKeysToElement(list("\uE03D", "a"))
team$sendKeysToElement(list(key = "backspace"))


#Input Texas
team$sendKeysToElement(list("Texas"))
team$sendKeysToElement(list(key = "enter"))

team$sendKeysToElement(list("\uE03D", "a"))
team$sendKeysToElement(list(key = "backspace"))

#Input Marquette
team$sendKeysToElement(list("Marquette"))
team$sendKeysToElement(list(key = "enter"))
#Let the site load before clicking again
Sys.sleep(3)


#Find the xpath with the information we care about
acePct<-remDr$findElement(using = "xpath", value = "/html/body/div[2]/div[2]/div/div/div/div[3]/div[2]/div[1]/div/stats-table/div/div[1]/div[2]/div[2]/div[3]/div[13]/span")

acePct$getElementText()

#Retreive information
serveErrorPct<-remDr$findElement(using = "xpath", value = "/html/body/div[2]/div[2]/div/div/div/div[3]/div[2]/div[1]/div/stats-table/div/div[1]/div[2]/div[2]/div[3]/div[15]/span")
serveErrorPct$getElementText()


remDr$quit()
#Same code in R as Python, given a year and team names we can
#exctract infromation from this site accordingly
