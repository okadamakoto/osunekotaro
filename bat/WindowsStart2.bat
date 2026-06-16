REM @echo off
@echo on
@echo off
net use

net use \\192.168.32.20\D$ /d /Y
net use \\192.168.32.20\D$ azureadmin@00 /USER:SJS-11A126\azureadmin

net use \\192.168.32.188\C$ /d /Y
net use \\192.168.32.188\C$ azureadmin@00 /USER:SJS-11A126\azureadmin

net use \\10.20.18.231\p05_system_ikou_PJ /d /Y
net use \\10.20.18.231\p05_system_ikou_PJ okada-m300 /USER:SJS-11A126\okada-m3

net use B: /d /Y
REM net use B: "\\10.57.64.238\jimusys12\ドキュメント" sys1234 /USER:.\sys12
net use B: \\10.57.64.240\jimusys12\ドキュメント k6AD4VpdN3 /USER:SJS-11A126\okada-m3

REM net use K: /d /Y
REM net use K: \\10.59.68.212\jikijimu alsok@00 /USER:SJS-11A126\okada-m3

net use R: /d /Y
net use R: \\192.168.32.20\c$\inetpub\logs\LogFiles\W3SVC2 azureadmin@00 /USER:SJS-11A126\azureadmin

net use V: /d /Y
net use V: \\10.57.64.240\共通 k6AD4VpdN3 /USER:SJS-11A126\okada-m3

net use Y: /d /Y
net use Y: \\10.57.64.232\project okada-m300 /USER:SJS-11A126\okada-m3

net use \\10.16.113.234\開発部門共有 /d /Y
net use \\10.16.113.234\開発部門共有 gnkk@7606 /USER:SJS-11A126\KAIKI

REM ネットワークドライブの切断
net use \\10.16.113.47\a630技術教育 /d /Y

REM ネットワークドライブの接続
net use \\10.16.113.47\a630技術教育 bd1fcA /USER:SJS-11A126\okada-m3

net use \\10.16.113.51\n704採用 /d /Y
net use \\10.16.113.51\n704採用 bd1fcA /USER:SJS-11A126\okada-m3


net use
pause

REM Edgeで特定のURLを開く

REM Outlookメールを開く
start "" "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe" "https://outlook.office.com/mail"
timeout /t 1 >nul

REM Edgeで特定のURLを開く
start "" "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe" "https://outlook.cloud.microsoft/mail/gikyou@alsok.co.jp/inbox/id/AAkALgAAAAAAHYQDEapmEc2byACqAC%2FEWg0AqNbk2BjKYUWNKJurA3OnGwAKkfaAUAAA"
timeout /t 1 >nul

REM Edgeで特定のURLを開く
start "" "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe" "https://forms.office.com/Pages/ResponsePage.aspx?id=bk2zv1m1IkqI6pIkPy6r0rJ9C-zce-JKl7VHS7D0AbBUMjE3UktJWldCQjhMVlQ4NVU4TTAyVUlLTi4u"
timeout /t 1 >nul

REM Edgeで特定のURLを開く
start "" "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe" "https://forms.office.com/Pages/DesignPageV2.aspx?prevorigin=shell&origin=NeoPortalPage&subpage=design&id=bk2zv1m1IkqI6pIkPy6r0rJ9C-zce-JKl7VHS7D0AbBURFlHRU5EWTZSQjZFN0I1U0RCMDBSV0hZMC4u"
timeout /t 1 >nul

REM Edgeで特定のURLを開く
start "" "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe" "https://alsok.smartdb.jp/hibiki/smartdb/dashboard"
timeout /t 1 >nul

REM Edgeで特定のURLを開く
start "" "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe" "https://job.techoffer.jp"
timeout /t 1 >nul

REM Edgeで特定のURLを開く
start "" "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe" "https://outlook.office.com/calendar/view/week"
timeout /t 1 >nul

REM Edgeで特定のURLを開く
start "" "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe" "https://alsok.insuite.jp/"
timeout /t 1 >nul

REM Edgeで特定のURLを開く
start "" "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe" "https://www.ap-siken.com/"
timeout /t 1 >nul

REM Edgeで特定のURLを開く
start "" "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe" "https://www.pm-siken.com/"
timeout /t 1 >nul

REM Edgeで特定のURLを開く
start "" "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe" "https://member.studying.jp/?_gl=1*x82sho*_gclma_au*MTAzOTIzNTk5LjE3NDEyMTc5NDI.*_gcl_au*MjExNDc0OTM2MC4xNzQxMjE3OTQ0*_ga*MTIyMTgzNTE0MS4xNzE1OTM2MDc2*_ga_JJCYJNN604*MTc0MTY3MjI5Ni4xMjAuMC4xNzQxNjcyMjk2LjYwLjAuMA..*_ga_ENCL4K56EY*MTc0MTY3MjI5Ni41OC4wLjE3NDE2NzIyOTYuNjAuMC4w&_bdsid=21rC8p.p0zO2kE.1741672305476.1741672308&_bd_prev_page=https%3A%2F%2Fstudying.jp%2F&_bdrpf=1"
timeout /t 1 >nul

REM Edgeで特定のURLを開く
start "" "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe" "https://forms.office.com/Pages/DesignPageV2.aspx?origin=shell"
timeout /t 1 >nul

REM Edgeで特定のURLを開く
REM start "" "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe" "https://alsok.phoneappli.net/front/home"
REM timeout /t 1 >nul

REM Edgeで特定のURLを開く
start "" "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe" "https://member.studying.jp/note/"
timeout /t 1 >nul

REM Edgeで特定のURLを開く
REM start "" "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe" "https://job.techoffer.jp/offer/keyword/sending-list?ab=AB01&ab=AB02&lastAccessDate=3days&isInterested=false&isHot=false&isAct=false&isHome=false&j=JO023&j=JO024&dp=PF00&dp=PF13&shouldExcludeForeignStudent=true&sort=lastAccessDateTime&orderBy=DESC"
REM timeout /t 1 >nul

REM Edgeで特定のURLを開く
REM start "" "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe" "https://job.techoffer.jp/offer/personal/sending-list?ab=AB01&ab=AB02&lastAccessDate=3days&isInterested=false&isHot=false&isAct=false&isHome=false&j=JO023&j=JO024&dp=PF00&dp=PF13&shouldExcludeForeignStudent=true&sort=lastAccessDateTime&orderBy=DESC"
REM timeout /t 1 >nul

REM Edgeで特定のURLを開く
REM start "" "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe" "https://www.webex.com/ja/index.html"
start "" "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe" "https://web.webex.com/sign-in"
timeout /t 1 >nul

REM Edgeで特定のURLを開く
REM start "" "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe" "edge://favorites/?id=28"
REM timeout /t 1 >nul


REM Chromeで別のURLを開く
REM start chrome https://outlook.office.com/mail/
REM timeout /t 1 >nul

REM 新しいTeamsアプリを起動
start "" "C:\Users\774652\AppData\Local\Microsoft\WindowsApps\ms-teams.exe"
timeout /t 1 >nul

powershell -ExecutionPolicy Bypass -File "C:\okada\PowerShellScript\Time3.ps1"
pause

