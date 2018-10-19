proc updateConfigDataWithKeywords {} {
     #-
     #- To create some keywords that are useful in scripts to retrieve data from configuration file
     #-
     #- This proc uses the parsed configuration data, identify the matches, generate data matching to a keyword requirement
     
     global ARR_PARSED_DATA
     
     set henbGwCount [llength [array names ARR_PARSED_DATA -regexp "lmtPort,"]]
     set ARR_PARSED_DATA(henbGwCount) $henbGwCount
     
     for {set i 0} {$i < $henbGwCount} {incr i} {
          
          # To identify MME, HeNB multihoming CPs
          foreach sim {mme henb} {
               set ${sim}Count [llength [array names ARR_PARSED_DATA -regexp "${sim}Sctp,$i"]]
               set ARR_PARSED_DATA(${sim}Count,$i) [set ${sim}Count]
               for {set j 0} {$j < [set ${sim}Count]} {incr j} {
                    set cp 0
                    foreach index [array names ARR_PARSED_DATA -regexp "${sim}SignalingPort,$i,$j"] {
                         incr cp
                         #To identify MultiHoming on henb/mme sim
                         set numericIndex [join [lrange [split $index ","] 1 end] ","]
                         set subInd "get[string totitle $sim]Cp${cp}"
                         
                         set ARR_PARSED_DATA(${subInd}Port,$i,$j) $ARR_PARSED_DATA(${sim}SignalingPort,$numericIndex)
                         set ARR_PARSED_DATA(${subInd}Vlan,$i,$j) $ARR_PARSED_DATA(${sim}SignalingVlan,$numericIndex)
                         set ARR_PARSED_DATA(${subInd}Mask,$i,$j) $ARR_PARSED_DATA(${sim}SignalingMask,$numericIndex)
                         set ARR_PARSED_DATA(${subInd}Ipaddress,$i,$j) $ARR_PARSED_DATA(${sim}SignalingIpaddress,$numericIndex)
                         lappend ARR_PARSED_DATA(getGwVlans,$i)  $ARR_PARSED_DATA(${sim}SignalingVlan,$numericIndex)
                    }
                    set ARR_PARSED_DATA(${sim}CpCount,$i,$j) $cp
               }
          }
          
          # To identify if OAM interface exists
          foreach index [array names ARR_PARSED_DATA -regexp "oam.*,$i"] {
               set subIndex    [regsub "^oam" $index "getOamClient"]
               set ARR_PARSED_DATA($subIndex,$i) $ARR_PARSED_DATA($index)
          }
          
          # identify no. of switches and their interfaces
          set switchCount [llength [array names ARR_PARSED_DATA -regexp "switchIpaddress,$i"]]
          set ARR_PARSED_DATA(switchCount,$i) $switchCount
          
          # To identify MME, HeNB Simulators
          set henbCp 1
          set mmeCp 1
          set oamCn 0
          for {set j 0} {$j < $switchCount} {incr j} {
               set ARR_PARSED_DATA(switchIntCount,$i,$j) 0
               
               foreach index [array names ARR_PARSED_DATA -regexp "switchInterfaceDescription,$i,$j"] {
                    incr ARR_PARSED_DATA(switchIntCount,$i,$j)
                    set numericIndex [join [lrange [split $index ","] 1 end] ","]
                    set intIndex  [lindex [split $index ","] end]
                    
                    # to retrieve switch port connected to Gateway
                    if {[regexp -nocase "connected to .*gw" $ARR_PARSED_DATA($index)]} {
                         switch -regexp $ARR_PARSED_DATA($index) {
                              {\s+port2\s+} {
                                   set ARR_PARSED_DATA(getGwSwitchPort2,$i,$j) $ARR_PARSED_DATA(switchInterfacePort,$numericIndex)
                              }
                              default {
                                   set ARR_PARSED_DATA(getGwSwitchPort,$i,$j) $ARR_PARSED_DATA(switchInterfacePort,$numericIndex)
                              }
                         }
                    }
                   
                    # To retrieve switch port connected from oam to gateway
                    if {[regexp -nocase "Connected to OAM" $ARR_PARSED_DATA($index)]} {
                         set ARR_PARSED_DATA(getGwOamSwitchPort,$i,$j) $ARR_PARSED_DATA(switchInterfacePort,$numericIndex) 
                    }   
                    # to retrieve switch ports connected to simulators
                    switch [lindex [string tolower [regexp -inline -nocase "(henb|mme)( )(sim|bearer)|(oam server)" $ARR_PARSED_DATA($index)]] 0] {
                         "henb sim" {
                              lappend ARR_PARSED_DATA(getHenbSimulatorHostIp,$i,$j)     $ARR_PARSED_DATA(switchInterfaceHostIpaddress,$numericIndex)
                              lappend ARR_PARSED_DATA(getHenbSimCpHostPort,$i,$j) $ARR_PARSED_DATA(switchInterfaceHostPort,$numericIndex)
                              set ARR_PARSED_DATA(getHenbSimCpSwitchPort,$i,$j)   $ARR_PARSED_DATA(switchInterfacePort,$numericIndex)
                              set ARR_PARSED_DATA(getHenbSimCpIntAndVlan,$i,$j) "[string trim $ARR_PARSED_DATA(switchInterfaceHostPort,$numericIndex)].[string trim [getDataFromConfigFile getHenbCp${henbCp}Vlan $i]]"
                              set ARR_PARSED_DATA(getHenbSimBearerIntAndVlan,$i,$j) "[string trim $ARR_PARSED_DATA(switchInterfaceHostPort,$numericIndex)].[string trim [getDataFromConfigFile henbBearerVlan $i]]"
                              incr henbCp
                         }
                         "mme sim" {
                              set ARR_PARSED_DATA(getMmeSimulatorHostIp,$i,$j)   $ARR_PARSED_DATA(switchInterfaceHostIpaddress,$numericIndex)
                              lappend ARR_PARSED_DATA(getMmeSimCp${mmeCp}HostPort,$i,$j) $ARR_PARSED_DATA(switchInterfaceHostPort,$numericIndex)
                              set ARR_PARSED_DATA(getMmeSimCp${mmeCp}SwitchPort,$i,$j)   $ARR_PARSED_DATA(switchInterfacePort,$numericIndex)
                              set ARR_PARSED_DATA(getMmeSimCp${mmeCp}IntAndVlan,$i,$j) "[string trim $ARR_PARSED_DATA(switchInterfaceHostPort,$numericIndex)].[getDataFromConfigFile getMmeCp${mmeCp}Vlan $i]"
                              set ARR_PARSED_DATA(getMmeSimBearerIntAndVlan,$i,$j) "[string trim $ARR_PARSED_DATA(switchInterfaceHostPort,$numericIndex)].[getDataFromConfigFile sgwVlan $i]"
                              incr mmeCp
                         }
                         "oam server" {
                              incr oamCn
                              set ARR_PARSED_DATA(getOamServerHostIp,$i,$j)       $ARR_PARSED_DATA(switchInterfaceHostIpaddress,$numericIndex)
                              lappend ARR_PARSED_DATA(getOamServerHostPort,$i,$j) $ARR_PARSED_DATA(switchInterfaceHostPort,$numericIndex)
                              set ARR_PARSED_DATA(getOamServerSwitchPort,$i,$j)   $ARR_PARSED_DATA(switchInterfacePort,$numericIndex)
                              set ARR_PARSED_DATA(getOamServerIntAndVlan,$i,$j)   "[string trim $ARR_PARSED_DATA(switchInterfaceHostPort,$numericIndex)].[string trim [getDataFromConfigFile oamVlan $i]]"
                         }
                    }
               }
               set ARR_PARSED_DATA(mmeSimCpCount,$i,$j) [expr $mmeCp - 1]
               set ARR_PARSED_DATA(oamIntCount,$i) $oamCn
          }
          
          # Code to populate the configuration required for routing setup
          if {![isEmptyList [array names ARR_PARSED_DATA -regexp switchInterfaceIntipaddress]]} {
               # The keyword switchInterfaceIntipaddress defines the L3 interface configuration on the switch
               set ::ROUTING_TB yes
               set henbCp 1
               set mmeCp 1
               set oamCn 0
               for {set j 0} {$j < $switchCount} {incr j} {
                    foreach index [array names ARR_PARSED_DATA -regexp "switchInterfaceDescription,$i,$j"] {
                         set numericIndex [join [lrange [split $index ","] 1 end] ","]
                         set intIndex  [lindex [split $index ","] end]
                         switch [lindex [string tolower [regexp -inline -nocase "(henb|mme)( )(sim|bearer)|(sr interface)|(oam server)" $ARR_PARSED_DATA($index)]] 0] {
                              "henb sim" {
                                   set ARR_PARSED_DATA(getHenbSimCpIpaddress,$i,$j)   $ARR_PARSED_DATA(switchInterfaceIntipaddress,$numericIndex)
                                   set ARR_PARSED_DATA(getHenbSimCpMask,$i,$j)        $ARR_PARSED_DATA(switchInterfaceIntmask,$numericIndex)
                                   set ARR_PARSED_DATA(getHenbSimCpVlan,$i,$j)        $ARR_PARSED_DATA(switchInterfaceIntvlan,$numericIndex)
                                   set ARR_PARSED_DATA(getHenbSimCpIntAndVlan,$i,$j) "[string trim $ARR_PARSED_DATA(switchInterfaceHostPort,$numericIndex)].[string trim \
                                             [getDataFromConfigFile getHenbSimCpVlan $i $j]]"
                                   
                              }
                              "mme sim" {
                                   print "mmeCp: $mmeCp"
                                   set ARR_PARSED_DATA(getMmeSimCp${mmeCp}Ipaddress,$i,$j)   $ARR_PARSED_DATA(switchInterfaceIntipaddress,$numericIndex)
                                   set ARR_PARSED_DATA(getMmeSimCp${mmeCp}Mask,$i,$j)        $ARR_PARSED_DATA(switchInterfaceIntmask,$numericIndex)
                                   set ARR_PARSED_DATA(getMmeSimCp${mmeCp}Vlan,$i,$j)        $ARR_PARSED_DATA(switchInterfaceIntvlan,$numericIndex)
                                   set ARR_PARSED_DATA(getMmeSimCp${mmeCp}IntAndVlan,$i,$j) "[string trim $ARR_PARSED_DATA(switchInterfaceHostPort,$numericIndex)].[string trim \
                                             [getDataFromConfigFile getMmeSimCp${mmeCp}Vlan $i $j]]"
                                   incr mmeCp
                              }
                              "sr interface" {
                                   lappend ARR_PARSED_DATA(getServiceRouterIpaddress,$i,$j)  $ARR_PARSED_DATA(switchInterfaceIntipaddress,$numericIndex)
                                   lappend ARR_PARSED_DATA(getServiceRouterMask,$i,$j)       $ARR_PARSED_DATA(switchInterfaceIntmask,$numericIndex)
                                   lappend ARR_PARSED_DATA(getServiceRouterVlan,$i,$j)       $ARR_PARSED_DATA(switchInterfaceIntvlan,$numericIndex)
                              }
                              "oam server" {
                                   set ARR_PARSED_DATA(getOamServerIpaddress,$i,$j)          $ARR_PARSED_DATA(switchInterfaceIntipaddress,$numericIndex)
                                   set ARR_PARSED_DATA(getOamServerMask,$i,$j)               $ARR_PARSED_DATA(switchInterfaceIntmask,$numericIndex)
                                   set ARR_PARSED_DATA(getOamServerVlan,$i,$j)               $ARR_PARSED_DATA(switchInterfaceIntvlan,$numericIndex)
                                   set ARR_PARSED_DATA(getOamServerIntAndVlan,$i,$j)         "[string trim $ARR_PARSED_DATA(switchInterfaceHostPort,$numericIndex)].[string trim \
                                             [getDataFromConfigFile getOamServerVlan $i $j]]"
                              }
                         }
                    }
               }
          } else {
               # Set the testbed type as L2
               set ::ROUTING_TB no
          }
          
          # Code to populate the bono and malban configuration
          if {![isEmptyList [array names ARR_PARSED_DATA -regexp bonoIpaddress]]} {
               for {set j 0} {$j < $switchCount} {incr j} {
                    foreach index [array names ARR_PARSED_DATA -regexp "(bono|malban|shm)"] {
                         set numericIndex [join [lrange [split $index ","] 1 end] ","]
                         regexp {(bono|malban|shm)} $index card
                         if {[info exists card]} {
                              switch -regexp $index {
                                   "Ipaddress" {lappend ARR_PARSED_DATA(get[string totitle $card]Ipaddress,$i) $ARR_PARSED_DATA(${card}Ipaddress,$numericIndex)}
                                   "Slot"      {lappend ARR_PARSED_DATA(get[string totitle $card]Slot,$i)      $ARR_PARSED_DATA(${card}Slot,$numericIndex)}
                              }
                         }
                    }
               }
               foreach card [list Bono Malban Shm] {
                    foreach param [list Ipaddress Slot] {
                         if {[info exists ARR_PARSED_DATA(get${card}${param},$i)]} {
                              set ARR_PARSED_DATA(get${card}${param},$i) [lsort -unique -dictionary $ARR_PARSED_DATA(get${card}${param},$i)]
                         }
                    }
               }
          }
          
          foreach index [array names ARR_PARSED_DATA -regexp "(Cp1|Cp2|Cp|Bearer|mme|sgw|oam)Vlan,$i"] {
               set numericIndex [join [lrange [split $index ","] 1 end] ","]
               # This will identify the vlans on HeNBGw for HeNB and MME
               switch -regexp $index {
                    "(HenbCp\[1-2\]Vlan|henbBearer)"  { lappend ARR_PARSED_DATA(getHenbGwVlans,$i) $ARR_PARSED_DATA($index) }
                    "(^sgw|MmeCp\[1-2\]Vlan)"         { lappend ARR_PARSED_DATA(getMmeGwVlans,$i)  $ARR_PARSED_DATA($index) }
                    "^oam"                            { lappend ARR_PARSED_DATA(getOamVlans,$i)    $ARR_PARSED_DATA($index) }
               }
               
               if {$::ROUTING_TB == "no"} {
                    switch -regexp $index {
                         "(HenbCp1|henbBearer)"       { lappend ARR_PARSED_DATA(getHenbSimulatorVlans,$i) $ARR_PARSED_DATA($index)}
                         "(MmeCp1|^sgw)"              { lappend ARR_PARSED_DATA(getMmeSimulatorVlans,$i) $ARR_PARSED_DATA($index)}
                    }
               } else {
                    
                    # This block would identify the vlans that needs to be configured towards the Simulator
                    switch -regexp $index {
                         "(HenbSimCp)"                { lappend ARR_PARSED_DATA(getHenbSimulatorVlans,$i) $ARR_PARSED_DATA($index) }
                         "(getMmeSimCp)"              { lappend ARR_PARSED_DATA(getMmeSimulatorVlans,$i) $ARR_PARSED_DATA($index)  }
                    }
               }
               
               if {[regexp {getMmeCp2Vlan} $index] && [info exists ARR_PARSED_DATA(getMmeSimCp2SwitchPort,$i,0)]} {
                    #vlans to be configured on mme sim port 2
                    lappend ARR_PARSED_DATA(getMmeSimulatorVlans2,$i)    $ARR_PARSED_DATA($index)
               }
               
               if {[regexp {getHenbCp2Vlan|getMmeCp2Vlan} $index] && [info exists ARR_PARSED_DATA(getGwSwitchPort2,$i,0)]} {
                    #vlans to configured on GW port 2
                    lappend ARR_PARSED_DATA(getVlansOnSwitch2,$i)   $ARR_PARSED_DATA($index)
               } else {
                    #vlans to configured on default GW port
                    lappend ARR_PARSED_DATA(getVlansOnSwitch,$i)    $ARR_PARSED_DATA($index)
               }
          }
          
          # The below configuration would be done only in case of a Routing setup
          # In this case the switch <--> host ip address and vlan configuration has to be done
          if {$::ROUTING_TB == "yes"} {
               # Switch interface and corrsponding vlan
               if { [ info exists  ARR_PARSED_DATA(getGwSwitchPort,$i,0) ] } {
                    if { [ info exists ARR_PARSED_DATA(getHenbCp1Vlan,$i,0) ] } {
                         lappend ARR_PARSED_DATA(cisocIntVlan,$ARR_PARSED_DATA(getGwSwitchPort,$i,0)) $ARR_PARSED_DATA(getHenbCp1Vlan,$i,0)
                    }
                    
                    if {![isATCASetup] && ![isIfCfgThrMON]} {
                         if { [  info exists ARR_PARSED_DATA(getMmeCp2Vlan,$i,0) ] } {
                              lappend ARR_PARSED_DATA(cisocIntVlan,$ARR_PARSED_DATA(getGwSwitchPort,$i,0)) $ARR_PARSED_DATA(getMmeCp2Vlan,$i,0)
                         }
                    } else {
                         #For Mon configured setups
                         if { [ info exists ARR_PARSED_DATA(getMmeCp1Vlan,$i,0) ] } {
                              lappend ARR_PARSED_DATA(cisocIntVlan,$ARR_PARSED_DATA(getGwSwitchPort,$i,0)) $ARR_PARSED_DATA(getMmeCp1Vlan,$i,0)
                         }
                         if { [ info exists ARR_PARSED_DATA(getServiceRouterVlan,$i,0) ] } {
                              lappend ARR_PARSED_DATA(cisocIntVlan,$ARR_PARSED_DATA(getGwSwitchPort,$i,0)) [lindex $ARR_PARSED_DATA(getServiceRouterVlan,$i,0) 0]
                         }
                         if { [ info exists ARR_PARSED_DATA(getOamServerVlan,$i,0) ] } {
                              lappend ARR_PARSED_DATA(cisocIntVlan,$ARR_PARSED_DATA(getOamServerVlan,$i,0)) [lindex $ARR_PARSED_DATA(getOamServerVlan,$i,0) 0]
                         }
                    }
                    
               }
               
               if { [ info exists  ARR_PARSED_DATA(getGwSwitchPort2,$i,0) ] } {
                    
                    if {![isATCASetup] && ![isIfCfgThrMON]} {
                         if { [ info exists ARR_PARSED_DATA(getHenbCp2Vlan,$i,0) ] } {
                              lappend ARR_PARSED_DATA(cisocIntVlan,$ARR_PARSED_DATA(getGwSwitchPort2,$i,0)) $ARR_PARSED_DATA(getHenbCp2Vlan,$i,0)
                         }
                         if { [  info exists ARR_PARSED_DATA(getMmeCp1Vlan,$i,0) ] } {
                              lappend ARR_PARSED_DATA(cisocIntVlan,$ARR_PARSED_DATA(getGwSwitchPort2,$i,0)) $ARR_PARSED_DATA(getMmeCp1Vlan,$i,0)
                         }
                    } else {
                         #For Mon configured setups
                         if { [ info exists ARR_PARSED_DATA(getHenbCp2Vlan,$i,0) ] } {
                              lappend ARR_PARSED_DATA(cisocIntVlan,$ARR_PARSED_DATA(getGwSwitchPort2,$i,0)) $ARR_PARSED_DATA(getHenbCp2Vlan,$i,0)
                         }
                         if { [  info exists ARR_PARSED_DATA(getMmeCp2Vlan,$i,0) ] } {
                              lappend ARR_PARSED_DATA(cisocIntVlan,$ARR_PARSED_DATA(getGwSwitchPort2,$i,0)) $ARR_PARSED_DATA(getMmeCp2Vlan,$i,0)
                         }
                         if { [  info exists ARR_PARSED_DATA(getServiceRouterVlan,$i,0) ] } {
                              lappend ARR_PARSED_DATA(cisocIntVlan,$ARR_PARSED_DATA(getGwSwitchPort2,$i,0)) [lindex $ARR_PARSED_DATA(getServiceRouterVlan,$i,0) 1]
                         }
                    }
                    
               }
               
               if { [ info exists  ARR_PARSED_DATA(getHenbSimCpSwitchPort,$i,0)] &&  [ info exists ARR_PARSED_DATA(getMmeSimCp1SwitchPort,$i,0)] } {
                    if { [ info exists ARR_PARSED_DATA(getHenbSimCpVlan,$i,0) ] } {
                         lappend ARR_PARSED_DATA(cisocIntVlan,$ARR_PARSED_DATA(getHenbSimCpSwitchPort,$i,0)) $ARR_PARSED_DATA(getHenbSimCpVlan,$i,0)
                    }
                    if { [  info exists ARR_PARSED_DATA(getMmeCp1Vlan,$i,0) ] } {
                         lappend ARR_PARSED_DATA(cisocIntVlan,$ARR_PARSED_DATA(getMmeSimCp1SwitchPort,$i,0)) $ARR_PARSED_DATA(getMmeSimCp1Vlan,$i,0)
                    }
               }
               
               if { [ info exists ARR_PARSED_DATA(getMmeSimCp2SwitchPort,$i,0)] } {
                    if { [  info exists ARR_PARSED_DATA(getMmeCp2Vlan,$i,0) ] } {
                         lappend ARR_PARSED_DATA(cisocIntVlan,$ARR_PARSED_DATA(getMmeSimCp2SwitchPort,$i,0)) $ARR_PARSED_DATA(getMmeSimCp2Vlan,$i,0)
                    }
               }
               
               # Get the list of vlans to be configured on switch
               set ARR_PARSED_DATA(getVlansOnSwitch,$i) "$ARR_PARSED_DATA(getHenbSimulatorVlans,$i) $ARR_PARSED_DATA(getMmeSimulatorVlans,$i) \
                         $ARR_PARSED_DATA(getHenbGwVlans,$i) $ARR_PARSED_DATA(getMmeGwVlans,$i)"
               # Add the OAM interface if it exists
               if {[info exists ARR_PARSED_DATA(getOamVlans,$i)]} {lappend ARR_PARSED_DATA(getVlansOnSwitch,$i) $ARR_PARSED_DATA(getOamVlans,$i)}
               for {set j 0} {$j < $switchCount} {incr j} {
                    if {[info exists ARR_PARSED_DATA(getOamServerVlan,$i,$j)]} {lappend ARR_PARSED_DATA(getVlansOnSwitch,$i) $ARR_PARSED_DATA(getOamServerVlan,$i,$j)}
               }
          }
          
          if {[isATCASetup]} {
               # Get the ports on the switch that would be connected to the MALBAN
               # These ports would be part of a LAG interface
               for {set j 0} {$j < $switchCount} {incr j} {
                    foreach index [array names ARR_PARSED_DATA -regexp "switchInterfaceDescription,$i,$j"] {
                         set numericIndex [join [lrange [split $index ","] 1 end] ","]
                         set intIndex  [lindex [split $index ","] end]
                         
                         # to retrieve switch port connected to Gateway
                         if {[regexp -nocase "connected to BONO" $ARR_PARSED_DATA($index)]} {
                              regsub {,\d+$} $numericIndex "" numIndex
                              lappend ARR_PARSED_DATA(getSwitchMalbanPort,$numIndex) $ARR_PARSED_DATA(switchInterfacePort,$numericIndex)
                         } elseif {[regexp -nocase "connected to switch" $ARR_PARSED_DATA($index)]} {
                              lappend ARR_PARSED_DATA(getSwitch2SwitchPort,$i,$j) $ARR_PARSED_DATA(switchInterfacePort,$numericIndex)
                         }
                    }
               }
               
          }
          
          # identify ixia index list
          foreach index [array names ARR_PARSED_DATA -regexp "switchInterfaceIxiaCard,$i,"] {
               lappend ARR_PARSED_DATA(ixiaIndexList,$i) [lindex [split $index ","] 3]
          }
          # identify fgw port
          foreach index [array names ARR_PARSED_DATA -regexp "henb(|Signaling)Port,$i,"] {
               lappend ARR_PARSED_DATA(getHenbGwPort,$i) $ARR_PARSED_DATA($index)
          }
     }
     parray ARR_PARSED_DATA
}

