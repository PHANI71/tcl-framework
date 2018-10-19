proc setUpLteSimulators {args} {
     #-
     #- to update configuration files of HeNB MME Simulator
     #-
     
     set allSims "HeNB MME"
     set validSims [join $allSims "|"]
     
     parseArgs args \
               [list \
               [list fgwNum              "optional"  "numeric"   "0"               "Position of FGW in the testbed"] \
               [list simList             "optional"  $validSims  $allSims          "simulators that have to be configured"] \
               [list testType            "optional"  "func|load" "func"            "Type of test that we are going to perform using simulator"] \
               [list noOfHeNBs           "optional"  "numeric"   "1"               "No of HeNBs to be simulated"] \
               [list noOfMMEs            "optional"  "numeric"   "1"               "No of MMEs to be simulated"] \
               [list numInStreams        "optional"  "numeric"   "512"             "Number of Input SCTP stream"] \
               [list numOutStreams       "optional"  "numeric"   "510"             "No of output SCTP stream"] \
               [list startSim            "optional"  "yes|no"    "yes"             "To start simulator or not"] \
               [list localMMEMultiHoming  "optional" "yes|no"    "no"              "To eanble multihoming towards MME on gw"]\
               [list localHeNBMultiHoming "optional" "yes|no"    "no"              "To eanble multihoming towards HeNB on gw"]\
               [list remoteMMEMultiHoming "optional" "yes|no"    "no"              "To eanble multihoming on MME sim"]\
               ]
     
     set MMESimIpAddr  [getDataFromConfigFile "getMmeSimulatorHostIp" $fgwNum]
     set HeNBSimIpAddr [getDataFromConfigFile "getHenbSimulatorHostIp" $fgwNum]
     
     foreach simType $simList {
          set simIp [set ${simType}SimIpAddr]
          
          # cleanup old files
          print -info "Cleanup stale files on $simType simulator"
          set result [getAllFiles $simIp [getLTEParam "${simType}Path"] "root" $::ROOT_PASSWORD "yes" "" "*.org"]
          if {$result != "" && $result != -1} {
               set cmd ""
               foreach org $result {
                    set current [string trim [regsub "\.org$" $org ""]]
                    append cmd "rm -f $current \n mv -f $org $current \n"
               }
               if {$cmd != ""} { set result [execCommandSU -dut $simIp -command $cmd] }
          } else {
               print -info "No stale files on $simType to clear"
          }
          
          print -info "Updating [string toupper $simType] Simulator configuration files ..."
          
          # updating conf.sh file
          set result [updateSimulatorPath -simIpAddr $simIp -simType $simType]
          if {$result != 0} {
               print -abort "Not able to update $simType simulator path information"
               return 1
          }
          
          # updating SimulatorLog.properties file
          set result [configSimulatorLogLevels -simIpAddr $simIp -simType $simType -logTo "console"]
          if {$result != 0} {
               print -abort "Not able to update $simType simulator log properties information"
               return 1
          }
          
          switch $simType {
               "MME" {
                    # updating MME config.ini file
                    set result [updateValAndExecute "generateMMESimulatorTestConfigFile -fgwNum fgwNum -simType simType \
                              -localMMEMultiHoming localMMEMultiHoming -remoteMMEMultiHoming remoteMMEMultiHoming" ]
                    if {$result != 0} {
                         print -abort "Not able to update MME simulator config file"
                         return 1
                    }
               }
               "HeNB" {
                    # updating HeNB config.ini file
                    set result [updateValAndExecute "generateHeNBSimulatorTestConfigFile -fgwNum fgwNum -simType simType \
                              -localHeNBMultiHoming localHeNBMultiHoming"]
                    if {$result != 0} {
                         print -abort "Not able to update HeNB simulator config file"
                         return 1
                    }
               }
          }
          
          #As as additional setup for debugging we are enabling user based packet capturing
          #This is just a temporary measure wherein it would be easier to raise issues
          #Later point of time it would be integrated with tshark analysis
          print -info "Starting Capture on $simType simulator interface"
          set result [decodeAndDumpS1Capture -fgwNum $fgwNum -operation "init" -simType $simType -localMMEMultiHoming $localMMEMultiHoming \
                    -localHeNBMultiHoming $localHeNBMultiHoming  -remoteMMEMultiHoming $remoteMMEMultiHoming ]
          
          # starting the simulator
          if {$startSim == "yes"} {
               print -info "Starting $simType simulator for \"$testType\" test"
               set result [launchLTESimulators -fgwNum $fgwNum -testType $testType -simList $simType \
                         -noOfMMEs $noOfMMEs -noOfHeNBs $noOfHeNBs]
               if {$result != 0} {
                    print -fail "Launching of simulator for \"$testType\" failed"
                    return -1
               } else {
                    print -pass "Successfully launched simulator \"$testType\" test"
               }
              
               switch $simType {
                    "MME" {
                         set result [createMME -fgwNum $fgwNum -noOfMMEs $noOfMMEs -numOutStreams $numOutStreams -numInStreams $numInStreams -localMMEMultiHoming $localMMEMultiHoming -remoteMMEMultiHoming $remoteMMEMultiHoming]
                         if { $result != 0 } {
                              print -fail "Failed to Create MME instances on MME Simulator interface -- numOutStreams : $numOutStreams --- numInStreams $numInStreams"
                              return -1
                         } else {
                              print -pass "Created MME instances on MME Simulator interface numOutStreams : $numOutStreams --- numInStreams $numInStreams"
                         }
                    }
                    "HeNB" {
                         set result [createHeNB -fgwNum $fgwNum -noOfHeNBs $noOfHeNBs -numOutStreams $numOutStreams -numInStreams $numInStreams -localHeNBMultiHoming $localHeNBMultiHoming]
                         if { $result != 0 } {
                              print -fail "Failed to Create HeNB instances on HeNB Simulator interface: numOutStreams : $numOutStreams --- numInStreams $numInStreams "
                              return -1
                         } else {
                              print -pass "Created HeNB instances on HeNB Simulator interface -- numOutStreams : $numOutStreams --- numInStreams $numInStreams"
                         }
                    }
               }
          }
     }
     
     return 0
}

proc generateMMESimulatorTestConfigFile {args} {
     #-
     #- to generate file for MME simulator
     #-
     
     parseArgs args \
               [list \
               [list simType             "optional"  "MME"            "MME"             "Simulator whose files have to be modified"] \
               [list fgwNum              "optional"  "numeric"        "0"               "FGW to which simulator connected"] \
               [list localMMEMultiHoming  "optional" "yes|no"         "no"              "To eanble multihoming towards MME on gw"]\
               [list remoteMMEMultiHoming "optional" "yes|no"         "no"              "To eanble multihoming on MME sim"]\
               [list mmeSendRate           "optional"  "numeric"      "15000"    "Rate at which MME messages has to be sent"] \
               [list testType               "optional"  "func|load|loadNew"   "func"    "Type of test that we are going to perform using simulator"] \
               [list numInStreams        "optional"  "numeric"   "512"             "Number of Input SCTP stream"] \
               [list numOutStreams       "optional"  "numeric"   "512"             "No of output SCTP stream"] \
               [list sctpInitRate          optional  "numeric"    "1000"           "Rate at which HeNB sends SCTP INIT from Simulator has to be sent"] \
               [list NumThreads           optional      "numeric"       "1"        "number of threads"] \
               [list DbgDrIP             optional       "string"    "__UN_DEFINED__" "debug door ip"] \
               [list DbgDrPort           optional       "string"    "[getLTEParam MMESimDbgPort]" "debug door port"] \
               [list NumThreadMMESim     "optional" "numeric" "1"        "mme threads"] \
               [list simLoc 	    "optional" "string" "__UN_DEFINED__"        "simLoc"] \
               ]
     
     set flag    0
     if { $testType == "load" } {
          set simLoc  [getLTEParam "${simType}LoadPath"]
          set logFileList "$simLoc/loadMMEConfig.ini"
     } elseif { $testType == "loadNew"} {
          if {![info exists simLoc] } {
               set simLoc  [getLTEParam "${simType}LoadNewPath"]
          }
          set logFileList "$simLoc/loadMMEConfig.ini"
     } else  {
          set simLoc  [getLTEParam "${simType}Path"]
          set logFileList "$simLoc/mmeConfig.ini"
     }
     
     # Reading data from testbed file
     set simIpAddr      [getDataFromConfigFile "get[string totitle $simType]SimulatorHostIp" $fgwNum]
     set DbgDrIP $simIpAddr
     set fgwS1MMEIp1    [getDataFromConfigFile "getMmeCp1Ipaddress" $fgwNum]
     if {$localMMEMultiHoming == "yes"} {
          set fgwS1MMEIp2    [getDataFromConfigFile "getMmeCp2Ipaddress" $fgwNum]
     } else {
          set fgwS1MMEIp2    $fgwS1MMEIp1
     }
     set fgwS1MMESctp1  [getDataFromConfigFile "mmeSctp" $fgwNum]
     set fgwS1MMESctp2  $fgwS1MMESctp1
     if { $::ROUTING_TB == "yes" } {
          set MMEIp1        [getDataFromConfigFile "getMmeSimCp1Ipaddress" $fgwNum]
     } else {
          set MMEIp1         [incrIp $fgwS1MMEIp1]
     }
     
     if {$remoteMMEMultiHoming == "yes"} {
          if { $::ROUTING_TB == "yes" } {
               set MMEIp2        [getDataFromConfigFile "getMmeSimCp2Ipaddress" $fgwNum]
          }  else {
               set MMEIp2         [incrIp $fgwS1MMEIp2]
          }
     } else {
          set MMEIp2         $MMEIp1
     }
     set MMESctp1       [expr $fgwS1MMESctp1 + 1]
     set MMESctp2       $MMESctp1
     set fgwS1SgwIp     [getDataFromConfigFile "sgwIpaddress" $fgwNum]
     
     # replace mapping
     if { $testType == "load" } {
          set mappingList \
                    [list \
                    [list "MME:1"                    { MMESendRate=mmeSendRate} ]\
                    [list "MME:1_SCTP:1"             { NumOutStreams=noOfStream, NumInStreams=noOfStream} ]\
                    ]

     } elseif {$testType == "loadNew" } {

          set mappingList \
                    [list \
                    [list "MMESimulator:1"       { FemtoUESendRate=mmeSendRate, SCTPInitRate=sctpInitRate, DbgDrIP=DbgDrIP, DbgDrPort=DbgDrPort,  NumOutStreams=numOutStreams, NumInStreams=numInStreams, NumThreads=NumThreadMMESim}]\
                    [list "HeNBGW:1"             { GatewaySignalingIP=fgwS1MMEIp1, GatewaySCTPPort=fgwS1MMESctp1, GatewayUserplaneIP=fgwS1SgwIp} ]\
                    ]
     } else {
          # replace mapping
          set mappingList \
                    [list \
                    [list "MME:1"                    { UserplaneIP=fgwS1SgwIp} ]\
                    [list "MME:1_EndPoint:1"         { IpAddress=MMEIp1, SctpPortNumber=MMESctp1} ]\
                    [list "MME:1_EndPoint:2"         { IpAddress=MMEIp2, SctpPortNumber=MMESctp2} ]\
                    [list "GWEndPoint:1"          { IpAddress=fgwS1MMEIp1, SctpPortNumber=fgwS1MMESctp1} ]\
                    [list "GWEndPoint:2"          { IpAddress=fgwS1MMEIp2, SctpPortNumber=fgwS1MMESctp2} ]\
                    ]
     }
     set mappingList [processMappingList $mappingList]
     
     foreach logFile $logFileList {
          set result [setUpConfigFileForSimulator -simIpAddr $simIpAddr -fileName $logFile -keyValPairs $mappingList]
          if {$result != 0} { set flag -1}
     }
     
     return $flag
}

