proc monitorSystemResourcesX {args} {
     #-
     #- Procedure to monitor the system resources on the system
     #-
     #- @return  -1 on failure, 0 on success
     #-
     
     global ARR_PROCESS_INFO
     
     set processList "DS MST HST HeNBGrp OAM"
     set bladeList   ""
     parseArgs args \
               [list \
               [list fgwNum           "optional"  "numeric"     "0"             "The fwg instance" ] \
               [list repeat           "optional"  "numeric"     "1"             "No of times the process that needs to be repeated" ] \
               [list wait             "optional"  "numeric"     "1"             "Wait before executing" ] \
               [list processList      "optional"  "string"      "$processList"  "The process list to be monitored" ] \
               [list paramList        "optional"  "string"      "mem cpu"       "The params that are used for monitoring" ] \
               [list bladeList        "optional"  "string"      ""              "The blades to be monitored" ] \
               [list execShowProcess  "optional"  "boolean"     "yes"           "The linux level process to be monitored" ] \
               [list analyze          "optional"  "boolean"     "yes"           "To analyze the result or not" ] \
               [list peakCpuThreshold "optional"  "numeric"     "0"             "The peak CPU threshold" ] \
               [list peakMemThreshold "optional"  "numeric"     "0"             "The peak CPU threshold" ] \
               [list memValue         "optional"  "string"      "actual"        "The memory value to be monitored" ] \
               [list retVal           "optional"  "boolean"     "yes"           "To return the value or not" ] \
               [list CPUper           "optional"  "boolean"     "yes"           "Calculate CPU percentages" ] \
               [list CPUparameters       "optional"  "string"     "idle"          "cpu utilisation types" ] \
               ]
     
     if {[info exists ARR_PROCESS_INFO]} {unset ARR_PROCESS_INFO}
     
     set ::NO_TIME_STAMP 1
     set parmList "mem cpu"
     set startTime [getSysTime "x X"]
     
     set processNameListDuplicate $processList
     foreach processName $processList {
          set telecomProcess [getHAProcessList "getDefault"]
          if { [lsearch -regexp $processList $processName*] != -1 } {
               if { [lsearch -regexp $processList $processName-] == -1} {
                    
                    set processInstances [lsearch -all -inline $telecomProcess $processName*]
                    foreach instance $processInstances {
                         lappend processNameListDuplicate $instance
                         lappend processList $processName
                         
                    }
                    set indexOfProcessElement [lsearch $processNameListDuplicate "$processName"]
                    set processNameListDuplicate [lreplace $processNameListDuplicate $indexOfProcessElement $indexOfProcessElement]
                    set indexOfProcessElement [lsearch $processList "$processName"]
                    set processList [lreplace $processList $indexOfProcessElement $indexOfProcessElement]
               }
          }
     }
     if {$CPUper == "yes"} {
          lappend processNameListDuplicate "CPUidle"
     }
     
     for {set i 1} {$i <= $repeat} {incr i} {
          set t1 [clock seconds]
          foreach bladeIp $bladeList {
               lappend pList [string trim "$processNameListDuplicate"]
               set result [getSysResourceInfo $bladeIp $processNameListDuplicate $paramList $memValue]
               if {$execShowProcess == "yes"} {
                    set result [showProcess -ipaddr $bladeIp -operation "returnResult"]
               }
               if {$CPUper == "yes"} {
                    set result [getCPUutilisationPercentage -ipaddr $bladeIp -CPUparameters $CPUparameters]
               }
               closeSpawnedSessions $bladeIp "all" "ssh"
          }
          
          print "SYS_RES:Per iteration time taken :  [expr [clock seconds] - $t1]s"
          # Execute show process if requested
          if {$i < $repeat} {
               set wait [expr $wait - ([clock seconds] - $t1)]
               if {$wait > 0} {halt $wait}
          }
     }
     set endTime [getSysTime "x X"]
     # Process and Dump the retrieved data
     set result [dumpSysResourceInfo -bladeList $bladeList -processList $pList -startTime $startTime \
               -endTime $endTime -retVal $retVal -analyze $analyze                              \
               -peakCpuThreshold $peakCpuThreshold -peakMemThreshold $peakMemThreshold]
     
     unset ::NO_TIME_STAMP
     
     if {$retVal == "yes"} {
          return $result
     }
     
     return 0
}

