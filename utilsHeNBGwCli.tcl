proc getMOId {dut} {
     #-
     #- Procedure to get the MO ID of the system being used
     #- The current version of the procedure uses the CLI to get the MOID
     #- The same can also be extracted from the FgwConfig_All.ini file
     #- The data would be stored in a global variable so that it can be used later
     #-
     #- @return the MOID on success and -1 on failure
     global MO_ID
     set confFile "/opt/conf/FgwConfig_All.ini"
     if {[doesFileExistOnHost -file $confFile -hostIp $dut]} {
          print -debug "Reading the $confFile file to get the MOID"
          set result [execCommandSU -dut $dut -command "head -n 20 $confFile"]
          if {[regexp "FGW_ID = \(\\d+\)" $result a henbid] && [regexp "CLUSTER_ID = \(\\d+\)" $result b clusterid]} {
               if {[info exists henbid] && [info exists clusterid]} {
                    set moid "$clusterid[format %.4d $henbid]"
                    set MO_ID $moid
                    print -debug "Got MOID from HeNGwConfig file as $moid"
                    return $moid
               }
          }
     } 
     print -debug "Could not extract the MOID"
     return -1
}

proc gotoCliRootNode {dut {nodeName ""} {nodeInst "1"} } {
     #-
     #- To get the Lte cli to go node using HeNBGwCLI.exe application
     #-
     #- @in dut   Ip address of the host on which HeNBGw is running
     #-
     #- @in nodeName: Node on which the operation needs to be performed
     #-
     #- @in nodeInst : Instance no of the node , since there can be multiple instances for same nodeName
     #-
     #- @return 0 on no error,  -1 on error
     #-
     
     # if requested to go to root node, directly move to root by using cd
     # this will be cleanup call to restore cli to root for furthur using
     global MO_ID
     if {![info exists MO_ID]} {
          set dut [getActiveBonoIp]

          set moId [getMOId $dut]
          if {![isDigit $moId]} {set moId 10001}
     } else {
          set moId $MO_ID
     } 
    
    if {$nodeName == "root" } {
          set result [execCliCommand -dut $dut -command "cd"]
          if {[isCliError $result]} {
               print -err "Failed to go to the rootnode of the HeNBGw cli"
               return -1
          } else {
               print -info "Moved to the rootnode of the HeNBGw cli"
               return 0
          }
     }
     
     set dir "FGW:$moId"
     switch $nodeName {
               "henbgw" {
                     set result "/$dir"

               }
	       "fgw" {
		     set result "/$dir"
	       }
               "TraceControl" {
                    #First get the root node and then to the sub node
                    if {[regexp {ItfLte:\d+} $result rootDir]} {
                         set result "cd ${rootDir}/${nodeName}"
                    }
               }
               "enbId" {
                               set result "/$dir"
                        }
               "mmeIpv4" {
                             set result "/$dir/MME:$nodeInst"
                         }
               "mme2Ipv4" {
                            set result "/$dir/MME:$nodeInst"
                          }
               "mmeIpv6" {
                            set result "/$dir/MME:$nodeInst"
                         }
               "mme2Ipv6" {
                                set result "/$dir/MME:$nodeInst"
                           }
               "mme" {
                     set result "/$dir"
               } 
               "sctpConfig" {
                    set result "/$dir"
               }
               "henbMaster" {
                     set result "/$dir"
               }
               "mmeRegion" {
                    set result "/$dir"
               }
               "mmeRegionEnbId" {
                    set result "/$dir/MMERegion:$nodeInst"
               }
               "mmeRegionTai" {
                    set result "/$dir/MMERegion:$nodeInst"

               }
               "mmeRefRegion" {
                    set result "/$dir/MME:$nodeInst"
               }
               "refMMEList" {
                      set result "/$dir/MMERegion:$nodeInst"

               }
               "performCont" {
                      set result "/$dir/ItfFgw:1"
               }
	       "traceControl" {
                      set result "/$dir/ItfFgw:1/TraceControl:$nodeInst"
                }
                "app4G" {
                      set result "/$dir/Application4G:1"
               }
               default {
                         set result "$nodeName"
               }
           }
        return $result
}

