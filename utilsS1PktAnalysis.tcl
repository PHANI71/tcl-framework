proc decodeAndDumpS1Capture {args} {
     #-
     #- proc to remove tshark errors captured during processing the packet
     #-
     #- return the array with the tuple list and -1 on failure
     #-
     
     set flag 0
     global PCAP_DUMP_EN
     global PCAP_DUMP_MULTIHOMING
     
     parseArgs args \
               [list \
               [list fgwNum           "optional"     "numeric"        "0"              "The dut instance in the testbed file"          ] \
               [list operation        "optional"     "init|dump"      "init"           "The operation to be performed"                 ] \
               [list captureFile      "optional"     "string"         "__UN_DEFINED__" "The file to be analyzed"                       ] \
               [list sctpPpid         "optional"     "numeric"        "18"             "The ppid to be used to decode the pcap file"   ] \
               [list simType          "optional"     "MME|HeNB|ALL"   "ALL"            "Define for which simulator the operation to be performed"   ] \
               [list callTrace        "optional"     "boolean"        "yes"            "Dump the call trace"   ] \
               [list callDump         "optional"     "boolean"        "yes"            "Dump the call Dump"   ] \
               [list simType          "optional"     "MME|HeNB|ALL"   "ALL"            "Define for which simulator the operation to be performed"   ] \
               [list onFlyAnalysis    "optional"     "boolean"        "no"             "On the fly analysis of capture"   ] \
               [list localMMEMultiHoming  "optional" "yes|no"    "no"              "To eanble multihoming towards MME on gw"]\
               [list localHeNBMultiHoming "optional" "yes|no"    "no"              "To eanble multihoming towards HeNB on gw"]\
               [list remoteMMEMultiHoming "optional" "yes|no"    "no"              "To eanble multihoming on MME sim"]\
               ]
     
     set enabledUsers "tupakula rnagesh vivekp mohanv"
     
     if {$simType == "ALL"} {set simType "HeNB MME"}
     
     foreach sim $simType {
          switch $sim {
               "MME" {
                    
                    set hostIp        [getDataFromConfigFile "getMmeSimulatorHostIp" $fgwNum]
                    
                    if { [ info exists PCAP_DUMP_MULTIHOMING ] || ( $remoteMMEMultiHoming == "yes" && $localMMEMultiHoming == "yes" ) } {
                         
                         print -info "Multi homing capture enabled on MME"
                         set port1          [getDataFromConfigFile "getMmeSimCp1HostPort" $fgwNum]
                         set port2          [getDataFromConfigFile "getMmeSimCp2HostPort" $fgwNum]
                         
                         if { $::ROUTING_TB == "yes"  } {
                              set vlan1          [getDataFromConfigFile "getMmeSimCp1Vlan" $fgwNum]
                              set vlan2          [getDataFromConfigFile "getMmeSimCp2Vlan" $fgwNum]
                         } else {
                              set vlan1          [getDataFromConfigFile "getMmeCp1Vlan" $fgwNum]
                              set vlan2          [getDataFromConfigFile "getMmeCp2Vlan" $fgwNum]
                         }
                         
                         set intNameAll       "${port1}.${vlan1} ${port2}.${vlan2}"
                         
                    } else {
                         set port          [getDataFromConfigFile "getMmeSimCp1HostPort" $fgwNum]
                         
                         if { $::ROUTING_TB == "yes"  } {
                              set vlan          [getDataFromConfigFile "getMmeSimCp1Vlan" $fgwNum]
                         } else {
                              set vlan          [getDataFromConfigFile "getMmeCp1Vlan" $fgwNum]
                         }
                         set intNameAll       "${port}.${vlan}"
                    }
               }
               "HeNB" {
                    set hostIp        [getDataFromConfigFile "getHenbSimulatorHostIp" $fgwNum]
                    set port          [getDataFromConfigFile "getHenbSimCpHostPort" $fgwNum]

                    if { $::ROUTING_TB == "yes"  } {
                         set vlan          [getDataFromConfigFile "getHenbSimCpVlan" $fgwNum]
                    } else {
                         set vlan          [getDataFromConfigFile "getHenbCp1Vlan" $fgwNum]
                    }
                    set intNameAll       "${port}.${vlan}"
               }
          }
          
          foreach intName $intNameAll {
               switch $operation {
                    "init" {
                         set result [trafficCaptureOnHost -hostIp $hostIp -intName $intName \
                                   -userName $::ROOT_USERNAME -password $::ROOT_PASSWORD \
                                   -tcpdumpOpts "" -maxPktSize 0 -fileType "pcap" -operation "start" -filterOpts "\"ip or ip6\""]
                         if {$result != 0} {
                              print -fail "Traffic capturing on host $hostIp on interface $intName failed"
                              return -1
                         } else {
                              set PCAP_DUMP_EN 1
                              if { $remoteMMEMultiHoming == "yes" && $localMMEMultiHoming == "yes" } { set PCAP_DUMP_MULTIHOMING 1 }
                         }
                    }
                    "dump" {
                         #If the capture was not started, no need to continue analysis
                         if {![info exists PCAP_DUMP_EN]} {return 0}

                         if {[isScriptRanThruRegression]} {
                              set captureFile "/tmp/[getOwner]_[getScriptName]_${sim}_s1ap.pcap"
                         } else {
                               set captureFile "/tmp/[getOwner]_${sim}_s1ap.pcap"
                         } 
                         
                         if {$onFlyAnalysis != "yes"} {
                              #Stop and get the captured file for analysis
                              set result [trafficCaptureOnHost -hostIp $hostIp -intName $intName \
                                        -fileType "pcap" -operation "stop" \
                                        -userName $::ROOT_USERNAME -password $::ROOT_PASSWORD]
                         }
                         
                         #Delete the old file before copying
                         catch {file delete -force $captureFile}
                         
                         set result [trafficCaptureOnHost -hostIp $hostIp -intName $intName \
                                   -fileType "pcap" -operation "get" -dstFileName $captureFile \
                                   -userName $::ROOT_USERNAME -password $::ROOT_PASSWORD]
                         if {![file exists $captureFile]} {
                              print -fail "The $sim Simulator capture file does not exist"
                              set flag 1
                         }
                         
                         removePcapCompressionErrors $captureFile
                         #Analyze the pcap file using tshark
                         set tsharkBin    [getBinaryPath "tshark" [getConnectedHostMgmntIp]]
                         if {$callTrace == "yes"} {
                              set tsharkSumCmd "$tsharkBin -r $captureFile -d sctp.ppi==$sctpPpid,s1ap -d sctp.ppi==301989888,s1ap -R sctp"
                              printHeader "Printing the Call Flow in the $sim capture file for interface $intName" "100" "-"
                              set result [execLinuxCommand -hostMgIp [getConnectedHostMgmntIp] \
                                        -userName [getOwner] -password "" -command $tsharkSumCmd]
                              print -nolog [string repeat - 100]
                         }
                         if {$callDump == "yes"} {
                              set tsharkCmd    "$tsharkBin -r $captureFile -d sctp.ppi==$sctpPpid,s1ap -d sctp.ppi==301989888,s1ap -R s1ap -V"
                              printHeader "Dumping the contents of the $sim pcap file" "100"
                              set result [execLinuxCommand -hostMgIp [getConnectedHostMgmntIp] \
                                        -userName [getOwner] -password "" -command $tsharkCmd]
                              if {[regexp "Unknown protocol|WARNING|doesn't exist" $result] || $result == -1} {
                                   print -fail "Failed to decode and dump the pcap data of $sim Simulator"
                                   set flag 1
                              } else {
                                   print -pass "Successfully dumped the pcap data $sim Simulator"
                              }
                         }
                    }
               }
          }
     }
     if {[info exists ::ROUTING_TB]} {
     set ::ROUTING_TB yes 
     }
     if {$flag} {return -1}
     return 0
}

