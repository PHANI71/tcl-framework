proc simulateThreadLock {args} {
     #-
     #- This procedure is used to simulate the thread lock condition given a specfic scenario
     #-

     parseArgs args \
               [list \
               [list fgwNum                "optional"   "numeric"    "0"        "Defines the position of fgw in the testbed file"] \
               [list process               "mandatory"   "string"     "__UN_DEFINED__"        "Defines the process for simulating the thread lock"] \
               [list threadName            "mandatory"  "string"    "__UN_DEFINED__"         "Defines the thread name in a process for simulating the thread lock"] \
               [list threadID              "optional"   "string"     "__UN_DEFINED__"        "Defines the TID for simulating thread mon"] \
               [list noOfThreads           "optional"   "numeric"    "1"        "Defines the number of threads that would be blocked"] \
               [list Bono                  "optional"   "string"     "active"                "Defines the bono on which the thread needs to be blocked"] \
               [list opCheck               "optional"   "string"     "SWO"                   "Defines whether SWO or restart will happen"] \
               ]

     set threadHBTime 20
     variable gdbHaltVal

     if {$Bono == "active"} {
	     set dut  [getActiveBonoIp $fgwNum "update"]
	     set activeBONO $dut
             set standbyBONO  [getPeerBonoIp $activeBONO]
     } else {
	     set activeBONO     [getActiveBonoIp $fgwNum "update"]
             set dut            [getPeerBonoIp $activeBONO]
	     set standbyBONO $dut
     }

     set processID [getProcId -Bono $Bono -process $process]
     if {$processID == -1} {
        print -fail "Failed to retreive Process ID"
        return -1
     } else {
	set threadID [getThreadId -Bono $Bono -process $process -procID $processID -threadName $threadName]
	if {$threadID == -1} {
        print -fail "Failed to retreive Thread ID"
	}
     }

     set cmd "ls /var/core"
     set result [execCommandSU -dut $dut -command $cmd ]
     print -debug "The value after checking cores is:$result"
     if {[regexp -nocase "core" $result]} {
        print -pass "No Existing Cores on HeNBGW"
     } else {
        print -fail "Existing Cores on HeNBGW"
     }

     set cmd "gdb attach $threadID"
     #set sessClose "ThreadMon"
     set gdbHalt $gdbHaltVal
     set result [execCommandSU -dut $dut -command $cmd -gdbHalt $gdbHalt]
     print -debug "The value after executing GDB:$result"
     if {$result != 0} {
	print -pass "The Execution of GDB to halt the thread $threadID is successful"
     } else {
	print -fail "The Execution of GDB to halt the thread $threadID failed"
	set flag 1
     }

     #print -debug "the time to halt is :$threadHBTime"
     #halt $threadHBTime

     set cmd "\n"
     set result [execCommandSU -dut $dut -command $cmd ]
     print -debug "The value after executing quit:$result"
     if {$result != 0} {
        print -pass "The Execution of quitting GDB to halt the thread $threadID is successful"
     } else {
        print -fail "The Execution of quitting GDB to halt the thread $threadID failed"
        #set flag 1
     }

     print -dbg "Check for any process restart or crash on $dut"
     set result [verifyProcesses -dutIp $dut -operation "verify"]
     if {$result == 0} {
	print -fail "No Process crash happened after Thread Lock. Exiting the test Case......"
	return -1
     } else {
	print -pass "The Process $process crashed on Bono."
     }

     set cmd "ls /var/core"
     set result [execCommandSU -dut $dut -command $cmd ]
     print -debug "The value after listing core files:$result"
     if {[regexp -nocase "core" $result]} {
	print -pass "The Process Crash dumped a Core on HeNBGW.The Core is:\n $result"
	set cmd "rm -f /var/core/*"
        set result [execCommandSU -dut $dut -command $cmd ]
        set cmd "ls /var/core"
        set result [execCommandSU -dut $dut -command $cmd ]
 	if {![regexp -nocase "core" $result]} {
            print -fail "Unable to remove the core files from the HeNBGW."
	} else {
	    print -pass "Successfully removed all the Core files from the HeNBGW."
	}
     } else {
 	print -fail "No Core Dump found on HeNBGW. Exiting the test Case......"
	set flag 1
     }

     set NewactiveBONO  [getActiveBonoIp $fgwNum "update"]
     set NewstandbyBONO  [getPeerBonoIp $NewactiveBONO]

     if {$opCheck == "SWO"} {
        if {($NewactiveBONO == $standbyBONO) && ($NewstandbyBONO == $activeBONO)} {
       	    print -pass "The Switchover of the Bono has occurred"
        } else {
            print -fail "No switchover of the Bono occurred. Hence, Exiting the script......"
	    return -1
        }
     } elseif {$opCheck =="RES"} {
        if {($NewactiveBONO == $activeBONO) && ($NewstandbyBONO == $standbyBONO)} {
  	    print -pass "The Restart of the Bono has occurred"
        } else {
            print -fail "Unexpected swithover of the Bono occurred. Hence, Exiting the script......"
	    return -1
        }
     } else {
        print -fail "Improper value for operation give. Exiting the script....."
	return -1
     }

     halt 10
     return 0
}