proc initiateLinkSwitchover {args} {

     #-
     #- Procedure to simulate a link switchover for the specified link on BONO
     #-
     #- @return
     #-

     parseArgs args \
               [list \
               [list fgwNum           "optional"  "numeric"         "0"                "FGW num in the configuration file"]\
               [list bonoIp           "mandatory" "string"          "_"                "BONO ip for which the attributes is to be retirved"]\
               [list portType         "mandatory" "string"          "base|fabric"      "port type for which the interface details are to be retrived"]\
               [list port             "mandatory" "string"          "_"                "link on which the switchover needs to be simulated"]\
               [list switchoverTime   "optional"  "numeric"         "5"                "time in seconds to wait for the port recovery after SWover"]\
               [list verify           "optional"  "yes|no"          "yes"              "If set, erification for port status after switchover done"]\
               ]

     set flag 0
     # Get the active interface on the BONO
     set activeIfBefore $port

     set bonoPorts $activeIfBefore
     #     set portType  [list "rtm UP" "base UP" "fabric UP"]

     foreach PORT $bonoPorts {
          switch $PORT {
               "$activeIfBefore" {set portType [list "base UP" "fabric UP"] }
          }
          set result [getPortStatusOnMon -bonoIp $bonoIp -port $activeIfBefore -portType $portType]
          if { $result != 0} {
               print -fail "Verification for port $port failed for portTypes $portType"
               set flag 1
          } else {
               print -pass "The port $port is in expected state"
          }
     }
     # Define the ports on which the failure has to be simulated
     set failedSwitchNo [string index $activeIfBefore end]
     set linkAggPorts [getDataFromConfigFile "getSwitchMalbanPort" $fgwNum $failedSwitchNo]

     # Get the RTM port state on the active bono
     set bonoStatus [getMonState -fgwNum $fgwNum -bonoIp $bonoIp]
     # Verify the Port status before simulating the link failure
     print -info "Verify the port status before simulating link failure"
     foreach PORT $bonoPorts {
          set result [getPortStatusOnMon -bonoIp $bonoIp -port $port -portType $portType]
          if { $result != 0} {
               print -fail "Verification for port $port failed for portTypes $portType"
               set flag 1
          } else {
               print -pass "The port $port is in expected state"
          }
     }

     set result [execCommandSU -dut $bonoIp -command "netstat -nap| grep -i sctp"]
     if {[regexp "ERROR:" $result]} {
          print -fail "Not able find the sctp port"
          return -1
     }

     # Simulating a Link failure
     set operation "down"
     print -info "Simulating a Link failure"
     set result [switchPortOp -switchNum $failedSwitchNo -port $linkAggPorts -operation $operation]
     if { $result != 0} {
          print -fail "Failed to bring down the Link $linkAggPorts on switch $failedSwitchNo"
          set flag 1
     } else {
          print -pass "Successfully bought down the Link $linkAggPorts on switch $failedSwitchNo"
     }

     # Wait for the ports to get switched over
     print -nonewline "For port recovery ... "
     halt $switchoverTime

     # Get the active interface after switchover
     set activeIfAfter [getActiveIfOnBono -bonoIp $bonoIp -portType "fabric"]
     print -info "activeIfAfter : $activeIfAfter"
     # Get the active bonoIp
     set activeBono [getActiveBonoIp $fgwNum]
     set result [execCommandSU -dut $activeBono -command "netstat -nap| grep -i sctp"]
     if {[regexp "ERROR:" $result]} {
          print -fail "Not able find the sctp port"
          return -1
     }

     if {$activeIfAfter == $activeIfBefore} {
          print -fail "Switchover failed.."
          set flag 1
     }

     # if verify is set , then verify the RTM status on the Active BONO after the link failure
     if {$verify == "yes"} {
          print -info "Verifying the port status on the Active BONO after the link failure"
          foreach port $bonoPorts {
               switch $port {
                    "$activeIfBefore" {set portType [list "base UP" "fabric UP"]}
                    "$activeIfAfter"  {set portType [list "base UP" "fabric UP"]}
               }
               set result [getPortStatusOnMon -bonoIp $bonoIp -port $port -portType $portType]
               if { $result != 0} {
                    print -fail "Verification for port $port failed for portTypes $portType"
                    set flag 1
               } else {
                    print -pass "The port $port is in expected state"
               }
          }
     }

     if {$flag} { return -1}

     return 0
}