proc removePcapCompressionErrors {pcap} {
     #-
     #- This procedure is used to remove any uncompression errors that may occour during packet capture
     #-
     #- @return 0 on success and -1 on failure
     #-
     
     set hostIp       [getConnectedHostMgmntIp]
     set tsharkBin    [getBinaryPath "tshark" $hostIp]
     set newFile  "/tmp/[getOwner]_tempPcap.pcap"
     
     catch {file delete -force $newFile}
     set cmd "$tsharkBin -r $pcap -w $newFile"
     set result [execLinuxCommand -hostMgIp [getConnectedHostMgmntIp] \
               -userName [getOwner] -password "" -command $cmd]
     if {[regexp "ERROR" $result] || $result == -1} {
          puts "FAIL: Failed to execute tshark command to read and write to a new file"
          return -1
     }
     catch {file delete -force $pcap}
     moveFile -hostIp $hostIp -srcFileName $newFile -dstFileName $pcap
     return 0
}

proc analyzeSctpSession {args} {
     #-
     #- This procedure is used to analyze the SCTP packets exchanges between peer entities
     #- Based on the operation the procedure is used to capture or analyse the SCTP traffic
     #- The user can also specify the type of analysis that can be done on the given sctp packet capture
     #-
     #- @return 0 on success and -1 on failure
     #-
     
     set flag 0
     parseArgs args \
               [list \
               [list fgwNum           "optional"     "numeric"        "0"                "The dut instance in the testbed file"          ] \
               [list operation        "optional"     "init|analyze"   "init"             "The operation to be performed"                 ] \
               [list captureFile      "optional"     "string"         "__UN_DEFINED__"   "The file to be analyzed"                       ] \
               [list simType          "mandatory"    "MME|HeNB"       "__UN_DEFINED__"   "Define for which simulator the operation to be performed"   ] \
               [list analyze          "optional"     "string"         "bundleTimer"      "The sctp param to be analyzed"   ] \
               [list noOfS1APPkts     "optional"     "string"         "__UN_DEFINED__"   "The number of S1AP packets used in the test"   ] \
               [list bundleTimer      "optional"     "string"         "__UN_DEFINED__"   "The sctp bundle timer used in the test"   ] \
               [list duration         "optional"     "string"         "__UN_DEFINED__"   "The duration for which the packets were sent"   ] \
               ]
     
     switch $simType {
          "MME" {
               set hostIp  [getDataFromConfigFile "getMmeSimulatorHostIp" $fgwNum]
               set port    [getDataFromConfigFile "getMmeSimCp1HostPort" $fgwNum]
               set vlan    [getDataFromConfigFile "getMmeCp1Vlan" $fgwNum]
          }
          "HeNB" {
               set hostIp  [getDataFromConfigFile "getHenbSimulatorHostIp" $fgwNum]
               set port    [getDataFromConfigFile "getHenbSimCpHostPort" $fgwNum]
               set vlan    [getDataFromConfigFile "getHenbCp1Vlan" $fgwNum]
          }
     }
     
     # Get the interface on which the capture and analysis has to be done
     set intName  "${port}.${vlan}"
     set hostCaptureFileName "/tmp/[getOwner]_${hostIp}_${intName}_sctpS1AP.pcap"
     
     switch $operation {
          "init" {
               set result [trafficCaptureOnHost -hostIp $hostIp -intName $intName \
                         -userName $::ROOT_USERNAME -password $::ROOT_PASSWORD -fileName $hostCaptureFileName \
                         -tcpdumpOpts "" -maxPktSize 0 -fileType "pcap" -operation "start" -filterOpts "\"ip or ip6\""]
               if {$result != 0} {
                    print -fail "Traffic capturing on host $hostIp on interface $intName failed"
                    return -1
               } else {
                    print -pass "Successfully started capture on host $hostIp on interface $intName"
               }
          }
          "analyze" {
               set captureFile "/tmp/[getOwner]_${simType}_sctp_s1ap.pcap"
               
               #Stop and get the captured file for analysis
               set result [trafficCaptureOnHost -hostIp $hostIp -intName $intName \
                         -fileType "pcap" -operation "stop" -fileName $hostCaptureFileName \
                         -captureOwner pcap -userName $::ROOT_USERNAME -password $::ROOT_PASSWORD]
               
               #Delete the old file before copying
               catch {file delete -force $captureFile}
               
               set result [trafficCaptureOnHost -hostIp $hostIp -intName $intName -fileName $hostCaptureFileName \
                         -fileType "pcap" -operation "get" -dstFileName $captureFile \
                         -userName $::ROOT_USERNAME -password $::ROOT_PASSWORD]
               if {![file exists $captureFile]} {
                    print -fail "The $simType Simulator capture file does not exist"
                    set flag 1
               }
          }
     }
     
     if {$flag} {return -1}
     return 0
}