proc getProcId {args} {

     #-
     #- This procedure is used to verify the process is running or not.
     #- And if it is, then return the proc id.

     parseArgs args \
               [list \
               [list fgwNum                "optional"   "numeric"    "0"        "Defines the position of fgw in the testbed file"] \
               [list process               "mandatory"   "string"     "__UN_DEFINED__"        "Defines the process for simulating the thread lock"] \
               [list threadID              "optional"  "string"     "__UN_DEFINED__"        "Defines the TID for simulating thread mon"] \
               [list noOfThreads           "optional"   "numeric"    "1"        "Defines the number of threads that would be blocked"] \
               [list Bono                  "optional"   "string"     "active"                "Defines the bono on which the thread needs to be blocked"] \
               ]

     if {$Bono == "active"} {
	     set fgwIp  [getActiveBonoIp $fgwNum "update"] 
     } else {
	     set activeBONO     [getActiveBonoIp $fgwNum "update"]
             set fgwIp          [getPeerBonoIp $activeBONO]
     }

	set result [verifyProcessOnHeNBGW -boardIp $fgwIp -expProcess $process]
	if {$result == 0} {
	     print -pass "The expected process is running on the GW"
	} else {
	     print -fail "The expected process is not running on the GW"
	     return -1
	}

	#To get all the pid from the bono
	set myProcs [showProcess -ipaddr $fgwIp -operation "returnResult"]
	print -debug "The list of process are :$myProcs"
	array set arr_proc_pid [processShowProcOutput $myProcs]
	parray arr_proc_pid

	#Following is the sample output of cmd "parray arr_proc_info"
	#arr_proc_info(DS,pid)            = 30167
	#arr_proc_info(DS,uptime)         = 1424504513
	#arr_proc_info(FGWMon,pid)        = 28997
	#arr_proc_info(FGWMon,uptime)     = 1424504545
	#arr_proc_info(HST,pid)           = 30107
	#arr_proc_info(HST,uptime)        = 1424504513
	#arr_proc_info(HeNBGrp-1,pid)     = 30065
	#arr_proc_info(HeNBGrp-1,uptime)  = 1424504513
	#arr_proc_info(HeNBGrp-2,pid)     = 30070
	#arr_proc_info(HeNBGrp-2,uptime)  = 1424504513
	#arr_proc_info(HeNBGrp-3,pid)     = 30075
	#arr_proc_info(HeNBGrp-3,uptime)  = 1424504513
	#arr_proc_info(HeNBGrp-4,pid)     = 30085
	#arr_proc_info(HeNBGrp-4,uptime)  = 1424504513
	#arr_proc_info(HeNBGrp-5,pid)     = 30097
	#arr_proc_info(HeNBGrp-5,uptime)  = 1424504513
	#arr_proc_info(MST-1,pid)         = 30118
	#arr_proc_info(MST-1,uptime)      = 1424504513
	#arr_proc_info(MST-2,pid)         = 30130
	#arr_proc_info(MST-2,uptime)      = 1424504513
	#arr_proc_info(MST-3,pid)         = 30140
	#arr_proc_info(MST-3,uptime)      = 1424504513
	#arr_proc_info(MST-4,pid)         = 30149
	#arr_proc_info(MST-4,uptime)      = 1424504513
	#arr_proc_info(MST-5,pid)         = 30158
	#arr_proc_info(MST-5,uptime)      = 1424504513
	#arr_proc_info(OAMServer,pid)     = 29054
	#arr_proc_info(OAMServer,uptime)  = 1424504545
	#arr_proc_info(StatsD,pid)        = 30174
	#arr_proc_info(StatsD,uptime)     = 1424504513
	#arr_proc_info(gsnmpProxy,pid)    = 30061
	#arr_proc_info(gsnmpProxy,uptime) = 1424504513
	#arr_proc_info(named,pid)         = 30327
	#arr_proc_info(named,uptime)      = 1424504513
	#arr_proc_info(shelfoam,pid)      = 29057
	#arr_proc_info(shelfoam,uptime)   = 1424504545
	#arr_proc_info(snmpd,pid)         = 30436
	#arr_proc_info(snmpd,uptime)      = 1424504512

	set procid $arr_proc_pid($process,pid)
	print -info "The Process id of the concerned process is:$procid"
	return $procid
}

proc getThreadId {args} {

     #-
     #- This procedure is used to get the thread id of a particular thread in a particular process.
     #- 

     parseArgs args \
               [list \
               [list fgwNum                "optional"   "numeric"    "0"        "Defines the position of fgw in the testbed file"] \
               [list process               "optional"   "string"     "__UN_DEFINED__"        "Defines the process for simulating the thread lock"] \
               [list threadName            "mandatory"  "string"    "__UN_DEFINED__"         "Defines the thread name in a process for simulating the thread lock"] \
               [list threadID              "optional"   "string"     "__UN_DEFINED__"        "Defines the TID for simulating thread mon"] \
               [list procID                "mandatory"  "string"     "__UN_DEFINED__"        "Defines the PID for simulating thread mon"] \
               [list noOfThreads           "optional"   "numeric"    "1"        "Defines the number of threads that would be blocked"] \
               [list Bono                  "optional"   "string"     "active"                "Defines the bono on which the thread needs to be blocked"] \
               ]

     if {$Bono == "active"} {
	     set dut  [getActiveBonoIp $fgwNum "update"] 
     } else {
	     set activeBONO     [getActiveBonoIp $fgwNum "update"]
             set dut       [getPeerBonoIp $activeBONO]
     }

     print -info "The process Id passed is :$procID"
     set cmd "grep -r -s Name /proc/$procID/task/"
     set threadDet [execLinuxCommand -hostMgIp $dut -userName "admin" -password "scAn\$9365" -command $cmd]
     if {[regexp "ERROR" $threadDet]} {
	print -fail "The execution of cmd:$cmd failed"
        return -1
     } else {
	print -info "The Threads of $process are:\n$threadDet"
	set indexofThread [lsearch -exact -nocase $threadDet $threadName]
	set tid [lindex $threadDet [expr "$indexofThread" - 1]]
	set tid [string trim $tid "/:"]
	set tid [split $tid "/"]
	set tid [lindex $tid 3]
     }
     return $tid
}
