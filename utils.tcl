proc checkSystemForTest {args} {
     #-
     #- to ensure system is in ready to perform test
     #- this will ensure all required processes are running on the system before running the test
     #-
     global DUT
     parseArgs args \
               [list \
               [list fgwNum         "optional"     "numeric"        "0"       "The dut instance in the testbed file" ] \
               [list operation      "optional"     "init|cleanup"   "init"    "The operation to be performed" ] \
               ]
     set boardIp [getDataFromConfigFile lmtIpaddress $fgwNum]
     
     switch $operation {
          "init" {
               # For an ATCA setup verify if all the boards in the cluster are UP
               if {[isATCASetup]} {
                    getActiveBladesInfo
                    set DUT          [lindex $::BONO_IP_LIST 0]
                    set fgwList $::BONO_IP_LIST
                    set pingFailedList ""
                    set cardType     [list MALBAN BONO]
                    
                    foreach card $cardType {
                         print -info "Verifying the \"$card\" connectivity for ip address \"[join [set ::${card}_IP_LIST]]\""
                         
                         if {[llength [set ::${card}_IP_LIST]] != [llength [getDataFromConfigFile get[string totitle $card]Ipaddress $fgwNum]]} {
                              foreach ip [getDataFromConfigFile get[string totitle $card]Ipaddress $fgwNum] {
                                   set oct4 [string trim [lindex [split $ip "."] end]]
                                   if {[lsearch -regexp [set ::${card}_IP_LIST] $oct4] < 0} {
                                        set slot [getBoardSlot $ip]
                                        set result [rebootBlade -bladeIp $ip -operation "activate"]
                                        if {$result != 0} {
                                             print -fail "Activating board $slot failed"
                                             print -debug "Cannot continue with the test"
                                             return 1
                                        }
                                   }
                              }
                         }
                    }
                    
                    # Verifying end to end connectivity of Bono Malban and OMNI ports
                    verifySystemConnectivity
                    
                    #clear HFL files before start of execution
                  foreach fgwIp $fgwList {
                  print -info "Clear the HFL Logs in /opt/log/HFL/"
                  set result [execCommandSU -dut $fgwIp -command "rm -rf /opt/log/HFL/*"]
                   }

                    checkINLConnection
                    # Set the time on bonos to be in sync with the host time
                    foreach ip $::BONO_IP_LIST {
                         print -debug "Setting the time on $ip to be in sync with the hostIp"
                         set result [syncTimeToServer -dutIp $ip]
                    }
               #To disable martian logs on all cards
               consoleCleanUp $fgwNum
               }
               # print the system version
               getSystemVersion $fgwNum
          }
          "cleanup" {
               # terminate the simulator instances that are running
               set result1 [cleanUpSimInstances]

               # Checking end to end connectivity of Bono Malban and OMNI ports
               set result  [verifySystemConnectivity]

               # Dump alarms raised on HFL file
               set fgwList $::BONO_IP_LIST
               foreach fgwIp $fgwList {
                  set localHost     [getConnectedHostMgmntIp 4]
                  set hflFilePath  "/opt/log/HFL"
                  set tempHflFilePrefix  "[getOwner]_hflFile"

                  print -info "Deleting temp xml files on host before copying"
                  set tmpFileList [getAllFiles $localHost "/tmp" [getOwner] "" "yes" "" $tempHflFilePrefix]
                  if {$tmpFileList != "" && $tmpFileList != -1} {
                      foreach tmpFile $tmpFileList {
                         file delete -force $tmpFile
                    }
                 } else {
                       print -debug "No temp xml files exists on host .. continuing"
                 }

                 # Get the list of all the HFL files generated on GW
                  set hflFileList  [getAllFiles $fgwIp $hflFilePath $::ADMIN_USERNAME $::ADMIN_PASSWORD "yes" "" "*HFL*xml"]
                  print -info " List of files are $hflFileList "

                  if {$hflFileList != "" && $hflFileList != -1} {
                       print -debug "Copying \"$hflFileList\" files to the host for analysis"
                       set fileCount 1
                       foreach hflFile $hflFileList {
                         set localFileName "/tmp/${tempHflFilePrefix}${fileCount}.xml"
                         set result [scpFile -localHost $localHost -remoteHost $fgwIp -localFileName $localFileName -opType "get" \
                                   -remoteFileName $hflFile -remoteUser $::ADMIN_USERNAME -remotePassword $::ADMIN_PASSWORD]
                         if {$result == -1} {
                              print -fail "Copying of HFL file $hflFile failed"
                              return -1
                         }

                  set fd [open $localFileName "r"]
                  set data [read $fd]
                  close $fd
                  #print "alarms are $data"
                  if {![regexp {[:alnum:]} $data match]} {
                          print -info "No alarms found in $localFileName"
                  } else {
                            print -fail "Found alarms in log file $localFileName"
                            display -header "alarms found in $localFileName" -data [split $data "\n"] -index "yes" -suppressEmptyLines "yes"
                  }
                  incr fileCount
                }
             } else {
                    print -fail "No HFL files were found"
                    return -1
                    }
              }
 
               # Dump the contents of the pacap file if its captured
               if {[info exists ::testType]} {
                    if { $::testType == "load" } {
                         set result  [decodeAndDumpS1Capture -fgwNum $fgwNum -operation "dump" -callDump "no" -callTrace "no"]
                    }
               } else {
                    set result  [decodeAndDumpS1Capture -fgwNum $fgwNum -operation "dump"]
               }
               # Dump the call flow in the script
               set result  [dumpCallFlowInScript]
               
               # Dump the network information and statistics
               if {[regexp "switchMonitoring$" [pwd]]} {
                    printHeader "Snaphot of system information after test execution"
                    foreach ip $::BONO_IP_LIST {
                         set result [dumpNetworkMonStateAndInterfaceStats -bonoIp $ip]
                    }
                      foreach ip $::MALBAN_IP_LIST {
                      dumpMalbanState -bladeIp $ip
                     }
               }
               
               if {0 && [isScriptRanThruRegression]} {
                    print -info "Performing a system reboot to bring the system in working state"
                    set result [rebootSystem -fgwNum $fgwNum -typeOfReboot "hard" -verify "yes"]
                    if {$result != 0} {
                         print -fail "System reboot failed; failed to recover the system in working state"
                    }
               }
               
               return $result1
          }
     }
}