proc generateHeNBSimulatorTestConfigFile {args} {
     #-
     #- to generate file for HeNB simulator
     #-
     
     parseArgs args \
               [list \
               [list simType              "optional"  "HeNB"       "HeNB"            "Simulator whose files have to be modified"] \
               [list fgwNum               "optional"  "numeric"    "0"               "FGW to which simulator connected"] \
               [list localHeNBMultiHoming "optional" "yes|no"     "no"              "To eanble multihoming towards HeNB on gw"]\
               [list henbSendRate         "optional"  "numeric"    "7000"               "FGW to which simulator connected"] \
               [list testType             "optional"  "func|load|loadNew"  "func"    "Type of test that we are going to perform using simulator"] \
               [list numInStreams        "optional"  "numeric"   "512"             "Number of Input SCTP stream"] \
               [list numOutStreams       "optional"  "numeric"   "512"             "No of output SCTP stream"] \
               [list sctpInitRate          optional  "numeric"    "1000"           "Rate at which HeNB sends SCTP INIT from Simulator has to be sent"] \
               [list NumThreads           optional      "numeric"       "1"        "number of threads"] \
               [list DbgDrIP		 optional	"string"    "__UN_DEFINED__" "debug door ip"] \
               [list DbgDrPort		 optional	"string"    "[getLTEParam HeNBSimDbgPort]" "debug door port"] \
               [list simInstance	 optional	"string"	""	"sim instance used for load test" ] \
               [list NumThreadHeNBSim     "optional" "numeric" "1"        "henb threads"] \
               [list simLoc 	    "optional" "string" "__UN_DEFINED__"        "simLoc"] \
               ]
     
     set flag    0
     if { $testType == "load" } {
          set simLoc  [getLTEParam "${simType}LoadPath"]
          set logFileList "$simLoc/loadHeNBConfig.ini"
     } elseif { $testType == "loadNew"} {
          if {![info exists simLoc] } {
               set simLoc  [getLTEParam "${simType}LoadNewPath"]
          }
          set logFileList "$simLoc/loadHeNBConfig.ini"
     } else {
          set simLoc  [getLTEParam "${simType}Path"]
          set logFileList "$simLoc/henbConfig.ini"
     }
     
     # Reading data from testbed file
     set simIpAddr      [getDataFromConfigFile "get[string totitle $simType]SimulatorHostIp" $fgwNum]
     set DbgDrIP $simIpAddr
     set fgwHeNBSignalIp    [getDataFromConfigFile "getHenbCp1Ipaddress" $fgwNum]
     if {$localHeNBMultiHoming == "yes"} {
          set fgwHeNBSignalIp2   [getDataFromConfigFile "getHenbCp2Ipaddress" $fgwNum]
     }
     set fgwHeNBBearerIp    [getDataFromConfigFile "henbBearerIpaddress" $fgwNum]
     if { $::ROUTING_TB == "yes" } {
          set HeNBIp            [getDataFromConfigFile "getHenbSimCpIpaddress" $fgwNum]
     }  else {
          set HeNBIp             [incrIp $fgwHeNBSignalIp]
     }
     
     set noOfInStream 512
     set noOfOutStream 512
     
     # replace mapping
     if { $testType == "load" } {
          set mappingList \
                    [list \
                    [list "HeNBSimulator:1"          {NumOutStreams=noOfOutStream, NumInStreams=noOfInStream, HeNBSendRate=henbSendRate, SCTPInitRate=sctpInitRate}]\
                    [list "HeNBGW:1"                 {GatewaySignalingIP=fgwHeNBSignalIp, GatewayUserplaneIP=fgwHeNBBearerIp}]\
                    ]

     } elseif {$testType == "loadNew" } {
 	  set henbGWsctpPort 36412
          set mappingList \
                    [list \
                    [list "HeNBSimulator:1"      { FemtoUESendRate=henbSendRate, SctpInitRate=sctpInitRate, NumOutStreams=numOutStreams, NumInStreams=numInStreams, NumThreads=NumThreads}]\
                    [list "FGW:1"             { GatewaySignalingIP=fgwHeNBSignalIp, GatewaySCTPPort=henbGWsctpPort, GatewayUserplaneIP=fgwHeNBBearerIp} ]\
                    ]
     }  else {
          set mappingList \
                    [list \
                    [list "HeNBSimulator:1"          {HeNBIP=HeNBIp}]\
                    [list "HeNBGW:1"                 {GatewaySignalingIP=fgwHeNBSignalIp, GatewayUserplaneIP=fgwHeNBBearerIp}]\
                    [list "HeNBGW:2"                 {GatewaySignalingIP=fgwHeNBSignalIp2, GatewayUserplaneIP=fgwHeNBBearerIp}]\
                    ]
     }
     set mappingList [processMappingList $mappingList]
     foreach logFile $logFileList {
          set result [setUpConfigFileForSimulator -simIpAddr $simIpAddr -fileName $logFile -keyValPairs $mappingList]
          if {$result != 0} { set flag -1}
     }
     
     return $flag
     
}

proc launchLTESimulators {args} {
     #-
     #- proc to launch MME, HeNB simulators
     #- The simulators would be launched based on the noOf instances to be spanned, indexed with the debug door
     #-
     #- @return  0 on success and -1 on failure
     #-
     
     set allSims "MME HeNB"
     
     parseArgs args \
               [list \
               [list fgwNum              "optional"  "numeric"            "0"               		"Position of FGW in the testbed"] \
               [list testType            "optional"  "func|load"          "func"            		"Type of test that we are going to perform using simulator"] \
               [list simList             "optional"  [join $allSims "|"]  $allSims          		"Type of test that we are going to perform using simulator"] \
               [list noOfHeNBs           "optional"  "numeric"            "1"               		"No of HeNBs to be simulated"] \
               [list noOfMMEs            "optional"  "numeric"            "1"               		"No of MMEs to be simulated"] \
               [list HeNBIndex           "optional"  "numeric"            "0"  				"Defines the HeNBIndex to be spanned"] \
               [list MMEIndex            "optional"  "numeric"            "0"  				"Defines the MMEIndex to be spanned"] \
               [list mmeDbgPort          "optional"  "numeric"            [getLTEParam MMESimDbgPort]   "The mme debug port to be used"] \
               [list henbDbgPort         "optional"  "numeric"            [getLTEParam HeNBSimDbgPort]  "The henb debug port to be used"] \
               ]
     
     set MMESimIpAddr  [getDataFromConfigFile "getMmeSimulatorHostIp" $fgwNum]
     set HeNBSimIpAddr [getDataFromConfigFile "getMmeSimulatorHostIp" $fgwNum]
     
     foreach simType $simList {
          set simLoc    [getLTEParam "${simType}Path"]
          set simAppln  [getLTEParam "${simType}Appln"]
          set simIpAddr [set ${simType}SimIpAddr]
          
          switch $simType {
               MME {
                    # OLD simulator: Each mme instance requires spanning of a different MME sim
                    # NEW Simulator: For MME only one instance of simulator has to be spanned
                    set noOfSimIns   1
                    set startDbgPort $mmeDbgPort
                    set startSimIns  0
               }
               HeNB {
                    # For HeNB only one instance of simulator has to be spanned
                    set noOfSimIns   1
                    set startDbgPort $henbDbgPort
                    set startSimIns  0
               }
          }
          
          # Spawn the simulators with the sim exe and the sim debug port
          # <sim-exe> <sim-debug-port>
          for {set instance $startSimIns} {$instance < $noOfSimIns} {incr instance} {
               set dbgPort [expr $startDbgPort + $instance]
               
               # Close any active running sessions for the simIp,port
               set result [closeActiveThreads "$simAppln.*$dbgPort" $simIpAddr "9" "all"]
               print -info "Launching $simType Simulator on $simIpAddr,$dbgPort"
               
               # Redirect the sim console logs to a log file
               # For log verification to work we need to update the log file to the logAnalyzer global array
               # And also initialize it to start reading the data
               #set simCmd  "$simLoc/$simAppln $dbgPort"
               set simCmd  "$simLoc/$simAppln"
               set simLog  "/tmp/${simType}_SIM_LOG_[getSysTime d_M_Y_H_M_S].log"
               set cmd "source $simLoc/conf.sh \n nohup $simCmd > $simLog 2>&1 &"
               
               set result [execCommandSU -dut $simIpAddr -command $cmd]
               if {[regexp "ERROR:|(No such file)" $result] || $result == -1} {
                    print -err "Not able to start $simType Simulator on $simIpAddr,$dbgPort"
                    return -1
               } else {
                    print -info "Started $simType Simulator on $simIpAddr,$dbgPort"
               }
               
               print -info "Wait of 2 secs for the simulator to finish launching"
               halt 2
               
               # initiating log verification for simulator logs
               lappend ::SYS_LOG_FILES $simLog
               set result [logAnalyzer -operation "init" -fileList $simLog -hostIp $simIpAddr]
               
               # based on the type of test, initialize the simulator
               if {$testType == "func"} {
                    set result [executeLteSimulatorBkdoorCmd -command "FunctionalTest" -simType $simType \
                              -${simType}Index $instance]
                    set result [executeLteSimulatorBkdoorCmd -command "help" -simType $simType \
                              -${simType}Index $instance]
               } else {
                    #need to check whether we have to do this or not
                    set result 0;#[sendCommandsToSimulatorInterfaces -commandList [list "fn 0 LoadTest"]]
               }
               
               if {[regexp "ERROR" $result]} {
                    print -fail "Not able to intialize $simType simulator for test type $testType"
                    return -1
               } else {
                    print -pass "Intialized $simType simulator for test type $testType"
               }
               
               # to avoid cmds sent to bkgnd interfer with current command
               closeSpawnedSessions $simIpAddr "root" "ssh"
          }
     }
     return 0
}

