proc executeLteSimulatorBkdoorCmd {args} {
     #-
     #- command to support execution of commands on mme/hEnb backdoor interface
     #-
     set ValidSimTypes "MME|HeNB"
     parseArgs args \
               [list \
               [list fgwNum         "optional"    "numeric"          "0"       "ip address of the host where backdoor port is opened"] \
               [list simType        "optional"    $ValidSimTypes     "MME"     "port number on which application is listening"] \
               [list command        "mandatory"   "string"           "_"       "command to be executed on the session"] \
               [list MMEIndex       "optional"    "numeric"          "0"       "The MME instance to send the message to"] \
               [list HeNBIndex      "optional"    "numeric"          "0"       "The HeNB instance to send the message to"] \
               [list testType        "optional"  "func|load|loadNew"          "func"   "Type of test that we are going to perform using simulator"] \
	       [list instance  "optional"  "numeric"        "0" "instance number" ] \
               ]
     
     switch $simType {
          "MME" {
               set simIp  [getDataFromConfigFile "getMmeSimulatorHostIp" $fgwNum]
               #To be decided
               set prompt "mme>"
               #set port   [expr [getLTEParam "MMESimDbgPort"] + $MMEIndex]
               set port   [getLTEParam "MMESimDbgPort"] ; #As of now only one MME instance would be supported 
          }
          "HeNB" {
               set simIp  [getDataFromConfigFile "getHenbSimulatorHostIp" $fgwNum]
               #To be decided
               set prompt "henb>"
               set port   [getLTEParam "HeNBSimDbgPort"] ;#As of now only one HeNB instance would be supported
	       if {[info exists instance] } { set  port [expr $port + $instance]}
               
          }
          default {
               print -fail "No code defined for \"$simType\" option"
               return -1
          }
     }
     

     if { ($testType == "load") || ($testType == "loadNew") } {set  prompt "loadsim>" }

     
     #For some of the messages an explicit timeout has to be specified
     if {[regexp -nocase "getmessage" $command]} {
          set timeout -1
     } else {
          set timeout 50
     }
     
     # With the new security feature the application ip for telnet should be the loopback ip
     #set applnIp "127.0.0.1"
     set simIpAddress [getDataFromConfigFile "getHenbSimulatorHostIp" $fgwNum]
     set applnIp $simIpAddress
     set result [executeBackDoorCmd -dutIp $simIp -userName "root" -password $::ROOT_PASSWORD -command $command \
               -port $port -prompt $prompt -sessTerminator "close" -applnIp $applnIp -timeout $timeout]
     if {[regexp "ERROR |(Command could not be invoked!!!)" $result]} {
          return "ERROR: Failed to execute on simulator"
     } else {
          return $result
     }
}

proc executeDsDbgDoorCmd {args} {
     #-
     #- command to support execution of commands on DS backdoor interface
     #-
     
     parseArgs args \
               [list \
               [list fgwNum         "optional"    "numeric"          "0"       "ip address of the host where backdoor port is opened"] \
               [list command        "mandatory"   "string"           "_"       "command to be executed on the session"] \
               ]
     
     set hostIp  [getActiveBonoIp $fgwNum]
     # With the new security requirement the application ip should be localhost ip
     set applnIp "127.0.0.1"
     
     set prompt  "(ds|DS)>"
     set port    17100
     
     # All the ds debug commands has to be prefixed with ds
     set cmdList ""
     foreach cmd [split $command "\n"] {
          lappend cmdList "ds [string trim $cmd]"
     }
     set command [join $cmdList "\n"]
     
     set result [executeBackDoorCmd -dutIp $hostIp -userName "admin" -password "$::ADMIN_PASSWORD" -command $command \
               -port $port -prompt $prompt -sessTerminator "close" -applnIp $applnIp]
     if {[regexp "ERROR |(Command could not be invoked!!!)" $result]} {
          return "ERROR: Failed to execute on DS BackDoor"
     } else {
          return $result
     }
}

proc executeHeNBGrpDbgDoorCmd {args} {
     #-
     #- command to support execution of commands on HeNBGrp backdoor interface
     #-
     
     parseArgs args \
               [list \
               [list fgwNum         "optional"    "numeric"          "0"       "ip address of the host where backdoor port is opened"] \
               [list command        "mandatory"   "string"           "_"       "command to be executed on the session"] \
               [list instance       "optional"    "numeric"          "1"       "Instance on which the command has to be executed"] \
               ]
     
     set hostIp  [getActiveBonoIp $fgwNum update]
     set prompt  "(henbgrp|HENBGRP\[1-5\])>"
     set port    [expr 17200 + $instance - 1]
     
     # With the new security requirement the application ip should be localhost ip
     set applnIp "127.0.0.1"
     
     set result [executeBackDoorCmd -dutIp $hostIp -userName "admin" -password "$::ADMIN_PASSWORD" -command $command \
               -port $port -prompt $prompt -sessTerminator "close" -applnIp $applnIp]
     if {[regexp "ERROR |(Command could not be invoked!!!)" $result]} {
          return "ERROR: Failed to execute on HeNBGrp BackDoor"
     } else {
          return $result
     }
}