proc getCPUutilisationPercentageX {args} {
     #-
     #- To calculate the overall CPU idle time
     #-
     global ARR_PROCESS_INFO
     set validCPUparameters "user|system|idle"
     parseArgs args \
               [list \
               [list ipaddr           "mandatory" "ipaddr"                      "-"                 "ip address on the host" ] \
               [list userName         "optional"  "string"                      "admin"             "userName to access the host" ] \
               [list password         "optional"  "string"                      "$::ADMIN_PASSWORD" "password to access the host" ] \
               [list CPUparameters    "optional"  "$validCPUparameters"     "user system idle"      "cpu utilisation types" ] \
               ]
     foreach param $CPUparameters {
          switch $param {
               "user" {
                    set command "top -n1 | grep 'Cpu(s)' | cut -d ' ' -f2 | cut -d '%' -f1"
                    set result [execCommandSU -dut $ipaddr -command $command]
                    set result [lindex [split [string trim $result] "\n"] 1]
                    lappend ARR_PROCESS_INFO($ipaddr,CPUuser,cpu) [lindex $result 0]
               }
               "system" {
                    set command "top -n1 | grep 'Cpu(s)' | cut -d ' ' -f4 | cut -d '%' -f1"
                    set result [execCommandSU -dut $ipaddr -command $command]
                    set result [lindex [split [string trim $result] "\n"] 1]
                    lappend ARR_PROCESS_INFO($ipaddr,CPUsystem,cpu) [lindex $result 0]
               }
               "idle" {
                    
                    set command "top -n1 | grep 'Cpu(s)' | cut -d ' ' -f8 | cut -d '%' -f1"
                    set result [execCommandSU -dut $ipaddr -command $command]
                    set result [lindex [split [string trim $result] "\n"] 1]
                    print -debug "result $result ARR_PROCESS_INFO($ipaddr,CPUidle,cpu) $ARR_PROCESS_INFO($ipaddr,CPUidle,cpu)"
                    set a  [lindex $result 0]
                    set ARR_PROCESS_INFO($ipaddr,CPUidle,cpu) [string trimright $ARR_PROCESS_INFO($ipaddr,CPUidle,cpu) 0]
                    lappend ARR_PROCESS_INFO($ipaddr,CPUidle,cpu) $a
                    print -debug "result $a ARR_PROCESS_INFO($ipaddr,CPUidle,cpu) $ARR_PROCESS_INFO($ipaddr,CPUidle,cpu)"
               }
          }
     }
     return 0
}