proc configSimulatorLogLevels {args} {
     #-
     #- set simulator log levels
     #- will disable stdout logs since they are not required for scripts
     #-
     parseArgs args \
               [list \
               [list simIpAddr           "mandatory" "ip"           ""        "host ip on which simulator running"] \
               [list testType            "optional" "func|load|loadNew" "func" "testType"] \
               [list simLoc              "optional" "string" "__UN_DEFINED__" "simLocation"] \
               [list simType             "mandatory" "MME|HeNB"     "MME"     "Type of simulator that we are using"] \
               [list logTo               "optional"  "string"       "file"    "enable logging for"] \
               [list fileDebugFilter     "optional"  "true|false"   "false"   "enables/disables debug filter on log file"] \
               [list fileInfoFilter      "optional"  "true|false"   "true"    "enables/disables Info filter on log file" ] \
               [list fileWarnFilter      "optional"  "true|false"   "false"   "enables/disables Warn filter on log file"] \
               [list fileErrorFilter     "optional"  "true|false"   "true"    "enables/disables Error filter on log file"] \
               [list fileFatalFilter     "optional"  "true|false"   "true"    "enables/disables Fatal filter on log file"] \
               ]
     if {$testType == "loadNew" } {
          if {![info exists simLoc] } {
               set simLoc [getLTEParam "${simType}LoadNewPath"]
          }
     } else {
          set simLoc [getLTEParam "${simType}Path"]
     }

     set logFile "$simLoc/SimulatorLog.properties"

     if {$logTo == "file"} {
          set logToPattern "R"
     } else {
          set logToPattern "STDOUT"
     }
     # disabling all stdout logs
     append patternList "-e '/STDOUT.*LogLevelToMatch/ \{ N ; s/true/false/\}'"
     # enable or disable file logs as per request
     foreach level "Debug Info Warn Error Fatal" {
          set userVal [set file${level}Filter]
          append patternList  " -e '/$logToPattern\\\..*LogLevelToMatch=[string toupper $level]/ \{ N ; s/true\\\|false/$userVal/\}'"
     }
     set orgFileName "$simLoc/SimulatorLog.properties.org"
     set preConfigFile "$simLoc/SimulatorLog.properties"
     set cmd "if \[ -f $orgFileName \]; then echo -e \"\\nINFO : Taking original file as reference\\n\"; rm -f $preConfigFile ; \
               cp -f $orgFileName $preConfigFile ; else echo -e \"\\nINFO : Taking backup of original\
               file before modifiying data\\n\"; cp $preConfigFile $orgFileName ; fi"
     set result [execCommandSU -dut $simIpAddr -command $cmd]
     if {[regexp "ERROR:|(No such file)" $result] || $result == -1} {
          print -err "Not able to get the proper file"
          return -1
     } else {
          print -info "successfully retrieved the proper file"
     }
     set cmd "sed -i $patternList $logFile"
     set result [execCommandSU -dut $simIpAddr -command $cmd]
     if {[regexp "ERROR:|(No such file)" $result] || $result == -1} {
          print -err "Not able to update the log levels"
          return -1
     } else {
          print -info "successfully updated log levels as requested on $simIpAddr"
          return 0
     }
}

proc updateSimulatorPath {args} {
     #-
     #- set simulator path information
     #-
     parseArgs args \
               [list \
               [list simIpAddr           "mandatory" "ip"         ""        "host ip on which simulator running"] \
               [list simType             "mandatory" "MME|HeNB"   ""        "simulator is Femto or CN"] \
               [list testType            "optional"  "func|load|loadNew"   "func"    "Type of test that we are going to perform using simulator"] \
               [list simLoc         "optional" "string" "__UN_DEFINED__"        "simLoc"] \
               ]

     if { $testType == "load" } {
          set simLoc [getLTEParam "${simType}LoadPath"]
          set logFile "$simLoc/conf_${simType}.sh"
     } elseif { $testType == "loadNew"} {
          if {![info exists simLoc] } {
               set simLoc [getLTEParam "${simType}LoadNewPath"]
          }
          set logFile "$simLoc/conf_${simType}.sh"
     } else {
          set simLoc [getLTEParam "${simType}Path"]
          set logFile "$simLoc/conf.sh"
     }

     set simType [string map " \
               HeNB HENB  \
               " $simType]

     set simLoc [regsub -all "/" $simLoc "\\\/"]
     if {$testType == "loadNew" } {

          set patternList " \
                    -e 's/LOAD_${simType}_CONFIG_PATH=.*/LOAD_${simType}_CONFIG_PATH=$simLoc/' \
                    -e 's/LOAD_${simType}_LOG_PROPERTIES_PATH=.*/LOAD_${simType}_LOG_PROPERTIES_PATH=$simLoc/' \
                    -e 's/LOAD_${simType}_LOG_PATH=.*/LOAD_${simType}_LOG_PATH=$simLoc\\\/Log/' \
                    "

     } else {
          set patternList " \
                    -e 's/${simType}_CONFIG_PATH=.*/${simType}_CONFIG_PATH=$simLoc/' \
                    -e 's/${simType}_LOG_PROPERTIES_PATH=.*/${simType}_LOG_PROPERTIES_PATH=$simLoc/' \
                    -e 's/${simType}_LOG_PATH=.*/${simType}_LOG_PATH=$simLoc\\\/Log/' \
                    "
     }
     set cmd "rm -f ${logFile}.org \n cp -f $logFile ${logFile}.org \n sed -i $patternList $logFile \n mkdir -p $simLoc/Log/"

     set result [execCommandSU -dut $simIpAddr -command $cmd]
     if {[regexp "ERROR:|(No such file)" $result] || $result == -1} {
          print -err "Not able to update simulator path information"
          return -1
     } else {
          print -info "successfully updated $simType simulator path information on $simIpAddr"
          return 0
     }
}