proc testCleanUp {args} {
     #-
     #- any specific cleanup need to be performed before exiting the script execution
     #-
     
     return 0
}

proc genAndCopySystemState {args} {
     #-
     #- procedure to generate the bsg save state and copy the archived files to local directory
     #-
     #- @ return the copied message name on success, -1 on fail
     #-
     parseArgs args \
               [list \
               [list dstHost              "optional"   "ipaddr"      "127.0.0.1"       "ip address of the machine to where cores have to copied" ] \
               [list dutIp                "mandatory"  "ipaddr"      "_"               "ip address of the source where the core has happened" ] \
               [list scriptName           "optional"   "string"      "__UN_DEFINED__"  "The script that is currently being executed" ] \
               ]

     set flag 0

     # generat the bsg save state
     set fileName [bsgSaveState -dutIp $dutIp -copyCores "yes" -genPstack "yes"]
     if {$fileName == -1} {
          print -fail "Generation of bsg save state on $dutIp failed, Exiting ..."
          return -1
     }
     set dstCoreFilesLoc "/home/[getOwner]/FGW/CORES"
     #set timestamp [getSysTime "b e R"]
     set timestamp [getSysTime "b d Y H M S"]
     set timestamp [join $timestamp "_"]

     set tmpFileName [string trim [lindex [split $fileName "/"] end]]
     set srcFileName "${dutIp}_${timestamp}_${scriptName}_${tmpFileName}"
     set result [scpFile -localHost $dstHost -remoteHost $dutIp -remoteUser "$::ADMIN_USERNAME" -remotePassword "$::ADMIN_PASSWORD" \
               -localFileName "$dstCoreFilesLoc/$srcFileName" -remoteFileName "$fileName" \
               ]
     if {$result != 0} {
          print -fail "Copy of BSG save state failed"
          return -1
     }
     return $tmpFileName
}


proc monitor_demo {fileName status {op "check"}} {
     #-
     #- supporting procs for demo
     #-
     switch $op {
          "check" {
               while {1} {
                    eval exec "sync"
                    set fd [open $fileName "r"]
                    set data [string trim [read $fd]]
                    close $fd
                    if {[regexp "^$status$" $data]} {break}
                    sleep 0.1
               }
          }
          "update" {
               eval exec "echo $status > $fileName"
          }
     }
     return 0
}

proc setup_demo_mode {procList} {
     #-
     #- proc to enable demo mode
     #-
     
     set ::DEMO_CONTROL_FILE "/tmp/.demo_status_monitor.db"
     foreach procName $procList {
          changeProcDefinition -procName $procName -defFun no
          proc $procName args {
               print -dbg "Before start executing, waiting for input from user ...."
               monitor_demo $::DEMO_CONTROL_FILE "START" "check"
               set result [eval "[lindex [info level [info level]] 0]_old $args"]
               set status [string map "\
                         0  PASS  \
                         -1 FAIL  \
                         1  ABORT \
                         " $result ]
               print -dbg "Updating [getCallingProcName] exuection status \"$result -> $status\" "
               monitor_demo $::DEMO_CONTROL_FILE $status "update"
               return $result
          }
     }
}