proc updateConfigDataValues {args} {
     #-
     #- This procedure is used to update the testbed config data that is generated by the updateConfigDataWithKeywords
     #- The values to be updated are sent either as key-value pair OR as keyList and their respective opList
     #-
     #- @return 0 on sucess and -1 on failure
     #-
     
     global ARR_PARSED_DATA
     
     set flag 0
     parseArgs args \
               [list \
               [list fgwNum              "optional"  "numeric"     "0"            "The dut instance in the testbed file"] \
               [list switchNum           "optional"  "numeric"     "0"            "The switch instance in the testbed file"] \
               [list paramList           "optional" "string"      "__UN_DEFINED__" "The key=val list to be updated"] \
               ]
     
     if {[info exists paramList]} {
          foreach ele $paramList {
               foreach {key value} [split $ele "="] {break}
               if {![catch [set ARR_PARSED_DATA($key,$fgwNum,$switchNum) $val]]} {
                    print -fail "$key updation in testbed config failed "
                    return -1
               } else {
                    print -debug "$key is updated with $val"
               }
          }
     } else {
          
          set vlaidIps "CNCP1|CNCP2|HeNBCP1|HeNBCP2|HeNBBearer|SGWBearer"
          parseArgs args \
                    [list \
                    [list keyList             "mandatory" "string"      "_" "List of ipaddress keys to be updated"] \
                    [list opList              "mandatory" "string"      "_" "type of ip values to be updated"] \
                    [list intFlop             "optional"  "yes|no"      "no" "interface to be flopped"] \
                    ]
          
          if { $intFlop == "yes" } {
               #Getting existing GW interfaces
               set gwPort1 [getDataFromConfigFile getHenbCp1Port $fgwNum $switchNum]
               set gwPort2 [getDataFromConfigFile getMmeCp1Port  $fgwNum $switchNum]
               
               set swIntTwdGw1 [ getDataFromConfigFile   switchInterfacePort $fgwNum $switchNum 0]
               set swIntTwdGw2 [ getDataFromConfigFile   switchInterfacePort $fgwNum $switchNum 1]
               
               #For interchanging GW interfaces of a vlan group
               foreach key $keyList op $opList {
                    
                    set keyName [string map -nocase "CNCP1 getMmeCp1Port \
                              CNCP2 getMmeCp2Port \
                              HeNBCP1 getHenbCp1Port \
                              HeNBCP2 getHenbCp2Port \
                              HeNBBearer henbBearerPort \
                              SGWBearer sgwPort \
                              " $key]
                    
                    if {![catch [set oldVal  [getDataFromConfigFile $keyName $fgwNum $switchNum]]]} {
                         print -fail "$keyName is not existing key in testbed config"
                         return -1
                    }
                    
                    switch $op {
                         "port1" {
                              if {$oldVal == $gwPort1} {
                                   print -debug "$keyName is already on gw port1 $oldVal"
                                   continue
                              } else {
                                   set newVal $gwPort1
                                   
                                   #Removing respective vlan from old vlan group And adding to new vlan group on gw
                                   set vlan [getDataFromConfigFile [regsub {Port} $keyName {Vlan}] $fgwNum $switchNum]
                                   
                                   #Deleting from old group
                                   set oldVlans $ARR_PARSED_DATA(getVlansOnSwitch2,$fgwNum)
                                   set ind [lsearch -exact $oldVlans $vlan]
                                   set ARR_PARSED_DATA(getVlansOnSwitch2,$fgwNum) [lreplace $oldVlans $ind $ind]
                                   
                                   #Adding to new group
                                   set newVlans $ARR_PARSED_DATA(getVlansOnSwitch,$fgwNum)
                                   set ARR_PARSED_DATA(getVlansOnSwitch,$fgwNum) [linsert $newVlans end $vlan]
                                   if { $keyName == "getMmeCp1Port" } {
                                        set  ARR_PARSED_DATA(cisocIntVlan,$swIntTwdGw1) [ lreplace $ARR_PARSED_DATA(cisocIntVlan,$swIntTwdGw1) end end $vlan ]
                                   }
                                   
                              }
                         }
                         "port2" {
                              
                              if {$oldVal == $gwPort2} {
                                   print -debug "$keyName is already on gw port2 $oldVal"
                                   continue
                              } else {
                                   set newVal $gwPort2
                                   #Removing respective vlan from old vlan group And adding to new vlan group on gw
                                   set vlan [getDataFromConfigFile [regsub {Port} $keyName {Vlan}] $fgwNum $switchNum]
                                   
                                   #Deleting from old group
                                   set oldVlans $ARR_PARSED_DATA(getVlansOnSwitch,$fgwNum)
                                   set ind [lsearch -exact $oldVlans $vlan]
                                   set ARR_PARSED_DATA(getVlansOnSwitch,$fgwNum) [lreplace $oldVlans $ind $ind $vlan]
                                   
                                   #Adding to new group
                                   set newVlans $ARR_PARSED_DATA(getVlansOnSwitch2,$fgwNum)
                                   set ARR_PARSED_DATA(getVlansOnSwitch2,$fgwNum) [linsert $newVlans end $vlan]
                              }
                              
                              if { $keyName == "getMmeCp2Port" } {
                                   set  ARR_PARSED_DATA(cisocIntVlan,$swIntTwdGw2) [ lreplace $ARR_PARSED_DATA(cisocIntVlan,$swIntTwdGw2) end end $vlan ]
                              }
                         }
                         default {
                              print -fail "$op is an invalid option"
                              return -1
                         }
                    }
                    if {![catch [set ARR_PARSED_DATA($keyName,$fgwNum,$switchNum) $newVal]]} {
                         print -fail "$keyName updation in testbed config failed "
                         return -1
                    } else {
                         print -debug "$keyName is updated with $newVal"
                    }
                    
               }
          } else {
               foreach key $keyList op $opList {
                    foreach {ip mask} [string map -nocase "CNCP1 {getMmeCp1Ipaddress getMmeCp1Mask} \
                              CNCP2 {getMmeCp2Ipaddress getMmeCp2Mask} \
                              HeNBCP1 {getHenbCp1Ipaddress getHenbCp1Mask} \
                              HeNBCP2 {getHenbCp2Ipaddress getHenbCp2Mask} \
                              HeNBBearer {henbBearerIpaddress henbBearerMask} \
                              SGWBearer {sgwIpaddress sgwMask} \
                              " $key] break
                    
                    set  ipSim [ string map -nocase "getMmeCp1Ipaddress  getMmeSimCp1Ipaddress  \
                              getMmeCp2Ipaddress  getMmeSimCp2Ipaddress  \
                              getHenbCp1Ipaddress getHenbSimCpIpaddress  \
                              getHenbCp2Ipaddress getHenbSimCpIpaddress  \
                              HeNBBearer   HeNBSimBearer  \
                              SGWBearer           SGWSimBearer " $ip ]
                    
                    set  ipSimMask [ string map -nocase  "getMmeCp1Mask       getMmeSimCp1Mask\
                              getMmeCp2Mask  getMmeSimCp2Mask\
                              getHenbCp1Mask getHenbSimCpMask \
                              getHenbCp2Mask getHenbSimCpMask" $mask ]
                    
                    if {![catch [set oldVal  [getDataFromConfigFile $ip $fgwNum $switchNum]]]} {
                         print -fail "$ip is not existing key in testbed config"
                         return -1
                    }
                    
                    if {![catch [set oldValSim  [getDataFromConfigFile $ipSim $fgwNum $switchNum]]]} {
                         print -fail "$ip is not existing key in testbed config"
                         return -1
                    }
                    
                    switch $op {
                         "ipv4" {
                              if {[::ip::is 6 [set oldVal]] && [::ip::is 6 [set oldValSim]] } {
                                   set newVal    [ipv6To4 -ip [::ip::normalize $oldVal]]
                                   set newValSim [ipv6To4 -ip [::ip::normalize $oldValSim]]
                                   set newMask "255.255.0.0"
                              } else {
                                   print -debug "$ip is already an ipv4 address $oldVal"
                                   continue
                              }
                         }
                         "ipv6" {
                              if {[::ip::is 4 [set oldVal]] && [::ip::is 4 [set oldValSim]] } {
                                   set newVal    [ipv4To6    -ip $oldVal -modifyPrefix "yes"]
                                   set newValSim [ipv4To6    -ip $oldValSim -modifyPrefix "yes"]
                                   set newMask "120"
                              } else {
                                   print -debug "$ip is already an ipv6 address $oldVal"
                                   continue
                              }
                         }
                         default {
                              print -fail "$op is an invalid option"
                              return -1
                         }
                    }
                    
                    foreach param "$ip $mask $ipSim $ipSimMask" val "$newVal $newMask $newValSim $newMask" {
                         if {![catch [set ARR_PARSED_DATA($param,$fgwNum,$switchNum) $val]]} {
                              print -fail "$param updation in testbed config failed "
                              return -1
                         } else {
                              print -debug "$param is updated with $op $val"
                         }
                    }
               }
          }
     }
     parray ARR_PARSED_DATA
     return 0
}