proc constructNonS1SimCommands {args} {
     #-
     #- constructs other than S1 related simulator commands
     #-
     
     set validCommands "createMME|openSCTPSocket|CloseSCTPAssociation|createHeNB|SendSCTPInit|deleteHeNB|createUE|abortSCTPAssociation|DeleteMME"
     parseArgs args \
               [list \
               [list command           mandatory  $validCommands   "-"                "The Simulator command to be constructed"] \
               [list localMMEId        optional   "string"         "__UN_DEFINED__"   "MME Id used for Simulator Purpose only"] \
               [list MMEName           optional   "string"         "__UN_DEFINED__"   "The MME Name to be used"] \
               [list MMECode           optional   "string"         "__UN_DEFINED__"   "The MME Code to be used"] \
               [list MMEIpaddress      optional   "string"         "__UN_DEFINED__"   "MME End Point IP address to be used"] \
               [list relMMECapacity    optional   "string"         "__UN_DEFINED__"   "The Relative MME Capacity to be used"] \
               [list MMEGroupId        optional   "string"         "__UN_DEFINED__"   "The MME group ID to be used"] \
               [list MCC               optional   "string"         "__UN_DEFINED__"   "The MCC param to be used"] \
               [list MNC               optional   "string"         "__UN_DEFINED__"   "The MNC param to be used"] \
               [list MMESCTPPortNumber optional   "string"         "__UN_DEFINED__"   "The MME SCTP Port Number to be used"] \
               [list tunnelEndPointId  optional   "string"         "__UN_DEFINED__"   "The TunnelEndPointId to be used"] \
               [list MMEUserplaneIp    optional   "string"         "__UN_DEFINED__"   "The MME Userplane IP to be used"] \
               [list maxAttempts       optional   "string"         "__UN_DEFINED__"   "The Maximum number of SCTP Init will be sent"] \
               [list numOutStreams     optional   "numeric"        "512"              "Max number of Outgoing Streams will be sent in a SCTP session"] \
               [list numInStreams      optional   "numeric"        "512"              "Max number of incoming Streams will be sent in a SCTP session"] \
               [list s1streamno        optional   "numeric"        "__UN_DEFINED__"   "Stream Number to be used for S1 message"] \
               [list sendBufSize       optional   "numeric"        "__UN_DEFINED__"   "Buffer Size on the sending direction"] \
               [list recvBufSize       optional   "numeric"        "__UN_DEFINED__"   "Buffer Size on the receiving direction"] \
               [list MMEUserplaneIp    optional   "string"         "__UN_DEFINED__"   "The MME Userplane IP to be used"] \
               [list HeNBId            optional   "string"         "__UN_DEFINED__"   "The HeNBId to be used"] \
               [list HeNBMCC           optional   "string"         "__UN_DEFINED__"   "The HeNB MCC to be used"] \
               [list HeNBMNC           optional   "string"         "__UN_DEFINED__"   "The HeNB MNC to be used"] \
               [list HeNBName          optional   "string"         "__UN_DEFINED__"   "The HeNB Name to be used"] \
               [list HeNBIp            optional   "string"         "__UN_DEFINED__"   "The HeNB Ip to be used"] \
               [list HeNBSCTP          optional   "string"         "__UN_DEFINED__"   "The HeNB SCTP to be used"] \
               [list pagingDRX         optional   "string"         "__UN_DEFINED__"   "The paging DRX to be used in HeNB"] \
               [list isENB             optional   "string"         "__UN_DEFINED__"   "Is ENB to be used in HeNB"] \
               [list CSGId             optional   "string"         "__UN_DEFINED__"   "The CSGId to be used in HeNB"] \
               [list TA                optional   "string"         "__UN_DEFINED__"   "The TAs to be used in HeNB"] \
               [list GWIp              optional   "string"         "__UN_DEFINED__"   "The GWIp to be used"] \
               [list GWSCTP            optional   "string"         "__UN_DEFINED__"   "The GWSCTP to be used"] \
               [list MMEIpaddress      optional   "string"         "__UN_DEFINED__"   "The MMEIPAddress to be used"] \
               [list localIpAddrCount  optional   "string"         "__UN_DEFINED__"   "The localIpAddrCount to be used"] \
               [list ueId              optional   "string"         "__UN_DEFINED__"   "The UE ID to be created"] \
               [list streamid          optional   "string"         "__UN_DEFINED__"   "The stream id for the user"] \
               ]
     
     set validArgs ""
     global ARR_LTE_TEST_PARAMS

     switch -nocase $command {
          "createMME" {
               set validArgs "CreateMME MMEId=localMMEId  MMMEIpAddr=MMEIpaddress MMEPort=MMESCTPPortNumber "
          }
          "DeleteMME" {
               set validArgs "DeleteMME MMEId=localMMEId  MMMEIpAddr=MMEIpaddress MMEPort=MMESCTPPortNumber "
          }
          "openSCTPSocket" {
               set validArgs "OpenSCTPSocket outStreams=numOutStreams inStreams=numInStreams MMEId=localMMEId"
          }
          "CloseSCTPAssociation" {
               set validArgs "CloseSCTPAssociation HeNBId=HeNBId MMEId=localMMEId gwIP=GWIp gwPort=GWSCTP"
          }
          "createHeNB" {
               set validArgs "Createhenb HeNBId=HeNBId HeNBIPAddr=HeNBIp HeNBPort=HeNBSCTP"
          }
          "SendSCTPInit" {
               if {[info exists ARR_LTE_TEST_PARAMS(assocID)]} { set assocID $ARR_LTE_TEST_PARAMS(assocID) }
               set validArgs "SendSCTPInit HeNBId=HeNBId  outStreams=numOutStreams inStreams=numInStreams gwIP=GWIp gwPort=GWSCTP assocID=assocID"
          }
          "deleteHeNB" {
               set validArgs "DeleteHeNB HeNBId=HeNBId"
          }
          "createUE" {
               set validArgs "CreateUE ueid=ueId streamid=streamid HeNBId=HeNBId"
          }
          "abortSCTPAssociation" {
               set validArgs "AbortSCTPAssociation HeNBId=HeNBId"
          }
     }
     
     return [updateVals $validArgs]
}

proc createMME {args} {
     #-
     #- creates MME object on MME simulator interface and listens on SCTP socket
     #-
     #- return 0 on success and -1 on failure
     #-
     
     set dfOperation "create open"
     parseArgs args \
               [list \
               [list fgwNum               optional   "numeric" "0"                        "The FGW number"] \
               [list noOfMMEs             optional   "string"  "1"                        "No of MMEs to be created"] \
               [list MMEIndex             optional   "string"  "0"                        "No of MMEs to be created"] \
               [list operation            optional   "string"   "$dfOperation"            "The operation to be performed"] \
               [list MMECode              optional   "string"  [getLTEParam "MMECode"]    "The MME Code to be used"] \
               [list MMEGroupId           optional   "string"  [getLTEParam "MMEGroupId"] "The MME Group Id to be used"] \
               [list MCC                  optional   "string"  [getLTEParam "MCC"]        "The MCC param to be used"] \
               [list MNC                  optional   "string"  [getLTEParam "MNC"]        "The MNC param to be used"] \
               [list maxAttempts          optional   "numeric" "__UN_DEFINED__"           "maxAttempts of SCTP" ] \
               [list numOutStreams        optional   "numeric" "__UN_DEFINED__"           "Number of SCTP outstreams on MME"] \
               [list numInStreams         optional   "numeric" "__UN_DEFINED__"           "Number of SCTP instreams on MME"]\
               [list streamId             optional   "numeric" "__UN_DEFINED__"           "Stream Number to be used for S1 message"]\
               [list localMMEMultiHoming  optional   "yes|no"  "no"                       "To eanble multihoming towards MME on gw"]\
               [list remoteMMEMultiHoming optional   "yes|no"  "no"                       "To eanble multihoming on MME sim"]\
               [list verify               optional   "boolean" "yes"                      "To verify if the state is proper"] \
               [list noOfRetries          optional   "numeric" "__UN_DEFINED__"           "Number of retries to verify the state"] \
               [list retryTimeout         optional   "numeric" "__UN_DEFINED__"           "Retry timout within the retries"] \
               ]
     
     set MMECode    [join $MMECode ","]
     set MMEGroupId [join $MMEGroupId ","]
     set MCC        [join $MCC ","]
     set MNC        [join $MNC ","]
     
     if { $::ROUTING_TB == "yes" } {
          set HeNBGwIpAddress   [getDataFromConfigFile getMmeSimCp1Ipaddress $fgwNum]
     } else {
          set HeNBGwIpAddress   [getDataFromConfigFile getMmeCp1Ipaddress $fgwNum]
     }
     set HeNBGwSCTPPort    [getDataFromConfigFile mmeSctp $fgwNum]
     set hostIp            [getActiveBonoIp $fgwNum]
     set MMECode [split $MMECode ","]
     set MMECodelist $MMECode
     set MMEIpaddressList $HeNBGwIpAddress
     #Following logic is added to avoid IP address reaching x.x.x.255 or x.x.x.0 or x.x.x.1
     set ip $HeNBGwIpAddress
     set ip [incrIp $ip]
     for {set i 1 } {$i < $noOfMMEs } {incr i } {
                    set ip [incrIp $ip]
                    set x [regexp {([0-9]+).([0-9]+).([0-9]+).([0-9]+)} $ip match a b c d]
                    while {$d == 255 || $d == 0 || $d == 1 } {
                          set ip [incrIp $ip]
                          set x [regexp {([0-9]+).([0-9]+).([0-9]+).([0-9]+)} $ip match a b c d]
                    }
                    set MMEIpaddressList [lappend MMEIpaddressList $ip]
     }

 
     for {set i $MMEIndex} { $i < [expr $noOfMMEs + $MMEIndex]} { incr i } {
          set MMEId      [getFromTestMap -MMEIndex $i -param "MMEId"]
          #Using same SCTP port for all MMEs, but different Ip addresses
          set MMESCTPPortNumber [expr $HeNBGwSCTPPort + 1]
          if {$remoteMMEMultiHoming == "yes"} {
               if { $::ROUTING_TB == "yes" } {
                     
                    #In routing setup, switchIpAddr is increment of getMmeSimCp1Ipaddress/getMmeSimCp2Ipaddress
                    if {$i >= 1} {
                         set inc [expr $i + 1]
                    } else {
                         set inc $i
                    }
                    
                    set HeNBGwIpAddress2   [getDataFromConfigFile getMmeSimCp2Ipaddress $fgwNum]
                    set MMEIpaddress1      [incrIp $HeNBGwIpAddress  $inc ]
                    lappend MMEIpaddress1  [incrIp $HeNBGwIpAddress2 $inc ]
                    set MMEIpaddress       [join $MMEIpaddress1 ,]
               } else {
                    set HeNBGwIpAddress2   [getDataFromConfigFile getMmeCp2Ipaddress $fgwNum]
                    set MMEIpaddress1      [incrIp $HeNBGwIpAddress [expr $i + 1]]
                    lappend MMEIpaddress1  [incrIp $HeNBGwIpAddress2 [expr $i + 1]]
                    set MMEIpaddress       [join $MMEIpaddress1 ,] 
               }
               set localIpAddrCount 2
          } else {
               if { $::ROUTING_TB == "yes" } {
                    #In routing setup, switchIpAddr is increment of getMmeSimCp1Ipaddress/getMmeSimCp2Ipaddress
                    if {$i >= 1} {
                         set inc [expr $i + 1]
                    } else {
                         set inc $i
                    }
#                    set MMEIpaddress      [incrIp $HeNBGwIpAddress  $inc ]
      	             set MMEIpaddress      [lindex $MMEIpaddressList $i]
               }  else {
                    set MMEIpaddress      [incrIp $HeNBGwIpAddress [expr $i + 1]]
               }
          }
 
          set GWIp   [getDataFromConfigFile "getMmeCp1Ipaddress" $fgwNum]
          set GWSCTP [getDataFromConfigFile "henbSctp" $fgwNum]

          foreach op $operation {
               switch $op {
                    "create" {
                         set command  "createMME"
		         set MMECode [lindex $MMECodelist $i]
                         if {$remoteMMEMultiHoming == "yes"} {
                              set simCmd   [updateValAndExecute "constructNonS1SimCommands -command command -MMECode MMECode \
                                        -MMEGroupId MMEGroupId -MMESCTPPortNumber MMESCTPPortNumber -MCC MCC -MNC MNC \
                                        -MMEIpaddress MMEIpaddress -localMMEId MMEId \
                                        -localIpAddrCount localIpAddrCount"]
                         } else {
                              set simCmd   [updateValAndExecute "constructNonS1SimCommands -command command -MMECode MMECode \
                                        -MMEGroupId MMEGroupId -MMESCTPPortNumber MMESCTPPortNumber -MCC MCC -MNC MNC -localMMEId MMEId \
                                        -MMEIpaddress MMEIpaddress"]
                         }
                         set toVerify "MME Created"
                         set toPrint  "Create MME"
                    }
                    "open" {
                         set command   "openSCTPSocket"
                         #openSCTPSocket maxattempts=maxAttempts numoutstreams=numOutStreams numinstreams=numInStreams sendbufsize=1024 recvbufsize=1024
                         set simCmd   [updateValAndExecute "constructNonS1SimCommands -command command -localMMEId MMEId \
                                   -maxAttempts maxAttempts -numOutStreams numOutStreams -numInStreams numInStreams -s1streamno streamId"]
                         set toVerify "SCTP Association Up|SCTP Stack Up|MME Created"
                         set toPrint  "bring SCTP association up"
                    }
                    "close" {
                         set command "CloseSCTPAssociation"
                         #set simCmd  [updateValAndExecute "constructNonS1SimCommands -command command -localMMEId MMEId -GWIp GWIp -GWSCTP GWSCTP"]
                         set simCmd  [updateValAndExecute "constructNonS1SimCommands -command command -localMMEId MMEId"]
                         set toVerify "SCTP Association Down|SCTP Stack Down|SCTP_DOWN"
                         set toPrint  "bring SCTP association down"
                    }
                    "delete" {
                         set command   "DeleteMME"
                         set simCmd  [updateValAndExecute "constructNonS1SimCommands -command command -localMMEId MMEId"]
                         set toVerify "ERROR : MME Not Created"
                         set toPrint  "Delete MME"
                    }
                    "abort" {
                         set command "abortSCTPAssociation"
                         set simCmd  [updateValAndExecute "constructNonS1SimCommands -command command -localMMEId MMEId"]
                         set toVerify "SCTP Association Down|SCTP Stack Down|SCTP_DOWN"
                         set toPrint  "Aborting MME SCTP association"
                    }
               }
               set result [executeLteSimulatorBkdoorCmd -simType "MME" -command $simCmd -MMEIndex $i]
               if {[regexp "ERROR: " $result]} {
                    print -fail "Failed to $toPrint on MME simulator"
                    return -1
               } else  {
                    print -info "Successfull in $toPrint on MME simulator"
               }
               
               #Getinfo syntax to be revisited once we know the exact syntax
               #Also output needs to be parsed
               if {![info exists noOfRetries] && ![info exists retryTimeout]} {
                    switch -regexp $op {
                         "create|delete|close" {
                              set noOfRet   1
                              set retryTime 1
                         }
                         default {
                              set noOfRet   6
                              set retryTime 5
                         }
                    }
               } else {
                    set noOfRet   $noOfRetries
                    set retryTime $retryTimeout
               }
               
               if {$noOfMMEs > 2} {
                    #adding this check, as in case of multiple mme creation,as halt 5 makes duplicate s1setups on mme sims
                    #verify getstate only for last mme launched
                    if {$i == [expr $noOfMMEs +$MMEIndex -1]} {
                         print -info "Verifying getstate for the last MME instance ..."
                         set verify "yes"
                    } else {
                         set verify "no"
                         set fail 0
                    }
               }
               if {[regexp "create" $op]} { 
                  halt 15
                  #halt 60
               }
               if {[regexp "open" $op]} {
                  halt 10
                  #halt 60
               }

             
               ### The below line is added by ankit as Getstate command is not provided in New Sim 
               set verify "no" 
               #If verify is enabled, verify the state
               if {$verify == "yes"} {
                    for {set retryNo 1;set fail 1} {$retryNo <= $noOfRet} {incr retryNo} {
                         print -info "Successfully retrieved and validated MME info on MME simulator"
                         if {$op == "delete"} {
                              print -nonewline "For the sim state to reinitialize ... "
                              halt 2
                         }
                         set command "GetState"
                         set simCmd [executeLteSimulatorBkdoorCmd -simType "MME" -command $command \
                                   -MMEIndex $i]
                         if {[regexp "close|delete" $op]} {
                              # A close on MME simulator would temproraly close the sctp connection
                              # So we cannot verify the sctp state, so skipping the verification
                              set fail 0
                              break
                         } elseif {[regexp "ERROR: " $simCmd] } {
                              print -fail "Failed to retrieve MME info on MME simulator"
                              return -1
                         } elseif {[regexp -nocase $toVerify $simCmd]} {
                              set fail 0
                              break
                         }
                         halt $retryTime
                    }
               }
               ### The below line is added by ankit as Getstate command is not provided in New Sim and hence fail is not set anywhere
               set fail 0
               if {$fail} {
                    print -fail "Improper state of $op ; expected=$toVerify"
                    if {$op == "open"} {
                         dumpHeNBGwState  "mme henb"
                         dumpNetworkState -hostIp $hostIp
                    }
                    return -1
               }
          }
     }
     return 0
}