proc executeHeNBGWMonDbgDoorCmd {args} {
     #-
     #- command to support execution of commands on HeNBGWMOn backdoor interface
     #-
     
     parseArgs args \
               [list\
               [list fgwNum         "optional"    "numeric"          "0"       "ip address of the host where backdoor port is opened"] \
               [list boardIp        "mandatory"   "ip"               "0"       "ip address of the board where the mon state needs to be checked"] \
               [list command        "mandatory"   "string"           "_"       "command to be executed on the session"] \
               ]
     
     #set prompt "(henbgwmon|HENBGWMON|HeNBGWMon)>"
     set prompt "(FGWMon)>"
     set port   "17600"
     
     set applnIp "127.0.0.1"
     
     set result [executeBackDoorCmd -dutIp $boardIp -userName "admin" -password "$::ADMIN_PASSWORD" -command $command \
               -port $port -prompt $prompt -sessTerminator "close" -applnIp $applnIp]
     if {[regexp "ERROR |(Command could not be invoked!!!)" $result]} {
          return "ERROR: Failed to execute on HeNBGWMon BackDoor"
     } else {
          return $result
     }
}

proc executeHstDbgDoorCmd {args} {
     #-
     #- command to support execution of commands on HST backdoor interface
     #-
     
     parseArgs args \
               [list \
               [list fgwNum         "optional"    "numeric"          "0"       "ip address of the host where backdoor port is opened"] \
               [list command        "mandatory"   "string"           "_"       "command to be executed on the session"] \
               ]
     
     set hostIp  [getActiveBonoIp $fgwNum]
     set prompt  "hst>"
     set port    17300
     
     # With the new security requirement the application ip should be localhost ip
     set applnIp "127.0.0.1"
     
     set result [executeBackDoorCmd -dutIp $hostIp -userName "admin" -password "$::ADMIN_PASSWORD" -command $command \
               -port $port -prompt $prompt -sessTerminator "close" -applnIp $applnIp]
     if {[regexp "ERROR |(Command could not be invoked!!!)" $result]} {
          return "ERROR: Failed to execute on DS BackDoor"
     } else {
          return $result
     }
}