proc getActiveBonoIp {{fgwNum 0} {op "return"}} {
     #-
     #- This procedure is used to get the Ip address of the active BONO in a redundant system
     #- If Both the BONOs have status as ACTIVE then the BONO with the lowest IP address is returned
     #- In a SIMPLEX mode, the sole BONO is the Active bono
     #-
     #- @return  -1 on failure, IP on success
     #-
     global DUT
     getActiveBladesInfo
     if {[isProcInStack setUpTestEnv] && ![info exists DUT]} {
          if {[isATCASetup]} {
               # Get the info about all the active blades
               # Set the first blade as the active blade
               
               set  bonoAddressList   [getDataFromConfigFile getBonoIpaddress 0]
               set  malbanAddressList [getDataFromConfigFile getMalbanIpaddress 0]
               
               #Activating malbans if both Malbans are not reachable
               if {![info exists ::MALBAN_IP_LIST]} {
                    set result [execConsoleCommands -boardIp [lindex $malbanAddressList 0] -operation "activate"]
                    set result [execConsoleCommands -boardIp [lindex $malbanAddressList 1] -operation "activate"]
               }
               
               if {[info exists ::BONO_IP_LIST]} {
                    set DUT [lindex $::BONO_IP_LIST 0]
               } else {
                    print -debug "Not able to get a valid ip address for DUT, exiting"
                    return -1
               }
          } else {
               set DUT [getDataFromConfigFile lmtIpaddress $fgwNum]
          }
     }
     
     if {$op == "return"} {
          if {[info exists DUT]} {
               return $DUT
          }
     }
     
     #Linux
     if {![isATCASetup]} {
          print -info "Using LMT Ip Address for DUT login"
          set DUT [getDataFromConfigFile lmtIpaddress $fgwNum]
          return $DUT
     } else {
          if {[info exists ::BONO_IP_LIST]} {
               set bonoAddressList $::BONO_IP_LIST
               set noOfBonos [ llength $bonoAddressList ]
          } else {
               #Needed when both MALBANs are down, to avoid script abort in a intermediate state
               print -info "No BONO is reachable on their base ip, still returning [lindex [getDataFromConfigFile getBonoIpaddress 0] 0]"
               set DUT [lindex [getDataFromConfigFile getBonoIpaddress 0] 0]
               return $DUT
          }
     }
     
     #ATCA
     if {$noOfBonos == 1} {
          #If only one bono exists then that board is the active one
          set activeBono $bonoAddressList
     } else {
          foreach bonoIp $bonoAddressList id {1 2} {
               set bonoState${id} [getMonState -fgwNum $fgwNum -bonoIp $bonoIp]
          }
          if {$bonoState1 != $bonoState2} {
               # If the board state are different then find the active one
               if {[regexp -nocase "active" $bonoState1]} {
                    set activeBono [lindex $bonoAddressList 0]
               } elseif {[regexp -nocase "active" $bonoState2]} {
                    set activeBono [lindex $bonoAddressList 1]
               } else {
                    print -fail "None of the Mon state is ACTIVE, getting bonoStates $bonoState1 and $bonoState2 respectively \
                              still returning [lindex $bonoAddressList 0] as activeBono"
                    set activeBono [lindex $bonoAddressList 0]
               }
          } else {
               # If the board state are same then return the first one as active
               if {[regexp -nocase "active" $bonoState1]} {
                    print -fail "Both of the Mon state is ACTIVE, getting bonoStates $bonoState1 and $bonoState2 respectively \
                              still returning [lindex $bonoAddressList 0] as activeBono"
                    set activeBono [lindex $bonoAddressList 0]
               } else {
                    print -fail "None of the Mon state is ACTIVE, getting bonoStates $bonoState1 and $bonoState2 respectively \
                              still returning [lindex $bonoAddressList 0] as activeBono"
                    set activeBono [lindex $bonoAddressList 0]
               }
          }
     }
     
     if {$op == "update"} {
          set DUT $activeBono
     }
     if {![info exists DUT]} {set DUT $activeBono}
     return $activeBono
}