proc createHeNB {args} {
     #-
     #- creates an HeNB object in the HeNB simulator
     #-
     #- @return 0 on success and -1 on failure
     #-
    
     global ARR_LTE_TEST_PARAMS  
     set dfOperation "create"
     parseArgs args \
               [list \
               [list fgwNum            optional   "numeric"   "0"                 "The FGW number"] \
               [list HeNBIndex         optional   "numeric"   "0"                 "The HeNB index to be configured"] \
               [list noOfHeNBs         optional   "string"    "1"                 "No of MMEs to be created"] \
               [list operation         optional   "string"    "$dfOperation"      "The operation to be performed"] \
               [list maxAttempts       optional   "numeric"   "__UN_DEFINED__"    "maxAttempts of SCTP" ] \
               [list streamId          optional   "numeric"   "__UN_DEFINED__"    "Stream Number to be used for S1 message"]\
               [list numOutStreams     optional   "numeric"   "__UN_DEFINED__"    "Number of SCTP outstreams on HeNB"] \
               [list numInStreams      optional   "numeric"   "__UN_DEFINED__"    "Number of SCTP instreams on HeNB"]\
               [list localHeNBMultiHoming optional "yes|no"    "no"               "To eanble multihoming towards HeNB on gw"]\
               [list verify            optional   "boolean"   "yes"               "To verify if the state is proper"] \
               [list noOfRetries          optional   "numeric" "__UN_DEFINED__"           "Number of retries to verify the state"] \
               [list retryTimeout         optional   "numeric" "__UN_DEFINED__"           "Retry timout within the retries"] \
               ]
     
     set fail   0
     set GWIp   [getDataFromConfigFile "getHenbCp1Ipaddress" $fgwNum]
     set GWSCTP [getDataFromConfigFile "henbSctp" $fgwNum]
     set HeNBIp   [getDataFromConfigFile "getHenbSimCpIpaddress" $fgwNum]

     set assocID 1
     set ARR_LTE_TEST_PARAMS(assocID) $assocID
     
     for {set i $HeNBIndex} { $i < [expr $noOfHeNBs + $HeNBIndex]} { incr i } {
          set HeNBId      [getFromTestMap -HeNBIndex $i -param "HeNBId"]
          set fgwHeNBSCTP [getDataFromConfigFile "henbSctp" $fgwNum]
          set HeNBSCTP    [expr $fgwHeNBSCTP + $i + 1]
          
          foreach op $operation {
               switch $op {
                    "create" {
                         set command  "createHeNB"
                         set simCmd   [updateValAndExecute "constructNonS1SimCommands -command command \
                                       -HeNBIp HeNBIp -HeNBId HeNBId -HeNBSCTP HeNBSCTP"]
                         set toVerify "HeNB Created"
                         set toPrint  "Create HeNB"
                    }
                    "send" {
                         set command   "SendSCTPInit"
                         set simCmd   [updateValAndExecute "constructNonS1SimCommands -command command -HeNBId HeNBId\
                                   -maxAttempts maxAttempts -numOutStreams numOutStreams -numInStreams numInStreams \
                                   -GWIp GWIp -GWSCTP GWSCTP -s1streamno streamId -assocID assocID"]
                         set toVerify "SCTP Association Up|SCTP Stack Up"
                         set toPrint  "bring SCTP association up"
                         
                    }
                    "close" {
                         set command "CloseSCTPAssociation"
                         set simCmd   [updateValAndExecute "constructNonS1SimCommands -command command -HeNBId HeNBId -GWIp GWIp -GWSCTP GWSCTP"]
                         set toVerify "SCTP Association Down|SCTP Stack Down|SCTP_DOWN"
                         set toPrint  "bring SCTP association down"
                    }
                    "delete" {
                         set command "deleteHeNB"
                         set simCmd   [updateValAndExecute "constructNonS1SimCommands -command command -HeNBId HeNBId"]
                         #set toVerify "Invalid HeNBId value"
                         #If ERROR message is seen in the output during command execution
                         #the following string is returned - Failed to execute on simulator
                         set toVerify "Failed to execute on simulator"
                         set toPrint  "Delete HeNB"
                    }
                    "abort" {
                         set command "abortSCTPAssociation"
                         set simCmd  [updateValAndExecute "constructNonS1SimCommands -command command -HeNBId HeNBId -GWIp GWIp -GWSCTP GWSCTP"]
                         set toVerify "SCTP Association Down|SCTP Stack Down|SCTP_DOWN"
                         set toPrint  "Delete HeNB"
                    }
                    
               }
               
               # Hack to check the SCTP Master port on the HeNBGW before sending the SCTP init
               if {$op == "send"} {
                    set sctpPort [getDataFromConfigFile "henbSctp" $fgwNum]
                    set fgwIp    [getActiveBonoIp $fgwNum]
                    print -info "Ensuring sctp port is listening on HeNBGW before sending SCTP INIT"
                    set retryFail 0
                    set noOfRet   10
                    set retInt    2
                    for {set retry 1} {$retry <= $noOfRet} {incr retry} {
                         set result [checkSctpPort -hostIp $fgwIp -localSctpPort $sctpPort -state "listen"]
                         if {$result != 0} {
                              print -fail "ITTERATION: $retry SCTP port $sctpPort is not present on HeNBGW"
                              set retryFail 1
                         } else {
                              print -pass "ITTERATION: $retry SCTP port $sctpPort is present on HeNBGW"
                              break
                         }
                         print -nonewline "To retry .. "
                         halt $retInt
                    }
                    if {$retryFail} {
                         print -fail "SCTP port is not is listening state on HeNBGW after [expr $noOfRet * $retInt] seconds retry too ... "
                         exit 1
                    }
               }
               set result [executeLteSimulatorBkdoorCmd -simType "HeNB" -command $simCmd]
               if {[regexp "ERROR: " $result]} {
                    print -fail "Failed to $toPrint on HeNB simulator"
                    return -1
               } else  {
                    print -info "Successfull in $toPrint on HeNB simulator"
               }
               
               #Getinfo syntax to be revisited once we know the exact syntax
               #Also output needs to be parsed
               if {![info exists noOfRetries] && ![info exists retryTimeout]} {
                    if {[regexp "create|delete" $op]} {
                         set noOfRet  1
                         set retryTime 1
                    } else {
                         set noOfRet  5
                         set retryTime 1
                    }
               } else {
                    set noOfRet   $noOfRetries
                    set retryTime $retryTimeout
               }
             
               ### The below line is added by ankit as Getstate command is not provided in New Sim 
               set verify "no" 
               #If verify is enabled, verify the state
               if {$verify == "yes"} {
                    for {set retryNo 1;set fail 1} {$retryNo <= $noOfRet} {incr retryNo} {
                         set command "GetState HeNBId=$HeNBId"
                         set simCmd [executeLteSimulatorBkdoorCmd -simType "HeNB" -command $command]
                         if {[regexp "ERROR: " $simCmd] && $op != "delete"} {
                              print -fail "Failed to retrieve HeNB info on HeNB simulator"
                              return -1
                         } elseif {[regexp -nocase $toVerify $simCmd]} {
                              set fail 0
                              print -info "Successfully retrieved and validated HeNB info on HeNB simulator"
                              break
                         }
                         halt $retryTime
                    }
               }
               if {$fail} {
                    print -fail "Improper state of $op ; expected=$toVerify"
                    return -1
               }
          }
     }
     return 0
}