proc executeMstDbgDoorCmd {args} {
     #-
     #- command to support execution of commands on MST backdoor interface
     #-
     
     parseArgs args \
               [list \
               [list fgwNum         "optional"    "numeric"          "0"       "ip address of the host where backdoor port is opened"] \
               [list command        "mandatory"   "string"           "_"       "command to be executed on the session"] \
               ]
     
     set hostIp  [getActiveBonoIp $fgwNum]
     set prompt  "mst>"
     set port    17400
     
     # With the new security requirement the application ip should be localhost ip
     set applnIp "127.0.0.1"
     
     set result [executeBackDoorCmd -dutIp $hostIp -userName "admin" -password "$::ADMIN_PASSWORD" -command $command \
               -port $port -prompt $prompt -sessTerminator "close" -applnIp $applnIp]
     if {[regexp "ERROR |(Command could not be invoked!!!)" $result]} {
          return "ERROR: Failed to execute on DS BackDoor"
     } else {
          return $result
     }
}
# prompt list
set ::BSG_PROMPT        "\nCLI >>"
set ::FGW_SHELL_PROMPT     "(~|)\](#|\\\$)"
proc execCliCommand {args} {
     #- To execute commands on henbgw cli session
     #-
     #- @error "ERROR: <desc>"
     #-
     #- @return string (captured data during commands execution)
     
     parseArgs args\
               [list \
               [list dut         "mandatory"    "ip"               "-"           "defines the fgwHostIp to be used"]\
               [list command     "mandatory"    "string"           "-"           "defines the command to be executed"]\
               [list user        "optional"     "admin|root"       "admin"       "defines the userName"]\
               [list pass        "optional"     "string"           "$::ADMIN_PASSWORD"       "defines the password to be used"]\
               [list timeout     "optional"     "string"           "300"         "defines the timeout period"]\
               [list sessionName "optional"     "string"           "bsgcli"    "defines the cli prompt"]\
               ]
     
     # If the $dut is  not a valid ipaddress, return
     if {![isIpaddr $dut]} {
          return "ERROR: Cannot Telnet to \"$dut\" (Invalid ip address)"
     }
     
     switch $sessionName {
          "bsgcli"   { set cliPrompt  "$::BSG_PROMPT" ; set eof ";"}
          default      { print -abort "No code defined to handle session \"$sessionName\""; return "ERROR: No code defin
               ed" }
     }
     
     set bufferFullMatchStr "$cliPrompt$"
     set result_string      ""
     
     # get session information
     set sessId [getExpectSession -hostMgIp $dut -userName $user -password $pass -sessionName $sessionName -expPromptVarName "FGW_SHELL_PROMPT"]
     if {[regexp "ERROR" $sessId]} {
          return $sessId
     }
     
     print -dbg "\nExecuting {[regsub -all "\n" $command " \\n "]}, timeout : $timeout \n"
     
     match_max -i $sessId 20000
     
     foreach cmd [split $command "\n"] {
          
          set cmd [string trim $cmd]
          
          if {[regexp "^sleep.*\\d+" $cmd wait]} {
               # scenario where requested to wait before executing a command
               catch {eval exec $wait}
          } else {
               # check if requested to wait after sending command
               regexp "sleep.*\\d+" $cmd wait
               
               # extract the actual cli to executed. (knock off the bsgcliProcessor append code)
               regsub "sleep.*" $cmd "" cmd1
               
               # send command to the expect shell
               send -i $sessId "${cmd1}${eof}\r"
               
               # scenario where requested to wait before getting prompt
               catch {eval exec $wait}
          }
          
          set errStr "" ;# to store error info encountered while waiting for prompt
          if {![regexp "noPrompt" $cmd]} {
               expect {
                    -i $sessId full_buffer                                {
                         append result_string $expect_out(buffer)
                         if {[isPromptBrokenDueToExpectBufferFull $sessId $bufferFullMatchStr $cliPrompt]} {exp_continue}
                         set expect_out(buffer) "" ;# flush buffer contents when there is no need to continue
                    }
                    -i $sessId timeout                                    {
                         set errStr "$sessionName session on $dut timed out. timeout was set to $timeout"
                         closeSpawnedSessions $dut $user "bsgcli"
                    }
                    -i $sessId -re "Connection closed by foreign host"    {
                         set errStr "$sessionName session got closed. Stopping furthur execution"
                         closeSpawnedSessions $dut $user "bsgcli"
                    }
                    -i $sessId -re $cliPrompt                              {}
               }
               # store data from the buffer if it exists
               if {[info exists expect_out(buffer)]} {
                    append result_string $expect_out(buffer)
               }
          } else {
               # to collect data from the buffer accumulated with previous send command
               expect -i $sessId -re $
               append result_string $errStr
          }
          # validate encountered errors during command execution
          if {$errStr != ""} {
               print -err "\n$errStr"
               append result_string "ERROR: $errStr"
               break
          }
     }
     print -dbg "\nCompleted execution of {[regsub -all "\n" $command " \\n "]}\n"
     
     return $result_string
}


proc installRoutesThruMonX {hostIp} {
     #-
     #- Expect code to handle change in prompt (session transfer) while installing the routes through routeadd script
     #-
     #- @in path -> path where net-snmp source code is present
     #-
     global arr_nw_data
     set result "SUCCESS: Route configuration successfull"
     
     # Extract the session Id
     set sessId     $::ARR_USR_EXP_SESS($hostIp,admin,su)
     set timeout    100
     set routeList  [array names arr_nw_data -regexp ",(cnCP|heNBCP|oAM)"]
     set noOfRoutes [llength $routeList]
     
     set count 0
     set option 7
     print "routeList: $routeList"
     foreach element "NA $routeList NA" {
          if {$element != "NA"} {
               set interface [lindex [split $element ","] end]
               set value     [lindex $arr_nw_data($element) 0]
               foreach {network gateway} $value {break}
               if {[::ip::is 6 $network]} {
                    set netmask    "120"
                    set network    [getNetPrefix $network $netmask]
                    set interface  "${interface}V6"
               } else {
                    set netmask    "255.255.255.0"
                    set network [getNetId $network $netmask]
               }
               set gateway [incrIp $gateway]
          }
          if {$count == [expr $noOfRoutes + 1]} {set option 0}
          
          after 200
          expect {
               -i $sessId "Quit :"                      {
                    send -i $sessId "$option\r"
                    if {$count == 0} {
                         set option 1
                         incr count
                         continue
                    } elseif {$option != 0} {
                         exp_continue
                    }
               }
               -i $sessId "Enter ipaddr :"                {send -i $sessId "$network\r"; exp_continue}
               -i $sessId "Enter netmask :"               {send -i $sessId "$netmask\r"; exp_continue}
               -i $sessId "Enter ipv6 prefix length.* "    {send -i $sessId "$netmask\r"; exp_continue}
               -i $sessId "Enter gateway :"               {send -i $sessId "$gateway\r"; exp_continue}
               -i $sessId "Enter MIM interface name :"    {send -i $sessId "$interface\r"}
               -i $sessId "ERROR : Error"                 {}
               -i $sessId "No such file or directory"     {
                    set str "File not found"
                    set expect_out(buffer) $str
                    print -debug $str
               }
               -i $sessId -re $::GW_SHELL_PROMPT          {}
               -i $sessId timeout                         {
                    set str "EXP_TIMEOUT: Expect timedout while doing configuration. timeout was set to $timeout seconds"
                    set expect_out(buffer) $str
                    print -debug $str
               }
          }
          incr count
     }
     if {[regexp "EXP_TIMEOUT|ERROR: Installation Falied" $expect_out(buffer)]} {
          set result "SQA_ERROR: Route configuration failed"
     } else {
          set result "SUCCESS: Route configuration successfull"
     }
     
     return $result
}