proc getMonState {args} {
     #-
     #- gets the blade state as mentioned by MON
     #-
     #- @return  -1 on failure, STATE on Success
     set valStates     "active|standby|unavailable|transient"
     set valSubStates  "resilient|nonresilient"
     parseArgs args \
               [list\
               [list fgwNum         "optional"    "numeric"          "0"               "ip address of the host where backdoor port is opened"] \
               [list bonoIp         "mandatory"   "string"           "_"               "ip address of the BONO where the mon state needs to be checked"] \
               [list verify         "optional"    "boolean"          "no"              "Verify the state"] \
               [list state          "optional"    "$valStates"       "active"          "The state to be verified"] \
               [list subState       "optional"    "$valSubStates"    "__UN_DEFINED__"  "The sub state to be verified"] \
               ]
     
     set oct4 [string trim [lindex [split $bonoIp "."] end]]
     if {[info exists $::BONO_IP_LIST]} {
          set bonoIp [lindex $::BONO_IP_LIST [lsearch -regexp $::BONO_IP_LIST "\.$oct4"]]
     }
     
     set result [executeHeNBGWMonDbgDoorCmd -fgwNum $fgwNum -boardIp $bonoIp -command "show mon state"]
     set result [string trim [extractOutputFromResult $result]]
     if {$result == -1 || [regexp -nocase "error|Connection refused" $result]} {
          print -error "Could not get the MON state on $bonoIp"
     } elseif {![isEmptyList $result]} {
          if {[regexp "HeNBGWMon state" $result]} {
               set result [split $result "\n"]
               set index  [lsearch -regexp $result "HeNBGWMon state"]
               set result [lindex $result $index]
               set result [string trim [lindex [split $result "="] end]]
               print -debug "MON state on $bonoIp is $result"
               
               if {$verify != "yes"} {
                    return $result
               } else {
                    set pattern "$state"
                    if {[info exists subState]} {
                         set pattern "$pattern.*$subState"
                    }
                    if {[regexp -nocase $pattern $result]} {
                         print -pass "Verified the MON state as \"$pattern\" on BONO \"$bonoIp\""
                         return 0
                    } else {
                         print -fail "The MON state on BONO \"$bonoIp\" is not as expected: Actual=$result Expected=$pattern"
                    }
               }
          } else {
               print -fail "Could not get the BONO ip address"
               return -1
          }
     }
     return -1
}

proc verifyHeNBGWClusterState {args} {
     #-
     #- Procedure to verify the state on the HeNBGW cluster
     #-
     #- @return  -1 on failure, STATE on Success
     #-
     set applicationProcess  [list HeNBGrp-1 HeNBGrp-2 HeNBGrp-3 HeNBGrp-4 HeNBGrp-5 HST-1 MST-1 MST-2 MST-3 MST-4 MST-5 DS-1]
     parseArgs args \
               [list\
               [list fgwNum         "optional"    "numeric"          "0"             "ip address of the host where backdoor port is opened"] \
               [list state          "optional"    "string"           "ACTIVE-STNBY"  "The state to verify for the cluster"] \
               ]
     set flag 0
     if {![isATCASetup]} {return 0}
     
     # Get the process state on each bono
     foreach bonoIp $::BONO_IP_LIST {
          #Get the process state on both the cards and verify if the cards are in activestandby state
          set result [showProcess -ipaddr $bonoIp -operation "returnResult"]
          if {$result == -1} {
               print -fail "Failed to retrieve process information from $bonoIp"
               return -1
          }
          
          array set arr_proc_info [processShowProcOutput $result]
          if {[regexp "HeNBGrp" [array names arr_proc_info -regexp ",pid"]]} {
               set arr_local($bonoIp,state) active
          } else {
               set arr_local($bonoIp,state) standby
          }
          
          # Get the mon state and verify
          set arr_local($bonoIp,monstate) [getMonState -fgwNum $fgwNum -bonoIp $bonoIp]
          unset arr_proc_info
     }
     
     if {[llength $::BONO_IP_LIST] == 1} {
          print -debug "System is in simplex mode, no further verification required" ; return 0
     }
     
     # Verify the state on the cluster
     switch $state {
          "ACTIVE-STNBY" {
               foreach verifyCriteria [list state monstate] {
                    switch $verifyCriteria {
                         state {
                              set toPrint "Process Verification"
                         }
                         monstate {
                              set toPrint "Mon Verification"
                         }
                    }
                    
                    if {$arr_local([lindex $::BONO_IP_LIST 0],$verifyCriteria) == $arr_local([lindex $::BONO_IP_LIST 1],$verifyCriteria)} {
                         print -fail "\"$toPrint\": Both the cards are in $arr_local([lindex $::BONO_IP_LIST 0],$verifyCriteria) state"
                         set flag 1
                    } else {
                         print -pass "\"$toPrint\": Cluster is in ACTIVE-STANDBY state"
                    }
               }
          }
          default {
               print -fail "Specify proper option to verify"
          }
     }
     
     # Verify the internode connectivity
     set result [verifyInterNodeConnection -fgwNum $fgwNum]
     if {$result != 0} {
          print -fail "The internode connection is not up between the BONOs"
          set flag 1
     } else {
          print -pass "Verified the internode connectivity between the BONOs"
     }
     
     if {$flag} {return -1}
     return 0
}