proc createDummyUE {args} {
     #-
     #- creates an dummy UE context on the MME simulator
     #-
     #- return 0 on success and -1 on failure
     #-
     
     parseArgs args \
               [list \
               [list fgwNum       optional   "numeric" "0"      "The FGW number"] \
               [list ueId         optional   "string"  "1"      "The UE id to be created"] \
               [list streamid     optional   "string"  "0"      "The stream id for the user"] \
               [list henbid       optional   "string"  "0"      "The stream id for the user"] \
               [list simType      optional   "MME|HeNB" "0"     "The stream id for the user"] \
               [list MMEIndex     optional   "numeric"  "0"     "The Index of MME sim instance"] \
               [list HeNBIndex    optional   "numeric"  "0"     "The Index of HeNB sim instance"] \
               [list verify       optional   "boolean" "yes"    "To verify if the state is proper"] \
               ]
     
     set command "createUE"
     if { $simType == "MME" } {
          set simCmd   [updateValAndExecute "constructNonS1SimCommands -command command -streamid streamid -ueId ueId"]
     } else {
          set simCmd   [updateValAndExecute "constructNonS1SimCommands -command command -streamid streamid -ueId ueId -HeNBId henbid"]
     }
     set result [executeLteSimulatorBkdoorCmd -simType $simType -command $simCmd -${simType}Index [set ${simType}Index]]
     if {[regexp "ERROR: " $result]} {
          print -fail "Failed to create dummy UE context "
          return -1
     } else  {
          print -info "Successfull created dummy UE context "
     }
     #As of now there is no way to verify the created UE context
     return 0
     
}

proc getState {args} {
     #-
     #- verifies the state of simulator
     #-
     #- return 0
     
     parseArgs args \
               [list \
               [list fgwNum            optional   "numeric"   "0"                "The FGW number"] \
               [list op                optional   "string"    "close"            "The operation to be verified"] \
               [list HeNBIndex         optional   "numeric"   "__UN_DEFINED__"   "Index of HeNB to be verified"] \
               [list MMEIndex          optional   "numeric"   "__UN_DEFINED__"   "Index of MME to be verified"] \
               [list noOfRetries       optional   "numeric"   "1"                "Number of retries to verify the state"] \
               [list retryTimeout      optional   "numeric"   "1"                "Retry timout within the retries"] \
               ]
     
     if {[info exists HeNBIndex]} {
          set simType "HeNB"
          #Below line added by ankit as Get state in not working in New Sim
          set command "GetHeNBInfo"
     }
     if {[info exists MMEIndex]} {
          set simType "MME"
          #Below line added by ankit as Get state in not working in New Sim
          set command "GetMMEInfo"
     }
     switch $op {
          "close" {
               set toVerify "SCTP Association Down|SCTP Stack Down|SCTP_DOWN"
               set toPrint  "bring SCTP association down"
          }
          "delete" {
               #If ERROR message is seen in the output during command execution
               #the following string is returned - Failed to execute on simulator
               #instead of Invalid HeNBId value.
               #set toVerify "Failed to execute on simulator"
               set toVerify ""
               set toPrint  "Delete HeNB"
          }
          "open" {
               set toVerify "SCTP Association Up|SCTP Stack Up"
               set toPrint  "bring SCTP association up"
          }
          "default" {}
     }
     #set command "GetState"
     if {[info exists HeNBIndex]} {
          set HeNBId [getFromTestMap -HeNBIndex $HeNBIndex -param "HeNBId"]
          append command " HeNBId=$HeNBId"
     }
     
     set flag 0
     for {set retry 1} {$retry <= $noOfRetries} {incr retry} {
          set simCmd [executeLteSimulatorBkdoorCmd -simType $simType -command $command -${simType}Index [set ${simType}Index]]
          if {[regexp "ERROR: " $simCmd] && $op != "delete"} {
               print -fail "($retry) Failed to retrieve info on $simType simulator"
               set flag 1
          } elseif {[regexp -nocase $toVerify $simCmd]} {
               print -info "($retry) Successfully retrieved and validated $simType info on $simType simulator"
               return 0
          } else {
               print -fail "($retry) Validation of $simType state info $toVerify failed"
               set flag 1
          }
          if {$retry != $noOfRetries} {
               print -nonewline "To retry ... "
               halt $retryTimeout
          }
     }
     if {$flag} {return -1}
     return 0
}

proc closeLTESimulators {args} {
     #-
     #- will close all LTE simulators that are running on the simulator host
     #-
     #- return 0
     
     set fgwNum 0
     set allSims "HeNB MME"
     
     foreach simType $allSims {
          set simAppln [getLTEParam "${simType}Appln"]
          set simIpAddr [getDataFromConfigFile "get[string totitle $simType]SimulatorHostIp" $fgwNum]
          print -dbg "Terminate if any $simAppln application running $simIpAddr ..."
          set result [closeActiveThreads $simAppln $simIpAddr "9" "all"]
     }
     return 0
}

