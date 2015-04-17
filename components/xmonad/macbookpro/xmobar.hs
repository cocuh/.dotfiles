Config { font = "-misc-fixed-*-*-*-*-13-*-*-*-*-*-*-*"
       , borderColor = "black"
       , border = TopB
       , bgColor = "black"
       , fgColor = "grey"
       , position = Top
       , lowerOnStart = True
       , persistent = False
       , commands = [ Run Weather "EGPF" ["-t","<station>: <tempC>C","-L","18","-H","25","--normal","green","--high","red","--low","lightblue"] 36000
                    , Run Network "enp0s20u2" ["-L","0","-H","32","--normal","green","--high","red"] 10
                    , Run Network "wlp3s0" ["-L","0","-H","32","--normal","green","--high","red"] 10
                    , Run BatteryP ["BAT0"] ["-t","Batt:<acstatus><left>% <timeleft>","-L","30","-H","80","-p","3","-l","red","-h","green","--","-O"," ","-o","+"] 60
                    , Run Cpu ["-L","3","-H","50","--normal","green","--high","red"] 10
                    , Run CpuFreq ["-t","<cpu0>","-L","0","-H","2","-n","white","-h","red"] 20
                    , Run Memory ["-t","Mem: <usedratio>%"] 10
					, Run Swap [] 10
                    , Run Com "uname" ["-s","-r"] "" 36000
        		    , Run Date "%a %b %_d %Y %H:%M:%S" "date" 10
                    ]
       , sepChar = "%"
       , alignSep = "}{"
       , template = "%cpu% | %memory% * %swap% | %wlp3s0% - %enp0s20u2% }{ <fc=#ee9a00>%date%</fc> | %battery% | Freq:%cpufreq% | %uname%"
       }
