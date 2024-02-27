j<-7

url.winning<-"https://www.ncaa.com/stats/volleyball-women/d1/current/team/51"
url.hitting<-"https://www.ncaa.com/stats/volleyball-women/d1/current/team/45"

for (i in 1:j){
  if (i==1){
    webpage.hitting<-read_html(url.hitting)
    Hitting_html<-html_nodes(webpage.hitting,'td')
    Hitting<-html_text(Hitting_html)
    
    webpage.winning<-read_html(url.winning)
    Winning_html<-html_nodes(webpage.winning,'td')
    Winning<-html_text(Winning_html)
  }else{
    url.hitting.new<-paste(url.hitting,"/p",as.character(i),sep="")
    webpage.hitting<-read_html(url.hitting.new)
    Hitting_html<-html_nodes(webpage.hitting,'td')
    Hitting<-c(Hitting,html_text(Hitting_html))
    
    url.winning.new<-paste(url.winning,"/p",as.character(i),sep="")
    webpage.winning<-read_html(url.winning.new)
    Winning_html<-html_nodes(webpage.winning,'td')
    Winning<-c(Winning,html_text(Winning_html))
  }
}

Hitting<-t(matrix(Hitting,nrow=7))
Hitting<-as.data.frame(Hitting)
Hitting<-Hitting[,-c(1)]
names(Hitting)<-c("Team","S","Kills","Errors","Total.Attacks","Hitting.Pct.")
Hitting$S<-as.numeric(Hitting$S)
Hitting$Kills<-as.numeric(Hitting$Kills)
Hitting$Errors<-as.numeric(Hitting$Errors)
Hitting$Total.Attacks<-as.numeric(Hitting$Total.Attacks)
Hitting$Hitting.Pct.<-as.numeric(Hitting$Hitting.Pct.)
Hitting$X<-Hitting$Kills/Hitting$Total.Attacks
Hitting$Y<-Hitting$Errors/Hitting$Total.Attacks

Winning<-t(matrix(Winning,nrow=5))
Winning<-as.data.frame(Winning)
Winning<-Winning[,-c(1)]
names(Winning)<-c("Team","Wins","Losses","Win.Pct")
Winning$Wins<-as.numeric(Winning$Wins)
Winning$Losses<-as.numeric(Winning$Losses)
Winning$Win.Pct<-as.numeric(Winning$Win.Pct)

D1.Hitting.Winning<-merge(Hitting,Winning, by="Team")