proc resetEntity {args} {
     #-
     #- will reset the MME
     #-
     #- @return 0 on success and -1 on failure
     
     set validResetTypes "sctpReset soft hard intFailure primary secondary intPrimary intSecondary"
     parseArgs args \
               [list \
               [list fgwNum            optional   "numeric" 		        "0"                 "The FGW number"] \
               [list entity            mandatory  "mme|henb|MME|HeNB|switch|HeNBGW"    "_"                 "The Entity to be reset"] \
               [list typeOfReset       optional   "[join $validResetTypes |]"   ""                  "The type of reset to be done"] \
               [list downTime          optional   "numeric"                     "__UN_DEFINED__"    "The downtime for the entity"] \
               [list operation         optional   "down|up|reset"               "down"              "The downtime for the entity"] \
               [list MMEIndex          optional   "numeric"    			"0" 		     "The MME instance to send the message to"] \
               [list HeNBIndex         optional   "numeric"        		"0"                  "The HeNB Index" ] \
               [list chainName         optional   "string"        		"OUTPUT"              "The chain name" ] \
               [list vlan              optional   "boolean"        		"no"                "To perform the operation on vlan interface or not" ] \
               ]
     
     set simAppln  [getLTEParam "${entity}Appln"]
     set simIpAddr [getDataFromConfigFile "get[string totitle $entity]SimulatorHostIp" $fgwNum]
     
     # A reset operation requires the downtime for the system
     # Specify a default downtime if not passed by user
     if {$operation == "reset"} {
          if {![info exists downTime]} {
               print -info "Setting the default downtime to 10 secs"
               set downTime 10
          }
          set operation "down up"
     }
     
     switch -regexp $typeOfReset {
          "sctpReset|soft" {
               switch -regexp $entity {
                    "MME" {
                         # An SCTPreset involves sending an SCTP down event from simulator
                         # A soft reboot is similar to an SCTPreset but also involves deleting/creation the sim instance
                         foreach op $operation {
                              if {$typeOfReset == "sctpReset"} {
                                   switch -regexp $op {
                                        "down" {set op "close"}
                                        "up"  {set op "open" }
                                   }
                              } else {
                                   switch -regexp $op {
                                        "down" {set op "close delete"}
                                        "up"   {set op "create open" }
                                   }
                              }
                              # perform the operation on the MME Simulator
                              set result [createMME -fgwNum $fgwNum -MMEIndex $MMEIndex -operation $op]
                              if {$result < 0} {
                                   print -fail "Sctp reset failed for MME"
                                   return -1
                              } else {
                                   print -pass "Sucessfully did a SCTP reset for MME"
                              }
                              if {[info exists downTime] && ($op == "down")} {
                                   print -nonewline "For $entity to recover ... "
                                   halt $downTime
                              }
                         }
                    }
                    "HeNB" {
                         # An SCTPreset involves sending an SCTP down event from simulator
                         # A soft reboot is similar to an SCTPreset but also involves deleting/creation the sim instance
                         foreach op $operation {
                              if {$typeOfReset == "sctpReset"} {
                                   switch -regexp $op {
                                        "down" {set op "close"}
                                        "up"   {set op "send" }
                                   }
                              } else {
                                   switch -regexp $op {
                                        "down" {set op "close delete"}
                                        "up"   {set op "create send" }
                                   }
                              }
                              # perform the operation on the HeNB simulator
                              set result [createHeNB -fgwNum $fgwNum -HeNBIndex $HeNBIndex -operation $op]
                              if {$result < 0} {
                                   print -fail "SCTP reset failed for HeNB"
                                   return -1
                              } else {
                                   print -pass "Sucessfully did a SCTP reset for HeNB"
                              }
                              if {[info exists downTime] && ($op == "down")} {
                                   print -nonewline "For $entity to recover ... "
                                   halt $downTime
                              }
                         }
                    }
               }
          }
          "hard" {
               # A hard reboot of the entity here involves killing
               # and spawning of active simulator instance
               switch -regexp $entity {
                    "MME" {
                         set dbgPort [expr [getLTEParam MMESimDbgPort] + $MMEIndex]
                    }
                    "HeNB" {
                         set dbgPort [getLTEParam HeNBSimDbgPort]
                    }
               }
               foreach op $operation {
                    if {$op == "down"} {
                         #Kill the $simAppln application
                         set result [closeActiveThreads "$simAppln.*$dbgPort" $simIpAddr "9" "all"]
                         if {$result < 0} {
                              print -fail "Closing the $simAppln failed"
                              return -1
                         }
                    } else {
                         #Start the application again
                         set result [launchLTESimulators -fgwNum $fgwNum -simList $entity \
                                   -HeNBIndex $HeNBIndex -MMEIndex $MMEIndex]
                         if {$result < 0} {
                              print -fail "Launching the simulator instance failed"
                              return -1
                         }
                    }
                    if {[info exists downTime] && ($op == "down")} {
                         print -nonewline "For $entity to recover ... "
                         halt $downTime
                    }
                    
               }
          }
          "intFailure" {
               # The interface failure could be initiated either on the simulator interface,
               # the switch or on the HeNBGW itself
               set failureScenarios "HeNBGW|HeNB|MME|switch"
               parseArgs args \
                         [list \
                         [list switchNum     optional   "numeric" 		"0"             "Switch num in the configuration file"]\
                         [list failureOn     optional   "$failureScenarios"     "$entity"       "The failure to be initiated on"] \
                         ]
               
               # port connected to gateway
               set fgwIp  [getActiveBonoIp $fgwNum]
               set gwPort [getDataFromConfigFile getSwitchMalbanPort $fgwNum $switchNum]
               
               switch $entity {
                    "HeNB"  {
                         set simIp      [getDataFromConfigFile "getHenbSimulatorHostIp" $fgwNum]
                         set simInt     [getDataFromConfigFile "getHenbSimCpHostPort" $fgwNum]
                         set simVlanInt [getDataFromConfigFile "getHenbSimCpVlan" $fgwNum]
                         set portOnGw   [getDataFromConfigFile "getHenbCp1Port" $fgwNum]
                         set swInt      [getDataFromConfigFile "get[string totitle $entity]SimCpSwitchPort" $fgwNum $switchNum]
                         set destGwAddr [getDataFromConfigFile "getHenbCp1Ipaddress" $fgwNum]
                         set gwAddr     [getDataFromConfigFile "getHenbSimCpIpaddress" $fgwNum]
                    }
                    "MME" {
                         set simIp      [getDataFromConfigFile "getMmeSimulatorHostIp" $fgwNum]
                         set simInt     [getDataFromConfigFile "getMmeSimulatorHostPort" $fgwNum]
                         set simVlanInt [getDataFromConfigFile "getMmeSimCp1Vlan" $fgwNum]
                         set portOnGw   [getDataFromConfigFile "getMmeCp1Port" $fgwNum]
                         set swInt      [getDataFromConfigFile "get[string totitle $entity]SimCp1SwitchPort" $fgwNum $switchNum]
                         set destGwAddr [getDataFromConfigFile "getMmeCp1Ipaddress" $fgwNum]
                         set gwAddr     [getDataFromConfigFile "getMmeSimCp1Ipaddress" $fgwNum]
                    }
               }
               
               # Induce failure
               switch -regexp $failureOn {
                    "HeNBGW" {
                         foreach op $operation {
                              # Administratively bring down or up of the interface on HeNBGW
                              set result [execCommandSU -dut $fgwIp -command "ifconfig $portOnGw $op"]
                              if {[regexp "ERROR" $result] || $result == -1} {
                                   print -fail "Failed to get the interface in $op state"
                                   return -1
                              } else {
                                   print -pass "Brought the interface to $op state"
                              }
                              
                              if {[info exists downTime] && ($op == "down")} {
                                   print -nonewline "For $entity to recover ... "
                                   halt $downTime
                              }
                         }
                    }
                    "HeNB|MME" {
                         # Administratively bring down or up of the interface on the HeNB or the MME Simulator
                         foreach op $operation {
                              if { $vlan == "yes" } {
                                   set simInt $simInt.$simVlanInt
                              }
                              set result [execCommandSU -dut $simIp -command "ifconfig $simInt $op"]
                              if {[regexp "ERROR" $result] || $result == -1} {
                                   print -fail "Failed to get the interface in $op state"
                                   return -1
                              } else {
                                   print -pass "Brought the interaface to $op state"
                              }
                              if {[info exists downTime] && ($op == "down")} {
                                   print -nonewline "For $entity to recover ... "
                                   halt $downTime
                              }

                              if {$op == "up"} {
                                 set mask 255.255.255.0
                                 set destNwrk  [join [ lreplace [ split [ lindex $destGwAddr 0] . ] end end 0 ] . ]
                                 set cmd "route add -net $destNwrk netmask $mask gw [incrIp $gwAddr -1]"
                                 set result [execCommandSU -dut $simIp -command $cmd ]
                                 if {[regexp "ERROR" $result] || $result == -1} {
                                   print -fail "Failed to add the route entry"
                                   return -1
                                 } else {
                                   print -pass "Successfully added the route entry"
                                 }
                              }

                         }
                         
                    }
                    "switch" {
                         # Administratively bring down or up of the port on the switch
                         foreach op $operation {
                              set result [switchPortOp -switchNum $switchNum -port $gwPort -operation $op]
                              if {$result < 0} {
                                   print -fail "Failed to bring the port $gwPort to $op state"
                                   return -1
                              } else {
                                   print -pass "Port $gwPort is now in $op state"
                              }
                              if {[info exists downTime] && ($op == "down")} {
                                   print -nonewline "For $entity to recover ... "
                                   halt $downTime
                              }
                         }
                    }
               }
          }
          
          "primary|secondary" {
               #Simulate the interface shutdown by droping the packets on simulator ; Implemented using the Iptables.
               switch -regexp [string toupper $entity] {
                    
                    "HENB|MME"  {
                         
                         if { [ regexp -nocase "MME"  $entity ]}  { set simIp  [getDataFromConfigFile "getMmeSimulatorHostIp" $fgwNum]}
                         if { [ regexp -nocase "HeNB" $entity]}   { set simIp  [getDataFromConfigFile "getHenbSimulatorHostIp" $fgwNum]}
                         
                         set ifaceToShutDown [ getIpAndPortForPrimSecondaryIface -dut $simIp -interfaceType $typeOfReset \
                                   -entity $entity  -MMEIndex $MMEIndex -HeNBIndex $HeNBIndex ]
                         
                         puts "######################## $ifaceToShutDown #########################"
                         foreach { srcIp srcPort dstIp dstPort iface vlanIface } $ifaceToShutDown {}
                         
                         foreach op $operation {
                              
                              if {[ regexp -nocase "up"   $op ] } { set action "delete" }
                              if {[ regexp -nocase "down" $op ] } { set action "DROP" }
                              
                              # perform the operation on the MME Simulator
                              #set result1 [ configureIpTableRules -dut $simIp -operation $action -entity $entity \
                              #          -srcIp $srcIp -dstIp $dstIp -srcPort $srcPort -dstPort $dstPort -iface $iface ]
                              
                              set result1 [ configureIpTableRules -dut $simIp -operation $action -entity $entity \
                                        -srcIp $srcIp -dstIp $dstIp -srcPort $srcPort -chainName $chainName ]
                              
                              #set result2 [ configureIpTableRules -dut $simIp -operation $action -entity $entity \
                              #          -srcIp $srcIp -dstIp $dstIp -srcPort $srcPort -dstPort $dstPort -iface $vlanIface  ]
                              
                              #set result2 [ configureIpTableRules -dut $simIp -operation $action -entity $entity \
                              #          -srcIp $srcIp -dstIp $dstIp -srcPort $srcPort  -chainName $chainName ]
                              
                              if {( $result1 != 0 ) } {
                                   print -fail "Not able to configure the iptable with rule $srcIp $dstIp $srcPort $dstPort $iface to $action on $entity"
                                   return -1
                              } else {
                                   print -pass "Sucessfully configure the iptable with rule $srcIp $dstIp $srcPort $dstPort $iface to $action on $entity"
                              }
                              if {[info exists downTime] && ($op == "down")} {
                                   print -nonewline "For $entity to recover ... "
                                   halt $downTime
                              }
                         }
                    }
                    
               }
          }
          
          "intPrimary|intSecondary" {
               
               set failureScenarios "HeNB|MME"
               parseArgs args \
                         [list \
                         [list connectionTo   optional   "$failureScenarios"     "MME"       "The failure to be initiated on"] \
                         ]
               
               set fgwIp  [getActiveBonoIp $fgwNum]
               set ifaceToShutDown [ getIpAndPortForPrimSecondaryIface -interfaceType $typeOfReset -entity $entity -connectionTo $connectionTo]
               puts "################### $ifaceToShutDown #######################"
               
               foreach op $operation {
                    # Administratively bring down or up of the interface on HeNBGW
                    set result [execCommandSU -dut $fgwIp -command "ifconfig $ifaceToShutDown $op"]
                    if {[regexp "ERROR" $result] || $result == -1} {
                         print -fail "Failed to get the interface in $op state"
                         return -1
                    } else {
                         print -pass "Brought the interface to $op state"
                    }
                    
                    if {[info exists downTime] && ($op == "down")} {
                         print -nonewline "For $entity to recover ... "
                         halt $downTime
                    }
               }
          }
     }
     return 0
}