proc updateConfigDataWithKeywordsForRoutingTestbed {} {
     #-
     #- To create some keywords that are useful in scripts to retrieve data from configuration file
     #-
     #- This proc uses the parsed configuration data, identify the matches, generate data matching to a keyword requirement
     
     global ARR_PARSED_DATA
     
     set henbGwCount [llength [array names ARR_PARSED_DATA -regexp "lmtPort,"]]
     set ARR_PARSED_DATA(henbGwCount) $henbGwCount
     
     for {set i 0} {$i < $henbGwCount} {incr i} {
          
          # To identify MME, HeNB multihoming CPs
          foreach sim {mme henb} {
               set ${sim}Count [llength [array names ARR_PARSED_DATA -regexp "${sim}Sctp,$i"]]
               set ARR_PARSED_DATA(${sim}Count,$i) [set ${sim}Count]
               for {set j 0} {$j < [set ${sim}Count]} {incr j} {
                    set cp 0
                    foreach index [array names ARR_PARSED_DATA -regexp "${sim}SignalingPort,$i,$j"] {
                         incr cp
                         #To identify MultiHoming on henb/mme sim
                         set numericIndex [join [lrange [split $index ","] 1 end] ","]
                         set subInd "get[string totitle $sim]Cp${cp}"
                         
                         set ARR_PARSED_DATA(${subInd}Port,$i,$j) $ARR_PARSED_DATA(${sim}SignalingPort,$numericIndex)
                         set ARR_PARSED_DATA(${subInd}Vlan,$i,$j) $ARR_PARSED_DATA(${sim}SignalingVlan,$numericIndex)
                         set ARR_PARSED_DATA(${subInd}Mask,$i,$j) $ARR_PARSED_DATA(${sim}SignalingMask,$numericIndex)
                         set ARR_PARSED_DATA(${subInd}Ipaddress,$i,$j) $ARR_PARSED_DATA(${sim}SignalingIpaddress,$numericIndex)
                    }
                    set ARR_PARSED_DATA(${sim}CpCount,$i,$j) $cp
               }
          }
          
          # identify no. of switches and their interfaces
          set switchCount [llength [array names ARR_PARSED_DATA -regexp "switchIpaddress,$i"]]
          set ARR_PARSED_DATA(switchCount,$i) $switchCount
          
          # To identify MME, HeNB Simulators
          for {set j 0} {$j < $switchCount} {incr j} {
               set ARR_PARSED_DATA(switchIntCount,$i,$j) 0
               set henbCp 1
               set mmeCp 1
               
               foreach index [array names ARR_PARSED_DATA -regexp "switchInterfaceDescription,$i,$j"] {
                    incr ARR_PARSED_DATA(switchIntCount,$i,$j)
                    set numericIndex [join [lrange [split $index ","] 1 end] ","]
                    set intIndex  [lindex [split $index ","] end]
                    
                    # to retrieve switch port connected to Gateway
                    if {[regexp -nocase "connected to .*gw" $ARR_PARSED_DATA($index)]} {
                         switch -regexp $ARR_PARSED_DATA($index) {
                              {\s+port2\s+} {
                                   set ARR_PARSED_DATA(getGwSwitchPort2,$i,$j) $ARR_PARSED_DATA(switchInterfacePort,$numericIndex)
                              }
                              default {
                                   set ARR_PARSED_DATA(getGwSwitchPort,$i,$j) $ARR_PARSED_DATA(switchInterfacePort,$numericIndex)
                              }
                         }
                    }
                    
                    # to retrieve switch ports connected to simulators
                    switch [lindex [string tolower [regexp -inline -nocase "(henb|mme)( )(sim|bearer)" $ARR_PARSED_DATA($index)]] 0] {
                         "henb sim" {
                              lappend ARR_PARSED_DATA(getHenbSimulatorHostIp,$i,$j)     $ARR_PARSED_DATA(switchInterfaceHostIpaddress,$numericIndex)
                              lappend ARR_PARSED_DATA(getHenbSimCpHostPort,$i,$j) $ARR_PARSED_DATA(switchInterfaceHostPort,$numericIndex)
                              set ARR_PARSED_DATA(getHenbSimCpSwitchPort,$i,$j)   $ARR_PARSED_DATA(switchInterfacePort,$numericIndex)
                              set ARR_PARSED_DATA(getHenbSimCpIntAndVlan,$i,$j) "[string trim $ARR_PARSED_DATA(switchInterfaceHostPort,$numericIndex)].[string trim [getDataFromConfigFile getHenbCp${henbCp}Vlan $i]]"
                              set ARR_PARSED_DATA(getHenbSimBearerIntAndVlan,$i,$j) "[string trim $ARR_PARSED_DATA(switchInterfaceHostPort,$numericIndex)].[string trim [getDataFromConfigFile henbBearerVlan $i]]"
                              incr henbCp
                         }
                         "mme sim" {
                              set ARR_PARSED_DATA(getMmeSimulatorHostIp,$i,$j)   $ARR_PARSED_DATA(switchInterfaceHostIpaddress,$numericIndex)
                              lappend ARR_PARSED_DATA(getMmeSimCp${mmeCp}HostPort,$i,$j) $ARR_PARSED_DATA(switchInterfaceHostPort,$numericIndex)
                              set ARR_PARSED_DATA(getMmeSimCp${mmeCp}SwitchPort,$i,$j)   $ARR_PARSED_DATA(switchInterfacePort,$numericIndex)
                              set ARR_PARSED_DATA(getMmeSimCp${mmeCp}IntAndVlan,$i,$j) "[string trim $ARR_PARSED_DATA(switchInterfaceHostPort,$numericIndex)].[getDataFromConfigFile getMmeCp${mmeCp}Vlan $i]"
                              set ARR_PARSED_DATA(getMmeSimBearerIntAndVlan,$i,$j) "[string trim $ARR_PARSED_DATA(switchInterfaceHostPort,$numericIndex)].[getDataFromConfigFile sgwVlan $i]"
                              incr mmeCp
                         }
                    }
               }
               set ARR_PARSED_DATA(mmeSimCpCount,$i,$j) [expr $mmeCp - 1]
          }
          
          ####### Code to populate the info for routing setup #########################
          for {set j 0} {$j < $switchCount} {incr j} {
               set henbCp 1
               set mmeCp 1
               foreach index [array names ARR_PARSED_DATA -regexp "switchInterfaceDescription,$i,$j"] {
                    set numericIndex [join [lrange [split $index ","] 1 end] ","]
                    set intIndex  [lindex [split $index ","] end]
                    switch [lindex [string tolower [regexp -inline -nocase "(henb|mme)( )(sim|bearer)" $ARR_PARSED_DATA($index)]] 0] {
                         "henb sim" {
                              set ARR_PARSED_DATA(getHenbSimCpIpaddress,$i,$j)   $ARR_PARSED_DATA(switchInterfaceIntipaddress,$numericIndex)
                              set ARR_PARSED_DATA(getHenbSimCpMask,$i,$j)        $ARR_PARSED_DATA(switchInterfaceIntmask,$numericIndex)
                              set ARR_PARSED_DATA(getHenbSimCpVlan,$i,$j)        $ARR_PARSED_DATA(switchInterfaceIntvlan,$numericIndex)
                              set ARR_PARSED_DATA(getHenbSimCpIntAndVlan,$i,$j) "[string trim $ARR_PARSED_DATA(switchInterfaceHostPort,$numericIndex)].[string trim \
                                        [getDataFromConfigFile getHenbSimCpVlan $i]]"
                              
                         }
                         "mme sim" {
                              set ARR_PARSED_DATA(getMmeSimCp${mmeCp}Ipaddress,$i,$j)   $ARR_PARSED_DATA(switchInterfaceIntipaddress,$numericIndex)
                              set ARR_PARSED_DATA(getMmeSimCp${mmeCp}Mask,$i,$j)        $ARR_PARSED_DATA(switchInterfaceIntmask,$numericIndex)
                              set ARR_PARSED_DATA(getMmeSimCp${mmeCp}Vlan,$i,$j)        $ARR_PARSED_DATA(switchInterfaceIntvlan,$numericIndex)
                              set ARR_PARSED_DATA(getMmeSimCp${mmeCp}IntAndVlan,$i,$j) "[string trim $ARR_PARSED_DATA(switchInterfaceHostPort,$numericIndex)].[string trim \
                                        [getDataFromConfigFile getMmeSimCp${mmeCp}Vlan $i]]"
                              incr mmeCp
                         }
                    }
               }
          }
          ##############################################################################
          
          foreach index [array names ARR_PARSED_DATA -regexp "(Cp1|Cp2|Cp|Bearer|mme|sgw)Vlan,$i"] {
               set numericIndex [join [lrange [split $index ","] 1 end] ","]
               # To identify vlans for simulators
               switch -regexp $index {
                    "(HenbSimCp)"        { lappend ARR_PARSED_DATA(getHenbSimulatorVlans,$i) $ARR_PARSED_DATA($index) }
                    "(getMmeSimCp)"      { lappend ARR_PARSED_DATA(getMmeSimulatorVlans,$i) $ARR_PARSED_DATA($index)  }
                    "(HenbCp)"           { lappend ARR_PARSED_DATA(getHenbGwVlans,$i) $ARR_PARSED_DATA($index) }
                    "(MmeCp)"            { lappend ARR_PARSED_DATA(getMmeGwVlans,$i) $ARR_PARSED_DATA($index)  }
                    
               }
               
               if {[regexp {getMmeSimCp2Vlan} $index] && [info exists ARR_PARSED_DATA(getMmeSimCp2SwitchPort,$i,0)]} {
                    #vlans to be configured on mme sim port 2
                    lappend ARR_PARSED_DATA(getMmeSimulatorVlans2,$i)    $ARR_PARSED_DATA($index)
                    #vlans to configured on default GW port
                    lappend ARR_PARSED_DATA(getVlansOnSwitch,$i)    $ARR_PARSED_DATA($index)
               } elseif {[regexp {getHenbCp2Vlan|getMmeCp1Vlan} $index] && [info exists ARR_PARSED_DATA(getGwSwitchPort2,$i,0)]} {
                    #vlans to configured on GW port 2
                    lappend ARR_PARSED_DATA(getVlansOnSwitch2,$i)   $ARR_PARSED_DATA($index)
               } else {
                    #vlans to configured on default GW port
                    lappend ARR_PARSED_DATA(getVlansOnSwitch,$i)    $ARR_PARSED_DATA($index)
               }
          }
          
          # Switch interface and corrsponding vlan
          if { [ info exists  ARR_PARSED_DATA(getGwSwitchPort,$i,0) ] } {
               if { [ info exists ARR_PARSED_DATA(getHenbCp1Vlan,$i,0) ] } {
                    lappend ARR_PARSED_DATA(cisocIntVlan,$ARR_PARSED_DATA(getGwSwitchPort,$i,0)) $ARR_PARSED_DATA(getHenbCp1Vlan,$i,0)
               }
               if { [  info exists ARR_PARSED_DATA(getMmeCp2Vlan,$i,0) ] } {
                    lappend ARR_PARSED_DATA(cisocIntVlan,$ARR_PARSED_DATA(getGwSwitchPort,$i,0)) $ARR_PARSED_DATA(getMmeCp2Vlan,$i,0)
               }
          }
          
          if { [ info exists  ARR_PARSED_DATA(getGwSwitchPort2,$i,0) ] } {
               if { [ info exists ARR_PARSED_DATA(getHenbCp2Vlan,$i,0) ] } {
                    lappend ARR_PARSED_DATA(cisocIntVlan,$ARR_PARSED_DATA(getGwSwitchPort2,$i,0)) $ARR_PARSED_DATA(getHenbCp2Vlan,$i,0)
               }
               if { [  info exists ARR_PARSED_DATA(getMmeCp1Vlan,$i,0) ] } {
                    lappend ARR_PARSED_DATA(cisocIntVlan,$ARR_PARSED_DATA(getGwSwitchPort2,$i,0)) $ARR_PARSED_DATA(getMmeCp1Vlan,$i,0)
               }
          }
          
          if { [ info exists  ARR_PARSED_DATA(getHenbSimCpSwitchPort,$i,0)] &&  [ info exists ARR_PARSED_DATA(getMmeSimCp1SwitchPort,$i,0)] } {
               if { [ info exists ARR_PARSED_DATA(getHenbSimCpVlan,$i,0) ] } {
                    lappend ARR_PARSED_DATA(cisocIntVlan,$ARR_PARSED_DATA(getHenbSimCpSwitchPort,$i,0)) $ARR_PARSED_DATA(getHenbSimCpVlan,$i,0)
               }
               if { [  info exists ARR_PARSED_DATA(getMmeCp1Vlan,$i,0) ] } {
                    lappend ARR_PARSED_DATA(cisocIntVlan,$ARR_PARSED_DATA(getHenbSimCpSwitchPort,$i,0)) $ARR_PARSED_DATA(getMmeSimCp1Vlan,$i,0)
               }
          }
          
          if { [ info exists ARR_PARSED_DATA(getMmeSimCp2SwitchPort,$i,0)] } {
               if { [  info exists ARR_PARSED_DATA(getMmeCp1Vlan,$i,0) ] } {
                    lappend ARR_PARSED_DATA(cisocIntVlan,$ARR_PARSED_DATA(getMmeSimCp2SwitchPort,$i,0)) $ARR_PARSED_DATA(getMmeSimCp2Vlan,$i,0)
               }
          }
          
          set ARR_PARSED_DATA(getVlansOnSwitch,$i) "$ARR_PARSED_DATA(getHenbSimulatorVlans,$i) $ARR_PARSED_DATA(getMmeSimulatorVlans,$i) \
                    $ARR_PARSED_DATA(getHenbGwVlans,$i) $ARR_PARSED_DATA(getMmeGwVlans,$i)"
          
          # identify ixia index list
          foreach index [array names ARR_PARSED_DATA -regexp "switchInterfaceIxiaCard,$i,"] {
               lappend ARR_PARSED_DATA(ixiaIndexList,$i) [lindex [split $index ","] 3]
          }
          # identify fgw port
          foreach index [array names ARR_PARSED_DATA -regexp "henb(|Signaling)Port,$i,"] {
               lappend ARR_PARSED_DATA(getHenbGwPort,$i) $ARR_PARSED_DATA($index)
          }
          
     }
     parray ARR_PARSED_DATA
}

proc mapKeywordIfRequired {keyword} {
    return $keyword
}