proc getHAProcessList {{param "active"}} {
     #-
     #- Procedure to get the list of all the HA process spawned on HeNBGW
     #-
     #- @in param the process list to get
     #-
     #- @return  -1 on failure, STATE on Success
     #-
     
     switch $param {
          active            {set processList "HeNBGWMon OAM ShelfOam HeNBGrp-1 HeNBGrp-2 HeNBGrp-3 HeNBGrp-4 HeNBGrp-5 HST-1 MST-1 MST-2 MST-3 MST-4 MST-5 DS-1"}
          standby           {set processList "HeNBGWMon OAM ShelfOam" }
          telecomProcess    {set processList "HeNBGrp-1 HeNBGrp-2 HeNBGrp-3 HeNBGrp-4 HeNBGrp-5 HST-1 MST-1 MST-2 MST-3 MST-4 MST-5 DS-1"}
          nonTelecomProcess {set processList "HeNBGWMon OAM ShelfOam" }
          default           {set processList "HeNBGWMon OAM ShelfOam HeNBGrp-1 HeNBGrp-2 HeNBGrp-3 HeNBGrp-4 HeNBGrp-5 HST-1 MST-1 MST-2 MST-3 MST-4 MST-5 DS-1"}
     }
     return $processList
}

proc processNameMapperX {args} {
     #-
     #-  Proc to Remove the pids and special chars appended to pname
     #-
     #-
     #- @return  -1 on failure
     #-
     #-

     parseArgs args \
               [list \
               [list dutIp              "mandatory"     "string"        "_"     "ip address of the dut"]\
               [list processList        "mandatory"     "string"        "_"     "list of processes"]\
               ]

     set newProcessList ""
     if {[regexp "," $processList]} {set processList [split $processList ","]}
     foreach plist $processList {
          foreach pname $plist {
               #- adding mapping code here if any

               lappend newProcessList $pname
          }
     }
     return $newProcessList
}
proc checkStatus {args} {
     #-
     #- This procedure is used to check status on the bono
     #-
     #- @return  1 on failure and 0 if nodes are running properly
     #-

     parseArgs args \
               [list \
               [list fgwNum         "optional"     "numeric"    "0"     "The position of fgw in the testbed"]\
               ]

     foreach bonoIp [getDataFromConfigFile getBonoIpaddress 0] {
     set result [execCommandSU -dut $bonoIp -command "status"]
     set data [extractOutputFromResult $result]
     set result [regexp -nocase "THIS NODE IS RUNNING AS (ACTIVE|Warm-STANDBY|STANDBY|Cold-STANDBY)" $data - mode]
     if {[info exists mode]} {
                print -pass "Node is configured properly"
        } else {
                print -fail "Node is not configured properly"
                return 1
         }
     }
     return 0
}