proc configureIpTableRulesX { args } {
     parseArgs args \
               [list \
               [list dut             "mandatory"  "string"       ""                     "list of commands to be executed" ] \
               [list operation       "optional"   "string"       "delete"             "list of commands to be executed" ] \
               [list iface           "optional"   "string"       "__UN_DEFINED__"      "delay between each repeat cycle"  ] \
               [list chainName       "optional"   "string"       "INPUT"                ""  ] \
               [list srcIp           "optional"   "string"       "__UN_DEFINED__"       ""  ] \
               [list srcPort         "optional"   "string"       "__UN_DEFINED__"       ""  ] \
               [list srcMask         "optional"   "string"       "24"                   ""  ] \
               [list dstIp           "optional"   "string"       "__UN_DEFINED__"       ""  ] \
               [list dstPort           "optional"   "string"       "__UN_DEFINED__"       ""  ] \
               [list dstMask         "optional"   "string"       "24"                   ""  ] \
               [list protocol        "optional"   "string"       "sctp"                 ""  ] \
               [list pos             "optional"   "string"       "1"                    ""  ] \
               ]
     
     set command ""
     
     if { ( [ ::ip::version $srcIp ] != 4 ) && ( [ ::ip::version $dstIp ] != 4 ) } {
          
          parseArgs args \
                    [list \
                    [list srcMask         "optional"   "string"       "120"                   ""  ] \
                    [list dstMask         "optional"   "string"       "120"                   ""  ] \
                    ]
          
          set ipTableCommand ip6tables
          if { [ info exists srcIp ] }   { append command " -s $srcIp/$srcMask" }
          if { [ info exists dstIp ] }   { append command " -d $dstIp/$dstMask" }
          if { [ info exists iface ] }   { append command " -i $iface" }
          
     } else {
          
          set ipTableCommand iptables
          if { [ info exists srcIp ] }   { append command " -s $srcIp/$srcMask" }
          if { [ info exists srcPort ] } { append command " --sport  $srcPort" }
          if { [ info exists dstIp ] }   { append command " -d $dstIp/$dstMask" }
          if { [ info exists dstPort ] } { append command " --dport $dstPort" }
          if { [ info exists iface ] }   { append command " -i $iface" }
     }
     switch [ string tolower $operation ] {
          
          "drop"      {  set command "$ipTableCommand -I $chainName  -p $protocol $command  -j $operation"  }
          
          "delete"    {  set command "$ipTableCommand -D $chainName -p $protocol $command -j DROP" }
          
     }
     
     print -info "IPCONFIG before the $operation"
     set result [execCommandSU -dut $dut -command "$ipTableCommand -nvL $chainName" ]
     
     set result [execCommandSU -dut $dut -command $command ]
     if [ regexp -- "for more information" $result ] {
          print -info "ERROR: Cannot configure requestd IP Table" ;
          return -1
     }
     
     print -info "IPCONFIG after the $operation"
     set result [execCommandSU -dut $dut -command "$ipTableCommand -nvL $chainName" ]
     
     return 0
}

proc getIpAndPortForPrimSecondaryIface { args } {
     
     parseArgs args \
               [list \
               [list fgwNum          "optional"   "numeric"      "0"                 "The FGW number"] \
               [list interfaceType   "optional"   "string"       "__UN_DEFINED__"       "list of commands to be executed" ] \
               [list entity          "optional"   "string"       "__UN_DEFINED__"       "delay between each repeat cycle" ] \
               [list MMEIndex        "optional"   "string"       "__UN_DEFINED__"       ""  ] \
               [list HeNBIndex       "optional"   "string"       "0"       ""  ] \
               ]
     
     switch  [ string tolower $entity ] {
          
          "mme" {
               
               if { [ regexp "primary" $interfaceType ] }   { set  type  1 }
               if { [ regexp "secondary" $interfaceType ] } { set  type  2 }
               set  key  "Mme"
               #set  srcSctpPort  6010
               
               # set interface     [getDataFromConfigFile "get${key}SimCp${type}HostPort" $fgwNum ]
               # set vlaInterface  [getDataFromConfigFile "get${key}SimCp${type}IntAndVlan" $fgwNum ]
               
               set dstIp         [getDataFromConfigFile "get${key}Cp${type}Ipaddress" $fgwNum ]
               
               if { $::ROUTING_TB == "yes"  } {
                    set srcIp        [getDataFromConfigFile  "get${key}SimCp${type}Ipaddress" $fgwNum ]
               } else {
                    set srcIp         [incrIp $dstIp ]
               }
               
               # set dstSctpPort [ getDataFromConfigFile "[string tolower $key]Sctp" $fgwNum ]
               
               set srcSctpPort [ expr [  getDataFromConfigFile "[string tolower $key]Sctp" $fgwNum ] + 1 ]
               
               #return "$srcIp $srcSctpPort $dstIp $dstSctpPort $interface $vlaInterface"
               return "$srcIp $srcSctpPort $dstIp"
               
          }
          
          "henb" {
               
               if { [ regexp "primary" $interfaceType ] }   { set  type  1 }
               if { [ regexp "secondary" $interfaceType ] } { set  type  2 }
               
               set  key  "Henb"
               
               #set srcSctpPort "[ expr 6006 + $HeNBIndex ]"
               set srcSctpPort [ getDataFromConfigFile "[string tolower $key]Sctp" $fgwNum ]
               set srcSctpPort [ expr $srcSctpPort + $HeNBIndex + 1]
               
               if { [ regexp -nocase "henb" $entity ] } { set dstSctpPort 6005 }
               
               #set interface     [getDataFromConfigFile "get${key}SimCpHostPort" $fgwNum ]
               #set vlaInterface  [getDataFromConfigFile "get${key}SimCpIntAndVlan" $fgwNum ]
               
               set dstIp         [getDataFromConfigFile "get${key}Cp${type}Ipaddress" $fgwNum ]
               if { $::ROUTING_TB == "yes"  } {
                    set srcIp         [ incrIp [getDataFromConfigFile "getHenbSimCpIpaddress" $fgwNum ] ]
               } else {
                    set srcIp         [ incrIp [getDataFromConfigFile "getHenbCp1Ipaddress" $fgwNum ] ]
               }
               #return "$srcIp $srcSctpPort $dstIp $dstSctpPort $interface $vlaInterface"
               return "$srcIp $srcSctpPort $dstIp"
               
          }
          
          "henbgw" {
               
               set failureScenarios "HeNB|MME"
               parseArgs args \
                         [list \
                         [list connectionTo   optional   "$failureScenarios"     "MME"       "The failure to be initiated on"] \
                         ]
               
               if { [ regexp -nocase "henb" $connectionTo ] }     { set  key  "Henb" }
               if { [ regexp -nocase "mme" $connectionTo ] }      { set  key  "Mme" }
               if { [ regexp -nocase "primary" $interfaceType ] }   { set  type  1 }
               if { [ regexp -nocase "secondary" $interfaceType ] } { set  type  2 }
               
               set interface [ getDataFromConfigFile "get${key}Cp${type}Port" $fgwNum]
               return $interface
          }
     }
}

proc cleanUpIpTableRule { args } {
     
     parseArgs args \
               [list \
               [list testType          "optional"   "string"      "func"                 "The FGW number"] \
               ]
     set fgwNum     0
     set chainName  "OUTPUT"
     
     if { $testType == "load" } {
          set      simIpList    [getDataFromConfigFile getMmeSimulatorHostIp $fgwNum]
          append   simIpList  " [getDataFromConfigFile getHenbSimulatorHostIp $fgwNum]"
          foreach simIp $simIpList {
               set result [execCommandSU -dut $simIp -command "iptables --flush" ]
          }
          return 0
     }
     
     set simIp  [getDataFromConfigFile "getMmeSimulatorHostIp" $fgwNum]
     
     foreach ipType {ipv4 ipv6} {
          
          if {$ipType == "ipv4" } { set ipTableCommand "iptables"  ; set srcIpIndex 7 ;  set dstIpIndex 8 }
          if {$ipType == "ipv6" } { set ipTableCommand "ip6tables" ; set srcIpIndex 6 ;  set dstIpIndex 7 }
          
          set result [execCommandSU -dut $simIp -command "$ipTableCommand -nvL $chainName" ]
          
          if { ![ regexp "destination(.*)\\\[" $result - useful ] } {
               print -info "Error : Cannot find the iptable patter"
               return -1
          }
          
          foreach line [ split $useful \r\n ] {
               set line [ string trim $line ]
               if { [ regexp "Service-Protection-1-OUTPUT" $line ] || ([llength $line ] < 3 )  } {
                    continue
               }
               
               set action      [ lindex $line 2]
               set proto       [ lindex $line 3]
               set inInt       [ lindex $line 5]
               set srcIp       [ lindex [ split [ lindex $line $srcIpIndex ] / ] 0 ]
               set srcMask     [ lindex [ split [ lindex $line $srcIpIndex ] / ] 1 ]
               set dstIp       [ lindex [ split [ lindex $line $dstIpIndex ] / ] 0 ]
               set dstMask     [ lindex [ split [ lindex $line $dstIpIndex ] / ] 1 ]
               
               if {$ipType == "ipv4" } {
                    regexp   ":(\[0-9]+)" [ lindex $line 10] - srcPort
                    if { ![ info exist srcPort ] } { puts "Error cannot src/dst port" ; continue }
                    
                    configureIpTableRules -dut $simIp -operation "delete" -entity "MME" -srcIp $srcIp  -dstIp $dstIp -srcPort $srcPort  \
                              -chainName "$chainName" -srcMask "$srcMask" -dstMask "$dstMask"
               } elseif { $ipType == "ipv6"  } {
                    
                    configureIpTableRules -dut $simIp -operation "delete" -entity "MME" -srcIp $srcIp  -dstIp $dstIp  \
                              -chainName "$chainName" -srcMask "$srcMask" -dstMask "$dstMask"
               }
          }
     }
     return 0
}