proc getHeNBGwSoftwareVersion { dut } {
     #-
     #- To retrieve the HeNBGw software version
     #-
     #- @in dut   Ip address of the host on which HeNBGw is running
     #-
     #- @error -1 on error
     #-
     #- @return alphanum version number of HeNBGw
     #-
     
     set result [getAndSetParamViaCli -dut $dut -paramList "swversion" -verify "returnResult" -operation "get" -nodeName ""]
     if {[regexp {(\"HeNBGW.*\d+\")} $result - match]} {
          print -dbg "Found HeNBGw SW version as $match"
          return [string trim $match \"]
     } else {
          print -fail "Failed to determine the software version of HeNBGw from the output"
          return -1
     }
}

proc getAndSetParamViaHeNBGWCli {args} {
     #-
     #- To retrieve and set the CLI
     #-
     #- @in dut   Ip address of the host on which Gateway is running
     #-
     #- @error -1 on error
     #-
     #- @return the result of the get/set operation
     #-
     
     parseArgs args\
               [list \
               [list dut           "mandatory"    "string"               "_"     "ip address of the dut"]\
               [list paramList     "mandatory"    "string"               "_"     "the value to which the userLabel should be set"]\
               [list nodeName      "optional"     "string"               ""      "the node on which param has to get/set. not specified, it will exec on root node"]\
               [list nodeInst      "optional"     "numeric"              "1"    "the node instance on which param has to get/set. not specified, it will exec on root node"]\
               [list verify        "optional"     "yes|no|returnResult"  "yes"   "if set, then retrive the value of the userLabel"]\
               [list operation     "optional"     "set|get|all"          "set"   "operation to be performed set/get"]\
               ]
     
     ########################################################
     # ???? will be removed once cli is accessible
     #return [updateParamInOamFile $paramList $nodeName]
     ########################################################
     
     return [getAndSetParamViaCli -dut $dut -paramList $paramList -nodeName $nodeName -nodeInst $nodeInst -verify $verify -operation $operation]
}

proc createOrDeleteObjViaHeNBGWCli {args} {
     #-
     #- To create or delete objects via cli
     #-
     #- @error -1 on error
     #-
     
     parseArgs args\
               [list \
               [list dut           "mandatory"    "string"              "_"	      "ip address of the dut"]\
               [list objList       "mandatory"    "string"              "_"       "list of objects that are to be created"]\
               [list nodeName      "optional"     "string"              ""        "the node on which param has to be created/deleted. not specified, it will exec on root node"]\
               [list nodeInst      "optional"     "numeric"              "1"        "the node on which param has to get/set. not specified, it will exec on root node"]\
               [list operation     "optional"     "create|delete"       "create"  "operation to be performed create/delete"]\
               ]
    
     return [createOrDeleteObjViaCli -dut $dut -objList $objList -nodeName $nodeName -nodeInst $nodeInst \
               -operation $operation ]
}
proc setAdminState { args } {

 #- Proc to set adminstate of an MO to locked or unlocked
 #- return -1 on failure

  parseArgs args \
               [list\
               [list HeNBGWNum           "optional"     "numeric"  "0"             "Position of HeNBGW in the testbed"]\
               [list MOName              "mandatory"    "string"   "__UN_DEFINED__"  "henbgw or mmeregion"]\
               [list MOInst              "optional"    "numeric"  "1"               "instance no"]\
               [list adminState          "optional"     "string"   "unlocked"        "adminstate value to be set"]\
               ]
     set dut  [getActiveBonoIp $HeNBGWNum]
     set moId [getMOId $dut]
     switch $MOName {
             "FGW" {
                          set cmd "set $MOName:$moId {administrativeState=\"$adminState\"}"
                          set result [execCliCommand -dut $dut -command $cmd]
                          if {[isCliError $result]} {
                            print -debug "result : $result"
                            print -fail "Failed to execute the command : $cmd "
                            return -1
                          }
              }
             "MME" {
             		 set cmd "set FGW:$moId/MME:$MOInst {administrativeState=\"$adminState\"}"
                         set result [execCliCommand -dut $dut -command $cmd]
                          if {[isCliError $result]} {
                            print -debug "result : $result"
                            print -fail "Failed to execute the command : $cmd "
                            return -1
                          }
             }
      }
     return 0
}
proc getAdminState { args } {

 #- Proc to set adminstate of an MO to locked or unlocked
 #- return -1 on failure

  parseArgs args \
               [list\
               [list HeNBGWNum           "optional"     "numeric"  "0"             "Position of HeNBGW in the testbed"]\
               [list MOName              "mandatory"    "string"   "__UN_DEFINED__"  "henbgw or mmeregion"]\
               [list MOInst              "optional"    "numeric"  "1"               "instance no"]\
               [list adminState          "optional"     "string"   "unlocked"        "adminstate value to be set"]\
               ]
     set dut  [getActiveBonoIp $HeNBGWNum]
      set moId [getMOId $dut]
     switch $MOName {
             "FGW" {
                          set cmd "get $MOName:$moId {administrativeState}"
                          set result [execCliCommand -dut $dut -command $cmd]
                          if {[isCliError $result]} {
                            print -debug "result : $result"
                            print -fail "Failed to execute the command : $cmd "
                            return -1
                          }
              }
      }
     return 0
}
proc getMONameForCLI {{nodeName ""}} {
     #-
     #- proc to retrieve a node name for create/delete/set/get through OAM CLI
     #-
     
     global MO_ID
     if {![info exists MO_ID]} {
          set dut [getActiveBonoIp]

          set moId [getMOId $dut]
          if {![isDigit $moId]} {set moId 10001}
     } else {
          set moId $MO_ID
     }
     
     switch $nodeName {
          "mmeIpv4"                    {return "/FGW:$moId/MME:1/MMEremoteSctpIPv4Address:1"}
          "mme2Ipv4"                   {return "/FGW:$moId/MME:1/MMEremoteSctpIPv4Address:2"}
          "mmeIpv6"                    {return "/FGW:$moId/MME:1/MMEremoteSctpIPv6Address:1"}
          "mme2Ipv6"                   {return "/FGW:$moId/MME:1/MMEremoteSctpIPv6Address:2"}
          "mme"                        {return "/FGW:$moId/MME:1"}
          "mmeRegionTai|mmeRegionTai1" {return "/FGW:$moId/MMERegion:1/MMERegiontaiList:1"}
          "mmeRegionTai2"              {return "/FGW:$moId/MMERegion:1/MMERegiontaiList:2"}
          "mmeRegionEnbId"             {return "/FGW:$moId/MMERegion:1/MMERegionglobalENBId:1"}
          "sctpConfig"                 {return "/FGW:$moId/SCTPConfig:1"}
          "henbMaster"                 {return "/FGW:$moId/HeNBMasterCP:1"}
          "mmeRegion"                  {return "/FGW:$moId/MMERegion:1"}
          "enbId"                      {return "/FGW:$moId/Application4G:1/Application4GglobalENBId:1"}
          "fgw"                        {return "/FGW:$moId"}
          "performCont"                {return "/FGW:$moId/ItfFgw:1/PerformanceControl:1"}
          "appl4G"                     {return "/FGW:$moId/Application4G:1"}
      }
}

proc checkIfMoExists {nodeName {nodeInstance "1"}} {
     #-
     #- proc to check if the MO is already created
     #-
     #- return 1 if the MO exists and -1 if not
     #-
     set dut [getActiveBonoIp]
     set nodePath [getMONameForCLI $nodeName]
     set result [execCliCommand -dut $dut -command "cd $nodePath" -timeout 60]
     if {[isCliError $result]} {
          print -err "Failed to get the rootnode information from HeNBGw cli"
          return -1
     }
     return 1
}

proc getNodeIndex {{nodeName ""} {nodeInstance "1"}} {
     #-
     #- proc to dereive the index how the data is stored when OAM_PersistantDB.xml is parsed
     #- this code will be deprecated once cli is available
     #-
     if {$nodeName == ""} { set nodeName "root" }
     global MO_ID
     if {![info exists MO_ID]} {
          set dut [getActiveBonoIp]
          set moId [getMOId $dut]
          if {![isDigit $moId]} {set moId 10001}
     } else {
          set moId $MO_ID
     }
     
     switch $nodeName {
          "root"            { return "FGW=$moId" }
          "enbId"           { return "FGW=$moId,Application4G=1,Application4GglobalENBId=1" }
          "mmeRegion"       { return "FGW=$moId,MMERegion=1" }
          "mmeRegionTai"    { return "FGW=$moId,MMERegion=1,MMERegiontaiList=1" }
          "mmeRegionEnbId"  { return "FGW=$moId,MMERegion=1,MMERegionglobalENBId=1"}
          "mme"             { return "FGW=$moId,MME=1" }
          "mmeIpv4"         { return "FGW=$moId,MME=1,MMEremoteSctpIPv4Address=1" }
          "mme2Ipv4"        { return "FGW=$moId,MME=1,MMEremoteSctpIPv4Address=2" }
          "mmeIpv6"         { return "FGW=$moId,MME=1,MMEremoteSctpIPv6Address=1" }
          "mme2Ipv6"        { return "FGW=$moId,MME=1,MMEremoteSctpIPv6Address=2" }
          "mmeS1Tai"        { return "FGW=$moId,MME=1,MMEs1TaiList=1" }
          "mmeTrans"        { return "FGW=$moId,MMETransportLocal=$nodeInstance" }
          "sctpConfig"      { return "FGW=$moId,SCTPConfig=1" }
          "mmeRefRegion"    { return "FGW=$moId,MMERegion=$nodeInstance" }
          "henbMaster"      { return "FGW=$moId,HeNBMasterCP=1" }
          "refMMEList"      { return "FGW=$moId,MMERegion=1" }
          default           { return $nodeName }
     }
}

proc mapNodeIndex {{nodeName ""}} {
     #-
     #- proc to dereive the index how the data is stored when OAM_PersistantDB.xml is parsed
     #- this code will be deprecated once cli is available
     #-
     if {$nodeName == ""} { set nodeName "root" }
     switch $nodeName {
          "root"            { return "" }
          "enbId"           { return "Application4G:1/Application4GglobalENBId" }
          "mmeRegion"       { return "MMERegion" }
          "mmeRegionTai"    { return "MMERegiontaiList" }
          "mmeRegionEnbId"  { return "MMERegionglobalENBId" }
          "mme"             { return "MME" }
          "mmeIpv4"         { return "MMEremoteSctpIPv4Address" }
          "mme2Ipv4"        { return "MMEremoteSctpIPv4Address" }
          "mmeIpv6"         { return "MMEremoteSctpIPv6Address" }
          "mme2Ipv6"        { return "MMEremoteSctpIPv6Address" }
          "sctpConfig"      { return "SCTPConfig" }
          "mmeRefRegion"    {return  "MMErefMMERegions"}
          "refMMEList"      {return  "MMERegionrefMMEList"}
          "henbMaster"      {return  "HeNBMasterCP"}
          default           { return $nodeName }
     }
}
proc updateParamInOamFile {paramList index} {
     #-
     #- proc to update data in array (OAM_PersistantDB.xml parsed data)
     #- this code will be deprecated once cli is available
     #-
     
#     global ARR_XML_DATA
     
#     set index [getNodeIndex $nodeName]
#     if {[regexp "," $paramList]} { set paramList [split $paramList ","] }
#     if {[regexp " " $paramList]} { set paramList [split $paramList " "] }
 #    foreach paramActualList $paramList {
  #   foreach param $paramActualList {
      #    foreach {key val} [split $param "="] {break}
       #   set val [string trim [string trim $val] \"]
        #  regsub -all {\-\-} $val "=" val
         # regsub -all "##" $val "," val
          #set index1 "$index,[string trim $key],Value"
     # parray ARR_XML_DATA
 #         if {![info exists ARR_XML_DATA($index1)]} {
  #             print -dbg "No entry found for key $index1"
   #        parray ARR_XML_DATA
 #         }
  #        print -dbg "Updated [lindex [split $key ,] end] at $index with $val"
   #       set ARR_XML_DATA($index1) $val
    # }
     #}
     #return 0
global ARR_XML_DATA

     set index [getXmlIndex -nodeName $index]
     print -dbg "index : $index paramList : $paramList"
     regsub "{" $paramList "" paramList
          print -dbg "paramList : $paramList"
          regsub "}" $paramList "" paramList
     print -dbg "paramList : $paramList"
     if {[regexp "," $paramList]} { set paramList [split $paramList ","] }
     foreach param $paramList {
          foreach {key val} [split $param "="] {break}
          set val [string trim [string trim $val] \"]
          regsub -all {\-\-} $val "=" val
          regsub -all "##" $val "," val
          set index1 "$index,[string trim $key],Value"
         print -info "index1 is $index1"
          if {![info exists ARR_XML_DATA($index1)]} {
               print -dbg "No entry found for key $index1"
          }
          print -dbg "Updated [lindex [split $key ,] end] at $index with $val"
          set ARR_XML_DATA($index1) $val
 parray ARR_XML_DATA
     }
     return 0

}

proc addNewObjInOamFile {objList} {
     #-
     #- proc to create new object in OAM_PersistantDB.xml
     #- this code is equivalent to create MO cli
     #- this code will be deprecated once cli is available
     #-

     set index     [string trim [string trim [regsub -all "/" [lindex $objList 0] ","] ","]]
     set paramList [lrange $objList 1 end]
     global ARR_XML_DATA
     
     # create MO if the specified object is not present in the data structure
     if {![info exists ARR_XML_DATA($index,ATTR_LIST)]} {
          # identify the default MO (1st MO retrieved from xml file)
          set index1 [regsub {\d+$} $index "1"]
          # identify the attributes for default MO and copy the xml structure
          foreach arrIndex [array names ARR_XML_DATA -regexp $index1,] {
               set ARR_XML_DATA([regsub "$index1," $arrIndex "$index,"]) $ARR_XML_DATA($arrIndex)
          }
          # retain the xml structure as per default MO
          # i.e., new MO will be created right after the default MO present in the xml file
          set arrIndex [lindex [lsort -dictionary [array names ARR_XML_DATA -regexp "[regsub {\d+$} $index {\\d+}],ATTR_LIST"]] end-1]
          set lIndex [expr 1 + [lsearch $ARR_XML_DATA(id) [string trim [regsub ",ATTR_LIST" $arrIndex ""]]]]
          set ARR_XML_DATA(id) [linsert $ARR_XML_DATA(id) $lIndex $index]
     }
     
     # value updation part for the MO
     return [updateParamInOamFile $paramList $index]
}

proc changeFgwSysCtlParams { args } {
     
     parseArgs args \
               [list \
               [list fgw             "optional"   "string"         ""            "list of commands to be executed" ] \
               [list parameter       "optional"   "string"         ""            "list of commands to be executed" ] \
               [list value           "optional"   "numeric"        "0"           "delay between each repeat cycle"  ] \
               [list type            "optional"   "string"         "sctp"        "used to filter the output"  ] \
               [list onSim           "optional"   "string"         "__UN_DEFINED__"        "used to filter the output"  ] \
               ]
     
     if { [ info exists onSim ] } {
          if { [ regexp -nocase "MME" $onSim ] }  { set simIpVar "getMmeSimulatorHostIp" }
          if { [ regexp -nocase "henb" $onSim ] } { set simIpVar "getHenbSimulatorHostIp" }
          set  fgwIp [getDataFromConfigFile "$simIpVar" $fgw]
     } else {
          set fgwIp   [getActiveBonoIp $fgw]
     }
     #net.sctp.rto_max = 60000
     #net.sctp.hb_interval = 30000
     
     #This list needs to be updated according to
     set sysCtlParameter [ string map "\
               sctpHeartBeat	net.sctp.hb_interval \
               sctpRtoMax	net.sctp.rto_max \
               " $parameter
     ]
     
     # Get the value of the parameter before the modification
     set cmd "sysctl -a | grep $type" ; #Change the command to remove the SCTP ; if you want to use it change other parameter
     set result [execCommandSU -dut $fgwIp -command $cmd]
     if { [regexp "$sysCtlParameter = (\[0-9]+)" $result - previousValue ] == 0 } { print -err "Cannot match" ; return 1 }
     
     # Update the new value for the specified parameter.
     puts [ set cmd "sysctl $sysCtlParameter=$value" ]
     set result [execCommandSU -dut $fgwIp -command $cmd]
     
     # Get the value of the parameter after the modification
     set cmd "sysctl -a | grep $type" ; #Change the command to remove the SCTP ; if you want to use it change other parameter
     set result [execCommandSU -dut $fgwIp -command $cmd]
     if { [regexp "$sysCtlParameter = (\[0-9]+)" $result - currentValue ] == 0 } { print -err "Cannot match" ; return 1 }
     
     print "Value before modification : $parameter $previousValue" ;
     print "Value after  modification : $parameter $currentValue"  ;
     if { $currentValue != $value } { return 1 }
     
     return 0
     
}

proc getDefaultParamValue {paramName} {
     #-
     #- proc to fetch the default value of a param (via cli or from OAM object)
     #-
     #- @in paramName -> parameter whose default value has to be fetched
     #- -1 on error, value retrieved from the cli otherwise
     #-
     
     global ARR_OAM_DEFAULT_VAL
parray ARR_OAM_DEFAULT_VAL
     
     if {![info exists ARR_OAM_DEFAULT_VAL($paramName)]} {
          print -fail "No default value defined for param \"$paramName\" in OAM file"
          return -1
     } else {
          print -info "$paramName default value is $ARR_OAM_DEFAULT_VAL($paramName)"
          return $ARR_OAM_DEFAULT_VAL($paramName)
   parray ARR_OAM_DEFAULT_VAL
     }
}

proc createOrDeleteSCTPConfigMO { args } {
     #-
     #- proc to create SCTP Config MO via OAM CLI
     #- @return cmd on success, @return -1 on failure
     parseArgs args \
               [list\
               [list HeNBGWNum               "optional"     "numeric"  "0"         "Position of HeNBGW in the testbed"]\
               [list operation               "optional"     "create|delete"   "create" "Operation to be performed"]\
               [list nodeInst                "optional"     "numeric"  "1"         "id of sctpconfig object to be created"]\
               [list index                   "optional"     "string"   "sctpConfig"  "index of the node"]\
               [list userLabel               "optional"     "string"   "SCTPConfig 1"   "defines a userLabel of SCTPConfig"]\
               [list administrativeState     "optional"     "string"   "unlocked"  "defines the adminstate of SCTPConfig"]\
               [list sctpBundleTmr           "optional"     "numeric"   "0"        "specifies the sctpBundleTmr value"]\               [list sctpCookieLife          "optional"     "numeric"   "60000"   "specifies the sctpCookieLife value"]\               [list sctpCookieLifeExt       "optional"     "boolean"   "false"   "specifies the sctpCookieLifeExt value"]\
               [list sctpFreezeTmr           "optional"     "numeric"   "3000"   "specifies the sctpFreezeTmr value"]\
               [list sctpHeartbeatTmr        "optional"     "numeric"   "3000"   "specifies the sctpHeartbeatTmr value"]\
               [list sctpInitAdvRxWnd        "optional"     "numeric"   "125000"   "specifies the sctpInitAdvRxWnd value"]\
               [list sctpKeyLifeTm           "optional"     "numeric"   "60000"   "specifies the sctpKeyLifeTm value"]\
               [list sctpMaxAckDelayDg       "optional"     "numeric"   "2"     "specifies the sctpMaxAckDelayDg value"]\
               [list sctpMaxAckDelayTm       "optional"     "numeric"   "100" "specifies the sctpMaxAckDelayTm value"]\
               [list sctpMaxAssocReTx       "optional"     "numeric"   "2" "specifies the sctpMaxAssocReTx value"]\
               [list sctpMaxPathReTx         "optional"     "numeric"   "2" specifies the sctpMaxPathReTx value"]\
               [list sctpMtuInitial          "optional"     "numeric"   "1500"  "specifies the sctpMtuInitial value"]\
               [list sctpMtuMaxInitial       "optional"     "numeric"   "1500"  " the sctpMtuMaxInitial value"] \
               [list sctpMtuMinInitial       "optional"     "numeric"   "508" "sctpMtuMinInitial value"] \
               [list sctpPerformMtuDisc       "optional"    "numeric"   "0" "specifies the sctpPerformMtuDisc value"]\
               [list sctpRtoAlpha            "optional"     "numeric"   "12"      "specifies the sctpRtoAlpha value"]\
               [list sctpRtoBeta             "optional"     "numeric"   "25"      "specifies the sctpRtoBeta value"]\
               [list sctpRtoInitial          "optional"     "numeric"   "3000"    "specifies the sctpRtoInitial value"]\
               [list sctpRtoMax              "optional"     "numeric"   "60000"   "specifies the sctpRtoMax value"]\
               [list sctpRtoMin              "optional"     "numeric"   "1000"    "specifies the sctpRtoMin value"]\
               [list sctpMaxAttempts         "optional"     "numeric"   "8"      "specifies the sctpMaxAttempts value"]\
               [list numOfPairsOfSctpStreams "optional"    "numeric"   "512"     "specifies the nOfPairsOfSctpStreams value"]\
               ]
     set HeNBGWIp [getActiveBonoIp $HeNBGWNum]
     switch $operation {
          "create" {
               set arr_local($index)  [list userLabel=\"$userLabel\",numOfPairsOfSctpStreams=numOfPairsOfSctpStreams]
               set objList [processMappingList [list [list [mapNodeIndex $index]:$nodeInst  $arr_local($index)]]]
               if {[isEmptyList $objList]} {set objList [mapNodeIndex $index]:$nodeInst}
          }
          "delete" {
               set objList [processMappingList [list [list [mapNodeIndex $index]:$nodeInst]]]
               if {[isEmptyList $objList]} {set objList [mapNodeIndex $index]:$nodeInst}
          }
     }
     print -info "Creating $index MO"
     set result [createOrDeleteObjViaHeNBGWCli -dut $HeNBGWIp -objList [list $objList] -nodeName $index -operation $operation]
     if {$result != 0} {
          print "result : $result"
          print -fail "Failed to update parameters at $index on HeNBGW"
          return -1
     } else {
          print -dbg "Successfully updated parameters at $index on HeNBGW"
          unset -nocomplain objList
          return 0
     }
}

proc createOrDeleteMMERegionMO { args } {
     #-
     #- proc to create MME Region MO via OAM CLI
     #- @return cmd on success, @return -1 on failure
     parseArgs args \
               [list \
               [list HeNBGWNum               "optional"     "numeric"  "0"            "Position of HeNBGW "]\
               [list nodeInst                "optional"     "numeric"  "1"            "MMEREgion Id"]\
               [list index                   "optional"     "string"   "mmeRegion"    "index of node"]\
               [list userLabel               "optional"     "string"   "MMERegion 1"  "defines a userLabel of MME" ]\
               [list administrativeState     "optional"     "string"   "unlocked"     "defines the adminstate of MME"]\
               [list operation               "optional"     "create|delete"   "create" "Operation to be performed"]\
               [list eNBNameGw               "optional"     "string"   "HeNBGWTest"   "defines the GW name"]\
               ]
     set HeNBGWIp [getActiveBonoIp $HeNBGWNum]
     switch $operation {
          "create" {
               set arr_local($index)  [list administrativeState=administrativeState,eNBNameGw=\"$eNBNameGw\"]
               set objList [processMappingList [list [list [mapNodeIndex $index]:$nodeInst  $arr_local($index)]]]
               print -debug "objList : $objList"
               if {[isEmptyList $objList]} {set objList [mapNodeIndex $index]:$nodeInst}
          }
          "delete" {
               set objList [processMappingList [list [list [mapNodeIndex $index]:$nodeInst ]]]
               if {[isEmptyList $objList]} {set objList [mapNodeIndex $index]:$nodeInst}
          }
          
     }
     print -info "Creating $index MO"
     set result [createOrDeleteObjViaHeNBGWCli -dut $HeNBGWIp -objList [list $objList] -nodeName $index -operation $operation]
     if {$result != 0} {
          print "result : $result"
          print -fail "Failed to update parameters at $index on HeNBGW"
          return -1
     } else {
          print -dbg "Successfully updated parameters at $index on HeNBGW"
          unset -nocomplain objList
          return 0
     }
}
proc createOrDeleteMMERegiontaiListMO {args} {
     #-
     #- proc to create MME Region MO via OAM CLI
     #- @return cmd on success, @return -1 on failure
     parseArgs args \
               [list \
               [list operation               "optional"     "create|delete"   "create"    "Operation to be performed"]\
               [list HeNBGWNum               "optional"     "numeric"  "0"            "Position of HeNBGW "]\
               [list nodeInst                "optional"     "numeric"  "1"            "MMEREgion Id"]\
               [list MoInst                 "optional"     "numeric"  "1"            "MMEregiontaillist InstanceID"]\
               [list index                   "optional"     "string"   "mmeRegionTai"  "index of the node"]\
               [list taiListId               "optional"     "numeric"  "1"             "MMEregiontaillist ID"]\
               [list taiListPlmnIdentityMcc  "optional"     "numeric"  "991"           "MCC" ]\
               [list taiListPlmnIdentityMnc  "optional"     "numeric"  "991"           "MNC" ]\
               [list taiListTrackingAreaCode "optional"     "numeric"  "23410"         "TAC" ]\
               ]
     set HeNBGWIp  [getActiveBonoIp $HeNBGWNum]
     switch $operation {
          "create" {
               set arr_local($index)  [list taiListId=taiListId,taiListPlmnIdentityMcc=\"$taiListPlmnIdentityMcc\",taiListPlmnIdentityMnc=\"$taiListPlmnIdentityMnc\",taiListTrackingAreaCode=taiListTrackingAreaCode]
               set objList [processMappingList [list [list [mapNodeIndex $index]:$MoInst  $arr_local($index)]]]
               if {[isEmptyList $objList]} {set objList [mapNodeIndex $index]:$MoInst}
          }
          "delete" {
               set objList [processMappingList [list [list [mapNodeIndex $index]:$MoInst ]]]
               if {[isEmptyList $objList]} {set objList [mapNodeIndex $index]:$MoInst}
          }
          
     }
     print -info "Creating $index MO"
     set result [createOrDeleteObjViaHeNBGWCli -dut $HeNBGWIp -objList [list $objList] \
               -nodeInst $nodeInst -nodeName $index -operation $operation]
     if {$result != 0} {
          print "result : $result"
          print -fail "Failed to update parameters at $index on HeNBGW"
          set flag 1
          return -1
     } else {
          print -dbg "Successfully updated parameters at $index on HeNBGW"
          return 0
     }
}
proc createMMERegionglobalENBIdMO { args } {
     #-
     #- proc to create MME RegionglobalENBId MO via OAM CLI
     #- @return cmd on success, @return -1 on failure
     parseArgs args \
               [list\
               [list HeNBGWNum                "optional"     "numeric"  "0"       "Position of HeNBGW in the testbed"]\
               [list MMERegionId             "optional"     "numeric"  "1"            "MMEREgion Id"]\
               [list MMERegionglobalENBIdInst "optional"     "numeric"  "1"       "globalenbid-instance"]\
               [list globalENBIdId            "optional"     "numeric"  "1"       "globalenbid"]\
               [list globalENBIdPlmnIdentityMcc "optional"   "numeric"  "991"     "globalENBIdPlmnIdentityMcc"]\
               [list globalENBIdPlmnIdentityMnc "optional"   "numeric"  "998"   "globalENBIdPlmnIdentityMnc"]\
               ]
     set HeNBGWIp  [getActiveBonoIp $HeNBGWNum]
     set moId [getMOId $HeNBGWIp]
     set command "create /FGW:$moId/MMERegion:$MMERegionId/MMERegionglobalENBId:$MMERegionglobalENBIdInst {globalENBIdId=\"globalENBIdId\",globalENBIdPlmnIdentityMcc=\"$globalENBIdPlmnIdentityMcc\",globalENBIdPlmnIdentityMnc=\"$globalENBIdPlmnIdentityMnc\"}"
     print "$command"
     #return 0
     set result  [ execCliCommand  -dut $HeNBGWIp -command $command]
     return 0
}

proc createOrDeleteMMErefMMERegionMO { args } {
     #-
     #- proc to create MME RegionglobalENBId MO via OAM CLI
     #- @return cmd on success, @return -1 on failure
     set HeNBGWIp  [getActiveBonoIp 0]
     set moId [getMOId $HeNBGWIp]      
     parseArgs args \
               [list\
               [list HeNBGWNum                "optional"     "numeric"  "0"       "Position of HeNBGW in the testbed"]\
               [list nodeInst                 "optional"     "numeric"  "1"            "node instance"]\
               [list index                    "optional"     "string"   "mmeRefRegion" "index of the node"]\
               [list refMMERegionsId          "optional"     "numeric"  "1"       "refMMERegionsId"]\
               [list operation                "optional"     "create|delete"   "create"         "Operation to be performed"]\
               [list refMMERegionsMmeRegionDn "optional"     "string"   "FGW=$moId,MMERegion=1" "MMEegion DN"]\
               [list MoInst             "optional"     "numeric"  "1"      "MME id"]\
               ]
     set HeNBGWIp  [getActiveBonoIp $HeNBGWNum]
     switch $operation {
          "create" {
               regsub -all "=" $refMMERegionsMmeRegionDn "--" refMMERegionsMmeRegionDn
               regsub -all "," $refMMERegionsMmeRegionDn "##" refMMERegionsMmeRegionDn
               #set arr_local($index)  [list refMMEListId=refMMEListId,refMMERegionsMmeRegionDn=\"$refMMERegionsMmeRegionDn\"]
               set arr_local($index)  [list refMMERegionsMmeRegionDn=\"$refMMERegionsMmeRegionDn\"]
               set objList [processMappingList [list [list [mapNodeIndex $index]:$MoInst  $arr_local($index)]]]
               
               if {[isEmptyList $objList]} {set objList [mapNodeIndex $index]:$MoInst}
               regsub -all {\-\-} $objList "=" objList
               regsub -all "##" $objList "," objList
               regsub -all {\\"} $objList "\"" objList
          }
          "delete" {
               set objList [processMappingList [list [list [mapNodeIndex $index]:$MoInst]]]
               if {[isEmptyList $objList]} {set objList [mapNodeIndex $index]:$MoInst}
          }
     }
     print -info "Creating $index MO"
     set result [createOrDeleteObjViaHeNBGWCli -dut $HeNBGWIp -objList [list $objList] \
               -nodeInst $nodeInst -nodeName $index -operation $operation]
     if {$result != 0} {
          print "result : $result"
          print -fail "Failed to update parameters at $index on HeNBGW"
          return -1
     } else {
          print -dbg "Successfully updated parameters at $index on HeNBGW"
          return 0
     }
}
proc createOrDeleteMMEMO { args } {
     #-
     #- proc to create MME MO via OAM CLI
     #- @return cmd on success, @return -1 on failure
     set HeNBGWIp  [getActiveBonoIp 0]
     set moId [getMOId $HeNBGWIp]
     parseArgs args \
               [list\
               [list HeNBGWNum           "optional"     "numeric"  "0"             "Position of HeNBGW in the testbed"]\
               [list nodeInst            "optional"     "numeric"  "1"              "defines a MMEId on HeNBGW" ]\
               [list index               "optional"     "string"   "mme"            "index of the node" ]\
               [list refSctpConfig       "optional"     "string"  "FGW=$moId,SCTPConfig=1"     "defines a reference to the SCTPConfig MO" ]\
               [list userLabel           "optional"     "string"   "MME 1"           "defines a userLabel of MME" ]\
               [list administrativeState "optional"     "string"   "unlocked"        "defines the adminstate of MME"]\
               [list remoteSctpPortNum   "optional"     "numeric"  "6010"           "defines MME's sctp port num"]\
               [list operation           "optional"     "create|delete"   "create"      "Operation to be performed"]\
               ]
     set HeNBGWIp  [getActiveBonoIp $HeNBGWNum]
     set remoteMMeSctp [expr [getDataFromConfigFile mmeSctp $HeNBGWNum] + 1]
     switch $operation {
          "create" {
               regsub -all "=" $refSctpConfig "--" refSctpConfig
               regsub -all "," $refSctpConfig "##" refSctpConfig
               set refMMETrans [getNodeIndex "mmeTrans"]
               set refMMETrans [encryptVar $refMMETrans]
               set arr_local($index)  [list userLabel=$userLabel, administrativeState=$administrativeState,remoteSctpPortNum=remoteMMeSctp,refSCTPConfig=\"$refSctpConfig\",refMMETransportLocal=\"$refMMETrans\"]
               set objList [processMappingList [list [list [mapNodeIndex $index]:$nodeInst  $arr_local($index)]]]
               #for refSCTPConfig value
               regsub -all {\-\-} $objList "=" objList
               regsub -all "##" $objList "," objList
               if {[isEmptyList $objList]} {set objList [mapNodeIndex $index]:$nodeInst}
          }
          "delete" {
               set objList [processMappingList [list [list [mapNodeIndex $index]:$nodeInst]]]
               if {[isEmptyList $objList]} {set objList [mapNodeIndex $index]:$nodeInst}
          }
     }
     print -info "Creating $index MO"
     set result [createOrDeleteObjViaHeNBGWCli -dut $HeNBGWIp -objList [list $objList] -nodeName $index -operation $operation]
     if {$result != 0} {
          print "result : $result"
          print -fail "Failed to update parameters at $index on HeNBGW"
          return -1
     } else {
          print -dbg "Successfully updated parameters at $index on HeNBGW"
          
          unset -nocomplain objList
          return 0
     }
}
proc createorDeleteMMESctpIPv6AddressMO {args} {
     
     parseArgs args \
               [list\
               [list HeNBGWNum        "optional"     "numeric"  "0"             "Position of HeNBGW in the testbed"]\
               [list nodeInst         "optional"     "numeric"  "1"             "Instance of the node"]\
               [list index            "optional"     "string"   "mmeIpv6"       "Index of the node"]\
               [list remoteMMeIpId    "optional"     "numeric"  "1"             "Id of the MO"]\
               [list remoteMMeIp      "optional"     "string"   "0:0:0:0:0:0:0:0" "IPV6 address"]\
               [list operation        "optional"     "create|delete"   "create"         "Operation to be performed"]\
               ]
     set HeNBGWIp  [getActiveBonoIp $HeNBGWNum]
     switch $operation {
          "create" {
               set remoteMMeIp    [incrIp [getDataFromConfigFile getMmeCp1Ipaddress $HeNBGWNum]]
               if {![isIpaddr $remoteMMeIp]} { return "ERROR: \"$remoteMMeIp\" (Invalid ip address)" }
               set arr_local($index)  [list remoteSctpIPv6AddressId=remoteMMeIpId,remoteSctpIPv6AddressIpV6Address=\"$remoteMMeIp\"]
               set objList [processMappingList [list [list [mapNodeIndex $index]:$nodeInst  $arr_local($index)]]]
               if {[isEmptyList $objList]} {set objList [mapNodeIndex $index]:$nodeInst}
          }
          "delete" {
               set objList [processMappingList [list [list [mapNodeIndex $index]:$nodeInst ]]]
               if {[isEmptyList $objList]} {set objList [mapNodeIndex $index]:$nodeInst}
          }
          
     }
     print -info "Creating $index MO"
     set result [createOrDeleteObjViaHeNBGWCli -dut $HeNBGWIp -objList [list $objList] -nodeName $index -operation $operation]
     if {$result != 0} {
          print "result : $result"
          print -fail "Failed to update parameters at $index on HeNBGW"
          return -1
     } else {
          print -dbg "Successfully updated parameters at $index on HeNBGW"
          unset -nocomplain objList
          return 0
     }
}
proc createorDeleteMMESctpIPv4AddressMO {args} {
     
     parseArgs args \
               [list\
               [list HeNBGWNum        "optional"     "numeric"  "0"             "Position of HeNBGW in the testbed"]\
               [list nodeInst         "optional"     "numeric"  "1"             "Instance of the node"]\
               [list index            "optional"     "string"   "mmeIpv4"       "Index of the node"]\
               [list operation         "optional"     "create|delete"   "create"  "Operation to be performed"]\
               [list remoteMMeIpId    "optional"     "numeric"  "1"             "Id of the MO"]\
               ]
     set HeNBGWIp  [getActiveBonoIp $HeNBGWNum]
     switch $operation {
          "create" {
               set remoteMMeIp    [incrIp [getDataFromConfigFile getMmeCp1Ipaddress $HeNBGWNum]]
               if {![isIpaddr $remoteMMeIp]} {return "ERROR: \"$remoteMMeIp\" (Invalid ip address)" }
               set arr_local($index) [list remoteSctpIPv4AddressId=remoteMMeIpId,remoteSctpIPv4AddressIpAddress=\"$remoteMMeIp\"]
               set objList [processMappingList [list [list [mapNodeIndex $index]:$nodeInst  $arr_local($index)]]]
               if {[isEmptyList $objList]} {set objList [mapNodeIndex $index]:$nodeInst}
          }
          "delete" {
               set objList [processMappingList [list [list [mapNodeIndex $index]:$nodeInst ]]]
               if {[isEmptyList $objList]} {set objList [mapNodeIndex $index]:$nodeInst}
          }
     }
     print -info "Creating $index MO"
     set result [createOrDeleteObjViaHeNBGWCli -dut $HeNBGWIp -objList [list $objList] -nodeName $index]
     if {$result != 0} {
          print "result : $result"
          print -fail "Failed to update parameters at $index on HeNBGW"
          return -1
     } else {
          print -dbg "Successfully updated parameters at $index on HeNBGW"
          
          unset -nocomplain objList
          return 0
     }
}
proc setDefaultPagingDrxOrEnbNameGw {args } {
    #- Proc to set defaultPagingDrx/eNBNameGW via CLI
    #- return -1 on failure
    parseArgs args \
               [list\
               [list HeNBGWNum           "optional"     "numeric"  "0"             "Position of HeNBGW in the testbed"]\
               [list defaultPagingDrx    "optional"     "numeric"  "__UN_DEFINED__" "Default Paging Drx Value"]\
               [list eNBNameGw           "optional"     "string"   "__UN_DEFINED__"  "name of the GW"]\
               [list MOName              "mandatory"    "string"   "__UN_DEFINED__"  "henbgw or mmeregion"]\
               [list MOInst              "optional"    "numeric"  "1"               "instance no"]\
               ]
     set dut  [getActiveBonoIp $HeNBGWNum]
     set moId [getMOId $dut]  
      switch $MOName {
        "Application4G" {
                  if { [info exists eNBNameGw] } {
	                  set cmd "set /FGW:$moId/Application4G:1 {eNBNameGw=\"$eNBNameGw\"}"
        	          set result [execCliCommand -dut $dut -command $cmd]
                	  if {[isCliError $result]} {
	                    print -debug "result : $result"
        	            print -fail "Failed to execute the command : $cmd "
                	    return -1
	                  }
                  }
		  if {[info exists defaultPagingDrx] } {
	                  set cmd "set /FGW:$moId/Application4G:1 {defaultPagingDrx=$defaultPagingDrx}"
        	          set result [execCliCommand -dut $dut -command $cmd]
                	  if {[isCliError $result]} {
	                    print -debug "result : $result"
        	            print -fail "Failed to execute the command : $cmd "
                	    return -1
	                  }
		  }

         }
         default {
                  set cmd "set /FGW:$moId/$MOName:$MOInst {eNBNameGw=\"$eNBNameGw\"}"
                  set result [execCliCommand -dut $dut -command $cmd]
                  if {[isCliError $result]} {
                    print -debug "result : $result"
                    print -fail "Failed to execute the command : $cmd "
                    return -1
                  }
         }
       } 
     return 0
}
proc verifyHENBGWMOParams { args } {
     #-
     #- proc to verify HENBGW MO via OAM CLI
     #- @return cmd on success, @return -1 on failure
     parseArgs args \
               [list\
               [list fgwNum          "optional"     "numeric"  "0"         "Position of FGW in the testbed"] \
               [list HeNBGWNum       "optional"     "numeric"  "0"         "Position of HeNBGW in the testbed"]\
               [list standby         "optional"     "string"   "no"       "Whether to execute this on standby card"]\
               ]

    if { $standby == "yes" } {
    set activeBONO [getActiveBonoIp $fgwNum "update"]
    set bonoIpList [getDataFromConfigFile getBonoIpaddress $fgwNum]
    set standbyIP []
    foreach ip $bonoIpList {
     if {[lsearch -exact $activeBONO  $ip ]==-1} { lappend standbyIP $ip }
    }
    set dut  $standbyIP
    } else {
     set dut  [getActiveBonoIp $HeNBGWNum]
    }

     set moId [getMOId $dut]
     set cmd "cd FGW:$moId/Application4G:1"
     set retValList ""
     set flag 0
     set result [execCliCommand -dut $dut -command $cmd]
     if {[isCliError $result]} {
          print -debug "result : $result"
          print -fail "Failed to execute the command : $cmd "
     }
     set attrList "administrativeState henbGWId eNBNameGw defaultPagingDrx latitudeNode1Degrees \
               latitudeNode2Degrees longitudeNode1Degrees longitudeNode2Degrees \
               latitudeNode1Minutes latitudeNode1Seconds latitudeNode2Minutes latitudeNode2Seconds \
               longitudeNode1Minutes longitudeNode1Seconds longitudeNode2Minutes longitudeNode2Seconds \
               locationNameNode1 locationNameNode2 eNBNameGw newDbVersion backupFilenameNode1 backupFilenameNode2 \
               swversion fallBackSwVersion newSwversion maxSupportedHeNBs"
     foreach index $attrList {
          print "index : $index"
          set cmd "get {$index}"
          set result [execCliCommand -dut $dut -command $cmd]
          if {[isCliError $result]} {
               print -debug "result : $result"
               print -fail "Failed to get the $index "
          }
          if {[regexp "$index=.*" $result match]} {
               set gotVal [lindex [split [lindex $match 0] "="] end]
               print -debug "gotVal = $gotVal"
          }
          switch $index {
               "administrativeState" {
                    set val "unlocked"
                    # some values will be in quotes while setting. remove quotes before comparing
                    if {$gotVal == $val} {
                         print -pass "value of $index is as expected \($gotVal == $val\)"
                    } else {
                         print -fail "value of $index is not as expected \($gotVal != $val\)"
                         set flag 1
                         #lappend failKeyList $key
                    }
               }
               "latitudeNode1Degrees|latitudeNode2Degrees|longitudeNode1Degrees|longitudeNode2Degrees" {
                    if {$gotVal <0 || $gotVal >180} {
                         print -error "$index range should 0-180!!!----> out of range"
                         set flag 1
                    } else {
                         print -pass "Value of $index is within range"
                    }
                    
               }
               "latitudeNode1Minutes|latitudeNode1Seconds|latitudeNode2Minutes|latitudeNode2Seconds|longitudeNode1Minutes|longitudeNode1Seconds|longitudeNode2Minutes|longitudeNode2Seconds" {
                    if {$gotVal <0 || $gotVal > 59} {
                         print -error "$index range should 0-59!!!----> out of range"
                         set flag 1
                    } else {
                         print -pass "Value of $index is within range"
                    }
               }
               "locationNameNode1|locationNameNode2|eNBNameGw|newDbVersion|backupFilenameNode1|backupFilenameNode2" {
                    if {[string length $gotVal] >100}  {
                         print -error "$index can be MAX 100 characters..."
                         set flag 1
                    } else {
                         print -pass "Length of $index is as expected"
                    }
                    
               }
               "defaultPagingDrx" {
                    if {$gotVal < 32 || $gotVal > 256} {
                         print -error "$index range should 2-32!!!----> out of range"
                         set flag 1
                    } else {
                         print -pass "Value of $index is within range"
                    }
               }
               "clusterid" {
                    if { $gotVal < 1 || $gotVal > 512 } {
                         print -error "$index range is 1-511 ---> out of range"
                         set flag 1
                    } else {
                         print -pass "Value of $index is within range"
                    }
               }
               "maxSupportedHeNBs" {
                    if { $gotVal <0 || $gotVal > 64000 } {
                         print -error "$index range is 0-64000 ---> out of range"
                         set flag 1
                    } else {
                         print -pass "Value of $index is within range"
                    }
                    
               }
               "henbgwId" {
                    if { $gotVal <1 || $gotVal > 9999 } {
                         print -error "$index range is 1-9999 ---> out of range"
                         set flag 1
                    } else {
                         print -pass "Value of $index is within range"
                    }
                    
               }
               "swversion|fallBackSwVersion|newSwversion" {
                    if {[string length $gotVal] >20}  {
                         print -error "$index can be MAX 20 characters..."
                         set flag 1
                    } else {
                         print -pass "Length of $index is as expected"
                    }
               }
          }
          
     }
     if { $flag} {
          print -fail "verification failed"
          return -1
     }
     return 0
     
}

proc verifyMMEMOParams { args } {
     #-
     #- proc to verify MME MO via OAM CLI
     #- @return cmd on success, @return -1 on failure
     parseArgs args \
               [list\
               [list HeNBGWNum               "optional"     "numeric"  "0"             "Position of HeNBGW in the testbe
     d"]\
               [list nodeInst                "optional"     "numeric"  "1"             "Instance of the node"]\
               ]
     set dut  [getActiveBonoIp $HeNBGWNum]
     set moId [getMOId $dut]
     set cmd "cd /FGW:$moId/MME:$nodeInst"
     set retValList ""
     set gotVal ""
     set flag 0
     set result [execCliCommand -dut $dut -command $cmd]
     if {[isCliError $result]} {
          print -debug "result : $result"
          print -fail "Failed to execute the command : $cmd "
     }
     set attrList "administrativeState mmeName refSCTPConfig remoteSctpPortNum userLabel"
     foreach index $attrList {
          print "index : $index"
          set cmd "get {$index}"
          set result [execCliCommand -dut $dut -command $cmd]
          if {[isCliError $result]} {
               print -debug "result : $result"
               print -fail "Failed to get the $index "
          }
          if {[regexp "$index=.*" $result match]} {
               set gotVal [lindex [split [lindex $match 0] "="] end]
               print -debug "gotVal = $gotVal"
          }
          switch $index {
               "administrativeState" {
                    set val "locked"
                    # some values will be in quotes while setting. remove quotes before comparing
                    if {$gotVal == $val} {
                         print -pass "value of $index is as expected \($gotVal == $val\)"
                    } else {
                         print -fail "value of $index is not as expected \($gotVal != $val\)"
                         set flag 1
                         #lappend failKeyList $key
                    }
               }
               "remoteSctpPortNum" {
                    if {$gotVal <1 || $gotVal >65535} {
                         print -error "$index range should 1-65535!!!----> out of range"
                         set flag 1
                    } else {
                         print -pass "Value of $index is within range"
                    }
                    
               }
               "userLabel|mmeName" {
                    if {[string length $gotVal] >100}  {
                         print -error "$index can be MAX 100 characters..."
                         set flag 1
                    } else {
                         print -pass "Length of $index is as expected"
                    }
                    
               }
          }
          
     }
     if { $flag} {
          print -fail "Verification failed!"
          return -1
     }
     return 0
}

proc deleteMMEMO { args } {
     #-
     #- proc to delete MME MO via OAM CLI
     parseArgs args \
               [list\
               [list HeNBGWNum               "optional"     "numeric"  "0"        "Position of HeNBGW in the testbed"]\
               [list mmeId                   "optional"     "numeric"  "1"         "defines a MMEId on HeNBGW" ]\
               [list MMERegionID             "optional"     "dn"       "1"         "defines the MMERegion ID" ]\
               ]
     set HeNBGWIp  [getActiveBonoIp $HeNBGWNum]
     set moId [getMOId $HeNBGWIp]
     set command "delete /FGW:$moId/MMERegion:1/MME:$mmeId "
     set result  [ execCliCommand  -dut $HeNBGWIp -command $command]
     return 0
}

proc updateMMEMO { args } {
     #-
     #- proc to update RW attributes of MME via OAM-CLI
}

proc X { } {
     #############################################################
     if { $cleanUpMO == "mmeRegionTai"} {
          set taiListId 1
          if {![info exists taiMcc]}     { set taiMcc     [getFromTestMap -HeNBIndex "all" -param "MCC"] }
          if {![info exists taiMnc]}     { set taiMnc     [getFromTestMap -HeNBIndex "all" -param "MNC"] }
          if {![info exists tac]}        { set tac        [getFromTestMap -HeNBIndex "all" -param "TAC"] }
          foreach mccList $taiMcc mncList $taiMnc TAC $tac {
               foreach mcc $mccList mnc $mncList {
                    print -info "Deleting MME Region TAI MOs"
                    set cleanUpMO "mmeRegionTai$taiListId"
                    print -debug "cleanUpMO:$cleanUpMO"
                    set objList [getMONameForCLI $cleanUpMO]
                    print -debug "objList : $objList"
                    if {![isEmptyList $objList]} {
                         set result [createOrDeleteObjViaHeNBGWCli -dut $dut -objList [list $objList] \
                                   -nodeName $cleanUpMO -operation "delete"]
                         if {$result != 0} {
                              print -fail "Deletion of \"$cleanUpMO\" failed"
                              #return -1
                         }
                    }
                    if {[info exists taiListId]} {incr taiListId}
               }
          }
     }
}

proc cleanUpStaleHeNBGwConfig {args} {
     #-
     #- This procedure is used to cleanup any stale HeNBGW configuration
     #- This is a precondition before starting any new configuration on the system
     #-
     #- @return -1 on error and 0 on success
     #-
     
     # Do not take any action as of now till everything is complete
     set validCleanUpList "mmeIpv4|mme2Ipv4|mmeIpv6|mme2Ipv6|mme|mmeRegionTai|mmeRegionEnbId|mmeRegion|sctpConfig"
     
     parseArgs args\
               [list \
               [list fgwNum          "optional"     "numeric"              "0"                          "Position of FGW in the testbed"] \
               [list cleanUpList     "optional"     "$validCleanUpList"    "mme mmeRegion sctpConfig"   "The params to be cleaned up"]\
               ]
     set dut  [getActiveBonoIp $fgwNum]
     
     # Clear the HeNBGW configuration in the order in which it was created
     foreach cleanUpMO "mmeIpv4 mme2Ipv4 mmeIpv6 mme2Ipv6 mme mmeRegionTai mmeRegionEnbId mmeRegion " {
          print "cleanUpMO:$cleanUpMO"
          #set objList [getNodeIndex $cleanUpMO]
          set objList [getMONameForCLI $cleanUpMO]
          print "objList : $objList"
          if {![isEmptyList $objList]} {
               set result [createOrDeleteObjViaHeNBGWCli -dut $dut -objList [list $objList] -nodeName $cleanUpMO \
                         -operation "delete"]
               if {$result != 0} {
                    print -fail "Deletion of \"$cleanUpMO\" failed"
                    #return -1
               }
          }
     }
     return 0
}

proc sctpPacketCountOnSim { args } {
     parseArgs args \
               [list \
               [list simIp           "mandatory"  "string"       ""                     "list of commands to be executed" ] \
               [list operation       "optional"   "string"       "getCount"             "list of commands to be executed" ] \
               [list iface           "optional"   "string"       "__UN_DEFINED__"      "delay between each repeat cycle"  ] \
               [list chainName       "optional"   "string"       "INPUT"                ""  ] \
               [list srcIp           "optional"   "string"       "__UN_DEFINED__"       ""  ] \
               [list srcMask         "optional"   "string"       "24"                   ""  ] \
               [list dstIp           "optional"   "string"       "__UN_DEFINED__"       ""  ] \
               [list dstMask         "optional"   "string"       "24"                   ""  ] \
               [list protocol        "optional"   "string"       "sctp"                 ""  ] \
               [list pos             "optional"   "string"       "1"                    ""  ] \
               [list chunkType       "optional"   "string"       "HEARTBEAT"            ""  ] \
               [list action          "optional"   "string"       "ACCEPT"               ""  ] \
               ]
     
     switch -regexp $operation {
          
          "configure"      {
               set command ""
               if { [ info exists srcIp ] } { append command " -s $srcIp/$srcMask" }
               if { [ info exists dstIp ] } { append command " -d $dstIp/$dstMask" }
               if { [ info exists iface ] } { append command " -i $iface" }
               
               set command "iptables -I $chainName $pos  -p $protocol $command --chunk-types any $chunkType -j $action"
          }
          
          "deleteConfig"   {    set command "iptables -D $chainName $pos" }
          
          "getCount"       {    set command "iptables -nL $chainName -v --line-numbers" }
          
          "clearCount"     {    set command "iptables -Z $chainName" }
     }
     
     set result [execCommandSU -dut $simIp -command $command ]
     if [ regexp -- "'iptables --help' for more information" $result ] {
          print -info "ERROR: Cannot configure requestd IP Table" ;
          return -1
     }
     
     if { $operation == "getCount" } {
          foreach line [ split $result \r\n ] {
               if { [ lindex $line 0 ] == $pos } {
                    print -info "[lindex $line 1]"
                    return [lindex $line 1]
               }
          }
     }
     return 0
}

proc getSRPingTimout {} {
     #-
     #- The procedure to get the default value of SR Ping timout for link switchover 
     #-
     #- @return -1 on error and value on success 
     #-

     # Hardcoded to 2 seconds
     return 5 
}

proc bulkCM { args } {
     #-
     #- This procedure is to do bulkCM operation
     #Step 1: Get the current configuration of FGW in preconfig XML format by issuing the following commands in BSGCLI
     #:   cd FGW:<DN>; set {uploadDB=True};
     #Step 2: Get the dbStatus using this command in cli prompt to verify uploadDB status
     #       get {dbStatus};
     #Step 3: Upon successful uploadDB command a tar file (FGW-OAM-Config:x:xxxx.tar) would be generated in the /opt/upload/ directory. You can check the file create giving the CLI command
     # get { uploadDBFileName};
     #Step 4: Extract the tar file generated in the above step using the following command
     # tar --force-local -xvf FGW-OAM-Config:x:xxxx.tar
     #Step 5: From the extracted folder, modify the OAM_PreConfig xml
     #Step 6: After modifying OAM_PreConfig.xml, tar the modified folder as below
     # tar --force-local -cvf FGW-OAM-Config:x:xxxx.tar *.xml *.ini *.xsd
     #Step 7:Copy the modified FGW-OAM-Config:x:xxxx.tar in the /opt/download dir and perform download DB
     # cd FGW:<DN>;
     # set { downloadDBFileName = "FGW-OAM-Config:x:xxxx.tar"};
     # set {downloadDB=True};
     #Step 8: Get the downloadDB status using the following command in CLI prompt to
     # get {dbStatus};
     
     #-
     #-
     parseArgs args\
               [list \
               [list dut      		   "optional"     "string"    "[getActiveBonoIp]"  "ip address of the dut"]\
               [list op          	   "optional"     "string"    "create|delete|update" "create or delete or set operation"] \
               [list moName      	   "optional"     "string"    ""              "MO to be created/deleted/updated"]\
               [list hPLMNPlmnIdentityMcc  "optional"     "string"    "__UN_DEFINED__"            "hPLMNPlmnIdentityMcc"]\
               [list hPLMNPlmnIdentityMnc  "optional"     "string"    "__UN_DEFINED__"            "hPLMNPlmnIdentityMnc"]\
               [list node1FemtoAddress            "optional" "string"       "__UN_DEFINED__"  "node1FemtoAddress"]\
               [list globalENBIdENBId             "optional" "string"       "__UN_DEFINED__"  "node2FemtoAddress"]\
               [list globalENBIdId                "optional" "string"       "__UN_DEFINED__"  "node2FemtoAddress"]\
               [list globalENBIdPlmnIdentityMcc   "optional" "string"       "__UN_DEFINED__"  "node2FemtoAddress"]\
               [list globalENBIdPlmnIdentityMnc   "optional" "string"       "__UN_DEFINED__"  "node2FemtoAddress"]\
               [list globalENBIdRowStatus         "optional" "string"       "__UN_DEFINED__"  "node2FemtoAddress"]\
  
     ]
     
     print -debug "op : $op"
     ### Get the current configuration of FGW in preconfig XML format
     
     print -info "Set the uploadDB to true"
     set result [FGWMo -op "set" -uploadDB "true" -verify "no"]
     if { $result != 0 } {
          print -fail "Failed to set uploadDB"
          set flag 1
     } else {
          print -pass "Set uploadDB to true successfully"
     }
     halt 60
     #### Get the dbStatus using this command in cli prompt to verify uploadDB status
     for {set i 1} {$i <= 16} { incr i} {
          print -info "Get the dbStatus to verify uploadDB status"
          set result [FGWMo -op "get" -dbStatus "uploadDBSuccessful"]
          if { $result == 0 } {
               print -pass "Verified dbStatus successfully for UPLOAD"
     		  break
          } else {
     	      set result [FGWMo -op "get" -dbStatus "uploadDBFailed"]
                     if { $result == 0 } {
                             print -fail "uploadDB is not successfull and it is uploadDBFailed"
                             set flag 1
                             set result 1
                             break
                     }	
     			halt 15
          }
     }
     if { $result != 0 } {
             print -fail "Failed to get dbStatus for UPLOAD"
             set flag 1
     }

     set tarFile [FGWMo -op "get" -uploadDBFileName "true" -verify "returnResult"]
     set tarFile [string trim $tarFile "{\""]
          set tarFile [string trim $tarFile "}\""]
     
     print -debug "tarFile : $tarFile"
     #### Goto /opt/upload dir and extract the tar file
     print -info "Goto /opt/upload dir and extract the tar file"
     set result [extractTarFile -dut $dut -dirname "/opt/upload" -tarFile $tarFile]
     if { $result != 0 } {
          print -fail "Failed to extract the tar file"
          set flag 1
     } else {
          print -pass "Extracted the tar file successfully"
     }
     if {$op == "create"} {
          if {![info exists hPLMNPlmnIdentityMcc]} {
               #set hPLMNPlmnIdentityMcc  [getPLMN -param "MCC" -plmnIndex $plmnIndex]
		set hPLMNPlmnIdentityMcc  $globalENBIdPlmnIdentityMcc
          }
          if {![info exists hPLMNPlmnIdentityMnc]} {
               #set hPLMNPlmnIdentityMnc  [getPLMN -param "MNC" -plmnIndex $plmnIndex]
               set hPLMNPlmnIdentityMnc  $globalENBIdPlmnIdentityMnc
          }
     }
     #### Modify the OAM_Preconfig.xml
     switch -regexp $moName {
           "Application4GglobalENBId" {
               set delim " "
               set nodeName [getXmlIndex -nodeName $moName]
               print -debug "nodeName : $nodeName"
               set args \
                         [list \
 			 globalENBIdENBId=globalENBIdENBId\
			 globalENBIdPlmnIdentityMcc=globalENBIdPlmnIdentityMcc\
			 globalENBIdPlmnIdentityMnc=globalENBIdPlmnIdentityMnc\
                         ]
               set quoteArgs "globalENBIdPlmnIdentityMcc globalENBIdPlmnIdentityMnc"
             foreach arg $args {
                    foreach {key val} [split $arg "="] {break}
                    if {[info exists $val]} {
                         if {[lsearch $quoteArgs $key] > -1} {
                              append params "$key=\"[set $val]\","
                         } else {
                              append params "$key=[set $val],"
                         }
                    }
               }
          }

#till here
          
     }
     if {$op == "create|delete"} {
          set objList "$nodeName"
     }
     
     if {$op == "create" || $op == "set"} {set delim ","} else {set delim " "}
     foreach arg $args {
          foreach {key val} [split $arg "="] {break}
          if {[info exists $val]} {
               if {[lsearch $quoteArgs $key] > -1} {
                    append params "$key=\"[set $val]\"$delim"
               } else {
                    append params "$key=[set $val]$delim"
               }
          }
     }
     
     if {[info exists params]} {
          set params "[string trim $params $delim]"
          append objList " \{$params\}"
          print -info "params $params"
     }
     
     #print -debug "objList : $objList , moName : $moName , op: $op"
     set result  [oamPreConfigFileforBulkCM -dut $dut -operation "read"]
     foreach index $moName {
          switch -regexp $index {
             "Application4GglobalENBId" {
                    if {$op == "update"} {
                       print -info "object lis is $objList and mois $moName"
                         set result  [updateParamInOamFile $objList $moName]
#                    print -info "object lis is $objList and mois $moName"

                    }
                    if {$op == "create"} {
                         #set result  [addNewObjInOamFile  $objList]
		  print -info "in create object lis is $objList and mois $moName"

                         set result  [updateParamInOamFile $objList $moName]
                    }
                    
                    if {$result != 0} {
                         print -fail "Failed to $op parameters at $nodeName on fgw"
                         return -1
                    } else {
                         print -dbg "Successfully $op parameters at $nodeName on fgw"
                    }
               }
          }
     }
     #retrieveDefaultValuesFromOam
     
     # Write the changes to the OAM_Preconfig.xml file and start the application to get CLI access
     set result  [oamPreConfigFileforBulkCM -dut $dut -operation "write"]
     # Done with OAM_Preconfig.xml configuration
     # Start the Application to get CLI access
     #set result  [restartHeNBGW -fgwNum $fgwNum -verify "yes" -operation "start"]
     #unset arr_local
     #### tar the modified folder and copy to /opt/download
     print -info "Goto /opt/upload dir and tar the modified folder"
     set dir "/opt/upload"
     set fileName "*.xml *.ini *.xsd"
     set archiveName $tarFile
     set result [tarFile $dut $dir $fileName $archiveName]
     if { $result != 0 } {
          print -fail "Failed to tar the file"
          set flag 1
     } else {
          print -pass "tar file is ready"
     }
     
     print -info "Copying the tar file to /opt/download"
     set result [execCommandSU -dut $dut -command "cp /opt/upload/$archiveName /opt/download/$archiveName"]
     if {[regexp -nocase "ERROR" $result] || $result == -1} {
          print -fail "Failed to copy the tar file to /opt/download"
          set flag 1
     } else {
          print -pass "Copied the tar file to /opt/download"
     }
     #### perform download DB
     
     set tarFile "\"$tarFile\""
     print -info "Set the downloadDBFileName"
     set result [FGWMo -op "set" -downloadDBFileName $tarFile]
     if { $result != 0 } {
          print -fail "Failed to set uploadDBFileName"
          set flag 1
     } else {
          print -pass "Set uploadDBFileName successfully"
     }
     ### Set downloadDB to true
     set result [FGWMo -op "set" -downloadDB "true" -verify "no"]
     if { $result != 0 } {
          print -fail "Failed to set downloadDB"
          set flag 1
     } else {
          print -pass "Set downloadDB to true successfully"
     }
     halt 300
     ### Check the download DB status
     for {set i 1} {$i <= 40} { incr i} {
         set result [FGWMo -op "get" -dbStatus "downloadDBSuccessful"]
         if { $result == 0 } {
                print -pass "Verified dbStatus successfully for DOWNLOAD"
                break
         } else {
                set result [FGWMo -op "get" -dbStatus "downloadDBFailed"]
                if { $result == 0 } {
                        print -fail "downloadDB is not successfull and it is downloadDBFailed"
                        set flag 1
                        set result 1
                        break
                }
         }
         halt 15
     }
     if { $result != 0 } {
            print -fail "Failed to get dbStatus for DOWNLOAD"
            set flag 1
     }
     ## to make sure further CLI is done on active node
     set dut [getActiveBonoIp 0 update] 
     return $result
}

proc FGWMo {args} {
     #-
     #- This procedure is used to set attributes in FGW MO
     #-
     
     parseArgs args\
               [list \
               [list dut                   	"optional"     "string"          "[getActiveBonoIp]"	"ip address of the dut"]\
               [list op                    	"optional"     "string"          "set"                  "get or set"]\
               [list nodeInstance          	"optional"     "string"          "1"         		"index of node"] \
               [list uploadDB              	"optional"     "string"          "__UN_DEFINED__"       "for bulkCM"]\
               [list downloadDB            	"optional"     "string"          "__UN_DEFINED__"       "for bulkCM"]\
               [list uploadDBFileName      	"optional"     "string"          "__UN_DEFINED__"       "for bulkCM"]\
               [list aclCheckEnabled      	"optional"     "string"          "__UN_DEFINED__"       "ACL check enable/disable"]\
               [list dbStatus              	"optional"     "string"          "__UN_DEFINED__"       "to check DB status"]\
               [list verify                	"optional"     "string"          "yes"          	"to get the result"]\
               [list downloadDBFileName    	"optional"     "string"          "__UN_DEFINED__"       "dwnload File"]\
               [list dpatPort                	"optional"     "string"          "__UN_DEFINED__"       "port no"]\
               [list mode                       "optional"     "string"          "__UN_DEFINED__"       "mode"]\
               [list swversion                  "optional"     "string"          "__UN_DEFINED__"       "swversion"]\
               [list newSwversion               "optional"     "string"          "__UN_DEFINED__"       "newSwversion"]\
      ]
     
     #The following line of code is not required for 4G
     #set nodeName [getNodeIndex "fgw"]
     set nodeName [getNodeIndex "/FGW:80013"]
     #set nodeName ""
     #Attributes of FGW MO, if defined then undergoes set operation
     set args [list  uploadDB=uploadDB downloadDB=downloadDB uploadDBFileName=uploadDBFileName dbStatus=dbStatus \
               downloadDBFileName=downloadDBFileName]
     
     set quoteArgs [list femtoUserTrafficAddress offloadNATaddressPoolIpAddress locationNameNode1 locationNameNode2\
                    ipAddressFMSRemote ipAddressSNTPRemote]
     foreach arg $args {
          foreach {key val} [split $arg "="] {break}
          if {[info exists $val]} {
               if {[lsearch $quoteArgs $key] > -1} {
                    append params "$key=\"[set $val]\" "
               } else {
                    append params "$key=[set $val] "
               }
          }
     }
     
     if {[info exists params]} {
          set params "[string trim $params " "]"
          append objList " \{$params\}"
          print -info "params $params"
     }
     
     #if {$op == "set"} {
	     set result [getAndSetParamViaBsgCli -dut $dut -paramList $params -nodeName $nodeName -operation $op -verify $verify]
     #} else {
#	     set result [getAndSetParamViaBsgCli -dut $dut -paramList $params -nodeName $nodeName1 -operation $op -verify $verify]
 #    }
     return $result
}

proc deleteObjInOamFile {objList} {
     #-
     #- proc to delete an object in OAM_Preconfig.xml
     #- this code is equivalent to delete MO cli
     #-
     print -debug "In deleteObjInOamFile(), objList: objList"
     set index     [string trim [string trim [regsub -all "/" [lindex $objList 0] ","] ","]]
     print -debug "index: $index"
     
     set paramList [lrange $objList 1 end]
     print -debug "paramList : $paramList"
     global ARR_XML_DATA
     
     # create MO if the specified object is not present in the data structure
     if {![info exists ARR_XML_DATA($index,ATTR_LIST)]} {
          # identify the default MO (1st MO retrieved from xml file)
          set index1 [regsub {\d+$} $index "1"]
          # identify the attributes for default MO and copy the xml structure
          foreach arrIndex [array names ARR_XML_DATA -regexp $index1,] {
               set ARR_XML_DATA([regsub "$index1," $arrIndex "$index,"]) $ARR_XML_DATA($arrIndex)
          }
          # retain the xml structure as per default MO
          # i.e., new MO will be created right after the default MO present in the xml file
          set arrIndex [lindex [lsort -dictionary [array names ARR_XML_DATA -regexp "[regsub {\d+$} $index {\\d+}],ATTR_LIST"]] end-1]
          set lIndex [expr 1 + [lsearch $ARR_XML_DATA(id) [string trim [regsub ",ATTR_LIST" $arrIndex ""]]]]
          set ARR_XML_DATA(id) [lreplace $ARR_XML_DATA(id) $lIndex $index]
     }
     
     # value updation part for the MO
     return [updateParamInOamFile $paramList $index]
     
}

proc getXmlIndex {args} {
     #-
     #-
     #- proc to retrieve the index how the data is stored when OAM_PersistantDB.xml is parsed
     #- this code will be used for  bulkCM proc
     #-
     parseArgs args\
               [list \
               [list nodeName "mandatory"  "string"   "_"   "name of a node, whose complete path has to be retrieved"] \
               [list nodeInstance "optional" "string"   "1"   "index of node whose complete path has to be retrieved"] \
               [list PhysicalInterfaceB "optional" "string"   "1"   "index of node whose complete path has to be retrieved"]\
               [list bsgNodeInstance "optional" "string"   "1" "index of node whose "]\
               [list m3uaNodeInstance "optional" "string"   "1" "index of node whose "]\
               [list ipspInstance     "optional" "string"   "1" "index of node whose "]\
               [list nexthopNodeInstance "optional" "string" "1" "index of node"]\
               [list PhysicalInterfaceS "optional" "string"   "1"   "index of node whose complete path has to be retrieved"]\
               [list sctpNodeInstance   "optional" "string"   "1"   "index of sctpassociation MO"]\
               [list sctpRefNodeInstance  "optional" "string"  "1"  "index of sctprefassociation MO"]\

     ] 
     global MO_ID
     if {![info exists MO_ID]} {
          set dut [getActiveBonoIp]
          set moId [getMOId $dut]
          print -debug "moId:$moId"
          if {![isDigit $moId]} {set moId 10001}
     } else {
          set moId $MO_ID
     }
     switch $nodeName {
          "Application4GglobalENBId"       { return "FGW=$moId,Application4G=$nodeInstance,Application4GglobalENBId=$nodeInstance"}
     }
     
}

#till here

proc getAndSetParamViaBsgCli {args} {
     #-
     #- To retrieve and set the BSG CLI
     #-
     #- @in dut   Ip address of the host on which BSG is running
     #-
     #- @error -1 on error
     #-
     #- @return the result of the get/set operation
     #-
     
     parseArgs args\
               [list \
               [list dut           "mandatory"    "string"              "_"	"ip address of the dut"]\
               [list paramList     "mandatory"    "string"              "_"     "the value to which the userLabel should be set"]\
               [list nodeName      "mandatory"     "string"              ""      "the node on which param has to get/set. not specified, it will exec on root node"]\
               [list verify        "optional"     "yes|no|returnResult" "yes"   "if set, then retrive the value of the userLabel"]\
               [list operation     "optional"     "set|get|all|list"    "set"   "operation to be performed set/get"]\
               [list noSplit	   "optional"	  "yes|no"		"no"	   "To send complete command without splitting by equals"]\
               ]
     
     #Newer cli procedures are written by passing full path in nodeName, so that extra step of move to parent node are removed
     if {![regexp "\/" $nodeName]} {
          # Access the nodeName's cli directory
          set result [gotoFgwCliRootNode $dut $nodeName]
          if {$result != 0} {
               print -err "Not able to access the BSG root node."
               return -1
          }
     }
     
     set flag 0
     set failKeyList ""
     set retValList ""
     set setFailList ""
     
     #set operation for comma seperated attributes
     if {$operation == "set" && [llength $paramList] == 1} {
          set command [encryptVar $paramList "decrypt"]
          set command "set $nodeName \{$command\}"
          set result [execCliCommand -dut $dut -command $command]
          if {[isCliError $result]} {
               print -fail "Failed to set the $paramList"
               set flag -1
               lappend setFailList [lindex [split $command " "] 1]
          }
          set paramList [split [lindex $paramList 0] ","]
           if {$verify == "yes"} {
           set operation "get"
          } else {
             return 0
          }

     }
     
     # identify the keys
     if {$paramList == "all"} {
          print -info "Get all the cli for the node $nodeName"
          set keyList "all"
          set valList "all"
          set command "get"
          set verify "returnResult"
     } else {
          foreach param $paramList {
               foreach {key val} [split $param "="] {break}
               set val [encryptVar $val "decrypt"]
               lappend keyList $key
               lappend valList $val
          }
     }
     
     # if verification is requested, verify immediately after setting an attribute
     if {$operation == "set" && $verify == "yes"} { set operation "set get" }
     
     foreach key $keyList val $valList {
          foreach op $operation {
               switch $op {
                    "set" {
                         if {[regexp "\/" $nodeName]} {
                              set command "set $nodeName \{$key=$val\}"
                         } else {
                              set command "set \{$key=$val\}"
                         }
                         set result [execCliCommand -dut $dut -command $command]
                         if {[isCliError $result]} {
                              print -fail "Failed to set the key $key with $val"
                              set flag -1
                              lappend setFailList [lindex [split $command " "] 1]
                              #break
                              #return -1
                         }
                    }
                    "get" {
                         if {[regexp "\/" $nodeName]} {
                              set command "get $nodeName \{$key\}"
                         } else {
                              set command "get \{$key\}"
                         }
                         set result [execCliCommand -dut $dut -command $command]
                         if {[isCliError $result]} {
                              print -fail "Failed to get the command : $command "
                              set flag -1
                              break
                         }
                         set result [extractOutputFromResult $result]
                         if {$verify != "no"} {
                              if {[regexp "$key=(.*)" $result match gotVal]} {
                                   #   set gotVal [lindex [split [lindex $match 0] "="] end]
                                   if {$verify == "returnResult"} {
                                        lappend retValList $gotVal
                                   } elseif {$verify == "yes"} {
                                        # some values will be in quotes while setting. remove quotes before comparing
                                        
                                        set val [string trim $val "\""]
                                        set gotVal [string trim  $gotVal "\""]
                                        
                                        if {$gotVal == $val} {
                                             print -pass "value of $key is as expected \($gotVal == $val\)"
                                             
                                        } else {
                                             print -fail "value of $key is not as expected \($gotVal != $val\)"
                                             set flag -1
                                             lappend failKeyList $key
                                        }
                                   }
                              } else {
                                   print -fail "Not found match for key \"$key\""
                                   set flag -1
                              }
                         }
                    }
                    
                    "all" {
                         set result [execCliCommand -dut $dut -command $command]
                         if {[isCliError $result]} {
                              print -fail "Failed to get the command : $command "
                              set flag -1
                              #   return -1
                         }
                         foreach line $resultList {
                              if {[regexp "=" $line]} {
                                   lappend retValList $line
                              }
                         }
                    }
               }
          }
     }
     
     print -info "Restoring the cli node to root"
     set result [gotoFgwCliRootNode $dut "root"]
     
     if {$setFailList != ""} {
          print -fail "Set operation failed. Failed for [join $setFailList ,] keys"
          set flag 1
          return -1
     }
     if {$failKeyList != ""} {
          print -fail "Get operation failed. Failed for [join $failKeyList ,] keys"
          set flag 1
          return -1
     }
     
     if {$verify == "yes"} {
          if {$flag != 0} {
               print -fail "$operation on few/all keys failed"
               set flag -1
               return $flag
          } else {
               print -pass "$operation completed  successfully"
          }
     } elseif {$verify == "returnResult"} {
          return $retValList
     }
     if {[isProcInStack configOAMCLI] && ![regexp "Day1ConstraintCheck" [pwd]]} {return 0}
     set result1 [execCommandSU -dut $dut -command "/opt/bin/BSGCLI.exe -v"]
     set result1 [extractOutputFromResult $result1]
     print -debug "result1=$result1"
     if {[regexp "04.00.00.22" $result1]} {
          set result [logAnalyzer -fileList "/opt/log/Log_FGW_CheckConstraints_errors.log" -hostIp $dut \
                    -operation "init"]
          print -debug "Execute FGWCheckConstraints TOOL"
          set result [execCommandSU -dut $dut -command "/opt/bin/FGWCheckConstraints.exe"]
          set result [logAnalyzer -fileList "/opt/log/Log_FGW_CheckConstraints_errors.log" -hostIp $dut \
                    -operation "verify"]
          if {[regexp "ERROR" $result]} {
               print -debug "found error $result"
               return 0
          } else {
               print -debug "no error"
               return -1
          }
     }
     
     return 0
}

proc gotoFgwCliRootNode {dut {nodeName ""}} {
     #-
     #- To get the FGW cli to go node using BSGCLI.exe application
     #-
     #- @in dut   Ip address of the host on which BSG is running
     #-
     #- @return 0 on no error,  -1 on error
     #-
     
     # if requested to go to root node, directly move to root by using cd
     # this will be cleanup call to restore cli to root for furthur using
     
     if {$nodeName == "root" } {
          set result [execCliCommand -dut $dut -command "cd"]
          if {[isCliError $result]} {
               print -err "Failed to go to the rootnode of the BSG cli"
               return -1
          } else {
               print -info "Moved to the rootnode of the BSG cli"
               return 0
          }
     }
     
     # go to specified node
     set result [execCliCommand -dut $dut -command "ls"]
     if {[isCliError $result]} {
          print -err "Failed to get the rootnode information from BSG cli"
          return -1
     }
     if {[regexp {FGW:\d+} $result dir]} {
          print -dbg "Got the root dir name as \"$dir\""
          #set result [execCliCommand -dut $dut -command "cd $dir"]
          #if {[isCliError $result]} {
          #     print -fail "Failed to go to the rootnode"
          #     return -1
          #} else {
          #     print -dbg "Successfully accessed root node"
          #}
     } else {
          print -fail "Failed to access the root node directory"
          return -1
     }
     
     # Goto specified node if nodeName is specified
     if {$nodeName != ""} {
          set result [execCliCommand -dut $dut -command "ls"]
          if {[isCliError $result]} {
               print -err "Failed to get the information"
               return -1
          }
          
          switch -regexp $nodeName {
               "BSG" {
                    if {[regexp {BSG:\d+} $result dir]} {
                         print -info "Got the BSG dir as \"$dir\""
                         set result [execCliCommand -dut $dut -command "cd $dir"]
                         if {[isCliError $result]} {
                              print -fail "Failed to go to the BSG node"
                              return -1
                         } else {
                              print -dbg "Successfully accessed BSG node"
                         }
                    }
               }
               "TraceControl" {
                    #First get the root node and then to the sub node
                    if {[regexp {ItfFgw:\d+} $result rootDir]} {
                         set result [execCliCommand -dut $dut -command "cd ${rootDir}/${nodeName}"]
                         if {[isCliError $result]} {
                              print -fail "Failed to go to the ${rootDir}/${nodeName} node"
                              return -1
                         } else {
                              print -dbg "Successfully accessed ${rootDir}/${nodeName} node"
                         }
                    }
               }
               default {
                    if {[regexp "$nodeName:\\d+" $result dir]} {
                         print -info "Got the BPG dir as \"$dir\""
                         set result [execCliCommand -dut $dut -command "cd $dir"]
                         if {[isCliError $result]} {
                              print -fail "Failed to go to the BPG node"
                              return -1
                         } else {
                              print -dbg "Successfully accessed BPG node"
                         }
                    }
               }
          }
     }
     
     return 0
}

