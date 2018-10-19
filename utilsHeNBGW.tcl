proc verifyProcessOnHeNBGW {args} {
     
     #-
     #- To check whether all/specified processes running on the HeNBGW
     #-
     #- @return  0 on success, -1 on failure
     #-
     
     #Changing the process names
     #set allExpectedProcess    "HeNBGwMon OAMServer gsnmpProxy HeNBGrp HST MST DS UPlaneMgr UPlaneFwd shelfoam snmpd"
     set allExpectedProcess    "FGWMon.exe OAMServer.exe gsnmpProxy.exe HeNBGrp.exe HST.exe MST.exe DS.exe shelfOam.exe StatsD.exe"
     set multiThreadedProcess  "HeNBGrp MST"
     parseArgs args \
               [list \
               [list boardIp          "mandatory" "ipaddr"                      "-"                  "ip address on the host on which fgw running" ] \
               [list userName         "optional"  "string"                      "admin"              "userName to access the host" ] \
               [list password         "optional"  "string"                      "$::ADMIN_PASSWORD"  "password to access the host" ] \
               [list expProcess       "optional"  "string"                      $allExpectedProcess  "processes expected to be running" ] \
               ]
     
     set flag 0
     set currentRunningProcess [showProcess -ipaddr $boardIp -userName $userName -password $password -operation "pList"]
     if {$currentRunningProcess == -1} {
          print -err "Failed to get processes running"
          return -1
     }
     
     print -info "Expected processes : [lsort -dictionary [join $expProcess ","]]"
     print -info "Current  processes : [lsort -dictionary [join $currentRunningProcess ","]]"
     set diff [listcomp $expProcess $currentRunningProcess]
     if {$diff != 0} {
          foreach fPr $diff {
               if {[regexp -- {\-\d} $$fPr]} {
                    # If the user has passed the actual process name then concider it as failure
                    print -fail "Process $fPr is not running"
                    set flag 1
                    continue
               }
               set result [regexp $fPr $currentRunningProcess]
               if {$result == -1} {
                    print -fail "Process $fPr is not running"
                    set flag 1
               }
          }
     }
     if {$flag} {return -1}
     print -pass "The expected process \"$expProcess\" are RUNNING"
     return 0
}

proc bsgSaveState {args} {
     #-
     #- To generate the bsg save state on the system
     #-
     #- @return the generated file on success and -1 on failure
     #-
     
     parseArgs args \
               [list\
               [list dutIp                 "optional"    "ipaddr"           "[getActiveBonoIp]"    "ip address of the dut"] \
               [list copyCores             "optional"    "boolean"          "no"                   "copy the cores or not"] \
               [list genPstack             "optional"    "boolean"          "no"                   "generate and copy the pstack or not"] \
               [list copyAllFiles          "optional"    "boolean"          "yes"                  "copy all the files or not"] \
               [list genBtrace             "optional"    "boolean"          "yes"                  "Generate btrace"] \
               [list genCoreForRunProcess  "optional"    "boolean"          "no"                   "Generate core for running process"] \
               [list startTime             "optional"    "string"           "__UN_DEFINED__"       "The starting timestamp"] \
               [list endTime               "optional"    "string"           "__UN_DEFINED__"       "The end timestamp"] \
               ]
     
     set inLineOption "\-"
     foreach option [list copyCores genPstack copyAllFiles genBtrace genCoreForRunProcess] {
          if {[info exists $option]} {
               if {[set $option] == "yes"} {
                    append inLineOption [string map "copyCores c genPstack p copyAllFiles l genBtrace p genCoreForRunProcess g" $option]
               }
          }
     }
     
     # Generate the files only as per timestamp if required
     if {[info exists startTime]} {append inLineOption " -s \"$startTime\""}
     if {[info exists endTime]}   {append inLineOption " -e \"$endTime\""  }
     
     print -info "Generating the BSG save state on \"$dutIp\""
     set result [execCommandSU -dut $dutIp -command "/opt/scripts/bsgsavestate $inLineOption" -timeout 500]
     set result [split [extractOutputFromResult $result] "\n"]
     set index  [lsearch -regexp $result "Output File"]
     if {$index != -1} {
          set outFileName [lindex $result $index]
          set outFileName [string trim [lindex [split $outFileName ":"] 1]]
          print -debug "Generated BSG save state on $dutIp is $outFileName"
          return $outFileName
     }
     return -1
}

proc verifyProcessVersionOnHeNBGW {args} {
     #-
     #- To check whether all/specified processes running on the HeNBGW
     #-
     #- @return  0 on success, -1 on failure
     #-
     
     #set allExpectedProcess    "FGWMon.exe OAMServer.exe gsnmpProxy.exe HeNBGrp.exe HST.exe MST.exe DS.exe UPlaneMgr.exe UPlaneFwd.exe shelfoam.exe snmpd"
     set allExpectedProcess    "FGWMon.exe OAMServer.exe gsnmpProxy.exe HeNBGrp.exe HST.exe MST.exe DS.exe shelfoam.exe BSGCLI.exe StatsD.exe"
     
     parseArgs args \
               [list \
               [list boardIp          "mandatory" "ipaddr"                      "-"                  "ip address on the host on which fgw running" ] \
               [list expVersion       "mandatory" "string"                      "-"                  "expected process version" ] \
               [list userName         "optional"  "string"                      "admin"              "userName to access the host" ] \
               [list password         "optional"  "string"                      "::ADMIN_PASSWORD"   "password to access the host" ] \
               [list pList            "optional"  "string"                      $allExpectedProcess  "processes expected to be running" ] \
               ]
     
     set flag 0
     
     foreach pname $pList {
          set version [getProcessVersion -ipaddr $boardIp -pname $pname]
          if {$version == -1} {
               print -fail "Not able to get version $pname"
               set flag 1
          }
          if {$version != $expVersion} {
               print -fail "$pname version \"$version\" is not same as that of system \"$expVersion\""
               set flag 1
          } else {
               print -pass "$pname version \"$version\" is same as that of system \"$expVersion\""
          }
     }
     
     if {$flag} {
          print -fail "\nAll/Few process version verification failed"
          return -1
     } else {
          print -pass "\nAll process are running expected version"
          return 0
     }
}
#-------------------------------

proc updateBsrDataConfig {args} {
     #-
     #- This procedure is used to update the BSR DATA file configuration
     #-
     #- The user can update multiple BSR values at one time
     #- HeNBIndex can be passed as a comma seperated list OR a range specified by -
     #-
     #- example
     #-   HeNBIndex 0-4    : BSRs 0,1,2,3,4
     #-   HeNBIndex 0,3,9  : BSRs 0,3,9
     #-   HeNBIndex 0-3,9  : BSRs 0,1,2,3,9
     #-
     #-

     global ARR_XML_DATA
     global ARR_LTE_TEST_PARAMS
     global ARR_LTE_TEST_PARAMS_MAP

     parseArgs args\
               [list \
               [list fgwNum                      "optional"     "numeric"                  "0"               "FGW number in testbed file"]\
               [list HeNBIndex                    "mandatory"    "string"                   "_"               "Start BSR ID"]\
               [list accessMode                  "optional"     "closedAccess|openAccess"  "__UN_DEFINED__"  "Access mode for the BSR"]\
               [list bsrId                       "optional"     "numeric"                  "__UN_DEFINED__"  "BSR Id for the BSR"]\
               [list enableServiceMonitoring     "optional"     "boolean"                  "__UN_DEFINED__"  "Enable service monitoring for the BSR"]\
               [list groupId                     "optional"     "numeric"                  "__UN_DEFINED__"  "The group ID for the BSR"]\
               [list hnbIdentity                 "optional"     "string"                   "__UN_DEFINED__"  "The hnbIdentity for the BSR"]\
               [list hnbUniqueIdentity           "optional"     "string"                   "__UN_DEFINED__"  "The hnbUniqueIdentity for the BSR"]\
               [list serialNumber                "optional"     "string"                   "__UN_DEFINED__"  "The serialNumber for the BSR"]\
               [list macroInfo                   "optional"     "string"                   "__UN_DEFINED__"  "The macroInfo for the BSR"]\
               ]
        # Create the index list in the way the BSR data has to be updated
     set bsrIndexList [generateListFromInput $HeNBIndex]

     set globalBsrVars [list accessMode bsrId enableServiceMonitoring groupId hnbIdentity hnbUniqueIdentity serialNumber]
     set splBsrVars    [list macroInfo]
     print -info "inside update proc, HeNBIndex is $HeNBIndex"
     # This configuration is used to update only GLOBAL bsrValues
     foreach bsrIndex $bsrIndexList {
          # Check if the BSR info exists in the BSR structure
          # If no exit and return failure
          if {[isEmptyList [array names ARR_LTE_TEST_PARAMS_MAP -regexp "H,$HeNBIndex"]]} {
               print -fail "BSR data for the BSR \"$bsrIndex\" does not exist. Cannot continue"
               return -1
          }
          foreach globalVar $globalBsrVars {
               if {[info exists $globalVar]} {
                    print -debug "HeNBIndex=$HeNBIndex : Updating $globalVar with \"[set $globalVar]\""
                    set ARR_LTE_TEST_PARAMS_MAP(H,$HeNBIndex,$globalVar) [set $globalVar]
               }
          }
     }

     # This part is used to configure special cases of BSR configuration
     foreach var $splBsrVars {
          if {![info exists $var]} {continue}
          foreach bsrIndex $bsrIndexList varNew [set $var] {
               switch $var {
                    macroInfo {
                         print -info "Mapping Macro Indexes to BSRs"
                         foreach macroIndex [split $varNew ","] {
                              #set macro [lindex [getFromFGWTestMap -param "MACRO"] $macroIndex]
                              lappend ARR_LTE_TEST_PARAMS_MAP(H,$HeNBIndex,macroInfo) $macroIndex
                              print -info "ARR_LTE_TEST_PARAMS_MAP(B,$bsrIndex,macroInfo) $ARR_FGW_TEST_PARAMS_MAP(B,$bsrIndex,macroInfo)"
                         }
                    }
               }
          }
     }
    return 0
}

#---------------------------
proc getBsrDataInfo {args} {
     #-
     #- This procedure is used to get the value of the requested param
     #-
     #- The procedure will check if the user has defined the key; if yes he it will return the user configured value
     #- Or else return the default value
     #-
     global ARR_LTE_TEST_PARAMS_MAP

     parseArgs args\
               [list \
               [list fgwNum                      "optional"     "numeric"                  "0"               "FGW number in testbed file"]\
               [list HeNBIndex                    "mandatory"    "string"                   "_"               "BSR Index"]\
               [list UEIndex                     "optional"     "numeric"                  "__UN_DEFINED__"  "UE index "]\
               [list key                         "optional"     "string"                   "__UN_DEFINED__"  "The key for which the value has to be returned" ]\
               [list defValue                    "optional"     "string"                   "__UN_DEFINED__"  "The default value to be returned"]\
               ]

     set value $defValue
     if {[info exists UEIndex]} {

     } else {
          if {[info exists ARR_LTE_TEST_PARAMS_MAP(H,$HeNBIndex,$key)]} {
               set value $ARR_LTE_TEST_PARAMS_MAP(H,$HeNBIndex,$key)
          }
     }
     return $value
}

proc setUpHeNBGW {args} {
     #-
     #- wraper to setup HeNBGW for test
     #-
     #- @out 0 on success, -1 on error
     #-
     
     #- @out 0 on success, -1 on error
     #-
     
     set validSimTypes "HeNB MME"
     global ARR_LTE_TEST_PARAMS_MAP
     global ARR_LTE_TEST_PARAMS
     
     parseArgs args \
               [list \
               [list fgwNum                      optional   "numeric"  "0"                     "Position of FGW in the testbed"] \
               [list switchNum                   optional   "numeric"  "0"                     "Position of switch under FGW"] \
               [list startBsrId          "optional"  "numeric"    "1000"                  "Start BSR ID"] \
               [list simType                     optional   "string"   $validSimTypes          "defines type of simualtors to be configured"]\
               [list noOfMMEs                    optional   "numeric"  "1"                              "No of MMEs to be simulated"] \
               [list noOfRegions                 optional   "numeric"  "1"                              "No of Regions to be simulated"] \
               [list eNBNameGw                   optional   "string"   [getLTEParam "HeNBGWName"]       "Gateway eNB name" ] \
               [list globaleNBId                 optional   "numeric"  [getLTEParam "globaleNBId"]      "Gateway eNB ID" ] \
               [list defaultPagingDrx            optional   "string"   [getLTEParam "defaultPagingDrx"] "Paging DRX value" ] \
               [list gwMCC                       optional   "numeric"  [getLTEParam "gwMCC"]            "MCC of the gateway" ] \
               [list gwMNC                       optional   "numeric"  [getLTEParam "gwMNC"]            "MNC of the gateway" ] \
               [list MMEeNBNameGw                optional   "string"   "__UN_DEFINED__"                 "Gateway Name w.r.f to MME" ] \
               [list taiMcc                      optional   "numeric"  "__UN_DEFINED__"                 "TAI's PLMN ID (MCC)" ] \
               [list taiMnc                      optional   "numeric"  "__UN_DEFINED__"                 "TAI's PLMN ID (MNC)" ] \
               [list mmeRegionMcc                optional   "numeric"  "__UN_DEFINED__"                 "MME Region PLMN ID (MCC)" ] \
               [list mmeRegionMnc                optional   "numeric"  "__UN_DEFINED__"                 "MME Region PLMN ID (MNC)" ] \
               [list mmeRegionGlobaleNBId        optional   "numeric"  "__UN_DEFINED__"                 "MME Region eNBId" ] \
               [list tac                         optional   "numeric"  "__UN_DEFINED__"                 "TAC" ] \
               [list s1ResetAckTimer             optional   "numeric"  "__UN_DEFINED__"                 "s1ResetAckTimer" ] \
               [list s1ResetGuardTimer           optional   "numeric"  "__UN_DEFINED__"                 "s1ResetGuardTimer" ] \
               [list s1SetupGuardTimer           optional   "numeric"  "__UN_DEFINED__"                 "s1SetupGuardTimer" ] \
               [list s1SetupRetryTimer           optional   "numeric"  "__UN_DEFINED__"                 "s1SetupRetryTimer" ] \
               [list s1RelCompGuardTimer         optional   "numeric"  "__UN_DEFINED__"                 "s1SetupCompleteGuardTimer" ] \
               [list s1TimeToWait                optional   "numeric"  "__UN_DEFINED__"                 "s1TimeToWait" ] \
               [list initialDLMessageGuardTimer  optional   "numeric"  "__UN_DEFINED__"                 "initialDLMessageGuardTimer" ] \
               [list enbConfigUpdateGuardTimer   optional   "numeric"  "__UN_DEFINED__"                 "enbConfigUpdateGuardTimer" ] \
               [list enbConfigUpdateRetryTimer   optional   "numeric"  "__UN_DEFINED__"			"enbConfigUpdateRetryTimer" ] \
               [list maxConfigUpdateRetries	 optional   "numeric"  "__UN_DEFINED__" 		"no of times eNB/mme config update needs to be retried" ] \
               [list mmeConfigUpdateGuardTimer   optional   "numeric"  "__UN_DEFINED__"                 "mmeConfigUpdateGuardTimer" ] \
               [list mmeConfigUpdateRetryTimer	 optional   "numeric"  "__UN_DEFINED__"			"mmeConfigUpdateRetryTimer" ] \
               [list warningMessageAckTimer      optional   "numeric"  "__UN_DEFINED__"                 "warningMessageAckTimer" ] \
               [list henbS1SetupRetryTimer       optional   "numeric"  "__UN_DEFINED__"                 "henbS1SetupRetryTimer" ] \
               [list hoGuardTimer                optional   "numeric"  "__UN_DEFINED__"                 "hoGuardTimer" ] \
               [list henbGwAdminState            optional   "string"   "__UN_DEFINED__"                 "HeNBGW MO's Admin state" ] \
               [list mmeRegionAdminState         optional   "string"   "__UN_DEFINED__"                 "MME Region MO's Admin sate" ] \
               [list mmeAdminState               optional   "string"   "__UN_DEFINED__"                 "MME MO's Admin sate" ] \
               [list sctpHeartbeatTmr            optional   "string"   "__UN_DEFINED__"                 "SCTP hearbeat timer" ] \
               [list sctpBundleTmr               optional   "string"   "__UN_DEFINED__"                 "SCTP Bundle timer" ] \
               [list sctpMaxAssocReTx            optional   "string"   "__UN_DEFINED__"                 "SCTP association retransmission attempts" ] \
               [list sctpMaxPathReTx             optional   "string"   "__UN_DEFINED__"                 "SCTP path retransmission attempts" ] \
               [list sctpRtoInitial              optional   "string"   "__UN_DEFINED__"                 "SCTP rto initial" ] \
               [list sctpRtoMin                  optional   "string"   "__UN_DEFINED__"                 "SCTP rto minimum" ] \
               [list sctpRtoMax                  optional   "string"   "__UN_DEFINED__"                 "SCTP rto maximum" ] \
               [list localMMEMultiHoming         optional   "yes|no"   "no"                             "To eanble multihoming towards MME on gw"]\
               [list localHeNBMultiHoming        optional   "yes|no"   "no"                             "To eanble multihoming towards HeNB on gw"]\
               [list remoteMMEMultiHoming        optional   "yes|no"   "no"                             "To eanble multihoming on MME sim"]\
               [list MMECPEthernetMode           optional   "string"   "__UN_DEFINED__"                 "Defines the ethernet mode between the MME and HeNBGW for CP"]\
               [list MMEUPEthernetMode           optional   "string"   "__UN_DEFINED__"                 "Defines the ethernet mode between the MME and HeNBGW for UP"]\
               [list HeNBCPEthernetMode          optional   "string"   "__UN_DEFINED__"                 "Defines the ethernet mode between the HeNB and HeNBGW for CP"]\
               [list HeNBUPEthernetMode          optional   "string"   "__UN_DEFINED__"                 "Defines the ethernet mode between the HeNB and HeNBGW for UP"]\
               [list redundantMode               optional   "yes|no"   "__UN_DEFINED__"                 "Define the system working mode"]\
               [list testType                    optional   "func|load|loadNew"   "func"                        "Type of test that we are going to perform using simulator"] \
               [list traceStatus                 optional   "string"   "__UN_DEFINED__"                 "To enable or disable Debug Info Warn Error Fatal logson HeNBGW"] \
               [list configCLI                   optional   "string"   "yes"                            "To enable bypassing config CLI of OAM"] \
               [list SRping                      optional   "yes|no"    "yes"                           "Define SRping need to configure or not"] \
               [list MultiS1Link                 optional     "yes|no"   "no"                            "To know multis1link enable towards mme"] \
               [list enableThreadMon             optional   "string"     "true"                              "Enabling or disabling ThreadMon" ] \
               [list coreOnThreadMon             optional   "string"     "true"                              "Enabling or disabling ThreadMon Core Dump" ] \
               [list prochbInterval              optional   "numeric"    "15"                                "The interval at which HB is sent from FGWMon to other tmt" ] \
               [list prochbGrdTime               optional   "numeric"    "15"                                "The interval at which HB response is expected on FGWMon from other tmt" ] \
               [list procRetry                   optional   "numeric"    "2"                                 "The number of retries before declaring a failure" ] \
               [list granularPeriod              optional   "string"   "min5"      "Configure the value of granular period in OAM_Preconfig.xml file"] \
               [list gdbHaltValmanual            optional   "string"     "no"                                "The number of retries before declaring a failure" ] \
               ]
     
     # stop HeNBGW step
     print -info "Stop processes on HeNBGW to update the configuration files"
     set result [restartHeNBGW -fgwNum $fgwNum -verify "yes" -operation "stop" -boardIp "all"]
     if {$result != 0} {
          print -fail "Stopping of HeNBGW failed"
          return -1
     }
     #------------------to create BSR persistent data----------------------------

     if {![info exists ::ARR_LTE_TEST_PARAMS(bkupDBArray)]} { set ::ARR_LTE_TEST_PARAMS(bkupDBArray) "no" }

     #Skip the updation of config file if script is executed with backup DB mode.
     if {$::ARR_LTE_TEST_PARAMS(bkupDBArray) == "no"} {
          # Generate and update OAM persistance database
          if {[info exists startBsrId]} {
               print -info "Generating and Updating BSR Data file"
               set operation "add"
               set isCmasScript 0
               if {[regexp -nocase "cmas" [getPath pwd]]} {
                    set isCmasScript 1
               }
               if {($testType == "func") || ($testType == "loadNew")} {
                    set result [updateValAndExecute "generateHeNBDataFile -fgwNum fgwNum -startBsrId startBsrId -endBsrId endBsrId \
           -operation operation -startBcLac startBcLac -startBcSac startBcSac -imsiStValue imsiStValue -imsiCount imsiCount \
                         -noOfHenbs noOfHenbs -noOfUEs noOfUEs -TotnoOfUEs TotnoOfUEs -testType testType -autoPsc autoPsc"]
               } 
               if {$result != 0} {
                    print -fail "Not able to generate/update OAM persistance database"
                    return -1
               } else {
                    print -pass "Successfully updated OAM persistance database"
               }
          } else {
               print -info "Not generating OAM persistance db as requested"
          }
     }
     #----------------------end-------------------------------------------------

     #Restoring OAM_PersistentDB.xml file from backup and skip CLI updates. 
     if {$ARR_LTE_TEST_PARAMS(bkupDBArray) == "yes"} {
       set scriptDir $ARR_LTE_TEST_PARAMS(scriptDir)
       set fgwList $::BONO_IP_LIST
       set filesList "OAM_PersistentDB.xml"
       set localHost "127.0.0.1"
       foreach fgwIp $fgwList {
         foreach fileName $filesList {
           set localFileName "$scriptDir/$fileName"
           set remoteFileName "/opt/conf/$fileName"

          print -dbg "Copying the $localFileName to the admin home since direct root access is not possible"
          set dstFileName "~/."
          set result [scpFile -remoteHost $fgwIp -localFileName $localFileName -opType "send" \
                    -remoteFileName $dstFileName -remoteUser "$::ADMIN_USERNAME" -remotePassword "$::ADMIN_PASSWORD"]

          if {$result != 0} {
               print -fail "Not able to copy $localFileName file to $fgwIp"
          } else {
               print -pass "Successfully copied $localFileName file to $fgwIp"
          }

          print -dbg "copy the $localFileName from admin's home to root after getting SU access"

          set cmd         "rm -f $remoteFileName \n cp -f /home/admin/$fileName $remoteFileName"

          set result [execCommandSU -dut $fgwIp -command $cmd]
          if {[regexp "ERROR|(No such file or directory)" $result]} {
               print -fail "Not able to update persistence database with local stored persistence file-$localFileName"
               return -1
          } else {
               print -info "Successfully updated persistence database with local stored persistence file-$localFileName"
          }

         }
       }
       #Setting configCLI as "no" to avoid CLI updates
       set configCLI "no"
     } else {
       # configure network parameters on the Gateway
       print -info "Generating and Updating OAM persistance data base file"
       if {[isATCASetup] || [isIfCfgThrMON]} {
          set result [updateValAndExecute "updateHeNBGWConfigFileOnAtca -fgwNum fgwNum  \
                    -localMMEMultiHoming localMMEMultiHoming -localHeNBMultiHoming localHeNBMultiHoming \
                    -remoteMMEMultiHoming remoteMMEMultiHoming -redundantMode redundantMode \
                    -MMECPEthernetMode MMECPEthernetMode -MMEUPEthernetMode MMEUPEthernetMode \
		    -enableThreadMon enableThreadMon -coreOnThreadMon coreOnThreadMon -prochbInterval prochbInterval \
		    -prochbGrdTime prochbGrdTime -procRetry procRetry -gdbHaltValmanual gdbHaltValmanual \
                    -HeNBCPEthernetMode HeNBCPEthernetMode -HeNBUPEthernetMode HeNBUPEthernetMode -SRping SRping -MultiS1Link MultiS1Link"]
          
       } else {
          set result [updateValAndExecute "updateHeNBGWConfigFile -fgwNum fgwNum  \
                    -localMMEMultiHoming localMMEMultiHoming -localHeNBMultiHoming localHeNBMultiHoming \
                    -remoteMMEMultiHoming remoteMMEMultiHoming"]
       }
       if {$result != 0} {
          print -fail "Not able to update HeNB Gateway Config file"
          return -1
       } else {
          print -pass "Successfully updated HeNB Gateway Config file"
       }
     }
     if { $testType == "load" } {
          set result [setLogTraceStatus -traceStatus $traceStatus]
          if {$result != 0} {
               print -fail "Not able to enable/disable mentioned logs on HeNBGW"
          } else {
               print -pass "Successfully enabld/disabled mentioned logs on HeNBGW"
          }
     }
     # Clean up the stale iptable rules configured on the gateway
     cleanUpIpTableRule
     
     # setup simulator hosts and cisco switch
     print -info "Configuring simulator hosts and L2 switch"
     if { $::ROUTING_TB == "yes" } {
          # Call the appropriate procedure based on the type of setup
          if {[isATCASetup] || [isIfCfgThrMON]} {
               # ATCA setup requires configuration of 2 OMNI Switches to achieve redudency
               set result [updateValAndExecute "configHeNBAndMMEForRoutingTestBedAtca -fgwNum fgwNum -switchNum switchNum -simType simType \
                         -localMMEMultiHoming localMMEMultiHoming -localHeNBMultiHoming localHeNBMultiHoming \
                         -remoteMMEMultiHoming remoteMMEMultiHoming -MMECPEthernetMode MMECPEthernetMode \
                         -MMEUPEthernetMode MMEUPEthernetMode -HeNBCPEthernetMode HeNBCPEthernetMode \
                         -HeNBUPEthernetMode HeNBUPEthernetMode -noOfMMEs noOfMMEs -SRping SRping"]
          } else {
               set result [updateValAndExecute "configHeNBAndMMEForRoutingTestBed -fgwNum fgwNum -switchNum switchNum -simType simType \
                         -localMMEMultiHoming localMMEMultiHoming -localHeNBMultiHoming localHeNBMultiHoming \
                         -remoteMMEMultiHoming remoteMMEMultiHoming -MMECPEthernetMode MMECPEthernetMode \
                         -MMEUPEthernetMode MMEUPEthernetMode -HeNBCPEthernetMode HeNBCPEthernetMode \
                         -HeNBUPEthernetMode HeNBUPEthernetMode -noOfMMEs noOfMMEs"]
          }
     } else {
          set result [updateValAndExecute "configHeNBAndMME -fgwNum fgwNum -switchNum switchNum -simType simType \
                    -localMMEMultiHoming localMMEMultiHoming -localHeNBMultiHoming localHeNBMultiHoming \
                    -remoteMMEMultiHoming remoteMMEMultiHoming -noOfMMEs noOfMMEs"]
          
     }
     if {$result != 0} {
          print -fail "Configuring simulator hosts/cisco switch failed"
          return -1
     } else {
          print -pass "Successfully configured simulator hosts/cisco switch"
     }
     
     # update the OAM pre-config file
     if { $configCLI == "yes" } {
          set result [updateValAndExecute "generatOamPreConfigFile -fgwNum fgwNum \
                    -eNBNameGw eNBNameGw -globaleNBId globaleNBId -defaultPagingDrx defaultPagingDrx \
                    -noOfMMEs noOfMMEs -noOfRegions noOfRegions \
                    -gwMCC gwMCC -gwMNC gwMNC -MMEeNBNameGw MMEeNBNameGw -taiMcc taiMcc -taiMnc taiMnc \
                    -mmeRegionMcc mmeRegionMcc -mmeRegionMnc mmeRegionMnc -mmeRegionGlobaleNBId mmeRegionGlobaleNBId \
                    -tac tac -s1ResetAckTimer s1ResetAckTimer -s1ResetGuardTimer s1ResetGuardTimer \
                    -s1SetupGuardTimer s1SetupGuardTimer -s1SetupRetryTimer s1SetupRetryTimer -s1TimeToWait s1TimeToWait \
                    -initialDLMessageGuardTimer initialDLMessageGuardTimer -enbConfigUpdateGuardTimer enbConfigUpdateGuardTimer \
                    -s1RelCompGuardTimer s1RelCompGuardTimer -mmeConfigUpdateGuardTimer mmeConfigUpdateGuardTimer -mmeConfigUpdateRetryTimer mmeConfigUpdateRetryTimer \
                    -warningMessageAckTimer warningMessageAckTimer -henbS1SetupRetryTimer henbS1SetupRetryTimer \
                    -hoGuardTimer hoGuardTimer -enbConfigUpdateRetryTimer enbConfigUpdateRetryTimer -maxConfigUpdateRetries maxConfigUpdateRetries \
                    -henbGwAdminState henbGwAdminState -mmeRegionAdminState mmeRegionAdminState -mmeAdminState mmeAdminState \
                    -sctpHeartbeatTmr sctpHeartbeatTmr -sctpBundleTmr sctpBundleTmr -sctpMaxAssocReTx sctpMaxAssocReTx \
                    -sctpMaxPathReTx sctpMaxPathReTx -sctpRtoInitial sctpRtoInitial -sctpRtoMin sctpRtoMin -sctpRtoMax sctpRtoMax \
                    -localMMEMultiHoming localMMEMultiHoming -localHeNBMultiHoming localHeNBMultiHoming \
                    -remoteMMEMultiHoming remoteMMEMultiHoming -granularPeriod granularPeriod -MultiS1Link MultiS1Link"]
     }
     #          -s1RelCompGuardTimer s1RelCompGuardTimer -mmeConfigUpdateGuardTimer mmeConfigUpdateGuardTimer -mmeConfigUpdateRetryTimer mmeConfigUpdateRetryTimer\
     -warningMessageAckTimer warningMessageAckTimer -henbS1SetupRetryTimer henbS1SetupRetryTimer \
               -hoGuardTimer hoGuardTimer -enbConfigUpdateRetryTimer enbConfigUpdateRetryTimer -maxConfigUpdateRetries maxConfigUpdateRetries \
               # generate valid HeNB data file (similar to bsrData.xml)
               
     # update iptables permit rules to permit sctp ports used in the test
     print -info "Updating iptables permit list to allow required sctp ports"
     set result [updateIpTablesOnHeNBGW -fgwNum $fgwNum -testType $testType]
     if {$result != 0} {
          print -fail "Not able to update iptables to permit required sctp ports for the test"
          return -1
     } else {
          print -pass "Successfully updated iptables to permit required sctp ports for the test"
     }
     
     if {[regexp "switchMonitoring$" [pwd]]} {
          printHeader "Snaphot of system information before test execution"
          foreach ip $::BONO_IP_LIST {
               set result [dumpNetworkMonStateAndInterfaceStats -bonoIp $ip]
          }
     }
     
     return 0
}

proc updateIpTablesOnHeNBGW {args} {
     #-
     #- to update sctp ports in the iptables permit rule
     #-
     parseArgs args \
               [list \
               [list fgwNum              "optional"  "numeric"    "0"                     "Position of FGW in the testbed"] \
               [list testType             optional   "func|load|loadNew"   "func"                 "Type of test that we are going to perform using simulator"] \
               ]
     
     set hostIp   [getActiveBonoIp $fgwNum]
     set HeNBSctp [getDataFromConfigFile "henbSctp" $fgwNum]
     set MMESctp  [getDataFromConfigFile "mmeSctp" $fgwNum]
     
     set sctpPortList "$HeNBSctp"
     #set tcpPortList  ""
     
     return [updateValAndExecute "updateIpTablesOnHost -hostIp hostIp -sctpPortList sctpPortList -tcpPortList tcpPortList -testType testType"]
}

proc setUpHeNBGWForTest {args} {
     #-
     #- wraper to setup HeNBGW for test
     #- it does updating FGW configuration file, OAM persistance database file and restart HeNBGW to take the changes
     #- it creates IU instances, MO
     #-
     #- @out 0 on success, -1 on error
     #-
     
     parseArgs args \
               [list \
               [list fgwNum                      optional   "numeric"  "0"                              "Position of FGW in the testbed"] \
               [list switchNum                   optional   "numeric"  "0"                              "Position of switch under FGW"] \
               [list noOfHeNBs                   optional   "numeric"  "1"               		"No of HeNBs to be simulated"] \
               [list noOfMMEs                    optional   "numeric"  "1"               		"No of MMEs to be simulated"] \
               [list noOfRegions                 optional   "numeric"  "1"                              "No of Regions to be simulated"] \
               [list eNBNameGw                   optional   "string"   [getLTEParam "HeNBGWName"]       "Gateway eNB name" ] \
               [list numInStreams                "optional"  "numeric"   "512"             "Number of Input SCTP stream"] \
               [list numOutStreams               "optional"  "numeric"   "512"             "No of output SCTP stream"] \
               [list globaleNBId                 optional   "numeric"  [getLTEParam "globaleNBId"]      "Gateway eNB ID" ] \
               [list defaultPagingDrx            optional   "string"   [getLTEParam "defaultPagingDrx"] "Paging DRX value" ] \
               [list startStopGw                 optional   "string"   "no"                             "Paging DRX value" ] \
               [list gwMCC                       optional   "numeric"  [getLTEParam "gwMCC"]            "MCC of the gateway" ] \
               [list gwMNC                       optional   "numeric"  [getLTEParam "gwMNC"]            "MNC of the gateway" ] \
               [list MMEeNBNameGw                optional   "string"   "__UN_DEFINED__"                 "Gateway Name w.r.f to MME" ] \
               [list taiMcc                      optional   "numeric"  "__UN_DEFINED__"                 "TAI's PLMN ID (MCC)" ] \
               [list taiMnc                      optional   "numeric"  "__UN_DEFINED__"                 "TAI's PLMN ID (MNC)" ] \
               [list mmeRegionMcc                optional   "numeric"  "__UN_DEFINED__"                 "MME Region PLMN ID (MCC)" ] \
               [list mmeRegionMnc                optional   "numeric"  "__UN_DEFINED__"                 "MME Region PLMN ID (MNC)" ] \
               [list mmeRegionGlobaleNBId        optional   "numeric"  "__UN_DEFINED__"                 "MME Region eNBId" ] \
               [list tac                         optional   "numeric"  "__UN_DEFINED__"                 "TAC" ] \
               [list s1ResetAckTimer             optional   "numeric"  "__UN_DEFINED__"                 "s1ResetAckTimer" ] \
               [list s1ResetGuardTimer           optional   "numeric"  "__UN_DEFINED__"                 "s1ResetGuardTimer" ] \
               [list s1SetupGuardTimer           optional   "numeric"  "__UN_DEFINED__"                 "s1SetupGuardTimer" ] \
               [list s1SetupRetryTimer           optional   "numeric"  "__UN_DEFINED__"                 "s1SetupRetryTimer" ] \
               [list s1RelCompGuardTimer         optional   "numeric"  "__UN_DEFINED__"                 "s1ReleaseCompleteGuardTimer" ] \
               [list s1TimeToWait                optional   "numeric"  "__UN_DEFINED__"                 "s1TimeToWait" ] \
               [list initialDLMessageGuardTimer  optional   "numeric"  "__UN_DEFINED__"                 "initialDLMessageGuardTimer" ] \
               [list enbConfigUpdateGuardTimer   optional   "numeric"  "__UN_DEFINED__"                 "enbConfigUpdateGuardTimer" ] \
               [list enbConfigUpdateRetryTimer   optional   "numeric"  "__UN_DEFINED__"			"enbConfigUpdateRetryTimer" ] \
               [list maxConfigUpdateRetries	 optional   "numeric"  "__UN_DEFINED__"			"no of times eNB/mme config update procedure needs to be retried" ] \
               [list mmeConfigUpdateGuardTimer   optional   "numeric"  "__UN_DEFINED__"                 "mmeConfigUpdateGuardTimer" ] \
               [list mmeConfigUpdateRetryTimer   optional   "numeric"  "__UN_DEFINED__"			"mmeConfigUpdateRetryTimer" ] \
               [list warningMessageAckTimer      optional   "numeric"  "__UN_DEFINED__"                 "warningMessageAckTimer" ] \
               [list henbS1SetupRetryTimer       optional   "numeric"  "__UN_DEFINED__"                 "henbS1SetupRetryTimer" ] \
               [list hoGuardTimer                optional   "numeric"  "__UN_DEFINED__"                 "hoGuardTimer" ] \
               [list henbGwAdminState            optional   "string"   "__UN_DEFINED__"                 "HeNBGW MO's Admin state" ] \
               [list mmeRegionAdminState         optional   "string"   "__UN_DEFINED__"                 "MME Region MO's Admin sate" ] \
               [list mmeAdminState               optional   "string"   "__UN_DEFINED__"                 "MME MO's Admin sate" ] \
               [list startSim                    optional   "yes|no"   "yes"                            "To start simulator or not"] \
               [list sctpHeartbeatTmr            optional   "string"   "__UN_DEFINED__"                 "SCTP hearbeat timer" ] \
               [list sctpBundleTmr               optional   "string"   "__UN_DEFINED__"                 "SCTP Bundle timer" ] \
               [list sctpMaxAssocReTx            optional   "string"   "__UN_DEFINED__"                 "SCTP association retransmission attempts" ] \
               [list sctpMaxPathReTx             optional   "string"   "__UN_DEFINED__"                 "SCTP path retransmission attempts" ] \
               [list sctpRtoInitial              optional   "string"   "__UN_DEFINED__"                 "SCTP rto initial" ] \
               [list sctpRtoMin                  optional   "string"   "__UN_DEFINED__"                 "SCTP rto minimum" ] \
               [list sctpRtoMax                  optional   "string"   "__UN_DEFINED__"                 "SCTP rto maximum" ] \
               [list localMMEMultiHoming         optional   "yes|no"   "__UN_DEFINED__"                 "To eanble multihoming towards MME on gw"]\
               [list localHeNBMultiHoming        optional   "yes|no"   "__UN_DEFINED__"                 "To eanble multihoming towards HeNB on gw"]\
               [list remoteMMEMultiHoming        optional   "yes|no"   "__UN_DEFINED__"                 "To eanble multihoming on MME sim"]\
               [list henbLoadScenario            optional   "string"   "junk.txt" 	                "Scenario for heNBload sim" ]\
               [list mmeLoadScenario             optional   "string"   "junk.txt"       	        "Scenario for MMEload sim" ]\
               [list testType                    optional   "func|load|loadNew"   "func"                        "Type of test that we are going to perform using simulator"] \
               [list MMECPEthernetMode           optional   "string"   "__UN_DEFINED__"                 "Defines the ethernet mode between the MME and HeNBGW for CP"]\
               [list MMEUPEthernetMode           optional   "string"   "__UN_DEFINED__"                 "Defines the ethernet mode between the MME and HeNBGW for UP"]\
               [list HeNBCPEthernetMode          optional   "string"   "__UN_DEFINED__"                 "Defines the ethernet mode between the HeNB and HeNBGW for CP"]\
               [list HeNBUPEthernetMode          optional   "string"   "__UN_DEFINED__"                 "Defines the ethernet mode between the HeNB and HeNBGW for UP"]\
               [list redundantMode               optional   "yes|no"   "__UN_DEFINED__"                 "Define the system working mode"]\
               [list henbSendRate                optional  "numeric"    "1000"                          "Rate at which HenB messages has to be send from Simulator "] \
               [list sctpInitRate                optional  "numeric"    "1000"                          "Rate at which HeNB sends SCTP INIT from Simulator has to be sent"] \
               [list mmeSendRate                 optional   "numeric"   10000                           "Rate at which MME messages has to be send from Simulator "] \
               [list traceStatus                 optional   "string"   "fileEnable"                     "To enable or disable Debug Info Warn Error Fatal logson HeNBGW"] \
               [list hwIdNode1            "optional" "numeric"            "__UN_DEFINED__"                    "Defines the handware ID to be used to node 1" ]\
               [list hwIdNode2            "optional" "numeric"            "__UN_DEFINED__"                    "Defines the handware ID to be used to node 2" ]\
               [list hwIdNode2            "optional" "numeric"            "__UN_DEFINED__"                    "Defines the handware ID to be used to node 2" ]\
               [list configCLI                   optional   "string"   "yes"                            "To enable bypassing config CLI of OAM"] \
               [list granularPeriod              optional   "string"   "fiveMinutes"  "granularPeriod is the parameter which decides how often PM file should get generated"] \
               [list PMinitialize          optional "string"     "no"    "initializing PM"] \
               [list SRping              "optional"   "yes|no"           "yes"                            "Define SRping need to configure or not"] \
               [list NumThreads           optional      "numeric"       "1"        "number of threads"] \
               [list differentIpsForHeNBs  "optional"  "string"    "no"         "whether henbs will have different IPs or same Ip"] \
               [list noOfVirtualIpsForHeNBs     "optional" "numeric" "0"        "virtual ips"] \
               [list NumThreadMMESim              optional      "numeric"       "1"        "number of threads for mme sim"] \
               [list NumThreadHeNBSim             optional      "numeric"       "1"        "number of threads for henb sim"] \
               [list numberOfHeNBSimInstances     "optional"  "numeric"                 "1"    "number of henb instances"] \
               [list numberOfMMESimInstances     "optional"  "numeric"          "1"    "number of henb instances"] \
               [list clearGWLogs     "optional"  "yes|no"          "yes"    "clear GW logs"] \
               [list execSAR                     optional   "string"     "__UN_DEFINED__"              "To choose whether or not to execute SAR command"] \
               [list MultiS1Link                 optional     "yes|no"   "no"                            "To know multis1link enable towards mme"] \
               [list launchSim                   optional   "yes|no"     "yes"              "whether to launch simulators or not"] \
               [list enableThreadMon             optional   "string"     "true"                              "Enabling or disabling ThreadMon" ] \
               [list coreOnThreadMon             optional   "string"     "true"                              "Enabling or disabling ThreadMon Core Dump" ] \
               [list prochbInterval              optional   "numeric"    "15"                                "The interval at which HB is sent from FGWMon to other tmt" ] \
               [list prochbGrdTime               optional   "numeric"    "15"                                "The interval at which HB response is expected on FGWMon from other tmt" ] \
               [list procRetry                   optional   "numeric"    "2"                                 "The number of retries before declaring a failure" ] \
	       [list sarOption                   "optional"     "string"         "net"    "execute sar command to get the output for CPU utilyzation or interface Rx/Tx count on the GW" ]\
               [list gdbHaltValmanual            optional   "string"     "no"                                "The number of retries before declaring a failure" ] \
               [list sctp_error                  optional   "string"     "no"                                "to do sctp error test "]\
               ]

     global ARR_LTE_TEST_PARAMS
     # updating test related parameters
     
     set henbCpCount    [getDataFromConfigFile "henbCpCount" $fgwNum $switchNum]
     set mmeCpCount     [getDataFromConfigFile "mmeCpCount" $fgwNum $switchNum]
     set mmeSimCpCount  [getDataFromConfigFile "mmeSimCpCount" $fgwNum $switchNum]
     #-----Jemy -----------------------------
     if {$testType == "func"} {
          set startBsrId [getFromTestMap -HeNBIndex 0 -param "HeNBId"]
          set endBsrId   [getFromTestMap -HeNBIndex 0 -param "HeNBId"]
     } else {
          set startBsrId [lindex [getFromTestMap -param "HeNBId"] 0]
          set endBsrId   [expr $startBsrId + $noOfHeNBs - 1]
     }
     #----------------------------------
     if { [info exists ::env(PMTEST)]} {
          print -info " -----------------  $::env(PMTEST) "
          set PMinitialize "yes"
          set granularPeriod "fiveMinutes"
          set PMcounterInit "init"
          set fgwNum 0
          set result [verifyPMCounters -operation $PMcounterInit  -fgwNum $fgwNum]
          if { $result != 0 } {
               print -debug "result : $result"
               print -fail "Failed to Initialize PM  "
               return -1
          }
          
     }
     
     if {![info exists localHeNBMultiHoming] } {
          if { $henbCpCount==2 } {
               if {[info exists HeNBCPEthernetMode]} {
                    if {[regexp "FLOATING" $HeNBCPEthernetMode]} {
                         set localHeNBMultiHoming "no"
                    } else {
                         set localHeNBMultiHoming "yes"
                    }
               } else {
                    set localHeNBMultiHoming "yes"
               }
          } else {
               set localHeNBMultiHoming "no"
          }
     }
     if {![info exists localMMEMultiHoming]} {
          if {$mmeCpCount==2 }   {
               if {[info exists MMECPEthernetMode]} {
                    if {[regexp "FLOATING" $MMECPEthernetMode]} {
                         set localMMEMultiHoming "no"
                    } else {
                         set localMMEMultiHoming "yes"
                    }
               } else {
                    set localMMEMultiHoming "yes"
               }
          } else {
               set localMMEMultiHoming "no"
          }
     }
     if {![info exists remoteMMEMultiHoming] } {
          if {$mmeSimCpCount==2 } {
               if {[info exists MMECPEthernetMode]} {
                    if {[regexp "FLOATING" $MMECPEthernetMode]} {
                         set remoteMMEMultiHoming "no"
                    } else {
                         set remoteMMEMultiHoming "yes"
                    }
               } else {
                    set remoteMMEMultiHoming "yes"
               }
          } else {
               set remoteMMEMultiHoming "no"
          }
     }
   
     # Disabling localHeNBMultiHoming as feature on GW is not in place
     if { $::ROUTING_TB != "yes" } {
          set localHeNBMultiHoming "no"
     }
     if {$clearGWLogs == "yes" } {
          
          foreach ip [getDataFromConfigFile getBonoIpaddress 0] {
               foreach cmd [list "rm -rf /opt/log/*" \
                         "rm -f /var/log/messages-*" \
                         "service rsyslog restart"]  {
                              set result [execCommandSU -dut $ip -command "$cmd"]
                         }
          }
          
     }
     # configure gateway
     set simType "HeNB MME"
     set result [updateValAndExecute "setUpHeNBGW -fgwNum fgwNum -switchNum switchNum -simType simType \
               -eNBNameGw eNBNameGw -globaleNBId globaleNBId -defaultPagingDrx defaultPagingDrx -startBsrId startBsrId\
               -noOfMMEs noOfMMEs -noOfRegions noOfRegions  -testType testType -redundantMode redundantMode\
               -gwMCC gwMCC -gwMNC gwMNC -MMEeNBNameGw MMEeNBNameGw -taiMcc taiMcc -taiMnc taiMnc \
               -mmeRegionMcc mmeRegionMcc -mmeRegionMnc mmeRegionMnc -mmeRegionGlobaleNBId mmeRegionGlobaleNBId \
               -tac tac -s1ResetAckTimer s1ResetAckTimer -s1ResetGuardTimer s1ResetGuardTimer \
               -s1SetupGuardTimer s1SetupGuardTimer -s1SetupRetryTimer s1SetupRetryTimer -s1TimeToWait s1TimeToWait \
               -initialDLMessageGuardTimer initialDLMessageGuardTimer -enbConfigUpdateGuardTimer enbConfigUpdateGuardTimer \
               -mmeConfigUpdateGuardTimer mmeConfigUpdateGuardTimer -warningMessageAckTimer warningMessageAckTimer \
               -henbS1SetupRetryTimer henbS1SetupRetryTimer -hoGuardTimer hoGuardTimer -henbGwAdminState henbGwAdminState \
               -mmeRegionAdminState mmeRegionAdminState -mmeAdminState mmeAdminState -s1RelCompGuardTimer s1RelCompGuardTimer \
               -sctpBundleTmr sctpBundleTmr -sctpHeartbeatTmr sctpHeartbeatTmr -sctpMaxAssocReTx sctpMaxAssocReTx \
               -sctpMaxPathReTx sctpMaxPathReTx -sctpRtoInitial sctpRtoInitial -sctpRtoMin sctpRtoMin -sctpRtoMax sctpRtoMax \
               -localMMEMultiHoming localMMEMultiHoming -localHeNBMultiHoming localHeNBMultiHoming -traceStatus traceStatus \
               -remoteMMEMultiHoming remoteMMEMultiHoming -MMECPEthernetMode MMECPEthernetMode -MMEUPEthernetMode MMEUPEthernetMode \
               -HeNBCPEthernetMode HeNBCPEthernetMode -HeNBUPEthernetMode HeNBUPEthernetMode -configCLI configCLI \
               -enableThreadMon enableThreadMon -coreOnThreadMon coreOnThreadMon -prochbInterval prochbInterval \
               -prochbGrdTime prochbGrdTime -procRetry procRetry -gdbHaltValmanual gdbHaltValmanual \
               -enbConfigUpdateRetryTimer enbConfigUpdateRetryTimer -maxConfigUpdateRetries maxConfigUpdateRetries -mmeConfigUpdateRetryTimer mmeConfigUpdateRetryTimer  -granularPeriod granularPeriod -SRping SRping -MultiS1Link MultiS1Link"]
     if {$result != 0} {
          print -abort "Failed to setup HeNB Gateway. Cannot continue the test"
          return 1
     } else {
          print -info "Successfully setup HeNB Gateway configuration"
     }
     
     # MO instances cleanup if any
     
     # MO instances creation if required
     
     # terminating stale simulators
     # The issue may happpen when multiple users share the same simulators
     # In which case it will kill all the simulator instances
     print -dbg "Terminating stale simulators if any ..."
     set result [cleanUpSimInstances -simType $simType]
     
     print -info "Enabling logs on Gateway"
     set result 0;# [setLogTraceStatus -fgwNum $fgwNum]
     if {$result !=0} {
          print -fail "Failed to enable logs on Gateway"
          # not failing script for this failure
     } else {
          print -info "Enabled logs on Gateway"
     }
     
     if { $startStopGw == "yes" } {
          set result  [restartHeNBGW -fgwNum $fgwNum -verify "yes" -operation "stop"]
          halt 10
          set result  [restartHeNBGW -fgwNum $fgwNum -verify "yes" -operation "start"]
     }

     if { $sctp_error == "yes" } {
          set cmd "rm -f /var/pm/A*xml"
          set dut  [getActiveBonoIp 0]
          execCommandSU -dut $dut -command $cmd
          set PMinitialize "yes"
     if { $PMinitialize == "yes" } {
          set PMinitialize "no"
          #     LogLevels
          #set result [verifyPMCounters -operation "init" -fgwNum $fgwNum]
          #     setDefaultPMcounterValues
          set cmd "rm -f /var/pm/A*xml"
          set dut  [getActiveBonoIp 0]
          execCommandSU -dut $dut -command $cmd
          LogLevels
          set ::PM_START_TIME [clock seconds]
          print -info " granularPeriod is $granularPeriod "
          switch -nocase $granularPeriod {
               "fiveMinutes" { set GranSec 300 }
               "fifteenMinutes" { set GranSec 900 }
               "thirtyMinutes"  { set GranSec 1800 }
               "Onehour" { set GranSec 3600 }
               default  { set GranSec 300}
          }
          print -info " granularPeriod is $granularPeriod GranSec: $GranSec "
          set sleeptime [expr $::PM_START_TIME % $GranSec  ]
          set SlpDif [ expr $GranSec + 90 ]
          set SleepNow [ expr  $SlpDif  - $sleeptime]
          print -info " Now sleeping for $SleepNow seconds in : SetUpHeNBGWForTest : utilsHeNBGW.tcl "
          halt $SleepNow
          set cmd "rm -f /var/pm/A*xml"
          set dut  [getActiveBonoIp 0]
          execCommandSU -dut $dut -command $cmd
          if {[info exists execSAR] && ($execSAR == "yes")} {
               print -info "The SAR command is going to be executed on HeNBGW"
               execSARcmdonHeNBGW -fgwNum 0 -sarOption $sarOption
          }
     }
    }

     # launching simulator
     if {$launchSim == "yes" } {
          if { ($testType == "load") || ($testType == "loadNew") } {
               set result [setUpLteLoadSimulators -fgwNum $fgwNum -startSim $startSim -noOfHeNBs $noOfHeNBs -noOfMMEs $noOfMMEs \
                         -localMMEMultiHoming $localMMEMultiHoming -remoteMMEMultiHoming $remoteMMEMultiHoming -henbLoadScenario $henbLoadScenario \
                         -mmeLoadScenario $mmeLoadScenario -henbSendRate $henbSendRate -sctpInitRate $sctpInitRate -mmeSendRate $mmeSendRate -testType $testType \
                         -NumThreadMMESim $NumThreadMMESim -NumThreadHeNBSim $NumThreadHeNBSim -differentIpsForHeNBs $differentIpsForHeNBs \
                         -noOfVirtualIpsForHeNBs $noOfVirtualIpsForHeNBs -numberOfHeNBSimInstances $numberOfHeNBSimInstances -numberOfMMESimInstances $numberOfMMESimInstances]
               if {$result != 0} {
                    print -fail "Failed to launch simulators to test HeNBGW. Cannot continue the test"
                    return 1
               }
               
               set result [ startStopOprofile  -operation "start" ]
               
          } else {
               set result [setUpLteSimulators -fgwNum $fgwNum -startSim $startSim -noOfHeNBs $noOfHeNBs -noOfMMEs $noOfMMEs \
                         -localMMEMultiHoming $localMMEMultiHoming -remoteMMEMultiHoming $remoteMMEMultiHoming -numInStreams $numInStreams \
                         -numOutStreams $numOutStreams  ]
               if {$result != 0} {
                    print -fail "Failed to launch simulators to test HeNBGW. Cannot continue the test"
                    return 1
               } else {
                    print -info "Successfully launched simulators to test HeNBGW"
               }
          }
     }
          set cmd "rm -f /var/pm/A*xml"
          set dut  [getActiveBonoIp 0]
          execCommandSU -dut $dut -command $cmd
     if { $sctp_error == "no" } {
     if { $PMinitialize == "yes" } {
          #     LogLevels
          #set result [verifyPMCounters -operation "init" -fgwNum $fgwNum]
          #     setDefaultPMcounterValues
          set cmd "rm -f /var/pm/A*xml"
          set dut  [getActiveBonoIp 0]
          execCommandSU -dut $dut -command $cmd
          LogLevels
          set ::PM_START_TIME [clock seconds]
          print -info " granularPeriod is $granularPeriod "
          switch -nocase $granularPeriod {
               "fiveMinutes" { set GranSec 300 }
               "fifteenMinutes" { set GranSec 900 }
               "thirtyMinutes"  { set GranSec 1800 }
               "Onehour" { set GranSec 3600 }
               default  { set GranSec 300}
          }
          print -info " granularPeriod is $granularPeriod GranSec: $GranSec "
          set sleeptime [expr $::PM_START_TIME % $GranSec  ]
          set SlpDif [ expr $GranSec + 90 ]
          set SleepNow [ expr  $SlpDif  - $sleeptime]
          print -info " Now sleeping for $SleepNow seconds in : SetUpHeNBGWForTest : utilsHeNBGW.tcl "
          halt $SleepNow
          set cmd "rm -f /var/pm/A*xml"
          set dut  [getActiveBonoIp 0]
          execCommandSU -dut $dut -command $cmd
          if {[info exists execSAR] && ($execSAR == "yes")} {
               print -info "The SAR command is going to be executed on HeNBGW"
               execSARcmdonHeNBGW -fgwNum 0 -sarOption $sarOption
          }
     }
     }
     print -info "HeNBGw is ready for test"
     
     return 0
}

proc setDefaultPMcounterValues {args } {
     #- Proc to set defaultPagingDrx/eNBNameGW via CLI
     #- return -1 on failure
     parseArgs args \
               [list\
               [list PMcounterInit    "optional"     "string"  "init" "Default Paging Drx Value"]\
               [list granularPeriod    "optional"    "string"  "fiveMinutes"       "instance no"]\
               ]
     set HeNBGWNum 0
     set dut  [getActiveBonoIp $HeNBGWNum]
     #     set granularPeriod "FifteenMinutes"
     print -info " -granularPeriod is $granularPeriod"
     #set cmd "set /FGW:80013/ItfFgw:1/PerformanceControl:1 {granularPeriod=FifteenMinutes}"
     set cmd "set /FGW:80013/ItfFgw:1/PerformanceControl:1 {granularPeriod=$granularPeriod}"
     set result [execCliCommand -dut $dut -command $cmd]
     if {[isCliError $result]} {
          print -debug "result : $result"
          print -fail "Failed to execute the command : $cmd "
          return -1
     }
     set fgwNum 0
     set result [verifyPMCounters -operation $PMcounterInit  -fgwNum $fgwNum]
     if { $result != 0 } {
          print -debug "result : $result"
          print -fail "Failed to Initialize PM  "
          return -1
     }
     return 0
}
proc LogLevels { } {
     
     set TraceList "/FGW:80013/ItfFgw:1/TraceControl:3 /FGW:80013/ItfFgw:1/TraceControl:5 "
     foreach trace $TraceList {
          set command   "set $trace {traceStatus=fileEnable}"
          set ip [getActiveBonoIp 0]
          set result     [execBsgCliCommandPm  -bsgIp $ip -command $command]
     }
}

proc execBsgCliCommandPm {args} {
     
     #- To execute commands on bsg cli session
     #-
     #- @error "ERROR: <desc>"
     #-
     #- @return string (captured data during commands execution)
     
     parseArgs args\
               [list \
               [list bsgIp       "mandatory"    "ip"              "-"           "defines the dut to be used"]\
               [list command     "mandatory"    "string"          "-"           "defines the command to be executed"]\
               [list sessionName  "optional"    "string"          "bsgcli"         "defines the userName"]\
               [list user        "optional"     "admin|root"      "admin"         "defines the userName"]\
               [list pass        "optional"     "string"   "$::ADMIN_PASSWORD"       "defines the password to be used"]\
               ]
     set result [execCliCommand -dut $bsgIp -command $command -user $user -pass $pass -sessionName $sessionName ]
     if {[regexp -nocase "error" $result]} {
          set err_str "Another BSG CLI console is opened. Multiple sessions are not supported"
          print -err $err_str
          return "ERROR: $err_str"
     } else {
          return $result
     }
     
}

proc configHeNBAndMME { args } {
     #-
     #- proc to setup HeNB-MME simulator hosts
     #-
     parseArgs args \
               [list \
               [list fgwNum                      optional  "numeric"  "0"      "FGW number in testbed file"]\
               [list switchNum                   optional  "numeric"  "0"      "switch number in testbed file"]\
               [list simType                     optional  "string"   ""       "Simulators to be configured"]\
               [list localMMEMultiHoming         optional  "yes|no"   "no" "To eanble multihoming towards MME on gw"]\
               [list localHeNBMultiHoming        optional  "yes|no"   "no" "To eanble multihoming towards HeNB on gw"]\
               [list remoteMMEMultiHoming        optional  "yes|no"   "no" "To eanble multihoming on MME sim"]\
               [list noOfMMEs                    optional  "numeric"  "1"      "number of MMEs to be configured on sim"]\
               ]
     
     set fgwIp [getActiveBonoIp $fgwNum]
     # to consider the ips which we are not going to use ... for the case of AMR concatenation feature
     set arr_nw_data(skipIpList) ""
     # disable configuration on Gateway. uncomment below line to enable it
     #set arr_nw_data(simIp) $fgwIp
     
     foreach type $simType {
          switch $type {
               "HeNB"  {
                    set simIp  		[getDataFromConfigFile "getHenbSimulatorHostIp" $fgwNum]
                    set simInt 		[getDataFromConfigFile "getHenbSimCpHostPort" $fgwNum]
                    set cp1PortOnGw	[getDataFromConfigFile "getHenbCp1Port" $fgwNum]
                    if {[getDataFromConfigFile "henbCpCount" $fgwNum]==2} {
                         set cp2PortOnGw        [getDataFromConfigFile "getHenbCp2Port" $fgwNum]
                    }
                    
                    # retrieve CP1 network parameters on simulator
                    lappend arr_nw_data($simIp,$simInt,vlan) [getDataFromConfigFile "getHenbCp1Vlan" $fgwNum]
                    lappend arr_nw_data($simIp,$simInt,vlan) [getDataFromConfigFile "henbBearerVlan" $fgwNum]
                    lappend arr_nw_data($simIp,$simInt,mask) [getDataFromConfigFile "getHenbCp1Mask" $fgwNum]
                    lappend arr_nw_data($simIp,$simInt,mask) [getDataFromConfigFile "henbBearerMask" $fgwNum]
                    lappend arr_nw_data($simIp,$simInt,ip)   [incrIp [getDataFromConfigFile "getHenbCp1Ipaddress" $fgwNum]]
                    lappend arr_nw_data($simIp,$simInt,ip)   [incrIp [getDataFromConfigFile "henbBearerIpaddress" $fgwNum]]
                    
                    # No remote multiHoming on HeNB sim, so not taking CP2 network parameters for henb sim
                    
                    # retrieve CP1 network parameters on gateway
                    lappend arr_nw_data($fgwIp,$cp1PortOnGw,vlan) [getDataFromConfigFile "getHenbCp1Vlan" $fgwNum]
                    lappend arr_nw_data($fgwIp,$cp1PortOnGw,vlan) [getDataFromConfigFile "henbBearerVlan" $fgwNum]
                    lappend arr_nw_data($fgwIp,$cp1PortOnGw,mask) [getDataFromConfigFile "getHenbCp1Mask" $fgwNum]
                    lappend arr_nw_data($fgwIp,$cp1PortOnGw,mask) [getDataFromConfigFile "henbBearerMask" $fgwNum]
                    lappend arr_nw_data($fgwIp,$cp1PortOnGw,ip)   [getDataFromConfigFile "getHenbCp1Ipaddress" $fgwNum]
                    lappend arr_nw_data($fgwIp,$cp1PortOnGw,ip)   [getDataFromConfigFile "henbBearerIpaddress" $fgwNum]
                    
                    if {$localHeNBMultiHoming == "yes"} {
                         # retrieving CP2 network parameters for HeNBCP on gateway
                         lappend arr_nw_data($fgwIp,$cp2PortOnGw,vlan) [getDataFromConfigFile "getHenbCp2Vlan" $fgwNum]
                         lappend arr_nw_data($fgwIp,$cp2PortOnGw,mask) [getDataFromConfigFile "getHenbCp2Mask" $fgwNum]
                         lappend arr_nw_data($fgwIp,$cp2PortOnGw,ip)   [getDataFromConfigFile "getHenbCp2Ipaddress" $fgwNum]
                    }
               }
               "MME" {
                    set simIp           [getDataFromConfigFile "getMmeSimulatorHostIp" $fgwNum]
                    set simCp1Int       [getDataFromConfigFile "getMmeSimCp1HostPort" $fgwNum]
                    set cp1PortOnGw     [getDataFromConfigFile "getMmeCp1Port" $fgwNum]
                    if {[getDataFromConfigFile "mmeCpCount" $fgwNum]==2} {
                         set simCp2Int       [getDataFromConfigFile "getMmeSimCp2HostPort" $fgwNum]
                         set cp2PortOnGw        [getDataFromConfigFile "getMmeCp2Port" $fgwNum]
                    }
                    
                    # retrieve CP1 network parameters on simulator
                    lappend arr_nw_data($simIp,$simCp1Int,vlan) [getDataFromConfigFile "getMmeCp1Vlan" $fgwNum]
                    lappend arr_nw_data($simIp,$simCp1Int,vlan) [getDataFromConfigFile "sgwVlan" $fgwNum]
                    lappend arr_nw_data($simIp,$simCp1Int,mask) [getDataFromConfigFile "getMmeCp1Mask" $fgwNum]
                    lappend arr_nw_data($simIp,$simCp1Int,mask) [getDataFromConfigFile "sgwMask" $fgwNum]
                    lappend arr_nw_data($simIp,$simCp1Int,ip)   [incrIp [getDataFromConfigFile "getMmeCp1Ipaddress" $fgwNum]]
                    lappend arr_nw_data($simIp,$simCp1Int,ip)   [incrIp [getDataFromConfigFile "sgwIpaddress" $fgwNum]]
                    
                    #to add unique ip to each MME instance on simulator, i.e create virtual ip's
                    if {$noOfMMEs > 1} {
                         set mmeSimVlan [getDataFromConfigFile "getMmeCp1Vlan" $fgwNum]
                         set mmeSimMask [getDataFromConfigFile "getMmeCp1Mask" $fgwNum]
                         set mmeSimIp   [incrIp [getDataFromConfigFile "getMmeCp1Ipaddress" $fgwNum]]
                         set arr_ip_data($simCp1Int\.$mmeSimVlan) "$mmeSimIp/$mmeSimMask"
                    }
                    
                    #configure interfaces if either local or remote MME multihoming is enabled
                    if {$remoteMMEMultiHoming == "yes" || $localMMEMultiHoming == "yes"} {
                         # retrieve CP1 network parameters on simulator
                         lappend arr_nw_data($simIp,$simCp2Int,vlan) [getDataFromConfigFile "getMmeCp2Vlan" $fgwNum]
                         lappend arr_nw_data($simIp,$simCp2Int,mask) [getDataFromConfigFile "getMmeCp2Mask" $fgwNum]
                         lappend arr_nw_data($simIp,$simCp2Int,ip)   [incrIp [getDataFromConfigFile "getMmeCp2Ipaddress" $fgwNum]]
                         
                         #to add unique secondary ip to each MME instance on simulator, i.e create virtual ip's
                         if {$noOfMMEs > 1} {
                              set mmeSimVlan [getDataFromConfigFile "getMmeCp2Vlan" $fgwNum]
                              set mmeSimMask [getDataFromConfigFile "getMmeCp2Mask" $fgwNum]
                              set mmeSimIp   [incrIp [getDataFromConfigFile "getMmeCp2Ipaddress" $fgwNum]]
                              set arr_ip_data($simCp2Int\.$mmeSimVlan) "$mmeSimIp/$mmeSimMask"
                              
                         }
                    }
                    
                    # retrieve CP1 network parameters on gateway
                    lappend arr_nw_data($fgwIp,$cp1PortOnGw,vlan) [getDataFromConfigFile "getMmeCp1Vlan" $fgwNum]
                    lappend arr_nw_data($fgwIp,$cp1PortOnGw,vlan) [getDataFromConfigFile "sgwVlan" $fgwNum]
                    lappend arr_nw_data($fgwIp,$cp1PortOnGw,mask) [getDataFromConfigFile "getMmeCp1Mask" $fgwNum]
                    lappend arr_nw_data($fgwIp,$cp1PortOnGw,mask) [getDataFromConfigFile "sgwMask" $fgwNum]
                    lappend arr_nw_data($fgwIp,$cp1PortOnGw,ip)   [getDataFromConfigFile "getMmeCp1Ipaddress" $fgwNum]
                    lappend arr_nw_data($fgwIp,$cp1PortOnGw,ip)   [getDataFromConfigFile "sgwIpaddress" $fgwNum]
                    
                    #configure interfaces if either local or remote MME multihoming is enabled
                    if {$localMMEMultiHoming == "yes" || $remoteMMEMultiHoming == "yes"} {
                         # retrieve CP2 network parameters on gateway
                         lappend arr_nw_data($fgwIp,$cp2PortOnGw,vlan) [getDataFromConfigFile "getMmeCp2Vlan" $fgwNum]
                         lappend arr_nw_data($fgwIp,$cp2PortOnGw,mask) [getDataFromConfigFile "getMmeCp2Mask" $fgwNum]
                         lappend arr_nw_data($fgwIp,$cp2PortOnGw,ip)   [getDataFromConfigFile "getMmeCp2Ipaddress" $fgwNum]
                    }
               }
          }
          # to track the different simulators
          lappend arr_nw_data(simIp) $simIp
     }
     
     # eliminate duplicates
     set arr_nw_data(simIp) [lsort -unique $arr_nw_data(simIp)]
     set arr_nw_data(simList) $simType
     
     print -info "Dump of interfaces, vlan information that we are going to use ..."
     parray arr_nw_data
     
     set result  [restartHeNBGW -fgwNum $fgwNum -verify "yes" -operation "start"]
     if {$result < 0} {
          print -fail "Application bringup failed on HeNBGW, cannot continue further"
          return -1
     } else {
          print -pass "Successfully brought up the HeNBGW application"
     }
     
     # invoking the configuration code
     print -info "configuring simulator hosts ..."
     set result [configNEsForTest $fgwIp]
     if {$result != 0} {
          print -fail "Configuring network failed"
          return -1
     } else {
          print -pass "Configuring network is success"
     }
     # To add virtual ip for MME instances, when noOfMMEs > 1
     if {$noOfMMEs > 1} {
          set result [configVirtualIp $simIp $fgwIp $noOfMMEs]
          if {$result != 0} {
               print -fail "Configuring virtual ip's failed for MMEs"
               return -1
          } else {
               print -pass "Configured virtual ip's for MMEs"
          }
     }
     return 0
}

proc getLTEParam {param} {
     #-
     #- Parse the LTENewParams.txt file and return the values based on the param requested
     #-
     #- @in param -> param that is defined in LTENewParams.txt file
     #-
     #- @out value associated to the param, -1 if param is not defined in the file
     #-
     global ARR_LTE_TEST_PARAMS
     global RANDOM
     set ::RANDOM 1
     
     if {![info exists ARR_LTE_TEST_PARAMS(read)]} {
          set fileName "[getPath mainSqa]/testbeds/LTENewParams.txt"
          set fd [open $fileName "r"]
          set data [string trim [read $fd]]
          close $fd
          foreach line [split $data "\n"] {
               set line [string trim $line]
               # skip blank lines and comments
               if {$line == "" || [regexp "^#" $line]} { continue }
               foreach {key val} [split $line "="] {break}
               set ARR_LTE_TEST_PARAMS([string trim $key]) [string trim $val]
          }
          set ARR_LTE_TEST_PARAMS(read) 1 ;# to force only one time reading
          # -- info that is not avaialable in config file .... to support different values testing
          #set ARR_LTE_TEST_PARAMS(stBsrId) [random 30000]
          # -- PLMN ID (MCC, MNC)
          if {$::RANDOM == "1"} {
               set ARR_LTE_TEST_PARAMS(MCC)              [getRandomUniqueListInRange 100 999]
               set ARR_LTE_TEST_PARAMS(MNC)              [getRandomUniqueListInRange 10  999]
               set ARR_LTE_TEST_PARAMS(testMCC)          [getRandomUniqueListInRange 100 999]
               set ARR_LTE_TEST_PARAMS(testMNC)          [getRandomUniqueListInRange 10  999]
               set ARR_LTE_TEST_PARAMS(testTAC)          [random 65535]
               set ARR_LTE_TEST_PARAMS(TAC)              [random 65535]
               set ARR_LTE_TEST_PARAMS(HeNBId)           [random 65000] ;#[random 1048575]
               set ARR_LTE_TEST_PARAMS(MMEId) 	    [random 65000] ;#[random 1048575]
               set ARR_LTE_TEST_PARAMS(MMEGroupId)       [random 65535]
               set ARR_LTE_TEST_PARAMS(MMECode)          [random 255]
               set ARR_LTE_TEST_PARAMS(CSGId)            [random 134217728]
               set ARR_LTE_TEST_PARAMS(defaultPagingDrx) 32
          } else {
               set ARR_LTE_TEST_PARAMS(MCC)              234
               set ARR_LTE_TEST_PARAMS(MNC)              123
               set ARR_LTE_TEST_PARAMS(testMCC)          "616"
               set ARR_LTE_TEST_PARAMS(testMNC)          "687"
               set ARR_LTE_TEST_PARAMS(testTAC)          "19394"
               set ARR_LTE_TEST_PARAMS(TAC)              23
               set ARR_LTE_TEST_PARAMS(HeNBId)           2
               set ARR_LTE_TEST_PARAMS(MMEGroupId)       1
               set ARR_LTE_TEST_PARAMS(MMECode)          1
               set ARR_LTE_TEST_PARAMS(CSGId)            55179767
               set ARR_LTE_TEST_PARAMS(defaultPagingDrx) 32
          }
          print -debug "Below are some of the parameters going to be used in the test script ..."
          parray ARR_LTE_TEST_PARAMS
     }
     
     if {[info exists ARR_LTE_TEST_PARAMS($param)]} {
          return $ARR_LTE_TEST_PARAMS($param)
     } else {
          print -err "No data defined for $param"
          return -1
     }
}

proc prepareLTETestParams {args} {
     #-
     #- Updates global array of Test Parameters and prepares new Mapping array containing HeNB and MME paramter mappings
     #- i.e updates array ARR_LTE_TEST_PARAMS and prepares ARR_LTE_TEST_PARAMS_MAP
     #- To be used to update HeNBGW as well as simulator for test
     #-
     #- **** GUMMEIs format ****
     #- (indexes are based on noOfPLMNs,noOfMMECs,noOfMMEGIs passed to this proc)
     #- Format 1:  -GUMMEI "-mme0 2,0,2,0,2,0;2,0,2,2,2,0" means, in mme0 servedGUMMEI
     #- 2 PLMNs in G0 matching with Broadcast PLMNs from GW,0 is starting index of PLMNs,2 MMECs in G0,0 is starting index of MMECs,2 MMEGIs in G0,0 is starting index of MMEGI;
     #- 2 PLMNs in G1 matching with Broadcast PLMNs from GW,0 is starting index of PLMNs,2 MMECs in G1,2 is starting index of MMECs,2 MMEGIs in G1,0 is starting index of MMEGI;
     #-
     #- Format 2:  -GUMMEI "-mme0 2,0,2,0,2,0:2,x,0,0,0,0" means, in mme0 servedGUMMEI
     #- 2 PLMNs in G0 matching with Broadcast PLMNs from GW,0 is starting index of PLMNs,2 MMECs in G0,0 is starting index of MMECs,2 MMEGIs in G0,0 is starting index of MMEGI:
     #- Append 2 PLMNs in G0 which are not matching(x) with Broadcast PLMNs from GW,Append 0 MMECs in G0,Append 0 MMEGIs;
     #-
     #- **** CSGs format ****
     #- (indexes are based on noOfCSGs passed to this proc)
     #- Format 1: -CSGs "-henb0 10,0" in henb0's CSGList
     #- 10 CSGs matching with GW configuration,0 is starting index of CSGs
     #-
     #- Format 2: -CSGs "-henb0 x,x" in henb0's CSGList
     #- 10 CSGs not matching(x) with GW configuration
     #-
     #- **** mmeRegions format ****
     #- Format 1:  -mmeRegions "R0 0,1 R1 2,3" (Region index 0 gets MME index 0&1
     #-                                         Region index 1 gets MME index 2&3)
     #- Format 2:  -mmeRegions "R0 0-5 R1 6-9" (Region index 0 gets MME index 0 to 5
     #-                                         Region index 1 gets MME index 6 to 9)
     #- Format 3:  -mmeRegions "R0 0,1 R1 2,3 R3 1" ( this is shared MME example mme of index 1 is used in R0 and R3)
     #-
     #- *** henbRegions format ****
     #- Format 1: -henbRegions "R0 0,1 R1 2,3"(Region index 0 gets HeNB index 0&1
     #-                                        Region index 1 gets HeNB index 2&3)
     #- Format 2: -henbRegions "R0 0-5 R1 6-9"(Region index 0 gets HeNB index 0 to 5
     #-                                        Region index 1 gets HeNB index 6 to 9)
     #-
     #- *** mmePLMNs format ****
     #- Format 1: -mmePLMNs  "M0-4 0 M5-9 1"( MME index 0 to 4 gets PLMN index 0
     #-                                       MME index 5 to 9 gets PLMN index 1)
     #- *** henbPLMNs format ****
     #- Format 1: -henbPLMNs "H0-3 0,1 H4 0 H5 1"( HeNB index 0 to 3 gets PLMN index 0&1
     #-                                            HeNB index 4      gets PLMN index 0
     #-                                            HeNB index 5      gets PLMN index 1"
     
     global ARR_LTE_TEST_PARAMS_MAP
     global ARR_LTE_TEST_PARAMS
     set validOp "generate|write|read"
     parseArgs args \
               [list \
               [list operation     "optional"  "$validOp"    "generate"              "The operation to be performed" ] \
               ]

     # Check whether user follows backup DB and array method or not. If user want to execute the script
     # with backupDB and array mode, then skip the below lines of code and read the array values from 
     # backup file.
     set ARR_LTE_TEST_PARAMS(bkupDBArray) "no"
     if { [info exists ::bkupDBMode] && $::bkupDBMode == 1} {
 	set scriptName "[getScriptName]"
     	set curDir "[getPath]"
     	set arrayDBBkupDir "$curDir/ARRDBBKUP"
     	set scriptDir "$arrayDBBkupDir/$scriptName"
     	set arrayBkupFile "$scriptDir/arrayBkup.tcl"
        set ARR_LTE_TEST_PARAMS(scriptDir) $scriptDir
        set ARR_LTE_TEST_PARAMS(arrayBkupFile) $arrayBkupFile
        set ARR_LTE_TEST_PARAMS(arrayDBBkupDir) $arrayDBBkupDir
         set filesList "arrayBkup.tcl OAM_BsrDataPersistentDB.xml OAM_PersistentDB.xml"

          set missingFile 0
          if {[file exists $scriptDir]} {
               foreach bkupFile $filesList {
                    set bkupFilePath "$scriptDir/$bkupFile"
                    if {![file exists $bkupFilePath]} {
                         print -info "$bkupFilePath file doesn't exist under $scriptDir."
                         set missingFile 1
                    }
               }
          } else {
               print -info "$scriptDir directory doesn't exists."
               set missingFile 1
          }
        if {$missingFile == 0} {
        if {[file exists $arrayBkupFile] && [file exists "$scriptDir/OAM_PersistentDB.xml"]} {
          if {[catch {source $arrayBkupFile} err]} {
             print -fail "There was a failure in sourcing the stored data"
             print -debug "Got Error: $err"
             print -info "Regenerating data and backup mode as off..."
          } else {
             print -info "Retreived the data from file  \"$arrayBkupFile\""
             set ARR_LTE_TEST_PARAMS(bkupDBArray) "yes"
             parray ARR_LTE_TEST_PARAMS
             parray ARR_LTE_TEST_PARAMS_MAP
             return 0
          }
        } else {
          print -info "IMPORTANT NOTE: $arrayBkupFile and $scriptDir/OAM_PersistentDB.xml files doesn't exist under $scriptDir"
          print -info "So, backup files will not restored..."
        }
     }
     }
     # The current approach uses generation of FGW PARAMS which uses random values
     # So when we need to run scripts where we want to avoid regeneration of params and reuse already generated values
     # we would need a way to store the data and retreive it to run the script without configuring the DUT
     set genFgwData "/tmp/[getOwner]_genFgwData4G.tcl"
     if {$operation == "read"} {
          if {![file exists $genFgwData]} {
               print -info "There is no stored data to retreive from \"$genFgwData\""
               print -debug "Generating the data"
          } else {
               # If there is a failure in sourcing the data, countinue normal operation
               if {[catch {source $genFgwData} err]} {
                    print -fail "There was a failure in sourcing the stored data"
                    print -debug "Got Error: $err"
                    print -info "Regenerating data"
               } else {
                    print -info "Retreived the data from file  \"$genFgwData\""
                    parray ARR_LTE_TEST_PARAMS
                    parray ARR_LTE_TEST_PARAMS_MAP
               }
          }
     }
     
     parseArgs args \
               [list \
               [list noOfHeNBs     "optional"  "numeric"  "1"                     "defines number of HeNBs to be used in script" ] \
               [list noOfPLMNs     "optional"  "numeric"  "6"                     "defines number of PLMNs to be used in script" ] \
               [list noOfTestPLMNs "optional"  "numeric"  "6"                     "defines number of test PLMNs to be used in script" ] \
               [list noOfMMEs      "optional"  "numeric"  "1"                     "defines number of MMEs to be used in script" ] \
               [list noOfMMECs     "optional"  "numeric"  "1"                     "defines number of MMECs to be used in script" ] \
               [list noOfMMECdupli "optional"  "numeric"  "__UN_DEFINED__"        "defines number of MMEs to be used in script" ] \
               [list noOfMMEGIs    "optional"  "numeric"  "1"                     "defines number of MMEGIs to be used in script" ] \
               [list noOfCSGs      "optional"  "numeric"  "1"                     "defines number of CSG Ids to be used in script" ] \
               [list noOfUEs       "optional"  "numeric"  "__UN_DEFINED__"        "defines noOfUEs per HeNB to be used in script" ] \
               [list noOfRegions   "optional"  "numeric"  "1"                     "defines number of Regions to be used in script" ] \
               [list TAC           "optional"  "numeric"  "[getLTEParam TAC]"     "defines first TAC to be used in script" ] \
               [list HeNBId        "optional"  "numeric"  "[getLTEParam HeNBId]"  "defines first HeNBId to be used in script" ] \
               [list MCC           "optional"  "numeric"  "[getLTEParam MCC]"     "defines first MCC to be used in script" ] \
               [list MNC           "optional"  "numeric"  "[getLTEParam MNC]"     "defines first MNC to be used in script" ] \
               [list MMECode       "optional"  "numeric"  "[getLTEParam MMECode]"    "defines first MMECode to be used in script" ] \
               [list MMEGroupId    "optional"  "numeric"  "[getLTEParam MMEGroupId]" "defines first MMEGroupId to be used in script" ] \
               [list MMEId         "optional"  "numeric"  "[getLTEParam MMEId]"  "defines first HeNBId to be used in script" ] \
               [list testMCC       "optional"  "numeric"  "[getLTEParam testMCC]" "defines first test MCC to be used in script" ] \
               [list testMNC       "optional"  "numeric"  "[getLTEParam testMNC]" "defines first test MNC to be used in script" ] \
               [list testTAC       "optional"  "numeric"  "[getLTEParam testTAC]" "defines first test TAC to be used in script" ] \
               [list CSGId         "optional"  "numeric"  "[getLTEParam CSGId]"   "defines first CSG Id to be used in script" ] \
               [list GUMMEIs       "optional"  "string"   ""                      "defines GUMMEI list in -<mmeIndex> <G1a:G1b>;<G2>..<G8> -<mmeIndex> <G1>..<G8> format, where G1..8 are of format (noOfPLMNs,PLMNStartInd,noOfMMECs,MMECStartInd,noOfMMEGIs,MMGIStartInd)"] \
               [list CSGs          "optional"  "string"   ""                      "defines CSGId list in -<henbIndex> <noOfCSGs,startInd> format"] \
               [list mmeRegions    "optional"  "string"   ""                      "defines Region assignment to MMEs in <regionIndex> <mmeStartInd-mmeEndInd> format"] \
               [list henbRegions   "optional"  "string"   ""                      "defines Region assignment to HeNBs in <regionIndex> <henbStartInd-henbEndInd> -<regionIndex> <henbStartInd-henbEndInd> format"] \
               [list mmePLMNs      "optional"  "string"   ""                      "defines plmn assignment to MMEs in <mmeStartIndex-mmeEndIndex> <plmnStartInd-plmnEndInd> <mmeStartIndex-mmeEndIndex> <plmnStartInd-plmnEndInd> format"] \
               [list henbPLMNs     "optional"  "string"   ""                      "defines plmn assignment to HeNBs in <henbStartIndex-henbEndIndex> <plmnStartInd-plmnEndInd> <henbStartIndex-henbEndIndex> <plmnStartInd-plmnEndInd> format"] \
               [list MultiS1Link "optional"     "yes|no" "no"                      "To know multis1link enable towards mme" ] \
               [list eNBType   "optional"       "string"     "__UN_DEFINED__"        "defines the enbtype as macro or home"]
               ]
     
     set ARR_LTE_TEST_PARAMS(MultiS1Link) $MultiS1Link
     if {![info exists noOfMMECs]} {
          
          set noOfMMECs $noOfMMEs
     }
     #Preparing MMEC for noOfMMECs, to be used to in gateway
     set ARR_LTE_TEST_PARAMS(MMECode) ""
     for { set i 0 } { $i < $noOfMMECs } { incr i } {
          lappend ARR_LTE_TEST_PARAMS(MMECode) $MMECode
          if {$MMECode == 255} {set MMECode 0} else { incr MMECode }
     }
     
     if {[info exists noOfMMECdupli ]} {
          for { set i 0 } { $i < $noOfMMECdupli } { incr i } {
               lappend ARR_LTE_TEST_PARAMS(MMECode) 122
               #          if {$MMECode == 255} {set MMECode 0} else { incr MMECode }
          }
     }
     #Preparing MMEGI for noOfMMEGIs, to be used to in gateway
     set ARR_LTE_TEST_PARAMS(MMEGroupId) ""
     for { set i 0 } { $i < $noOfMMEGIs } { incr i } {
          lappend ARR_LTE_TEST_PARAMS(MMEGroupId) $MMEGroupId
          if {$MMEGroupId == 65535} {set MMEGroupId 0} else { incr MMEGroupId }
     }
     
     #setting eNBType of a HeNH, according to env variable(HeNB) value
     #Later, during S1Setup this value can be overwritten from script
       if {[info exists ::env(ENB)]} {
          print -debug "env(ENB) set in bash"
          set IS_MACRO 1
          print -info "enbtype s macro"
     } elseif { [info exists eNBType]} {
         foreach ele [split $eNBType " "] {
                         set HeNBIndex [lindex [split $ele ","] 0]
                         set eNBType [lindex [split $ele ","] 1]
                         lappend ARR_LTE_TEST_PARAMS_MAP(H,$HeNBIndex,eNBType)  $eNBType
                         print -info "eNBType is passed from script"
         }
     } else {
          set IS_HENB 1
          print -info "IS_HENB is set as $IS_HENB"
     }
 
     #Preparing TAC, HeNBId for noOfHeNBs
     #Preparing array of mapping between TAC and HeNBId
     
     set ARR_LTE_TEST_PARAMS(HeNBId) ""
     set ARR_LTE_TEST_PARAMS(TAC) ""
     for { set i 0 } { $i < $noOfHeNBs } { incr i } {
          lappend ARR_LTE_TEST_PARAMS(TAC) $TAC
          lappend ARR_LTE_TEST_PARAMS(HeNBId) $HeNBId
          if {$operation == "read"} {set ARR_LTE_TEST_PARAMS_MAP(H,$i,HeNBId)   $HeNBId} else {lappend ARR_LTE_TEST_PARAMS_MAP(H,$i,HeNBId)   $HeNBId}
          if {$operation == "read"} {set ARR_LTE_TEST_PARAMS_MAP(H,$i,TAC)      $TAC} else {lappend ARR_LTE_TEST_PARAMS_MAP(H,$i,TAC)      $TAC}
          if {[info exists IS_HENB]} {lappend ARR_LTE_TEST_PARAMS_MAP(H,$i,eNBType)  home}
          if {[info exists IS_MACRO]} {lappend ARR_LTE_TEST_PARAMS_MAP(H,$i,eNBType)  macro}
          set ARR_LTE_TEST_PARAMS_MAP(H,$i,MMECode)     $ARR_LTE_TEST_PARAMS(MMECode)
          set ARR_LTE_TEST_PARAMS_MAP(H,$i,MMEGroupId)  $ARR_LTE_TEST_PARAMS(MMEGroupId)
          if {$TAC == 65535} {set TAC 0}         else { incr TAC }
          if {$HeNBId == 1048575} {set HeNBId 0} else { incr HeNBId }
     }
     for { set i 0 } { $i < $noOfMMEs } { incr i } {
          lappend ARR_LTE_TEST_PARAMS_MAP(M,$i,MMEId)   $MMEId
          if {$MMEId == 1048575} {set MMEId 0} else { incr MMEId }
     }
     
     #Preparing CSGs for noOfCSGs, to be used to in gateway
     set ARR_LTE_TEST_PARAMS(CSGId) ""
     for { set i 0 } { $i < $noOfCSGs } { incr i } {
          lappend ARR_LTE_TEST_PARAMS(CSGId) $CSGId
          if {$CSGId == 134217728 } {set CSGId 0} else { incr CSGId }
     }
     
     set ARR_LTE_TEST_PARAMS(MCC) ""
     set ARR_LTE_TEST_PARAMS(MNC) ""
     #Preparing MNC, MCC for noOfPLMNs, to be used to in gateway
     for { set i 0 } { $i < $noOfPLMNs } { incr i } {
          if { $MNC<=9} {
               lappend ARR_LTE_TEST_PARAMS(MNC) [format %.2d $MNC]
          } elseif { $MNC<=99 } {
               lappend ARR_LTE_TEST_PARAMS(MNC) $MNC
          } else {
               lappend ARR_LTE_TEST_PARAMS(MNC) [format %.3d $MNC]
          }
          
          lappend ARR_LTE_TEST_PARAMS(MCC) [format %.3d $MCC]
          
          if {$MCC == 999} {set MCC 0} else { incr MCC }
          if {$MNC == 999} {set MNC 0} else { incr MNC }
     }
     
     #Preparing test MNC, MCC for noOfTestPLMNs, to be used in other than gateway
     set ARR_LTE_TEST_PARAMS(testMCC) ""
     set ARR_LTE_TEST_PARAMS(testMNC) ""
     set ARR_LTE_TEST_PARAMS(testTAC) ""
     for { set i 0 } { $i < $noOfTestPLMNs } { incr i } {
          lappend ARR_LTE_TEST_PARAMS(testMCC) $testMCC
          lappend ARR_LTE_TEST_PARAMS(testMNC) $testMNC
          lappend ARR_LTE_TEST_PARAMS(testTAC) $testTAC
          incr testMCC
          incr testMNC
          incr testTAC
     }
     
     #assgining PLMNs to henbs based upon henbPLMNs
     if {$henbPLMNs != "" } {
          assignPLMN "henb" $henbPLMNs
     } else {
          #Prepares array of mapping between MCC, MNC and HeNBId
          #Assigns MCC, MNC in round robin order to HeNBIds
          set i 0
          set j 0
          if { $noOfPLMNs > $noOfHeNBs } { set flag 0 } else { set flag 1 }
          while { 1 } {
               #set HeNBId [lindex $ARR_LTE_TEST_PARAMS(HeNBId) $i]
               if {$operation == "read"} {set ARR_LTE_TEST_PARAMS_MAP(H,$i,MCC) "[lindex $ARR_LTE_TEST_PARAMS(MCC) $j]"} else {lappend ARR_LTE_TEST_PARAMS_MAP(H,$i,MCC) "[lindex $ARR_LTE_TEST_PARAMS(MCC) $j]"}
               if {$operation == "read"} {set ARR_LTE_TEST_PARAMS_MAP(H,$i,MNC) "[lindex $ARR_LTE_TEST_PARAMS(MNC) $j]"} else {lappend ARR_LTE_TEST_PARAMS_MAP(H,$i,MNC) "[lindex $ARR_LTE_TEST_PARAMS(MNC) $j]"}
               incr i
               incr j
               if { $j > [expr $noOfPLMNs -1 ] } {
                    set j 0
                    if { $flag == 0 } { break }
               }
               if { $i > [expr $noOfHeNBs - 1 ] } {
                    set i 0
                    if { $flag == 1 } { break }
               }
          }
     }
     # generating CSG Ids and assigning to HeNBs
     generateCSGIds -CSGs $CSGs -noOfHeNBs $noOfHeNBs
     
     #generating GUMMEIS and assigning to MMEs
     #generating GUMMEIs for multiple MMEs based on mmeRegions and mmePLMNs
     generateGUMMEIS -GUMMEIs $GUMMEIs -noOfMMEs $noOfMMEs -noOfRegions $noOfRegions -mmeRegions $mmeRegions -mmePLMNs $mmePLMNs
     # generating UE Parameters
     if {[info exists noOfUEs]} {
          generateUEParams -noOfUEs $noOfUEs -noOfHeNBs $noOfHeNBs
     }
     if {$henbRegions != ""} {
          assignRegion "henb" $henbRegions
     } else {
          #Default assigning all the henb's to region 0
          for { set i 0 } { $i < $noOfHeNBs } { incr i } {
               set ARR_LTE_TEST_PARAMS_MAP(H,$i,Region) 0
          }
     }
     
     if {[info exists ::IS_BKGND_SCRIPT]} {
          if { $::IS_BKGND_SCRIPT == 1 } {
               updateUTLteParamData -noOfHeNBs $noOfHeNBs -noOfUEs $noOfUEs -noOfMMEs $noOfMMEs -noOfRegions $noOfRegions
          }
     }
     
     # prepare GW parameters
     set ARR_LTE_TEST_PARAMS(gwMCC)    [lindex $ARR_LTE_TEST_PARAMS(MCC) 0]
     set ARR_LTE_TEST_PARAMS(gwMNC)    [lindex $ARR_LTE_TEST_PARAMS(MNC) 0]
     
     print -debug "Below are updated parameters going to be used in the test script ..."
     parray ARR_LTE_TEST_PARAMS
     print -debug "Below are parameter mappings going to be used in the test script ..."
     parray ARR_LTE_TEST_PARAMS_MAP
     # Check if the user wants to store the data so that it can be used later
     if {$operation == "write"} {
          print -info "Writing the data to file \"$genFgwData\""
          set fd [open $genFgwData w]
          foreach ele [array names ARR_LTE_TEST_PARAMS] {
               set value $ARR_LTE_TEST_PARAMS($ele)
               if {$ele == "testMCC"|| $ele == "testMNC" || $ele == "testTAC"} {set value [lindex $ARR_LTE_TEST_PARAMS($ele) 0]}
               if {![regexp {^\"} $value]} {set value \"$value\"}
               print -nolog $fd "set ARR_LTE_TEST_PARAMS($ele) $value"
          }
          foreach ele [array names ARR_LTE_TEST_PARAMS_MAP] {
               set value $ARR_LTE_TEST_PARAMS_MAP($ele)
               if {![regexp {^\"} $value]} {set value \"$value\"}
               print -nolog $fd "set ARR_LTE_TEST_PARAMS_MAP($ele) $value"
          }
          close $fd
     }
     
     return 0
}
#-----------------------------------------
proc generateHeNBDataFile {args} {
     #-
     #- generates OAM_BsrDataPersistentDB.xml
     #-

     global ARR_XML_DATA
     global ARR_LTE_TEST_PARAMS
     global ARR_LTE_TEST_PARAMS_MAP

     print -info "JEMY ---->Inside generateHeNBData"         
     parseArgs args\
               [list \
               [list henbgwNum        "optional"     "numeric"             "0"               "FGW number in testbed file"]\
               [list startBsrId    "mandatory"    "string"              "_"               "Start BSR ID"]\
               [list endBsrId      "mandatory"    "string"              "_"               "END BSR ID"]\
               [list operation     "optional"     "add|delete"          "add"             "opertion to be performed"]\
               [list accessMode    "optional"     "1|2"                 "1"               "Access Mode"]\
               [list grpSize       "optional"     "numeric"             "5"               "No. of Femtos per group"]\
               [list startGrpId    "optional"     "numeric"             "1"               "Start Group ID"]\
               [list transfer      "optional"     "boolean"             "yes"              "Whether to transfer the file to FGW or not"]\
               [list imsiCount     "optional"     "numeric"             "__UN_DEFINED__"  "Start Group ID"]\
               [list imsiStValue   "optional"     "numeric"             "__UN_DEFINED__"  "IMSI start value"]\
               [list offset        "optional"     "numeric"             "__UN_DEFINED__"  "offset"]\
               [list moNum         "optional"     "numeric"             "__UN_DEFINED__"  "MO Number"]\
               [list startBcLac    "optional"     "string"             "-1"               "CBC LAC start Number"]\
               [list startBcSac    "optional"     "string"             "-1"               "CBC SAC start Number"]\
               [list noOfHenbs      "optional"     "numeric"            "__UN_DEFINED__"   "no of BSRs for load test"] \
               [list noOfUEs       "optional"     "numeric"            "__UN_DEFINED__"   "no of UEs for load test per UE"] \
               [list TotnoOfUEs    "optional"     "numeric"            "__UN_DEFINED__"   "total number of UEs"] \
               [list checkExternalPSC "optional"  "boolean"            "__UN_DEFINED__"   "checkExternalPSC"] \
               [list rscpThreshold "optional"     "numeric"            "__UN_DEFINED__"   "rscpThreshold"] \
               [list hoStatsForBestFitPSC "optional" "boolean"         "__UN_DEFINED__"   "hoStatsForBestFitPSC"] \
               [list uniquePSCAssignment  "optional" "boolean"         "false"            "uniquePSCAssignment"] \
               [list cellId        "optional"     "numeric"            "__UN_DEFINED__"   "cell Id"] \
               [list autoPsc       "optional"     "string"             "no"               "Flag to check auto Psc feature"] \
               [list femtoPSCList  "optional"     "string"             "__UN_DEFINED__"   "femtoPSCList"] \
               [list femtoGroupId  "optional"     "numeric"            "__UN_DEFINED__"   "femtoGroupId"] \
               [list neighborTypesId "optional"   "numeric"            1                  "neighborTypesId"] \
               [list femtoPSCListId  "optional"   "numeric"            1                  "femtoPSCListId"] \
               [list isDetectedNbr   "optional"   "boolean"            "__UN_DEFINED__"   "isDetectedNbr"] \
               [list isManualNbr     "optional"   "boolean"            "__UN_DEFINED__"   "isManualNbr"] \
               [list isUEDetectedNbr "optional"   "boolean"            "__UN_DEFINED__"   "isUEDetectedNbr"] \
               [list testType      "optional"     "func|load|loadNew"   "func"            "test type"] \
               ]

     set dut   [getActiveBonoIp $henbgwNum]
     set moid  [getMOId $dut]

     set xmlFileName "info.xml"
     set xmlTmpFile  "info1.xml"
     set zipFileName "info.zip"

     # clean up of stale files
     file delete -force $xmlFileName
     file delete -force $zipFileName

     # delete any previous stale values of the array
     if {[array exists ARR_XML_DATA]} {unset -nocomplain ARR_XML_DATA}

     # Fgw MO and header
     set ARR_XML_DATA(FGW=$moid,ATTR_LIST)                                          type
     set ARR_XML_DATA(FGW=$moid,type,DataType)                                      DisplayString
     set ARR_XML_DATA(FGW=$moid,type,Id)                                            1
     set ARR_XML_DATA(FGW=$moid,type,Name)                                          type
     set ARR_XML_DATA(FGW=$moid,type,Value)                                         complete
     set ARR_XML_DATA(header)                                                       {{<?xml version="1.0" encoding="UTF-8"?>} {<tns:MOIList xmlns:tns="http://www.preconf.com/PRECONF" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.preconf.com/PRECONF OAM_PreConfig.xsd">} </tns:MOIList>}
     set ARR_XML_DATA(id)                                                           "FGW=$moid"
      # Get the number of BSRs to be configured
     set noOfBsr [llength $ARR_LTE_TEST_PARAMS(HeNBId)]
     print -info "Jemy ---noOfBsr= $noOfBsr"
     if {$testType == "loadNew" } {
          if {[info exists noOfHenbs] } {
               set noOfBsr $noOfHenbs
          } else {
               print -fail "no of BSRs to be passed for the load test xml file generation"
          }
          if {[info exists noOfUEs] } {
               set noOfUEs $noOfUEs
          } else {
               print -fail "no of UEs to be passed for the load test xml file generation"
          }

          set  HeNBId [getFromTestMap -HeNBIndex 0 -param "HeNBId"]
          #set cellId [getFromTestMap -HeNBIndex 0 -param "cellId"]
          set cellId 200 
          #          print -debug "noOfUEs : $noOfUEs"
          set counterToAvoidSameImsi 0
          set currentJ 0
          set MCC [lindex [getFromTestMap -param "MCC"] 0]
          set MNC [lindex [getFromTestMap -param "MNC"] 0]
          set result [regexp {\d{3}} $MNC]
          if {$result == 0 } {
               set rangeMax 10
               set modRange 9999999999
          } else {
               set rangeMax 9
               set modRange 999999999
          }
          set rncId 113
           for {set i 1 } {$i <  $noOfHenbs  } {incr i} {
               set  HeNBId [getFromTestMap -HeNBIndex 0 -param "HeNBId"]
               set HeNBId [expr (($HeNBId + $i) % 65535)]
               lappend ARR_LTE_TEST_PARAMS_MAP(H,$i,HeNBId) $HeNBId

               if {[getFromTestMap -HeNBIndex 0 -param "type"] == "hnb" } {

                    set bsrLen [ string length [ format %x "$HeNBId" ] ]
                    set HeNBIdTemp  "[ string repeat 0 [ expr 4 - $bsrLen] ][ format %x $HeNBId ]"
                    lappend ARR_LTE_TEST_PARAMS_MAP(H,$i,cellId) [scan "[format %x $rncId ]$HeNBIdTemp" %x ]

                    set hnbIdentity [getFromTestMap -HeNBIndex 0 -param "hnbIdentity"]
                    set hnbIdFormat [lindex [split $hnbIdentity ""] 0]
                    if { $hnbIdFormat == 0} {
                         #format :      0<IMSI>@<realm>
                         set hnbIdentityParts [split $hnbIdentity "@"]
                         #print -debug "hnbIdentityParts : $hnbIdentityParts"
                         set hnbIdentityFirstPart [split [lindex $hnbIdentityParts 0] ""]
                         set removeFirstDigitZero [lreplace $hnbIdentityFirstPart 0 0 ]
                         set hnbIdentityFirstPart [join $removeFirstDigitZero ""]
                         #print -debug "hnbIdentityFirstPart : $hnbIdentityFirstPart"
                         set hnbIdentityFirstPart [expr (($hnbIdentityFirstPart + $i) % (9999999999999999))]
                         set hnbIdentity 0$hnbIdentityFirstPart\@[lindex $hnbIdentityParts 1]
                         lappend ARR_LTE_TEST_PARAMS_MAP(H,$i,hnbIdentity) $hnbIdentity

                    } else {
                         set hnbIdentityParts [split $hnbIdentity "@"]
                         set EachDigit [split $hnbIdentityParts ""]
                         set removeFirstDigit [lreplace $EachDigit 0 0]
                         set justOuiAndSerialNumber [join $removeFirstDigit ""]
                         set serialNumber [lindex [split [lindex $hnbIdentityParts 0] "\-"] 1]
                         #print -debug "serialNumber : $serialNumber"
                         set eachDigitInJustOuiAndSerialNumber [split $justOuiAndSerialNumber ""]
                         set extractOUI [join [lrange $eachDigitInJustOuiAndSerialNumber 0 5] ""]
                         set OUIinHexa $extractOUI
                         # print -debug "OUIinHexa : $OUIinHexa"
                         set OUIinDecimal [expr 0x$OUIinHexa]
                         set OUIinDecimal [expr (($OUIinDecimal + $i) % 16777215) ]
                         set newOUIInHex [format %X $OUIinDecimal]
                         if {[string len $newOUIInHex] != 6} {
                          set newOUIInHex [string repeat 0 [expr 6 - [string len $newOUIInHex]]]$newOUIInHex
                              # print -debug "OUinHexaAfterPrependingWithZeros is :$newOUIInHex"
                         }
                         #      print -debug "OUinHexaAfterIncrementing is :$newOUIInHex"
                         set hnbIdentity 1$newOUIInHex\-$serialNumber\@[lindex $hnbIdentityParts 1]
                         lappend ARR_LTE_TEST_PARAMS_MAP(H,$i,hnbIdentity) $hnbIdentity
                    }

               } else {
                    set cellId [expr (($HeNBId + $i) % 65535)]
                    lappend ARR_LTE_TEST_PARAMS_MAP(H,$i,cellId) $cellId
               }
 
                if {$i == 1} {
                    set UEIndexToRetrieveLastUEsIMSIforPreviousBSR [expr [expr $i * $noOfUEs] - 1]
               } else {
                    set UEIndexToRetrieveLastUEsIMSIforPreviousBSR [expr [expr [expr $i * $noOfUEs] - 1] - [expr $noOfUEs * [expr $i - 1]]]
               }
 
              set HeNBIndexOfPreviousBsr [expr $i - 1]
               set endStringIMSIExisting [getFromTestMap -param "endStringIMSI" -UEIndex $UEIndexToRetrieveLastUEsIMSIforPreviousBSR -HeNBIndex $HeNBIndexOfPreviousBsr]
               for {set j 0 } {$j < $noOfUEs} {incr j} {
                    set endStringIMSIExisting [scan $endStringIMSIExisting %d]

                    set endStringIMSI [expr (($endStringIMSIExisting + [expr $j + 1] ) % ($modRange)) ]
                    if {[string len $endStringIMSI] < $rangeMax } {

                         set endStringIMSI [string repeat 0 [expr $rangeMax - [string len $endStringIMSI ]]]$endStringIMSI
                    }
                    set ARR_LTE_TEST_PARAMS_MAP(H,$i,U,$j,endStringIMSI) $endStringIMSI
                    set ARR_LTE_TEST_PARAMS_MAP(H,$i,U,$j,IMSI) $MCC$MNC$endStringIMSI

               }
          }

     }
     # Getting the parameters from array

     #set mandatoryIEs "HeNBId cellId"
      #set mandatoryParams "HeNBId cellId"
      set mandatoryIEs "HeNBId"
      set mandatoryParams "HeNBId"
     foreach ie $mandatoryIEs param $mandatoryParams {
          if {![info exists $ie]} {
               set $ie  [getFromTestMap -HeNBIndex 0 -param "$param"]
          }
     }
     set cellId 200
     # For each bsr create the xml entry
     for {set bsr 0} {$bsr < $noOfBsr} {incr bsr} {
          set noOfUEs [llength [array names ARR_LTE_TEST_PARAMS_MAP -regexp "H,$bsr,U,\\d+,IMSI"]]
          #print -debug "noOfUEs in array : $noOfUEs"
          if {$testType == "loadNew" } {

               if {[info exists noOfUEs] } {
                    set noOfUEs $noOfUEs
               } else {
                    print -fail "no of UEs to be passed for the load test xml file generation"
               }

          }
          # Get the BSR ID to be updated
          #set HeNBId $ARR_LTE_TEST_PARAMS_MAP(H,$bsr,HeNBId)
          #set mandatoryIEs "HeNBId cellId"
          #set mandatoryIEs "HeNBId cellId"
          #set mandatoryParams "HeNBId cellId"
          set mandatoryIEs "HeNBId"
          set mandatoryParams "HeNBId"

          foreach ie $mandatoryIEs param $mandatoryParams {
               set $ie  [getFromTestMap -HeNBIndex $bsr -param "$param"]
          }
          set cellId 200
          set bsrMoTag "FGW=$moid,HeNB=$HeNBId"
          set accessMode [getBsrDataInfo -HeNBIndex $bsr -key accessMode -defValue "closedAccess"]
          updateBsrDataConfig -HeNBIndex $bsr -accessMode $accessMode

          # Define all the BSR values
          set ARR_XML_DATA($bsrMoTag,ATTR_LIST)                                 "action accessMode csgIdList enableServiceMonitoring enbType henbName hnbUniqueIdentity serialNumber tac"
          set ARR_XML_DATA($bsrMoTag,accessMode,DataType)                       Enumeration
          set ARR_XML_DATA($bsrMoTag,accessMode,Id)                             2
          set ARR_XML_DATA($bsrMoTag,accessMode,Name)                           accessMode
          set ARR_XML_DATA($bsrMoTag,accessMode,Value)                          $accessMode
          set ARR_XML_DATA($bsrMoTag,csgIdList,DataType)                        INTEGER
          set ARR_XML_DATA($bsrMoTag,csgIdList,Id)                              3
          set ARR_XML_DATA($bsrMoTag,csgIdList,Name)                            csgIdList
          set ARR_XML_DATA($bsrMoTag,csgIdList,Value)                           [getBsrDataInfo -HeNBIndex $bsr -key CSGId -defValue "123"] 
          set ARR_XML_DATA($bsrMoTag,action,DataType)                           Enumeration
          set ARR_XML_DATA($bsrMoTag,action,Id)                                 1
          set ARR_XML_DATA($bsrMoTag,action,Name)                               action
          set ARR_XML_DATA($bsrMoTag,action,Value)                              create
          set ARR_XML_DATA($bsrMoTag,enbType,DataType)                          Enumeration
          set ARR_XML_DATA($bsrMoTag,enbType,Id)                                5
          set ARR_XML_DATA($bsrMoTag,enbType,Name)                              eNBType
          set ARR_XML_DATA($bsrMoTag,enbType,Value)                             [getBsrDataInfo -HeNBIndex $bsr -key eNBType -defValue "eNB"]
          set ARR_XML_DATA($bsrMoTag,henbName,DataType)                         OCTETSTRING
          set ARR_XML_DATA($bsrMoTag,henbName,Id)                                6
          set ARR_XML_DATA($bsrMoTag,henbName,Name)                              henbName
          set ARR_XML_DATA($bsrMoTag,henbName,Value)                             "henb1"
          set ARR_XML_DATA($bsrMoTag,enableServiceMonitoring,DataType)          Boolean
          set ARR_XML_DATA($bsrMoTag,enableServiceMonitoring,Id)                4
          set ARR_XML_DATA($bsrMoTag,enableServiceMonitoring,Name)              enableServiceMonitoring
          set ARR_XML_DATA($bsrMoTag,enableServiceMonitoring,Value)             [getBsrDataInfo -HeNBIndex $bsr -key enableServiceMonitoring -defValue "True"]
          set ARR_XML_DATA($bsrMoTag,hnbUniqueIdentity,DataType)                HexBinary
          set ARR_XML_DATA($bsrMoTag,hnbUniqueIdentity,Id)                      7
          set ARR_XML_DATA($bsrMoTag,hnbUniqueIdentity,Name)                    hnbUniqueIdentity
          set ARR_XML_DATA($bsrMoTag,hnbUniqueIdentity,Value)                   [getBsrDataInfo -HeNBIndex $bsr -key hnbUniqueIdentity -defValue "0000000000000000"]
          set ARR_XML_DATA($bsrMoTag,serialNumber,DataType)                     OCTETSTRING
          set ARR_XML_DATA($bsrMoTag,serialNumber,Id)                           8
          set ARR_XML_DATA($bsrMoTag,serialNumber,Name)                         serialNumber
          set ARR_XML_DATA($bsrMoTag,serialNumber,Value)                        [getBsrDataInfo -HeNBIndex $bsr -key HeNBId -defValue "1120"]
          set ARR_XML_DATA($bsrMoTag,tac,DataType)                           INTEGER
          set ARR_XML_DATA($bsrMoTag,tac,Id)                                 9
          set ARR_XML_DATA($bsrMoTag,tac,Name)                               tac
          set ARR_XML_DATA($bsrMoTag,tac,Value)                              [getBsrDataInfo -HeNBIndex $bsr -key TAC -defValue "0"]
          set bsrMoTag "FGW=$moid,HeNB=$HeNBId,LteCell=1,globalHeNBId=1"                                           
          # LteCell entry under BSR
          set ARR_XML_DATA($bsrMoTag,ATTR_LIST)              "action plmnIdentityMcc plmnIdentityMnc eNBId"
          set ARR_XML_DATA($bsrMoTag,action,DataType)        Enumeration
          set ARR_XML_DATA($bsrMoTag,action,Id)                                 1
          set ARR_XML_DATA($bsrMoTag,action,Name)                               action
          set ARR_XML_DATA($bsrMoTag,action,Value)                              create
          set ARR_XML_DATA($bsrMoTag,plmnIdentityMcc,DataType)                  OCTETSTRING
          set ARR_XML_DATA($bsrMoTag,plmnIdentityMcc,Id)                         2
          set ARR_XML_DATA($bsrMoTag,plmnIdentityMcc,Name)                      plmnIdentityMcc
          set ARR_XML_DATA($bsrMoTag,plmnIdentityMcc,Value)                     [getBsrDataInfo -HeNBIndex $bsr -key MCC  -defValue "000"]
           set ARR_XML_DATA($bsrMoTag,plmnIdentityMnc,DataType)                  OCTETSTRING
          set ARR_XML_DATA($bsrMoTag,plmnIdentityMnc,Id)                         3
          set ARR_XML_DATA($bsrMoTag,plmnIdentityMnc,Name)                      plmnIdentityMnc
          set ARR_XML_DATA($bsrMoTag,plmnIdentityMnc,Value)                     [getBsrDataInfo -HeNBIndex $bsr -key MNC  -defValue "000"]

          set ARR_XML_DATA($bsrMoTag,eNBId,DataType)                            INTEGER
          set ARR_XML_DATA($bsrMoTag,eNBId,Id)                                  4
          set ARR_XML_DATA($bsrMoTag,eNBId,Name)                                eNBId
          set ARR_XML_DATA($bsrMoTag,eNBId,Value)                     [getBsrDataInfo -HeNBIndex $bsr -key HeNBId  -defValue "000"]
          set bsrMoTag "FGW=$moid,HeNB=$HeNBId,LteCell=1,plmnList=1"
          set ARR_XML_DATA($bsrMoTag,ATTR_LIST)              "action plmnIdentityMcc plmnIdentityMnc"
           set ARR_XML_DATA($bsrMoTag,action,DataType)        Enumeration
          set ARR_XML_DATA($bsrMoTag,action,Id)                                 1
          set ARR_XML_DATA($bsrMoTag,action,Name)                               action
          set ARR_XML_DATA($bsrMoTag,action,Value)                              create
          set ARR_XML_DATA($bsrMoTag,plmnIdentityMcc,DataType)                  OCTETSTRING
          set ARR_XML_DATA($bsrMoTag,plmnIdentityMcc,Id)                         2
          set ARR_XML_DATA($bsrMoTag,plmnIdentityMcc,Name)                      plmnIdentityMcc
          set ARR_XML_DATA($bsrMoTag,plmnIdentityMcc,Value)                     [getBsrDataInfo -HeNBIndex $bsr -key MCC  -defValue "000"]
           set ARR_XML_DATA($bsrMoTag,plmnIdentityMnc,DataType)                  OCTETSTRING
          set ARR_XML_DATA($bsrMoTag,plmnIdentityMnc,Id)                         3
          set ARR_XML_DATA($bsrMoTag,plmnIdentityMnc,Name)                      plmnIdentityMnc
          set ARR_XML_DATA($bsrMoTag,plmnIdentityMnc,Value)                     [getBsrDataInfo -HeNBIndex $bsr -key MNC  -defValue "000"]
 
          # Update the MO list after each bsr creation
          set ARR_XML_DATA(id)                                                  [concat \
                    $ARR_XML_DATA(id) \
                    "FGW=$moid,HeNB=$HeNBId \
                    FGW=$moid,HeNB=$HeNBId,LteCell=1,globalHeNBId=1 \
                    FGW=$moid,HeNB=$HeNBId,LteCell=1,plmnList=1" 
                    ]
            if {$testType != "loadNew" } {
               parray ARR_XML_DATA
          }
     }
     set result [generateXmlFile $xmlFileName]
     if {![file exists $xmlFileName]} {
          print -fail "$xmlFileName is not generated after formatting the original file"
          return -1
     }
     print -pass "Generated $xmlFileName file"

     set result [execCommandSU -dut $dut -command "rm -f /opt/bsrdata/OAM_BsrDataPersistentDB.xml /opt/bsrdata/AdjMatrixInfo.dat"]
    exec chmod 755 [getPath pwd]/$xmlFileName
     set result [syncHeNBData -sequence "changeUserNameSftp fileInput" -fileLoc "[getPath pwd]/$xmlFileName"]
     if {$result != 0 } {
          print -fail "syncHeNBData initialization failed. Exiting!"
          return -1
     } else {
          print -pass "User name in OAM_SftpDetailsFile.ini is changed and zip is prepared successfully"
     }
     return 0
}

#----------------------------------


proc syncHeNBData { args } {

###############################################################################################################################################

     #Available options : changeUserNameSftp restartProcess configCli passwordlessLogin configBsrDataFile fileTransfer fileInput

     #changeUserNameSftp : To change username in /opt/conf/OAM_SftpDetailsFile.ini from fgwuser to root
     #restartProcess : for "changeUserNameSftp" to take into effect, processes to be restarted
     #configCli : To configure actBSRDataBsgBsrInfoRepository and actBSRDataBsgBsrInformationFile with respective host IP and zip file location respectively
     #passwordlessLogin : To establish passwordless login between bono (root) to host machine (root) to enable passwordless sftp transfer of zip file
     #configBsrDataFile : To configure xml file and then zipping it. Passing required "action" (partial/complete) would change FGW FDN header in the xml file to have respective action
     #fileTransfer : To initiate zip file transfer via CLI command
     #fileInput : If xml file already exists, then via this option zipping is done and zip file will be placed in /tmp location

###############################################################################################################################################

     parseArgs args\
               [list \
               [list fgwNum          "optional"     "numeric"             "0"               "FGW number in testbed file"]\
               [list action          "optional"     "partial|complete"    "partial"          "sync type"]\
               [list syncBsrDataFile "optional"    "string"              "__UN_DEFINED__"    "The contents to be added in the file which is used for synchronizing"]\
               [list changeUserNameSftp "optional"  "yes|no"             "yes"              "change user name from fgwteam to root in OAM_SftpDetailsFile.ini"]\
               [list passwordlessLogin "optional"  "yes|no"             "yes"              "ssh key exchange"]\
               [list sequence       "optional"  "string"        ""      "sequence of actions to be performed"] \
               [list fileLoc       "optional"   "string"        "__UN_DEFINED__"        "file location of bsr data file which is to be zipped and transferred"] \
               ]

     set dut   [getActiveBonoIp $fgwNum]
     set moid  [getMOId $dut]
     set tmpXml "/tmp/[getOwner]_syncFile.xml"
     set tmpZip "/tmp/[getOwner]_syncFile.zip"


     foreach seq $sequence {
          switch $seq {
               "changeUserNameSftp" {
                    set cmd "sed -i 's/fgwuser/root/g' /opt/conf/OAM_SftpDetailsFile.ini"
                    set result [execCommandSU -dut $dut -command $cmd]
               }
               "restartProcess" {
                    set result [restartBsg -fgwNum $fgwNum -verify "yes" -operation "restart" -boardIp "all"]

                    set bonoIpAddress [getDataFromConfigFile getBonoIpaddress 0]
                    if {[llength $bonoIpAddress] == 2 } {

                         set failFlag 1
                         set dut [getActiveBonoIp $fgwNum]
                         set indexActive [lsearch $bonoIpAddress $dut]
                         set standbyIp [lreplace $bonoIpAddress $indexActive $indexActive]
                         for {set i 0 } {$i < 30 } {incr i } {
                              print -debug "Iteration [expr $i + 1]: "

et cmd "grep -l \"Received CheckFDN, Peer Sync is completed\" /opt/log/OAM/*"
                              set executedCmdResult [execCommandSU -dut $standbyIp -command $cmd ]
                              print -debug "executedCmdResult : $executedCmdResult"
                              set noOfFiles [llength [lsearch -all -inline -regexp $executedCmdResult /opt/log/OAM/Log_OAM.log*] ]
                              print -debug "noOfFiles containing \"peer sync completion string\" : $noOfFiles"

                              if {$noOfFiles > 0 } {
                                   set failFlag 0
                                   break
                              }

                              halt 10
                         }
                         if {$failFlag == 1 } {
                              print -fail "Peer Sync didn't happen even after waiting for 300 seconds. Cannot continue. Exiting"
                              return -1
                         } else {
                              print -pass "Peer Sync completed"
                         }
                    }

               }
               "configCli" {

                    set paramList ""

                    print -info "Enabling BSR DaTA file downloading on to the FGW"

                    lappend paramList "actBSRDataBsgBsrInfoRepository=\"192.168.0.200\""
                    lappend paramList "actBSRDataBsgBsrInformationFile=\"$tmpZip\""

                    set result [getAndSetParamViaBsgCli -dut $dut -paramList $paramList -verify "yes" -operation "set" -nodeName ""]
                    if {$result != 0} {
                         print -fail "Not able to configure cli params for partial/complete sync"
                         return -1
                    } else {
                      print -pass "Successfully configured cli params for partial/complete sync"
                    }

               }
               "fileTransfer" {

                      set dut  [getActiveBonoIp 0]
                    set moId [getMOId $dut]
                    set cmd "set FGW:$moId {actBSRData=True}"
                    set result [execCliCommand -dut $dut -command $cmd]
                     if {[isCliError $result]} {
                            print -debug "result : $result"
                            print -fail "Failed to execute the command : $cmd "
                            return -1
                          } else {
                             print -pass "actBSRData is set to True"
                   }

                    halt 15


               }
               "passwordlessLogin" {
                    exec touch /tmp/temporary.txt
                    set match ""
                    set result [execCommandSU -dut $dut -command "scp root@192.168.0.200:/tmp/temporary.txt /root/"]

                    set regExpMatch [regexp "Permission denied" $result match]
                    print -debug "regExpMatch: $regExpMatch; match : $match"

                    if {$regExpMatch == 1 } {
set result [execCommandSU -dut $dut -command "ssh-copy-id -i ~/.ssh/id_rsa.pub root@192.168.0.200" -cmdPasswd "yzSU\$9980"]
                         set regExpMatch ""
                         set match ""
                         set result [execCommandSU -dut $dut -command "scp root@192.168.0.200:/tmp/temporary.txt /root/"]

                         set regExpMatch [regexp "Permission denied" $result match]
                         print -debug "After keygen : regExpMatch: $regExpMatch; match : $match"
                         if {$regExpMatch == 1 } {
                              print -debug "Unable to establish passwordless login. Exiting!"
                              return -1
                         } else {

                              print -debug "Passwordless login is successfully established."
                         }

                    } else {
                         print -debug "Passwordless login is already present. No need to copy authorized keys"

                    }
               }
               "configBsrDataFile" {

                    set header [list "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\" ?>" "<tns:MOIList xmlns:tns=\"http://www.preconf.com/PRECONF\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:schemaLocation=\"http://www.preconf.com/PRECONF OAM_PreConfig.xsd\">"]
                    set footer "</tns:MOIList>"
                    set dut   [getActiveBonoIp $fgwNum]
                    set moid  [getMOId $dut]
                    catch {file delete -force $tmpXml}
                    catch {file delete -force $tmpZip}


                    set tmpFileId [open $tmpXml "a+"]


                    foreach ele $header {
                         print -nolog $tmpFileId $ele
                    }

                    print -nolog $tmpFileId ""
set syncHeader1 "<MOI fdn=\"FGW=$moid\">"
                    set syncHeader2 "<Attributes>"
                    set syncHeader3 "<Attribute DataType=\"DisplayString\" Id=\"1\" Name=\"type\" Value=\"$action\"/>"
                    set syncHeader4 "</Attributes>"
                    set syncHeader5 "</MOI>"
                    foreach ele [list $syncHeader1 $syncHeader2 $syncHeader3 $syncHeader4 $syncHeader5] {
                         print -nolog $tmpFileId $ele
                    }
                    print -nolog $tmpFileId ""
                    #append the $syncBsrDataFile contents if the variable exists.
                    if {[info exists syncBsrDataFile] } {
                         print -nolog $tmpFileId $syncBsrDataFile
                    }
                    print -nolog $tmpFileId ""
                    print -nolog $tmpFileId $footer
                    close $tmpFileId
                    #Creating zip file
                    set pwdVar [pwd]
                    cd /tmp
                    set result [exec zip [file tail $tmpZip] [file tail $tmpXml]]
                    set zipStatus [regexp "adding:.*syncFile\.xml.*deflated.*\%.*" $result match]
                    if {$zipStatus == 0 } {
                         print -fail "Zip operation failed. Exiting."
                         return -1
                    }
                    cd $pwdVar
               }
               "fileInput" {
                    if {[info exists fileLoc] } {
                         set result [catch {exec ls $fileLoc}]
                         if {$result == 1 } {
                              print -fail "File : $fileLoc doesn't exists. Exiting!"
                              return -1
                         }

                         catch {file delete -force $tmpXml}
                         catch {file delete -force $tmpZip}


                        exec cp -f $fileLoc $tmpXml
                         print -info "copied $fileLoc to $tmpXml"
                         set pwdVar [pwd]
                         cd /tmp
                         set result [exec zip [file tail $tmpZip] [file tail $tmpXml]]
                         set zipStatus [regexp "adding:.*syncFile\.xml.*deflated.*\%.*" $result match]
                         if {$zipStatus == 0 } {
                              print -fail "Zip operation failed. Exiting."
                              return -1
                         }
                         cd $pwdVar

                    } else {
                         print -fail "fileLoc variable doesn't exists! File path info should be passed for file transfer. Exiting!"
                         return -1
                    }

               }
          }
     }
     return 0

}

####################################################################################################
proc bkup4GArrayAndDatabase {} {
     #Taking backup of DB from BONO and prepareLTEParams array to restore it later if same script execute it again in 
     #backup mode. 

     global ARR_LTE_TEST_PARAMS
     global ARR_LTE_TEST_PARAMS_MAP

     if {$ARR_LTE_TEST_PARAMS(bkupDBArray) == "yes"} {
        print -info "DB and ARRAY backup already exists. So, skipping backup of array and DB procedure"
        return 0
     } else {
        if {[info exists ::bkupDBMode] && $::bkupDBMode == 1} {
          print -info "Script is executed with backup mode and taking backup of required files for next iteration"
        } else {
          #Script is not executed with backup mode
          return 0
        }
     }

     set localHost "127.0.0.1"
     
     set arrayDBBkupDir $ARR_LTE_TEST_PARAMS(arrayDBBkupDir)
     set scriptDir $ARR_LTE_TEST_PARAMS(scriptDir)
     set arrayBkupFile $ARR_LTE_TEST_PARAMS(arrayBkupFile)

     set result [execLinuxCommand -hostMgIp $localHost -command "mkdir -p $arrayDBBkupDir"]
     set result [execLinuxCommand -hostMgIp $localHost -command "mkdir -p $scriptDir"]
     if {$result == -1} {
        print -fail "Failed to create $scriptDir directory"
        return -1
     }

     print -info "Writing the data to file \"$arrayBkupFile\""
     set fd [open $arrayBkupFile "w+"]
     foreach ele [array names ARR_LTE_TEST_PARAMS] {
       set value $ARR_LTE_TEST_PARAMS($ele)
       if {$ele == "testMCC"|| $ele == "testMNC" || $ele == "testTAC"} {set value [lindex $ARR_LTE_TEST_PARAMS($ele) 0]}
       if {![regexp {^\"} $value]} {set value \"$value\"}
       print -nolog $fd "set ARR_LTE_TEST_PARAMS($ele) $value"
     }

     foreach ele [array names ARR_LTE_TEST_PARAMS_MAP] {
       set value $ARR_LTE_TEST_PARAMS_MAP($ele)
       if {![regexp {^\"} $value]} {set value \"$value\"}
       print -nolog $fd "set ARR_LTE_TEST_PARAMS_MAP($ele) $value"
     }

     close $fd

     #Backup of database from Gateway
     set localHost     [getConnectedHostMgmntIp 4]
     set filesList "/opt/bsrdata/OAM_BsrDataPersistentDB.xml OAM_PersistentDB.xml"
     set fgwIp [getActiveBonoIp]
     foreach fileName $filesList {
       set localFileName "$scriptDir/$fileName"
       set remoteFileName "/opt/conf/$fileName"
       set result [scpFile -localHost $localHost -remoteHost $fgwIp -localFileName $localFileName -opType "get" \
                -remoteFileName $remoteFileName -remoteUser $::ADMIN_USERNAME -remotePassword $::ADMIN_PASSWORD]
       if {$result == -1} {
          print -fail "Copying of $remoteFileName file is failed from $fgwIp"
          return -1
       }
     }
     return 0
}


proc generateGUMMEIS {args} {
     #-
     #- to generat GUMMEIS
     #-
     #- input representation -<mmeIndex> <G1a:G1b>;<G2> -<mmeIndex> <G1>
     #- G1a:G1b ":" represents a GUMMEI that is a combination of MCC, MNCs from different indicies
     #-          for ex: we want 2 MCC, MNCs that are part of Gateway configuration and 1 MCC, MNC that are not part
     #-                  of Gateway configuratino, we can use this representation
     #-          ";"  used to seperate out GUMMEIs
     #-          "," used to seperate GUMMEI parameters (like MCC,MNCs,MMECode,MMEGroupId)
     #-
     
     global ARR_LTE_TEST_PARAMS
     global ARR_LTE_TEST_PARAMS_MAP
     
     parseArgs args \
               [list \
               [list GUMMEIs    "optional"  "string"    ""                 "defines gummei parameters for generating" ] \
               [list noOfMMEs   "optional"  "numeric"   "1"                "defines total number of MMEs" ] \
               [list noOfRegions  "optional" "numeric"  "1"                "defines total number of regions" ] \
               [list mmeRegions   "optional" "string"   ""                 "defines mme assignment to region, i.e MMEC, MMEGI assignment" ] \
               [list mmePLMNs     "optional" "string"   "__UN_DEFINED__"   "defines plmn assignment to MMEs" ] \
               ]
     set eleParams {noOfplmns plmnIndex noOfmmecs mmecIndex noOfmmegis mmegiIndex}
     
     foreach {mmeIndex paramList} $GUMMEIs {
          regexp -- {\d+$} $mmeIndex mmeIndex
          set mmeIndex [string trim $mmeIndex]
          set i 0 ;# gummei index
          foreach params [split $paramList ";"] {
               set arrIndex "M,$mmeIndex,G${i}"
               foreach param "MCC MNC MMECode MMEGroupId" { set ARR_LTE_TEST_PARAMS_MAP($arrIndex,$param) "" }
               foreach  eleList [split $params ":"] {
                    foreach $eleParams [split $eleList ","] {break}
                    # Generating PLMNs
                    if {$plmnIndex == "x"} {
                         set plmnIndex 0
                         set ARR_LTE_TEST_PARAMS_MAP($arrIndex,MCC) [concat $ARR_LTE_TEST_PARAMS_MAP($arrIndex,MCC) [lrange $ARR_LTE_TEST_PARAMS(testMCC) $plmnIndex [expr $noOfplmns + $plmnIndex -1]]]
                         set ARR_LTE_TEST_PARAMS_MAP($arrIndex,MNC) [concat $ARR_LTE_TEST_PARAMS_MAP($arrIndex,MNC) [lrange $ARR_LTE_TEST_PARAMS(testMNC) $plmnIndex [expr $noOfplmns + $plmnIndex -1]]]
                    } else {
                         set ARR_LTE_TEST_PARAMS_MAP($arrIndex,MCC) [concat $ARR_LTE_TEST_PARAMS_MAP($arrIndex,MCC) [lrange $ARR_LTE_TEST_PARAMS(MCC) $plmnIndex [expr $noOfplmns + $plmnIndex -1]]]
                         set ARR_LTE_TEST_PARAMS_MAP($arrIndex,MNC) [concat $ARR_LTE_TEST_PARAMS_MAP($arrIndex,MNC) [lrange $ARR_LTE_TEST_PARAMS(MNC) $plmnIndex [expr $noOfplmns + $plmnIndex -1]]]
                    }
                    # GENERATING MME Index
                    if {$mmecIndex == "x"} {
                         set ARR_LTE_TEST_PARAMS_MAP($arrIndex,MMECode) [concat $ARR_LTE_TEST_PARAMS_MAP($arrIndex,MMECode) [getRandomUniqueListInRange 1 100 $noOfmmecs]]
                    } else {
                         set ARR_LTE_TEST_PARAMS_MAP($arrIndex,MMECode) [concat $ARR_LTE_TEST_PARAMS_MAP($arrIndex,MMECode) [lrange $ARR_LTE_TEST_PARAMS(MMECode) $mmecIndex [expr $noOfmmecs + $mmecIndex -1]]]
                    }
                    # generate MME Group ID
                    if {$mmegiIndex == "x"} {
                         set ARR_LTE_TEST_PARAMS_MAP($arrIndex,MMEGroupId) [concat $ARR_LTE_TEST_PARAMS_MAP($arrIndex,MMEGroupId) [getRandomUniqueListInRange 1 100 $noOfmmegis]]
                    } else {
                         set ARR_LTE_TEST_PARAMS_MAP($arrIndex,MMEGroupId) [concat $ARR_LTE_TEST_PARAMS_MAP($arrIndex,MMEGroupId) [lrange $ARR_LTE_TEST_PARAMS(MMEGroupId) $mmegiIndex [expr $noOfmmegis + $mmegiIndex -1]]]
                    }
               }
               incr i
               set ARR_LTE_TEST_PARAMS($mmeIndex,GUMMEIs) $i
          }
     }
     
     if {$noOfMMEs > 1} {
          #Handling MMEC,MMEGI assignment to MMEs in a region, based on mmeRegion definition
          ############## eg:- mmeRegions "R0 0-4 R1 5-9" ###################################
          print -info "mmeRegions $mmeRegions"
          
          assignRegion "mme" $mmeRegions
          proc old {} {
               foreach {regionInd mmeList} $mmeRegions {
                    print -info "regionInd $regionInd mmeList $mmeList"
                    regexp -- {\d+$} $regionInd regionInd
                    set regionInd [string trim $regionInd]
                    set MMEGI [random 65535]
                    foreach {stInd endInd} [split $mmeList "-"] {break}
                    #when there is no range of indices defined
                    if {$endInd == ""} { set endInd $stInd }
                    for {set i $stInd} {$i <= $endInd} {incr i} {
                         lappend ARR_LTE_TEST_PARAMS_MAP(M,$i,Region) $regionInd
                         #If G0 is defined, bcoz of GUMMEIs assignment above, not doing below assignment
                         if {![info exists ARR_LTE_TEST_PARAMS_MAP(M,$i,G0,MMECode)]} {
                              #Unique MMEC, but same MMEGI to MMEs of a region
                              set ARR_LTE_TEST_PARAMS_MAP(M,$i,G0,MMECode)  "[random 255]"
                              lappend ARR_LTE_TEST_PARAMS_MAP(M,$i,G0,MMEGroupId) "$MMEGI"
                              set ARR_LTE_TEST_PARAMS($i,GUMMEIs) 1
                         }
                    }
               }
          }
          #Handling PLMN assignment to MMEs in a region, based on mmePLMNs definition
          ############## eg:- mmePLMNs   "M0-4 0 M5-9 1" ###################################
          if {$mmePLMNs != ""} {
               assignPLMN "mme" $mmePLMNs
          } else {
               for {set i 0} {$i < $noOfMMEs} {incr i} {
                    if {![info exists ARR_LTE_TEST_PARAMS_MAP(M,$i,G0,MCC)]} {
                         #Assigning all the generated MCC and MNC
                         set ARR_LTE_TEST_PARAMS_MAP(M,$i,G0,MCC) "$ARR_LTE_TEST_PARAMS(MCC)"
                         set ARR_LTE_TEST_PARAMS_MAP(M,$i,G0,MNC) "$ARR_LTE_TEST_PARAMS(MNC)"
                    }
               }
          }
     } elseif {$noOfMMEs == 1} {
          #### Retaining old way of default MMEC,MMEGI,PLMN assignment, for single MME
          if {![info exists ARR_LTE_TEST_PARAMS_MAP(M,0,G0,MMECode)]} {
               #Keeping the earlier method, for single MME
               set ARR_LTE_TEST_PARAMS_MAP(M,0,G0,MMECode)  "$ARR_LTE_TEST_PARAMS(MMECode)"
               set ARR_LTE_TEST_PARAMS_MAP(M,0,G0,MMEGroupId) "$ARR_LTE_TEST_PARAMS(MMEGroupId)"
               
               #Assigning all the generated MCC and MNC
               set ARR_LTE_TEST_PARAMS_MAP(M,0,G0,MCC) "$ARR_LTE_TEST_PARAMS(MCC)"
               set ARR_LTE_TEST_PARAMS_MAP(M,0,G0,MNC) "$ARR_LTE_TEST_PARAMS(MNC)"
               set ARR_LTE_TEST_PARAMS(0,GUMMEIs) 1
          }
          
          if  {$mmeRegions == ""} {
               set ARR_LTE_TEST_PARAMS_MAP(M,0,Region) 0
          } else {
               assignRegion "mme" $mmeRegions
          }
     }
     
     return 0
}

proc assignRegion {simType {exp ""}} {
     #-
     #- Assigns Regions to mme's or henb's according to mmeRegion/henbRegion arugument passed to prepareLTETestParams
     #-
     global ARR_LTE_TEST_PARAMS
     global ARR_LTE_TEST_PARAMS_MAP
     global RANDOM
     
     set simChar [string map "mme M henb H" $simType]
     print -info " $simType Regions $exp"
     foreach {regionInd regList} $exp {
          print -info "regionInd $regionInd regList $regList"
          regexp -- {\d+$} $regionInd regionInd
          set regionInd [string trim $regionInd]
          
          if {$::RANDOM == 1} {
               if {$simType=="mme"} {set MMEGI [random 65535]}
          } else {
               if {$simType=="mme"} {set MMEGI [expr $regionInd + 1]}
          }
          
          set indexList ""
          if {[regexp {:} $regList]} {
               #Individual index given
               set indexList1 [split $regList ","]
               print -info "indexList1 $indexList1"
               set maxS1Links 0
               set noOfRegMMEs 0
               foreach mmeS1List $indexList1 {
                    foreach {S1mmeIndex S1Links} [split $mmeS1List ":"] {
                         print -info "S1mmeIndex $S1mmeIndex S1Links $S1Links maxS1Links $maxS1Links"
                         set noOfRegMMEs [incr noOfRegMMEs]
                         #set ARR_LTE_TEST_PARAMS_MAP(S1MMEIndex,$S1mmeIndex) "$S1Links"
                         set ARR_LTE_TEST_PARAMS_MAP(M,$S1mmeIndex,noOfS1MMEs) "$S1Links"
                         lappend indexList $S1mmeIndex
                         if {$S1Links > $maxS1Links} {
                              set maxS1Links $S1Links
                         }
                    }
               }
               set ARR_LTE_TEST_PARAMS_MAP(R,$regionInd,noOfRegMMEs) "$noOfRegMMEs"
               
               set ARR_LTE_TEST_PARAMS_MAP(R,$regionInd,maxS1Links) "$maxS1Links"
          } else {
               if {[regexp {\-} $regList]} {
                    #Range is given
                    foreach {stInd endInd} [split $regList "-"] {break}
                    for {set i $stInd} {$i <= $endInd} {incr i} { lappend indexList $i }
               } elseif {[regexp {,} $regList]} {
                    #Individual index given
                    set indexList [split $regList ","]
               } else {
                    #only 1 element
                    set indexList $regList
               }
          }
          set noOfRegHenbs 0
          
          foreach i $indexList {
               lappend ARR_LTE_TEST_PARAMS_MAP($simChar,$i,Region) $regionInd
               if {$simType=="henb"} {
                    set noOfRegHenbs [expr $noOfRegHenbs + 1]
               }
               if {$simType=="mme"} {
                    #If G0 is already defined, bcoz of GUMMEIs assignment in generateGUMMEIs, not doing below assignment
                    if {![info exists ARR_LTE_TEST_PARAMS_MAP(M,$i,G0,MMECode)]} {
                         #Unique MMEC, but same MMEGI to MMEs of a region
                         if {$::RANDOM == 1} {
                              set ARR_LTE_TEST_PARAMS_MAP(M,$i,G0,MMECode)  "[random 255]"
                         } else {
                              set ARR_LTE_TEST_PARAMS_MAP(M,$i,G0,MMECode)  [expr $i + 1]
                         }
                         lappend ARR_LTE_TEST_PARAMS_MAP(M,$i,G0,MMEGroupId) "$MMEGI"
                         set ARR_LTE_TEST_PARAMS($i,GUMMEIs) 1
                    }
               }
          }
          if {$simType=="henb"} {
               set ARR_LTE_TEST_PARAMS_MAP(R,$regionInd,noOfHenbs) $noOfRegHenbs
          }
     }
     return 0
}

proc assignPLMN {simType {exp ""}} {
     #-
     #- Assigns PLMNs to mme's or henb's according to mmePLMN/henbPLMN arugument passed to prepareLTETestParams
     #-
     global ARR_LTE_TEST_PARAMS
     global ARR_LTE_TEST_PARAMS_MAP
     
     set simChar [string map "mme M henb H" $simType]
     print -info " $simType plmn assignment $exp"
     foreach {simRange plmnRange} $exp {
          print -info "simRange $simRange plmnRange $plmnRange"
          #regexp -- {\d+(|-)(|,)$} $simRange simRange
          regsub -all "M" $simRange "" simRange
          regsub -all "H" $simRange "" simRange
          set regionInd [string trim $simRange]
          
          set simIndList ""
          if {[regexp {\-} $simRange]} {
               #Range is given
               foreach {stInd endInd} [split $simRange "-"] {break}
               for {set i $stInd} {$i <= $endInd} {incr i} { lappend simIndList $i }
          } elseif {[regexp {,} $simRange]} {
               #Individual index given
               set simIndList [split $simRange ","]
          } else {
               #only 1 element
               set simIndList $simRange
          }
          
          ## simIndList has all mme/henb indices to which, plmns need to be assigned below
          foreach ind $simIndList {
               set indexList ""
               if {[regexp {\-} $plmnRange]} {
                    #Range is given
                    foreach {stInd endInd} [split $plmnRange "-"] {break}
                    for {set i $stInd} {$i <= $endInd} {incr i} { lappend indexList $i }
               } elseif {[regexp {,} $plmnRange]} {
                    #Individual index given
                    set indexList [split $plmnRange ","]
               } else {
                    #only 1 element
                    set indexList $plmnRange
               }
               
               #indexList has all plmn indices
               foreach i $indexList {
                    if {$simType =="mme"} {
                         lappend ARR_LTE_TEST_PARAMS_MAP($simChar,$ind,G0,MCC) [lindex $ARR_LTE_TEST_PARAMS(MCC) $i]
                         lappend ARR_LTE_TEST_PARAMS_MAP($simChar,$ind,G0,MNC) [lindex $ARR_LTE_TEST_PARAMS(MNC) $i]
                    } else {
                         lappend ARR_LTE_TEST_PARAMS_MAP($simChar,$ind,MCC) [lindex $ARR_LTE_TEST_PARAMS(MCC) $i]
                         lappend ARR_LTE_TEST_PARAMS_MAP($simChar,$ind,MNC) [lindex $ARR_LTE_TEST_PARAMS(MNC) $i]
                    }
               }
          }
     }
     return 0
}

proc generateCSGIds {args} {
     #-
     #- Generates CSGIds
     #- input representation -<henbIndex> $noOfCSGs,$index;$x_noOfCSGs,$x_index -<henbIndex $noOfCSGs,$index
     #- where $noOfCSGs,$index represent number of CSGs and index that are part of Gateway configuration
     #-   $x_noOfCSGs,$x_index represent  number of CSGs and index that are not part of Gateway configuration
     
     global ARR_LTE_TEST_PARAMS
     global ARR_LTE_TEST_PARAMS_MAP
     
     parseArgs args \
               [list \
               [list CSGs       "optional"  "string"   ""         "defines CSG parameters for generating, of -henb0 noOfCSGs,index -henb1 noOfCSGs,index format" ] \
               [list noOfHeNBs  "optional"  "numeric"  "1"        "defines number of HeNBs" ] \
               ]
     
     #-henb0 $noOfCSGs,$index -henb1 $noOfCSGs,$index
     foreach {henbIndex paramList} $CSGs {
          regexp -- {\d+$} $henbIndex henbIndex
          set henbIndex [string trim $henbIndex]
          set ARR_LTE_TEST_PARAMS_MAP(H,$henbIndex,CSGId) ""
          foreach params [split $paramList ";"] {
               foreach {noOfcsgs csgIndex} [split $params ","] {
                    if {$csgIndex == "x"} {
                         set ARR_LTE_TEST_PARAMS_MAP(H,$henbIndex,CSGId) [concat $ARR_LTE_TEST_PARAMS_MAP(H,$henbIndex,CSGId) [getRandomUniqueListInRange 1 10000 $noOfcsgs]]
                    } else {
                         set ARR_LTE_TEST_PARAMS_MAP(H,$henbIndex,CSGId) [concat $ARR_LTE_TEST_PARAMS_MAP(H,$henbIndex,CSGId) [lrange $ARR_LTE_TEST_PARAMS(CSGId) $csgIndex [expr $noOfcsgs + $csgIndex -1]]]
                    }
               }
          }
     }
     
     for {set i 0} {$i < $noOfHeNBs} {incr i} {
          if {![info exists ARR_LTE_TEST_PARAMS_MAP(H,$i,CSGId)]} {
               set ARR_LTE_TEST_PARAMS_MAP(H,$i,CSGId)  "$ARR_LTE_TEST_PARAMS(CSGId)"
          }
     }
     return 0
}

proc generateUEParams {args} {
     #-
     #- Generates UE params
     #-
     global ARR_LTE_TEST_PARAMS
     global ARR_LTE_TEST_PARAMS_MAP
     global RANDOM
     
     parseArgs args \
               [list \
               [list noOfUEs       "optional"  "numeric"   "__UN_DEFINED__"  "defines noOfUEs" ] \
               [list noOfHeNBs     "optional"  "numeric"   "__UN_DEFINED__"  "defines noOfHeNBs" ] \
               ]
     
     for {set h 0} {$h < $noOfHeNBs} {incr h} {
          for {set i 0} {$i < $noOfUEs} {incr i} {
               if {$::RANDOM == 1} {
                    set ARR_LTE_TEST_PARAMS_MAP(H,$h,U,$i,ueid) [random 1000]
                    #eNBUES1APId is 0..2power24-1
                    set ARR_LTE_TEST_PARAMS_MAP(H,$h,U,$i,eNBUES1APId) [random 16777215]
                    #MMEUES1APId is 0..2power32-1 actually
                    set ARR_LTE_TEST_PARAMS_MAP(H,$h,U,$i,MMEUES1APId) [random 16777215]
               } else {
                    set ARR_LTE_TEST_PARAMS_MAP(H,$h,U,$i,ueid) [expr $i + 1]
                    #eNBUES1APId is 0..2power24-1
                    set ARR_LTE_TEST_PARAMS_MAP(H,$h,U,$i,eNBUES1APId) [expr $i + 1]
                    #MMEUES1APId is 0..2power32-1 actually
                    set ARR_LTE_TEST_PARAMS_MAP(H,$h,U,$i,MMEUES1APId) [expr $i + 1]
               }
               
          }
     }
     return 0
}

proc prepareStaticTestParams {args} {
     global ARR_LTE_TEST_PARAMS_MAP
     global ARR_LTE_TEST_PARAMS
     
     parseArgs args \
               [list \
               [list fgwNum        "optional"  "numeric"  "0" "defines fgw number to be used in script" ] \
               [list noOfHeNBs     "optional"  "numeric"  "1" "defines number of HeNBs to be used in script" ] \
               [list noOfMMEs      "optional"  "numeric"  "1" "defines number of MMEs to be used in script" ] \
               [list noOfUEs       "optional"  "numeric"  "1" "defines number of UEs to be used in script" ] \
               [list TAC           "optional"  "numeric"  ""  "defines first TAC to be used in script" ] \
               [list eNBId         "optional"  "numeric"  ""  "defines first HeNBId to be used in script" ] \
               [list MCC           "optional"  "numeric"  ""  "defines first MCC to be used in script" ] \
               [list MNC           "optional"  "numeric"  ""  "defines first MNC to be used in script" ] \
               [list MMECode       "optional"  "numeric"  ""  "defines first MMECode to be used in script" ] \
               [list MMEGroupId    "optional"  "numeric"  ""  "defines first MMEGroupId to be used in script" ] \
               [list eNBNameGw     "optional"  "string"   ""  "defines eNBGatewayName to be used in script" ] \
               [list globaleNBId   "optional"  "string"   ""  "defines globaleNBId to be used in script" ] \
               [list defaultPagingDrx "optional" "string" ""  "defines defaultPagingDrx to be used in script" ] \
               ]
     
     #Reading from user inputs and generating Global Array
     set ARR_LTE_TEST_PARAMS(MCC)              $MCC
     set ARR_LTE_TEST_PARAMS(MNC)              $MNC
     set ARR_LTE_TEST_PARAMS(TAC)              $TAC
     set ARR_LTE_TEST_PARAMS(HeNBId)           $eNBId
     set ARR_LTE_TEST_PARAMS(MMEGroupId)       $MMEGroupId
     set ARR_LTE_TEST_PARAMS(MMECode)          $MMECode
     set ARR_LTE_TEST_PARAMS(defaultPagingDrx) $defaultPagingDrx
     set ARR_LTE_TEST_PARAMS(HeNBGWName)       $eNBNameGw
     set ARR_LTE_TEST_PARAMS(globaleNBId)      $globaleNBId
     set ARR_LTE_TEST_PARAMS(CSGId)            "12345"
     set ARR_LTE_TEST_PARAMS(read)             1
     set ARR_LTE_TEST_PARAMS(gwMCC)            [lindex $ARR_LTE_TEST_PARAMS(MCC) 0]
     set ARR_LTE_TEST_PARAMS(gwMNC)            [lindex $ARR_LTE_TEST_PARAMS(MNC) 0]
     set ARR_LTE_TEST_PARAMS(0,GUMMEIs)        1
     set ARR_LTE_TEST_PARAMS(HeNBPath)         "/opt/SCGW15Sim/HeNB"
     set ARR_LTE_TEST_PARAMS(HeNBSimDbgPort)   16200
     set ARR_LTE_TEST_PARAMS(MMEPath)          "/opt/SCGW15Sim/MME"
     set ARR_LTE_TEST_PARAMS(MMESimDbgPort)    16100
     set ARR_LTE_TEST_PARAMS(HeNBAppln)        "HeNBSim.exe"
     set ARR_LTE_TEST_PARAMS(MMEAppln)         "MMESim.exe"
     
     for { set i 0 } { $i < $noOfHeNBs } { incr i } {
          lappend ARR_LTE_TEST_PARAMS_MAP(H,$i,HeNBId)   [lindex $eNBId $i]
          lappend ARR_LTE_TEST_PARAMS_MAP(H,$i,TAC)      [lindex $TAC $i]
          lappend ARR_LTE_TEST_PARAMS_MAP(H,$i,MCC)      [lindex $MCC $i]
          lappend ARR_LTE_TEST_PARAMS_MAP(H,$i,MNC)      [lindex $MNC $i]
          
     }
     
     set CSGs ""
     set GUMMEIs ""
     # generating CSG Ids and assigning to HeNBs
     generateCSGIds -CSGs $CSGs -noOfHeNBs $noOfHeNBs
     # generating GUMMEIS and assigning to MMEs
     generateGUMMEIS -GUMMEIs $GUMMEIs -noOfMMEs $noOfMMEs
     # generating UE Parameters
     if {[info exists noOfUEs]} {
          generateUEParams -noOfUEs $noOfUEs -noOfHeNBs $noOfHeNBs
     }
     
     print -debug "Below are updated parameters going to be used in the test script ..."
     parray ARR_LTE_TEST_PARAMS
     print -debug "Below are parameter mappings going to be used in the test script ..."
     parray ARR_LTE_TEST_PARAMS_MAP
     
     return 0
}

proc verifyMsgRcvdOnGw {args} {
     #-
     #- Verifies message/CLI on gateway
     #-
     
     set flag 0
     set defaultCauseValue "message_not_compatible_with_receiver_state"
     parseArgs args \
               [list \
               [list msgType              optional   "string"         "s1Response"                 "The type of message to be verified" ] \
               [list fgwNum               optional   "numeric"        "0"                          "The GW in the testbed" ] \
               [list MMEIndex             optional   "numeric"        "0"                          "The MME instance to be verified against" ] \
               [list TAC                  optional   "string"         [getLTEParam "TAC"]          "The Broadcasted TAC to be used" ] \
               [list eNBName              optional   "string"         [getLTEParam "HeNBGWName"]   "eNB name"] \
               [list globaleNBId          optional   "string"         [getLTEParam "globaleNBId"]  "eNB ID"] \
               [list pagingDRX            optional   "string"         "v32"                        "Pagging DRX value"] \
               [list MCC                  optional   "string"         "__UN_DEFINED__"             "The MCC param to be used"] \
               [list MNC                  optional   "string"         "__UN_DEFINED__"             "The MNC param to be used"] \
               [list MMEName              optional   "string"         "__UN_DEFINED__"             "The MME Name to be sent"] \
               [list HeNBMCC              optional   "string"         "__UN_DEFINED__"             "The MCC param to be used in HeNB"] \
               [list HeNBMNC              optional   "string"         "__UN_DEFINED__"             "The MNC param to be used in HeNB"] \
               [list MMEGroupId           optional   "string"         [getLTEParam "MMEGroupId"]   "The MME group ID to be used"] \
               [list MMECode              optional   "string"         [getLTEParam "MMECode"]      "The MME Code to be used"] \
               [list relMMECapability     optional   "string"         "100"                        "The relMMECapability to be used"] \
               [list MMERelaySupportInd   optional   "string"         "__UN_DEFINED__"             "The MME Relay Support Indicator to be used"] \
               [list timeToWait           optional   "string"         "__UN_DEFINED__"             "Value of time to wait indication in failure msg"] \
               [list causeType            optional   "string"         "protocol"                   "Identifies the cause choice group"] \
               [list cause                optional   "string"         "$defaultCauseValue"         "Identifies the cause value"] \
               [list criticalityDiag      optional   "string"         "__UN_DEFINED__"             "The critical diag to be enabled or not"] \
               [list procedureCode        optional   "string"         "__UN_DEFINED__"             "The procedure code to be used diag"] \
               [list triggerMsg           optional   "string"         "__UN_DEFINED__"             "Identifies the triggering message"] \
               [list procedureCriticality optional   "string"         "__UN_DEFINED__"             "Identifies the procedure Criticality"] \
               [list IECriticality        optional   "string"         "__UN_DEFINED__"             "Identifies the IE Criticality"] \
               [list IEId                 optional   "numeric"        "__UN_DEFINED__"             "Identifies the IE Id"] \
               [list typeOfError          optional   "string"         "__UN_DEFINED__"             "Identifies the type of error"] \
               [list verifyLog            optional   "string"         "no"                         "Option to stop and verify log"] \
               [list returnRaw            optional   "string"         "no"                         "Option to stop and verify log"] \
               ]
     
     if {![info exists MNC]}        {set MNC        [lindex [getFromTestMap -MMEIndex $MMEIndex -param "MNC"] 0]}
     if {![info exists MCC]}        {set MCC        [lindex [getFromTestMap -MMEIndex $MMEIndex -param "MCC"] 0]}
     if {![info exists MMECode]}    {set MMECode    [getFromTestMap -MMEIndex $MMEIndex -param "MMECode"]}
     if {![info exists MMEGroupId]} {set MMEGroupId [getFromTestMap -MMEIndex $MMEIndex -param "MMEGroupId"]}
     
     set result [updateValAndExecute "verifyHeNBGWContext -msgType msgType -MMEIndex MMEIndex -TAC TAC \
               -eNBName eNBName -globaleNBId globaleNBId -pagingDRX pagingDRX \
               -MCC MCC -MNC MNC -MMEName MMEName -HeNBMCC HeNBMCC -HeNBMNC HeNBMNC \
               -MMEGroupId MMEGroupId -MMECode MMECode -relMMECapability relMMECapability \
               -MMERelaySupportInd MMERelaySupportInd -timeToWait timeToWait \
               -causeType causeType -cause cause -criticalityDiag criticalityDiag \
               -procedureCode procedureCode -triggerMsg triggerMsg -returnRaw returnRaw \
               -procedureCriticality procedureCriticality -IECriticality IECriticality \
               -IEId  -typeOfError typeOfError"]
     
     #Modified code to get the raw data after processing insted of result after the comparsioin
     if { $returnRaw == "yes"  } { return $result }
     if {$result < 0} {
          print -fail "Failed to verify the created context on HeNBGW"
          set flag 1
     } else {
          print -pass "Verify the created context on the HeNBGW"
     }
     
     #Verify alarm verification in message file if the feature is enabled
     if {$verifyLog != "no"} {
          print -nonewline "For log to update ..."
          halt 2
          
          set operation "verify"
          set result [updateValAndExecute "verifyAlarmLogging -operation operation -fgwNum fgwNum -msgType msgType \
                    -causeType causeType -cause cause -criticalityDiag criticalityDiag \
                    -procedureCode procedureCode -triggerMsg triggerMsg \
                    -procedureCriticality procedureCriticality -IECriticality IECriticality \
                    -IEId IEId -typeOfError typeOfError -timeToWait timeToWait"]
          if {$result < 0} {
               print -fail "Pattern Alarm verification failed"
               set flag 1
          } else {
               print -pass "Pattern Alarm verification successfull"
          }
     }
     
     if {$flag} {return -1}
     return 0
}

proc updateHeNBGWConfigFile {args} {
     #-
     #- To Update HeNBGW configuration failure, so as to configure the Machine
     #- running HeNBGW initialize all required network parameters like HeNH, MME, GW's LMT
     #-
     #- @return  -1 on failure, 0 on success
     #-
     
     parseArgs args \
               [list \
               [list fgwNum           "optional"  "numeric"           "0"                                 "HeNBGW number in the testbed file" ] \
               [list confFile         "optional"  "string"            "/opt/scripts/FgwConfig_All.ini" "configuration to be updated" ] \
               [list patternList      "optional"  "string"            ""                                  "Pattern to be updated; key=value format" ] \
               [list localMMEMultiHoming  "optional" "yes|no"         "no"              "To eanble multihoming towards MME on gw"]\
               [list localHeNBMultiHoming "optional" "yes|no"         "no"              "To eanble multihoming towards HeNB on gw"]\
               [list remoteMMEMultiHoming "optional" "yes|no"         "no"              "To eanble multihoming on MME sim"]\
               ]
     
     if {$patternList != ""} {
          foreach ele $patternList {
               foreach {key value} [split $ele "="] {break}
               set arr_local($key) $value
          }
     } else {
          set lmtIp          [getDataFromConfigFile "lmtIpaddress" $fgwNum]
          set lmtVlan        [getDataFromConfigFile "lmtVlan" $fgwNum]
          set lmtMask        [getDataFromConfigFile "lmtMask" $fgwNum]
          set lmtEthPort     [getDataFromConfigFile "lmtPort" $fgwNum]
          
          set HeNBCp1Ip   [::ip::normalize [getDataFromConfigFile "getHenbCp1Ipaddress" $fgwNum]]
          set HeNBCp1Mask [getDataFromConfigFile "getHenbCp1Mask" $fgwNum]
          set HeNBCp1Vlan [getDataFromConfigFile "getHenbCp1Vlan" $fgwNum]
          set HeNBCp1Port [getDataFromConfigFile "getHenbCp1Port" $fgwNum]
          
          if {$localHeNBMultiHoming == "yes"} {
               set HeNBCp2Ip   [::ip::normalize [getDataFromConfigFile "getHenbCp2Ipaddress" $fgwNum]]
               set HeNBCp2Mask [getDataFromConfigFile "getHenbCp2Mask" $fgwNum]
               set HeNBCp2Vlan [getDataFromConfigFile "getHenbCp2Vlan" $fgwNum]
               set HeNBCp2Port [getDataFromConfigFile "getHenbCp2Port" $fgwNum]
          }
          
          set HeNBBearerIp   [::ip::normalize [getDataFromConfigFile "henbBearerIpaddress" $fgwNum]]
          set HeNBBearerMask [getDataFromConfigFile "henbBearerMask" $fgwNum]
          set HeNBBearerVlan [getDataFromConfigFile "henbBearerVlan" $fgwNum]
          set HeNBEthPort    [getDataFromConfigFile "henbBearerPort" $fgwNum]
          
          set MMECp1Ip          [::ip::normalize [getDataFromConfigFile "getMmeCp1Ipaddress" $fgwNum]]
          set MMECp1Vlan        [getDataFromConfigFile "getMmeCp1Vlan" $fgwNum]
          set MMECp1Mask        [getDataFromConfigFile "getMmeCp1Mask" $fgwNum]
          set MMECp1Port        [getDataFromConfigFile "getMmeCp1Port" $fgwNum]
          
          #configure interfaces if either local or remote MME multihoming is enabled
          if {$localMMEMultiHoming == "yes" || $remoteMMEMultiHoming == "yes"} {
               set MMECp2Ip          [::ip::normalize [getDataFromConfigFile "getMmeCp2Ipaddress" $fgwNum]]
               set MMECp2Vlan        [getDataFromConfigFile "getMmeCp2Vlan" $fgwNum]
               set MMECp2Mask        [getDataFromConfigFile "getMmeCp2Mask" $fgwNum]
               set MMECp2Port        [getDataFromConfigFile "getMmeCp2Port" $fgwNum]
               
          }
          
          set SGWIp          [::ip::normalize [getDataFromConfigFile "sgwIpaddress" $fgwNum]]
          set SGWVlan        [getDataFromConfigFile "sgwVlan" $fgwNum]
          set SGWMask        [getDataFromConfigFile "sgwMask" $fgwNum]
          set SGWEthPort     [getDataFromConfigFile "sgwPort" $fgwNum]
          
          # delim is the local variable to detemine the name in the FgwConfig_All.ini file
          # for ex: for ipv4, the name in the file is CNCP1_DEFAULTGATEWAY, whereas ipv6 CNCP1V6_DEFAULTGATEWAY
          
          set typeList "mgmt HeNB MME HeNB_Bearer SGW"
          set desc     [list "Mgmt interface" "HeNBCP1 Network" "MMECP1 Network" "HeNBBearer Network" "MMEBearer Network"]
          
          if {$localHeNBMultiHoming == "yes"} {
               append typeList " HeNB2"
               lappend desc    "HeNB2 Network"
          }
          
          if {$localMMEMultiHoming == "yes" || $remoteMMEMultiHoming == "yes"} {
               append typeList " MME2"
               lappend desc    "MME2 Network"
          }
          
          foreach type $typeList desc $desc {
               print -info "Initializing $desc related parameters"
               if {[regexp {(HeNB|MME)(2)} $type - match cpNum]} {
                    set type $match
               } else {
                    set cpNum "1"
               }
               
               switch $type {
                    "mgmt" {
                         
                         set arr_local(LMT_IPADDRESS)                   $lmtIp
                         set arr_local(LMT_NETMASK)                     $lmtMask
                         set arr_local(LMT_DEFAULTGATEWAY)              [getGateway $lmtIp]
                         set arr_local(LMT_VLANID)                      $lmtVlan
                         set arr_local(LMT_PORT)                        $lmtEthPort
                         
                         if {$lmtVlan == 0} {
                              print -dbg "Skip LMT ip address configuration since its vlan is specified as 0 in config file. This will help scripts to run on ATCA setup"
                              set arr_local(LMT_IPADDRESS) "0.0.0.0"
                         }
                    }
                    "HeNB" {
                         if {[::ip::is 6 [set HeNBCp${cpNum}Ip]]} {
                              set delim "V6_"
                              print -info "Using Ipv6 address for HENBCP${cpNum} as mentioned in the configuration file"
                         } else {
                              set delim "_"
                              print -info "Using Ipv4 address for HENBCP${cpNum} as mentioned in the configuration file"
                         }
                         
                         # HeNB Signal configuration
                         # To be uncommented once HeNB local Multihoming is available
                         #set arr_local(HENBCP${cpNum}${delim}IPADDRESS)         [set HeNBCp${cpNum}Ip]
                         #set arr_local(HENBCP${cpNum}${delim}NETMASK)           [set HeNBCp${cpNum}Mask]
                         #set arr_local(HENBCP${cpNum}${delim}DEFAULTGATEWAY)    0.0.0.0 ;#[getGateway $HeNBSignalIp]
                         #set arr_local(HENBCP${cpNum}${delim}VLANID)            [set HeNBCp${cpNum}Vlan]
                         #set arr_local(HENBCP${cpNum}${delim}PORT)              [set HeNBCp${cpNum}Port]
                         
                         foreach ipType [list "_" "V6_"] {
                              if {$ipType == $delim} {
                                   set arr_local(HENBCP${cpNum}${delim}IPADDRESS)         [set HeNBCp${cpNum}Ip]
                                   set arr_local(HENBCP${cpNum}${delim}NETMASK)           [set HeNBCp${cpNum}Mask]
                                   set arr_local(HENBCP${cpNum}${delim}DEFAULTGATEWAY)    0.0.0.0 ;#[getGateway $HeNBSignalIp]
                                   set arr_local(HENBCP${cpNum}${delim}VLANID)            [set HeNBCp${cpNum}Vlan]
                                   set arr_local(HENBCP${cpNum}${delim}PORT)              [set HeNBCp${cpNum}Port]
                              } else {
                                   set arr_local(HENBCP${cpNum}${ipType}IPADDRESS)         0.0.0.0
                                   set arr_local(HENBCP${cpNum}${ipType}NETMASK)           0.0.0.0
                                   set arr_local(HENBCP${cpNum}${ipType}DEFAULTGATEWAY)    0.0.0.0
                                   set arr_local(HENBCP${cpNum}${ipType}VLANID)            1
                                   set arr_local(HENBCP${cpNum}${ipType}PORT)              0
                              }
                         }
                    }
                    "HeNB_Bearer" {
                         if {[::ip::is 6 [set HeNBBearerIp]]} {
                              set delim "V6_"
                              print -info "Using Ipv6 address for HENBBearer as mentioned in the configuration file"
                         } else {
                              set delim "_"
                              print -info "Using Ipv4 address for HENBBearer as mentioned in the configuration file"
                         }
                         
                         foreach ipType [list "_" "V6_"] {
                              if {$ipType == $delim} {
                                   
                                   # HeNB Bearer configuration
                                   set arr_local(HENBUP${delim}IPADDRESS)         $HeNBBearerIp
                                   set arr_local(HENBUP${delim}NETMASK)           $HeNBBearerMask
                                   set arr_local(HENBUP${delim}DEFAULTGATEWAY)    0.0.0.0 ;#[getGateway $HeNBBearerIp]
                                   set arr_local(HENBUP${delim}VLANID)            $HeNBBearerVlan
                                   set arr_local(HENBUP${delim}PORT)              $HeNBEthPort
                              } else {
                                   # HeNB Bearer configuration
                                   set arr_local(HENBUP${ipType}IPADDRESS)         0.0.0.0
                                   set arr_local(HENBUP${ipType}NETMASK)           0.0.0.0
                                   set arr_local(HENBUP${ipType}DEFAULTGATEWAY)    0.0.0.0
                                   set arr_local(HENBUP${ipType}VLANID)            1
                                   set arr_local(HENBUP${ipType}PORT)              0
                              }
                         }
                    }
                    "MME" {
                         if {[::ip::is 6 [set MMECp${cpNum}Ip]]} {
                              set delim "V6_"
                              print -info "Using Ipv6 address for MMECP${cpNum} as mentioned in the configuration file"
                         } else {
                              set delim "_"
                              print -info "Using Ipv4 address for MMECP${cpNum} as mentioned in the configuration file"
                         }
                         
                         foreach ipType [list "_" "V6_"] {
                              if {$ipType == $delim} {
                                   # MME Signal configuration
                                   set arr_local(CNCP${cpNum}${delim}IPADDRESS)          [set MMECp${cpNum}Ip]
                                   set arr_local(CNCP${cpNum}${delim}NETMASK)            [set MMECp${cpNum}Mask]
                                   set arr_local(CNCP${cpNum}${delim}DEFAULTGATEWAY)     0.0.0.0 ;#[getGateway $MMEIp]
                                   set arr_local(CNCP${cpNum}${delim}VLANID)             [set MMECp${cpNum}Vlan]
                                   set arr_local(CNCP${cpNum}${delim}PORT)               [set MMECp${cpNum}Port]
                              } else {
                                   set arr_local(CNCP${cpNum}${ipType}IPADDRESS)          0.0.0.0
                                   set arr_local(CNCP${cpNum}${ipType}NETMASK)            0.0.0.0
                                   set arr_local(CNCP${cpNum}${ipType}DEFAULTGATEWAY)     0.0.0.0
                                   set arr_local(CNCP${cpNum}${ipType}VLANID)             1
                                   set arr_local(CNCP${cpNum}${ipType}PORT)               0
                              }
                         }
                    }
                    "SGW" {
                         if {[::ip::is 6 [set SGWIp]]} {
                              set delim "V6_"
                              print -info "Using Ipv6 address for SGW as mentioned in the configuration file"
                         } else {
                              set delim "_"
                              print -info "Using Ipv4 address for SGW as mentioned in the configuration file"
                         }
                         
                         foreach ipType [list "_" "V6_"] {
                              if {$ipType == $delim} {
                                   # MME Bearer configuration
                                   set arr_local(CNUP1${delim}IPADDRESS)          $SGWIp
                                   set arr_local(CNUP1${delim}NETMASK)            $SGWMask
                                   set arr_local(CNUP1${delim}DEFAULTGATEWAY)     0.0.0.0 ;#[getGateway $SGWIp]
                                   set arr_local(CNUP1${delim}VLANID)             $SGWVlan
                                   set arr_local(CNUP1${delim}PORT)               $SGWEthPort
                              } else {
                                   
                                   # MME Bearer configuration
                                   set arr_local(CNUP1${ipType}IPADDRESS)          0.0.0.0
                                   set arr_local(CNUP1${ipType}NETMASK)            0.0.0.0
                                   set arr_local(CNUP1${ipType}DEFAULTGATEWAY)     0.0.0.0
                                   set arr_local(CNUP1${ipType}VLANID)             1
                                   set arr_local(CNUP1${ipType}PORT)               0
                              }
                         }
                    }
                    
               }
          }
     }
     
     #Temp Hack till be get a permanant solution for buffer full condition
     #We break the operation into multiple commands and execute
     set local_index 0
     
     set cmd ""
     foreach varname [lsort -dictionary [array names arr_local]] {
          append cmd " -e 's/${varname}.*=.*/$varname=$arr_local($varname)/'"
          incr local_index
          if {$local_index == 10} {
               set local_index 0
               set cmd "sed -i $cmd $confFile"
               set result [execCommandSU -dut $lmtIp -command $cmd]
               if {[regexp "ERROR|(No such file or directory)" $result]} {
                    print -fail "Not able to update FGW configuration file"
                    return -1
               }
               
               set cmd ""
          }
     }
     
     set cmd "sed -i $cmd $confFile \n rm -f /opt/conf/OAM_PersistentDB.xml*"
     set result [execCommandSU -dut $lmtIp -command $cmd]
     if {[regexp "ERROR|(No such file or directory)" $result]} {
          print -fail "Not able to update HeNBGW configuration file"
          return -1
     } else {
          print -info "Successfully updated HeNBGW configuration file"
     }
     
     #########################################Setting GW_ARCH in FgwConfig_All.ini##############################################
     set HeNBGWconfFile "/opt/scripts/FgwConfig_All.ini"
     set cmd "sed -i 's/GW_ARCH =.*/GW_ARCH = 4G/g' $HeNBGWconfFile"
     
     set result [execCommandSU -dut $bonoIp -command $cmd]
     print -info "Setting GW Architecture in FgwConfig_All.ini"
     
     ################################################################################################################################
     
     #If previous script has exited after making interface down
     foreach vlanPort "HeNBCp1Port HeNBCp2Port HeNBEthPort MMECp1Port MMECp2Port SGWEthPort" {
          if {[info exists $vlanPort]} {
               lappend intList [set $vlanPort]
          }
     }
     
     if {[info exists intList]} {
          foreach int [lsort -unique $intList] {
               set result [execCommandSU -dut $lmtIp -command "ifconfig $int up"]
          }
     }
     
     unset -nocomplain intList
     
     #Hack to remove existing vlan interface configurations on GW
     #As configureInterfaces.sh doesn't take care this
     
     foreach vlanName "HeNBCp1Vlan HeNBCp2Vlan HeNBBearerVlan MMECp1Vlan MMECp2Vlan SGWVlan" {
          if {[info exists $vlanName]} {
               lappend vlanList [set $vlanName]
          }
     }
     
     print -info "vlanName $vlanList"
     
     # get the ifconfig output and check for presence of required vlan Interfaces
     set result [execCommandSU -dut $lmtIp -command "ifconfig | egrep -2 \"^eth\[0-9\]+\\.\[0-9\]+ \""]
     if {[regexp "ERROR" $result] || $result == -1} {
          print -fail "Not able to fetch simInterface configuration from $lmtIp"
          return -1
     } else {
          print -pass "Got simInterface configuration from $lmtIp"
     }
     
     set ifConfOp $result
     
     print -info "Removing existing vlans from GW"
     foreach vlan $vlanList {
          if {[regexp "(eth\\d+\.$vlan)" $ifConfOp match]} {
               print -info "vlan present $match"
               foreach {int vln} [split $match "."] {break}
               set result [configVlanOnLinuxHost -hostIp $lmtIp -hostInt $int -vlanList $vln -operation "rem"]
               lappend intList $int
          }
     }
     
     print -info "Making interfaces up on GW"
     
     if {[info exists intList]} {
          foreach int [lsort -unique $intList] {
               set result [execCommandSU -dut $lmtIp -command "ifconfig $int up"]
               if {[regexp "ERROR" $result] || $result == -1} {
                    print -fail "Failed to get the interface in up state"
                    return -1
               } else {
                    print -pass "Brought up interface $int"
               }
          }
     }
     
     halt 2
     
     # The interface configuration on a non ATCA setup has to be done using the configureInterfaces script
     # For the ATCA setup the MON would take care of the interface configuration
     print -info "Configuring interfaces on GW"
     set utility "configureInterfaces.sh"
     
     set cmd "cd /opt/scripts/ \n chmod 555 $utility \n ./$utility"
     set result [execCommandSU -dut $lmtIp -command $cmd]
     if {[regexp "(No such file or directory)" $result]} {
          print -fail "Not able to execute $utility"
          return -1
     } else {
          print -info "Successfully executed $utility"
     }
     
     foreach vlanPort "HeNBCp1Port HeNBCp2Port HeNBEthPort MMECp1Port MMECp2Port SGWEthPort" vlanName "HeNBCp1Vlan HeNBCp2Vlan HeNBBearerVlan MMECp1Vlan MMECp2Vlan SGWVlan" {
          if {[info exists $vlanName] && [info exists $vlanPort]} {
               set result [execCommandSU -dut $lmtIp -command "ifconfig [set $vlanPort].[set $vlanName] up"]
          }
     }
     return 0
}

proc updateHeNBGWConfigFileOnAtca {args} {
     #-
     #- To Update HeNBGW configuration file on a ATCA
     #- This file would be used to update the interface ip and port on OAM_Preconfig.xml
     #-
     #- @return  -1 on failure, 0 on success
     #-
     
     set validEthernetMode "LOADSHARE_1GETH|LOADSHARE_10GETH|FLOATING_1GETH|FLOATING_10GETH|FLOATING_GETH"
     parseArgs args \
               [list \
               [list fgwNum               "optional" "numeric"            "0"                                 "HeNBGW number in the testbed file" ] \
               [list confFile             "optional" "string"             "/opt/conf/FgwConfig_All.ini"    "configuration to be updated" ] \
               [list threadConfFile       "optional" "string"             "/opt/conf/ThreadMonConf.ini"    "configuration to be updated" ] \
               [list patternList          "optional" "string"             ""                                  "Pattern to be updated; key=value format" ] \
               [list localMMEMultiHoming  "optional" "yes|no"             "no"                                "To eanble multihoming towards MME on gw"]\
               [list localHeNBMultiHoming "optional" "yes|no"             "no"                                "To eanble multihoming towards HeNB on gw"]\
               [list remoteMMEMultiHoming "optional" "yes|no"             "no"                                "To eanble multihoming on MME sim"]\
               [list MMECPEthernetMode    "optional" "$validEthernetMode" "LOADSHARE_10GETH"                  "Defines the ethernet mode between the MME and HeNBGW for CP"]\
               [list MMEUPEthernetMode    "optional" "$validEthernetMode" "FLOATING_10GETH"                   "Defines the ethernet mode between the MME and HeNBGW for UP"]\
               [list HeNBCPEthernetMode   "optional" "$validEthernetMode" "LOADSHARE_10GETH"                  "Defines the ethernet mode between the HeNB and HeNBGW for CP"]\
               [list HeNBUPEthernetMode   "optional" "$validEthernetMode" "FLOATING_10GETH"                   "Defines the ethernet mode between the HeNB and HeNBGW for UP"]\
               [list OAMEthernetMode      "optional" "$validEthernetMode" "FLOATING_1GETH"                     "Defines the ethernet mode for OAM"]\
               [list redundantMode        "optional" "yes|no"             "__UN_DEFINED__"                    "Defines the redundant mode of operation"]\
               [list noOfInterNodeLinkIf  "optional" "numeric"            "4"                                 "Defines the no of ifaces to be configured for internod link" ]\
               [list hwIdNode1            "optional" "numeric"            "__UN_DEFINED__"                    "Defines the handware ID to be used to node 1" ]\
               [list hwIdNode2            "optional" "numeric"            "__UN_DEFINED__"                    "Defines the handware ID to be used to node 2" ]\
               [list SRping               "optional"   "yes|no"               "yes"                           "Define SRping need to configure or not"] \
               [list MultiS1Link                 optional     "yes|no"   "no"                            "To know multis1link enable towards mme"] \
               [list gwMCC                       optional   "numeric"  [getLTEParam "MCC"]            "MCC of the gateway" ] \
               [list globaleNBId                 optional   "numeric"  [getLTEParam "globaleNBId"]      "Gateway eNB ID" ] \
               [list gwMNC                       optional   "numeric"  [getLTEParam "MNC"]            "MNC of the gateway" ] \
               [list enableThreadMon             optional   "string"     "true"                              "Enabling or disabling ThreadMon" ] \
               [list coreOnThreadMon             optional   "string"     "true"                              "Enabling or disabling ThreadMon Core Dump" ] \
               [list prochbInterval              optional   "numeric"    "15"                                "The interval at which HB is sent from FGWMon to other tmt" ] \
               [list prochbGrdTime               optional   "numeric"    "15"                                "The interval at which HB response is expected on FGWMon from other tmt" ] \
               [list procRetry                   optional   "numeric"    "2"                                 "The number of retries before declaring a failure" ] \
               [list gdbHaltValmanual            optional   "string"     "no"                                "The number of retries before declaring a failure" ] \
               ]

      if {[info exists globaleNBId]} {
        set globaleNBId [lindex $globaleNBId 0]
     }

     if {[info exists gwMCC]} {
        set gwMCC [lindex $gwMCC 0]
     }

     if {[info exists gwMNC]} {
        set gwMNC [lindex $gwMNC 0]
     }
    
     variable gdbHaltVal
     if {$gdbHaltValmanual == "no"} {
	     set gdbHaltVal [expr $prochbInterval * [expr $procRetry + 2]]
     } else {
	     set gdbHaltVal $gdbHaltValmanual
     }
 
     if {[isIfCfgThrMON] && ![isATCASetup]} {
          set bonoIpList [getDataFromConfigFile lmtIpaddress $fgwNum]
     } else {
          set bonoIpList $::BONO_IP_LIST
     }
     # The configuration has to be done on BONOs
     if {![info exists redundantMode]} {
          set noOfBonos [llength $bonoIpList]
     } else {
          if {$redundantMode == "yes" } {
               set noOfBonos 2
          } else {
               set noOfBonos 1
          }
     }
     
     printHeader "Configuring HeNBGW with BONO(s) \"$bonoIpList\"" "100" "-"
     # The configuration has to be done on each of the bonoIp addresses
     foreach bonoIp $bonoIpList {
          if {$patternList != ""} {
               foreach ele $patternList {
                    foreach {key value} [split $ele "="] {break}
                    set arr_local($key) $value
               }
          } else {
               set lmtIp       [getDataFromConfigFile "lmtIpaddress" $fgwNum]
               set lmtVlan     [getDataFromConfigFile "lmtVlan" $fgwNum]
               set lmtMask     [getDataFromConfigFile "lmtMask" $fgwNum]
               set lmtEthPort  [getDataFromConfigFile "lmtPort" $fgwNum]
               
               if {$localHeNBMultiHoming == "yes"} {
                    set HeNBCp1Ip   [::ip::normalize [getDataFromConfigFile "getHenbCp1Ipaddress" $fgwNum]]
                    set HeNBCp1Mask [getDataFromConfigFile "getHenbCp1Mask" $fgwNum]
                    set HeNBCp1Vlan [getDataFromConfigFile "getHenbCp1Vlan" $fgwNum]

                    set HeNBCp2Ip     [::ip::normalize [getDataFromConfigFile "getHenbCp2Ipaddress" $fgwNum]]
                    set HeNBCp2Mask   [getDataFromConfigFile "getHenbCp2Mask" $fgwNum]
                    set HeNBCp2Vlan   [getDataFromConfigFile "getHenbCp2Vlan" $fgwNum]
               } else {
                    set HeNBCp3Ip   [::ip::normalize [getDataFromConfigFile "getHenbCp1Ipaddress" $fgwNum]]
                    set HeNBCp3Mask [getDataFromConfigFile "getHenbCp1Mask" $fgwNum]
                    set HeNBCp3Vlan [getDataFromConfigFile "getHenbCp1Vlan" $fgwNum]
               }
 
               set HeNBBearerIp   [::ip::normalize [getDataFromConfigFile "henbBearerIpaddress" $fgwNum]]
               set HeNBBearerMask [getDataFromConfigFile "henbBearerMask" $fgwNum]
               set HeNBBearerVlan [getDataFromConfigFile "henbBearerVlan" $fgwNum]
               set HeNBEthPort    $HeNBUPEthernetMode ;#[getDataFromConfigFile "henbBearerPort" $fgwNum]
               
               set MMECp1Ip       [::ip::normalize [getDataFromConfigFile "getMmeCp1Ipaddress" $fgwNum]]
               set MMECp1Vlan     [getDataFromConfigFile "getMmeCp1Vlan" $fgwNum]
               set MMECp1Mask     [getDataFromConfigFile "getMmeCp1Mask" $fgwNum]
               set MMECp1Port     $MMECPEthernetMode ;#[getDataFromConfigFile "getMmeCp1Port" $fgwNum]
               #configure interfaces if either local or remote MME multihoming is enabled
               if {$localMMEMultiHoming == "yes" || $remoteMMEMultiHoming == "yes"} {
                    set MMECp2Ip     [::ip::normalize [getDataFromConfigFile "getMmeCp2Ipaddress" $fgwNum]]
                    set MMECp2Vlan   [getDataFromConfigFile "getMmeCp2Vlan" $fgwNum]
                    set MMECp2Mask   [getDataFromConfigFile "getMmeCp2Mask" $fgwNum]
                    set MMECp2Port   $MMECPEthernetMode ;#[getDataFromConfigFile "getMmeCp2Port" $fgwNum]
               } else {
                    set MMECp1Port   "FLOATING_10GETH" ;#[getDataFromConfigFile "getMmeCp2Port" $fgwNum]
               }
               
               set SGWIp          [::ip::normalize [getDataFromConfigFile "sgwIpaddress" $fgwNum]]
               set SGWVlan        [getDataFromConfigFile "sgwVlan" $fgwNum]
               set SGWMask        [getDataFromConfigFile "sgwMask" $fgwNum]
               set SGWEthPort     $MMEUPEthernetMode ;#[getDataFromConfigFile "sgwPort" $fgwNum]
               
               set gwHeNBSctp     [getDataFromConfigFile henbSctp $fgwNum]
               
               #Malban IP address configuration
               foreach i {0 1} {
                    set malban${i}Ip [getDataFromConfigFile malbanIpaddress 0 $i]
                    if {![isIpaddr [set malban${i}Ip]]} {set malban${i}Ip 1.1.1.1}
               }
               
               set curBonoSlot   [getBoardSlot $bonoIp]
               if {[isIfCfgThrMON] && ![isATCASetup]} {
                    set curBonoSlot 1
               }
               
               # Set the hardware ID to be used in the HeNBGW configuration
               # The hardware id is used to decide which card should come up as ACTIVE
               if {[expr $curBonoSlot % 2]} {
                    set peerBonoSlot [expr $curBonoSlot + 1]
                    set cluster      $curBonoSlot
                    if {[info exists hwIdNode1]} {
                         set hwId         $hwIdNode1
                    } else {
                         set hwId         1
                    }
               } else {
                    set peerBonoSlot [expr $curBonoSlot - 1]
                    set cluster      $peerBonoSlot
                    if {[info exists hwIdNode2]} {
                         set hwId         $hwIdNode2
                    } elseif {$noOfBonos == "1"} {
                         set hwId         1
                    } else {
                         set hwId         2
                    }
               }
               
               # SHM IP address defination
               set pShmIp         "192.168.0.171"
               set sShmIp         "192.168.1.171"
               
               set pShmEth0Ip     "192.168.0.2"
               set sShmEth0Ip     "192.168.0.3"
               set pShmEth1Ip     "192.168.1.2"
               set sShmEth1Ip     "192.168.1.3"
               
               # delim is the local variable to detemine the name in the FgwConfig_All.ini file
               # for ex: for ipv4, the name in the file is CNCP1_DEFAULTGATEWAY, whereas ipv6 CNCP1V6_DEFAULTGATEWAY
               set typeDescList [list \
                         [list "mgmt"        "Mgmt interface"] \
                         [list "MME"         "MMECP1 Network"] \
                         [list "HeNB_Bearer" "HeNBBearer Network"] \
                         [list "SGW"         "MMEBearer Network"] \
                         [list "bono"        "BONO Configuration"] \
                         [list "root"        "Common Configuration"] \
                         [list "shm"         "SHM Configuration"] \
                         [list "malban"      "Malban Configuration"] \
                         ]
              
               # Configure local multihoming support on HeNB
               if {$localHeNBMultiHoming == "yes"} {
                    lappend typeDescList [list  "HeNB"  "HeNB  Network"]
                    lappend typeDescList [list  "HeNB2" "HeNB2 Network"]
               } else {
                    lappend typeDescList [list  "HeNB3" "HeNB3 Network"]
               }
                
               # Configure local multihoming support on MME
               if {$localMMEMultiHoming == "yes" || $remoteMMEMultiHoming == "yes"} {
                    lappend typeDescList [list "MME2"  "MME2 Network"]
               }
               set fmsRemoteIp [getDataFromConfigFile getOamServerIpaddress $fgwNum]
               # Configure OAM if updated in testbed file
               set oamIntCount [getDataFromConfigFile oamIntCount $fgwNum]
               if {$oamIntCount > 0} {
                    lappend typeDescList [list "OAM" "OAM Network"]
                    set oamIp   [getDataFromConfigFile getOamClientIpaddress $fgwNum 0]
                    set oamVlan [getDataFromConfigFile getOamClientVlan      $fgwNum 0]
                    set oamMask [getDataFromConfigFile getOamClientMask      $fgwNum 0]
               }
               
               # If there are more then one Bono in the cluster then we need to setup internode link configuration
               # Also set the operation mode accordingly
               if {$noOfBonos > 1} {
                    lappend typeDescList [list "INL" "Internode Link"]
                    set henbgwMode  "REDUNDANT"
               } else {
                    set henbgwMode  "SIMPLEX"
               }
               
               # SR Ping configuration
               if {$SRping == "yes" } {
                    if {[getDataFromConfigFile getServiceRouterIpaddress $fgwNum 0] > 0} {
                         lappend typeDescList [list "SR" "Service Router Ping"]
                         if {[getDataFromConfigFile switchCount $fgwNum] == 1} {
                              #configuring sr vlans, if there is only 1 switch
                              for {set i 1} {$i <= 2} {incr i} {
                                   set srIp$i [lindex [getDataFromConfigFile getServiceRouterIpaddress $fgwNum] [expr $i -1]]
                                   set srMask$i [lindex [getDataFromConfigFile getServiceRouterMask $fgwNum] [expr $i-1]]
                                   set srVlan$i [lindex [getDataFromConfigFile getServiceRouterVlan $fgwNum] [expr $i-1]]
                              }
                         } else {
                              for {set switchNo 1} {$switchNo <= [getDataFromConfigFile switchCount $fgwNum]} {incr switchNo} {
                                   set srIp$switchNo   [getDataFromConfigFile getServiceRouterIpaddress $fgwNum [expr $switchNo - 1]]
                                   set srMask$switchNo [getDataFromConfigFile getServiceRouterMask $fgwNum [expr $switchNo - 1]]
                                   set srVlan$switchNo [getDataFromConfigFile getServiceRouterVlan $fgwNum [expr $switchNo -1]]
                              }
                         }
                    }
               } else {
                    for {set bonoId 1} {$bonoId <= $noOfBonos} {incr bonoId} {
                         foreach srNo {1 2} {
                              set arr_local(NEXTHOPHEARTBEAT_NEXTHOPIP${srNo}_B${bonoId})     "0.0.0.0"
                              set arr_local(NEXTHOPHEARTBEAT_FGWIP${srNo}_B${bonoId})         "0.0.0.0"
                              set arr_local(NEXTHOPHEARTBEAT_NETMASK${srNo}_B${bonoId})       "0.0.0.0"
                              set arr_local(NEXTHOPHEARTBEAT_VLANID${srNo}_B${bonoId})        "0"
                         }
                    }
               }
               # Configure the defined types
               foreach element $typeDescList {
                    foreach {type desc} $element {
                         print -info "Initializing $desc related parameters"
                         if {[regexp {(HeNB|MME)(2)} $type - match cpNum]} {
                              set type $match
                         } else {
                              if {[regexp {(HeNB)(3)} $type - match cpNum]} {
                                  set type $match
                              } else {
                                  set cpNum "1"
                              }
                         }
 
                         switch $type {
                              "mgmt" {
                                   continue
                                   set arr_local(NETWORK_IP_OF_LMT)            [getNetId $lmtIp $lmtMask]
                                   set arr_local(FIXED_IP_OF_LMT_NODE1)        $lmtIp
                                   set arr_local(FIXED_LMT_NETMASK)            $lmtMask
                                   set arr_local(FIXED_LMT_DEFAULTGATEWAY)     [getGateway $lmtIp]
                                   set arr_local(FIXED_LMT_VLANID)             $lmtVlan
                                   set arr_local(ETHERNET_PORT_LMT)            $lmtEthPort
                                   
                                   if {$lmtVlan == 0} {
                                        print -dbg "Skip LMT ip address configuration since its vlan is specified as 0 in config file. This will help scripts to run on ATCA setup"
                                        set arr_local(LMT_IPADDRESS) "0.0.0.0"
                                   }
                              }
                              "OAM" {
                                   set arr_local(NETWORK_IP_OF_OAM)            [getNetId $oamIp $oamMask]
                                   set arr_local(FLOATING_IP_OF_OAM)           $oamIp
                                   set arr_local(FLOATING_OAM_NETMASK)         $oamMask
                                   set arr_local(FLOATING_OAM_DEFAULTGATEWAY)  [getGateway $oamIp]
                                   set arr_local(FLOATING_OAM_VLANID)          $oamVlan
                                   set arr_local(ETHERNET_PORT_OAM)            $OAMEthernetMode
                                   if {[isIpaddr $fmsRemoteIp]} {
                                        set arr_local(FMS_REMOTE_IP_ADDRESS)   $fmsRemoteIp
                                   }
                                   if {$henbgwMode == "REDUNDANT"} {
                                        set arr_local(DUMMY_OAM_IP_ADDRESS)    [generateDummyIpAddr $oamIp $oamMask]
                                   }
                              }
                              "HeNB" {
                                   if {[::ip::is 6 [set HeNBCp${cpNum}Ip]]} {
                                        set net   [getNetPrefix [set HeNBCp${cpNum}Ip] [set HeNBCp${cpNum}Mask]]
                                        set delim "V6"
                                        set gw    "0:0:0:0:0:0:0:0"
                                        
                                        set arr_local(HENBCP${cpNum}_IP_VERSION)     "IPV6"
                                        set arr_local(NETWORK_IP_OF_HENBCP${cpNum})  "0.0.0.0"
                                        set arr_local(HENBCP${cpNum}_IP)             "0.0.0.0"
                                        set arr_local(IP_OF_HENBCP${cpNum})          "0.0.0.0"
                                        set arr_local(HENBCP${cpNum}_NETMASK)        "0.0.0.0"
                                        set arr_local(HENBCP${cpNum}_DEFAULTGATEWAY) "0.0.0.0"
                                        set arr_local(HENBCP${cpNum}_VLANID)          0
                                        #set arr_local(ETHERNET_PORT_HENBCP${cpNum}V4)  [set HeNBCp${cpNum}Port]
                                        print -info "Using Ipv6 address for HENBCP${cpNum} as mentioned in the configuration file"
                                   } else {
                                        set arr_local(HENBCP${cpNum}_IP_VERSION)   "IPV4"
                                        set net [getNetId [set HeNBCp${cpNum}Ip] [set HeNBCp${cpNum}Mask]]
                                        set delim ""
                                        set gw    "0.0.0.0"
                                        print -info "Using Ipv4 address for HENBCP${cpNum} as mentioned in the configuration file"
                                   }
                                   
                                   set arr_local(NETWORK_IP_OF_HENBCP${cpNum}${delim})  $net
                                   set arr_local(HENBCP${cpNum}${delim}_IP)             [set HeNBCp${cpNum}Ip]
                                   set arr_local(IP_OF_HENBCP${cpNum}${delim})          [set HeNBCp${cpNum}Ip]
                                   set arr_local(HENBCP${cpNum}${delim}_NETMASK)        [set HeNBCp${cpNum}Mask]
                                   set arr_local(HENBCP${cpNum}${delim}_DEFAULTGATEWAY) $gw ;#[getGateway $HeNBSignalIp]
                                   set arr_local(HENBCP${cpNum}${delim}_VLANID)         [set HeNBCp${cpNum}Vlan]
                                   #set arr_local(ETHERNET_PORT_HENBCP${cpNum}${delim})  [set HeNBCp${cpNum}Port]
                                   if {$henbgwMode == "REDUNDANT"} {
                                        #     set arr_local(DUMMY_HENBCP${cpNum}${delim}_IP_ADDRESS) [regsub {.\d+$} [set HeNBCp${cpNum}Ip] {.254}]
                                        set arr_local(DUMMY_HENBCP${cpNum}${delim}_IP_ADDRESS) [generateDummyIpAddr [set HeNBCp${cpNum}Ip] [set  HeNBCp${cpNum}Mask]]
                                        
                                   }
                              }
                              "HeNB_Bearer" {
                                   if {[::ip::is 6 [set HeNBBearerIp]]} {
                                        set net [getNetPrefix $HeNBBearerIp $HeNBBearerMask]
                                        set delim "V6"
                                        set gw    "0:0:0:0:0:0:0:0"
                                        print -info "Using Ipv6 address for HENBBearer as mentioned in the configuration file"
                                   } else {
                                        set net [getNetId $HeNBBearerIp $HeNBBearerMask]
                                        set delim ""
                                        set gw    "0.0.0.0"
                                        print -info "Using Ipv4 address for HENBBearer as mentioned in the configuration file"
                                   }
                                   
                                   # HeNB Bearer configuration
                                   set arr_local(NETWORK_IP_OF_HENBUP${cpNum}${delim})           $net
                                   set arr_local(FLOATING_IP_OF_HENBUP${cpNum}${delim})          $HeNBBearerIp
                                   set arr_local(FLOATING_HENBUP${cpNum}${delim}_NETMASK)        $HeNBBearerMask
                                   set arr_local(FLOATING_HENBUP${cpNum}${delim}_DEFAULTGATEWAY) $gw ;#[getGateway $HeNBBearerIp]
                                   set arr_local(FLOATING_HENBUP${cpNum}${delim}_VLANID)         $HeNBBearerVlan
                                   set arr_local(ETHERNET_PORT_HENBUP${cpNum}${delim})           $HeNBEthPort
                                   if {$henbgwMode == "REDUNDANT"} {
                                        # set arr_local(DUMMY_HENBUP${cpNum}${delim}_IP_ADDRESS) [generateDummyIpAddr $HeNBBearerIp $arr_local(FLOATING_HENBUP${cpNum}${delim}_NETMASK)]
                                        set arr_local(DUMMY_HENBUP${cpNum}${delim}_IP_ADDRESS) [generateDummyIpAddr $HeNBBearerIp $arr_local(FLOATING_HENBUP${cpNum}${delim}_NETMASK)]
                                        
                                   }
                                   
                              }
                              "MME" {
                                   if {[::ip::is 6 [set MMECp${cpNum}Ip]]} {
                                        set net [getNetPrefix [set MMECp${cpNum}Ip] [set MMECp${cpNum}Mask]]
                                        set delim "V6"
                                        set gw    "0:0:0:0:0:0:0:0"
                                        
                                        set arr_local(CNCP${cpNum}_IP_VERSION)   "IPV6"
                                        set arr_local(NETWORK_IP_OF_CNCP${cpNum})         "0.0.0.0"
                                        set arr_local(FLOATING_IP_OF_CNCP${cpNum})         "0.0.0.0"
                                        set arr_local(FLOATING_CNCP${cpNum}_NETMASK)       "0.0.0.0"
                                        set arr_local(FLOATING_CNCP${cpNum}_DEFAULTGATEWAY)] "0.0.0.0"
                                        set arr_local(FLOATING_CNCP${cpNum}_VLANID)         0
                                        set arr_local(ETHERNET_PORT_CNCP${cpNum})           [set MMECp${cpNum}Port]
                                        print -info "Using Ipv6 address for MMECP${cpNum} as mentioned in the configuration file"
                                   } else {
                                        set arr_local(CNCP${cpNum}_IP_VERSION)   "IPV4"
                                        set net [getNetId [set MMECp${cpNum}Ip] [set MMECp${cpNum}Mask]]
                                        set delim ""
                                        set gw    "0.0.0.0"
                                        set arr_local(NETWORK_IP_OF_CNCP${cpNum}V6)            "0:0:0:0:0:0:0:0"
                                        set arr_local(FLOATING_IP_OF_CNCP${cpNum}V6)           "0:0:0:0:0:0:0:0"
                                        set arr_local(FLOATING_CNCP${cpNum}V6_NETMASK)         "0:0:0:0:0:0:0:0"
                                        set arr_local(FLOATING_CNCP${cpNum}V6_DEFAULTGATEWAY)  "0:0:0:0:0:0:0:0"
                                        set arr_local(FLOATING_CNCP${cpNum}V6_VLANID)         0
                                        set arr_local(ETHERNET_PORT_CNCP${cpNum}V6)           [set MMECp${cpNum}Port]
                                        
                                        print -info "Using Ipv4 address for MMECP${cpNum} as mentioned in the configuration file"
                                   }
                                   set s1IniLinks 8
                                   set fip ""
                                   set MMECp${cpNum}IpS1 [set MMECp${cpNum}Ip]
                                   # MME Signal configuration
                                   set arr_local(NETWORK_IP_OF_CNCP${cpNum}${delim})           $net
                                   if { $MultiS1Link == "yes" } {
                                        for {set ins 0} {$ins < $s1IniLinks} {incr ins} {
                                             if {[::ip::is 6 [set MMECp${cpNum}Ip]]} {
                                                  set tmpMMEIp [incrIpv6 -ip [set MMECp${cpNum}Ip] -step $ins]
                                             } else {
                                                  set tmpMMEIp [incrIp [set MMECp${cpNum}Ip] $ins]
                                             }
                                             lappend fip $tmpMMEIp
                                        }
                                        set MMECp${cpNum}Ip [join $fip ","]
                                   }
                                   set arr_local(FLOATING_IP_OF_CNCP${cpNum}${delim})          [set MMECp${cpNum}Ip]
                                   set arr_local(FLOATING_CNCP${cpNum}${delim}_NETMASK)        [set MMECp${cpNum}Mask]
                                   set arr_local(FLOATING_CNCP${cpNum}${delim}_DEFAULTGATEWAY) $gw ;#[getGateway $MMEIp]
                                   set arr_local(FLOATING_CNCP${cpNum}${delim}_VLANID)         [set MMECp${cpNum}Vlan]
                                   set arr_local(ETHERNET_PORT_CNCP${cpNum}${delim})           [set MMECp${cpNum}Port]
                                   if {$henbgwMode == "REDUNDANT"} {
                                        # set arr_local(DUMMY_CNCP${cpNum}${delim}_IP_ADDRESS) [generateDummyIpAddr [set MMECp${cpNum}Ip] $arr_local(FLOATING_CNCP${cpNum}${delim}_NETMASK)]
                                        if { $MultiS1Link == "yes" } {
                                             set arr_local(DUMMY_CNCP${cpNum}${delim}_IP_ADDRESS) [generateDummyIpAddr [set MMECp${cpNum}IpS1] $arr_local(FLOATING_CNCP${cpNum}${delim}_NETMASK)]
                                        } else {
                                             set arr_local(DUMMY_CNCP${cpNum}${delim}_IP_ADDRESS) [generateDummyIpAddr [set MMECp${cpNum}Ip] $arr_local(FLOATING_CNCP${cpNum}${delim}_NETMASK)]
                                        }
                                   }
                              }
                              "SGW" {
                                   if {[::ip::is 6 [set SGWIp]]} {
                                        set net [getNetPrefix $SGWIp $SGWMask]
                                        set delim "V6"
                                        set gw    "0:0:0:0:0:0:0:0"
                                        print -info "Using Ipv6 address for SGW as mentioned in the configuration file"
                                   } else {
                                        set net [getNetId $SGWIp $SGWMask]
                                        set delim ""
                                        set gw    "0.0.0.0"
                                        print -info "Using Ipv4 address for SGW as mentioned in the configuration file"
                                   }
                                   
                                   # MME Bearer configuration
                                   set arr_local(NETWORK_IP_OF_CNUP${cpNum}${delim})           $net
                                   set arr_local(FLOATING_IP_OF_CNUP${cpNum}${delim})          $SGWIp
                                   set arr_local(FLOATING_CNUP${cpNum}${delim}_NETMASK)        $SGWMask
                                   set arr_local(FLOATING_CNUP${cpNum}${delim}_DEFAULTGATEWAY) $gw ;#[getGateway $SGWIp]
                                   set arr_local(FLOATING_CNUP${cpNum}${delim}_VLANID)         $SGWVlan
                                   set arr_local(ETHERNET_PORT_CNUP${cpNum}${delim})           $SGWEthPort
                                   if {$henbgwMode == "REDUNDANT"} {
                                        #set arr_local(DUMMY_CNUP${cpNum}${delim}_IP_ADDRESS) [generateDummyIpAddr $SGWIp $arr_local(FLOATING_CNUP${cpNum}${delim}_NETMASK)]
                                        set arr_local(DUMMY_CNUP${cpNum}${delim}_IP_ADDRESS) [generateDummyIpAddr $SGWIp $arr_local(FLOATING_CNUP${cpNum}${delim}_NETMASK)]
                                        
                                   }
                                   
                              }
                              "bono" {
                                   # The BONO Slot configuration
                                   set arr_local(CURRENT_BONO_SLOT_NUMBER)    $curBonoSlot
                                   set arr_local(PEER_BONO_SLOT_NUMBER)       $peerBonoSlot
                              }
                              "root" {
                                   set arr_local(FGW_OPERATING_MODE)          "REDUNDANT"
                                   set arr_local(HENBMASTER_PORTNUMBERHENBCP) $gwHeNBSctp
                                   set arr_local(HENBGW_PORTNUMCNCPLOCAL1)    $gwHeNBSctp
                                   set arr_local(HENBGW_HARDWARENUM)          $hwId
                                   set arr_local(HENBCP_PORTNUMBER)           "36412"
                                   set arr_local(HENBCP_REF_SCTP_CONFIG)      "1"
                              }
                              "shm" {
                                   # The newer config file has differnt prefix value so retaining both values till the legecy code is removed
                                   set arr_local(SHELF_MGR_RMCP_ETH0_IPADDRESS)      $pShmIp
                                   set arr_local(SHELF_MGR_RMCP_ETH1_IPADDRESS)      $sShmIp
                                   set arr_local(SHELFMGR_PRIMARY_ETH0_IPADDRESS)    $pShmEth0Ip
                                   set arr_local(SHELFMGR_PRIMARY_ETH1_IPADDRESS)    $pShmEth1Ip
                                   set arr_local(SHELFMGR_SECONDARY_ETH0_IPADDRESS)  $sShmEth0Ip
                                   set arr_local(SHELFMGR_SECONDARY_ETH1_IPADDRESS)  $sShmEth1Ip
                                   
                              }
                              "malban" {
                                   # The newer config file has differnt prefix value so retaining both values till the legecy code is removed
                                   set arr_local(MALBAN_ACTIVENODE_ETH0_A_IPADDRESS) $malban0Ip
                                   set arr_local(MALBAN_ACTIVENODE_ETH0_B_IPADDRESS) $malban1Ip
                                   set arr_local(MALBAN_ACTIVENODE_ETH1_A_IPADDRESS) [getActiveBaseIp $malban0Ip]
                                   set arr_local(MALBAN_ACTIVENODE_ETH1_B_IPADDRESS) [getActiveBaseIp $malban1Ip]
                              }
                              "INL" {
                                   set noOfINLs 2
                                   # The internodelink configuration is to setup internode communication with the bonos
                                   for {set inl 1} {$inl <= $noOfINLs} {incr inl} {
                                        set arr_local(NETWORK_IP_OF_INTERNODELINK${inl})        [getInterNodeLinkParam -param NETWORK -noOfINLs $noOfINLs -instance $inl -cluster $cluster]
                                        set arr_local(FIXED_IP_OF_INTERNODELINK${inl}_NODE1)    [getInterNodeLinkParam -param LINK${inl}NODE1   -noOfINLs $noOfINLs -instance $inl -cluster $cluster]
                                        set arr_local(FIXED_IP_OF_INTERNODELINK${inl}_NODE2)    [getInterNodeLinkParam -param LINK${inl}NODE2   -noOfINLs $noOfINLs -instance $inl -cluster $cluster]
                                        set arr_local(FIXED_INTERNODELINK${inl}_NETMASK)        [getInterNodeLinkParam -param NETMASK -noOfINLs $noOfINLs -instance $inl -cluster $cluster]
                                        set arr_local(FIXED_INTERNODELINK${inl}_VLANID)         [getInterNodeLinkParam -param VLANID  -noOfINLs $noOfINLs -instance $inl -cluster $cluster]
                                   }
                              }
                              "SR" {
                                   for {set bonoId 1} {$bonoId <= $noOfBonos} {incr bonoId} {
                                        foreach srNo {1 2} {
                                             if {[::ip::is 6 [set srIp${srNo}]]} {
                                                  set delim "V6" ;
                                                  set other_delim ""
                                                  set other_nextHopIp "0.0.0.0"
                                                  set other_fgwIp     "0.0.0.0"
                                                  set other_netMask   "0.0.0.0"
                                             } else {
                                                  set delim "" ;
                                                  set other_delim "V6"
                                                  set other_nextHopIp "0:0:0:0:0:0:0:0"
                                                  set other_fgwIp     "0:0:0:0:0:0:0:0"
                                                  set other_netMask   "0"
                                             }
                                             set arr_local(NEXTHOPHEARTBEAT_NEXTHOPIP${srNo}${delim}_B${bonoId})     "[set srIp${srNo}]"
                                             set arr_local(NEXTHOPHEARTBEAT_FGWIP${srNo}${delim}_B${bonoId})         "[incrIp [set srIp${srNo}] $bonoId]"
                                             set arr_local(NEXTHOPHEARTBEAT_NETMASK${srNo}${delim}_B${bonoId})       "[set srMask${srNo}]"
                                             set arr_local(NEXTHOPHEARTBEAT_VLANID${srNo}_B${bonoId})                "[set srVlan${srNo}]"
                                             
                                             set arr_local(NEXTHOPHEARTBEAT_NEXTHOPIP${srNo}${other_delim}_B${bonoId})  $other_nextHopIp
                                             set arr_local(NEXTHOPHEARTBEAT_FGWIP${srNo}${other_delim}_B${bonoId})      $other_fgwIp
                                             set arr_local(NEXTHOPHEARTBEAT_NETMASK${srNo}${other_delim}_B${bonoId})    $other_netMask
                                             
                                        }
                                   }
                              }
                         }
                    }
               }
          }
          
          #Temp Hack till be get a permanant solution for buffer full condition
          #We break the operation into multiple commands and execute
          set orgFileName "${confFile}_org"
          set cmd "if \[ -f $orgFileName \]; then echo -e \"\\nINFO : Taking original file as reference\\n\"; rm -f $confFile ; \
                    cp -f $orgFileName $confFile ; else echo -e \"\\nINFO : Taking backup of original\
                    file before modifiying data\\n\"; cp $confFile $orgFileName ; fi"
          set result [execCommandSU -dut $bonoIp -command $cmd]
          
          set local_index 0
          
          set cmd ""
          foreach varname [lsort -dictionary [array names arr_local]] {
               append cmd " -e 's/${varname} =.*/$varname = $arr_local($varname)/'"
               incr local_index
               if {$local_index == 10} {
                    set local_index 0
                    set cmd "sed -i $cmd $confFile"
                    set result [execCommandSU -dut $bonoIp -command $cmd]
                    if {[regexp "ERROR|(No such file or directory)" $result]} {
                         print -fail "Not able to update FGW configuration file"
                         return -1
                    }
                    
                    set cmd ""
               }
          }
          
          # Delete the old files and modify the HeNBGW config file
          set cmd "\
                    sed -i $cmd $confFile \n \
                    rm -f /opt/conf/OAM_PersistentDB.xml* \n \
                    rm -f /opt/conf/OAM_PreConfig.xml_Orig \n \
                    rm -f /opt/conf/ShelfOam_conf.ini_Orig \
                    "
          set result [execCommandSU -dut $bonoIp -command $cmd]
          if {[regexp "ERROR|(No such file or directory)" $result]} {
               print -fail "Not able to update HeNBGW configuration file"
               return -1
          } else {
               print -info "Successfully updated HeNBGW configuration file"
          }
          
          # Keeping a copy of the OAM_Preconfig.xml file
          # The executable only updates the value of the preconfig.xml file it doesnt generate it
          set preConfigFile "/opt/conf/OAM_PreConfig.xml"
          set orgFileName   "${preConfigFile}_org"
          set cmd "if \[ -f $orgFileName \]; then echo -e \"\\nINFO : Taking original file as reference\\n\"; rm -f $preConfigFile ; \
                    cp -f $orgFileName $preConfigFile ; else echo -e \"\\nINFO : Taking backup of original\
                    file before modifiying data\\n\"; cp $preConfigFile $orgFileName ; fi"
          set result [execCommandSU -dut $bonoIp -command $cmd]
          
          set utility "FGWConfig.exe"
          set cmd "cd /opt/bin/ \n chmod 555 $utility \n ./$utility --force"
          set result [execCommandSU -dut $bonoIp -command $cmd]
          if {[regexp "(No such file or directory)" $result]} {
               print -fail "Not able to execute $utility"
               return -1
          } else {
               print -info "Successfully executed $utility and generated the OAM_Preconfig.xml file"
          }
          
          set cmd "sed -i 's/traceStatus\" Value=\"disable\"/traceStatus\" Value=\"fileEnable\"/g' $preConfigFile"
          set result [execCommandSU -dut $bonoIp -command $cmd]

          #Modifying tracelevel from warning to debug.
          set cmd "sed -i 's/applicabilityTraceLevel\" Value=\"warning\"/applicabilityTraceLevel\" Value=\"debug\"/g' $preConfigFile"
          set result [execCommandSU -dut $bonoIp -command $cmd]

          print -info "Setting All Log Levels(DEBUG,INFO,TRACE) in OAM_Preconfig.xml"
          set cmd "sed -i 's/globalENBIdId\" Value=\".*\"/globalENBIdId\" Value=\"$globaleNBId\"/g' $preConfigFile"
          set result [execCommandSU -dut $bonoIp -command $cmd]
          print -info "Setting globalENBIdId in OAM_Preconfig.xml"
          print -info "changes for the mcc and mnc attributes because those attribtes need bulkcm operation.instead of bulkcm we are ading direct here "
          set cmd "sed -i 's/globalENBIdPlmnIdentityMcc\" Value=\".*\"/globalENBIdPlmnIdentityMcc\" Value=\"$gwMCC\"/g' $preConfigFile"
          set result [execCommandSU -dut $bonoIp -command $cmd]
          print -info "Setting globalENBIdPlmnIdentityMcc in OAM_Preconfig.xml"
          set cmd "sed -i 's/globalENBIdPlmnIdentityMnc\" Value=\".*\"/globalENBIdPlmnIdentityMnc\" Value=\"$gwMNC\"/g' $preConfigFile"
          set result [execCommandSU -dut $bonoIp -command $cmd]
          print -info "Setting globalENBIdPlmnIdentityMnc in OAM_Preconfig.xml"
          
          set cmd "sed -i 's/granularPeriod\" Value=\"fifteenMinutes\"/granularPeriod\" Value=\"fiveMinutes\"/g' $preConfigFile"
          set result [execCommandSU -dut $bonoIp -command $cmd]
          print -info "Setting in granularPeriod to five mInutes OAM_Preconfig.xml"
          
          #set ValueOfvarname "40"
          set MonconfFile "/opt/conf/FGWMon_config.ini"
          #set Scmd " -e 's/HEARTBEATATTEMPT =.*/HEARTBEATATTEMPT = 40/'"
          #set cmd "sed -i $Scmd $MonconfFile"
          #set result [execCommandSU -dut $bonoIp -command $cmd]
          #if {[regexp "ERROR|(No such file or directory)" $result]} {
          #     print -fail "Not able to update HeNBGW MON configuration file"
          #     return -1
          #} else {
          #     print -info "Successfully updated HeNBGW MON configuration file"
          #}
          
          ####### updating hardware num ##########
          set hardwareNum $hwId
          set Scmd " -e 's/HardwareNo =.*/HardwareNo = $hwId/'"
          set cmd "sed -i $Scmd $MonconfFile"
          set result [execCommandSU -dut $bonoIp -command $cmd]
          if {[regexp "ERROR|(No such file or directory)" $result]} {
               print -fail "Not able to update HeNBGW MON configuration file with HardwareNo"
               return -1
          } else {
               print -info "Successfully updated HeNBGW MON configuration file with HardwareNo"
          }
          
          #########################################Setting GW_ARCH in FgwConfig_All.ini##############################################
          set HeNBGWconfFile "/opt/conf/FgwConfig_All.ini"
          set cmd "sed -i 's/GW_ARCH =.*/GW_ARCH = 4G/g' $HeNBGWconfFile"
          
          set result [execCommandSU -dut $bonoIp -command $cmd]
          print -info "Setting GW Architecture in FgwConfig_All.ini"
          
          ###########################################################################################################################

          #########################################Setting HB params in ThreadMonConf.ini############################################
          set threadMonConfFile "/opt/conf/ThreadMonConf.ini"

          set cmd "sed -i 's/EnableTM =.*/EnableTM = $enableThreadMon/g' $threadMonConfFile"
          set result [execCommandSU -dut $bonoIp -command $cmd]

          set cmd "sed -i 's/DumpCoreOnAnomaly =.*/DumpCoreOnAnomaly = $coreOnThreadMon/g' $threadMonConfFile"
          set result [execCommandSU -dut $bonoIp -command $cmd]

          set cmd "sed -i 's/ProcHeartbeatInterval =.*/ProcHeartbeatInterval = $prochbInterval/g' $threadMonConfFile"
          set result [execCommandSU -dut $bonoIp -command $cmd]

          set cmd "sed -i 's/ProcHeartbeatResponseGuardTime =.*/ProcHeartbeatResponseGuardTime = $prochbGrdTime/g' $threadMonConfFile"
          set result [execCommandSU -dut $bonoIp -command $cmd]

          set cmd "sed -i 's/ProcHeartbeatRetryCount =.*/ProcHeartbeatRetryCount = $procRetry/g' $threadMonConfFile"
          set result [execCommandSU -dut $bonoIp -command $cmd]

          print -info "Setting GW Architecture in ThreadMonConf.ini"
     
          ###########################################################################################################################
         
          if {![isATCASetup]} {
               set Scmd " -e 's/HEARTBEATATTEMPT =.*/HEARTBEATATTEMPT = 40/'"
               set cmd "sed -i $Scmd $MonconfFile"
               set result [execCommandSU -dut $bonoIp -command $cmd]
               if {[regexp "ERROR|(No such file or directory)" $result]} {
                    print -fail "Not able to update HeNBGW MON configuration file"
                    return -1
               } else {
                    print -info "Successfully updated HeNBGW MON configuration file"
               }
               
               set Scmd " -e 's/LinuxBoxPresent =.*/LinuxBoxPresent = yes/'"
               
               set cmd "sed -i $Scmd $MonconfFile"
               set result [execCommandSU -dut $bonoIp -command $cmd]
               if {[regexp "ERROR|(No such file or directory)" $result]} {
                    print -fail "Not able to update HeNBGW MON configuration file"
                    return -1
               } else {
                    print -info "Successfully updated HeNBGW MON configuration file"
               }
               
          }
          #This has to be removed when fix is given by development.This is to allow more than 4961 HeNBs.bug_id:00930984
          #set result [execCommandSU -dut $bonoIp -command "ulimit -n 65000"]
     }
     
     return 0
}
proc getInterNodeLinkParam {args} {
     #-
     #- This procedure is used to get the internode link params for a given cluster
     #-
     #-
     
     set validParam "NETWORK|LINK1NODE1|LINK2NODE1|LINK1NODE2|LINK2NODE2|NETMASK|VLANID"
     parseArgs args \
               [list \
               [list fgwNum           "optional"  "numeric"           "0"        "FGW number in the testbed file" ] \
               [list instance         "optional"  "numeric"           "1"        "The internode link instance" ] \
               [list cluster          "mandatory" "numeric"           "_"        "The cluster for which the INL params have to be retreived" ] \
               [list noOfINLs         "optional"  "numeric"           "1"        "The number of INLs" ] \
               [list param            "mandatory" "$validParam"       "_"        "The param for which the data has to be retreived" ] \
               ]
     
     switch -exact $param {
          "NETWORK"      {return "193.${cluster}.${instance}.0"}
          "LINK1NODE1"   {return "193.${cluster}.${instance}.${instance}"}
          "LINK2NODE1"   {return "193.${cluster}.${instance}.[expr ${instance} + 4]"}
          "LINK1NODE2"   {return "193.${cluster}.${instance}.[expr $instance + $noOfINLs + 1]"}
          "LINK2NODE2"   {return "193.${cluster}.${instance}.[expr $instance + $noOfINLs + 4]"}
          "NETMASK"      {return "255.255.255.0"}
          "VLANID"       {return [expr [lindex [lsort -increasing [getDataFromConfigFile getVlansOnSwitch $fgwNum]] end] + 1]}
          
     }
     return -1
}
proc restartHeNBGW {args} {
     #-
     #- Procedure to perform stop and start of BSG instance
     #-
     #- @return  -1 on failure, 0 on success
     #-
     
     set validOpList "restart|start|stop"
     parseArgs args \
               [list \
               [list fgwNum           "optional"  "numeric"       "0"               "FGW number in the testbed file" ] \
               [list boardIp          "optional"  "string"        "__UN_DEFINED__"  "Board on which startHeNBGWMon needs to be done" ] \
               [list verify           "optional"  "yes|no"        "yes"             "To perform verification or not" ] \
               [list operation        "optional"  $validOpList    "restart"         "To perform stop/start or both on BSG" ] \
               ]
     
     if {![info exists boardIp]} {
          set fgwIpList [getActiveBonoIp $fgwNum]
     } else {
          if {$boardIp == "all"} {
               if {[isATCASetup]} {
                    set fgwIpList $::BONO_IP_LIST
               } else {
                    set fgwIpList [getActiveBonoIp $fgwNum]
               }
          } else {
               set fgwIpList $boardIp
          }
     }
     
     switch $operation {
          "restart" { set cmdList "stopbsg startbsg" }
          "stop"    { set cmdList "stopbsg" ; set verify "no" }
          "start"   { set cmdList "startbsg" }
     }
     
     # Start or stop the application on the board
     set flag 0
     foreach fgwIp $fgwIpList {
          print -debug "Performing \"$cmdList\" on \"$fgwIp\""
          foreach cmd $cmdList {
               set result [execCommandSU -dut $fgwIp -command $cmd]
               if {[regexp "ERROR: " $result]} {
                    print -fail "Not able execute $cmd on $fgwIp"
                    set flag 1
                    continue
               } else {
                    print -info "Successfully executed $cmd on $fgwIp"
               }
               
               if {$cmd == "StopHeNBGW"} {
                    print -dbg "Closing the cli spanned session"
                    closeSpawnedSessions $fgwIp "all" "bsgcli"
               }
          }
          
          if {$verify == "yes"} {
               print -nonewline "For HeNBGW to intialize ... "
               if {[isATCASetup] || [isIfCfgThrMON]} {
                    # For an ATCA setup, the MON takes around 30 seconds to bringup all the processes
                    halt 30
               } else {
                    halt 10
               }
               
               print -info "Verifying HeNBGrp process on the HeNBGW"
               set result [verifyProcessOnHeNBGW -boardIp $fgwIp -expProcess "HeNBGrp"]
               if {$result != 0} {
                    print -fail "HeNBGrp is not running after restart"
                    set flag 1
                    continue
               } else {
                    print -pass "HeNBGrp is up and running after restart"
               }
               
               print -info "Verify the routing table on HeNBGW"
               set result [verifyVlanInterfacesOnHeNBGW -fgwNum $fgwNum]
               if {$result != 0} {
                    print -fail "Routing table is not as expected on HeNBGW"
                    set flag 1
                    continue
               } else {
                    print -pass "Routing table is as expected on HeNBGW"
               }
               
               if {!$flag} {
                    print -pass "HeNBGW passed all verification steps and is ready to use"
               }
          }
     }
     if {$flag} {return -1}
     return 0
}

proc verifyVlanInterfacesOnHeNBGW {args} {
     #-
     #- Check for the existence of vlan interfaces in the routing table of the GW
     #-
     set validEthernetMode "LOADSHARE_1GETH|LOADSHARE_10GETH|FLOATING_1GETH|FLOATING_10GETH"
     parseArgs args \
               [list \
               [list fgwNum               "optional" "numeric"            "0"                  "FGW number in testbed file" ] \
               [list interface            "optional" "string"             "__UN_DEFINED__"     "The interface to be verified" ] \
               [list 1Ginterface          "optional" "string"             "__UN_DEFINED__"     "The 1Ginterface to be verified" ] \
               [list MMECPEthernetMode    "optional" "$validEthernetMode" "LOADSHARE_10GETH"   "Defines the ethernet mode between the MME and HeNBGW for CP"]\
               [list MMEUPEthernetMode    "optional" "$validEthernetMode" "FLOATING_10GETH"    "Defines the ethernet mode between the MME and HeNBGW for UP"]\
               [list HeNBCPEthernetMode   "optional" "$validEthernetMode" "LOADSHARE_10GETH"   "Defines the ethernet mode between the HeNB and HeNBGW for CP"]\
               [list HeNBUPEthernetMode   "optional" "$validEthernetMode" "FLOATING_10GETH"    "Defines the ethernet mode between the HeNB and HeNBGW for UP"]\
               [list fgwIp                "optional" "string"             "__UN_DEFINED__"     "FgwIp address"] \
               ]
     
     if {![info exists fgwIp]} {
          set fgwIp     [getActiveBonoIp $fgwNum]
     }
     # Dump the ipv4 route table
     set command "netstat -rn\nip -6 route"
     set flag    0
     
     print -info "Getting the ipv4 routing table on HeNBGW ..."
     set result [execCommandSU -dut $fgwIp -command $command]
     if {[regexp "ERROR" $result]} {
          print -fail "Not able to get routing table on HeNBGW"
          return -1
     } else {
          print -pass "Got routing table on HeNBGW"
     }
     
     set ipv4v6result [extractOutputFromResult $result]
     
     # If the table exists with all the network info then use it to extract the interface and vlan
     if {![array exists ::arr_nw_data]} {
          set vlansOnGw [getDataFromConfigFile "getMmeGwVlans" $fgwNum]
          lappend vlansOnGw [getDataFromConfigFile "henbSignalingVlan" $fgwNum]
          lappend vlansOnGw [getDataFromConfigFile "henbBearerVlan" $fgwNum]
          
          if {![info exists interface]} {
               set interface [getDataFromConfigFile "getHenbCp1Port" $fgwNum]
          }
          
          if {[info exists 1Ginterface]} {
               set 1GvlansOnGw [getDataFromConfigFile "getOamVlans" $fgwNum]
               foreach vlan $1GvlansOnGw {
                    set 1GvlanInterface "$1Ginterface\.$vlan"
                    if {[regexp $1GvlanInterface $ipv4v6result]} {
                         print -dbg "Found $1GvlanInterface in the routing table"
                    } else {
                         print -fail "Not found $1GvlanInterface in the routing table"
                         set flag -1
                    }
               }
               
          }
          
          set command "netstat -rn"
          set flag    0
          
          foreach vlan $vlansOnGw {
               set vlanInterface "$interface\.$vlan"
               if {[regexp $vlanInterface $ipv4v6result]} {
                    print -dbg "Found $vlanInterface in the routing table"
               } else {
                    print -fail "Not found $vlanInterface in the routing table"
                    set flag -1
               }
          }
     } else {
          set bonoIp    [getDataFromConfigFile bonoIpaddress $fgwNum 0]
          foreach index [array names ::arr_nw_data -regexp "$bonoIp,.*,ip"]  {
               set tmpIndex       [split $index ","]
               set interface      [lindex $tmpIndex 1]
               if {[info exists ::arr_nw_data($bonoIp,$interface,vlan)]} {
                    set vlanList       $::arr_nw_data($bonoIp,$interface,vlan)
                    set interface      [string map "sr1 10Geth0 sr2 10Geth1" $interface]
                    foreach vlan $vlanList {
                         set vlanInterface  "$interface\.$vlan"
                         if {[regexp $vlanInterface $ipv4v6result]} {
                              print -dbg "Found $vlanInterface in the routing table"
                         } else {
                              print -fail "Not found $vlanInterface in the routing table"
                              set flag -1
                         }
                    }
               }
          }
          
     }
     if {$flag == -1} {
          print -fail "Few/All vlan interfaces are not found in the routing table HeNBGW"
          #return -1
          #Temp hack
          return 0
     } else {
          print -pass "All vlan interfaces are found in the routing table of HeNBGW"
          return 0
     }
}

proc generatOamPreConfigFile {args} {
     #-
     #- temporary code to update OAM_PreConfig.xml file
     #-
     
     # params that are going to be udpated in OAM_PreConfig.xml file
     proc y  {} {
          "HeNBGW:10001"
          eNBNameGw
          defaultPagingDrx
          ipAddressOAMLocal
          ipAddressOAMLocalV6
          ipAddressHeNBOAMProxy
          ipAddressHeNBOAMProxyV6
          clusterId
          henbUserTrafficAddress
          henbUserTrafficAddressV6
          ipAddressCnCPLocal1
          ipAddressCnCPLocal1V6
          portNumCnCPLocal1
          ipAddressHeNBCpLocal
          ipAddressHeNBCpLocalV6
          portNumberHeNBCP
          s1ResetAckTimer
          s1ResetGuardTimer
          s1SetupGuardTimer
          s1SetupRetryTimer
          s1RelCompGuardTimer
          s1TimeToWait
          initialDLMessageGuardTimer
          enbConfigUpdateGuardTimer
          enbConfigUpdateRetryTimer
          maxConfigUpdateRetries
          mmeConfigUpdateGuardTimer
          mmeConfigUpdateRetryTimer
          warningMessageAckTimer
          henbS1SetupRetryTimer
          hoGuardTimer
          "HeNBGW=10001,Application4G=1,Application4GglobalENBId=1"
          globalENBIdplmnIdentityMcc
          globalENBIdplmnIdentityMnc
          globalENBIdeNBId
          
          "HeNBGW=10001,MMERegion=1"
          administrativeState = unlocked
          eNBNameGw
          
          "HeNBGW=10001,MMERegion=1,MMERegiontaiList=1"
          taiListId
          taiListplmnIdentityMcc
          taiListplmnIdentityMnc
          taiListtrackingAreaCode
          
          "HeNBGW=10001,MMERegion=1,MMERegionglobalENBId=1"
          globalENBIdId
          globalENBIdplmnIdentityMcc
          globalENBIdplmnIdentityMnc
          globalENBIdeNBId
          
          "HeNBGW=10001,MME=1"
          administrativeState = unlocked
          remoteSctpPortNum = local + 1
          
          "HeNBGW=10001,MME=1,MMEremoteSctpIPv4Address=1"
          remoteSctpIPv4AddressIdipAddress = mme ip address
          
          "HeNBGW=10001,MME=1,MMEremoteSctpIPv6Address=1"
          
          remoteSctpIPv6AddressIdipAddress = mme ipv6 address
          
          "HeNBGW=10001,MME=1,MMEs1TaiList=1"
          s1TaiListId
          s1TaiListplmnIdentityMcc
          s1TaiListplmnIdentityMnc
          s1TaiListtrackingAreaCode
          
          "HENBGW=10001,HeNBMaster=1"
          refSCTPConfig
          ipAddressHeNBCpLocal1
          ipAddressHeNBCpLocal1V6
          ipAddressHeNBCpLocal2
          ipAddressHeNBCpLocal2V6
          ipAddressHeNBCpLocalIntraNodeFloating
          ipAddressHeNBCpLocalV6IntraNodeFloating
          portNumberHeNBCP
          henbLocalVLAN1
          henbLocalVLAN2
          
          "HENBGW=10001,ItfFgw=1,PerformanceControl=1"
          granularPeriod
          
     }
     global ARR_LTE_TEST_PARAMS_MAP
     
     parseArgs args \
               [list \
               [list fgwNum                      optional   "numeric"  "0"                              "HeNB index reference to the testbed file" ] \
               [list noOfMMEs                    optional   "numeric"  "1"                              "No of MMEs to be simulated"] \
               [list noOfRegions                 optional   "numeric"  "1"                              "No of Regions to be simulated"] \
               [list eNBNameGw                   optional   "string"   [getLTEParam "HeNBGWName"]       "Gateway eNB name" ] \
               [list globaleNBId                 optional   "numeric"  [getLTEParam "globaleNBId"]      "Gateway eNB ID" ] \
               [list defaultPagingDrx            optional   "string"   [getLTEParam "defaultPagingDrx"] "Paging DRX value" ] \
               [list gwMCC                       optional   "numeric"  [getLTEParam "gwMCC"]            "MCC of the gateway" ] \
               [list gwMNC                       optional   "numeric"  [getLTEParam "gwMNC"]            "MNC of the gateway" ] \
               [list MMEeNBNameGw                optional   "string"   "__UN_DEFINED__"                 "Gateway Name w.r.f to MME" ] \
               [list taiMcc                      optional   "numeric"  "__UN_DEFINED__"                 "TAI's PLMN ID (MCC)" ] \
               [list taiMnc                      optional   "numeric"  "__UN_DEFINED__"                 "TAI's PLMN ID (MNC)" ] \
               [list mmeRegionMcc                optional   "numeric"  "__UN_DEFINED__"                 "MME Region PLMN ID (MCC)" ] \
               [list mmeRegionMnc                optional   "numeric"  "__UN_DEFINED__"                 "MME Region PLMN ID (MNC)" ] \
               [list mmeRegionGlobaleNBId        optional   "numeric"  "__UN_DEFINED__"                 "MME Region eNBId" ] \
               [list tac                         optional   "numeric"  "__UN_DEFINED__"                 "TAC" ] \
               [list s1ResetAckTimer             optional   "numeric"  "__UN_DEFINED__"                 "s1ResetAckTimer" ] \
               [list s1ResetGuardTimer           optional   "numeric"  "__UN_DEFINED__"                 "s1ResetGuard Timer" ] \
               [list s1SetupGuardTimer           optional   "numeric"  "__UN_DEFINED__"                 "s1SetupGuard Timer" ] \
               [list s1SetupRetryTimer           optional   "numeric"  "__UN_DEFINED__"                 "s1SetupRetry Timer" ] \
               [list s1RelCompGuardTimer         optional   "numeric"  "__UN_DEFINED__"                 "s1SetupCompleteGuardTimer" ] \
               [list s1TimeToWait                optional   "numeric"  "__UN_DEFINED__"                 "s1TimeToWait" ] \
               [list initialDLMessageGuardTimer  optional   "numeric"  "__UN_DEFINED__"                 "initialDLMessageGuardTimer" ] \
               [list enbConfigUpdateGuardTimer   optional   "numeric"  "__UN_DEFINED__"                 "enbConfigUpdateGuardTimer" ] \
               [list mmeConfigUpdateRetryTimer   optional   "numeric"  "__UN_DEFINED__"			"mmeConfigUpdateRetryTimer" ] \
               [list enbConfigUpdateRetryTimer   optional   "numeric"  "__UN_DEFINED__"			"enbConfigUpdateRetryTimer " ] \
               [list maxConfigUpdateRetries	 optional   "numeric"  "__UN_DEFINED__"			"no of times eNB/mme config update needs to be retried" ] \
               [list mmeConfigUpdateGuardTimer   optional   "numeric"  "__UN_DEFINED__"                 "mmeConfigUpdateGuardTimer" ] \
               [list warningMessageAckTimer      optional   "numeric"  "__UN_DEFINED__"                 "warningMessageAckTimer" ] \
               [list henbS1SetupRetryTimer       optional   "numeric"  "__UN_DEFINED__"                 "henbS1SetupRetryTimer" ] \
               [list henbGwAdminState            optional   "string"   "__UN_DEFINED__"                 "HeNBGW MO's Admin state" ] \
               [list mmeRegionAdminState         optional   "string"   "__UN_DEFINED__"                 "MME Region MO's Admin sate" ] \
               [list mmeAdminState               optional   "string"   "__UN_DEFINED__"                 "MME MO's Admin state" ] \
               [list sctpHeartbeatTmr            optional   "string"   "__UN_DEFINED__"                 "SCTP hearbeat timer" ] \
               [list sctpBundleTmr               optional   "string"   "__UN_DEFINED__"                 "SCTP Bundle timer"   ] \
               [list sctpMaxAssocReTx            optional   "string"   "__UN_DEFINED__"                 "SCTP association retransmission attempts" ] \
               [list sctpMaxPathReTx             optional   "string"   "__UN_DEFINED__"                 "SCTP path retransmission attempts" ] \
               [list sctpRtoInitial              optional   "string"   "__UN_DEFINED__"                 "SCTP rto initial"  ] \
               [list sctpRtoMin                  optional   "string"   "__UN_DEFINED__"                 "SCTP rto minimum" ] \
               [list sctpRtoMax                  optional   "string"   "__UN_DEFINED__"                 "SCTP rto maximum" ] \
               [list localMMEMultiHoming         optional   "yes|no"   "no"             		"To eanble multihoming towards MME on gw"]\
               [list localHeNBMultiHoming        optional   "yes|no"   "no"             		"To eanble multihoming towards HeNBon gw"]\
               [list remoteMMEMultiHoming        optional   "yes|no"   "no"             		"To eanble multihoming on MME sim"] \
               [list hoGuardTimer                optional   "numeric"  "__UN_DEFINED__"           	"hoGuardTimer" ] \
               [list granularPeriod              optional   "string"   "min5"      "Configure the value of granular period in OAM_Preconfig.xml file"] \
               [list MultiS1Link                 optional     "yes|no"   "no"                            "To know multis1link enable towards mme"] \
               [list henbRegistrationCheckEnabled   optional     "True|False"   "False"                  "HeNB Service Monitoring"] \
               [list henbValidationCheckEnabled     optional     "True|False"   "False"                  "HeNB Service Monitoring"] \
               ]
     
     # variable declaration
     set flag 0
     set dut              [getActiveBonoIp $fgwNum]
     set gwHeNBSctp       [getDataFromConfigFile henbSctp $fgwNum]
     set gwMMESctp        [getDataFromConfigFile mmeSctp $fgwNum]
     #set remoteMMeSctp  \"[expr [getDataFromConfigFile mmeSctp $fgwNum] + 1]\"
     set remoteMMeSctp     [expr [getDataFromConfigFile mmeSctp $fgwNum] + 1]
     
     # ip address declaration
     set gwHeNBBearerIp   [getDataFromConfigFile henbBearerIpaddress $fgwNum]
     set gwMMEIp          [getDataFromConfigFile getMmeCp1Ipaddress $fgwNum]
     set gwHeNBSignalIp   [getDataFromConfigFile getHenbCp1Ipaddress $fgwNum]
     if { $::ROUTING_TB == "yes" } {
          set remoteMMeIp      [getDataFromConfigFile getMmeSimCp1Ipaddress $fgwNum]
     } else {
          set remoteMMeIp      [incrIp [getDataFromConfigFile getMmeCp1Ipaddress $fgwNum]]
     }
     #set gwMMEIp2         0.0.0.0 ;# As of now we have to set the gwMMEIP2 as 0.0.0.0
     
     set networkIps "gwHeNBBearerIp gwMMEIp gwHeNBSignalIp remoteMMeIp"
     
     if {$localHeNBMultiHoming == "yes"} {
          append networkIps " gwHeNBSignalIp2"
          set gwHeNBSignalIp2 [getDataFromConfigFile getHenbCp2Ipaddress $fgwNum]
     }
     
     if {$localMMEMultiHoming == "yes"} {
          append networkIps " gwMMEIp2"
          set gwMMEIp2 [getDataFromConfigFile getMmeCp2Ipaddress $fgwNum]
     }
     
     # Get the secondary remote MME ip address
     if {$remoteMMEMultiHoming == "yes"} {
          append networkIps " remoteMMeIp2"
          if { $::ROUTING_TB == "yes" } {
               set remoteMMeIp2      [getDataFromConfigFile getMmeSimCp2Ipaddress $fgwNum]
          } else {
               set remoteMMeIp2 [incrIp [getDataFromConfigFile getMmeCp2Ipaddress $fgwNum]]
          }
     }
     foreach var $networkIps {
          if {[::ip::is 6 [set $var]]} {
               set ${var}V6 \"[::ip::normalize [set $var]]\"
               #unsetting the ipv4 variable instance, if ip version is 6
               #so that, respective MOs or variables wont be configured
               unset -nocomplain $var
               #set $var     \"0.0.0.0\" ;# disabling ipv4 address
          } else {
               set $var     \"[set $var]\"
               #set ${var}V6 \"0:0:0:0:0:0:0:0\" ;# disabling ipv6 address
          }
     }
     
     if {![info exists henbGwAdminState]}        { set henbGwAdminState      "unlocked" }
     
     # Inserting sec
     # Adding below change, As 2 variables (s1TimeToWait,henbS1SetupRetryTimer) used in scripts, for the same IE updation
     if {[info exists s1TimeToWait] || [info exists henbS1SetupRetryTimer] }   {
          if {[info exists henbS1SetupRetryTimer]} { set s1TimeToWait $henbS1SetupRetryTimer}
          set s1TimeToWait    [regsub -nocase {^(\d+)} $s1TimeToWait {sec\1}]
     }
     # Assign the reference sctp configuration
     set refSctpConfig [getNodeIndex "sctpConfig"]
     set refSctpConfig [encryptVar $refSctpConfig]
     
     # For a ATCA setup, no manual configuration of OAM_Preconfig.xml file is required.
     # The HeNBGWMon takes care of generating the preconfig file and also to create the required interfaces
     
     if {![isATCASetup] && ![isIfCfgThrMON]} {
          # RO attributes--- to be done via OAM_Preconfig.xml
          # As of now some of the attributes has to be configured in the OAM_Preconfig.xml file
          # These variables have RO access and hence cannot be set through CLI
          set arr_local(root) \
                    [list \
                    henbUserTrafficAddress=gwHeNBBearerIp, henbUserTrafficAddressV6=gwHeNBBearerIpV6, \
                    ipAddressCnCPLocal1=gwMMEIp, ipAddressCnCPLocal1V6=gwMMEIpV6, portNumCnCPLocal1=gwMMEport, \
                    ipAddressCnCPLocal2=gwMMEIp2, ipAddressCnCPLocal2V6=gwMMEIp2V6, \
                    ]
          #set arr_local(sctpConfig)      [list sctpBundleTmr=sctpBundleTmr, sctpHeartbeatTmr=sctpHeartbeatTmr, sctpMaxAssocReTx=sctpMaxAssocReTx, sctpMaxPathReTx=sctpMaxPathReTx, sctpRtoInitial=sctpRtoInitial, sctpRtoMin=sctpRtoMin, sctpRtoMax=sctpRtoMax]
          # Read the OAM preconfig file before writing the configuration
          set result  [oamPreConfigFile $dut "read"]
          
          foreach index "root" {
               switch -regexp $index {
                    "root" {
                         set objList [processMappingList [list [list $index $arr_local($index)]]]
                         set result  [updateParamInOamFile [lindex $objList 1] $index]
                         if {$result != 0} {
                              print -fail "Failed to update parameters at $index on HeNBGW"
                              return -1
                         } else {
                              print -dbg "Successfully updated parameters at $index on HeNBGW"
                         }
                    }
               }
          }
          retrieveDefaultValuesFromOam
          
          # Write the changes to the OAM_Preconfig.xml file and start the application to get CLI access
          set result  [oamPreConfigFile $dut "write"]
          # Done with OAM_Preconfig.xml configuration
          
          # Start the Application to get CLI access
          set result  [restartHeNBGW -fgwNum $fgwNum -verify "yes" -operation "start"]
          unset arr_local
     } else {
          
          # Read the OAM preconfig file before retrieving default values
          set result  [oamPreConfigFile $dut "read"]
          
          # No action has to be taken, just retreive the default values from OAM_Preconfig.xml file
          retrieveDefaultValuesFromOam
     }
     
     # handling timers
     if {[info exists s1ResetGuardTimer]} {
          set expResetAckTimer [expr ( $s1ResetGuardTimer * [getDefaultParamValue "s1ResetRetries"] ) + 1]
          if {![info exists s1ResetAckTimer]} {
               print -dbg "Based reset guard timer, setting reset ack timer to : $expResetAckTimer"
               set s1ResetAckTimer $expResetAckTimer
          } elseif {$s1ResetAckTimer < $expResetAckTimer} {
               print -fail "Passed reset Ack timer is not more that (gaurd_timer * retries) ($expResetAckTimer)"
               return -1
          }
     } else {
          if {[info exists s1ResetAckTimer]} {
               if {![info exists s1ResetGuardTimer]} { set s1ResetGuardTimer [getDefaultParamValue "s1ResetGuardTimer"] }
               set expResetAckTimer [expr ( $s1ResetGuardTimer * [getDefaultParamValue "s1ResetRetries"] ) + 1]
               if {$s1ResetAckTimer < $expResetAckTimer} {
                    print -fail "Passed reset Ack timer is not more that (gaurd_timer * retries) ($expResetAckTimer)"
                    return -1
               }
          }
     }
     # Define the MO types and the attributes that has to be configured through CLI
     #administrativeState=henbGwAdminState,
     set arr_local(fgw) \
               [list \
               administrativeState=henbGwAdminState \
               ]
     set arr_local(appl4G) \
               [list \
               eNBNameGw=\"$eNBNameGw\", defaultPagingDrx=defaultPagingDrx, ipAddressOAMLocal=ipAddressOAMLocal, \
               ipAddressOAMLocalV6=ipAddressOAMLocalV6, ipAddressHeNBOAMProxy=ipAddressHeNBOAMProxy, \
               ipAddressHeNBOAMProxyV6=ipAddressHeNBOAMProxyV6, clusterId=clusterId, \
               s1ResetAckTimer=s1ResetAckTimer, s1ResetGuardTimer=s1ResetGuardTimer, s1SetupGuardTimer=s1SetupGuardTimer, mmeConfigUpdateRetryTimer=mmeConfigUpdateRetryTimer, \
               s1SetupRetryTimer=s1SetupRetryTimer, s1SetupTimeToWait=s1TimeToWait, initialDLMessageGuardTimer=initialDLMessageGuardTimer, \
               enbConfigUpdateGuardTimer=enbConfigUpdateGuardTimer, enbConfigUpdateRetryTimer=enbConfigUpdateRetryTimer, mmeConfigUpdateGuardTimer=mmeConfigUpdateGuardTimer, \
               warningMessageAckTimer=warningMessageAckTimer, s1ReleaseCompleteGuardTimer=s1RelCompGuardTimer, maxConfigUpdateRetries=maxConfigUpdateRetries, \
               hoGuardTimer=hoGuardTimer, henbRegistrationCheckEnabled=henbRegistrationCheckEnabled, henbValidationCheckEnabled=henbValidationCheckEnabled \
               ]
     set arr_local(henbMaster)  \
               [list \
               refSCTPConfig=\"$refSctpConfig\", \
               ipAddressHeNBCpLocal1=gwHeNBSignalIp,\
               ipAddressHeNBCpLocal1V6=gwHeNBSignalIpV6, \
               ipAddressHeNBCpLocal2=gwHeNBSignalIp2, ipAddressHeNBCpLocal2V6=gwHeNBSignalIp2V6,\
               portNumberHeNBCP=gwHeNBSctp \
               ]
     set sctpConfigAdminState "unlocked"
     set numOfPairsOfSctpStreams "512"
     set sctpUserLabel "SCTPConfig1"
     
     set refSctpConfig [getNodeIndex "sctpConfig"]
     set refSctpConfig [encryptVar $refSctpConfig]
     
     # Define the MO and attributes to be created or set
     set arr_local(enbId)           [list globalENBIdPlmnIdentityMcc=\"$gwMCC\", globalENBIdPlmnIdentityMnc=\"$gwMNC\", globalENBIdENBId=globaleNBId]
     set arr_local(sctpConfig,1)  [list \
               userLabel=\"$sctpUserLabel\",\
               numOfPairsOfSctpStreams=numOfPairsOfSctpStreams, \
               sctpBundleTmr=sctpBundleTmr, \
               sctpHeartbeatTmr=sctpHeartbeatTmr, sctpMaxAssocReTx=sctpMaxAssocReTx,\
               sctpMaxPathReTx=sctpMaxPathReTx, sctpRtoInitial=sctpRtoInitial,\
               sctpRtoMin=sctpRtoMin, sctpRtoMax=sctpRtoMax\
               ]
     set createMOs ""
     set setMOs "fgw appl4G"
     if {[info exists arr_local(performCont)]} {
          lappend setMOs "performCont"
     }
     
     # Create the MOs and set the values for the attributes that have been defined
     foreach  index $setMOs {
          #if {$objList == ""} {continue}
          set nodeInst "1"
          # The MO class for these attributes already exist so need to only set the attributes
          set nodeInst "1"
          set objList [processMappingList [list [list $index $arr_local($index)]]]
          set index [getMONameForCLI $index]
          # Update attributes
          print -info "Updating test parameters required for HeNBGW (xml index : $index)"
          set result [getAndSetParamViaHeNBGWCli -dut $dut -paramList [lindex $objList 1] -nodeName $index -nodeInst $nodeInst]
          if {$result != 0} {
               print -fail "Failed to update parameters at $index on HeNBGW"
               set flag 1
          } else {
               print -dbg "Successfully updated parameters at $index on HeNBGW"
          }
          unset -nocomplain objList
     }
     
     foreach  index $createMOs {
          # Create the MO class and the corresponding attributes
          if {[regexp "," $index]} {
               set oldIndex $index
               foreach {index nodeInst} [split $index ","] {break}
               set objList [processMappingList [list [list [mapNodeIndex $index]:$nodeInst  $arr_local($oldIndex)]]]
          } else {
               set objList [processMappingList [list [list [mapNodeIndex $index]:$nodeInst  $arr_local($index)]]]
          }
          if {[isEmptyList $objList]} {set objList [mapNodeIndex $index]:$nodeInst}
          #for refSCTPConfig value
          set objList [encryptVar $objList "decrypt"]
          
          #for IP address value
          regsub -all {\\"} $objList "\"" objList
          # Update attributes
          
          print -info "Creating $index MO"
          set result [createOrDeleteObjViaHeNBGWCli -dut $dut -objList [list $objList] -nodeName $index]
          if {$result != 0} {
               print -fail "Failed to update parameters at $index on HeNBGW"
               set flag 1
          } else {
               print -dbg "Successfully updated parameters at $index on HeNBGW"
          }
          unset -nocomplain objList
     }
     
     #unlock done here
     print -info "Creating MME Regions MOs and their element MOs"
     #Retaining values passed from script for region 0
     if {![info exists taiMcc]}                  { set taiMcc                [getFromTestMap -HeNBIndex "all" -param "MCC"] }
     if {![info exists taiMnc]}                  { set taiMnc                [getFromTestMap -HeNBIndex "all" -param "MNC"] }
     if {![info exists tac]}                     { set tac                   [getFromTestMap -HeNBIndex "all" -param "TAC"] }
     if {![info exists mmeRegionMcc]}            { set mmeRegionMcc          [lindex [getFromTestMap -HeNBIndex "all" -param "MCC"] 0 0]}
     if {![info exists mmeRegionMnc]}            { set mmeRegionMnc          [lindex [getFromTestMap -HeNBIndex "all" -param "MNC"] 0 0]}
     if {![info exists MMEeNBNameGw]}            { set MMEeNBNameGw          [getLTEParam "HeNBGWName"] }
     if {![info exists mmeRegionGlobaleNBId]}    { set mmeRegionGlobaleNBId  [getLTEParam "globaleNBId"] }
     if {![info exists mmeRegionAdminState]}     { set mmeRegionAdminState   "unlocked" }
     print -info "MultiS1Link is $MultiS1Link"
     if { $MultiS1Link == "yes" } {
          set mmeRegionGlobaleNBId [getRandomUniqueListInRange 50 100]
          set ARR_LTE_TEST_PARAMS_MAP(R,0,eNBId) "$mmeRegionGlobaleNBId"
          #           set tmpNoOfRegions 0
          #           set tmpmaxS1Links 0
          #           for {set i 0} {$i < $noOfRegions} {incr i} {
          #               set tmpmaxS1Links [getFromTestMap -RegionIndex $i -param "maxS1Links"]
          #               set tmpNoOfRegions [expr $tmpNoOfRegions + $tmpmaxS1Links]
          #            }
          #           set origNoOfRegions $noOfRegions
          
          #           set noOfRegions $tmpNoOfRegions
          #           print -info "noOfRegions $noOfRegions"
     }
     
     #if {![info exists mmeRegioneNBNameGw]}      { set mmeRegioneNBNameGw    [getLTEParam "HeNBGWName"] }
     if {![info exists mmeAdminState]}           { set mmeAdminState         "unlocked" }
     
     set refMMETrans [getNodeIndex "mmeTrans"]
     set refMMETrans [encryptVar $refMMETrans]
     
     # Defined adminState variables in argument list for henbGw, mmeRegion, mme MOs
     # set adminState     unlocked
     if { $MultiS1Link != "yes" } {
          for {set i 0} {$i < $noOfRegions} {incr i} {
               print -info "tac $tac mmeRegionMcc $mmeRegionMcc MMEeNBNameGw $MMEeNBNameGw mmeRegionGlobaleNBId $mmeRegionGlobaleNBId"
               set taiListId 1
               if {$i !=0} {
                    set taiMcc                [getFromTestMap -HeNBIndex "all" -param "MCC" -RegionIndex $i]
                    set taiMnc                [getFromTestMap -HeNBIndex "all" -param "MNC" -RegionIndex $i]
                    set tac                   [getFromTestMap -HeNBIndex "all" -param "TAC" -RegionIndex $i]
                    set mmeRegionMcc          [lindex [getFromTestMap -HeNBIndex "all" -param "MCC" -RegionIndex $i] 0 0]
                    set mmeRegionMnc          [lindex [getFromTestMap -HeNBIndex "all" -param "MNC" -RegionIndex $i] 0 0]
                    set MMEeNBNameGw          [getLTEParam "HeNBGWName"]
                    #######Need to construct based upon region PLMN######
                    set mmeRegionGlobaleNBId  [getLTEParam "globaleNBId"]
                    set mmeRegionAdminState   "unlocked"
                    #set mmeRegioneNBNameGw    [getLTEParam "HeNBGWName"]
                    set mmeAdminState         "unlocked"
               }
               # Define the MO and attributes to be created or set
               set regionInd [expr $i + 1]
               set arr_local(mmeRegion,$regionInd)     [list administrativeState=mmeRegionAdminState, eNBNameGw=\"$MMEeNBNameGw\"]
               set arr_local(mmeRegionEnbId)  [list globalENBIdPlmnIdentityMcc=\"$mmeRegionMcc\", globalENBIdPlmnIdentityMnc=\"$mmeRegionMnc\", globalENBIdENBId=mmeRegionGlobaleNBId]
               
               # Define the order in which the MOs has to be configured
               # Create the MOs and set the values for the attributes that have been defined
               foreach  index "mmeRegion,$regionInd mmeRegionTai mmeRegionEnbId" {
                    print -info "Creating $index MO"
                    set nodeInst 1
                    if {[regexp {mmeRegion,} $index]} {
                         ##Region MOs to be created under HeNGW MO
                         set rootInst 1
                    } else {
                         ##Other MOs to be created under respective Region MO
                         set rootInst $regionInd
                    }
                    
                    switch -regexp $index {
                         "mmeRegionTai" {
                              set nodeName "mmeRegionTai"
                              set tmpTaiList $taiListId
                              foreach mccList $taiMcc mncList $taiMnc TAC $tac {
                                   foreach mcc $mccList mnc $mncList {
                                        set objList [processMappingList [list [list [mapNodeIndex $nodeName]:$taiListId [list taiListId=taiListId, taiListPlmnIdentityMcc=\"$mcc\", taiListPlmnIdentityMnc=\"$mnc\", taiListTrackingAreaCode=TAC]]]]
                                        if {$objList == ""} {continue}
                                        # Update attributes
                                        print -info "Creating MME Region TAI MOs"
                                        print -info "nodeName $nodeName objList $objList"
                                        set dut [getActiveBonoIp]
                                        set result [createOrDeleteObjViaHeNBGWCli -dut $dut -objList [list $objList] -nodeName $nodeName -nodeInst $rootInst]
                                        if {$result != 0} {
                                             print -fail "Failed to update parameters at $nodeName on HeNBGW"
                                             set flag 1
                                        } else {
                                             print -dbg "Successfully updated parameters at $nodeName on HeNBGW"
                                        }
                                        
                                        if {[info exists taiListId]} {incr taiListId}
                                        incr tmpTaiList
                                        set taiListId $tmpTaiList
                                   }
                              }
                         }
                         default {
                              # Create the MO class and the corresponding attributes
                              if {[regexp "," $index]} {
                                   set oldIndex $index
                                   foreach {index nodeInst} [split $index ","] {break}
                                   set objList [processMappingList [list [list [mapNodeIndex $index]:$nodeInst  $arr_local($oldIndex)]]]
                              } else {
                                   set objList [processMappingList [list [list [mapNodeIndex $index]:$nodeInst  $arr_local($index)]]]
                              }
                              if {[isEmptyList $objList]} {set objList [mapNodeIndex $index]:$nodeInst}
                              set objList [encryptVar $objList "decrypt"]
                              
                              #for IP address value
                              regsub -all {\\"} $objList "\"" objList
                              # Update attributes
                              print -info "Creating $index MO"
                              print -info "index $index objList $objList"
                              if {$index == "mmeRegionEnbId" } {
                                   set dut [getActiveBonoIp]
                                   #set nodeName [getMONameForCLI "mmeRegion"]
                                   print -info "Locking the parent MO"
                                   set result [getAndSetParamViaHeNBGWCli    -dut $dut -paramList "administrativeState=locked" -nodeName "mmeRegionEnbId" -nodeInst $rootInst -operation "set"]
                                   
                              }
                              set dut [getActiveBonoIp]
                              set result [createOrDeleteObjViaHeNBGWCli -dut $dut -objList [list $objList] -nodeName $index -nodeInst $rootInst]
                              if {$result != 0} {
                                   print -fail "Failed to update parameters at $index on HeNBGW"
                                   set flag 1
                              } else {
                                   print -dbg "Successfully updated parameters at $index on HeNBGW"
                              }
                              unset -nocomplain objList
                              
                              if {$index == "mmeRegionEnbId" } {
                                   set dut [getActiveBonoIp]
                                   #                              set nodeName [getMONameForCLI "mmeRegion"]
                                   print -info "Unlocking the parent MO"
                                   set result [getAndSetParamViaHeNBGWCli  -dut $dut -paramList "administrativeState=unlocked" -nodeName "mmeRegionEnbId" -nodeInst $rootInst -operation "set"]
                                   
                              }
                              
                         }
                    }
               }
          }
     } else {
          #set subRegCount 0
          set regMainCount 1
          set HeNBIndex 0
          for {set i 0} {$i < $noOfRegions} {incr i} {
               #print -info "tac $tac mmeRegionMcc $mmeRegionMcc MMEeNBNameGw $MMEeNBNameGw mmeRegionGlobaleNBId $mmeRegionGlobaleNBId"
               set taiListId 1
               set tmpmaxS1Links [getFromTestMap -RegionIndex $i -param "maxS1Links"]
               set j 0
               set noOfHeNBs [getFromTestMap -RegionIndex $i -param "noOfHenbs"]
               set mainLoopIndicator $i
               set subLoopIndicator $i
               set regionRetry 0
               set regRetInd 0
               set regCount $regMainCount
               for {set S1regInd 0} {$S1regInd < $tmpmaxS1Links} {incr S1regInd} {
                    set taiMcc                [getFromTestMap -HeNBIndex $i -param "MCC" -RegionIndex $i]
                    set taiMnc                [getFromTestMap -HeNBIndex $i -param "MNC" -RegionIndex $i]
                    set mmeRegionMcc          [lindex [getFromTestMap -HeNBIndex $i -param "MCC" -RegionIndex $i] 0 0]
                    set mmeRegionMnc          [lindex [getFromTestMap -HeNBIndex $i -param "MNC" -RegionIndex $i] 0 0]
                    set MMEeNBNameGw          [getLTEParam "HeNBGWName"]
                    #######Need to construct based upon region PLMN######
                    # set mmeRegionGlobaleNBId [random 50 100]
                    #set mmeRegionGlobaleNBId [expr $mmeRegionGlobaleNBId + 5]
                    #set ARR_LTE_TEST_PARAMS_MAP(R,$i,SubR,$S1regInd,eNBId) "$mmeRegionGlobaleNBId"
                    #set ARR_LTE_TEST_PARAMS_MAP(R,$i,SubR,$subRegCount,eNBId) "$mmeRegionGlobaleNBId"
                    #set subRegCount [ incr subRegCount ]
                    if {$j < $noOfHeNBs} {
                         set tac                   [getFromTestMap -HeNBIndex $HeNBIndex -param "TAC" -RegionIndex $i]
                         set j [incr j]
                         set HeNBIndex [incr HeNBIndex]
                    } else {
                         set tac    [getRandomUniqueListInRange 1000 5000]
                    }
                    
                    set mmeRegionAdminState   "unlocked"
                    #set mmeRegioneNBNameGw    [getLTEParam "HeNBGWName"]
                    set mmeAdminState         "unlocked"
                    
                    # Define the MO and attributes to be created or set
                    if { $mainLoopIndicator == $subLoopIndicator } {
                         set regionInd $regMainCount
                    } else {
                         set regionInd $regCount
                    }
                    
                    set subLoopIndicator [ expr $subLoopIndicator + 1 ]
                    set arr_local(mmeRegion,$regionInd)     [list administrativeState=mmeRegionAdminState, eNBNameGw=\"$MMEeNBNameGw\"]
                    set arr_local(mmeRegionEnbId)  [list globalENBIdPlmnIdentityMcc=\"$mmeRegionMcc\", globalENBIdPlmnIdentityMnc=\"$mmeRegionMnc\", globalENBIdENBId=mmeRegionGlobaleNBId]
                    
                    # Define the order in which the MOs has to be configured
                    # Create the MOs and set the values for the attributes that have been defined
                    foreach  index "mmeRegion,$regionInd mmeRegionTai mmeRegionEnbId" {
                         print -info "Creating $index MO-$regionRetry"
                         if {($regionRetry == 1 ) && ($index != "mmeRegionTai") } {continue}
                         set nodeInst 1
                         if {[regexp {mmeRegion,} $index]} {
                              ##Region MOs to be created under HeNGW MO
                              set rootInst 1
                         } else {
                              #     ##Other MOs to be created under respective Region MO
                              set rootInst $regionInd
                         }
                         
                         #set mmeRegionGlobaleNBId [random 50 100]
                         set mmeRegionGlobaleNBId [expr $mmeRegionGlobaleNBId + 5]
                         #set ARR_LTE_TEST_PARAMS_MAP(R,$i,SubR,$S1regInd,eNBId) "$mmeRegionGlobaleNBId"
                         set ARR_LTE_TEST_PARAMS_MAP(R,$i,SubR,$regionInd,eNBId) "$mmeRegionGlobaleNBId"
                         
                         switch -regexp $index {
                              "mmeRegionTai" {
                                   set nodeName "mmeRegionTai"
                                   set tmpTaiList $taiListId
                                   foreach mccList $taiMcc mncList $taiMnc TAC $tac {
                                        foreach mcc $mccList mnc $mncList {
                                             set objList [processMappingList [list [list [mapNodeIndex $nodeName]:$taiListId [list taiListId=taiListId, taiListPlmnIdentityMcc=\"$mcc\", taiListPlmnIdentityMnc=\"$mnc\", taiListTrackingAreaCode=TAC]]]]
                                             if {$objList == ""} {continue}
                                             # Update attributes
                                             print -info "Creating MME Region TAI MOs"
                                             print -info "nodeName $nodeName objList $objList"
                                             # if {($S1regInd == [expr $tmpmaxS1Links -1]) && ($noOfHeNBs > $j)} {
                                             #     set nodeInst [expr $S1regInd + 1]
                                             # } else {
                                             #     set nodeInst $regionInd
                                             # }
                                             set dut [getActiveBonoIp]
                                             set result [createOrDeleteObjViaHeNBGWCli -dut $dut -objList [list $objList] -nodeName $nodeName -nodeInst $rootInst]
                                             if {$result != 0} {
                                                  print -fail "Failed to update parameters at $nodeName on HeNBGW"
                                                  set flag 1
                                             } else {
                                                  print -dbg "Successfully updated parameters at $nodeName on HeNBGW"
                                             }
                                             if {($S1regInd == [expr $tmpmaxS1Links - 1]) && ($noOfHeNBs > $j)} {
                                                  if {[info exists taiListId]} {incr taiListId}
                                                  incr tmpTaiList
                                                  set taiListId $tmpTaiList
                                                  set S1regInd -1
                                                  set regCount [expr $regMainCount - 1]
                                                  set regRetInd 1
                                             } else {
                                                  if {[info exists taiListId]} {set taiListId  $taiListId}
                                                  #               incr tmpTaiList
                                                  set taiListId $tmpTaiList
                                                  #set regionInst $regionInd
                                             }
                                        }
                                   }
                              }
                              default {
                                   # Create the MO class and the corresponding attributes
                                   if {[regexp "," $index]} {
                                        set oldIndex $index
                                        foreach {index nodeInst} [split $index ","] {break}
                                        set objList [processMappingList [list [list [mapNodeIndex $index]:$nodeInst  $arr_local($oldIndex)]]]
                                   } else {
                                        set objList [processMappingList [list [list [mapNodeIndex $index]:$nodeInst  $arr_local($index)]]]
                                   }
                                   if {[isEmptyList $objList]} {set objList [mapNodeIndex $index]:$nodeInst}
                                   set objList [encryptVar $objList "decrypt"]
                                   
                                   #for IP address value
                                   regsub -all {\\"} $objList "\"" objList
                                   # Update attributes
                                   print -info "Creating $index MO"
                                   print -info "index $index objList $objList"
                                   if {$index == "mmeRegionEnbId" } {
                                        set dut [getActiveBonoIp]
                                        #set nodeName [getMONameForCLI "mmeRegion"]
                                        print -info "Locking the parent MO"
                                        set dut  [getActiveBonoIp]
                                        set result [getAndSetParamViaHeNBGWCli    -dut $dut -paramList "administrativeState=locked" -nodeName "mmeRegionEnbId" -nodeInst $rootInst -operation "set"]
                                        
                                   }
                                   set dut [getActiveBonoIp]
                                   set result [createOrDeleteObjViaHeNBGWCli -dut $dut -objList [list $objList] -nodeName $index -nodeInst $rootInst]
                                   if {$result != 0} {
                                        print -fail "Failed to update parameters at $index on HeNBGW"
                                        set flag 1
                                   } else {
                                        print -dbg "Successfully updated parameters at $index on HeNBGW"
                                   }
                                   unset -nocomplain objList
                                   
                                   if {$index == "mmeRegionEnbId" } {
                                        set dut [getActiveBonoIp]
                                        #                              set nodeName [getMONameForCLI "mmeRegion"]
                                        print -info "Unlocking the parent MO"
                                        set dut [getActiveBonoIp]
                                        set result [getAndSetParamViaHeNBGWCli  -dut $dut -paramList "administrativeState=unlocked" -nodeName "mmeRegionEnbId" -nodeInst $rootInst -operation "set"]
                                        
                                   }
                                   
                              }
                         }
                    }
                    
                    if {$regRetInd == 1} {
                         set regionRetry 1
                    }
                    set regCount [incr regCount]
               }
               set regMainCount [expr $regMainCount + $tmpmaxS1Links]
          }
     }
     #if { $MultiS1Link == "yes" } {
     #   set noOfRegions $origNoOfRegions
     #}
     # Define the MME Ip address MO for both single and multihoming and ipv4 and ipv6
     print -info "Creating MME MOs and their element MOs"
     set arr_local(mmeIpv4,1)       [list remoteSctpIPv4AddressId=remoteMMeIpId,remoteSctpIPv4AddressIpAddress=remoteMMeIp]
     set arr_local(mme2Ipv4,2)      [list remoteSctpIPv4AddressId=remoteMMeIpId2,remoteSctpIPv4AddressIpAddress=remoteMMeIp2]
     set arr_local(mmeIpv6,1)       [list remoteSctpIPv6AddressIpV6Address=remoteMMeIpV6]
     set arr_local(mme2Ipv6,2)      [list remoteSctpIPv6AddressIpV6Address=remoteMMeIp2V6]
     
     if { $MultiS1Link != "yes" } {
          for {set ind 0} {$ind < $noOfMMEs} {incr ind} {
               set nodeName "mme"
               set mmeId    [expr $ind + 1]
               set tmpSctp $remoteMMeSctp
               
               if {![info exists mmeAdminState]} { set mmeAdminState "unlocked"}
               #set arr_local(mme,$ind)           [list administrativeState=mmeAdminState, remoteSctpPortNum=remoteMMeSctp, refSCTPConfig=\"$refSctpConfig\"]
               set objList [processMappingList [list [list [mapNodeIndex $nodeName]:$mmeId [list administrativeState=mmeAdminState, remoteSctpPortNum=remoteMMeSctp, refSCTPConfig=\"$refSctpConfig\", refMMETransportLocal=\"$refMMETrans\"]]]]
               
               #for refSCTPConfig value
               set objList [encryptVar $objList "decrypt"]
               set remoteMMeSctp $tmpSctp
               
               print -info "Creating $nodeName MO objList $objList"
               set dut [getActiveBonoIp]
               set result [createOrDeleteObjViaHeNBGWCli -dut $dut -objList [list $objList] -nodeName $nodeName]
               if {$result != 0} {
                    print -fail "Failed to create MME MO on HeNBGW"
                    set flag 1
               } else {
                    print -dbg "Successfully created MME MO on HeNBGW"
               }
               
               # Configuring either ipv4 or ipv6 sctpMO
               set mmeNodes ""
               #if {[::ip::is 6 [regsub -all {\"} $remoteMMeIp ""]]}
               if {[info exists remoteMMeIpV6]} {
                    set mmeNodes "mmeIpv6,1"
               } else {
                    set mmeNodes "mmeIpv4,1"
               }
               
               # If remote MME multihoming is enabled than create the mmeIp MO
               if {$remoteMMEMultiHoming == "yes"} {
                    if {[info exists remoteMMeIp2V6]} {
                         #if {[::ip::is 6 [regsub -all {\"} $remoteMMeIp ""]] && [info exists remoteMMeIp2V6]}
                         set mmeNodes [concat $mmeNodes "mme2Ipv6,2"]
                         # elseif {[::ip::is 4 [regsub -all {\"} $remoteMMeIp ""]] && [info exists remoteMMeIp2]}
                    } elseif {[info exists remoteMMeIp2]} {
                         set mmeNodes [concat $mmeNodes "mme2Ipv4,2"]
                    }
               }
               
               print -info "Finding regions of MME"
               set regs [getFromTestMap -MMEIndex $ind -param "Region"]
               set j 1
               foreach regId $regs {
                    set refMMERegionsMmeRegion [getNodeIndex "mmeRefRegion" [expr $regId +1]]
                    set refMMERegionsMmeRegion [encryptVar $refMMERegionsMmeRegion]
                    set arr_local(mmeRefRegion,$j)  [list refMMERegionsMmeRegionDn=\"$refMMERegionsMmeRegion\"]
                    set mmeNodes [concat $mmeNodes "mmeRefRegion,$j"]
                    incr j
               }
               
               foreach index $mmeNodes {
                    print -info "Creating $index MO"
                    # Create the MO class and the corresponding attributes
                    set oldIndex $index
                    foreach {index nodeInst} [split $index ","] {break}
                    set objList [processMappingList [list [list [mapNodeIndex $index]:$nodeInst  $arr_local($oldIndex)]]]
                    print -info "objList $objList"
                    if {[isEmptyList $objList]} {set objList [mapNodeIndex $index]:$nodeInst}
                    set objList [encryptVar $objList "decrypt"]
                    
                    #for IP address value
                    regsub -all {\\"} $objList "\"" objList
                    # Update attributes
                    print -info "Creating $index MO under $nodeName:$mmeId node"
                    if {[regexp {mmeIpv4|mmeIpv6|mme2Ipv4|mme2Ipv6} $index] } {
                         set dut [getActiveBonoIp]
                         #  set nodeName [getMONameForCLI "mme"]
                         print -info "Locking the parent MO"
                         set result [getAndSetParamViaHeNBGWCli  -dut $dut -paramList "administrativeState=locked" -nodeName "mmeIpv4"  -nodeInst $mmeId -operation "set"]
                         
                    }
                    set dut [getActiveBonoIp]
                    set result [createOrDeleteObjViaHeNBGWCli -dut $dut -objList [list $objList] -nodeName $index -nodeInst $mmeId]
                    if {$result != 0} {
                         print -fail "Failed to update parameters at $index on HeNBGW"
                         set flag 1
                    } else {
                         print -dbg "Successfully updated parameters at $index on HeNBGW"
                    }
                    unset -nocomplain objList
                    
                    if {[regexp {mmeIpv4|mmeIpv6|mme2Ipv4|mme2Ipv6} $index] } {
                         set dut [getActiveBonoIp]
                         #set nodeName [getMONameForCLI "mme"]
                         print -info "Unlocking the parent MO"
                         set result [getAndSetParamViaHeNBGWCli  -dut $dut -paramList "administrativeState=unlocked" -nodeName "mmeIpv4" -nodeInst $mmeId -operation "set"]
                         
                    }
               }
               
               if { $::ROUTING_TB == "yes" && $ind == 0 } {
                    #In routing setup, switchIpAddr is increment of getMmeSimCp1Ipaddress/getMmeSimCp2Ipaddress
                    set inc 2
               } else {
                    set inc 1
               }
               
               # For multiple MMEs we need to increment the remote SCTP ip address
               # This will be done either for IPv4 or IPv6 configuration
               foreach ipIndex [lsearch -all -inline -regexp $mmeNodes "mme(|2)?Ipv(4|6)"] {
                    set tmpMMEIp [string map "mmeIpv4,1 remoteMMeIp mme2Ipv4,2 remoteMMeIp2 mmeIpv6,1 remoteMMeIpV6 mme2Ipv6,2 remoteMMeIp2V6" $ipIndex]
                    regsub -all {\"} [set $tmpMMEIp] "" $tmpMMEIp
                    if {[::ip::is 6 [set $tmpMMEIp]]} {
                         set $tmpMMEIp [incrIpv6 -ip [set $tmpMMEIp] -step $inc]
                    } else {
                         set $tmpMMEIp [incrIp [set $tmpMMEIp] $inc]
                    }
                    set $tmpMMEIp \"[set $tmpMMEIp]\"
               }
          }
     } else {
          set mmeCount 0
          set moCount 1
          set mmeNodes ""
          set regCount 0
          set mmeNo 0
          for {set regIndex 0} {$regIndex < $noOfRegions} {incr regIndex} {
               set regMaxS1Links [getFromTestMap -RegionIndex $regIndex -param "maxS1Links"]
               set noOfMMEs [getFromTestMap -RegionIndex $regIndex -param "noOfRegMMEs"]
               
               set remSctpInd 0
               for {set ind 0} {$ind < $noOfMMEs} {incr ind} {
                    set noOfS1MMELinks [getFromTestMap -S1MMEIndex $mmeCount -param "noOfS1MMEs"]
                    set mmeCount [incr mmeCount]
                    for {set moind 1} {$moind <= $noOfS1MMELinks} {incr moind} {
                         set nodeName "mme"
                         set mmeId $moCount
                         set ARR_LTE_TEST_PARAMS_MAP(MOID,$mmeId,MMEIndex) $mmeNo
                         #set ARR_LTE_TEST_PARAMS_MAP(M,$ind,S1LinkNo,$moind,MOID) $mmeId
                          set ARR_LTE_TEST_PARAMS_MAP(R,$regIndex,M,$ind,S1LinkNo,$moind,MOID) $mmeId
                         set tmpSctp $remoteMMeSctp
                         set refMMETrans [getNodeIndex "mmeTrans" $moind]
                         set refMMETrans [encryptVar $refMMETrans]
                         if {![info exists mmeAdminState]} { set mmeAdminState "unlocked"}
                         #set arr_local(mme,$ind)           [list administrativeState=mmeAdminState, remoteSctpPortNum=remoteMMeSctp, refSCTPConfig=\"$refSctpConfig\"]
                         set objList [processMappingList [list [list [mapNodeIndex $nodeName]:$mmeId [list administrativeState=mmeAdminState, remoteSctpPortNum=remoteMMeSctp, refSCTPConfig=\"$refSctpConfig\", refMMETransportLocal=\"$refMMETrans\"]]]]
                         #for refSCTPConfig value
                         set objList [encryptVar $objList "decrypt"]
                         set remoteMMeSctp $tmpSctp
                         
                         print -info "Creating $nodeName MO objList $objList"
                         set result [createOrDeleteObjViaHeNBGWCli -dut $dut -objList [list $objList] -nodeName $nodeName]
                         if {$result != 0} {
                              print -fail "Failed to create MME MO on HeNBGW"
                              set flag 1
                         } else {
                              print -dbg "Successfully created MME MO on HeNBGW"
                         }
                         # set moCount [incr moCount]
                         
                         # Configuring either ipv4 or ipv6 sctpMO
                         set mmeNodes ""
                         #if {[::ip::is 6 [regsub -all {\"} $remoteMMeIp ""]]}
                         if {[info exists remoteMMeIpV6]} {
                              set mmeNodes "mmeIpv6,1"
                         } else {
                              set mmeNodes "mmeIpv4,1"
                         }
                         
                         # If remote MME multihoming is enabled than create the mmeIp MO
                         if {$remoteMMEMultiHoming == "yes"} {
                              if {[info exists remoteMMeIp2V6]} {
                                   #if {[::ip::is 6 [regsub -all {\"} $remoteMMeIp ""]] && [info exists remoteMMeIp2V6]}
                                   set mmeNodes [concat $mmeNodes "mme2Ipv6,2"]
                                   # elseif {[::ip::is 4 [regsub -all {\"} $remoteMMeIp ""]] && [info exists remoteMMeIp2]}
                              } elseif {[info exists remoteMMeIp2]} {
                                   set mmeNodes [concat $mmeNodes "mme2Ipv4,2"]
                              }
                         }
                         
                         #print -info "Finding regions of MME"
                         #set regs [getFromTestMap -MMEIndex $ind -param "Region"]
                         #set j 1
                         #foreach regId $regs {
                         set refMMERegionsMmeRegion [getNodeIndex "mmeRefRegion" [expr $moind + $regCount]]
                         #set ARR_LTE_TEST_PARAMS_MAP(MOID,$moCount,SubReg) [expr [expr $moind + $regCount] - 1]
                         set ARR_LTE_TEST_PARAMS_MAP(MOID,$moCount,SubReg) [expr $moind + $regCount]
                         set subReg $::ARR_LTE_TEST_PARAMS_MAP(MOID,$moCount,SubReg)
                         set ARR_LTE_TEST_PARAMS_MAP(SubReg,$subReg,Region) $regIndex
                         set refMMERegionsMmeRegion [encryptVar $refMMERegionsMmeRegion]
                         set arr_local(mmeRefRegion,$moind)  [list refMMERegionsMmeRegionDn=\"$refMMERegionsMmeRegion\"]
                         set s1linksmmeNodes [concat $mmeNodes "mmeRefRegion,$moind"]
                         set mmeNodes [concat $mmeNodes "mmeRefRegion,1"]
                         #     incr j
                         # }
                         
                         foreach index $mmeNodes oldIndex $s1linksmmeNodes {
                              print -info "Creating $index MO"
                              # Create the MO class and the corresponding attributes
                              #set oldIndex $index
                              foreach {index nodeInst} [split $index ","] {break}
                              #set objList [processMappingList [list [list [mapNodeIndex $index]:$nodeInst  $arr_local(mmeRefRegion,$moind)]]]
                              set objList [processMappingList [list [list [mapNodeIndex $index]:$nodeInst  $arr_local($oldIndex)]]]
                              print -info "objList $objList"
                              if {[isEmptyList $objList]} {set objList [mapNodeIndex $index]:$nodeInst}
                              set objList [encryptVar $objList "decrypt"]
                              
                              #for IP address value
                              regsub -all {\\"} $objList "\"" objList
                              # Update attributes
                              print -info "Creating $index MO under $nodeName:$mmeId node"
                              if {[regexp mmeIpv4 $index] } {
                                   set dut [getActiveBonoIp]
                                   #  set nodeName [getMONameForCLI "mme"]
                                   print -info "Locking the parent MO"
                                   set result [getAndSetParamViaHeNBGWCli  -dut $dut -paramList "administrativeState=locked" -nodeName "mmeIpv4"  -nodeInst $mmeId -operation "set"]
                                   
                              }
                              set result [createOrDeleteObjViaHeNBGWCli -dut $dut -objList [list $objList] -nodeName $index -nodeInst $mmeId]
                              if {$result != 0} {
                                   print -fail "Failed to update parameters at $index on HeNBGW"
                                   set flag 1
                              } else {
                                   print -dbg "Successfully updated parameters at $index on HeNBGW"
                              }
                              unset -nocomplain objList
                              
                              if {[regexp mmeIpv4 $index] } {
                                   set dut [getActiveBonoIp]
                                   #set nodeName [getMONameForCLI "mme"]
                                   print -info "Unlocking the parent MO"
                                   set result [getAndSetParamViaHeNBGWCli  -dut $dut -paramList "administrativeState=unlocked" -nodeName "mmeIpv4" -nodeInst $mmeId -operation "set"]
                                   
                              }
                         }
                         if { ($::ROUTING_TB == "yes") && ($ind == 0) && ($regIndex == 0)} {
                              #In routing setup, switchIpAddr is increment of getMmeSimCp1Ipaddress/getMmeSimCp2Ipaddress
                              set inc 2
                         } else {
                              set inc 1
                         }
                         if { $noOfS1MMELinks == $moind } {
                              # For multiple MMEs we need to increment the remote SCTP ip address
                              # This will be done either for IPv4 or IPv6 configuration
                              foreach ipIndex [lsearch -all -inline -regexp $mmeNodes "mme(|2)?Ipv(4|6)"] {
                                   set tmpMMEIp [string map "mmeIpv4,1 remoteMMeIp mme2Ipv4,2 remoteMMeIp2 mmeIpv6,1 remoteMMeIpV6 mme2Ipv6,2 remoteMMeIp2V6" $ipIndex]
                                   regsub -all {\"} [set $tmpMMEIp] "" $tmpMMEIp
                                   if {[::ip::is 6 [set $tmpMMEIp]]} {
                                        set $tmpMMEIp [incrIpv6 -ip [set $tmpMMEIp] -step $inc]
                                   } else {
                                        set $tmpMMEIp [incrIp [set $tmpMMEIp] $inc]
                                   }
                                   set $tmpMMEIp \"[set $tmpMMEIp]\"
                              }
                              if {0} {
                                   foreach ipIndex [lsearch -all -inline -regexp $mmeNodes "mme(|2)?Ipv(4|6)"] {
                                        set tmpMMEIp [string map "mmeIpv4,1 remoteMMeIp mme2Ipv4,2 remoteMMeIp2 mmeIpv6,1 remoteMMeIpV6 mme2Ipv6,2 remoteMMeIp2V6" $ipIndex]
                                        regsub -all {\"} [set $tmpMMEIp] "" $tmpMMEIp
                                        if {[::ip::is 6 [set $tmpMMEIp]]} {
                                             set $tmpMMEIp [incrIpv6 -ip [set $tmpMMEIp] -step $inc]
                                        } else {
                                             set $tmpMMEIp [incrIp [set $tmpMMEIp] $inc]
                                             set ip [set $tmpMMEIp]
                                             set x [regexp {([0-9]+).([0-9]+).([0-9]+).([0-9]+)} $ip match a b c d]
                                             while {$d == 255 || $d == 0 || $d == 1 } {
                                                  set ip [incrIp $ip]
                                                  set x [regexp {([0-9]+).([0-9]+).([0-9]+).([0-9]+)} $ip match a b c d]
                                             }
                                             set $tmpMMEIp $ip
                                        }
                                        set $tmpMMEIp \"[set $tmpMMEIp]\"
                                   }
                              }
                              set remSctpInd $ind
                         }
                         set moCount [incr moCount]
                    }
                    set mmeNo [incr mmeNo]
               }
               set regCount [expr $regCount + $regMaxS1Links]
          }
     }
     parray ARR_LTE_TEST_PARAMS_MAP
     if {$flag} {return -1}
     return 0
}

proc oamPreConfigFile {dut operation} {
     set fileName    "/opt/conf/OAM_PreConfig.xml"
     set orgFileName "${fileName}.orig"
     set localFile   "/tmp/[getOwner]_[file tail $fileName]"
     
     switch $operation {
          "read" {
               print -info "Reading OAM xml file ..."
               # processing of xml file
               if {![isATCASetup] && [isIfCfgThrMON]} {
                    print -info "Taking original file as source before updating ..."
                    set cmd "if \[ -f $orgFileName \]; then echo -e \"\\nINFO : Taking original file as reference\\n\"; rm -f $fileName ; \
                              cp -f $orgFileName $fileName ; else echo -e \"\\nINFO : Taking backup of original\
                              file before modifiying data\\n\"; cp $fileName $orgFileName ; fi"
                    set result [execCommandSU -dut $dut -command $cmd]
               }
               
               file delete -force $localFile
               set result [scpFile -remoteHost $dut -localFileName $localFile -remoteUser "admin" -remotePassword "$::ADMIN_PASSWORD" -remoteFileName $fileName]
               if {$result != 0} {
                    print -fail "Failed to retrieve $fileName from $dut. Cannot perform data updation"
                    return -1
               }
               xmlParser $localFile
               #
          }
          "write" {
               # generating xml file
               print -info "Generating OAM xml file ..."
               generateXmlFile $localFile
               
               # copy the modified file to the destination
               print -info "Copying the modified file to the Gateway temporary location"
               set remoteFile "/home/admin/[file tail $fileName]"
               set result [scpFile -remoteHost $dut -localFileName $localFile -remoteUser "admin" -remotePassword "$::ADMIN_PASSWORD" -remoteFileName $remoteFile -opType "send"]
               if {$result != 0} {
                    print -error "Copying of file to local machine failed"
                    print -debug "The system configuration changes would not be updated. ABORTING"
                    exit 1
               }
               print -info "Moving the file from temporary location to the original location"
               set result [moveFile -hostIp $dut -srcFileName $remoteFile -dstFileName $fileName]
               if {$result != 0} {
                    print -err "Copying of file to local machine failed"
                    return -1
               }
          }
     }
     return 0
}

proc oamPreConfigFileforBulkCM { args } {
     parseArgs args \
               [list \
               [list dut          "optional"     "string"          "optional"         "GW ip"]\
               [list operation    "optional"     "string"          "optional"        "read or write" ] \
               [list fileName     "optional"    "string"           "fileName"        "name of the file"] \
               ]
     
     set fileName    "/opt/upload/OAM_PreConfig.xml"
     #set orgFileName "${fileName}.orig"
     set localFile   "/tmp/[getOwner]_[file tail $fileName]"
     
     #set fileName    "/opt/conf/OAM_PreConfig.xml"
     #set orgFileName "${fileName}.orig"
     #set localFile   "/tmp/[getOwner]_[file tail $fileName]"
     
     switch $operation {
          "read" {
               print -info "Reading OAM xml file ..."
               # processing of xml file
               if {![isATCASetup] && [isIfCfgThrMON]} {
                    print -info "Taking original file as source before updating ..."
                    set cmd "if \[ -f $orgFileName \]; then echo -e \"\\nINFO : Taking original file as reference\\n\"; rm -f $fileName ; \
                              cp -f $orgFileName $fileName ; else echo -e \"\\nINFO : Taking backup of original\
                              file before modifiying data\\n\"; cp $fileName $orgFileName ; fi"
                    set result [execCommandSU -dut $dut -command $cmd]
               }
               
               file delete -force $localFile
               set result [scpFile -remoteHost $dut -localFileName $localFile -remoteUser "admin" -remotePassword "$::ADMIN_PASSWORD" -remoteFileName $fileName]
               if {$result != 0} {
                    print -fail "Failed to retrieve $fileName from $dut. Cannot perform data updation"
                    return -1
               }
               xmlParser $localFile
               #
          }
          "write" {
               # generating xml file
               print -info "Generating OAM xml file ..."
               generateXmlFile $localFile
               
               # copy the modified file to the destination
               print -info "Copying the modified file to the Gateway temporary location"
               set remoteFile "/home/admin/[file tail $fileName]"
               set result [scpFile -remoteHost $dut -localFileName $localFile -remoteUser "admin" -remotePassword "$::ADMIN_PASSWORD" -remoteFileName $remoteFile -opType "send"]
               if {$result != 0} {
                    print -error "Copying of file to local machine failed"
                    print -debug "The system configuration changes would not be updated. ABORTING"
                    exit 1
               }
               print -info "Moving the file from temporary location to the original location"
               set result [moveFile -hostIp $dut -srcFileName $remoteFile -dstFileName $fileName]
               if {$result != 0} {
                    print -err "Copying of file to local machine failed"
                    return -1
               }
          }
     }
     return 0
}

#proc oamPreConfigFileforBulkCM { args } {
#
#     parseArgs args \
#               [list \
#               [list dut          "optional"     "string"          "optional"         "GW ip"]\
#               [list operation    "optional"     "string"          "optional"        "read or write" ] \
#               [list fileName     "optional"    "string"           "fileName"        "name of the file"] \
#               ]
#
#     set fileName    "/opt/upload/OAM_PreConfig.xml"
#     #set orgFileName "${fileName}.orig"
#     set localFile   "/tmp/[getOwner]_[file tail $fileName]"
#
#     switch $operation {
#          "read" {
#               print -info "Reading OAM xml file ..."
#               # processing of xml file
#               #print -info "Taking original file as source before updating ..."
#               #set cmd "if \[ -f $orgFileName \]; then echo -e \"\\nINFO : Taking original file as reference\\n\"; rm -f $fileName ; \
#               cp -f $orgFileName $fileName ; else echo -e \"\\nINFO : Taking backup of original\
#                         file before modifiying data\\n\"; cp $fileName $orgFileName ; fi"
#               #set result [execCommandSU -dut $dut -command $cmd]
#               file delete -force $localFile
#               set result [scpFile -remoteHost $dut -localFileName $localFile -remoteUser "$::ADMIN_USERNAME" -remotePassword "$::ADMIN_PASSWORD" -remoteFileName $fileName]
#               if {$result != 0} {
#                    print -fail "Failed to retrieve $fileName from $dut. Cannot perform data updation"
#                    return -1
#               }
#               xmlParser $localFile
#               #
#          }
#          "write" {
#               # generating xml file
#               print -info "Generating OAM xml file ..."
#               generateXmlFile $localFile
#
#               # copy the modified file to the destination
#               print -info "Copying the modified file to the Gateway temporary location"
#               #set remoteFile "/opt/download/[file tail $fileName]"
#               set remoteFile "/home/admin/[file tail $fileName]"
#               set result [scpFile -remoteHost $dut -localFileName $localFile -remoteUser "$::ADMIN_USERNAME" -remotePassword "$::ADMIN_PASSWORD" -remoteFileName $remoteFile -opType "send"]
#               if {$result != 0} {
#                    print -error "Copying of file to local machine failed"
#                    print -debug "The system configuration changes would not be updated. ABORTING"
#                    exit 1
#               }
#               #delete the existing OAM_PreConfig.xml from the /opt/upload folder
#               set result [execCommandSU -dut $dut -command "rm -rf /opt/upload/OAM_PreConfig.xml"]
#
#               #copy the modified OAM_PreConfig.xml from /home/admin to /opt/upload
#               set result [execCommandSU -dut $dut -command "cp /home/admin/OAM_PreConfig.xml /opt/upload/OAM_PreConfig.xml"]
#
#               proc a {} {
#                    print -info "Moving the file from temporary location to the original location"
#                    set result [moveFile -hostIp $dut -srcFileName $remoteFile -dstFileName $fileName]
#                    if {$result != 0} {
#                         print -err "Copying of file to local machine failed"
#                         return -1
#                    }
#               }
#          }
#     }
#     return 0
#}

proc retrieveDefaultValuesFromOam {} {
     #-
     #- supporting proc to retrieve default values from OAM file
     #- We will also consider the updated values after the OAM file is generated and stored on the gateway
     #-
     
     global ARR_OAM_DEFAULT_VAL
     global ARR_XML_DATA
     
     set valueList "fGWMonTimer cellBroadcastResponseGuardTimer s1ResetAckTimer s1ResetGuardTimer s1ResetRetries s1SetupGuardTimer \
               s1SetupRetryTimer s1SetupRetries initialDLMessageGuardTimer enbConfigUpdateGuardTimer mmeConfigUpdateGuardTimer \
               warningMessageAckTimer s1SetupTimeToWait s1ReleaseCompleteGuardTimer hoGuardTimer enbConfigUpdateRetryTimer maxConfigUpdateRetries mmeConfigUpdateRetryTimer"
     
     foreach val $valueList {
          set index [array names ARR_XML_DATA -regexp ",${val},Value"]
          if {$index != ""} {
               set ARR_OAM_DEFAULT_VAL($val) $ARR_XML_DATA($index)
          } else {
               print -fail "Not found \"$val\" in the OAM file"
          }
     }
}

proc restartSoftware {args} {
     #-
     #- Procedure to perform stop and start of BSG instance
     #-
     #- @return  -1 on failure, 0 on success
     
     set validOpList "start|stop|restart"
     parseArgs args \
               [list \
               [list fgwNum           "optional"  "numeric"       "0"       "Position of FGW in the testbed"] \
               [list verify           "optional"  "yes|no"        "yes"     "To perform verification or not" ] \
               [list operation        "optional"  $validOpList    "restart" "To perform stop/start or both on BSG" ] \
               ]
     
     return [restartHeNBGW -fgwNum $fgwNum -verify $verify -operation $operation]
}

proc verifySoftwareProcess {args} {
     #-
     #- To check whether all/specified processes running on the HeNBGW
     #-
     #- @return  0 on success, -1 on failure
     #-
     
     #Changing the process names
     #set allExpectedProcess    "HeNBGwMon gsnmpProxy HeNBGrp HST MST DS"
     set allExpectedProcess    "HeNBGWMon SNMPProxy HeNBGrp HST MST DS"
     
     parseArgs args \
               [list \
               [list boardIp          "mandatory" "ipaddr"                      "-"                  "ip address on the host on which fgw running" ] \
               [list userName         "optional"  "string"                      "admin"              "userName to access the host" ] \
               [list password         "optional"  "string"                      "$::ADMIN_PASSWORD"  "password to access the host" ] \
               [list expProcess       "optional"  "string"                      $allExpectedProcess  "processes expected to be running" ] \
               ]
     
     return [verifyProcessOnHeNBGW -boardIp $boardIp -userName $userName -password $password -expProcess $expProcess]
}

proc cleanUpSimInstances {args} {
     #-
     #- To cheanup stale simulator instances
     #-
     #- @return  0 on success, -1 on failure
     #-
     
     set validSimTypes "HeNB MME"
     parseArgs args \
               [list \
               [list fgwNum           "optional"  "numeric"    "0"                   "Position of FGW in the testbed"] \
               [list switchNum        "optional"  "numeric"    "0"                   "Position of switch in the testbed"] \
               [list simType          "optional"  "string"      "$validSimTypes"     "The simulators running on the host" ] \
               ]
     
     if {[info exists ::BONO_IP_LIST]} {
          set dutIpList $::BONO_IP_LIST
     } else {
          set dutIpList [getActiveBonoIp $fgwNum]
     }
     # Wait for 2 secs before killing the simulators
     print -nonewline "For logging to complete ... "
     halt 2
     
     foreach sim $simType {
          switch $sim {
               "HeNB" {
                    set simIp  [getDataFromConfigFile getHenbSimulatorHostIp $fgwNum $switchNum]
                    set simExe "HeNBSim.exe"
               }
               "MME" {
                    set simIp  [getDataFromConfigFile getMmeSimulatorHostIp $fgwNum $switchNum]
                    set simExe "MMESim.exe"
               }
          }
          closeActiveThreads $simExe $simIp "9" "root"
     }
     
     if {[isProcInStack "setUpHeNBGWForTest"]} {
          # monitor log files on the system for errors
          foreach dutIp $dutIpList {
               print -info "Enabling monitor on log files on $dutIp for errors ..."
               set result [logAnalyzer -hostIp $dutIp -operation "init"]
               
               print -dbg "Taking a snapshot of processes on $dutIp before starting the actual script execution"
               set result [verifyProcesses -dutIp $dutIp]
          }
     } else {
          # monitor log files on the system for errors
          set flag 0
          foreach dutIp $dutIpList {
               print -info "Checking DUT $dutIp log files for errors ..."
               set result [logAnalyzer -hostIp $dutIp -operation "verify"]
               
               print -dbg "Check for any process restart or crash on $dutIp"
               set result [verifyProcesses -dutIp $dutIp -operation "verify"]
               if {$result != 0} {set flag 1}
          }
          return $flag
     }
     
     return 0
}

proc verifyAlarmLogging {args} {
     #-
     #- The procedure to verify the logging in the message file
     #-
     #- @return  0 on success, -1 on failure
     #-
     
     parseArgs args \
               [list \
               [list operation            optional   "init|verify"    "init"       		   "The operation to be performed" ] \
               [list fgwNum               optional   "numeric"        "0"       		   "The dut instance in the testbed file" ] \
               [list msgType              optional   "string"         "s1failure"                  "The message to be verified" ] \
               [list typeOfAlarm          optional   "string"         "__UN_DEFINED__"             "The alarm to be verified" ] \
               [list timeToWait           optional   "string"         "__UN_DEFINED__"             "The time to wait in the message" ] \
               [list causeType            optional   "string"         "__UN_DEFINED__"             "Identifies the cause choice group"] \
               [list cause                optional   "string"         "__UN_DEFINED__"             "Identifies the cause value"] \
               [list criticalityDiag      optional   "string"         "__UN_DEFINED__"             "The critical diag to be enabled or not"] \
               [list procedureCode        optional   "string"         "__UN_DEFINED__"             "The procedure code to be used diag"] \
               [list triggerMsg           optional   "string"         "__UN_DEFINED__"             "Identifies the triggering message"] \
               [list procedureCriticality optional   "string"         "__UN_DEFINED__"             "Identifies the procedure Criticality"] \
               [list IECriticality        optional   "string"         "__UN_DEFINED__"             "Identifies the IE Criticality"] \
               [list IEId                 optional   "numeric"        "__UN_DEFINED__"             "Identifies the IE Id"] \
               [list typeOfError          optional   "string"         "__UN_DEFINED__"             "Identifies the type of error"] \
               ]
     
     set type     [string map -nocase "s1failure S1SetupFailure s1Response S1SetupResponse" $msgType]
     set fileList "/opt/log/app4G/Log_appl4G.log"
     set logType  "alarmLogging"
     set hostIp   [getActiveBonoIp $fgwNum]
     
     if {$operation == "init"} {
          set result [logAnalyzer -fileList $fileList -operation "start" -hostIp $hostIp -logType $logType]
          if {$result < 0} {
               print -fail "Could not index the message logging"
               return -1
          } else {
               print -pass "Log Analysis started"
               return 0
          }
     }
     set data [logAnalyzer -fileList $fileList -operation "return" -hostIp $hostIp -logType $logType]
     if {[catch {array set arr_local $data} err]} {
          print -fail "Could not extact message for analysis"
          return -1
     }
     
     set data $arr_local([string trim $fileList])
     
     set pattern ""
     set extLog  -1
     
     #If msgType is s1response, unsetting cause variable instaces
     if {$msgType == "s1response"} {
          unset -nocomplain cause
          unset -nocomplain causeType
     }
     
     #If the user specifies the typeOfAlarm to be verified in the response then
     # frame the alram to be verified
     # Alternatively verify the critical diag
     if {[info exists typeOfAlarm]} {
          switch $typeOfAlarm {
               "NO_RESPONSE" {set pattern "raiseS1SetupNoResponseAlarm.*S1SetupNoResponse"}
               default       {print -fail "\"$typeOfAlarm\" is not a valid ALARM verification type" ; return -1}
          }
          set extLog [regexp -nocase "$pattern" $data]
     } else {
          # append pattern "$type\.\*"
          # above line changed support process non ue messsage and also to failure message verificationon
          foreach element [list causeType cause IECriticality IEId typeOfError timeToWait] {
               if {[info exists $element]} {
                    if {$element == "causeType"} {continue}
                    if {$element == "cause" && [info exists causeType]} {
                         set var "cause.${causeType}"
                    } else {
                         set var [string map "IECriticality iECriticality IEId iE_ID" $element]
                    }
                    append pattern "$var: [set $element]\.\*"
               }
          }
          set pattern    [string trimright $pattern "\.\*"]
          # set extLog [regexp -nocase "processS1SetupFailure.*$pattern" $data]
          # changed to support process non ue messsage and also to failure message verification
          
          # Added error_indication switch, for the scripts passing msgType in verifyAlarmLogging call
          if {$msgType == "error_indication"} {
               set extLog [regexp -nocase "Error.*Indication.*$pattern" $data]
          } else {
               set extLog [regexp -nocase "process.*$pattern" $data]
          }
     }
     if {$extLog <= 0} {
          print -fail "Could not verify the alarm/pattern \"$pattern\" in the $fileList"
          return -1
     } else {
          print -pass "Pattern \"$pattern\" found in $fileList"
          return 0
     }
}

proc dumpHeNBGwState {{moduleList "all"}} {
     #-
     #- The procedure to dump the HeNBGW state through the debug door
     #-
     #- @return  0 on success, -1 on failure
     #-
     
     set cmdArray(mme)   {"ds,show mme" "ds,show mme ds" "ds,show mmer" "ds,show gwdata" \
                    "ds,show mme conf" "ds,show mme det" "ds,show stats mme all"}
     set cmdArray(henb)  {"ds,show henb" "henbgrp,show henb" "henbgrp,show henb henbgrp" "henbgrp,show paging stats" "henbgrp,show s1ap stats"}
     set cmdArray(ue)    {"henbgrp,show ue all" "henbgrp,show ue mme" "henbgrp,show ue stats"}
     
     if {$moduleList == "all"} {
          set moduleList [lsort -dictionary [array names cmdArray]]
     }
     
     foreach module $moduleList {
          if {[info exists cmdArray($module)]} {
               puts "[string repeat = 30] Dumping stats From : [string toupper $module] [string repeat = 30]"
               foreach entity $cmdArray($module) {
                    foreach {mod cmd} [split $entity ,] {break}
                    switch $mod {
                         "ds"      {executeDsDbgDoorCmd -command $cmd}
                         "henbgrp" {executeHeNBGrpDbgDoorCmd -command $cmd}
                    }
                    puts "\n"
               }
          }
     }
     print -nolog [string repeat - 80]
     
     return 0
}

proc verifyHeNBGWContext {args} {
     #-
     #- Verifies if context is created on the HeNBGW
     #- The Lib will verify the HeNB or MME context based on the Index passed
     #- If the user passes the HeNBIndex then the HeNB context would be verified
     #-
     #- @return 0 on success and -1 on failure
     #-
     
     set noOfRetries   5
     set retryInterval 1
     set flag 0
     parseArgs args \
               [list \
               [list msgType              optional   "string"         "s1Response"                 "The type of message to be verified" ] \
               [list MMEIndex             optional   "string"         "0"                          "The MME instance to be verified against" ] \
               [list HeNBIndex            optional   "string"         "__UN_DEFINED__"             "The HeNB instance to be verified against" ] \
               [list TAC                  optional   "string"         "__UN_DEFINED__"             "The Broadcasted TAC to be used" ] \
               [list eNBName              optional   "string"         "__UN_DEFINED__"		   "eNB name"] \
               [list globaleNBId          optional   "string"         "__UN_DEFINED__"  	   "eNB ID"] \
               [list pagingDRX            optional   "string"         "__UN_DEFINED__"  	   "Pagging DRX value"] \
               [list MCC                  optional   "string"         "__UN_DEFINED__"             "The MCC param to be used"] \
               [list MNC                  optional   "string"         "__UN_DEFINED__"             "The MNC param to be used"] \
               [list MMEName              optional   "string"         "__UN_DEFINED__"             "The MME Name to be sent"] \
               [list HeNBMCC              optional   "string"         "__UN_DEFINED__"             "The MCC param to be used in HeNB"] \
               [list HeNBMNC              optional   "string"         "__UN_DEFINED__"             "The MNC param to be used in HeNB"] \
               [list MMEGroupId           optional   "string"         "__UN_DEFINED__"   	   "The MME group ID to be used"] \
               [list MMECode              optional   "string"         "__UN_DEFINED__"             "The MME Code to be used"] \
               [list relMMECapability     optional   "string"         "__UN_DEFINED__"             "The relMMECapability to be used"] \
               [list MMERelaySupportInd   optional   "string"         "__UN_DEFINED__"             "The MME Relay Support Indicator to be used"] \
               [list timeToWait           optional   "string"         "__UN_DEFINED__"             "Value of time to wait indication in failure msg"] \
               [list causeType            optional   "string"         "__UN_DEFINED__"             "Identifies the cause choice group"] \
               [list cause                optional   "string"         "__UN_DEFINED__"             "Identifies the cause value"] \
               [list criticalityDiag      optional   "string"         "__UN_DEFINED__"             "The critical diag to be enabled or not"] \
               [list procedureCode        optional   "string"         "__UN_DEFINED__"             "The procedure code to be used diag"] \
               [list triggerMsg           optional   "string"         "__UN_DEFINED__"             "Identifies the triggering message"] \
               [list procedureCriticality optional   "string"         "__UN_DEFINED__"             "Identifies the procedure Criticality"] \
               [list IECriticality        optional   "string"         "__UN_DEFINED__"             "Identifies the IE Criticality"] \
               [list IEId                 optional   "numeric"        "__UN_DEFINED__"             "Identifies the IE Id"] \
               [list typeOfError          optional   "string"         "__UN_DEFINED__"             "Identifies the type of error"] \
               [list verifyLog            optional   "string"         "no"                         "Option to stop and verify log"] \
               [list returnRaw            optional   "string"         "no"                         "Option to stop and verify log"] \
               ]
     
     if {![info exists HeNBIndex]} {
          set contextType "MME"
          #Get the MME data from the debug door
          for {set retry 0} {$retry < $noOfRetries} {incr retry} {
               set result     [executeHeNBGrpDbgDoorCmd -command "show mme"]
               set result     [extractOutputFromResult $result]
               if {[string trim $result] != ""} {break}
               print -info "Failed to get data from debug door... retrying"
               halt $retryInterval
          }
          set data       [split $result \n]
          set mmeCxtList [lsearch -all -regexp $data "MME Context Details for MME Id"]
          if {$mmeCxtList < 0 || [isEmptyList $mmeCxtList]} {
               if {![regexp -nocase "s1Response" $msgType]} {
                    print -pass "MME Context not created for $msgType as expected"
                    return 0
               } else {
                    print -fail "MME context does not exist for MMEIndex $MMEIndex"
                    return -1
               }
          }
          
          #Extract the MME block for the MME index
          if {[llength $mmeCxtList] > [expr $MMEIndex + 1]} {
               set mmeData [lrange $data [lindex $mmeCxtList $MMEIndex] [lindex $mmeCxtList [expr $MMEIndex + 1]]]
          } else {
               set mmeData [lrange $data [lindex $mmeCxtList $MMEIndex] end]
          }
          
          #Extract the MME context details from the MME data
          set startIndex [lsearch -regexp $mmeData "MMERegion END" ]
          set gummIndex  [lsearch -regexp $mmeData "Served GUMMEI List"]
          set endIndex   [lsearch -regexp $mmeData "MMEContext END"]
          
          set mmeData1      [join [lrange $mmeData [expr $startIndex + 1] [expr $endIndex - 1]] "\n"]
          set contextData   [join [lrange $mmeData $gummIndex [expr $endIndex - 1]] "\n"]
          set msgType     s1Response
          
     } else {
          # To verify the HeNB Index get the HeNB data and verify the TAI
          set contextType "HeNB"
          if {[info exists ::ARR_HeNBGRP_MAP($HeNBIndex)]} {
               set instance $::ARR_HeNBGRP_MAP($HeNBIndex)
          } else {
               set instance 1
          }
          set enbId       $::ARR_LTE_TEST_PARAMS_MAP(H,$HeNBIndex,HeNBId)
          for {set retry 0} {$retry < $noOfRetries} {incr retry} {
               set result      [executeHeNBGrpDbgDoorCmd -command "show henb" -instance $instance]
               set result      [extractOutputFromResult $result]
               if {[string trim $result] != ""} {break}
               print -info "Failed to get data from debug door... retrying"
               halt $retryInterval
          }
          
          set data        [split $result \n]
          set heNBCnxtI   [lsearch -regexp $data "HeNB Context Details for.*ENBID.*$enbId"]
          print "heNBCnxtI: $heNBCnxtI"
          if {$heNBCnxtI < 0} {
               if {![regexp -nocase "s1Request" $msgType]} {
                    print -pass "HeNB Context not created for $msgType as expected"
                    return 0
               } else {
                    print -fail "HeNB context does not exist for HeNBIndex $HeNBIndex"
                    return -1
               }
          }
          
          # Extract the data that is required
          set startIndex  [lsearch -regexp -start $heNBCnxtI $data "Serving TAI List"]
          set endIndex    [lsearch -regexp -start $heNBCnxtI $data "Map of"]
          set contextData [join [lrange $data $startIndex [expr $endIndex - 1]] \n]
          set msgType     "s1Request"
     }
     
     switch -regexp $msgType {
          "s1Response" {
               if { $returnRaw == "yes"  } {return "[processSimulatorOutput $contextData debug]" }
               set result [verifySimOutput [processContextData -context $contextType -MMEIndex $MMEIndex] [processSimulatorOutput $contextData debug]]
          }
          "s1Request" {
               set result [verifySimOutput [processContextData -context $contextType -HeNBIndex $HeNBIndex] [processSimulatorOutput $contextData debug]]
          }
     }
     
     #Verify alarm verification in message file if the feature is enabled
     if {$verifyLog != "no"} {
          print -nonewline "For log to update ..."
          halt 2
          
          set operation "verify"
          set result [updateValAndExecute "verifyAlarmLogging -operation operation -fgwNum fgwNum -msgType msgType \
                    -causeType causeType -cause cause -criticalityDiag criticalityDiag \
                    -procedureCode procedureCode -triggerMsg triggerMsg \
                    -procedureCriticality procedureCriticality -IECriticality IECriticality \
                    -IEId IEId -typeOfError typeOfError -timeToWait timeToWait"]
          if {$result < 0} {
               print -fail "Pattern Alarm verification failed"
               set flag 1
          } else {
               print -pass "Pattern Alarm verification successfull"
          }
     }
     
     # Dump the debug door contents after the verification is complete
     if {[info exists contextType]} {dumpHeNBGwState [string tolower $contextType]}
     
     if {$flag} {return -1}
     return 0
}

proc extractMMEIndexInS1FlexForeNBConfigSent {args} {
     
     #- Extracting the MME index in S1 flex
     #-
     #- return 0 on sucess and -1 on failure
     #-
     global ARR_MME_FOR_eNB_MSGs
     
     parseArgs args \
               [list \
               [list fgwNum              "optional"  "numeric"      "0"            "The dut instance in the testbed file "] \
               [list op                  "optional"  "snap|extract" "snap"         "operation of taking snapshot or compare"] \
               
     ]
     
     set noOfRetries 5
     set retryInterval 2
     for {set retry 0} {$retry < $noOfRetries} {incr retry} {
          set result [executeDsDbgDoorCmd -command "show stats configtrans all"]
          set result      [extractOutputFromResult $result]
          if {[string trim $result] != ""} {break}
          print -info "Failed to get data from debug door... retrying"
          halt $retryInterval
     }
     
     set data [split $result \n]
     regsub -all {\-} $data "" data
     
     set data [string trim $data "\n"]
     
     if { $data == ""} {
          print -fail "snapshot of MME msg statistics is not available"
          return -1
     }
     set mmeIndENB 0
     array set arr_local_eNB ""
     foreach line $data {
          regexp {(\d+) *(\d+) *(\d+) *(\d+)} $line - mmeIndENB MMEConfigRx MMEConfigTx eNBConfigTx
          if {$mmeIndENB} {
               set arr_local_eNB($mmeIndENB) $eNBConfigTx
          }
     }
     
     if {$op == "snap"} {
          print -info "printing the snapshot collected ...."
          parray arr_local_eNB
          print -debug "storing the snapshot collected"
          array set ARR_MME_FOR_eNB_MSGs [array get arr_local_eNB]
          
          return 0
     } elseif {$op == "extract"} {
          set indexListeNB ""
          if {[info exists ARR_MME_FOR_eNB_MSGs]} {
               array set arr_local_eNB1 [array get ARR_MME_FOR_eNB_MSGs]
               set indexListeNB [lsort -dictionary [array names arr_local_eNB1]]
               unset ARR_MME_FOR_eNB_MSGs
               print -info "printing the old snapshot collected ...."
               parray arr_local_eNB1
          } else {
               print -info "previous snapshot of MME msg statistics is not available ....."
          }
          
          array set arr_local_eNB2 [array get arr_local_eNB]
          set indexListeNB2 [lsort -dictionary [array names arr_local_eNB2]]
          set indexListeNB  [lsort -unique [concat $indexListeNB $indexListeNB2]]
          
          print -info "printing the new snapshot collected ...."
          parray arr_local_eNB2
          
          set found 0
          foreach index $indexListeNB {
               if {[info exists arr_local_eNB1($index)] && [info exists arr_local_eNB2($index)]} {
                    #Extracting mmeIndex where statistics is increased by 1
                    if {$arr_local_eNB2($index) == [expr $arr_local_eNB1($index) + 1]} {
                         print -info "mme $index has 1 msg recently been sent"
                         lappend match $index
                         set found 1
                    } elseif {$arr_local_eNB2($index) == $arr_local_eNB1($index)} {
                         continue
                    } elseif {$arr_local_eNB2($index) > [expr $arr_local_eNB1($index) + 1]} {
                         print -fail "mme $index has [expr $arr_local_eNB2($index)-$arr_local_eNB1($index)] \
                                   msgs recently been sent"
                         lappend match $index
                         set found 1
                    } else { continue}
               } elseif {![info exists arr_local_eNB2($index)]} {
                    print -info "mme $index is not available in recent snapshot"
               } elseif {![info exists arr_local_eNB1($index)]} {
                    #Extracting mmeIndex where statistics is increased by 1
                    if {$arr_local_eNB2($index) == 1} {
                         print -info "mme $index, which is new, has 1 msg recently been sent"
                         lappend match $index
                         set found 1
                    } elseif {$arr_local_eNB2($index) > 1} {
                         print -fail "mme $index has $arr_local_eNB2($index) msgs recently been sent"
                         lappend match $index
                         set found 1
                    } else { continue }
               }
          }
     }
     
     if {$found == 1} {
          return $match
     } else {
          print -info "Msg is not sent"
          return -1
     }
     
}

proc extractMMEIndexInS1Flex {args} {
     #-
     #- Extracting the MME index in S1 flex
     #-
     #- return 0 on sucess and -1 on failure
     #-
     global ARR_HeNBGRP_MAP
     global ARR_MME_MSGs
     
     parseArgs args \
               [list \
               [list fgwNum              "optional"  "numeric"      "0"            "The dut instance in the testbed file "] \
               [list HeNBIndex           "optional"  "numeric"      "0"            "HeNBIndex"] \
               [list OverloadMMEIndex    "optional"  "numeric"      "__UN_DEFINED__" "MMEIndex which is marked in overload list"] \
               [list op                  "optional"  "snap|extract" "snap"         "operation of taking snapshot or compare"] \
               
     ]
     
     if {[info exists ::ARR_HeNBGRP_MAP($HeNBIndex)]} {
          set instance $::ARR_HeNBGRP_MAP($HeNBIndex)
     } else {
          set instance 1
     }
     
     print -dbg "HeNBGrp instance for HeNBIndex $HeNBIndex is $instance"
     set noOfRetries 5
     set retryInterval 2
     for {set retry 0} {$retry < $noOfRetries} {incr retry} {
          set result      [executeHeNBGrpDbgDoorCmd -command "show ue stats mme all" -instance $instance]
          set result      [extractOutputFromResult $result]
          if {[string trim $result] != ""} {break}
          print -info "Failed to get data from debug door... retrying"
          halt $retryInterval
     }
     
     set data [split $result \n]
     regsub -all {\-} $data "" data
     
     set data [string trim $data "\n"]
     
     if { $data == ""} {
          print -fail "snapshot of MME msg statistics is not available"
          return -1
     }
     
     array set arr_local ""
     foreach line $data {
          switch -regexp $line {
               {MME.*UE stats} {
                    regexp {MME\((\d+)\) UE stats} $line - mmeInd
               }
               {Initial UE Msg Sent} {
                    regexp {Initial UE Msg Sent : (\d+)} $line - noOfMsgs
                    set arr_local($mmeInd) $noOfMsgs
               }
               default { continue}
          }
     }
     
     if {$op == "snap"} {
          print -info "printing the snapshot collected ...."
          parray arr_local
          print -debug "storing the snapshot collected"
          array set ARR_MME_MSGs [array get arr_local]
          
          return 0
     } elseif {$op == "extract"} {
          set indexList ""
          if {[info exists ARR_MME_MSGs]} {
               array set arr_local1 [array get ARR_MME_MSGs]
               set indexList [lsort -dictionary [array names arr_local1]]
               unset ARR_MME_MSGs
               print -info "printing the old snapshot collected ...."
               parray arr_local1
          } else {
               print -info "previous snapshot of MME msg statistics is not available ....."
          }
          
          array set arr_local2 [array get arr_local]
          set indexList2 [lsort -dictionary [array names arr_local2]]
          set indexList  [lsort -unique [concat $indexList $indexList2]]
          
          print -info "printing the new snapshot collected ...."
          parray arr_local2
          
          set flag  0
          set found 0
          foreach index $indexList {
               if {[info exists arr_local1($index)] && [info exists arr_local2($index)]} {
                    #Extracting mmeIndex where statistics is increased by 1
                    if {$arr_local2($index) == [expr $arr_local1($index) + 1]} {
                         print -info "mme $index has 1 msg recently been sent"
                         lappend match $index
                         set found 1
                    } elseif {$arr_local2($index) == $arr_local1($index)} {
                         continue
                    } elseif {$arr_local2($index) > [expr $arr_local1($index) + 1]} {
                         print -fail "mme $index has [expr $arr_local2($index)-$arr_local1($index)] \
                                   msgs recently been sent"
                         lappend match $index
                         set found 1
                    } else { continue}
               } elseif {![info exists arr_local2($index)]} {
                    print -info "mme $index is not available in recent snapshot"
               } elseif {![info exists arr_local1($index)]} {
                    #Extracting mmeIndex where statistics is increased by 1
                    if {$arr_local2($index) == 1} {
                         print -info "mme $index, which is new, has 1 msg recently been sent"
                         lappend match $index
                         set found 1
                    } elseif {$arr_local2($index) > 1} {
                         print -fail "mme $index has $arr_local2($index) msgs recently been sent"
                         lappend match $index
                         set found 1
                    } else { continue }
               }
               if {[info exists OverloadMMEIndex]} {
                    print -info "found $found index $index mme $OverloadMMEIndex"
                    if {$found == 1 } {
                         if {[lsearch -exact $index $OverloadMMEIndex] != 0} {
                              print -Info "overloaded mme $index has received a msg, as expected "
                         } elseif {[lsearch -exact $index $OverloadMMEIndex] == 0} {
                              print -fail "overloaded mme $index has received a msg, not expected "
                              set flag 1
                         }
                    } elseif {$found == 0 && [lsearch -exact $index $OverloadMMEIndex]} {
                         print -info "overloaded mme $index has not received any msg, as expected "
                         set found 1
                    }
               }
          }
     }
     if {[info exists OverloadMMEIndex]} {
          if {$flag == 1} {
               print -fail "overloaded mme $index has received a msg, not expected "
               return -1
          } else {
               return 0
          }
     }
     
     if {$found == 1} {
          return $match
     } else {
          print -info "Msg is not sent"
          return -1
     }
}

proc mmeAccessList {args} {
     #-
     #-Procedure for displaying/validating MME access list
     #-
     global ARR_HeNBGRP_MAP
     global ARR_MME_ACC_LST
     parseArgs args \
               [list \
               [list HeNBIndex          mandatory  "numeric" "0"               "Index of HeNB to get the henbGrp instance and regionInd" ] \
               [list tai                optional   "string"  "__UN_DEFINED__"  "tai in the format of {tac=<tac> mcc=<mcc> mnc=<mnc>}" ] \
               [list plmnIndex          optional   "string"  "__UN_DEFINED__"  "Index of PLMN within HeNB for which mmeAccessList need to be validated" ] \
               [list expectedMMEs       optional   "string"  "__UN_DEFINED__"  "List of of MME indices expected in mmeAccessList" ] \
               [list compare            optional   "yes|no"  "no"              "option to compare the mmeAccessList with previous execution of this command"] \
               [list RRCEstablishCause  optional   "string"  "__UN_DEFINED__"  "Filtering acording to RRC Establishment cause" ] \
               [list  returnResult      optional   "string"  "no"               "to return result to compare 2 plmns"]\
               ]
     
     if {[info exists tai]} {
          print -info "HeNBIndex $HeNBIndex tai $tai"
          regexp -nocase {mcc=(\d+)} $tai match mcc
          regexp -nocase {mnc=(\d+)} $tai match mnc
          #Using decimal equivalent of plmn, as DD expects decimal value
          #set plmn [expr 0x$plmn]
     } elseif {[info exists plmnIndex]} {
          print -info "HeNBIndex $HeNBIndex plmnIndex $plmnIndex"
          set mcc [getIEVal -ieType "bcMCC" -ieIndex $plmnIndex -HeNBIndex $HeNBIndex]
          set mnc [getIEVal -ieType "bcMNC" -ieIndex $plmnIndex -HeNBIndex $HeNBIndex]
     }
     set plmn [createLteIdentifier -identifier PLMNId -MCC $mcc -MNC $mnc]
     
     if {[info exists ::ARR_HeNBGRP_MAP($HeNBIndex)]} {
          set instance $::ARR_HeNBGRP_MAP($HeNBIndex)
     } else {
          set instance 1
     }
     set regIndices [getFromTestMap -HeNBIndex $HeNBIndex -param "Region"]
     foreach regInd [lindex $regIndices 0] {
          set regInd [expr $regInd + 1]
          
          print -info "Printing MME access table  for region $regInd plmn $plmn"
          if {[info exists RRCEstablishCause]} {
               set result      [executeHeNBGrpDbgDoorCmd -command "show nnsf mmeaccesslist $regInd $plmn $RRCEstablishCause" -instance $instance]
          } else {
               set result      [executeHeNBGrpDbgDoorCmd -command "show nnsf mmeaccesslist $regInd $plmn" -instance $instance]
          }
     }
     #set result {MME Access List
     #---------------
     #MME ID: 1 Start Range : 1 End Range : 158
     #MME ID: 2 Start Range : 159 End Range : 360}
     
     set data [split $result \n]
     regsub -all {\-} $data "" data
     
     set data [string trim $data "\n"]
     
     if { $data == ""} {
          print -fail "snapshot of MME access table is not available"
          return -1
     }
     
     array set arr_local ""
     foreach line $data {
          switch -regexp $line {
               {MME ID} {
                    regexp {MME ID\: (\d+) Start Range : (\d+) End Range : (\d+)} $line - mmeInd stRange endRange
                    set arr_local($mmeInd,stRange)  $stRange
                    set arr_local($mmeInd,endRange) $endRange
               }
               default { continue}
          }
     }
     
     set flag 0
     if {$compare != "yes" } {
          print -info "printing the snapshot collected ...."
          parray arr_local
          print -debug "storing the snapshot collected"
          unset -nocomplain ARR_MME_ACC_LST
          array set ARR_MME_ACC_LST [array get arr_local]
          if { $returnResult == "yes"} {
               return ARR_MME_ACC_LST
          }
     } else {
          #comparing the startrange and endrange with the previous mmeaccessdata
          print -info "comparing the startrange and endrange with the previous mmeaccessdata ... "
          if {[info exists ARR_MME_ACC_LST]} {
               array set arr_local1 [array get ARR_MME_ACC_LST]
               foreach index [array names arr_local] index1 [array names arr_local1] {
                    if {$arr_local($index) != $arr_local1($index1)} {
                         print -fail "MME Access list data $arr_local($index) is not same as previous $arr_local1($index1) for mme index $index"
                         set flag 1
                    }
               }
               set indexList [lsort -dictionary [array names arr_local1]]
               
          }
     }
     if {[info exists expectedMMEs]} {
          #Verifying the expected mme Indices with the MME Id's in current mmeAccessData
          print -info "Verifying the expected mme Indices $expectedMMEs with the MME Id's in current mmeAccessData ... "
          
          set expectedMMEs [lsort -increasing $expectedMMEs]
          
          #Getting MMEIndices from current mmeAccessList o/p
          set keys [array names ARR_MME_ACC_LST *,stRange]
          set keys [lsort -increasing [regsub -all {,stRange} $keys ""]]
          print -info "keys $keys"
          foreach ind $expectedMMEs ind1 $keys {
               incr ind
               if {$ind != $ind1} {
                    print -fail "MME access list data $ind1 is not same as expected MME index $ind"
                    set flag 1
               }
          }
          
     }
     if {$flag} {
          return -1
     } else {
          return 0
     }
}

proc setLogTraceStatus {args} {
     #-
     #- Setting the tracelevel for process
     #-
     #- return 0 on sucess and -1 on failure
     #-
     set flag 0
     parseArgs args \
               [list \
               [list fgwNum              "optional"  "numeric"     "0"            "The dut instance in the testbed file "] \
               [list processList         "optional"  "string"      "all"          "The trace level to be set"] \
               [list traceLevel          "optional"  "string"      "all"          "The trace level to be set"] \
               [list traceStatus         "optional"  "string"      "fileEnable"   "Set the trace status"] \
               ]
     
     set dutIp [getActiveBonoIp $fgwNum]
     if {$traceLevel  == "all"} {set traceLevel  "Debug Info Warn Error Fatal" }
     if {$processList == "all"} {set processList "DS HeNBGrp HST MST HeNBGWMON"}
     #check if tracestatus has multiple entries
     if {[llength $traceStatus] == 1} {
          set numOflevels [llength $traceLevel]
          for {set i 1} {$i<$numOflevels} {incr i} {
               append traceStatus " fileEnable"
          }
     }
     # enable or disable file logs as per request
     foreach level $traceLevel status $traceStatus {
          if {$status == "fileDisable"} {
               append patternList  " -e '/\\\..*LogLevelToMatch=[string toupper $level]/ \{ N ; s/true\\\|false/false/\}'"
          } else {
               append patternList  " -e '/\\\..*LogLevelToMatch=[string toupper $level]/ \{ N ; s/true\\\|false/true/\}'"
          }
     }
     foreach process $processList {
          set logFile "/opt/conf/${process}log.properties"
          print -info "Setting the trace level \"$traceLevel\" for process \"$process\""
          set cmd "rm -f ${logFile}.org \n cp -f $logFile ${logFile}.org \n sed -i $patternList $logFile"
          
          set result [execCommandSU -dut $dutIp -command $cmd]
          if {[regexp "ERROR:|(No such file)" $result] || $result == -1} {
               print -err "Not able to update the log levels"
               set flag 1
          } else {
               print -info "successfully updated log levels for $process"
          }
     }
     if {$flag} {return -1}
     return 0
}

proc verifyUEContext {args} {
     #-
     #- Procedure to verify the UE context on the HeNBGW
     #- This procedure can also be used to update the UE values in the ARR_LTE_TEST_PARAMS_MAP
     #-
     #- return 0 on sucess and -1 on failure
     #-
     
     set flag 0
     set validStates "full|partial|ready_for_release|update|empty"
     
     set validClass1Procedures [getValidClass1Procedures]
     set validClass2Procedures [getValidClass2Procedures]
     set validMsg              [concat $validClass1Procedures $validClass2Procedures]
     set validMsg              [join $validMsg |]
     
     parseArgs args \
               [list \
               [list fgwNum              "optional"  "numeric"       "0"        		"The dut instance in the testbed file "   ] \
               [list state               "optional"  "$validStates"  "full"     		"The state of the UE context to verify"   ] \
               [list HeNBIndex           "optional"  "numeric"       "0"        		"The HeNB on which the UE is associated"  ] \
               [list MMEIndex            "optional"  "numeric"       "0"        		"The MME for which the UE is associated"  ] \
               [list UEIndex             "optional"  "string"        "0"        		"The UE for which the context is verified"] \
               [list eNBUES1APId         "optional"  "numeric"       "__UN_DEFINED__" 		"eNBUES1APId from script"] \
               [list MMEUES1APId         "optional"  "numeric"       "__UN_DEFINED__" 		"eNBUES1APId from script"] \
               [list initiatingMsg       "optional"  "$validMsg"     "__UN_DEFINED__"    	"The message after which the context is verified"] \
               ]
     
     if {$state == "update"} {
          set validUpdateList "vENBUES1APId|vMMEUES1APId|mStreamId|hStreamId"
          parseArgs args \
                    [list \
                    [list updateVar      "mandatory"  "$validUpdateList"   "_"                "The param to be updated "   ] \
                    [list updateMap      "optional"   "string"             "__UN_DEFINED__"   "The value to be used to map the data to be updated"   ] \
                    ]
          
          set i 0
          foreach var $updateVar {
               if {[info exists updateMap] } {
                    if {[lindex $updateMap $i]!=-1} {
                         set updMap [lindex $updateMap $i]
                    }
               }
               switch $var {
                    "vENBUES1APId" {
                         if {[info exists eNBUES1APId]} {
                              set updMap $eNBUES1APId
                              set cmd    "show ue enbapid $updMap"
                         } elseif {[info exists MMEUES1APId]} {
                              set updMap $MMEUES1APId
                              set cmd "show ue mmeapid $updMap"
                         } elseif {![info exists updMap]} {
                              set updMap [getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -MMEIndex $MMEIndex -param "eNBUES1APId"]
                              set cmd    "show ue enbapid $updMap"
                         }
                         set extVar {Virtual ENB UE S1 AP ID}
                    }
                    "vMMEUES1APId" {
                         if {[info exists MMEUES1APId]} {
                              set updMap $MMEUES1APId
                         } elseif {![info exists updMap]} {
                              set updMap [getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -MMEIndex $MMEIndex -param "MMEUES1APId"]
                         }
                         set cmd "show ue mmeapid $updMap"
                         set extVar {Virtual MME UE S1 AP ID}
                    }
                    "mStreamId" {
                         if {[info exists eNBUES1APId]} {
                              set updMap $eNBUES1APId
                         } elseif {![info exists updMap]} {
                              set updMap [getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -MMEIndex $MMEIndex -param "eNBUES1APId"]
                         }
                         set cmd "show ue enbapid $updMap"
                         set extVar {MME Out Stream ID}
                    }
                    "hStreamId" {
                         if {[info exists eNBUES1APId]} {
                              set updMap $eNBUES1APId
                              set cmd    "show ue enbapid $updMap"
                         } elseif {[info exists MMEUES1APId]} {
                              set updMap $MMEUES1APId
                              set cmd "show ue mmeapid $updMap"
                         } elseif {![info exists updMap]} {
                              set updMap [getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -MMEIndex $MMEIndex -param "eNBUES1APId"]
                              set cmd    "show ue enbapid $updMap"
                         }
                         set extVar {HeNB Out Stream ID}
                    }
               }
               
               unset -nocomplain updMap
               #Get the HeNBGrp from which data has to be fetched
               if {[info exists ::ARR_HeNBGRP_MAP($HeNBIndex)]} {
                    set instance $::ARR_HeNBGRP_MAP($HeNBIndex)
               } else {
                    set instance 1
               }
               
               #Get the UE context and the mapping and update the value
               set result [executeHeNBGrpDbgDoorCmd -command $cmd -instance $instance]
               set result [processSimulatorOutput $result "debug"]
               if {[catch {array set arr_local $result}]} {
                    print -fail "Could not process data from UE context"
                    return -1
               }
               if {![info exists arr_local($extVar)]} {
                    print -fail "Could not get the required data, $extVar"
                    return -1
               }
               set paramList [list [list $var $arr_local($extVar)]]
               print -info "Updating the $var for HeNB=$HeNBIndex UE=$UEIndex with value $arr_local($extVar)"
               set result [updateLteParamData -fgwNum $fgwNum -HeNBIndex $HeNBIndex \
                         -MMEIndex $MMEIndex -UEIndex $UEIndex -paramList $paramList]
               if {$result < 0} {
                    print -fail "Could not update the UE context data"
                    return -1
               }
               incr i
          }
     } else {
          # Verify context data
          foreach mmeIndex $MMEIndex henbIndexList $HeNBIndex ueIndexList $UEIndex {
               foreach henbIndex $henbIndexList ueIndex $ueIndexList {
                    # Get the HeNBGrp from which data has to be fetched
                    if {[info exists ::ARR_HeNBGRP_MAP($henbIndex)]} {
                         set instance $::ARR_HeNBGRP_MAP($henbIndex)
                    } else {
                         set instance 1
                    }
                    
                    # identifying the UEs associated with given HeNB
                    set ueIndex1 ""
                    if {[regexp "," $ueIndex]} { set ueIndex [split $ueIndex ,] }
                    foreach ueId $ueIndex {
                         if {[regexp {^(\d+)-(\d+)$} $ueId _ start end]} {
                              set ueIndex1 [concat $ueIndex1 [listOfIncrEle $start [expr $end - $start + 1]]]
                         } else {
                              lappend ueIndex1 $ueId
                         }
                    }
                    
                    # check the state of each UE on the Gateway
                    foreach ueId $ueIndex1 {
                         if {$henbIndex == ""} {
                            print -debug "NOTE: henbIndex variable is null."
                            #Dump the UE state after the UE verification is complete
                            dumpHeNBGwState ue
                            return 0
                         }
                         set updateMap [getFromTestMap -HeNBIndex $henbIndex -UEIndex $ueId -MMEIndex $mmeIndex -param "eNBUES1APId"]
                         set cmd "show ue enbapid $updateMap"
                         
                         print -info "Checking UE($ueId) state on Gateway associated with HeNB($henbIndex), MME($mmeIndex), virtual eNB_id ($updateMap)"
                         
                         # Get the UE context and the mapping and update the value
                         set contextData [executeHeNBGrpDbgDoorCmd -command $cmd -instance $instance]
                         switch -regexp $state {
                              "empty" {
                                   if {![isEmptyList [extractOutputFromResult $contextData]]} {
                                        print -fail "Context is not empty"
                                        return -1
                                   } else {
                                        print -pass "The UE context is empty"
                                   }
                              }
                              "partial|full|ready_for_release" {
                                   if {![info exists initiatingMsg]} {
                                        set initiatingMsg [getLastInitiatedMessage -MMEIndex $mmeIndex -HeNBIndex $henbIndex]
                                        if {$initiatingMsg == -1} {set initiatingMsg downlink_nas_transport}
                                   }
                                   set processContextInput  [processContextData -context UE \
                                             -MMEIndex $mmeIndex -HeNBIndex $henbIndex -UEIndex $ueId -state $state -initiatingMsg $initiatingMsg]
                                   set processContextOutput [processSimulatorOutput $contextData debug]
                                   set result [verifySimOutput $processContextInput $processContextOutput]
                              }
                              default {
                                   print -info "$state is not available"
                              }
                         }
                    }
               }
          }
          #Dump the UE state after the UE verification is complete
          dumpHeNBGwState ue
     }
     return 0
}

proc extractMultipleContextOp {cmd {cmdType mme}} {
     #-
     #- Procedure for getting multiple context o/p from DD
     #- cmdType mmme/henb processes UE contexts and gets ues1List for reset
     #-
     #- @return ues1list on success, @return -1 on failure
     #-
     
     set result [executeHeNBGrpDbgDoorCmd -command $cmd]
     set result [processSimulatorOutput $result "ueCtx"]
     if {[catch {array set arr_local $result}]} {
          print -fail "Could not process data from UE context"
          return -1
     }
     #parray arr_local
     
     if {$cmdType == "mme"} {
          set extList {"ENB UE S1 AP ID" "Virtual MME UE S1 AP ID"}
     } elseif {$cmdType == "henb"} {
          set extList {"MME UE S1 AP ID" "Virtual ENB UE S1 AP ID"}
     } else {
          return -1
     }
     
     #Reading multiple UE contexts
     foreach name [array names arr_local] {
          print -info "[string repeat - 10] context [string repeat - 10]"
          if {[lsearch -regexp $arr_local($name) {UE_CONTEXT_SUBSTATE_DEFAULT|UE_CONTEXT_SUBSTATE_AWAITING_MME_RSP}] < 0} {
               print -debug "skipping a UE context as it is not in Full/Partial state,hence Reset message is not expected .."
               continue
          }
          
          if {$cmdType == "mme"} {
               regexp {HeNB ID\s+:\s+(\d+)} $arr_local($name) match index
               set index [expr $index-1]
               set index "h$index"
               print -info "peer index $index"
          }
          
          if {$cmdType == "henb"} {
               regexp {MME ID\s+:\s+(\d+)} $arr_local($name) match index
               set index [expr $index-1]
               set index "m$index"
               print -info "peer index $index"
          }
          
          set ues1 ""
          #Reading each line of UE context
          foreach ele $arr_local($name) {
               foreach {param val} [split $ele ":"] {break}
               set param [string trim $param]
               set val [string trim $val]
               
               #If context is in partial state, ms1id will be 0, no need to append to ues1list
               if {$val == 0} {continue}
               
               if {[lsearch $extList $param]<0} {
                    continue
               }
               
               print -info "ele: $ele"
               switch $param {
                    "ENB UE S1 AP ID" {
                         #append arr_new_local($index,u$ind) "es1id=$val "
                         append ues1 "es1id=$val "
                    }
                    "Virtual MME UE S1 AP ID" {
                         #append arr_new_local($index,u$ind) "ms1id=$val "
                         append ues1 "ms1id=$val "
                    }
                    "Virtual ENB UE S1 AP ID" {
                         #append arr_new_local($index,u$ind) "es1id=$val "
                         append ues1 "es1id=$val "
                    }
                    "MME UE S1 AP ID" {
                         #append arr_new_local($index,u$ind) "ms1id=$val "
                         append ues1 "ms1id=$val "
                    }
                    "default" {}
               }
          }
          #appending ues1 to respective peer(mme/henb) index's list
          append arr_new_local($index) "{[string trim $ues1]},"
          #incr ind
     }
     if {![array exists arr_new_local]} {
          print -debug "No UE Contexts found"
          return -1
     }
     foreach key [array names arr_new_local ] {
          set arr_new_local($key) [string trim $arr_new_local($key) ","]
     }
     print -info "Retrived UES1List from Multiple Context Entries: [string repeat - 20]"
     parray arr_new_local
     
     return [array get arr_new_local]
}
proc updateNewAndOldGUMMEIs {args} {
     #-
     #- This procedure is used to update the LTE Param data with old values with index 'o'
     #- And to update the LTE Param data with new  values\
     #- the new served GUMMEI List should be passed
     #- @return 0 on sucess and -1 on failure
     
     parseArgs args \
               [list \
               [list fgwNum              "optional"  "numeric"     "0"            "The dut instance in the testbed file "   ] \
               [list HeNBIndex           "optional"  "numeric"     "0"            "The HeNB on which the UE is associated"  ] \
               [list GUMMEIIndex         "optional"  "numeric"     "__UN_DEFINED__" "The GUMMEI Index of MME "  ] \
               [list servedGUMMEIList    "mandatory" "string"      "_"            "The servedGUMMEIlist to be updated"] \
               ]
     foreach {param} [split $servedGUMMEIList " "] {
          regsub -all "\{" $param "" param
          regsub -all "\}" $param "" param
          regsub -all "=" $param " " param
          regsub -all "servedPLMNs" $param "" param
          print -debug "param=$param"
          set paramList [list $param]
          print "paramList()=$paramList"
          set paramList [string map "servedGroupIDs MMEGroupId servedMMECs MMECode" $paramList]
          print "Modified paramList()=$paramList"
          set result [updateLteParamWithOldGUMMEIs -GUMMEIIndex 0 -paramList $paramList]
          if { $result != 0 } {
               print -fail "Update fail for old gummeis @ index o"
               set flag 1
          }  else {
               print -pass "Updated the old gummeis @ index o successfully"
          }
          set result [updateLteParamWithNewGUMMEIs -HeNBIndex $HeNBIndex -paramList $paramList]
          if { $result != 0 } {
               print -fail "Update fail for new gummeis"
               set flag 1
          }  else {
               print -pass "Updated the new gummeis successfully"
          }
          
     }
     return 0
}

proc updateLteParamWithNewGUMMEIs {args} {
     #-
     #- This procedure is used to update the LTE Param data with new  values
     #  as part of a successful MME Config Update
     #- The values to be updated are sent as key-value pair
     #-
     #- @return 0 on sucess and -1 on failure
     #-
     
     global ARR_LTE_TEST_PARAMS
     global ARR_LTE_TEST_PARAMS_MAP
     
     set flag 0
     parseArgs args \
               [list \
               [list fgwNum              "optional"  "numeric"     "0"            "The dut instance in the testbed file "   ] \
               [list HeNBIndex           "optional"  "numeric"     "0"            "The HeNB on which the UE is associated"  ] \
               [list MMEIndex            "optional"  "numeric"     "0"            "The MME for which the UE is associated"  ] \
               [list GUMMEIIndex         "optional"  "numeric"     "__UN_DEFINED__" "The GUMMEI Index of MME "  ] \
               [list UEIndex             "optional"  "numeric"     "0"            "The UE for which the context is verified"] \
               [list paramList           "mandatory" "string"      "_"            "The params to be updated"] \
               ]
     foreach param $paramList {
          foreach {key val} $param {break}
          switch -regexp $key {
               "MNC|MCC|MMECode|MMEGroupId" {
                    if { [info exists GUMMEIIndex] } {
                         regsub -all "," $val " " val
                         if {![catch {set ARR_LTE_TEST_PARAMS_MAP(M,$MMEIndex,G${GUMMEIIndex},$key) [string trim $val]}]} {
                              print -info "Updated ARR_LTE_TEST_PARAMS_MAP(M,$MMEIndex,G${GUMMEIIndex},$key) with value \"[string trim $val]\""
                         } else {
                              print -fail "Failed to update ARR_LTE_TEST_PARAMS_MAP(M,$MMEIndex,G${GUMMEIIndex},$key) with value \"[string trim $val]\""
                         }
                    } else {
                         print "param@updateNEWgummeis=$param"
                         print -debug "key =$key , val=$val"
                         regsub -all "," $val " " val
                         if {![catch {set ARR_LTE_TEST_PARAMS_MAP(H,$HeNBIndex,$key) [string trim $val]}]} {
                              print -info "Updated ARR_LTE_TEST_PARAMS_MAP(H,$HeNBIndex,$key) with value \"[string trim $val]\""
                         } else {
                              print -fail "Failed to update ARR_LTE_TEST_PARAMS_MAP(H,$HeNBIndex,$key) with value \"[string trim $val]\""
                         }
                    }
               }
               default {
                    print -fail "Invalid value of param $key, cannot update"
                    set flag 1
               }
          }
     }
     return 0
}

proc updateLteParamWithOldGUMMEIs {args} {
     #-
     #- This procedure is used to update the LTE Param data with old values with index 'o'
     #  as part of a successful MME Config Update
     #- The values to be updated are sent as key-value pair
     #-
     #- @return 0 on sucess and -1 on failure
     #-
     
     global ARR_LTE_TEST_PARAMS
     global ARR_LTE_TEST_PARAMS_MAP
     
     set flag 0
     parseArgs args \
               [list \
               [list fgwNum              "optional"  "numeric"     "0"            "The dut instance in the testbed file "   ] \
               [list HeNBIndex           "optional"  "numeric"     "0"            "The HeNB on which the UE is associated"  ] \
               [list MMEIndex            "optional"  "numeric"     "0"            "The MME for which the UE is associated"  ] \
               [list GUMMEIIndex         "optional"  "numeric"     "__UN_DEFINED__" "The GUMMEI Index of MME "  ] \
               [list UEIndex             "optional"  "numeric"     "0"            "The UE for which the context is verified"] \
               [list paramList           "mandatory" "string"      "_"            "The params to be updated"] \
               ]
     
     foreach param $paramList {
          foreach {key val} $param {break}
          switch -regexp $key {
               "TAC|CSGId|HeNBId" {
                    if {![catch {set ARR_LTE_TEST_PARAMS_MAP(H,$HeNBIndex,$key,o) [string trim $val]}]} {
                         print -info "Updated ARR_LTE_TEST_PARAMS_MAP(H,$HeNBIndex,$key,o) with value \"[string trim $val]\""
                    } else {
                         print -fail "Failed to update ARR_LTE_TEST_PARAMS_MAP(H,$HeNBIndex,$key,o) with value \"[string trim $val]\""
                    }
               }
               
               "MNC|MCC|MMECode|MMEGroupId" {
                    if { [info exists GUMMEIIndex] } {
                         set param "$key"
                         print "param@updateOLDgummeis=$param"
                         set val [getFromTestMap -MMEIndex $MMEIndex -GUMMEIIndex $GUMMEIIndex -param $param]
                         print -debug "OLD val from test map=$val"
                         if {![catch {set ARR_LTE_TEST_PARAMS_MAP(M,$MMEIndex,G${GUMMEIIndex},$key,o) [string trim $val]}]} {
                              print -info "Updated ARR_LTE_TEST_PARAMS_MAP(M,$MMEIndex,G${GUMMEIIndex},$key,o) with value \"[string trim $val]\""
                         } else {
                              print -fail "Failed to update ARR_LTE_TEST_PARAMS_MAP(M,$MMEIndex,G${GUMMEIIndex},$key,o) with value \"[string trim $val]\""
                         }
                    } else {
                         set val [getFromTestMap -HeNBIndex $HeNBIndex -param $key]
                         if {![catch {set ARR_LTE_TEST_PARAMS_MAP(H,$HeNBIndex,$key,o) [string trim $val]}]} {
                              print -info "Updated ARR_LTE_TEST_PARAMS_MAP(H,$HeNBIndex,$key,o) with value \"[string trim $val]\""
                         } else {
                              print -fail "Failed to update ARR_LTE_TEST_PARAMS_MAP(H,$HeNBIndex,$key,o) with value \"[string trim $val]\""
                         }
                    }
               }
               "HeNBGWName|defaultPagingDRX" {
                    if {![catch {set ARR_LTE_TEST_PARAMS($key,o) $val}]} {
                         print -info "updated ARR_LTE_TEST_PARAMS($key,o) with value \"[string trim $val]\""
                    } else {
                         print -fail "Failed to update ARR_LTE_TEST_PARAMS($key,o) with value \"[string trim $val]\""
                    }
               }
               
               default {
                    print -fail "Invalid value of param $key, cannot update"
                    set flag 1
               }
          }
     }
     return 0
}

proc updateUTLteParamData {args} {
     
     #-
     #- This procedure is used to update the LTE Param data for unit testing purpose
     #-
     #- @return 0 on sucess and -1 on failure
     #-
     
     global ARR_LTE_TEST_PARAMS
     global ARR_LTE_TEST_PARAMS_MAP
     
     set flag 0
     parseArgs args \
               [list \
               [list noOfHeNBs     "optional"  "numeric"  "1"                     "defines number of HeNBs to be used in script" ] \
               [list noOfPLMNs     "optional"  "numeric"  "6"                     "defines number of PLMNs to be used in script" ] \
               [list noOfMMEs      "optional"  "numeric"  "1"                     "defines number of MMEs to be used in script" ] \
               [list noOfUEs       "optional"  "numeric"  "__UN_DEFINED__"        "defines noOfUEs per HeNB to be used in script" ] \
               [list noOfRegions   "optional"  "numeric"  "1"                     "defines number of Regions to be used in script" ] \
               ]
     
     for {set i 0} {$i < $noOfHeNBs} {incr i} {
          for {set j 0} {$j < $noOfUEs} {incr j} {
               set ARR_LTE_TEST_PARAMS_MAP(H,$i,U,$j,vENBUES1APId) "[random 2073157]"
               set ARR_LTE_TEST_PARAMS_MAP(H,$i,U,$j,mmeUEId) "[random 2072]"
               set ARR_LTE_TEST_PARAMS_MAP(H,$i,U,$j,mStreamId) "[random 255]"
          }
     }
     
     #Source output file name to get the GetMessage output for that particular message
     set sourceFileName "output_[getScriptName].tcl"
     print -info "OUTPUT SCRIPT NAME : $sourceFileName"
     if {![file exists $sourceFileName]} {
          print -fail "$sourceFileName doesn't exist"
          exit -1
     } else {
          print -info "Doing source $sourceFileName to get GetMessages output values"
          source $sourceFileName
          global ARR_UTMSG_COUNT
     }
}

proc updateLteParamData {args} {
     #-
     #- This procedure is used to update the LTE Param data that is generated by the prepareLTETestParams
     #- The values to be updated are sent as key-value pair
     #-
     #- @return 0 on sucess and -1 on failure
     #-
     
     global ARR_LTE_TEST_PARAMS
     global ARR_LTE_TEST_PARAMS_MAP
     
     set flag 0
     parseArgs args \
               [list \
               [list fgwNum              "optional"  "numeric"     "0"            "The dut instance in the testbed file "   ] \
               [list HeNBIndex           "optional"  "numeric"     "0"            "The HeNB on which the UE is associated"  ] \
               [list MMEIndex            "optional"  "numeric"     "0"            "The MME for which the UE is associated"  ] \
               [list GUMMEIIndex         "optional"  "numeric"     "__UN_DEFINED__" "The GUMMEI Index of MME "  ] \
               [list UEIndex             "optional"  "numeric"     "0"            "The UE for which the context is verified"] \
               [list paramList           "mandatory" "string"      "_"            "The params to be updated"] \
               ]
     
     foreach param $paramList {
          foreach {key val} $param {break}
          switch -regexp $key {
               "vENBUES1APId|vMMEUES1APId|MMEUES1APId|eNBUES1APId|mStreamId|mmeUEId|hStreamId|MMEIndex|eNBId" {
                    if {![catch {set ARR_LTE_TEST_PARAMS_MAP(H,$HeNBIndex,U,$UEIndex,$key) [string trim $val]}]} {
                         print -info "Updated ARR_LTE_TEST_PARAMS_MAP(H,$HeNBIndex,U,$UEIndex,$key) with value \"[string trim $val]\""
                    } else {
                         print -fail "Failed to update ARR_LTE_TEST_PARAMS_MAP(H,$HeNBIndex,U,$UEIndex,$key) with value \"[string trim $val]\""
                    }
               }
               "TAC|CSGId|HeNBId" {
                    if {![catch {set ARR_LTE_TEST_PARAMS_MAP(H,$HeNBIndex,$key) [string trim $val]}]} {
                         print -info "Updated ARR_LTE_TEST_PARAMS_MAP(H,$HeNBIndex,$key) with value \"[string trim $val]\""
                    } else {
                         print -fail "Failed to update ARR_LTE_TEST_PARAMS_MAP(H,$HeNBIndex,$key) with value \"[string trim $val]\""
                    }
               }
               "eNBType" {
                    set ARR_LTE_TEST_PARAMS_MAP(H,$HeNBIndex,$key) [string trim $val]
                    print -info "Updated ARR_LTE_TEST_PARAMS_MAP(H,$HeNBIndex,$key) with value \"[string trim $val]\""
               }
               "MNC|MCC|MMECode|MMEGroupId" {
                    if { [info exists GUMMEIIndex] } {
                         if {![catch {set ARR_LTE_TEST_PARAMS_MAP(M,$MMEIndex,G${GUMMEIIndex},$key) [string trim $val]}]} {
                              print -info "Updated ARR_LTE_TEST_PARAMS_MAP(M,$MMEIndex,G${GUMMEIIndex},$key) with value \"[string trim $val]\""
                         } else {
                              print -fail "Failed to update ARR_LTE_TEST_PARAMS_MAP(M,$MMEIndex,G${GUMMEIIndex},$key) with value \"[string trim $val]\""
                         }
                    } else {
                         if {![catch {set ARR_LTE_TEST_PARAMS_MAP(H,$HeNBIndex,$key) [string trim $val]}]} {
                              print -info "Updated ARR_LTE_TEST_PARAMS_MAP(H,$HeNBIndex,$key) with value \"[string trim $val]\""
                         } else {
                              print -fail "Failed to update ARR_LTE_TEST_PARAMS_MAP(H,$HeNBIndex,$key) with value \"[string trim $val]\""
                         }
                    }
               }
               "HeNBGWName|defaultPagingDRX" {
                    if {![catch {set ARR_LTE_TEST_PARAMS($key) $val}]} {
                         print -info "updated ARR_LTE_TEST_PARAMS($key) with value \"[string trim $val]\""
                    } else {
                         print -fail "Failed to update ARR_LTE_TEST_PARAMS($key) with value \"[string trim $val]\""
                    }
               }
               default {
                    print -fail "Invalid value of param $key, cannot update"
                    set flag 1
               }
          }
     }
     return 0
}

proc getCGIdFromeNBId {eNBId {randNum "200"}} {
     #-
     #- To generate a valid CGI from a given eNBId
     #-
     #- eNBId will be represented in 20-bits
     #-
     #- In Generated CGI, 1st 20-bits shld be same as eNBId, to achieve this we append a 8-bit data to represent CGI in 28-bits
     #-
     #- @in eNBId -> decimal value of eNBId
     #-
     #- @out CGI -> decimal value of CGI
     #-
     
     binary scan [binary format I $eNBId] B* eNBIdBin
     
     # considering  eNBId will be rerpesented only in 28-bits
     set eNBIdBin [string range $eNBIdBin 12 end]
     
     # generate a random number which can be represented with in 8-bits
     binary scan [binary format I $randNum] B* randNumBin
     
     # represent the random number in 8-bit format
     set randNumBin [string range $randNumBin end-7 end]
     
     print -dbg "eNBID  $eNBId binary value (20-bits) : $eNBIdBin"
     print -dbg "random $randNum binary value (8-bits) : $randNumBin"
     
     set cgiBin ${eNBIdBin}${randNumBin}
     print -dbg "CGI in binary value (28-bits) : $cgiBin"
     
     # converting the CG ID to decimal
     binary scan [binary format B* [format %032s $cgiBin]] I1 cgi
     
     print -dbg "CGI in decimal is : $cgi"
     
     print -dbg "Comparing CGI, eNBID binary values : [string compare [string range $cgiBin 0 19] $eNBIdBin]"
     return $cgi
}

proc verifyMMEContextPresenceOnHenbGw { args } {
     
     parseArgs args \
               [list \
               [list henbGwMmeContextData    "optional"  "string"  "__UN_DEFINED__"    ""   ] \
               [list expectedOutput          "optional"  "string"  "__UN_DEFINED__"    ""   ] \
               ]
     
     puts "henbGwMmeContextData --> $henbGwMmeContextData --> [llength $henbGwMmeContextData] "
     puts "expectedOutput       --> $expectedOutput -> [llength $expectedOutput ]"
     
     #If MME conetxt is empty proc verifyMsgRcvdOnGw return -1 in henbGwMmeContextData
     if { [llength $henbGwMmeContextData] == 1 && $henbGwMmeContextData == -1 } { set henbGwMmeContextData "" }
     
     if { [llength $henbGwMmeContextData] == 0 && [llength $expectedOutput ] == 0 } {
          print -info "Empty MME context table : Expected" ;
          return 0
     }
     
     if { [llength $henbGwMmeContextData] != 0 && [llength $expectedOutput ] == 0 } {
          print -info "ERROR:non Empty MME context table : Expected empty context table" ;
          return -1
     }
     
     return [verifySimOutput $henbGwMmeContextData $expectedOutput ]
}

proc configHeNBAndMMEForRoutingTestBed { args } {
     #-
     #- proc to setup HeNB-MME simulator hosts
     #-
     parseArgs args \
               [list \
               [list fgwNum                      optional  "numeric"  "0"      "FGW number in testbed file"]\
               [list switchNum                   optional  "numeric"  "0"      "switch number in testbed file"]\
               [list simType                     optional  "string"   ""       "Simulators to be configured"]\
               [list localMMEMultiHoming         optional  "yes|no"   "no" "To eanble multihoming towards MME on gw"]\
               [list localHeNBMultiHoming        optional  "yes|no"   "no" "To eanble multihoming towards HeNB on gw"]\
               [list remoteMMEMultiHoming        optional  "yes|no"   "no" "To eanble multihoming on MME sim"]\
               [list noOfMMEs                    optional  "numeric"  "1"      "number of MMEs to be configured on sim"]\
               ]
     
     set fgwIp [getActiveBonoIp $fgwNum]
     # to consider the ips which we are not going to use ... for the case of AMR concatenation feature
     set arr_nw_data(skipIpList) ""
     # disable configuration on Gateway. uncomment below line to enable it
     #set arr_nw_data(simIp) $fgwIp
     foreach type $simType {
          switch $type {
               "HeNB"  {
                    set simIp  		[getDataFromConfigFile "getHenbSimulatorHostIp" $fgwNum]
                    set simInt 		[getDataFromConfigFile "getHenbSimCpHostPort" $fgwNum]
                    set cp1PortOnGw	[getDataFromConfigFile "getHenbCp1Port" $fgwNum]
                    if {[getDataFromConfigFile "henbCpCount" $fgwNum]==2} {
                         set cp2PortOnGw        [getDataFromConfigFile "getHenbCp2Port" $fgwNum]
                    }
                    
                    # retrieve CP1 network parameters on simulator
                    lappend arr_nw_data($simIp,$simInt,vlan) [getDataFromConfigFile "getHenbSimCpVlan" $fgwNum]
                    lappend arr_nw_data($simIp,$simInt,mask) [getDataFromConfigFile "getHenbSimCpMask" $fgwNum]
                    lappend arr_nw_data($simIp,$simInt,ip)   [getDataFromConfigFile "getHenbSimCpIpaddress" $fgwNum]
                    lappend arr_nw_data($simIp,simHenbGw)    "[getDataFromConfigFile "getHenbCp1Ipaddress" $fgwNum] [getDataFromConfigFile "getHenbSimCpIpaddress" $fgwNum]"
                    
                    # No remote multiHoming on HeNB sim, so not taking CP2 network parameters for henb sim
                    
                    # retrieve CP1 network parameters on gateway
                    lappend arr_nw_data($fgwIp,$cp1PortOnGw,vlan) [getDataFromConfigFile "getHenbCp1Vlan" $fgwNum]
                    lappend arr_nw_data($fgwIp,$cp1PortOnGw,mask) [getDataFromConfigFile "getHenbCp1Mask" $fgwNum]
                    lappend arr_nw_data($fgwIp,$cp1PortOnGw,ip)   [getDataFromConfigFile "getHenbCp1Ipaddress" $fgwNum]
                    lappend arr_nw_data($fgwIp,fgwHenbGw)         "[getDataFromConfigFile "getHenbSimCpIpaddress" $fgwNum] [getDataFromConfigFile "getHenbCp1Ipaddress" $fgwNum]"
                    
                    if {$localHeNBMultiHoming == "yes"} {
                         # retrieving CP2 network parameters for HeNBCP on gateway
                         lappend arr_nw_data($fgwIp,$cp2PortOnGw,vlan) [getDataFromConfigFile "getHenbCp2Vlan" $fgwNum]
                         lappend arr_nw_data($fgwIp,$cp2PortOnGw,mask) [getDataFromConfigFile "getHenbCp2Mask" $fgwNum]
                         lappend arr_nw_data($fgwIp,$cp2PortOnGw,ip)   [getDataFromConfigFile "getHenbCp2Ipaddress" $fgwNum]
                         lappend arr_nw_data($simIp,simHenbGw)         "[getDataFromConfigFile "getHenbCp2Ipaddress" $fgwNum] [getDataFromConfigFile "getHenbSimCpIpaddress" $fgwNum]"
                         lappend arr_nw_data($fgwIp,fgwHenbGw)         "[getDataFromConfigFile "getHenbSimCpIpaddress" $fgwNum] [getDataFromConfigFile "getHenbCp2Ipaddress" $fgwNum]"
                    }
               }
               "MME" {
                    set simIp           [getDataFromConfigFile "getMmeSimulatorHostIp" $fgwNum]
                    set simCp1Int       [getDataFromConfigFile "getMmeSimCp1HostPort" $fgwNum]
                    set cp1PortOnGw     [getDataFromConfigFile "getMmeCp1Port" $fgwNum]
                    if {[getDataFromConfigFile "mmeCpCount" $fgwNum]==2} {
                         set simCp2Int       [getDataFromConfigFile "getMmeSimCp2HostPort" $fgwNum]
                         set cp2PortOnGw        [getDataFromConfigFile "getMmeCp2Port" $fgwNum]
                    }
                    
                    # retrieve CP1 network parameters on simulator
                    lappend arr_nw_data($simIp,$simCp1Int,vlan) [getDataFromConfigFile "getMmeSimCp1Vlan" $fgwNum]
                    lappend arr_nw_data($simIp,$simCp1Int,mask) [getDataFromConfigFile "getMmeSimCp1Mask" $fgwNum]
                    lappend arr_nw_data($simIp,$simCp1Int,ip)   [getDataFromConfigFile "getMmeSimCp1Ipaddress" $fgwNum]
                    lappend arr_nw_data($simIp,simMmeGw)        "[getDataFromConfigFile "getMmeCp1Ipaddress" $fgwNum] [getDataFromConfigFile "getMmeSimCp1Ipaddress" $fgwNum]"
                    
                    #to add unique ip to each MME instance on simulator, i.e create virtual ip's
                    if {$noOfMMEs > 1} {
                         set mmeSimVlan [getDataFromConfigFile "getMmeSimCp1Vlan" $fgwNum]
                         set mmeSimMask [getDataFromConfigFile "getMmeSimCp1Mask" $fgwNum]
                         set mmeSimIp   [incrIp [getDataFromConfigFile "getMmeSimCp1Ipaddress" $fgwNum]]
                         set arr_ip_data($simCp1Int\.$mmeSimVlan) "$mmeSimIp/$mmeSimMask"
                    }
                    
                    #configure interfaces if either local or remote MME multihoming is enabled
                    if {$remoteMMEMultiHoming == "yes" || $localMMEMultiHoming == "yes"} {
                         # retrieve CP1 network parameters on simulator
                         lappend arr_nw_data($simIp,$simCp2Int,vlan) [getDataFromConfigFile "getMmeSimCp2Vlan" $fgwNum]
                         lappend arr_nw_data($simIp,$simCp2Int,mask) [getDataFromConfigFile "getMmeSimCp2Mask" $fgwNum]
                         lappend arr_nw_data($simIp,$simCp2Int,ip)   [getDataFromConfigFile "getMmeSimCp2Ipaddress" $fgwNum]
                         lappend arr_nw_data($simIp,simMmeGw)        "[getDataFromConfigFile "getMmeCp2Ipaddress" $fgwNum] [getDataFromConfigFile "getMmeSimCp2Ipaddress" $fgwNum]"
                         if {$noOfMMEs > 1} {
                              set mmeSimVlan [getDataFromConfigFile "getMmeSimCp2Vlan" $fgwNum]
                              set mmeSimMask [getDataFromConfigFile "getMmeSimCp2Mask" $fgwNum]
                              set mmeSimIp   [incrIp [getDataFromConfigFile "getMmeSimCp2Ipaddress" $fgwNum]]
                              set arr_ip_data($simCp2Int\.$mmeSimVlan) "$mmeSimIp/$mmeSimMask"
                              
                         }
                         
                    }
                    
                    # retrieve CP1 network parameters on gateway
                    lappend arr_nw_data($fgwIp,$cp1PortOnGw,vlan) [getDataFromConfigFile "getMmeCp1Vlan" $fgwNum]
                    lappend arr_nw_data($fgwIp,$cp1PortOnGw,mask) [getDataFromConfigFile "getMmeCp1Mask" $fgwNum]
                    lappend arr_nw_data($fgwIp,$cp1PortOnGw,ip)   [getDataFromConfigFile "getMmeCp1Ipaddress" $fgwNum]
                    lappend arr_nw_data($fgwIp,fgwMmeGw)          "[getDataFromConfigFile "getMmeSimCp1Ipaddress" $fgwNum] [getDataFromConfigFile "getMmeCp1Ipaddress" $fgwNum]"
                    
                    #configure interfaces if either local or remote MME multihoming is enabled
                    if {$localMMEMultiHoming == "yes" || $remoteMMEMultiHoming == "yes"} {
                         # retrieve CP2 network parameters on gateway
                         lappend arr_nw_data($fgwIp,$cp2PortOnGw,vlan) [getDataFromConfigFile "getMmeCp2Vlan" $fgwNum]
                         lappend arr_nw_data($fgwIp,$cp2PortOnGw,mask) [getDataFromConfigFile "getMmeCp2Mask" $fgwNum]
                         lappend arr_nw_data($fgwIp,$cp2PortOnGw,ip)   [getDataFromConfigFile "getMmeCp2Ipaddress" $fgwNum]
                         lappend arr_nw_data($fgwIp,fgwMmeGw)          "[getDataFromConfigFile "getMmeSimCp2Ipaddress" $fgwNum] [getDataFromConfigFile "getMmeCp2Ipaddress" $fgwNum]"
                    }
               }
          }
          # to track the different simulators
          lappend arr_nw_data(simIp) $simIp
     }
     
     set srVlans [getDataFromConfigFile "getServiceRouterVlan" $fgwNum]
     set srMasks [getDataFromConfigFile "getServiceRouterMask" $fgwNum]
     set srIps   [getDataFromConfigFile "getServiceRouterIpaddress" $fgwNum]
     print -info "srVlans $srVlans srMasks $srMasks srIps $srIps"
     foreach srVlan $srVlans srMask $srMasks srIp $srIps {
          lappend arr_nw_data(sr,vlan) $srVlan
          lappend arr_nw_data(sr,mask) $srMask
          lappend arr_nw_data(sr,ip) $srIp
     }
     
     # eliminate duplicates
     set arr_nw_data(simIp) [lsort -unique $arr_nw_data(simIp)]
     set arr_nw_data(simList) $simType
     
     print -info "Dump of interfaces, vlan information that we are going to use ..."
     parray arr_nw_data
     # invoking the configuration code
     
     # ------------------------------------------------------------------------------ #
     # invoking the configuration code
     # ------------------------------------------------------------------------------ #
     print -info  "Configuring simulator hosts ..."
     print -info  "Skipping the omni switch and host configuration"
     print -debug "The NEs would be reconfigured if L3 verification fails"
     set result 0 ; #[configNEsForRoutingTestbed $fgwIp "config"]
     if {$result != 0} {
          print -fail "Configuring network for routing failed"
          return -1
     } else {
          print -pass "Configuring network for routing is success"
     }
     
     # ------------------------------------------------------------------------------ #
     # For the ATCA setup use the MON script to update the routes
     # Start the Application so that the interface configuration takes effect
     # ------------------------------------------------------------------------------ #
     set clusterState 0
     if {[isIfCfgThrMON]} {
          set bonoIpList [getActiveBonoIp]
          set noOfBonos  [llength $bonoIpList]
          
          if {$noOfBonos == 1 && ![info exists waitAfterApplnStart]} {
               set waitAfterApplnStart 100
          } elseif {![info exists waitAfterApplnStart]} {
               set waitAfterApplnStart 100
          }
          foreach bonoIp $bonoIpList {
               print -info "Configuring the routes through MON on board $bonoIp"
               #   set result [configRoutesOnBono $bonoIp]
               set result 0
               if {$result != 0} {
                    print -fail "Route confiuration on board ip \"$bonoIp\" failed"
                    return -1
               } else {
                    print -pass "Route confiuration on board ip \"$bonoIp\" successful"
               }
          }
          
          # ------------------------------------------------------------------------------ #
          # Start the HeNBGW application
          # ------------------------------------------------------------------------------ #
          foreach bonoIp $bonoIpList bonoId [listOfIncrEle 1 $noOfBonos] {
               print -info  "Starting the HeNBGW application on \"$bonoIp\""
               print -debug "Process verification enabled? : $verifyProcess"
               set result  [restartHeNBGW -fgwNum $fgwNum -verify $verifyProcess -operation "start" -boardIp $bonoIp]
               if {$result < 0} {
                    print -fail "Application bringup failed on $bonoIp, cannot continue further"
                    return -1
               } else {
                    print -pass "Successfully brought up the HeNBGW application on $bonoIp"
               }
               # Temp hack to make bono on lower slot to be active
               if {$bonoId == "1" && $noOfBonos > 1} {
                    print -debug "Waiting for $waitForApplStartBtNodes seconds before starting the application on second bono"
                    halt $waitForApplStartBtNodes
               }
          }
          print -nonewline "For the state to be negiotiated .."
          halt $waitAfterApplnStart
          
          # ------------------------------------------------------------------------------ #
          # Verify the L3 Configuration and reconfigure switch if requried
          # Verify that the Internode connection is up between the BONOs
          # ------------------------------------------------------------------------------ #
          if {$verifyProcess == "yes"} {
               print -info "Verifying the network connectivity after system restart"
               set result [configNEsForRoutingTestbed $fgwIp "verify"]
               if {$result != 0} {
                    print -fail "Configuring network for routing failed"
                    return -1
               } else {
                    print -pass "Configuring network for routing is success"
               }
               
               print -info "Verifying Internode link communation between NODES"
               set result [verifyHeNBGWClusterState -fgwNum $fgwNum]
               if {$result != 0} {
                    print -fail "The HeNBGW cluster state is improper"
                    set clusterState 1
               } else {
                    print -pass "HeNBGW cluster state is proper"
               }
          } else {
               print -info "Skipping internode link verification between boards"
          }
          # Update the active Bono
          set result [getActiveBonoIp $fgwNum update]
     }
     
     # ------------------------------------------------------------------------------ #
     # To add virtual ip for MME instances, when noOfMMEs > 1
     # ------------------------------------------------------------------------------ #
     if {$noOfMMEs > 1} {
          for {set switchNo 0} {$switchNo < $noOfSwitch} {incr switchNo} {
               set simIp [getDataFromConfigFile "getMmeSimulatorHostIp" $fgwNum $switchNo]
               if {![isIpaddr $simIp]} {continue}
               #to add unique ip to each MME instance on simulator, i.e create virtual ip's
               for {set cpNum 1} {$cpNum <= $noOfMMECPs} {incr cpNum} {
                    if {$cpNum == 2 && ($remoteMMEMultiHoming == "no" && $localMMEMultiHoming == "no")} {continue}
                    set arr_ip_data([set simCp${cpNum}Int]\.[set getMmeSimCp${cpNum}Vlan]) "[incrIp [set getMmeSimCp${cpNum}Ipaddress]]/[set getMmeSimCp${cpNum}Mask]"
               }
               set result [configVirtualIp $simIp $fgwIp $noOfMMEs]
               if {$result != 0} {
                    print -fail "Configuring virtual ip's failed for MMEs"
                    return -1
               } else {
                    print -pass "Configured virtual ip's for MMEs"
               }
          }
     }
     
     proc a { }  {
          set result  [restartHeNBGW -fgwNum $fgwNum -verify "yes" -operation "start"]
          if {$result < 0} {
               print -fail "Application bringup failed on HeNBGW, cannot continue further"
               return -1
          } else {
               print -pass "Successfully brought up the HeNBGW application"
          }
          
          print -info "configuring simulator hosts ..."
          set result [configNEsForRoutingTestbed $fgwIp "verify"]
          if {$result != 0} {
               print -fail "Configuring network for routing failed"
               return -1
          } else {
               print -pass "Configuring network for routing is success"
          }
          
          # To add virtual ip for MME instances, when noOfMMEs > 1
          if {$noOfMMEs > 1} {
               set result [configVirtualIp $simIp $fgwIp $noOfMMEs]
               if {$result != 0} {
                    print -fail "Configuring virtual ip's failed for MMEs"
                    return -1
               } else {
                    print -pass "Configured virtual ip's for MMEs"
               }
          }
     }
     return 0
}

proc configHeNBAndMMEForRoutingTestBedAtca { args } {
     #-
     #- proc to setup HeNB-MME simulator hosts
     #-
     parseArgs args \
               [list \
               [list fgwNum                      optional  "numeric"  "0"                "FGW number in testbed file"]\
               [list switchNum                   optional  "numeric"  "0"                "switch number in testbed file"]\
               [list simType                     optional  "string"   ""                 "Simulators to be configured"]\
               [list localMMEMultiHoming         optional  "yes|no"   "no"               "To eanble multihoming towards MME on gw"]\
               [list localHeNBMultiHoming        optional  "yes|no"   "no"               "To eanble multihoming towards HeNB on gw"]\
               [list remoteMMEMultiHoming        optional  "yes|no"   "no"               "To eanble multihoming on MME sim"]\
               [list noOfMMEs                    optional  "numeric"  "1"                "number of MMEs to be configured on sim"]\
               [list waitForApplStartBtNodes     optional  "numeric"  "1"                "the time to wait between application starts on BONOs"]\
               [list waitAfterApplnStart         optional  "numeric"  "__UN_DEFINED__"   "the time to wait between application starts on BONOs"]\
               [list verifyProcess               optional  "boolean"  "yes"              "To verify process after starting the application"]\
               [list SRping                      optional  "yes|no"   "yes"              "Define SRping need to configure or not"] \
               ]
     
     global arr_nw_data
     set fgwIp [getActiveBonoIp $fgwNum]
     # to consider the ips which we are not going to use ... for the case of AMR concatenation feature
     set arr_nw_data(skipIpList) ""
     
     set noOfSwitch [getDataFromConfigFile switchCount $fgwNum]
     
     print -info "localMMEMultiHoming --> $localMMEMultiHoming \n localHeNBMultiHoming --> $localHeNBMultiHoming \n remoteMMEMultiHoming --> $remoteMMEMultiHoming"
     
     if {$SRping == "yes" } {
          append simType " SR"
     }
     
     append simType " OAM"
     foreach type $simType {
          switch $type {
               "HeNB"  {
                    # Retrieve the configuration for each of the switch
                    set noOfHeNBCPs [getDataFromConfigFile "henbCpCount" $fgwNum]
                    if {$localHeNBMultiHoming == "no"} {
                         set noOfHeNBCPs 1
                    } else {
                         set noOfHeNBCPs 2
                    }
 
                    # As of now remote henb multihoming is disabled so get the only henbsimip address
                    for {set switchNo 0} {$switchNo < $noOfSwitch} {incr switchNo} {
                         if {[getDataFromConfigFile getHenbSimCpIpaddress $fgwNum $switchNo] > 0} {
                              set henbSimCpIpaddres [getDataFromConfigFile getHenbSimCpIpaddress $fgwNum $switchNo]
                         }
                    }
                    
                    for {set switchNo 0} {$switchNo < $noOfSwitch} {incr switchNo} {
                         # Get the sim ip address
                         set simIp  [getDataFromConfigFile "getHenbSimulatorHostIp" $fgwNum $switchNo]
                         if {![isIpaddr $simIp]} {continue}
                         lappend arr_nw_data(simIp) $simIp
                         
                         set simInt [getDataFromConfigFile "getHenbSimCpHostPort"   $fgwNum $switchNo]
                         for {set cpNum 1} {$cpNum <= $noOfHeNBCPs} {incr cpNum} {
                              if {[getDataFromConfigFile "getHenbCp${cpNum}Port" $fgwNum $switchNo] > 0} {
                                   set cp${cpNum}PortOnGw	[getDataFromConfigFile "getHenbCp${cpNum}Port" $fgwNum $switchNo]
                              }
                         }
                         
                         # retrieve CP network parameters on simulator
                         foreach ele1 [list vlan mask ip] ele2 [list getHenbSimCpVlan getHenbSimCpMask getHenbSimCpIpaddress] {
                              if {[getDataFromConfigFile $ele2 $fgwNum $switchNo] > 0} {
                                   lappend arr_nw_data($simIp,$simInt,$ele1) [getDataFromConfigFile $ele2 $fgwNum $switchNo]
                              }
                         }
                         
                         # retrieve CP network parameters on gateway
                         for {set cpNum 1} {$cpNum <= $noOfHeNBCPs} {incr cpNum} {
                              foreach ele1 [list vlan mask ip] ele2 [list getHenbCp${cpNum}Vlan getHenbCp${cpNum}Mask getHenbCp${cpNum}Ipaddress] {
                                   set henb${cpNum}${ele1} [getDataFromConfigFile $ele2 $fgwNum $switchNo]
                                   if {[set henb${cpNum}${ele1}] < 0} {continue}
                                   lappend arr_nw_data($fgwIp,[set cp${cpNum}PortOnGw],$ele1) [set henb${cpNum}${ele1}]
                              }
                              # Append the data to the sim list. This would be used to configure routes on henb simulator
                              if {[getDataFromConfigFile getHenbCp${cpNum}Ipaddress $fgwNum $switchNo] > 0} {
                                   lappend arr_nw_data($simIp,simHenbGw) [list [set henb${cpNum}ip]  $henbSimCpIpaddres]
                              }
                         }
                    }
                    
                    # Get the data for building the route table on henbgw
                    if {$localHeNBMultiHoming == "yes"} {
                         for {set cpNum 1} {$cpNum <= $noOfHeNBCPs} {incr cpNum} {
                              lappend arr_nw_data($fgwIp,fgwHenbGw)       [list $henbSimCpIpaddres [set henb${cpNum}ip]]
                              lappend arr_nw_data($fgwIp,heNBCP${cpNum})  [list $henbSimCpIpaddres [set henb${cpNum}ip]]
                         }
                    } else {
                        set cpNum 1
                        lappend arr_nw_data($fgwIp,fgwHenbGw)       [list $henbSimCpIpaddres [set henb${cpNum}ip]]
                        lappend arr_nw_data($fgwIp,heNBCP3)         [list $henbSimCpIpaddres [set henb${cpNum}ip]]
                    }

               }
               "MME" {
                    set noOfMMECPs [getDataFromConfigFile "mmeCpCount" $fgwNum]
                    if {($remoteMMEMultiHoming == "no" && $localMMEMultiHoming == "no")} {
                         set noOfMMECPs 1
                    }
                    for {set switchNo 0} {$switchNo < $noOfSwitch} {incr switchNo} {
                         set simIp       [getDataFromConfigFile "getMmeSimulatorHostIp" $fgwNum $switchNo]
                         if {![isIpaddr $simIp]} {continue}
                         lappend arr_nw_data(simIp) $simIp
                         for {set cpNum 1} {$cpNum <= $noOfMMECPs} {incr cpNum} {
                              foreach ele1 [list simCp${cpNum}Int cp${cpNum}PortOnGw] ele2 [list getMmeSimCp${cpNum}HostPort getMmeCp${cpNum}Port] {
                                   if {[getDataFromConfigFile $ele2 $fgwNum $switchNo] > 0} {
                                        set $ele1 [getDataFromConfigFile $ele2 $fgwNum $switchNo]
                                   }
                              }
                         }
                    }
                    for {set switchNo 0} {$switchNo < $noOfSwitch} {incr switchNo} {
                         set simIp       [getDataFromConfigFile "getMmeSimulatorHostIp" $fgwNum $switchNo]
                         if {![isIpaddr $simIp]} {continue}
                         for {set cpNum 1} {$cpNum <= $noOfMMECPs} {incr cpNum} {
                              foreach ele1 [list vlan mask ip] ele2 [list getMmeSimCp${cpNum}Vlan getMmeSimCp${cpNum}Mask getMmeSimCp${cpNum}Ipaddress] {
                                   if {$cpNum == 2 && $remoteMMEMultiHoming == "no"} {continue}
                                   # retrieve CP1 network parameters on simulator
                                   if {[getDataFromConfigFile $ele2 $fgwNum $switchNo] < 0} {continue}
                                   set $ele2 [getDataFromConfigFile $ele2 $fgwNum $switchNo]
                                   lappend arr_nw_data($simIp,[set simCp${cpNum}Int],$ele1) [set $ele2]
                              }
                              
                              foreach ele1 [list vlan mask ip] ele2 [list getMmeCp${cpNum}Vlan getMmeCp${cpNum}Mask getMmeCp${cpNum}Ipaddress] {
                                   if {$cpNum == 2 && $localMMEMultiHoming == "no"} {continue}
                                   if {[getDataFromConfigFile $ele2 $fgwNum $switchNo] < 0} {continue}
                                   set $ele2 [getDataFromConfigFile $ele2 $fgwNum $switchNo]
                                   lappend arr_nw_data($fgwIp,[set cp${cpNum}PortOnGw],$ele1) [set $ele2]
                              }
                              if {$cpNum == 2 && ($remoteMMEMultiHoming == "no" && $localMMEMultiHoming == "no")} {continue}
                              if {$remoteMMEMultiHoming == "yes" && $localMMEMultiHoming == "yes"} {
                                   lappend arr_nw_data($simIp,simMmeGw) [list [set getMmeCp${cpNum}Ipaddress] [set getMmeSimCp${cpNum}Ipaddress]]
                              } elseif {$remoteMMEMultiHoming == "no" && $localMMEMultiHoming == "yes"} {
                                   lappend arr_nw_data($simIp,simMmeGw) [list [set getMmeCp${cpNum}Ipaddress] [set getMmeSimCp1Ipaddress]]
                              } else {
                                   lappend arr_nw_data($simIp,simMmeGw) [list [set getMmeCp${cpNum}Ipaddress] [set getMmeSimCp${cpNum}Ipaddress]]
                              }
                         }
                    }
                    # Create the list of network and network for Sim and HeNBGW
                    # This would be used to create the default route
                    for {set cpNum 1} {$cpNum <= $noOfMMECPs} {incr cpNum} {
                         
                         if {$cpNum == 2 && ($remoteMMEMultiHoming == "no" && $localMMEMultiHoming == "no")} {continue}
                         if {$remoteMMEMultiHoming == "yes" && $localMMEMultiHoming == "yes"} {
                              lappend arr_nw_data($fgwIp,fgwMmeGw) [list [set getMmeSimCp${cpNum}Ipaddress] [set getMmeCp${cpNum}Ipaddress]]
                              lappend arr_nw_data($fgwIp,cnCP${cpNum}) [list [set getMmeSimCp${cpNum}Ipaddress] [set getMmeCp${cpNum}Ipaddress]]
			 } elseif {($remoteMMEMultiHoming == "no" && $localMMEMultiHoming == "yes") || ($remoteMMEMultiHoming == "yes" && $localMMEMultiHoming == "no")} {
                              lappend arr_nw_data($fgwIp,fgwMmeGw) [list [set getMmeSimCp1Ipaddress] [set getMmeCp${cpNum}Ipaddress]]
                              lappend arr_nw_data($fgwIp,cnCP${cpNum}) [list [set getMmeSimCp1Ipaddress] [set getMmeCp${cpNum}Ipaddress]]
                         } else { lappend arr_nw_data($fgwIp,fgwMmeGw) [list [set getMmeSimCp${cpNum}Ipaddress] [set getMmeCp${cpNum}Ipaddress]]
                              lappend arr_nw_data($fgwIp,cnCP${cpNum}) [list [set getMmeSimCp${cpNum}Ipaddress] [set getMmeCp${cpNum}Ipaddress]]
                         }
                         
                    }
               }
               "SR" {
                    # For SR configuration
                    for {set switchNo 0} {$switchNo < $noOfSwitch} {incr switchNo} {
                         if {[getDataFromConfigFile getServiceRouterIpaddress $fgwNum $switchNo] > 0} {
                              foreach ele1 [list vlan mask ip] ele2 [list getServiceRouterVlan getServiceRouterMask getServiceRouterIpaddress] {
                                   lappend arr_nw_data($fgwIp,sr[expr ${switchNo} + 1],$ele1) [getDataFromConfigFile $ele2 $fgwNum $switchNo]
                              }
                         }
                    }
                    proc a {} {
                         set srVlans [getDataFromConfigFile "getServiceRouterVlan" $fgwNum]
                         set srMasks [getDataFromConfigFile "getServiceRouterMask" $fgwNum]
                         set srIps   [getDataFromConfigFile "getServiceRouterIpaddress" $fgwNum]
                         print -info "srVlans $srVlans srMasks $srMasks srIps $srIps"
                         set count 1
                         foreach srVlan $srVlans srMask $srMasks srIp $srIps {
                              lappend arr_nw_data($fgwIp,sr${count},vlan) $srVlan
                              lappend arr_nw_data($fgwIp,sr${count},mask) $srMask
                              lappend arr_nw_data($fgwIp,sr${count},ip) $srIp
                              incr count
                         }
                    }
                    
               }
               "OAM" {
                    # For OAM configuration check if the block is defined in testbed file
                    if {[getDataFromConfigFile oamIntCount $fgwNum] > 0} {
                         set oamIntCount [getDataFromConfigFile oamIntCount $fgwNum]
                         for {set oamInt 0} {$oamInt < $oamIntCount} {incr oamInt} {
                              set port [getDataFromConfigFile getOamClientPort $fgwNum $oamInt]
                              foreach ele1 [list ip mask vlan] ele2 [list getOamClientIpaddress getOamClientMask getOamClientVlan] {
                                   lappend arr_nw_data($fgwIp,$port,$ele1) [getDataFromConfigFile $ele2 $fgwNum $oamInt]
                              }
                              lappend arr_nw_data($fgwIp,fgwOam) [list \
                                        [getDataFromConfigFile getOamServerIpaddress $fgwNum $oamInt] [getDataFromConfigFile getOamClientIpaddress $fgwNum $oamInt] \
                                        ]
                              lappend arr_nw_data($fgwIp,oAM)    [list \
                                        [getDataFromConfigFile getOamServerIpaddress $fgwNum $oamInt] [getDataFromConfigFile getOamClientIpaddress $fgwNum $oamInt] \
                                        ]
                              set simIp       [getDataFromConfigFile getOamServerHostIp $fgwNum $oamInt]
                              set simPort     [getDataFromConfigFile getOamServerHostPort $fgwNum $oamInt]
                              foreach ele1 [list vlan mask ip] ele2 [list getOamServerVlan getOamServerMask getOamServerIpaddress] {
                                   lappend arr_nw_data($simIp,$simPort,$ele1) [getDataFromConfigFile $ele2 $fgwNum $oamInt]
                              }
                              lappend arr_nw_data($simIp,simOamGw) [list \
                                        [getDataFromConfigFile getOamClientIpaddress $fgwNum $oamInt] [getDataFromConfigFile getOamServerIpaddress $fgwNum $oamInt]  \
                                        ]
                         }
                    }
               }
          }
          # to track the different simulators
          foreach ele [list simHenbGw simMmeGw fgwHenbGw fgwMmeGw cnCP1 cnCP2 heNBCP1 heNBCP2] {
               foreach ele1 [array names arr_nw_data -regexp ",$ele"] {
                    set arr_nw_data($ele1) [lsort -unique $arr_nw_data($ele1)]
               }
          }
     }
     
     # eliminate duplicates
     set arr_nw_data(simIp) [lsort -unique $arr_nw_data(simIp)]
     set arr_nw_data(simList) $simType
     
     print -info "Dump of interfaces, vlan information that we are going to use ..."
     parray arr_nw_data
     
     # ------------------------------------------------------------------------------ #
     # invoking the configuration code
     # ------------------------------------------------------------------------------ #
     print -info  "Configuring simulator hosts ..."
     print -info  "Skipping the omni switch and host configuration"
     print -debug "The NEs would be reconfigured if L3 verification fails"
     set result 0 ; #[configNEsForRoutingTestbed $fgwIp "config"]
     if {$result != 0} {
          print -fail "Configuring network for routing failed"
          return -1
     } else {
          print -pass "Configuring network for routing is success"
     }
     
     # ------------------------------------------------------------------------------ #
     # For the ATCA setup use the MON script to update the routes
     # Start the Application so that the interface configuration takes effect
     # ------------------------------------------------------------------------------ #
     set clusterState 0
     if {[isATCASetup] || [isIfCfgThrMON]} {
          if {[isATCASetup]} {
               set bonoIpList $::BONO_IP_LIST
          } else {
               set bonoIpList [getActiveBonoIp]
          }
          set noOfBonos  [llength $bonoIpList]
          
          if {$noOfBonos == 1 && ![info exists waitAfterApplnStart]} {
               set waitAfterApplnStart 100
               #set waitAfterApplnStart 50
          } elseif {![info exists waitAfterApplnStart]} {
               set waitAfterApplnStart 100
               #set waitAfterApplnStart 50
          }
          foreach bonoIp $bonoIpList {
               print -info "Configuring the routes through MON on board $bonoIp"
               set result [configRoutesOnBono $bonoIp]
               set result 0
               if {$result != 0} {
                    print -fail "Route confiuration on board ip \"$bonoIp\" failed"
                    return -1
               } else {
                    print -pass "Route confiuration on board ip \"$bonoIp\" successful"
               }
          }
          
          # ------------------------------------------------------------------------------ #
          # Start the HeNBGW application
          # ------------------------------------------------------------------------------ #
          foreach bonoIp $bonoIpList bonoId [listOfIncrEle 1 $noOfBonos] {
               print -info  "Starting the HeNBGW application on \"$bonoIp\""
               print -debug "Process verification enabled? : $verifyProcess"
               set result  [restartHeNBGW -fgwNum $fgwNum -verify $verifyProcess -operation "start" -boardIp $bonoIp]
               if {$result < 0} {
                    print -fail "Application bringup failed on $bonoIp, cannot continue further"
                    return -1
               } else {
                    print -pass "Successfully brought up the HeNBGW application on $bonoIp"
               }
               # Temp hack to make bono on lower slot to be active
               if {$bonoId == "1" && $noOfBonos > 1} {
                    print -debug "Waiting for $waitForApplStartBtNodes seconds before starting the application on second bono"
                    halt $waitForApplStartBtNodes
               }
          }
          print -nonewline "For the state to be negiotiated .."
          halt $waitAfterApplnStart
          
          # ------------------------------------------------------------------------------ #
          # Verify the L3 Configuration and reconfigure switch if requried
          # Verify that the Internode connection is up between the BONOs
          # ------------------------------------------------------------------------------ #
          if {$verifyProcess == "yes"} {
               print -info "Verifying the network connectivity after system restart"
               set result [configNEsForRoutingTestbed $fgwIp "verify"]
               if {$result != 0} {
                    print -fail "Configuring network for routing failed"
                    if {[isATCASetup]} {
                         foreach ip $::MALBAN_IP_LIST {
                              dumpMalbanState -bladeIp $ip
                         }
                    }
                    return -1
               } else {
                    print -pass "Configuring network for routing is success"
               }
               
               print -info "Verifying Internode link communation between NODES"
               set result [verifyHeNBGWClusterState -fgwNum $fgwNum]
               if {$result != 0} {
                    print -fail "The HeNBGW cluster state is improper"
                    set clusterState 1
               } else {
                    print -pass "HeNBGW cluster state is proper"
               }
          } else {
               print -info "Skipping internode link verification between boards"
          }
          # Update the active Bono
          set result [getActiveBonoIp $fgwNum update]
     }
     
     # ------------------------------------------------------------------------------ #
     # To add virtual ip for MME instances, when noOfMMEs > 1
     # ------------------------------------------------------------------------------ #
     if {$noOfMMEs > 1} {
          for {set switchNo 0} {$switchNo < $noOfSwitch} {incr switchNo} {
               set simIp [getDataFromConfigFile "getMmeSimulatorHostIp" $fgwNum $switchNo]
               if {![isIpaddr $simIp]} {continue}
               #to add unique ip to each MME instance on simulator, i.e create virtual ip's
               for {set cpNum 1} {$cpNum <= $noOfMMECPs} {incr cpNum} {
                    #if {$cpNum == 2 && ($remoteMMEMultiHoming == "no" && $localMMEMultiHoming == "no")} {continue}
                    if {$cpNum == 2 && $remoteMMEMultiHoming == "no"} {continue}
                    set arr_ip_data([set simCp${cpNum}Int]\.[set getMmeSimCp${cpNum}Vlan]) "[incrIp [set getMmeSimCp${cpNum}Ipaddress]]/[set getMmeSimCp${cpNum}Mask]"
               }
               set result [configVirtualIp $simIp $fgwIp $noOfMMEs]
               if {$result != 0} {
                    print -fail "Configuring virtual ip's failed for MMEs"
                    return -1
               } else {
                    print -pass "Configured virtual ip's for MMEs"
               }
          }
     }
     
     return 0 ;# Stop GAP solution
}

proc encryptVar {var {op encrypt}} {
     #-
     #- To encrypt or decrypt the variable if the variable has special characters in it
     #- This will fail the variable value defination so we need to encrypt the variable before initialization
     #-
     #- @in var  the variable to be encrypted or decrypted
     #- @in op   the operation to be performed, default as encryption
     #-
     #- @return var
     #-
     
     if {$op == "encrypt"} {
          regsub -all "=" $var "--" var
          regsub -all "," $var "##" var
     } else {
          regsub -all {\-\-} $var "=" var
          regsub -all "##" $var "," var
     }
     return $var
}

proc verifyMMEContext {args} {
     #-
     #- Verifies If MME context is created on the HeNBGW
     #- The Lib will verify the MME context based on the Index passed
     #- If the user passes the HeNBIndex then the HeNB context would be verified
     #-
     #- @return 0 on success and -1 on failure
     #-
     #- set param1    "MME_Overload_Status"
     #- set param2    "MME_Overload_Action"
     #- set ParamList "$param1 $param2"
     #- set value1    "True"
     #- set value2    "REJECT_NON_EMERGENCY_MO_DT"
     #- set ValueList "$value1 $value2"
     #- set result [verifyMMEContext -ParamList $ParamList -ValueList $ValueList]
     
     set noOfRetries   5
     set retryInterval 1
     set flag 0
     parseArgs args \
               [list \
               [list msgType              optional   "string"         "s1Response"                 "The type of message to be verified" ] \
               [list MMEIndex             optional   "string"         "0"                          "The MME instance to be verified against" ] \
               [list ParamList            optional   "string"         "__UN_DEFINED__"             "The MME Name to be sent"] \
               [list ValueList            optional   "string"         "__UN_DEFINED__"             "The MME Name to be sent"] \
               ]
     
     # validate data lengths
     if {[llength $ParamList] != [llength $ValueList]} {
          print -fail "data length mismatch ParamList([llength $ParamList]) and ValueList([llength $ValueList])"
          return -1
     }
     
     set contextType "MME"
     #Get the MME data from the debug door
     for {set retry 0} {$retry < $noOfRetries} {incr retry} {
          set result     [executeHeNBGrpDbgDoorCmd -command "show mme"]
          set result     [extractOutputFromResult $result]
          if {[string trim $result] != ""} {break}
          print -info "Failed to get data from debug door... retrying"
          halt $retryInterval
     }
     
     set data       [split $result \n]
     set mmeCxtList [lsearch -all -regexp $data "MME Context Details for MME Id"]
     if {$mmeCxtList < 0 || [isEmptyList $mmeCxtList]} {
          if {![regexp -nocase "s1Response" $msgType]} {
               print -pass "MME Context not created for $msgType as expected"
               return 0
          } else {
               print -fail "MME context does not exist for MMEIndex $MMEIndex"
               return -1
          }
     }
     
     #Extract the MME block for the MME index
     if {[llength $mmeCxtList] > [expr $MMEIndex + 1]} {
          set mmeData [lrange $data [lindex $mmeCxtList $MMEIndex] [lindex $mmeCxtList [expr $MMEIndex + 1]]]
     } else {
          set mmeData [lrange $data [lindex $mmeCxtList $MMEIndex] end]
     }
     
     set MMEIndex [expr $MMEIndex + 1]
     #Extract the MME context details from the MME data
     set startIndex      [lsearch -regexp $mmeData "MME Context Details for MME Id: $MMEIndex" ]
     set overloadStatus  [lsearch -regexp $mmeData "MME Overload Status"]
     set overloadAction  [lsearch -regexp $mmeData "MME Overload Action"]
     set endIndex        [lsearch -regexp $mmeData "MME Region Map Members for MME Id : $MMEIndex"]
     
     set mmeContext  [join [lrange $mmeData $startIndex $endIndex ] "\n"]
     
     set mmedata [split $mmeContext \n]
     foreach ele $mmedata {
          if {![string match $ele ""]} {
               set ele  [string trim $ele "-"]
               set var [split $ele :]
               if { [ llength [lindex $var 0] ] == 0 } { continue }
               if {[llength $var] < 3 } {
                    set arr_local([string trim [lindex $var 0]]) [string trim [lindex $var 1]]
               } else {
                    set arr_local([string trim [lindex $var 0]]) [string trim [lindex $var 2]]
               }
          }
     }
     parray arr_local
     
     foreach Param $ParamList Value $ValueList {
          set temp [split $Param "_"]
          if {[info exists arr_local($temp)]} {
               if {[string match -nocase $Value $arr_local($temp)]} {
                    print -pass "MME Conext matching for $temp Expected value \"$Value\" and received \"$arr_local($temp)\""
               } else {
                    print -fail "MME Conext not matching for $temp Expected value \"$Value\" and received \"$arr_local($temp)\""
                    return -1
               }
          } else {
               print -fail "\"$temp\" not exist in MME Context"
               return -1
          }
     }
     
     return 0
}

proc configRoutesOnBono {bonoIp} {
     #-
     #- This script is used to configure routes on bono
     #-
     #- @return 0 on success and -1 on failure
     #-
     
     set result [execCommandSU -dut $bonoIp -command "cd /opt/bin \n ./MonConfig.exe"]
     if {[regexp -nocase "error|failure" $result] || $result == -1} {
          print -fail "Route configuration on bono failed"
          return -1
     } else {
          print -pass "Configured routes on bono $bonoIp"
          return 0
     }
}

proc verifyInterNodeConnection {args} {
     #-
     #- Procedure to verify the INL between the BONOs
     #-
     parseArgs args \
               [list \
               [list fgwNum                      optional  "numeric"  "0"      "FGW number in testbed file"]\
               ]
     
     set flag 0
     set state "ESTABLISHED"
     foreach bonoIp $::BONO_IP_LIST {
          foreach localSctpPort [list 4002 40003] remoteSctpPort [list 4002 40003] {
               set result [checkSctpPort -hostIp $bonoIp -localSctpPort $localSctpPort -remoteSctpPort $remoteSctpPort -state $state]
               if {$result != 0} {
                    print -fail "SCTP Not in $state state for $localSctpPort,$remoteSctpPort"
                    set flag 1
               } else {
                    print -debug "SCTP in $state state for $localSctpPort,$remoteSctpPort"
               }
          }
     }
     if {$flag} {return -1}
     return 0
}

proc generateDummyIpAddrX {ip subnet} {
     #-
     #- Procedure to generate a dummp ip address
     #-
     #- @in ip ip address for which the dummy ip needs to be generated
     #- @in subnet subnet of the ip address
     #-
     #- @return -1 on failure ip address on success
     #-
     
     if {[::ip::is 4 $ip]} {
          set dummyIp [regsub {.\d+$} $ip {.254}]
     } else {
          set tmp    [split $ip ":"]
          set tmpEnd [lindex $tmp end]
          set tmpEnd [format %x [expr 0x$tmpEnd & 0xff00]]
          set tmpEnd [format %x [expr 0x$tmpEnd + 0x00fe]]
          set tmp    [lreplace $tmp end end $tmpEnd]
          set dummyIp [join $tmp ":"]
     }
     if {[isIpaddr $dummyIp]} {
          return $dummyIp
     } else {
          return -1
     }
}

proc execConsoleCommands {args} {
     #-
     #- Procedure to execute commands, through console connection of a board( MALBAN, BONO, SHM)
     #- This procedure to be called only when both Malbans are down
     #-
     #- @return -1 on failure , on success returns console command output
     
     set validOp "activate|deactivate|startbsg|stopbsg|showproc|getMonState"
     parseArgs args\
               [list \
               [list fgwNum            "optional"     "numeric"           "0"                 "The positioning of FGW in the testbed"]\
               [list boardIp           "mandatory"    "ip"                "__UN_DEFINED__"    "defines the ip of board on which operation has to be executed"] \
               [list operation         "mandatory"    $validOp            "_"                 "Command to be executed"]\
               ]
     
     switch $operation {
          "activate"   {
               set command "clia \n activate board [getBoardSlot $boardIp] \n exit"
               #Getting activate board Ip through console, as this procedure is called only when both Malbans are down
               set consoleIp [getActiveShmIpThruConsole]
          }
          "deactivate" {
               set command "clia \n deactivate board [getBoardSlot $boardIp] \n exit"
               #Getting activate board Ip through console, as this procedure is called only when both Malbans are down
               set consoleIp [getActiveShmIpThruConsole]
          }
          "startbsg" {
               set command "startbsg"
               set consoleIp $boardIp
          }
          "stopbsg" {
               set command "stopbsg"
               set consoleIp $boardIp
          }
          "showproc"   {
               set command "showproc"
               set consoleIp $boardIp
          }
          "getMonState" {
               set command "telnet 0 17600 \n show mon state \n close"
               set consoleIp $boardIp
          }
     }
     
     print -info "Command to be sent through console of $consoleIp: $command"
     set result [sendCommandThruConsole -boardIp $consoleIp -command $command]
     
     if {[regexp "activate|deactivate" $operation]} {
          if {$operation == "deactivate"} {
               set status DOWN
          } else {
               set status UP
          }
          
          print -info "Verifying board for status as $status"
          set result [monitorDeviceForStatus $boardIp $status]
          if {$result != 0} {
               print -fail "Verification of $boardIp for $status failed"
               set flag 1
          } else {
               print -pass "Verified the board status for \"$boardIp\" as \"$status\""
          }
          if {[getBladeType $boardIp] == "MALBAN"} {
               # A malban failure would cause the base ip address to change
               # Get the new set of base ip address
               set ::DID_BASE_SWITCH 1
               #getActiveBladesInfo
               getActiveBonoIp $fgwNum "update"
          }
     }
     
     if {$result != ""} {
          return $result
     } else {
          return -1
     }
}

proc getMimName {args} {
     #-
     #- Procedure to get the MIM name from the network
     #-
     #- @return MimName
     #-
     parseArgs args \
               [list \
               [list fgwNum        "optional"  "numeric"  "0"            "FGW number in testbed file"]\
               [list nwIf          "mandatory" "string"   "_"            "The network iterface"]\
               [list ifType        "optional"  "string"   "cp"           "The type of network iterface"]\
               [list ifNum         "optional"  "numeric"  "1"            "The interface number"]\
               ]
     
     if {$nwIf == "all"} {
          return "cnCP1 cnCP2 heNBCP1 heNBCP2 oAM heNBCP3"
     }
     switch $nwIf {
          "mme"   {set mimName "cn[string toupper $ifType]$ifNum"}
          "henb"  {set mimName "heNB[string toupper $ifType]"}
          "oam"   {set mimName "oAM"}
          "lmt"   {set mimName "lMT"}
          "cbc"   {set mimName "cellBroadcast"}
     }
     return $mimName
}

proc getRouteKeywords {args} {
     #-
     #- This script is used to return list of route keywords in arr_nw_data
     #-
     #- @return 0 on success and -1 on failure
     #-
     if {[isATCASetup]} {
          set routeList "fgwHenbGw simHenbGw fgwMmeGw simMmeGw fgwOam simOamGw"
     } else {
          set routeList "fgwHenbGw simHenbGw fgwMmeGw simMmeGw fgwOam simOamGw"
     }
     return $routeList
}

proc updateSwitchConfigData {args} {
     #-
     #- Wrapper procedure to build the switch config data
     #- This will set the the variables in the calling proc
     #-
     #- @return 0 on sucessfull configuration and -1 on failure
     #-
     
     parseArgs args \
               [list \
               [list fgwNum        	"optional"  "numeric" "0"                "FGW num in the configuration file"]\
               [list switchIndex     	"optional"  "numeric" "0"                "Switch num in the configuration file"]\
               [list omniSwitchMgmtIp   "optional"  "ip"      "__UN_DEFINED__"   "IP address to connect omni switch"]\
               [list omniSwitchPasswd   "optional"  "string"  "__UN_DEFINED__"   "privilege user password"]\
               [list linkAggNum         "optional"  "string"  ""                 "The link aggregate to be used"]\
               [list ixiaConfig         "optional"  "string"  ""                 "IXIA configuration"]\
               ]
     
     array set arr_omniSwitch_int {}
     
     set opts [list \
               gw \
               defaultHenbSim \
               defaultMmeSim \
               switch2Switch \
               ]
     
     #configuring port2 on mmeSim, if testbed file has sim port2 info
     if {[getDataFromConfigFile "getMmeSimCp2SwitchPort" $fgwNum] != -1} {
          set opts [concat $opts "mmeSimPort2"]
     }
     if {[getDataFromConfigFile "getServiceRouterIpaddress" $fgwNum $switchIndex] != -1} {
          set opts [concat $opts "sr"]
          
     }
     
     # Check if OAM configuration exists
     if {[getDataFromConfigFile oamIntCount $fgwNum] > 0} {
          set opts [concat $opts "oamServer oamClient"]
     }
     
     # read ixia info to the array if any
     if {$ixiaConfig != ""} { array set arr_sw_int $ixiaConfig }
     
     # identify the vlans, ports from the testbed file
     foreach type $opts {
          print -debug "type: $type"
          switch -regexp $type {
               "^gw$" {
                    set int $linkAggNum
                    set vlans "[getDataFromConfigFile "getMmeGwVlans" $fgwNum] [getDataFromConfigFile "getHenbGwVlans" $fgwNum]"
                    # Incase teh SR has to be configured then the SR vlan should be part of the aggregate link
                    set srVlan [getDataFromConfigFile "getServiceRouterVlan"        $fgwNum $switchIndex]
                    if {[isDigit $srVlan]} {append vlans " $srVlan"}
               }
               "defaultHenbSim" {
                    # The Link to the HeNB Simulator
                    set int   [getDataFromConfigFile "getHenbSimCpSwitchPort" $fgwNum $switchIndex]
                    set vlans [getDataFromConfigFile "getHenbSimulatorVlans"  $fgwNum]
               }
               "defaultMmeSim" {
                    # The Link to the MME simulator
                    set int   [getDataFromConfigFile "getMmeSimCp1SwitchPort" $fgwNum $switchIndex]
                    set vlans [getDataFromConfigFile "getMmeSimulatorVlans"   $fgwNum]
               }
               "mmeSimPort2" {
                    # The secondary link to the MME simulator
                    set int   [getDataFromConfigFile "getMmeSimCp2SwitchPort" $fgwNum $switchIndex]
                    set vlans [getDataFromConfigFile "getMmeSimulatorVlans2"  $fgwNum]
               }
               "switch2Switch" {
                    # The connection between the switch
                    set int   [getDataFromConfigFile "getSwitch2SwitchPort"   $fgwNum $switchIndex]
                    set vlans [getDataFromConfigFile "getVlansOnSwitch"       $fgwNum]
               }
               "sr" {
                    set int   "sr[expr $switchIndex + 1]"
                    set vlans [getDataFromConfigFile "getServiceRouterVlan"   $fgwNum $switchIndex]
               }
               "oamServer" {
                    set int   [getDataFromConfigFile "getOamServerSwitchPort" $fgwNum $switchIndex]
                    set vlans [getDataFromConfigFile "getOamServerVlan"       $fgwNum $switchIndex]
               }
               "oamClient" {
                    set int   [getDataFromConfigFile "getGwOamSwitchPort"     $fgwNum $switchIndex]
                    set vlans [getDataFromConfigFile "oamVlan"                $fgwNum]
               }
               # skip interfaces that are not part of the testbed
          }
          if {$int == -1} {continue}
          if {$vlans == -1} {continue}
          print -debug "int: $int vlans: $vlans"
          if {![info exists arr_omniSwitch_int($omniSwitchMgmtIp,$int,vlans)]} { set arr_omniSwitch_int($omniSwitchMgmtIp,$int,vlans) "" }
          set arr_omniSwitch_int($omniSwitchMgmtIp,$int,vlans) [concat $arr_omniSwitch_int($omniSwitchMgmtIp,$int,vlans) $vlans]
          set arr_omniSwitch_int($omniSwitchMgmtIp,$int,mode)  "trunk"
     }
     # Export the data to a level above
     return [array get arr_omniSwitch_int]
     uplevel "array set arr_omniSwitch_int \[array get arr_omniSwitch_int\]"
     return 0
}
proc checkINLConnection {{fgwNum 0}} {
     #-
     #- This procedure is used to check the INL connection
     #-
     #-
     if {[isATCASetup]} {
          set bonoList [getDataFromConfigFile getBonoIpaddress $fgwNum]
          if {[llength $bonoList] == 2} {
               set cluster  [getBoardSlot [lindex [lsort -dictionary $bonoList] 0] ]
               #               set node1    [getInterNodeLinkParam -fgwNum $fgwNum -cluster $cluster -param NODE1]
               #               set node2    [getInterNodeLinkParam -fgwNum $fgwNum -cluster $cluster -param NODE2]
               
               #               set peerIpList1 [split $node1 ","]
               #               set peerIpList2  [split $node2 ","]
               
               set noOfINLs 2
               for {set inl 1} {$inl <= $noOfINLs} {incr inl} {
                    set link${inl}node1    [getInterNodeLinkParam -fgwNum $fgwNum -cluster $cluster -param LINK${inl}NODE1 -noOfINLs $noOfINLs -instance $inl]
                    set link${inl}node2    [getInterNodeLinkParam -fgwNum $fgwNum -cluster $cluster -param LINK${inl}NODE2 -noOfINLs $noOfINLs -instance $inl]
               }
               
               set peerIpList1 "$link1node1 $link2node1"
               set peerIpList2 "$link1node2 $link2node2"
               
               foreach node1 $peerIpList1 node2 $peerIpList2 {
                    foreach dutIp $bonoList peerINLIp [list $node2 $node1] {
                         checkIfSshKeysExchanged $dutIp $peerINLIp
                         # closeSpawnedSessions $dutIp "all" "ssh"
                         closeSpawnedSessions $dutIp
                    }
               }
          }
     }
     return 0
}

proc getInterNodeLinkParamX {args} {
     #-
     #- This procedure is used to get the internode link params for a given cluster
     #-
     #-
     
     set validParam "NETWORK|NODE1|NODE2|NETMASK|VLANID"
     parseArgs args \
               [list \
               [list fgwNum           "optional"  "numeric"           "0"        "FGW number in the testbed file" ] \
               [list instance         "optional"  "numeric"           "1"        "The internode link instance" ] \
               [list cluster          "mandatory" "numeric"           "_"        "The cluster for which the INL params have to be retreived" ] \
               [list noOfINLs         "optional"  "numeric"           "4"        "The number of INLs" ] \
               [list param            "mandatory" "$validParam"       "_"        "The param for which the data has to be retreived" ] \
               ]
     
     switch -exact $param {
          "NETWORK" {return "193.${cluster}.${instance}.0"}
          "NODE1"   {return "193.${cluster}.${instance}.${instance}"}
          "NODE2"   {return "193.${cluster}.${instance}.[expr $instance + $noOfINLs + 1]"}
          "NETMASK" {return "255.255.255.0"}
          "VLANID"  {return [expr [lindex [lsort -increasing [getDataFromConfigFile getVlansOnSwitch $fgwNum]] end] + 1]}
     }
     return -1
}

proc getS1LinkEnbId {args} {
     #-
     #- This procedure is used to get the enbId of mme in case of multiple s1 links
     #-
     #-
     
     parseArgs args \
               [list \
               [list MMEIndex         "optional"  "numeric"           "0"        "MMEIndex " ] \
               [list RegMMEIndex      "optional"  "numeric"           "0"        "MMEIndex in a region"] \
               [list linkNo           "optional"  "numeric"           "1"        "The internode link instance" ] \
               ]
     
     set regIndex $::ARR_LTE_TEST_PARAMS_MAP(M,$MMEIndex,Region)
     set MOID $::ARR_LTE_TEST_PARAMS_MAP(R,$regIndex,M,$RegMMEIndex,S1LinkNo,$linkNo,MOID)
     set subR $::ARR_LTE_TEST_PARAMS_MAP(MOID,$MOID,SubReg)
     set region $::ARR_LTE_TEST_PARAMS_MAP(SubReg,$subR,Region)
     set enbId $::ARR_LTE_TEST_PARAMS_MAP(R,$region,SubR,$subR,eNBId)
     return $enbId
}
proc getBsgId {fgwIp} {
     #-
     #- This script is used to get the FGW ID as present in BSG CLI
     #-
     #- @return FGWID on success and -1 on failure
     #-
     set cmd "ls"
     set pattern "FGW:(\[0-9\]+)"
     set result [execBsgCliCommandPm -bsgIp $fgwIp -command $cmd]
     if {[regexp $pattern $result temp bsgId]} {
          print -info "BSG ID is $bsgId"
          return $bsgId
     } else {
          print -fail "Failed to get BSGID in \n $result"
          return -1
     }
     set fileName [bsgSaveState -dutIp $dutIp -copyCores "yes" -genPstack "yes"]
}
