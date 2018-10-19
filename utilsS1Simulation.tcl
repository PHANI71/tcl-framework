proc getValidClass1Procedures {} {

     set validClass1Procedures [list \
               "handover_required" \
               "handover_command" \
               "handover_preparation_failure" \
               "handover_request" \
               "handover_request_ackowledge" \
               "handover_failure" \
               "path_switch_request" \
               "path_switch_request_ackowledge" \
               "path_switch_request_failure" \
               "handover_cancel" \
               "handover_cancel_ackowledge" \
               "e-rab_setup_request" \
               "e-rab_setup_response" \
               "e-rab_modify_request" \
               "e-rab_modify_response" \
               "e-rab_release_command" \
               "e-rab_release_response" \
               "initial_context_setup_request" \
               "initial_context_setup_response" \
               "initial_context_setup_failure" \
               "reset" \
               "reset_acknowledge" \
               "s1_setup_request" \
               "s1_setup_response" \
               "s1_setup_failure" \
               "ue_context_release_command" \
               "ue_context_release_complete" \
               "ue_context_modification_request" \
               "ue_context_modification_response" \
               "ue_context_modification_failure" \
               "enb_configuration_update" \
               "enb_configuration_update_ackowledge" \
               "enb_configuration_update_failure" \
               "mme_configuration_update" \
               "mme_configuration_update_acknowledge" \
               "mme_configuration_update_failure" \
               "write-replace_warning_request" \
               "write-replace_warning_response" \
               "kill_request" \
               "kill_response"
     ]
     return $validClass1Procedures
}

proc getValidClass2Procedures {} {
     set validClass2Procedures [list \
               "handover_notify" \
               "e-rab_release_indication" \
               "paging" \
               "initial_ue_message" \
               "downlink_nas_transport" \
               "uplink_nas_transport" \
               "nas_non_delivery_indication" \
               "error_indication" \
               "ue_context_release_request" \
               "downlink_s1_cdma2000_tunneling" \
               "uplink_s1_cdma2000_tunneling" \
               "ue_capability_info_indication" \
               "enb_status_transfer" \
               "mme_status_transfer" \
               "mme_config_transfer" \
               "deactivate_trace" \
               "trace_start" \
               "trace_failure_indication" \
               "location_reporting_control" \
               "location_reporting_failure_indication" \
               "location_report" \
               "overload_start" \
               "overload_stop" \
               "enb_direct_information_transfer" \
               "mme_direct_information_transfer" \
               "enb_configuration_transfer" \
               "mme_configuration_transfer" \
               "cell_traffic_trace" \
               "downlink_ue_associated_lppa_transport" \
               "uplink_ue_associated_lppa_transport" \
               "downlink_non_ue_associated_lppa_transport" \
               "uplink_non_ue_associated_lppa_transport"
     ]
     return $validClass2Procedures
}

proc constructS1Procedure {args} {
     #-
     #- This procedure would be used to construct and S1 procedure
     #- The valid argument list/IEs depends on the message to be constructed
     #- Also the message type can be specified
     #-
     
     #Define the valid S1 message and message type that would be supported
     set validClass1Procedures [getValidClass1Procedures]
     set validClass2Procedures [getValidClass2Procedures]
     
     set validProcedureNames [concat $validClass1Procedures $validClass2Procedures]
     set validProcedureNames [join $validProcedureNames |]
     
     set validProcedureTypes "class1|class2"
     
     parseArgs args \
               [list \
               [list msgName              mandatory  $validProcedureNames ""                    "Name of the S1 message that we are sending"] \
               [list msgType              mandatory  $validProcedureTypes ""                    "type of message that we are sending"] \
               [list simType              optional   "MME|HeNB"             "MME"                 "simulator on which the comamnd need to be sent"] \
               [list streamId             optional   "string"             "0"                   "The sctp stream to send or receive data"] \
               [list MMEName              optional   "string"             "__UN_DEFINED__"      "Identifies MME Name"] \
               [list eNBName              optional   "string"             "__UN_DEFINED__"      "Identifies eNB Name"] \
               [list MCC                  optional   "string"             "__UN_DEFINED__"      "Identifies MCC"] \
               [list MNC                  optional   "string"             "__UN_DEFINED__"      "Identifies MNC"] \
               [list HeNBMCC              optional   "string"             "__UN_DEFINED__"      "Identifies HeNB MCC"] \
               [list HeNBMNC              optional   "string"             "__UN_DEFINED__"      "Identifies HeNB MNC"] \
               [list HeNBId               optional   "string"             "__UN_DEFINED__"      "Identifies HeNB Id"] \
               [list ueid                 optional   "string"             "__UN_DEFINED__"      "Identifies internal UE Id"] \
               [list eRAB                 optional   "string"             "__UN_DEFINED__"      "Identifies eRAB to be setup"] \
               [list e_RAB_ID               optional   "numeric"            "__UN_DEFINED__"      "Identifies radio access bearer"] \
               [list eRABsList            optional   "string"             "__UN_DEFINED__"      "Identifies eRABs failure/release list"] \
               [list eRABsAdmitList       optional   "string"             "__UN_DEFINED__"      "Identifies eRABs admit list"] \
               [list eRABsFailList        optional   "string"             "__UN_DEFINED__"      "Identifies eRABs failure/release list"] \
               [list eRABsSwitchedDL      optional   "string"             "__UN_DEFINED__"      "Identifies eRABs to be switched in DL"] \
               [list eRABsSwitchedUL      optional   "string"             "__UN_DEFINED__"      "Identifies eRABs to be switched in UL"] \
               [list causeType            optional   "string"             "__UN_DEFINED__"      "Identifies cause choice group"] \
               [list cause                optional   "string"             "__UN_DEFINED__"      "Identifies cause value"] \
               [list radioNwCause         optional   "string"             "__UN_DEFINED__"      "Identifies radio network layer cause"] \
               [list transLayerCause      optional   "string"             "__UN_DEFINED__"      "Identifies transport layer cause"] \
               [list NASCause             optional   "string"             "__UN_DEFINED__"      "Identifies NAS layer cause"] \
               [list protocolCause        optional   "string"             "__UN_DEFINED__"      "Identifies protocol cause"] \
               [list miscCause            optional   "string"             "__UN_DEFINED__"      "Identifies misc cause"] \
               [list eUtranTraceId        optional   "string"             "__UN_DEFINED__"      "Identifies the eUTRAN trace id"] \
               [list intToTrace           optional   "string"             "__UN_DEFINED__"      "Identifies the interface to trace"] \
               [list traceDepth           optional   "string"             "__UN_DEFINED__"      "Identifies the trace depth"] \
               [list traceCollEntityIp    optional   "string"             "__UN_DEFINED__"      "Identifies the trace collection entity ip address"] \
               [list MDTConf              optional   "string"             "__UN_DEFINED__"      "Identifies the MDT configuration"] \
               [list globaleNBId          optional   "string"             "__UN_DEFINED__"      "Identifies the global eNb id "] \
               [list TAI                  optional   "string"             "__UN_DEFINED__"      "Identifies the selected TAI"] \
               [list LAI                  optional   "string"             "__UN_DEFINED__"      "Identifies the Location area id "] \
               [list RAC                  optional   "string"             "__UN_DEFINED__"      "Identifies the RAC id "] \
               [list RNCId                optional   "numeric"            "__UN_DEFINED__"      "Identifies the RNC Id"] \
               [list extRNCId             optional   "numeric"            "__UN_DEFINED__"      "Identifies the extended RNC Id"] \
               [list PLMNId               optional   "string"             "__UN_DEFINED__"      "Identifies the PLMN id"] \
               [list LAC                  optional   "string"             "__UN_DEFINED__"      "Identifies the LAC Id"] \
               [list CI                   optional   "string"             "__UN_DEFINED__"      "Identifies the CI"] \
               [list RRCContainer         optional   "string"             "__UN_DEFINED__"      "Identifies the RRC container"] \
               [list DLForwarding         optional   "string"             "__UN_DEFINED__"      "Identifies the DL forwarding"] \
               [list targetId             optional   "string"             "__UN_DEFINED__"      "Identifies the target in handover"] \
               [list targetCellId         optional   "string"             "__UN_DEFINED__"      "Identifies the target cell id"] \
               [list subProfileIdForRAT   optional   "string"             "__UN_DEFINED__"      "Identifies the subscriber profile id"] \
               [list ueHistoryInfo        optional   "string"             "__UN_DEFINED__"      "Identifies the UE history info"] \
               [list QCI                  optional   "numeric"            "__UN_DEFINED__"      "Identifies the QoS Class"] \
               [list allocAndRetPrority   optional   "numeric"            "__UN_DEFINED__"      "Identifies the allocation and retention priority"] \
               [list GBRQoS               optional   "numeric"            "__UN_DEFINED__"      "Identifies the GBR QoS "] \
               [list pagingDRX            optional   "string"             "__UN_DEFINED__"      "Identifies the paging DRX "] \
               [list eRABMaxBitRateDl     optional   "numeric"            "__UN_DEFINED__"      "Identifies the eRAB Max bit rate in DL "] \
               [list eRABMaxBitRateUl     optional   "numeric"            "__UN_DEFINED__"      "Identifies the eRAB Max bit rate in UL "] \
               [list eRABGurBitRateDl     optional   "numeric"            "__UN_DEFINED__"      "Identifies the eRAB guaranteed bit rate in DL "] \
               [list eRABGurBitRateUl     optional   "numeric"            "__UN_DEFINED__"      "Identifies the eRAB guaranteed bit rate in UL "] \
               [list bitRate              optional   "numeric"            "__UN_DEFINED__"      "Identifies the bit rate "] \
               [list UEAggMaxBitRate      optional   "string"             "__UN_DEFINED__"      "Identifies the UE aggregate Max bit rate in DL "] \
               [list UEAggMaxBitRateDl    optional   "numeric"            "__UN_DEFINED__"      "Identifies the UE aggregate Max bit rate in DL "] \
               [list UEAggMaxBitRateUl    optional   "numeric"            "__UN_DEFINED__"      "Identifies the UE aggregate Max bit rate in UL "] \
               [list criticalityDiag      optional   "string"             "__UN_DEFINED__"      "Identifies the criticality diagonistics"] \
               [list procedureCode        optional   "numeric"            "__UN_DEFINED__"      "Identifies the procedure code"] \
               [list triggerMsg           optional   "string"             "__UN_DEFINED__"      "Identifies the triggering message"] \
               [list procedureCriticality optional   "string"             "__UN_DEFINED__"      "Identifies the procedure Criticality"] \
               [list IECriticality        optional   "string"             "__UN_DEFINED__"      "Identifies the IE Criticality"] \
               [list IEId                 optional   "numeric"            "__UN_DEFINED__"      "Identifies the IE Id"] \
               [list typeOfError          optional   "string"             "__UN_DEFINED__"      "Identifies the type of error"] \
               [list timeToWait           optional   "string"             "__UN_DEFINED__"      "Identifies the Time to wait IE"] \
               [list forbiddenInterRAT    optional   "string"             "__UN_DEFINED__"      "Identifies the forbidden inter RATs"] \
               [list cdma2000PDU     optional   "string"             "__UN_DEFINED__"      "Identifies the CDMA 2000 PDU"] \
               [list CDMA2000RATType      optional   "string"             "__UN_DEFINED__"      "Identifies the CDMA 2000 RAT type"] \
               [list cdma2000SectorID      optional   "string"             "__UN_DEFINED__"      "Identifies the CDMA 2000 Sector ID"] \
               [list nextHopChainCount    optional   "string"             "__UN_DEFINED__"      "Identifies the Next hop chaining counter"] \
               [list nextHopNH            optional   "string"             "__UN_DEFINED__"      "Identifies the Next hop NH"] \
               [list UERadioCapability    optional   "string"             "__UN_DEFINED__"      "Identifies the UE radio capability"] \
               [list CDMA2000HOStatus     optional   "string"             "__UN_DEFINED__"      "Identifies the CDMA 2000 HO status"] \
               [list CDMA2000HOReqInd     optional   "string"             "__UN_DEFINED__"      "Identifies the CDMA 2000 HO required indication"] \
               [list UlCount              optional   "string"             "__UN_DEFINED__"      "Identifies the UL count value"] \
               [list DlCount              optional   "string"             "__UN_DEFINED__"      "Identifies the DL count value"] \
               [list RxStOfUlPDCPSDU      optional   "string"             "__UN_DEFINED__"      "Identifies the Receive status of UL PDCP SDU"] \
               [list PDCPSN               optional   "numeric"            "__UN_DEFINED__"      "Identifies the PDCP SN"] \
               [list HFN                  optional   "numeric"            "__UN_DEFINED__"      "Identifies the HFN"] \
               [list CDMA20001xRTTRAND    optional   "string"             "__UN_DEFINED__"      "Identifies the CDMA 2000 1xRTT RAND"] \
               [list event                optional   "string"             "__UN_DEFINED__"      "Identifies the event in the request type"] \
               [list reportArea           optional   "string"             "__UN_DEFINED__"      "Identifies the report Area"] \
               [list CDMA20001xRTTMEID    optional   "string"             "__UN_DEFINED__"      "Identifies the CDMA 2000 1xRTT MEID"] \
               [list CDMA20001xRTTMSI     optional   "string"             "__UN_DEFINED__"      "Identifies the CDMA 2000 1xRTT Mobile Subscription information"] \
               [list CDMA20001xRTTPilot   optional   "string"             "__UN_DEFINED__"      "Identifies the CDMA 2000 1xRTT Pilot list"] \
               [list macroeNBID           optional   "string"             "__UN_DEFINED__"      "Identifies the Macro eNB ID"] \
               [list homeeNBID            optional   "string"             "__UN_DEFINED__"      "Identifies the home eNB ID"] \
               [list cellID               optional   "string"             "__UN_DEFINED__"      "Identifies the cell ID"] \
               [list encrAlgo             optional   "string"             "__UN_DEFINED__"      "Identifies the encryption algo"] \
               [list intigrityProtAlgo    optional   "string"             "__UN_DEFINED__"      "Identifies the intigrity protection algo"] \
               [list securityKey          optional   "string"             "__UN_DEFINED__"      "Identifies the security key"] \
               [list lastVisCell          optional   "string"             "__UN_DEFINED__"      "Identifies the last visited cell"] \
               [list lastViseUTRANCell    optional   "string"             "__UN_DEFINED__"      "Identifies the last visited cell"] \
               [list lastVisUTRANCell     optional   "string"             "__UN_DEFINED__"      "Identifies the last visited cell"] \
               [list lastVisGERANCell     optional   "string"             "__UN_DEFINED__"      "Identifies the last visited cell"] \
               [list globalCellId         optional   "string"             "__UN_DEFINED__"      "Identifies the global cell id"] \
               [list cellType             optional   "string"             "__UN_DEFINED__"      "Identifies the cell type"] \
               [list timeUEStayedInCell   optional   "string"             "__UN_DEFINED__"      "Identifies the time UE stayed in cell"] \
               [list eCGI                 optional   "string"             "__UN_DEFINED__"      "Identifies the eCGI"] \
               [list emerAreaId           optional   "string"             "__UN_DEFINED__"      "Identifies the emergency area id"] \
               [list RIMTransfer          optional   "string"             "__UN_DEFINED__"      "Identifies the RIM transfer"] \
               [list priorityLevel        optional   "numeric"            "__UN_DEFINED__"      "Identifies the priority level"] \
               [list preEmptionCap        optional   "string"             "__UN_DEFINED__"      "Identifies the preemption capability"] \
               [list preEmptionVul        optional   "string"             "__UN_DEFINED__"      "Identifies the preemption vulnerablity"] \
               [list MSClassMask2         optional   "string"             "__UN_DEFINED__"      "Identifies the MSClassMask2"] \
               [list MSClassMask3         optional   "string"             "__UN_DEFINED__"      "Identifies the MSClassMask3"] \
               [list cellSize             optional   "string"             "__UN_DEFINED__"      "Identifies the cell size"] \
               [list noOfBroadcasts       optional   "string"             "__UN_DEFINED__"      "Identifies the noOfBroadcasts"] \
               [list transLayerAdd        optional   "string"             "__UN_DEFINED__"      "Identifies the noOfBroadcasts"] \
               [list GTPTEID              optional   "string"             "__UN_DEFINED__"      "Identifies the GTP TEID"] \
               [list MMEUES1APId          optional   "string"             "__UN_DEFINED__"      "Identifies the MME UE S1AP ID"] \
               [list MMEUES1APId2         optional   "string"             "__UN_DEFINED__"      "Identifies the MME UE S1AP ID"] \
               [list eNBUES1APId          optional   "string"             "__UN_DEFINED__"      "Identifies the eNB UE S1AP ID"] \
               [list NASPDU               optional   "string"             "__UN_DEFINED__"      "Identifies the NAS PDU"] \
               [list MMEC                 optional   "string"             "__UN_DEFINED__"      "Identifies the MMEC"] \
               [list MTMSI                optional   "string"             "__UN_DEFINED__"      "Identifies the M-TMSI"] \
               [list MMEGroupId           optional   "string"             "__UN_DEFINED__"      "Identifies the MME Group Id"] \
               [list MMEId		  optional   "string"             "__UN_DEFINED__"      "Identifies the MME Group Id"] \
               [list MMECode              optional   "string"             "__UN_DEFINED__"      "Identifies the MME Code"] \
               [list servedGUMMEIList     optional   "string"             "__UN_DEFINED__"      "Identifies the Served GUMMEI Lists"] \
               [list UEIdIndexVal         optional   "string"             "__UN_DEFINED__"      "Identifies the UE Id Index Value"] \
               [list IMSI                 optional   "string"             "__UN_DEFINED__"      "Identifies the IMSI"] \
               [list STMSI                optional   "string"             "__UN_DEFINED__"      "Identifies the S-TMSI"] \
               [list DFPathAvail          optional   "string"             "__UN_DEFINED__"      "Identifies the DF path availability"] \
               [list CSFallInd            optional   "string"             "__UN_DEFINED__"      "Identifies the CS fallback indicator"] \
               [list CNDomain             optional   "string"             "__UN_DEFINED__"      "Identifies the CN Domain"] \
               [list RIMInfo              optional   "string"             "__UN_DEFINED__"      "Identifies the RIM information"] \
               [list RIMRA                optional   "string"             "__UN_DEFINED__"      "Identifies the RIM Routing area"] \
               [list SONInfo              optional   "string"             "__UN_DEFINED__"      "Identifies the SON information"] \
               [list SONInfoRequest       optional   "string"             "__UN_DEFINED__"      "Identifies the SON information"] \
               [list SONInfoReply         optional   "string"             "__UN_DEFINED__"      "Identifies the SON information"] \
               [list X2TNLConfInfo        optional   "string"             "__UN_DEFINED__"      "Identifies the x2 TNL configuration info"] \
               [list timeSyncInfo         optional   "string"             "__UN_DEFINED__"      "Identifies the time sync inforamtion"] \
               [list IPSECTransAdd        optional   "string"             "__UN_DEFINED__"      "Identifies the IPSEC transport layer address"] \
               [list GTPTransAdd          optional   "string"             "__UN_DEFINED__"      "Identifies the GTP transport layer address"] \
               [list stratumLevel         optional   "string"             "__UN_DEFINED__"      "Identifies the stratum level"] \
               [list syncStatus           optional   "string"             "__UN_DEFINED__"      "Identifies the sync status"] \
               [list relMMECapability     optional   "string"             "__UN_DEFINED__"      "Identifies the relative MME Capability"] \
               [list MMERelaySupportInd   optional   "string"             "__UN_DEFINED__"      "Identifies the MME relay support indicator"] \
               [list supportedTAs         optional   "string"             "__UN_DEFINED__"      "Identifies supported TAs"] \
               [list CSGIdList            optional   "string"             "__UN_DEFINED__"      "Identifies list of CSGs"] \
               [list RRCEstablishCause    optional   "string"             "__UN_DEFINED__"      "Identifies RRC Establishment cause"] \
               [list GUMMEI               optional   "string"             "__UN_DEFINED__"      "Identifies GUMME"] \
               [list cellAccessMode       optional   "string"             "__UN_DEFINED__"      "Identifies Cell Access Mode"] \
               [list relayNodeInd         optional   "string"             "__UN_DEFINED__"      "Identifies Relay Node Indicator"] \
               [list handOverRestriction  optional   "string"             "__UN_DEFINED__"      "Identifies Handover Restriciton List"] \
               [list gwContextRelInd      optional   "string"             "__UN_DEFINED__"      "Identifies Gateway context release indication"] \
               [list ueIdentityIndexValue optional   "string"             "__UN_DEFINED__"      "Index of MME"] \
               [list uePagingId           optional   "string"             "__UN_DEFINED__"      "UE paging ID IMSI or s-TMSI "] \
               [list cnDomain             optional   "string"             "__UN_DEFINED__"      "CN domain CS or PS" ] \
               [list pagingPriority       optional   "string"             "__UN_DEFINED__"      "Paging Priority" ] \
               [list drxPaging            optional   "string"             "__UN_DEFINED__"      "Paging Priority" ] \
               [list GwTransportAddr      optional   "string"             "__UN_DEFINED__"      "Gw Transport Layer Address" ] \
               [list UESecurityCap        optional   "string"             "__UN_DEFINED__"      "Defines the UE security capability" ] \
               [list srvccOperation       optional   "string"             "__UN_DEFINED__"      "Defines the SRVCC operation" ] \
               [list srvccHOIndication    optional   "string"             "__UN_DEFINED__"      "Defines the SRVCC HO indication" ] \
               [list CSGMembershipStatus  optional   "string"             "__UN_DEFINED__"      "Defines the CSG membership status" ] \
               [list TraceActivation      optional   "string"             "__UN_DEFINED__"      "Defines the Trace activation to be enabled" ] \
               [list resetType            optional   "string"             "__UN_DEFINED__"      "Defines the reset type to be enabled" ] \
               [list uE_associatedLogicalS1_ConnectionListResAck              optional   "string"             "__UN_DEFINED__"      "Defines the reset s1 list to be enabled" ] \
               [list nasLen               optional   "string"            "__UN_DEFINED__"      "Nas Length to be used for the message"] \
               [list nasSecurityParams    optional   "numeric"            "__UN_DEFINED__"      "Defines the NAS security params"] \
               [list handoverType         optional   "string"             "__UN_DEFINED__"      "Defines the handover type in the message"] \
               [list handoverReqType      optional   "string"             "__UN_DEFINED__"      "Defines the handover request type in the message"] \
               [list PSService            optional   "string"             "__UN_DEFINED__"      "Defines the handover PS Service avialablity"] \
               [list securityContext      optional   "string"             "__UN_DEFINED__"      "Defines the handover Security context"] \
               [list overloadAction       optional   "string"             "__UN_DEFINED__"      "Identifies the overload action"] \
               [list trafficLoadReductionIndication optional "string"     "__UN_DEFINED__"      "1-99 percentage of the type of traffic to be rejected"] \
               [list srcToTgtTransContainer   optional  "string"          "__UN_DEFINED__"      "Defines the handover source to target transpaernt container"] \
               [list srcToTgtTransContainer2  optional  "string"          "__UN_DEFINED__"      "Defines the handover secondary source to target transpaernt container"] \
               [list tgtToSrcTransContainer   optional  "string"          "__UN_DEFINED__"      "Defines the handover target to source transpaernt container"] \
               [list tgtToSrcTransContainer2  optional  "string"          "__UN_DEFINED__"      "Defines the handover target to source transpaernt container"] \
               [list eNBStusTsfrCntier    optional   "string"              "__UN_DEFINED__"     "PDCP Sequence Number value" ] \
               [list msgId                optional   "string"              "__UN_DEFINED__"     "Message id for wr-rep-warn msg" ] \
               [list serialNum            optional   "string"              "__UN_DEFINED__"     "Serail num for wr-rep-warn msg" ] \
               [list warnAreaList         optional   "string"              "__UN_DEFINED__"     "warningAreaList for wr-rep-warn msg" ] \
               [list bcCompAreaList       optional   "string"              "__UN_DEFINED__"     "broadcastAreaCompleteList for wr-rep-warn msg response" ] \
               [list bcCancAreaList       optional   "string"              "__UN_DEFINED__"     "broadcastAreaCancelList for kill response" ] \
               [list repPeriod            optional   "string"              "__UN_DEFINED__"     "repetition period for wr-rep-warn msg" ] \
               [list extRepPeriod         optional   "numeric"             "__UN_DEFINED__"     "extension repetition period for wr-rep-warn msg"]  \
               [list numOfBc              optional   "numeric"             "__UN_DEFINED__"     "number of broadcasts in wr-rep-warn msg"] \
               [list warnType             optional   "string"              "__UN_DEFINED__"     "warning type in wr-rep-warn msg" ] \
               [list warnSecInfo          optional   "string"              "__UN_DEFINED__"     "warning security info in wr-rep-warn msg" ] \
               [list dataCodeScheme       optional   "string"               "__UN_DEFINED__"    "data coding scheme in wr-rep-warn msg" ] \
               [list warnMsgCont          optional   "string"               "__UN_DEFINED__"    " warning msg content in wr-rep-warn msg" ] \
               [list concurWarnMsgInd     optional   "string"               "__UN_DEFINED__"    "cocurrent warning msg indicator in wr-rep-warn msg" ] \
               [list requestType          optional   "string"               "__UN_DEFINED__"    "cocurrent warning msg indicator in wr-rep-warn msg" ] \
               [list causeVal             optional   "string"               "__UN_DEFINED__"    "cocurrent warning msg indicator in wr-rep-warn msg" ] \
               [list gwIp	 	  optional   "string"               "__UN_DEFINED__"    "cocurrent warning msg indicator in wr-rep-warn msg" ] \
               [list gwPort		  optional   "string"               "__UN_DEFINED__"    "cocurrent warning msg indicator in wr-rep-warn msg" ] \
               [list traceActivation        optional   "string"               "__UN_DEFINED__"    "cocurrent warning msg indicator in wr-rep-warn msg" ] \
               [list interSystemInfoTransferTypeEDT optional   "string"               "__UN_DEFINED__"    "cocurrent warning msg indicator in wr-rep-warn msg" ] \
               [list routingId            optional   "string"               "__UN_DEFINED__"    "cocurrent warning msg indicator in wr-rep-warn msg" ] \
               [list lppaPdu              optional   "string"               "__UN_DEFINED__"    "cocurrent warning msg indicator in wr-rep-warn msg" ] \
               [list eRabSubDataFwdList   optional   "string"               "__UN_DEFINED__"    "cocurrent warning msg indicator in wr-rep-warn msg" ] \
               [list cdma2000HOStatus     optional   "string"               "__UN_DEFINED__"    "cocurrent warning msg indicator in wr-rep-warn msg" ] \
               [list cdma2000RATType      optional   "string"               "__UN_DEFINED__"    "cocurrent warning msg indicator in wr-rep-warn msg" ] \
               [list cdma2000PDU          optional   "string"               "__UN_DEFINED__"    "cocurrent warning msg indicator in wr-rep-warn msg" ] \
               [list cdma2000OneXSRVCCInfo  optional   "string"               "__UN_DEFINED__"    "cocurrent warning msg indicator in wr-rep-warn msg" ] \
               [list cdma2000HOReqInd      optional   "string"               "__UN_DEFINED__"    "cocurrent warning msg indicator in wr-rep-warn msg" ] \
               [list cdma2000OneXRAND      optional   "string"               "__UN_DEFINED__"    "cocurrent warning msg indicator in wr-rep-warn msg" ] \
               [list traceCollectionEntityIPAddress                 optional   "string"         "__UN_DEFINED__"      "e-UTRAN CGI chosen from UE" ] \
               [list MultiS1Link         optional   "yes|no"         "no"                          "flag to enable multiple s1 links"] \
               [list uES1APIDs            optional   "string"               "__UN_DEFINED__"   "UE S1AP Id value" ] \
               ]

     global ARR_LTE_TEST_PARAMS
     print -info "VENKATA: Before - simType is $simType :::   entered if loop"
     set MultiS1Link $ARR_LTE_TEST_PARAMS(MultiS1Link)
     if {$simType == "HeNB"} { 
           print -info "VENKATA: simType is $simType :::   entered if loop"
        if {[info exists ARR_LTE_TEST_PARAMS(assocID)]} { 
           set assocID $ARR_LTE_TEST_PARAMS(assocID)
           print -info "VENKATA: entered if loop"
           print -info "TESTING: assocID- $assocID simType- $simType"
           if {[info exists gwIp]} {
               unset gwIp
           }
        }
     }
     
     #based on the type of message create the message list
     switch $msgName {
          "s1_setup_request" {
               set validArgs "MsgType=S1SetupRequest eNBname=eNBName HeNBId=HeNBId global_ENB_ID=globaleNBId  defaultPagingDRX=pagingDRX \
                         cSG_IdList=CSGIdList supportedTAs=supportedTAs StreamNo=streamId gwIP=gwIp gwPort=gwPort assocID=assocID"
          }
          "s1_setup_response" {
                 set validArgs "MsgType=S1SetupResponse mMEname=MMEName MMEId=MMEId enbID=globaleNBId\
                         relativeMMECapacity=relMMECapability mMERelaySupportIndicator=MMERelaySupportInd \
                         criticalityDiagnostics=criticalityDiag servedGUMMEIs=servedGUMMEIList StreamNo=streamId gwIP=gwIp gwPort=gwPort"
          }
          "paging" {
               set  validArgs "MsgType=Paging MMEName=MMEName MMEId=MMEId uEIdentityIndexValue=ueIdentityIndexValue uEPagingID=uePagingId \
                         cNDomain=cnDomain pagingDRX=drxPaging  tAIList=supportedTAs cSG_IdList=CSGIdList StreamNo=streamId gwIP=gwIp gwPort=gwPort \
                         pagingPriority=pagingPriority enbID=globaleNBId assocID=assocID"
          }
          "s1_setup_failure" {
               set validArgs "MsgType=S1SetupFailure  henbid=HeNBId MMEId=MMEId cause=cause enbID=globaleNBId assocID=assocID \
                         criticalityDiagnostics=criticalityDiag timeToWait=timeToWait StreamNo=streamId gwIP=gwIp gwPort=gwPort"
          }
          "error_indication" {
               set validArgs "MsgType=ErrorIndication henbid=HeNBId MMEId=MMEId cause=cause enbID=globaleNBId assocID=assocID \
                         eNB_UE_S1AP_ID=eNBUES1APId mME_UE_S1AP_ID=MMEUES1APId criticalityDiagnostics=criticalityDiag StreamNo=streamId gwIP=gwIp gwPort=gwPort"
          }
          "initial_ue_message" {
               set validArgs "MsgType=InitialUEMessage henbid=HeNBId eNB_UE_S1AP_ID=eNBUES1APId cSG_Id=CSGIdList \
                         tAI=TAI eUTRAN_CGI=eCGI rRC_Establishment_Cause=RRCEstablishCause s_TMSI=STMSI gUMMEI_ID=GUMMEI \
                         cellAccessMode=cellAccessMode gW_TransportLayerAddress=GwTransportAddr gwIP=gwIp gwPort=gwPort \
                         relayNode_Indicator=relayNodeInd nAS_PDU=nasLen StreamNo=streamId assocID=assocID"
          }
          "downlink_nas_transport" {
               set validArgs "MsgType=DownlinkNASTransport MMEId=MMEId eNB_UE_S1AP_ID=eNBUES1APId mME_UE_S1AP_ID=MMEUES1APId \
                         subscriberProfileIDforRFP=subProfileIdForRAT handoverRestrictionList=handOverRestriction nAS_PDU=nasLen \
                         enbID=globaleNBId StreamNo=streamId gwIP=gwIp gwPort=gwPort"
          }
          "uplink_nas_transport" {
               set validArgs "MsgType=UplinkNASTransport henbid=HeNBId eNB_UE_S1AP_ID=eNBUES1APId assocID=assocID \
                         mME_UE_S1AP_ID=MMEUES1APId tAI=TAI eUTRAN_CGI=eCGI gW_TransportLayerAddress=GwTransportAddr nAS_PDU=nasLen \
                         StreamNo=streamId gwIP=gwIp gwPort=gwPort"
          }
          "initial_context_setup_request" {
               set validArgs "MsgType=InitialContextSetupRequest MMEId=MMEId henbid=HeNBId eNB_UE_S1AP_ID=eNBUES1APId \
                         mME_UE_S1AP_ID=MMEUES1APId uEaggregateMaximumBitrate=UEAggMaxBitRate uESecurityCapabilities=UESecurityCap \
                         securityKey=securityKey uERadioCapability=UERadioCapability subscriberProfileIDforRFP=subProfileIdForRAT \
                         cSFallbackIndicator=CSFallInd sRVCCOperationPossible=srvccOperation cSGMembershipStatus=CSGMembershipStatus \
                         registeredLAI=LAI gUMMEI_ID=GUMMEI mME_UE_S1AP_ID_2=MMEUES1APId2 managementBasedMDTAllowed=MDTConf \
                         e_RABToBeSetupListCtxtSUReq=eRAB handoverRestrictionList=handOverRestriction traceActivation=TraceActivation  \
                         StreamNo=streamId gwIP=gwIp gwPort=gwPort enbID=globaleNBId"
          }
          "initial_context_setup_response" {
               set validArgs "MsgType=InitialContextSetupResponse henbid=HeNBId eNB_UE_S1AP_ID=eNBUES1APId assocID=assocID \
                         mME_UE_S1AP_ID=MMEUES1APId criticalityDiagnostics=criticalityDiag \
                         e_RABSetupListCtxtSURes=eRAB e_RABFailedToSetupListCtxtSURes=eRABsList StreamNo=streamId gwIP=gwIp gwPort=gwPort"
          }
          "initial_context_setup_failure" {
               set validArgs "MsgType=InitialContextSetupFailure henbid=HeNBId eNB_UE_S1AP_ID=eNBUES1APId \
                         mME_UE_S1AP_ID=MMEUES1APId criticalityDiagnostics=criticalityDiag assocID=assocID \
                         cause=cause StreamNo=streamId gwIP=gwIp gwPort=gwPort enbID=globaleNBId"
          }
          "e-rab_setup_request" {
               set validArgs "MsgType=E_RABSetupRequest MMEId=MMEId eNB_UE_S1AP_ID=eNBUES1APId \
                         mME_UE_S1AP_ID=MMEUES1APId uEaggregateMaximumBitrate=UEAggMaxBitRate enbID=globaleNBId \
                         e_RABToBeSetupListBearerSUReq=eRAB StreamNo=streamId gwIP=gwIp gwPort=gwPort"
          }
          "e-rab_setup_response" {
               set validArgs "MsgType=E_RABSetupResponse henbid=HeNBId assocID=assocID eNB_UE_S1AP_ID=eNBUES1APId \
                         mME_UE_S1AP_ID=MMEUES1APId criticalityDiagnostics=criticalityDiag \
                         e_RABSetupListBearerSURes=eRAB e_RABFailedToSetupListBearerSURes=eRABsList StreamNo=streamId gwIP=gwIp gwPort=gwPort"
          }
          "e-rab_modify_request" {
               set validArgs "MsgType=E_RABModifyRequest MMEId=MMEId eNB_UE_S1AP_ID=eNBUES1APId \
                         mME_UE_S1AP_ID=MMEUES1APId uEaggregateMaximumBitrate=UEAggMaxBitRate enbID=globaleNBId \
                         e_RABToBeModifiedListBearerModReq=eRAB StreamNo=streamId gwIP=gwIp gwPort=gwPort"
          }
          "e-rab_modify_response" {
               set validArgs "MsgType=E_RABModifyResponse henbid=HeNBId assocID=assocID eNB_UE_S1AP_ID=eNBUES1APId \
                         mME_UE_S1AP_ID=MMEUES1APId criticalityDiagnostics=criticalityDiag \
                         e_RABModifyListBearerModRes=eRAB e_RABFailedToModifyList=eRABsList StreamNo=streamId gwIP=gwIp gwPort=gwPort"
          }
          "e-rab_release_command" {
               set validArgs "MsgType=E_RABReleaseCommand MMEId=MMEId eNB_UE_S1AP_ID=eNBUES1APId \
                         mME_UE_S1AP_ID=MMEUES1APId uEaggregateMaximumBitrate=UEAggMaxBitRate nAS_PDU=NASPDU enbID=globaleNBId \
                         e_RABToBeReleasedList=eRABsList StreamNo=streamId gwIP=gwIp gwPort=gwPort"
          }
          "e-rab_release_response" {
               set validArgs "MsgType=E_RABReleaseResponse henbid=HeNBId assocID=assocID eNB_UE_S1AP_ID=eNBUES1APId \
                         mME_UE_S1AP_ID=MMEUES1APId criticalityDiagnostics=criticalityDiag \
                         e_RABReleaseListBearerRelComp=eRAB e_RABFailedToReleaseList=eRABsList StreamNo=streamId gwIP=gwIp gwPort=gwPort"
          }
          "e-rab_release_indication" {
               set validArgs "MsgType=E_RABReleaseIndication henbid=HeNBId assocID=assocID eNB_UE_S1AP_ID=eNBUES1APId \
                         mME_UE_S1AP_ID=MMEUES1APId e_RABReleasedList=eRABsList StreamNo=streamId gwIP=gwIp gwPort=gwPort"
          }
          "nas_non_delivery_indication" {
               set validArgs "MsgType=NASNonDeliveryIndication henbid=HeNBId assocID=assocID eNB_UE_S1AP_ID=eNBUES1APId \
                         mME_UE_S1AP_ID=MMEUES1APId cause=cause nAS_PDU=nasLen StreamNo=streamId gwIp=gwIp gwPort=gwPort"
          }
          "ue_context_release_request" {
               set validArgs "MsgType=UEContextReleaseRequest henbid=HeNBId assocID=assocID eNB_UE_S1AP_ID=eNBUES1APId \
                         mME_UE_S1AP_ID=MMEUES1APId cause=cause \
                         gWContextReleaseIndication=gwContextRelInd StreamNo=streamId gwIp=gwIp gwPort=gwPort"
          }
          "ue_context_release_command" {
               set validArgs "MsgType=UEContextReleaseCommand MMEId=MMEId uE_S1AP_IDs=uES1APIDs enbID=globaleNBId \
                         cause=cause StreamNo=streamId gwIp=gwIp gwPort=gwPort"
          }
          "ue_context_release_complete" {
               set validArgs "MsgType=UEContextReleaseComplete henbid=HeNBId eNB_UE_S1AP_ID=eNBUES1APId \
                         mME_UE_S1AP_ID=MMEUES1APId StreamNo=streamId gwIp=gwIp gwPort=gwPort assocID=assocID"
          }
          "reset" {
               set validArgs "MsgType=Reset henbid=HeNBId MMEId=MMEId cause=cause enbID=globaleNBId \
                         uE_associatedLogicalS1_ConnectionListResAck=uE_associatedLogicalS1_ConnectionListResAck \
                         resetType=resetType StreamNo=streamId gwIp=gwIp gwPort=gwPort assocID=assocID"
          }
          "reset_acknowledge" {
               set validArgs "MsgType=ResetAcknowledge henbid=HeNBId MMEId=MMEId uE_associatedLogicalS1_ConnectionListResAck=uE_associatedLogicalS1_ConnectionListResAck \
                         criticalityDiagnostics=criticalityDiagnostics StreamNo=streamId gwIp=gwIp gwPort=gwPort enbID=globaleNBId assocID=assocID"
          }
          "handover_required" {
               set validArgs "MsgType=HandoverRequired henbid=HeNBId eNB_UE_S1AP_ID=eNBUES1APId \
                         mME_UE_S1AP_ID=MMEUES1APId handoverType=handoverType cause=cause assocID=assocID \
                         targetID=targetId direct_Forwarding_Path_Availability=DFPathAvail sRVCCHOIndication=srvccHOIndication \
                         source_ToTarget_TransparentContainer=srcToTgtTransContainer source_ToTarget_TransparentContainer_Secondary=srcToTgtTransContainer2 \
                         mSClassmark2=MSClassMask2 mSClassmark3=MSClassMask3 cSG_Id=CSGIdList cellAccessMode=cellAccessMode \
                         pS_ServiceNotAvailable=PSService gUMMEI_ID=GUMMEI mME_UE_S1AP_ID_2=MMEUES1APId2 StreamNo=streamId gwIP=gwIp gwPort=gwPort"
          }
          "handover_command" {
               set validArgs "MsgType=HandoverCommand MMEId=MMEId eNB_UE_S1AP_ID=eNBUES1APId enbID=globaleNBId \
                         mME_UE_S1AP_ID=MMEUES1APId handoverType=handoverType nASSecurityParametersfromE_UTRAN=nasSecurityParams \
                         e_RABSubjecttoDataForwardingList=eRAB e_RABtoReleaseListHOCmd=eRABsList \
                         target_ToSource_TransparentContainer=tgtToSrcTransContainer target_ToSource_TransparentContainer_Secondary=tgtToSrcTransContainer2 \
                         criticalityDiagnostics=criticalityDiag StreamNo=streamId gwIP=gwIp gwPort=gwPort"
          }
          "handover_preparation_failure" {
               set validArgs "MsgType=HandoverPreparationFailure MMEId=MMEId eNB_UE_S1AP_ID=eNBUES1APId enbID=globaleNBId \
                         mME_UE_S1AP_ID=MMEUES1APId cause=cause \
                         criticalityDiagnostics=criticalityDiag StreamNo=streamId gwIP=gwIp gwPort=gwPort"
          }
          "handover_request" {
               set validArgs "MsgType=HandoverRequest MMEId=MMEId mME_UE_S1AP_ID=MMEUES1APId handoverType=handoverType \
                         cause=cause uEaggregateMaximumBitrate=UEAggMaxBitRate enbID=globaleNBId \
                         source_ToTarget_TransparentContainer=srcToTgtTransContainer uESecurityCapabilities=UESecurityCap \
                         handoverRestrictionList=handOverRestriction traceActivation=TraceActivation \
                         requestType=handoverReqType sRVCCOperationPossible=srvccOperation \
                         securityContext=securityContext nASSecurityParameterstoE_UTRAN=nasSecurityParams \
                         cSG_Id=CSGIdList cSGMembershipStatus=CSGMembershipStatus gUMMEI_ID=GUMMEI \
                         mME_UE_S1AP_ID_2=MMEUES1APId2 e_RABToBeSetupListHOReq=eRAB StreamNo=streamId gwIP=gwIp gwPort=gwPort"
          }
          "handover_request_ackowledge" {
               set validArgs "MsgType=HandoverRequestAcknowledge henbid=HeNBId assocID=assocID eNB_UE_S1AP_ID=eNBUES1APId \
                         mME_UE_S1AP_ID=MMEUES1APId e_RABAdmittedList=eRABsAdmitList e_RABFailedToSetupListHOReqAck=eRABsFailList \
                         cSG_Id=CSGIdList criticalityDiagnostics=criticalityDiag target_ToSource_TransparentContainer=tgtToSrcTransContainer StreamNo=streamId gwIP=gwIp gwPort=gwPort"
          }
          "handover_failure" {
               set validArgs "MsgType=HandoverFailure henbid=HeNBId assocID=assocID mME_UE_S1AP_ID=MMEUES1APId \
                         cause=cause criticalityDiagnostics=criticalityDiag StreamNo=streamId gwIP=gwIp gwPort=gwPort"
          }
          "handover_notify" {
               set validArgs "MsgType=HandoverNotify henbid=HeNBId assocID=assocID eNB_UE_S1AP_ID=eNBUES1APId \
                         mME_UE_S1AP_ID=MMEUES1APId tAI=TAI eUTRAN_CGI=eCGI StreamNo=streamId gwIP=gwIp gwPort=gwPort"
          }
          "handover_cancel" {
               set validArgs "MsgType=HandoverCancel henbid=HeNBId assocID=assocID eNB_UE_S1AP_ID=eNBUES1APId \
                         mME_UE_S1AP_ID=MMEUES1APId cause=cause StreamNo=streamId gwIP=gwIp gwPort=gwPort"
          }
          "handover_cancel_ackowledge" {
               set validArgs "MsgType=HandoverCancelAcknowledge MMEId=MMEId eNB_UE_S1AP_ID=eNBUES1APId enbID=globaleNBId \
                         mME_UE_S1AP_ID=MMEUES1APId criticalityDiagnostics=criticalityDiag StreamNo=streamId gwIP=gwIp gwPort=gwPort"
          }
          "path_switch_request" {
               set validArgs "MsgType=PathSwitchRequest henbid=HeNBId assocID=assocID eNB_UE_S1AP_ID=eNBUES1APId \
                         sourceMME_UE_S1AP_ID=MMEUES1APId e_RABToBeSwitchedDLList=eRABsSwitchedDL eUTRAN_CGI=eCGI \
                         tAI=TAI uESecurityCapabilities=UESecurityCap cSG_Id=CSGIdList cellAccessMode=cellAccessMode \
                         sourceMME_GUMMEI=GUMMEI StreamNo=streamId gwIP=gwIp gwPort=gwPort"
          }
          "path_switch_request_ackowledge" {
               set validArgs "MsgType=PathSwitchRequestAcknowledge MMEId=MMEId eNB_UE_S1AP_ID=eNBUES1APId enbID=globaleNBId \
                         mME_UE_S1AP_ID=MMEUES1APId uEaggregateMaximumBitrate=UEAggMaxBitRate mME_UE_S1AP_ID_2=MMEUES1APId2 criticalityDiagnostics=criticalityDiag \
                         securityContext=securityContext e_RABToBeSwitchedULList=eRABsSwitchedUL e_RABToBeReleasedList=eRABsList StreamNo=streamId gwIP=gwIp gwPort=gwPort"
          }
          "path_switch_request_failure" {
               set validArgs "MsgType=PathSwitchRequestFailure MMEId=MMEId eNB_UE_S1AP_ID=eNBUES1APId enbID=globaleNBId \
                         cause=cause mME_UE_S1AP_ID=MMEUES1APId criticalityDiagnostics=criticalityDiag StreamNo=streamId gwIP=gwIp gwPort=gwPort"
          }
          "enb_status_transfer" {
               set validArgs "MsgType=ENBStatusTransfer henbid=HeNBId assocID=assocID eNB_UE_S1AP_ID=eNBUES1APId \
                         mME_UE_S1AP_ID=MMEUES1APId eNB_StatusTransfer_TransparentContainer=eNBStusTsfrCntier StreamNo=streamId gwIP=gwIp gwPort=gwPort"
          }
          "mme_status_transfer" {
               set validArgs "MsgType=MMEStatusTransfer MMEId=MMEId eNB_UE_S1AP_ID=eNBUES1APId enbID=globaleNBId \
                         mME_UE_S1AP_ID=MMEUES1APId eNB_StatusTransfer_TransparentContainer=eNBStusTsfrCntier StreamNo=streamId gwIP=gwIp gwPort=gwPort"
          }
          "mme_config_transfer" {
               set validArgs "MsgType=MMEConfigurationTransfer MMEId=MMEId sONConfigurationTransferMCT=SONInfo StreamNo=streamId gwIP=gwIp gwPort=gwPort enbID=globaleNBId"
          }
          "overload_start" {
               set validArgs "MsgType=OverloadStart MMEId=MMEId overloadResponse=overloadAction gUMMEIList=GUMMEI enbID=globaleNBId \
                         trafficLoadReductionIndication=trafficLoadReductionIndication StreamNo=streamId gwIP=gwIp gwPort=gwPort"
          }
          "overload_stop" {
               set validArgs "MsgType=OverloadStop MMEId=MMEId gUMMEIList=GUMMEI StreamNo=streamId gwIP=gwIp gwPort=gwPort enbID=globaleNBId"
          }
          "enb_configuration_transfer" {
               set validArgs "MsgType=ENBConfigurationTransfer henbid=HeNBId assocID=assocID sONConfigurationTransferECT=SONInfo StreamNo=streamId gwIP=gwIp gwPort=gwPort"
          }
          "write-replace_warning_request" {
               set validArgs "MsgType=WriteReplaceWarningRequest MMEId=MMEId messageIdentifier=msgId serialNumber=serialNum warningAreaList=warnAreaList repetitionPeriod=repPeriod extendedRepetitionPeriod=extRepPeriod numberofBroadcastRequest=numOfBc warningType=warnType warningSecurityInfo=warnSecInfo dataCodingScheme=dataCodeScheme warningMessageContents=warnMsgCont concurrentWarningMessageIndicator=concurWarnMsgInd StreamNo=streamId gwIP=gwIp gwPort=gwPort"
          }
          "write-replace_warning_response" {
               set validArgs "MsgType=WriteReplaceWarningResponse henbid=HeNBId messageIdentifier=msgId serialNumber=serialNum broadcastCompletedAreaList=bcCompAreaList criticalityDiagnostics=criticalityDiag StreamNo=streamId gwIP=gwIp gwPort=gwPort assocID=assocID"
          }
          "kill_request" {
               set validArgs "MsgType=KillRequest MMEId=MMEId messageIdentifier=msgId serialNumber=serialNum warningAreaList=warnAreaList StreamNo=streamId gwIP=gwIp gwPort=gwPort "
          }
          "kill_response" {
               set validArgs "MsgType=KillResponse henbid=HeNBId messageIdentifier=msgId serialNumber=serialNum broadcastCancelledAreaList=bcCancAreaList criticalityDiagnostics=criticalityDiag StreamNo=streamId gwIP=gwIp gwPort=gwPort assocID=assocID"
          }
          "mme_configuration_update" {
               set validArgs "MsgType=MMEConfigurationUpdate mMEname=MMEName MMEId=MMEId enbID=globaleNBId \
                         servedGUMMEIs=servedGUMMEIList relativeMMECapacity=relMMECapability StreamNo=streamId gwIP=gwIp gwPort=gwPort"
          }
          "mme_configuration_update_acknowledge" {
               set validArgs "MsgType=MMEConfigurationUpdateAcknowledge henbid=HeNBId assocID=assocID \
                         criticalityDiagnostics=criticalityDiag StreamNo=streamId gwIP=gwIp gwPort=gwPort"
          }
          "mme_configuration_update_failure" {
               set validArgs "MsgType=MMEConfigurationUpdateFailure henbid=HeNBId cause=cause assocID=assocID \
                         timeToWait=timeToWait criticalityDiagnostics=criticalityDiag StreamNo=streamId gwIP=gwIp gwPort=gwPort"
          }
          "enb_configuration_update" {
               set validArgs "MsgType=ENBConfigurationUpdate henbid=HeNBId eNBname=eNBName defaultPagingDRX=pagingDRX cSG_IdList=CSGIdList supportedTAs=supportedTAs StreamNo=streamId gwIP=gwIp gwPort=gwPort assocID=assocID"
          }
          "enb_configuration_update_ackowledge" {
               set validArgs "MsgType=ENBConfigurationUpdateAcknowledge MMEId=MMEId criticalityDiagnostics=criticalityDiag enbID=globaleNBId StreamNo=streamId gwIP=gwIp gwPort=gwPort"
          }
          "enb_configuration_update_failure" {
               set validArgs "MsgType=ENBConfigurationUpdateFailure MMEId=MMEId cause=cause timeToWait=timeToWait enbID=globaleNBId criticalityDiagnostics=criticalityDiag StreamNo=streamId gwIP=gwIp gwPort=gwPort"
          }

          "trace_start" {
               set validArgs "MsgType=TraceStart MMEId=MMEId  eNB_UE_S1AP_ID=eNBUES1APId  mME_UE_S1AP_ID=MMEUES1APId enbID=globaleNBId traceActivation=traceActivation StreamNo=streamId gwIP=gwIp gwPort=gwPort "
          }
          
          "trace_failure_indication" {
               set validArgs "MsgType=TraceFailureIndication henbid=HeNBId  eNB_UE_S1AP_ID=eNBUES1APId  mME_UE_S1AP_ID=MMEUES1APId e_UTRAN_Trace_ID=eUtranTraceId  cause=cause  StreamNo=streamId gwIP=gwIp gwPort=gwPort assocID=assocID"
          }
          
          "deactivate_trace" {
               set validArgs "MsgType=DeactivateTrace MMEId=MMEId eNB_UE_S1AP_ID=eNBUES1APId  mME_UE_S1AP_ID=MMEUES1APId  e_UTRAN_Trace_ID=eUtranTraceId ueid=ueid StreamNo=streamId gwIP=gwIp gwPort=gwPort"
          }
          "location_reporting_control" {
               set validArgs "MsgType=LocationReportingControl MMEId=MMEId eNB_UE_S1AP_ID=eNBUES1APId mME_UE_S1AP_ID=MMEUES1APId enbID=globaleNBId requestType=requestType gwIP=gwIp gwPort=gwPort StreamNo=streamId" 
          }
          "location_report" {
               set validArgs "MsgType=LocationReport henbid=HeNBId ueid=ueid eNB_UE_S1AP_ID=eNBUES1APId mME_UE_S1AP_ID=MMEUES1APId requestType=requestType eUTRAN_CGI=eCGI tAI=TAI  gwIP=gwIp gwPort=gwPort StreamNo=streamId assocID=assocID"
          }
          "location_reporting_failure_indication" {
               set validArgs "MsgType=LocationReportingFailureIndication henbid=HeNBId eNB_UE_S1AP_ID=eNBUES1APId mME_UE_S1AP_ID=MMEUES1APId cause=cause gwIP=gwIp gwPort=gwPort StreamNo=streamId assocID=assocID"
          }
          "ue_context_modification_failure" {
               set validArgs "MsgType=UEContextModificationFailure henbid=HeNBId eNB_UE_S1AP_ID=eNBUES1APId mME_UE_S1AP_ID=MMEUES1APId cause=cause gwIP=gwIp gwPort=gwPort StreamNo=streamId criticalityDiagnostics=criticalityDiag assocID=assocID"
          }
          "ue_context_modification_response" {
               set validArgs "MsgType=UEContextModificationResponse henbid=HeNBId eNB_UE_S1AP_ID=eNBUES1APId mME_UE_S1AP_ID=MMEUES1APId gwIP=gwIp gwPort=gwPort StreamNo=streamId criticalityDiagnostics=criticalityDiag assocID=assocID"
          }
          "ue_context_modification_request" {
               set validArgs "MsgType=UEContextModificationRequest MMEId=MMEId  henbid=HeNBId eNB_UE_S1AP_ID=eNBUES1APId mME_UE_S1AP_ID=MMEUES1APId securityKey=securityKey subscriberProfileIDforRFP=subProfileIdForRAT uEaggregateMaximumBitrate=UEAggMaxBitRate cSFallbackIndicator=CSFallInd uESecurityCapabilities=UESecurityCap cSGMembershipStatus=CSGMembershipStatus registeredLAI=LAI  gwIP=gwIp gwPort=gwPort StreamNo=streamId "
          }
          "enb_direct_information_transfer" {
               set validArgs "MsgType=ENBDirectInformationTransfer henbid=HeNBId inter_SystemInformationTransferTypeEDT=interSystemInfoTransferTypeEDT gwIP=gwIp gwPort=gwPort StreamNo=streamId assocID=assocID"
          }
          "mme_direct_information_transfer" {
               set validArgs "MsgType=MMEDirectInformationTransfer MMEId=MMEId henbid=HeNBId enbID=globaleNBId inter_SystemInformationTransferTypeMDT=interSystemInfoTransferTypeEDT gwIP=gwIp gwPort=gwPort StreamNo=streamId"
          }
          "downlink_ue_associated_lppa_transport"  {
               set validArgs "MsgType=DownlinkUEAssociatedLPPaTransport MMEId=MMEId enbID=globaleNBId henbid=HeNBId eNB_UE_S1AP_ID=eNBUES1APId mME_UE_S1AP_ID=MMEUES1APId routing_ID=routingId lPPa_PDU=lppaPdu gwIP=gwIp gwPort=gwPort StreamNo=streamId"
          }
          "downlink_non_ue_associated_lppa_transport"  {
               set validArgs "MsgType=DownlinkNonUEAssociatedLPPaTransport MMEId=MMEId henbid=HeNBId routing_ID=routingId lPPa_PDU=lppaPdu StreamNo=streamId"
          }
          "uplink_ue_associated_lppa_transport"  {
               set validArgs "MsgType=UplinkUEAssociatedLPPaTransport MMEId=MMEId henbid=HeNBId eNB_UE_S1AP_ID=eNBUES1APId mME_UE_S1AP_ID=MMEUES1APId routing_ID=routingId lPPa_PDU=lppaPdu gwIP=gwIp gwPort=gwPort StreamNo=streamId assocID=assocID"
          }
          "uplink_non_ue_associated_lppa_transport"  {
               set validArgs "MsgType=UplinkNonUEAssociatedLPPaTransport MMEId=MMEId henbid=HeNBId StreamNo=streamId routing_ID=routingId lPPa_PDU=lppaPdu StreamNo=streamId  assocID=assocID"
          }    
          "cell_traffic_trace" {
               set validArgs "MsgType=CellTrafficTrace henbid=HeNBId ueid=ueid assocID=assocID eNB_UE_S1AP_ID=eNBUES1APId  mME_UE_S1AP_ID=MMEUES1APId  e_UTRAN_Trace_ID=eUtranTraceId StreamNo=streamId  eUTRAN_CGI=eCGI traceCollectionEntityIPAddress=traceCollectionEntityIPAddress gwIP=gwIp gwPort=gwPort  "
          }
          "downlink_s1_cdma2000_tunneling"  {
               set validArgs "MsgType=DownlinkS1cdma2000tunneling MMEId=MMEId enbID=globaleNBId henbid=HeNBId eNB_UE_S1AP_ID=eNBUES1APId mME_UE_S1AP_ID=MMEUES1APId uL_TransportLayerAddress=eRabSubDataFwdList cdma2000HOStatus=cdma2000HOStatus cdma2000RATType=cdma2000RATType cdma2000PDU=cdma2000PDU gwIP=gwIp gwPort=gwPort StreamNo=streamId"
          }

          "uplink_s1_cdma2000_tunneling"  {
               set validArgs "MsgType=UplinkS1cdma2000tunneling MMEId=MMEId henbid=HeNBId eNB_UE_S1AP_ID=eNBUES1APId mME_UE_S1AP_ID=MMEUES1APId \
                cdma2000HORequiredIndication=cdma2000HOReqInd cdma2000OneXRAND=cdma2000OneXRAND  eUTRANRoundTripDelayEstimationInfo=eutranRounddTripDelay \
                cdma2000OneXSRVCCInfo=cdma2000OneXSRVCCInfo cdma2000HOStatus=cdma2000HOStatus cdma2000SectorID=cdma2000SectorID cdma2000RATType=cdma2000RATType cdma2000PDU=cdma2000PDU gwIP=gwIp gwPort=gwPort StreamNo=streamId assocID=assocID"
          }

          "ue_capability_info_indication"  {
               set validArgs "MsgType=UECapabilityInfoIndication MMEId=MMEId enbID=globaleNBId henbid=HeNBId eNB_UE_S1AP_ID=eNBUES1APId mME_UE_S1AP_ID=MMEUES1APId uERadioCapability=UERadioCapability gwIP=gwIp gwPort=gwPort StreamNo=streamId assocID=assocID"
          }

     }
     array set arr_s1_msg {}
     # Framing the message arguments and send it
     foreach arg $validArgs {
          foreach {key val} [split $arg "="] {break}
          if {$key == "MsgType"}  { append mesg "$key=$val "}
          if {[info exists $val]} { append mesg "$key=[set $val] " }
     }
     append mesg " "
     lappend arr_s1_msg($msgName) $mesg
     
     return [array get arr_s1_msg]
}

proc sendOrVerifyS1APProcedure {args} {
     #-
     #- This procedure is used to send or verify a S1AP procedure
     #- The procedure requires the simtype to be specified in other way to
     #- which simulator the message has to be sent
     #-
     
     global ARR_CALL_FLOW
     parseArgs args \
               [list \
               [list msgList              mandatory  "string"               ""                    "Message to be sent or verified"] \
               [list msgName              optional   "string"               ""                    "Name of the S1AP message that we are sending"] \
               [list msgType              optional   "string"               ""                    "Type of S1AP message that we are sending"] \
               [list operation            optional   "send|(don't|)expect"  "send"                "operation to be performed"] \
               [list simType              optional   "MME|HeNB"             "MME"                 "simulator on which the output has to be verified"] \
               [list HeNBIndex            optional   "numeric"              "__UN_DEFINED__"      "The HeNBIndex to send the message to"] \
               [list MMEIndex             optional   "numeric"              "__UN_DEFINED__"      "The MMEIndex to send the message to"] \
               [list getS1MsgRetryAttemps optional   "numeric"              "__UN_DEFINED__"      "The no of attempts to retry"] \
               [list getS1MsgRetryAfter   optional   "numeric"              "__UN_DEFINED__"      "To retry after"] \
               [list enbID                optional   "numeric"              "__UN_DEFINED__"      "enbid"] \
               [list henbId               optional   "numeric"              "__UN_DEFINED__"      "HeNB id to filter data from the getMessage output"] \
               [list mmeId               optional   "numeric"              "__UN_DEFINED__"      "HeNB id to filter data from the getMessage output"] \
               [list verifyLatest         optional   "yes|no"         "no"                        "Option to verify latest message's value in output message"] \
               ]
     
     array set arr_s1_msg $msgList

     set MultiS1Link $::ARR_LTE_TEST_PARAMS(MultiS1Link) 
     
     set flag 0
     set failCount 0
     
     # Enable call flow tracing
     if {$operation != "don'texpect"} {
          if {![array exists ARR_CALL_FLOW]} {
               set ARR_CALL_FLOW(seqNo) 1
          } else {
               incr ARR_CALL_FLOW(seqNo)
          }
          switch $simType {
               "MME"  {set simIndex MMEIndex;  set mmeId [getFromTestMap -MMEIndex $MMEIndex -param "MMEId"]}
               "HeNB" {set simIndex HeNBIndex; set henbId [getFromTestMap -HeNBIndex $HeNBIndex -param "HeNBId"]}
          }
          set callFlowIndex "$ARR_CALL_FLOW(seqNo),$simType,[set $simIndex],$operation"
          set ARR_CALL_FLOW($callFlowIndex) $msgName
     }
     
     switch $operation {
          "send" {
               foreach id [lsort -increasing [array names arr_s1_msg]] {
                    set varData ""

                    #foreach ueVar [list ueid enbues1apid mmeues1apid] 
                    foreach ueVar [list ueid eNB_UE_S1AP_ID mME_UE_S1AP_ID] {
                         if {[regexp "$ueVar=\(\\d+\)" [lindex $arr_s1_msg($id) 0] varVal]} {
                              if {[info exists varVal]} {
                                   append varData " $varVal"
                                   unset varVal
                              }
                         }
                    }
                    if {$varData != ""} {append ARR_CALL_FLOW($callFlowIndex) " \($varData \)"}
                    
                    set command "SendS1apMsg [lindex $arr_s1_msg($id) 0]"
                    set result [updateValAndExecute "executeLteSimulatorBkdoorCmd -simType simType -command command \
                              -HeNBIndex HeNBIndex -MMEIndex MMEIndex"]
                    if {[regexp "ERROR: " $result]} {
                         print -fail "Failed to send the S1AP message from $simType"
                         set flag 1
                         incr failCount
                    } else  {
                         print -info "Successfully sent the S1AP message from $simType"
                    }
               }
               set simType [string toupper $simType]
               set noOfEntities [llength [array names arr_s1_msg]]
               if {$flag} {
                    print -fail "Sending S1AP $msgType,$msgName message failed for $failCount out of $noOfEntities entities from $simType simulator"
                    return -1
               } else {
                    print -info "Successfully sent S1AP $msgType,$msgName message for $noOfEntities entities from $simType simulator"
                    return 0
               }
          }
          "expect" {
               foreach id [lsort -increasing [array names arr_s1_msg]] {

                    # get the data dump from simulator
                    set simData [updateValAndExecute "getS1APMessageFromSim -simType simType \
                              -HeNBIndex HeNBIndex -MMEIndex MMEIndex -henbId henbId -mmeId mmeId -enbID enbID \
                              -cmdRetryAttempts getS1MsgRetryAttemps -cmdRetryAfter getS1MsgRetryAfter"]
                    if {$simData == -1} {
                         print -fail "Not able retrieve S1AP message recieved on dbg ($simType simulator)"
                         set flag 1
                         continue
                    }

                    if {[info exists ::IS_BKGND_SCRIPT]} {
                       if { $::IS_BKGND_SCRIPT == 1 } {
                          print -info "Reading the GetMessage value from the output file for UT testing"
                          if {[info exists ::ARR_UTMSG_COUNT($msgName)]} {
                             set msgCount $::ARR_UTMSG_COUNT($msgName)
                             set ::ARR_UTMSG_COUNT($msgName) [incr msgCount]
                          } else {
                             set ::ARR_UTMSG_COUNT($msgName) 1
                             set msgCount 1  
                          }

                          print -info "Msg and Count info: $msgName - $msgCount"

                          if { [info exists ::ARR_UTOUTPUT_MAP($msgName,$msgCount)] } { 
                             set simData $::ARR_UTOUTPUT_MAP($msgName,$msgCount)
                          } else {
                             print -fail "ERROR: User has not given the output for $msgName in output file"
                             return -1
                          }
                       }
                    }

                    print -info "SIMDATA: $simData"

                    
                    # The simulator maintains an unique id for each UE message that is being received
                    # on the MME simulator
                    # This id would be used by the mme simulator for subsiquest messages that are sent to the UE
                    # So we extract the full processed data from simulator and using reverse mapping
                    # get the UE for which the data has to be processed
                    if {$msgName == "initial_ue_message"} {
                         set result  [processSimulatorOutput $simData "mmesim" "full"]
                         if {[catch {array set arr_local $result} err]} {
                              print -fail "Error extracting data"
                              print -info "Got error: $err"
                              return -1
                         }
                         set enbueid $arr_local(eNB_UE_S1AP_ID)
                         set ues     [array names ::ARR_LTE_TEST_PARAMS_MAP -regexp "vENBUES1APId"]
                         if {[isEmptyList $ues]} {
                              print -fail "Could not get the UE data for updation"
                              return -1
                         } else {
                              foreach ue $ues {
                                   if {$::ARR_LTE_TEST_PARAMS_MAP($ue) == $enbueid} {
                                        set UeIndex [lindex [split $ue ,] 3]
					set arr_local(UEID) 1
                                        set ::ARR_LTE_TEST_PARAMS_MAP(H,$HeNBIndex,U,$UeIndex,mmeUEId) $arr_local(UEID)
                                        print -info "Updated MMEUEID=$arr_local(UEID) for UE=$UeIndex"
                                        break
                                   }
                              }
                         }
                    }
                    
                    set varData ""
                    #foreach ueVar [list ueid enbues1apid mmeues1apid] 
                    foreach ueVar [list ueid eNB_UE_S1AP_ID mME_UE_S1AP_ID] {
                         if {[regexp "$ueVar=\(\\d+\)" [lindex $arr_s1_msg($id) 0] varVal]} {
                              if {[info exists varVal]} {
                                   append varData " $varVal"
                                   unset varVal
                              }
                         }
                    }
                    if {$varData != ""} {append ARR_CALL_FLOW($callFlowIndex) " \($varData \)"}
                    
                    # Verify the constructed data against expected values
                    set result  [verifyRcvdS1APMessage -msgName $msgName -msgType $msgType \
                              -expValList $arr_s1_msg($id) -simData $simData -verifyLatest $verifyLatest]
                    if {$simType == "MME"} {
                         set dbgStr "for MME"
                    } else {
                         set dbgStr "on HeNB"
                    }
                    if {$result != 0} {
                         print -fail "S1AP message verification failed $dbgStr"
                         set flag 1
                    } else {
                         print -pass "S1AP message verification successful $dbgStr"
                    }
               }
               if {$flag} {
                    print -fail "S1AP message verification failed from $simType simulator"
                    return -1
               } else {
                    print -info "Successfully verified from $simType simulator"
                    return 0
               }
          }
          "don'texpect" {
               # checking for messages on simulator that were not supposed to be recieved
               foreach id [lsort -increasing [array names arr_s1_msg]] {
                    print -info "Ensure \"$id\" message will not be recieve on $simType simulator"
                    # get the data dump from simulator
                    set simData [updateValAndExecute "getS1APMessageFromSim -simType simType \
                              -HeNBIndex HeNBIndex -MMEIndex MMEIndex \
                              -cmdRetryAttempts getS1MsgRetryAttemps -cmdRetryAfter getS1MsgRetryAfter"]
                    if {$simData == -1} {
                         print -pass "Didn't receive $id message on $simType simulator"
                    } else {
                         set result  [processSimulatorOutput $simData "mmesim" "full"]
                         if {[catch {array set arr_local $result} err]} {
                              print -fail "Error extracting data"
                              print -info "Got error: $err"
                         } else {
                              if {[regexp {(M|m)sg(t|T)ype=([a-zA-Z_-]+)} [lindex $arr_s1_msg($id) 0] varVal]} {
                                   if {[info exists varVal]} {
                                        set expMsg [string trim [lindex [split $varVal =] 1]]
                                        set expMsg [simMsgNameMapper $expMsg]
                                        if {[string tolower $expMsg] == [string tolower $arr_local(msgName)]} {
                                             print -fail "Did not expect to receive message $expMsg on simulator"
                                        } else {
                                             print -fail "Did not expect to receive message $expMsg on simulator however received message $arr_local(msgName)"
                                        }
                                   }
                              }
                         }
                         print -fail "Received unexpected $id message on $simType simulator"
                         set flag 1
                    }
               }
               if {$flag} {
                    print -fail "Few/All messages that were not expected recieved on $simType simulator"
                    return -1
               } else {
                    print -pass "Not found any unexpected messages on $simType Simulator"
                    return 0
               }
          }
     }
}

proc getS1APMessageFromSim {args} {
     #-
     #- code to verify a recieved S1AP message
     #-
     parseArgs args \
               [list \
               [list simType            optional   "MME|HeNB"      "MME"                  "simulator on which the output has to b verified"] \
               [list cmdRetryAttempts   optional   "numeric"       "5"                    "Number of attempts"] \
               [list cmdRetryAfter      optional   "numeric"       "1"                    "Time interval between attempts"] \
               [list HeNBIndex          optional   "numeric"       "__UN_DEFINED_"        "HeNBIndex"] \
               [list MMEIndex           optional   "numeric"       "__UN_DEFINED_"        "MMEIndex"] \
               [list henbId             optional   "numeric"       "__UN_DEFINED__"       "HeNB id to filter data for specific henb"] \
               [list enbID              optional   "numeric"       "__UN_DEFINED__"       "ENBID"] \
               [list mmeId             optional   "numeric"       "__UN_DEFINED__"       "HeNB id to filter data for specific henb"] \
               ]
     
     set command "GetMessages"
     
     # consider henb id if it is passed to filter data
     if {[info exists henbId]} { append command " henbId=$henbId" }
     if {[info exists mmeId]} { append command " MMEId=$mmeId" } 
     if {[info exists enbID] && $simType == "MME"} { 
        append command " enbid={macroENB_ID=$enbID}"
     } 
     
     for {set retryAttempt 1} {$retryAttempt <= $cmdRetryAttempts} {incr retryAttempt} {
          printHeader "$retryAttempt : Trying to retrieve data from [string toupper $simType] simulator" 100
          set result [executeLteSimulatorBkdoorCmd -simType $simType -command $command -${simType}Index [set ${simType}Index]]
          if {[regexp "ERROR: " $result]} {
               print -fail "Failed to dump the received S1AP message on [string toupper $simType]"
               return -1
          }
         
          # condition where data is received on simulator
          if {[string trim $result] != ""} {break}
          
          # decission for retrying
          if {$retryAttempt == $cmdRetryAttempts} {
               print -fail "Failed to retrieve data from [string toupper $simType] simulator"
               return -1
          } else {
               print -info -nonewline "Not able retrieve data from [string toupper $simType] simulator. To retry ... "
               halt $cmdRetryAfter
          }
     }
     
     return $result
}

proc verifyRcvdS1APMessage {args} {
     #-
     #- This procedure is used to verify the expected S1AP message against the received one
     #-
     #- @out 0 on pass, -1 fail (mismatch)
     #-
     
     set flag 0
     set validateList ""
     parseArgs args \
               [list \
               [list msgName              optional   "string"       ""                    "Name of the S1AP message that we are sending"] \
               [list msgType              optional   "string"       ""                    "Type of S1AP message that we are sending"] \
               [list simData              mandatory  "string"       ""                    "The data received from the simulator"] \
               [list expValList           mandatory  "string"       ""                    "The data that is expected to be received"] \
               [list verifyLatest         optional   "yes|no"       "no"                        "Option to verify latest message's value in output message"] \
               ]
     # verification
     return [verifySimOutput [processSimInput $msgName $expValList] [processSimulatorOutput $simData "mmesim" "verify" $verifyLatest]]
}

proc S1Setup {args} {
     #-
     #- Procedure for sending/expecting S1 setup message
     #-
     #- @return 0 on success, @return -1 on failure
     #-
     global ARR_HeNBGRP_MAP
     global IS_HENB
     set validS1Msg        "request|response|failure|paging"
     set defaultCauseValue "message_not_compatible_with_receiver_state"
     
     parseArgs args \
               [list \
               [list fgwNum                  optional   "string"         "0"             "The Broadcasted TAC to be used" ] \
               [list msg                  optional   "$validS1Msg"    "request"                    "The message to be sent" ] \
               [list operation            optional   "send|(don't|)expect" "send"             	   "send or expect option" ] \
               [list execute              optional   "boolean"        "yes"                        "To perform the operation or not. if no, will return the message"] \
               [list streamId             optional   "string"         "0"                          "The sctp string to send or receive data"] \
               [list TAC                  optional   "string"         "__UN_DEFINED__"             "The Broadcasted TAC to be used" ] \
               [list eNBName              optional   "string"         [getLTEParam "HeNBGWName"]   "eNB name"] \
               [list globaleNBId          optional   "string"         [getLTEParam "globaleNBId"]  "eNB ID"] \
               [list pagingDRX            optional   "string"         "v[getLTEParam defaultPagingDrx]" "Pagging DRX value"] \
               [list MCC                  optional   "string"         "__UN_DEFINED__"             "The MCC param to be used"] \
               [list MNC                  optional   "string"         "__UN_DEFINED__"             "The MNC param to be used"] \
               [list MMEName              optional   "string"         "__UN_DEFINED__"             "The MME Name to be sent"] \
               [list HeNBId               optional   "string"         "__UN_DEFINED__"             "The heNBId param to be used in HeNB"] \
               [list HeNBMCC              optional   "string"         "__UN_DEFINED__"             "The MCC param to be used in HeNB"] \
               [list HeNBMNC              optional   "string"         "__UN_DEFINED__"             "The MNC param to be used in HeNB"] \
               [list CSGId                optional   "string"         "__UN_DEFINED__"             "The CSGId param to be used in HeNB"] \
               [list MMEGroupId           optional   "string"         [getLTEParam "MMEGroupId"]   "The MME group ID to be used"] \
               [list MMECode              optional   "string"         [getLTEParam "MMECode"]      "The MME Code to be used"] \
               [list MMERelaySupportInd   optional   "string"         "__UN_DEFINED__"             "The MME Relay Support Indicator to be used"] \
               [list timeToWait           optional   "string"         "__UN_DEFINED__"             "Value of time to wait indication in failure msg"] \
               [list causeType            optional   "string"         "protocol"                   "Identifies the cause choice group"] \
               [list cause                optional   "string"         "$defaultCauseValue"         "Identifies the cause value"] \
               [list criticalityDiag      optional   "string"         "__UN_DEFINED__"             "The critical diag to be enabled or not"] \
               [list procedureCode        optional   "string"         "__UN_DEFINED__"             "The procedure code to be used diag"] \
               [list triggerMsg           optional   "string"         "__UN_DEFINED__"             "Identifies the triggering message"] \
               [list procedureCriticality optional   "string"         "__UN_DEFINED__"             "Identifies the procedure Criticality"] \
               [list IECriticality        optional   "string"         "__UN_DEFINED__"             "Identifies the IE Criticality"] \
               [list IEId                 optional   "string"         "__UN_DEFINED__"             "Identifies the IE Id"] \
               [list typeOfError          optional   "string"         "__UN_DEFINED__"             "Identifies the type of error"] \
               [list supportedTAs         optional   "string"        "__UN_DEFINED__"             "Identifies supported TAI"] \
               [list verifyLog            optional   "start|stop|no"  "no"                         "Option to start log verification"] \
               [list getS1MsgRetryAttemps optional   "numeric"        "__UN_DEFINED__"             "Retry attempts to get the date"] \
               [list getS1MsgRetryAfter   optional   "numeric"        "__UN_DEFINED__"             "Time between retries to get data"] \
               [list eNBType              optional   "home|macro"     "__UN_DEFINED__"             "eNB type"] \
               [list MultiS1Link          optional   "yes|no"         "no"                          "flag to enable multiple s1 links"] \
               [list verifyLatest         optional   "yes|no"         "no"                        "Option to verify latest message's value in output message"] \
               ]
     
     set msgName [string map "request s1_setup_request response s1_setup_response failure s1_setup_failure paging paging" $msg]
     set msgType "class1"
     
     if {![info exists eNBType]} {
	     if {[info exists ::env(ENB)]} {
	          print -debug "env(ENB) set in bash"
	          set eNBType macro
	     } else {
	          set IS_HENB 1
	          set eNBType home
	     }
     } elseif { [info exists eNBType] && $eNBType == "home" } {
          set IS_HENB 1
     }
     
     #commented to read eNBType value from script
     # else {
     #    set eNBType macro
     #}
     
     #To verify logging in the system we will extract the message file and verify if the pattern is matched as expected
     if {$verifyLog == "start"} {
          set result [verifyAlarmLogging -operation "init" -msgType $msgName]
          if {$result < 0} {
               print -debug "Message analysis will not work, could not initialize logging"
          }
     }

     set gwIp   [getDataFromConfigFile "mmeSignalingIpaddress" $fgwNum]
     set gwPort [getDataFromConfigFile "henbSctp" $fgwNum] 
 
     switch $operation {
          "send" {
               switch -regexp $msg {
                    "request" {
                         set simType "HeNB"
                         set gwIp   [getDataFromConfigFile "henbSignalingIpaddress" $fgwNum]
                         parseArgs args \
                                   [list \
                                   [list HeNBIndex   mandatory  "numeric"        ""        "Index of HeNB"] \
                                   [list sctpInit    optional   "boolean"        "yes"     "Initialize sctp before sending S1"] \
                                   ]
                         
                         #Setup SCTP association if required
                         if {$sctpInit == "yes"} {
                              print -info "Setting up STCP before establishing an S1 connection"
                              set result [createHeNB -HeNBIndex $HeNBIndex -operation "send" -verify "yes" -streamId $streamId]
                              if {$result < 0} {
                                   print -fail "Setting up of SCTP to HeNBGW failed"
                                   return -1
                              } else {
                                   print -pass "Sucessfully setup SCTP towards HeNBGW"
                              }
                         }

                         print -info "Using below values for S1 setup request from HeNB of index $HeNBIndex, if they are not passed from script"
                         print -info "[array get ::ARR_LTE_TEST_PARAMS_MAP "H,$HeNBIndex,*"]"

                         if { ![info exists TAC] }    { set TAC      [getFromTestMap -HeNBIndex $HeNBIndex -param "TAC"] }
                         if { ![info exists MNC] }    { set MNC      [getFromTestMap -HeNBIndex $HeNBIndex -param "MNC"] }
                         if { ![info exists MCC] }    { set MCC      [getFromTestMap -HeNBIndex $HeNBIndex -param "MCC"] }
                         if { ![info exists CSGId] }  { set CSGId    [getFromTestMap -HeNBIndex $HeNBIndex -param "CSGId"]}
                         if { ![info exists HeNBId] } { set HeNBId   [getFromTestMap -HeNBIndex $HeNBIndex -param "HeNBId"] }
                         if { ![info exists HeNBMNC]} { set HeNBMNC  [lindex [lindex [getFromTestMap -HeNBIndex $HeNBIndex -param "MNC"] 0] 0]}
                         if { ![info exists HeNBMCC]} { set HeNBMCC  [lindex [lindex [getFromTestMap -HeNBIndex $HeNBIndex -param "MCC"] 0] 0]}
                         
                         foreach param "CSGId globaleNBId HeNBMNC HeNBMCC pagingDRX" {
                              if {[set $param] == ""} {
                                   print -dbg "No $param IE generated with -$param <val> option. will not send $param IE in the message"
                                   unset -nocomplain $param
                              }
                         }
                         
                         set CSGId [ string trim $CSGId "{}" ]
                         if {[info exists CSGId]} {
                              set csgIdList ""
                              set csgCount 0
                              foreach csgid [split $CSGId " "] {
                                   if {$csgCount == 0 } {
                                     set csgIdList "{cSG_Id=$csgid} "
                                   } else {
                                     set csgIdList [ concat $csgIdList "cSG_IdList=\{cSG_Id=$csgid\} " ]
                                   }
                                   incr csgCount
                              }
                              set CSGId $csgIdList
                         }
                         
                         # generate globaleNBId if it is expected to be used
                         if {[info exists globaleNBId] && [info exists HeNBMNC] && [info exists HeNBMCC]} {
                              set globaleNBId "\{ eNB_ID=\{ ${eNBType}ENB_ID=$HeNBId \} pLMNidentity=\{ MCC=$HeNBMCC MNC=$HeNBMNC\}\}"
                              
                              unset -nocomplain HeNBMNC
                              unset -nocomplain HeNBMCC
                         }
                         
                         #Storing eNBType value in HeNB global info, to use in other messages
                         set paramList [list [list "eNBType" $eNBType]]
                         print -info "The eNBType has been set to \"$eNBType\""
                         updateLteParamData -HeNBIndex $HeNBIndex -paramList $paramList
                         
                         if { ![info exists supportedTAs]} {
                              set supportedTAs [getTA -TACList $TAC -MNCList $MNC -MCCList $MCC]
                              #set supportedTAs [getTAList -TACList $TAC -MNCList $MNC -MCCList $MCC]
                              print -info "supportedTAs $supportedTAs"
                         }

                         if {$supportedTAs == ""} {
                              print -info "No supportedTAs IE generated with -TAC $TAC -MCC $MCC -MNC $MNC ... will not send supportedTAs IE in the message"
                              unset -nocomplain supportedTAs
                         }
                    }
                    "response" {
                         set simType "MME"
                         set defaultRelCap [getRandomUniqueListInRange 1 255]
                         parseArgs args \
                                   [list \
                                   [list MMEIndex   mandatory  "numeric"      ""     "Index of MME"] \
                                   [list GUMMEIIndex   optional     "string"  "all"  "Index of GUMMEI"] \
                                   [list relMMECapability  optional "string"  "$defaultRelCap"  "The relMMECapability to be used"] \
                                   ]
                         
                    	 set MMEId [getFromTestMap -MMEIndex $MMEIndex -param "MMEId"]
                         unset -nocomplain gwIp  
                         unset -nocomplain gwPort

                         set servedGUMMEIList [getServedGUMMEIList -MMEIndex $MMEIndex -GUMMEIIndex $GUMMEIIndex]
                         if {$servedGUMMEIList == ""} {
                              print -info "No Served GUMMEIs generated with -MMEIndex $MMEIndex -GUMMEIIndex $GUMMEIIndex ... will not send served GUMMEIs in the message"
                              unset -nocomplain servedGUMMEIList
                         }
                         if {$relMMECapability == ""} {
                              print -info "No Relative MME Capability IE generated with -relMMECapability $relMMECapability ... will not send Relative MME Capability IE in the message"
                              unset -nocomplain relMMECapability
                         }

                         if {$MultiS1Link == "yes"} {
                            # generate globaleNBId if it is expected to be used
                            if {[info exists globaleNBId]} {
                              set globaleNBId "\{${eNBType}ENB_ID=$globaleNBId\}" 
                            }
                         } else {
                            unset -nocomplain globaleNBId
                         }
                    }
                    "failure" {
                         set simType "MME"
                         unset -nocomplain gwIp
                         unset -nocomplain gwPort
                         unset -nocomplain globaleNBId

                         parseArgs args \
                                   [list \
                                   [list MMEIndex   mandatory  "numeric"        ""     "Index of MME"] \
                                   ]
                    	 set MMEId [getFromTestMap -MMEIndex $MMEIndex -param "MMEId"]
                         if {$causeType == ""} {
                              print -info "No Cause Type IE generated with -causeType $causeType ... will not send cause IE in the message"
                              unset -nocomplain causeType
                         }
                         if {$cause == ""} {
                              print -info "No Cause value IE generated with -cause $cause ... will not send cause IE in the message"
                              unset -nocomplain cause
                         }
                         
                    }
                    
                    "paging" {
                         set simType "MME"
                         set msgType "class2"
                    	 set MMEId [getFromTestMap -MMEIndex $MMEIndex -param "MMEId"]
                         
                         parseArgs args \
                                   [list \
                                   [list ueIdentityIndexValue    optional   "numeric"     "100"                  "Index of MME"] \
                                   [list uePagingId              optional   "stmsi|imsi"  "stmsi"                "UE paging ID IMSI or s-TMSI "] \
                                   [list cnDomain                optional   "cs|ps"       "cs"                   "CN domain CS or PS" ] \
                                   [list pagingPriority          optional   "string"      "__UN_DEFINED__"       "Paging Priority" ] \
                                   [list drxPaging               optional   "string"      "__UN_DEFINED__"       "Paging Priority" ] \
                                   [list testTAI                 optional   "string"      "no"                   "Send paging message with only test TAI" ] \
                                   [list GUMMEIIndex             optional   "string"      "0"                    "Index of GUMMEI"] \
                                   [list MMEIndex                optional   "string"      "0"                    "Index of GUMMEI"] \
                                   [list needCsgId               optional   "string"      "no"                   "Index of GUMMEI"] \
                                   ]
                         
                         if { $needCsgId != "no" } {
                              if { ![info exists CSGId] }  { set CSGId  [ join [ lindex [getFromTestMap -HeNBIndex "all"  -param "CSGId"] 0 ] , ] }
                              
                              foreach param "CSGId pagingDRX" {
                                   if {[set $param] == ""} {
                                        print -dbg "No $param IE generated with -$param <val> option. will not send $param IE in the message"
                                        unset -nocomplain $param
                                   }
                              }
                         }
                         
                         if { ![info exists TAC] }    { set TAC      [getFromTestMap -HeNBIndex "all" -param "TAC"] }
                         if { ![info exists MNC] }    { set MNC      [getFromTestMap -HeNBIndex "all" -param "MNC"] }
                         if { ![info exists MCC] }    { set MCC      [getFromTestMap -HeNBIndex "all" -param "MCC"] }
                         
                         set supportedTAs [getTA -TACList $TAC -MNCList $MNC -MCCList $MCC]
                         print -info "supportedTAs $supportedTAs"
                         if {$supportedTAs == ""} {
                              print -info "No supportedTAs IE generated with -TAC $TAC -MCC $MCC -MNC $MNC ... \
                                        will not send supportedTAs IE in the message"
                              unset -nocomplain supportedTAs
                         }
                         
                         if { $testTAI != "no" } {
                              set testTAC $::ARR_LTE_TEST_PARAMS(testTAC)
                              set testMNC $::ARR_LTE_TEST_PARAMS(testMNC)
                              set testMCC $::ARR_LTE_TEST_PARAMS(testMCC)
                              set supportedTestTAs [getTA -TACList $testTAC -MNCList $testMNC -MCCList $testMCC]
                              
                              if { $testTAI == "testTAIOnly" } { set supportedTAs $supportedTestTAs }
                              if { $testTAI == "yes" } { set supportedTAs "$supportedTAs,$supportedTestTAs" }
                         }
                         
                         switch  $uePagingId  {
                              "stmsi"  {
                                   set mmecList [getFromTestMap -MMEIndex $MMEIndex -GUMMEIIndex $GUMMEIIndex -param "MMECode"]
                                   set mmeCode [ lindex $mmecList 0 ]
                                   set mTmsi [ random 429496729 ]
                                   set uePagingId [ list "s_TMSI=[list [ list mMEC=$mmeCode m_TMSI=$mTmsi]]" ]
                              }
                              
                              "imsi"  {
                                   set mnc  [ lindex [getFromTestMap -MMEIndex $MMEIndex -GUMMEIIndex $GUMMEIIndex -param "MNC"] 0 ]
                                   set mcc  [ lindex [getFromTestMap -MMEIndex $MMEIndex -GUMMEIIndex $GUMMEIIndex -param "MCC"] 0 ]
                                   set msin [ random 429496729 ]
                                   set uePagingId  "{imsi=$mcc$mnc$msin}"
                                   print -info "imsi --> $uePagingId"
                              }
                         }
                    }
               }
          }
          "expect" {
               if {[regexp "request" $msg]} {
                    set simType "MME"
                    
                    parseArgs args \
                              [list \
                              [list MMEIndex   mandatory  "numeric"        ""     "Index of MME"] \
                              ]
                    
                    set MMEId [getFromTestMap -MMEIndex $MMEIndex -param "MMEId"]
                    set regions [getFromTestMap -MMEIndex $MMEIndex -param "Region"]
                    foreach ie [list TAC MCC MNC] {
                         #Fetching TAC,MCC,MNC value from global array, if they are not passed from script
                         if {![info exists $ie]} {
                              set $ie ""
                              #Getting all regionIndices of MME
                              foreach regInd $regions {
                                   set $ie [concat [set $ie] [getFromTestMap -HeNBIndex "all" -param "$ie" -RegionIndex $regInd]]
                              }
                         }
                    }
                    
                    #if { ![info exists HeNBMNC]} { set HeNBMNC  [getFromTestParam "gwMNC"]}
                    #if { ![info exists HeNBMCC]} { set HeNBMCC  [getFromTestParam "gwMCC"]}
                    
                    #### [lindex $regions 0] is to fetch first region's globalMCC/MNC when MME is accessed by multiple regions
                    if { ![info exists HeNBMNC]} { set HeNBMNC  [lindex [getFromTestMap -HeNBIndex "all" -param "MNC" -RegionIndex [lindex $regions 0]] 0 0]}
                    if { ![info exists HeNBMCC]} { set HeNBMCC  [lindex [getFromTestMap -HeNBIndex "all" -param "MCC" -RegionIndex [lindex $regions 0]] 0 0]}
                    # generate globaleNBId if it is expected to be used
                    # will be in format of GlobalENBId={mcc=123 mnc=456 macroENBId=50}
                    if {[info exists globaleNBId] && [info exists HeNBMNC] && [info exists HeNBMCC]} {
                         #set globaleNBId [list [list mcc=$HeNBMCC mnc=$HeNBMNC macroENBId=$globaleNBId]]
                         if {$MultiS1Link == "yes"} {
                         set enbID $globaleNBId 
                         } 
                         set globaleNBId "\{ eNB_ID=\{ macroENB_ID=$globaleNBId \} pLMNidentity=\{ MCC=$HeNBMCC MNC=$HeNBMNC\}\}"
                         unset -nocomplain HeNBMNC
                         unset -nocomplain HeNBMCC
                         unset -nocomplain HeNBId
                    }
                    
                    if { ![info exists supportedTAs]} {
                         print -info "TAC $TAC, MNC $MNC, MCC $MCC"
                         set supportedTAs [getTA -TACList $TAC -MNCList $MNC -MCCList $MCC]
                         print -info "supportedTAs $supportedTAs"
                    }
                    
               } elseif {[regexp "response" $msg]} {
                    set simType "HeNB"
                    parseArgs args \
                              [list \
                              [list HeNBIndex   mandatory  "numeric"        ""     "Index of HeNB"] \
                              [list MMEIndex    optional   "string"        "all"    "Index of MME"] \
                              [list GUMMEIIndex optional   "string"        "all"   "Index of GUMMEI"] \
                              [list relMMECapability  optional "string"    "255"  "The relMMECapability to be used"] \
                              ]
                    
                    if { ![info exists MMEName]} { set MMEName  [getFromTestParam "HeNBGWName"]}
                    #commenting MMERelaySupportInd as Gw should not send this IE to HeNB, bug809212
                    #if { ![info exists MMERelaySupportInd]} { set MMERelaySupportInd "TRUE_"}
                    
                    set regionIndex [getFromTestMap -HeNBIndex $HeNBIndex -param "Region"]
                    set servedGUMMEIList [getServedGUMMEIList -MMEIndex $MMEIndex -GUMMEIIndex $GUMMEIIndex -RegionIndex $regionIndex]

                    unset -nocomplain globaleNBId 
                    
                    #To get the henbgrp serving the henb we would get the data from DS
                    #Any further reference to the henb has to be mapped for this henbgrp
                    set henbid   [getFromTestMap -HeNBIndex $HeNBIndex -param "HeNBId"]
                    set data     [executeDsDbgDoorCmd -command "show henb"]
                    set data     [split [extractOutputFromResult $data] "\n"]
                    set index    [lsearch -regexp $data "HeNBId"]
                    if {$index != -1} {
                         set data [lrange $data [expr $index + 1] end-1]
                         if {[isEmptyList $data]} {
                              print -fail "No DS data exists for HeNB"
                              continue
                         }
                         foreach line $data {
                              foreach {enbid henbgrp} $line {
                                   if {[regexp "/" $enbid]} {
                                        foreach {plmn hd enbid} [split $enbid "/"] {break}
                                   }
                                   if {[string trim $enbid] == $henbid} {
                                        set ARR_HeNBGRP_MAP($HeNBIndex) [string trim $henbgrp]
                                        parray ARR_HeNBGRP_MAP
                                        break
                                   }
                              }
                         }
                    }
                    if {![info exists ARR_HeNBGRP_MAP($HeNBIndex)]} {
                         if {[array exists ARR_HeNBGRP_MAP]} {
                              set noOfS1Req   [llength [array names ARR_HeNBGRP_MAP]]
                              set s1HeNbIndex [expr $noOfS1Req % 4]
                              if {$s1HeNbIndex == 0} {set s1HeNbIndex 4}
                              set ARR_HeNBGRP_MAP($HeNBIndex) $s1HeNbIndex
                         } else {
                              print -info "Could not get henbgrp mapping for henb, assuming default"
                              set ARR_HeNBGRP_MAP($HeNBIndex) 1
                         }
                    }
                    parray ARR_HeNBGRP_MAP
               } elseif {[regexp "failure" $msg]} {
                    set simType "HeNB"
                    parseArgs args \
                              [list \
                              [list HeNBIndex   mandatory  "numeric"        ""     "Index of HeNB"] \
                              ]
               }
          }
          "don'texpect" {
               set simType "HeNB"
               parseArgs args \
                              [list \
                              [list HeNBIndex   mandatory  "numeric"        ""     "Index of HeNB"] \
                              ]
               set s1setup [list $msgName ""]
               return [updateValAndExecute "sendOrVerifyS1APProcedure -msgName msgName -msgType msgType -operation operation \
                                            -msgList s1setup -simType simType -HeNBIndex HeNBIndex "]

          }
     }
     
     if {[info exists criticalityDiag]} {
          set criticDiag [updateValAndExecute "getCriticDiag -criticalityDiag criticalityDiag \
                    -procedureCode procedureCode -triggerMsg triggerMsg -procedureCriticality procedureCriticality \
                    -IECriticality IECriticality -IEId IEId -typeOfError typeOfError"]
     }

     if {[info exists causeType] && [info exists cause]} {
        set causeVal "\{$causeType=$cause\}"
     }
     
     set s1SetupMsg [updateValAndExecute "constructS1Procedure -simType simType -msgName msgName -msgType msgType \
            -HeNBId HeNBId -MMEId MMEId -globaleNBId globaleNBId -HeNBMCC HeNBMCC -HeNBMNC HeNBMNC -pagingDRX pagingDRX -CSGIdList CSGId \
               -MMEName MMEName -MCC MCC -MNC MNC -supportedTAs supportedTAs -MMEGroupId MMEGroupId -gwIp gwIp -gwPort gwPort \
               -MMECode MMECode -relMMECapability relMMECapability -MMERelaySupportInd MMERelaySupportInd -drxPaging drxPaging\
               -criticalityDiag criticDiag -eNBName eNBName -cause causeVal -pagingPriority pagingPriority -MultiS1Link MultiS1Link\
               -timeToWait timeToWait -servedGUMMEIList servedGUMMEIList -streamId streamId -uePagingId uePagingId" ]
     print -info "s1SetupMsg $s1SetupMsg"
     
     if {$execute == "no"} { return "$simType $s1SetupMsg"}
     
     return [updateValAndExecute "sendOrVerifyS1APProcedure -msgName msgName -msgType msgType \
               -operation operation -msgList s1SetupMsg -simType simType -enbID enbID \
               -HeNBIndex HeNBIndex -MMEIndex MMEIndex -verifyLatest verifyLatest \
               -getS1MsgRetryAttemps getS1MsgRetryAttemps -getS1MsgRetryAfter getS1MsgRetryAfter"]
}

proc errorIndication {args} {
     #-
     #- Procedure for sending/expecting errorIndication
     #-
     #- @return 0 on success, @return -1 on failure
     #-
     set validSims "HeNB|MME"
     parseArgs args \
               [list \
               [list operation            optional   "send|(don't|)expect" "send"                                        "send or expect option" ] \
               [list execute              optional   "boolean"             "yes"                                         "To perform the operation or not. if no, will return the message"] \
               [list MMEIndex             optional   "numeric"             "__UN_DEFINED__"                              "Index of MME"] \
               [list causeType            optional   "string"              "protocol"                                    "Identifies the cause choice group"] \
               [list cause                optional   "string"              "message_not_compatible_with_receiver_state"  "Identifies the cause value"] \
               [list criticalityDiag      optional   "string"              "__UN_DEFINED__"                              "The critical diag to be enabled or not"] \
               [list procedureCode        optional   "string"              "__UN_DEFINED__"                              "The procedure code to be used diag"] \
               [list triggerMsg           optional   "string"              "__UN_DEFINED__"                              "Identifies the triggering message"] \
               [list procedureCriticality optional   "string"              "__UN_DEFINED__"                              "Identifies the procedure Criticality"] \
               [list IECriticality        optional   "string"              "__UN_DEFINED__"                              "Identifies the IE Criticality list"] \
               [list IEId                 optional   "numeric"             "__UN_DEFINED__"                              "Identifies the IE Id list"] \
               [list typeOfError          optional   "string"              "__UN_DEFINED__"                              "Identifies the type of error list"] \
               [list eNBUES1APId          optional   "string"        "__UN_DEFINED__"    "eNB UE S1AP Id value" ] \
               [list MMEUES1APId          optional   "string"        "__UN_DEFINED__"    "MME UE S1AP Id value" ] \
               [list UEIndex              optional  "numeric" 	      ""      		  "Index of UE whose values need to be retrieved" ] \
               [list verifyLog            optional   "start|stop|no"       "no"                                          "Option to start log verification"] \
               [list streamId             optional   "numeric" 	           "__UN_DEFINED__"                              "The streamID to be used for the UE transaction" ] \
               [list ignoreIE             optional   "string" 	           "__UN_DEFINED__"                              "To ignore some of the fields in error indication" ] \
               ]
     
     set msgName "error_indication"
     set msgType "class1"
     
     #To verify logging in the system we will extract the message file and verify if the pattern is matched as expected
     if {$verifyLog == "start"} {
          set result [verifyAlarmLogging -operation "init" -msgType $msgName]
          if {$result < 0} {
               print -debug "Message analysis will not work, could not initialize logging"
          }
     }

     set gwPort [getDataFromConfigFile "henbSctp" 0 ]

     if {[info exists UEIndex]} {
          #If UEIndex is passed from user, simType also has to be passed from script
          parseArgs args \
                    [list \
                    [list simType            mandatory   "MME|HeNB"   ""                   "send or expect option" ] \
                    [list HeNBIndex          mandatory   "numeric"    "__UN_DEFINED__"     "Index of HeNB whose values need to be retrieved" ] \
                    ]
          
          if {![info exists MMEIndex]} {
               ##getFromTestMap returns MMEIndex incase of load balancing case of S1Flex scenario
               if {[getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "MMEIndex"] != -1} {
                    set MMEIndex [getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "MMEIndex"]
                    print -info "Using MMEIndex $MMEIndex among load balanced MMEs"

               } else {
                    #Keeping default value of 0
                    set MMEIndex "0"
                    print -info "Using default MMEIndex $MMEIndex"
               }
          } else {
               print -info "Using MMEIndex $MMEIndex passed from script"
          }

          set MultiS1Link $::ARR_LTE_TEST_PARAMS(MultiS1Link)
          if {$MultiS1Link == "yes"} {
             set enbID [getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "eNBId"]
             set eNBType [getFromTestMap -HeNBIndex $HeNBIndex -param "eNBType"]
             if {! [ info exists eNBType ]} {
                set eNBType "macro"
             }
             if {[info exists enbID]} {
                set globaleNBId "\{${eNBType}ENB_ID=$enbID\}"
             }
          }
          
          switch $simType {
               "HeNB" {
                    set paramList [list eNBUES1APId vENBUES1APId streamId]
                    set HeNBId    [getFromTestMap -HeNBIndex $HeNBIndex -param "HeNBId"]
                    set gwIp   [getDataFromConfigFile "henbSignalingIpaddress" 0 ]
               }
               "MME" {
                    set paramList [list vENBUES1APId MMEUES1APId mStreamId]
                    set gwIp   [getDataFromConfigFile "mmeSignalingIpaddress" 0 ]
     		    set MMEId  [getFromTestMap -MMEIndex $MMEIndex -param "MMEId"]
               }
               "default" {
                    print -fail "Incorrect simType passed to the proc"
                    return -1
               }
          }
          
          #Update the dynamic variables
          foreach dynElement {eNBUES1APId MMEUES1APId streamId} param $paramList {
               if {![info exists $dynElement]} {
                    if {$param == "streamId"} {
                         set streamId [expr $UEIndex + 1]
                         continue
                    }
                    if {[catch {set $dynElement [getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "$param"]}]} {
                         print -abort "Failed to get the param $param"
                         return 1
                    }
               }
          }
          
          #if the user passess an empty value for any of s1ap argument then unset the variable
          foreach ues1apid [list eNBUES1APId MMEUES1APId ] {
               if {[info exists $ues1apid]} {
                    if {[set $ues1apid] == ""} {
                         unset -nocomplain $ues1apid
                    }
               }
          }
          
     } else {
          parseArgs args \
                    [list \
                    [list HeNBIndex            optional   "numeric"    "__UN_DEFINED__"    "Index of HeNB whose values need to be retrieved" ] \
                    ]
          if {[info exists MMEIndex]} {
               set simType "MME"
     	       set MMEId  [getFromTestMap -MMEIndex $MMEIndex -param "MMEId"]
               set gwIp   [getDataFromConfigFile "mmeSignalingIpaddress" 0 ]
          }
          if {[info exists HeNBIndex]} {
               set simType "HeNB"
               set HeNBId [getFromTestMap -HeNBIndex $HeNBIndex -param "HeNBId"]
               set gwIp   [getDataFromConfigFile "henbSignalingIpaddress" 0 ]
          }
     }
     
     if { ( $operation == "expect" ) && [info exists ignoreIE]  } {
          foreach param [ split $ignoreIE , ] {
               unset -nocomplain $param
          }
     }

     if {[info exists criticalityDiag]} {
          set criticDiag [updateValAndExecute "getCriticDiag -criticalityDiag criticalityDiag \
                    -procedureCode procedureCode -triggerMsg triggerMsg -procedureCriticality procedureCriticality \
                    -IECriticality IECriticality -IEId IEId -typeOfError typeOfError"]
     }

     set causeVal "\{$causeType=$cause\}"
     
     set errIndMsg [updateValAndExecute "constructS1Procedure -simType simType -msgName msgName -msgType msgType \
               -criticalityDiag criticDiag -cause causeVal -HeNBId HeNBId -MMEId MMEId -streamId streamId -globaleNBId globaleNBId \
               -eNBUES1APId eNBUES1APId -MMEUES1APId MMEUES1APId -gwIp gwIp -gwPort gwPort"]

     print -info "errorIndicationMsg $errIndMsg"
     
     if {$execute == "no"} { return "$simType $errIndMsg"}

     if { $operation == "don'texpect" } {
               set simType "MME"
               set errIndication [list $msgName ""]
               return [updateValAndExecute "sendOrVerifyS1APProcedure -msgName msgName -msgType msgType -operation operation\
                                            -msgList errIndication -simType simType -HeNBIndex HeNBIndex -MMEIndex MMEIndex"]
     }
 
     return [updateValAndExecute "sendOrVerifyS1APProcedure -msgName msgName -msgType msgType -operation operation \
               -msgList errIndMsg -simType simType -HeNBIndex HeNBIndex -MMEIndex MMEIndex -UEIndex UEIndex -henbId HeNBId -enbID enbID"]
}

proc initialUE {args} {
     #-
     #- Procedure for sending/expecting Initial UE message
     #- TAI format:  -TAI "0,1" (TAC matching     with HeNB info,PLMN index within HeNB broadcast list)
     #-              -TAI "x,x" (TAC not matching with HeNB info,PLMN not   within HeNB broadcast list)
     #- eCGI format: -eCGI "0,1" (eCGI matching     with HeNB/macroENB info,PLMN index within HeNB broadcast list)
     #-              -eCGI "x,x" (eCGI not matching with HeNB/macroENB info,PLMN not   within HeNB broadcast list)
     #- GUMMEI format: -GUMMEI "0,1,1,1"( servedGUMMEI Index,Index of PLMN within that GUMMEI,Index MMEC within that GUMMEI,Index MMEGI within that GUMMEI)
     #-                -GUMMEI "x,x,x,x"( not from servedGUMMEI,PLMN not from GUMMEI,MMEC not from GUMMEI,MMEGI not from GUMMEI)
     #- sTMSI format: -sTMSI "x,0,1" (sTMSI taken random val,servedGUMMEI Index,Index MMEC within that GUMMEI)
     #-               -sTMSI "0,x,x" (sTMSI taken fixed val,not from servedGUMMEI,MMEC not within any GUMMEI)
     #-
     #- IEs of this message :
     #-          eNB UE S1AP ID          M
     #-          NAS-PDU                 M
     #-          TAI                     M
     #-          E-UTRAN CGI             M
     #-          RRC Establishment cause M
     #-          S-TMSI                  O
     #-            ->MMEC                M
     #-            ->M-TMSI              M
     #-          CSG Id                  O
     #-            ->PLMN Identity       M
     #-            ->Cell Identity       M
     #-          GUMMEI                  O
     #             ->PLMN identity       M
     #             ->MME Group ID        M
     #             ->MME code            M
     #-          Cell Access Mode        O
     #-          GW Transport Layer Address O
     #-          Relay Node Indicator       O
     #-@return 0 on success, @return -1 on failure
     #-
     global ARR_INITIAL_UE
     set nasPdu "05120358104f768062ccb90d9b98264bbfb2bd2010555d77652d0900ff493065c731ea4b86"
     parseArgs args \
               [list \
               [list fgwNum             optional   "string"         "0"             "The Broadcasted TAC to be used" ] \
               [list operation          optional   "send|(don't|)expect" "send"        		"send or expect option"] \
               [list execute            optional   "boolean"     "yes"         		"To perform the operation or not. if no, will return the message"] \
               [list HeNBIndex          mandatory  "numeric" 	 ""      		"Index of HeNB whose values need to be retrieved" ] \
               [list UEIndex            mandatory  "numeric" 	 ""      		"Index of UE whose values need to be retrieved" ] \
               [list MMEIndex           optional   "numeric" 	 "0"      		"Index of MME whose values need to be retrieved" ] \
               [list eNBUES1APId        optional   "string" 	 "__UN_DEFINED__"   	"eNB UE S1AP Id value" ] \
               [list TAI                optional   "string" 	 "0,0"               	"TAI chosen from UE" ] \
               [list eCGI               optional   "string" 	 "0,0"               	"e-UTRAN CGI chosen from UE" ] \
               [list RRCEstablishCause  optional   "string" 	 "MO_DATA"           	"RRC Establishment cause from UE" ] \
               [list sTMSI              optional   "string" 	 "__UN_DEFINED__"   	"M-TMSI value of S-TMSI from UE" ] \
               [list GUMMEI             optional   "string"  	 "__UN_DEFINED__"   	"GUMMEI from UE of format gummeiInd,plmnInd,mmecInd,mmegiInd" ] \
               [list CellAccessMode     optional   "string" 	 "__UN_DEFINED__"   	"Cell Access Mode value from UE" ] \
               [list GwTransportAddr    optional   "string" 	 "__UN_DEFINED__"   	"GW Transport Layer Address value from UE" ] \
               [list RelayNodeInd       optional   "string" 	 "__UN_DEFINED__"   	"Relay Node Indicator value from UE" ] \
               [list CSGId              optional   "string" 	 "__UN_DEFINED__"   	"CSGId value from UE" ] \
               [list nasLen             optional   "string"      "$nasPdu"             "Nas Length to be used for the message"] \
               [list henbUeId           optional   "numeric" 	 "__UN_DEFINED__"   	"" ] \
               [list streamId           optional   "numeric" 	 "__UN_DEFINED__"   	"The streamID to be used for the UE transaction" ] \
               ]
      
     set MultiS1Link $::ARR_LTE_TEST_PARAMS(MultiS1Link)
     set msgName "initial_ue_message"
     set msgType "class2"
     
     switch $operation {
          "send" {
               set simType "HeNB"
               set result [extractMMEIndexInS1Flex -op "snap" -HeNBIndex $HeNBIndex]
          }
          "expect" {
               set simType "MME"
               set updateVar "vENBUES1APId mStreamId"
               set state "update"

               ## In S1Flex scenario ###
               ## Finding MME index from debug door, if GUMMEI and sTMSI are not used in initialUE send
               if {![info exists GUMMEI] && ![info exists sTMSI]} {
                    if {[findNumOfMMEs] > 1} {
                         set tai [generateIEs -IEType "TAI" -paramIndices $TAI -HeNBIndex $HeNBIndex]
                         set result [mmeAccessList -HeNBIndex $HeNBIndex -tai $tai]
                         
                         print -info "More than one instance of MME found.."
                         print -info "Finding the MME index from debug door on which initialUE message is sent"
                         #set MMEIndex [expr [extractMMEIndexInS1Flex -op "extract" -HeNBIndex $HeNBIndex] -1]
                         if {$MultiS1Link != "yes"} {
                           set MMEIndex [expr [extractMMEIndexInS1Flex -op "extract" -HeNBIndex $HeNBIndex] -1]
                         } else {
                           set MMEIndex [extractMMEIndexInS1Flex -op "extract" -HeNBIndex $HeNBIndex]
                         }
                         
 
                         if {[llength $MMEIndex] > 1 || $MMEIndex < 0} {
                              print -fail "MMEIndex extraction failed, got $MMEIndex"
                              return -1
                         } else {
                              print -info "Extracted MMEIndex from debug door is $MMEIndex ..... "
                              print -info "Updating MMEIndex $MMEIndex in test map array"
                              #Updating MMEIndex in global array
                              if {$MultiS1Link != "yes"} {
                                 set paramList [list [list "MMEIndex" $MMEIndex]]
                              } else {
                                 set paramList [list [list "MMEIndex" $::ARR_LTE_TEST_PARAMS_MAP(MOID,$MMEIndex,MMEIndex)]]
                                 set tmpMMEIndex $::ARR_LTE_TEST_PARAMS_MAP(MOID,$MMEIndex,MMEIndex)
                                 set subR $::ARR_LTE_TEST_PARAMS_MAP(MOID,$MMEIndex,SubReg)
                                 set RegionNo $::ARR_LTE_TEST_PARAMS_MAP(SubReg,$subR,Region)
                                 set enbId [list [list "eNBId" $::ARR_LTE_TEST_PARAMS_MAP(R,$RegionNo,SubR,$subR,eNBId)]]
                                 updateLteParamData -HeNBIndex $HeNBIndex -UEIndex $UEIndex -paramList $enbId
                              }
                              updateLteParamData -HeNBIndex $HeNBIndex -UEIndex $UEIndex -paramList $paramList
                         }
                    }
               } else {
                    print -info "Using the MME index passed from script $MMEIndex"
               }

               
               
               #Introducing delay before verifying partial context on GW
               halt 0.5
               
               # to verify the eNBID received on the simulator we need to update the virtual eNB ID generated by the GW
               set result [updateValAndExecute "verifyUEContext -HeNBIndex HeNBIndex -MMEIndex MMEIndex \
                         -UEIndex UEIndex -state state -updateVar updateVar -eNBUES1APId eNBUES1APId"]
               if {$result < 0} {
                    print -fail "Updation of the vENBUES1APId failed cant continue"
                    return -1
               }
               # Update the enbuesapid and streamid to be used for verification
               foreach ele1 "eNBUES1APId streamId" ele2 "vENBUES1APId mStreamId" {
                    set $ele1 [getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "$ele2"]
               }
               
               #Unsetting the GUMMEI, as it is not expected IE in MME
               foreach param "GUMMEI" {
                    if {[info exists $param]} {
                         print -dbg "Not sending $param IE in the message, as it is not forwarded by GW"
                         unset -nocomplain $param
                    }
               }
          }
          "don'texpect" {
               set simType "MME"
               set initialUe [list $msgName ""]
               return [updateValAndExecute "sendOrVerifyS1APProcedure -msgName msgName -msgType msgType \
                         -operation operation -HeNBIndex HeNBIndex -MMEIndex MMEIndex -simType simType -msgList initialUe"]
          }
     }

     if {![info exists eNBUES1APId]} { set eNBUES1APId [getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "eNBUES1APId"]}
     set HeNBId [getFromTestMap -HeNBIndex $HeNBIndex -param "HeNBId"]
     set ueid   [getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "ueid"]
     
    set gwIp   [getDataFromConfigFile "henbSignalingIpaddress" $fgwNum]
    set gwPort [getDataFromConfigFile "henbSctp" $fgwNum] 

     foreach ele "TAI eCGI sTMSI GUMMEI CSGId" {
          if {[info exists $ele]} {
               if { [set $ele] != ""} {
                    if {$operation == "send"} {
                         set val [generateIEs -IEType "$ele" -paramIndices [set $ele] -HeNBIndex $HeNBIndex -MMEIndex $MMEIndex -UEIndex $UEIndex]
                         set ARR_INITIAL_UE($ele) $val
                         set $ele $val
                    } else {
                         set $ele $ARR_INITIAL_UE($ele)
                    }
               }
          }
     }
     
     if {$operation == "expect"} {
          unset -nocomplain ARR_INITIAL_UE
     }
     
     #The stream id cannot be zero as its used for S1 AP Non UE messages
     if {[info exists UEIndex] && ![info exists streamId]} {
          set streamId [expr $UEIndex + 1]
     }
     
     #Unsetting the variable, for testing missing mandatory IE
     foreach param "eNBUES1APId TAI eCGI RRCEstablishCause" {
          if {[set $param] == ""} {
               print -dbg "No $param IE generated with -$param <val> option. will not send $param IE in the message"
               unset -nocomplain $param
          }
     }
     
     if { [info exists CellAccessMode] } {
          set CellAccessMode [ string map "hybrid 0 open 1 closed 2" $CellAccessMode ]
     }
     
     if { [info exists RelayNodeInd] } {
          set RelayNodeInd   [ string map "true 0 false 1" $RelayNodeInd ]
     }
    
     if {[info exists tmpMMEIndex] && $MultiS1Link == "yes"} {
        set MMEIndex $tmpMMEIndex
     } 
     set initialUe [updateValAndExecute "constructS1Procedure -simType simType -msgName msgName -msgType msgType\
               -HeNBId HeNBId -ueid ueid -eNBUES1APId eNBUES1APId -CSGIdList CSGId -TAI TAI -eCGI eCGI  -gwIp gwIp -gwPort gwPort \
               -RRCEstablishCause RRCEstablishCause -STMSI sTMSI -GUMMEI GUMMEI -cellAccessMode CellAccessMode \
               -relayNodeInd RelayNodeInd -GwTransportAddr GwTransportAddr -streamId streamId -nasLen nasLen"]
     
     print -info "initialUE $initialUe"

     if {$execute == "no"} { return "$simType $initialUe"}
     
     return [updateValAndExecute "sendOrVerifyS1APProcedure -msgName msgName -msgType msgType \
               -operation operation -msgList initialUe -simType simType -enbID enbId \
               -HeNBIndex HeNBIndex -MMEIndex MMEIndex"]
}

proc downlinkNASTransport {args} {
     #-
     #- Procedure for sending/expecting Downlink NAS Transport message
     #-
     #- **** ServingPLMN of HO restriction list ****
     # (indexes are based on noOfPLMNs passed to this proc)
     #- Format 1: -servingPLMN  "0"" means, servingPLMN is 0th index broadcast PLMN from GW
     #- Format 2: -servingPLMN  "x"" means, servingPLMN is not matching(x) with broadcast PLMN from GW
     #-
     #- **** Equivalent PLMNs of HO restriction list ****
     #- (indexes are based on noOfPLMNs passed to this proc)
     #- Format 1: -equivalPLMNs "4,0:2,x" means,
     #- 4 PLMNs matching with Broadcast PLMNs from GW,0 is starting index of PLMNs:Append 2 PLMNs not matching(x) with Broadcast PLMNs from GW
     #-
     #- **** ForbiddenTAs of HO restriction list ****
     #- (indexes are based on noOfPLMNs and noOfHeBs passed to prepareLTETestParams)
     #- Format 1: -forbiddenTA "1,2,0:1000,x;x,1000,x"
     # 1st element is, 1st index PLMN matching with Broadcast PLMNs from GW,2 TACs matching with GW configuration,starting TAC from index 0:Appending 1000 TACs not matching with GW configuration;
     #-2nd element is, not matching(x) PLMN,having 1000 not matching TACs
     #-
     #- **** ForbiddenLAs of HO restriction list ****
     #- (indexes are based on noOfPLMNs passed to this proc)
     #- Format 1: -forbiddenLA "1,1000;x,1100" means,
     #- 1st element is, 1st index PLMN matching with Broadcast PLMNs from GW,1000 LACs;
     #- 2nd element is, not matching(x) PLMN,having 1100 LACs
     #-
     #- @return 0 on success, @return -1 on failure
     #-
     
     global ARR_HORes
     set nasPdu "05120358104f768062ccb90d9b98264bbfb2bd2010555d77652d0900ff493065c731ea4b86"
     parseArgs args \
               [list \
               [list operation           optional   "send|(don't|)expect"   "send"        	"send or expect option"] \
               [list fgwNum             optional   "string"         "0"             "The Broadcasted TAC to be used" ] \
               [list execute             optional   "boolean"       "yes"         	"To perform the operation or not. if no, will return the message"] \
               [list MMEIndex            optional   "numeric"       "__UN_DEFINED__"    "Index of MME whose values need to be retrieved" ] \
               [list UEIndex             mandatory  "numeric" 	    ""    		"Index of UE whose values need to be retrieved" ] \
               [list HeNBIndex           optional   "numeric"       "0"   		"Index of HeNB whose values need to be retrieved" ] \
               [list eNBUES1APId         optional   "string"        "__UN_DEFINED__"   	"eNB UE S1AP Id value" ] \
               [list MMEUES1APId         optional   "string"        "__UN_DEFINED__"   	"MME UE S1AP Id value" ] \
               [list SubscriberProfileId optional   "numeric"       "__UN_DEFINED__"   	"Subscriber Profile ID for RAT/Frequency priority" ] \
               [list servingPLMN         optional   "string"        "__UN_DEFINED__"   	"serving PLMN in Hand over Restriction List" ] \
               [list equivalPLMN         optional   "string"        "__UN_DEFINED__"   	"equivalent PLMNs in Hand over Restriction List" ] \
               [list forbiddenTA         optional   "string"        "__UN_DEFINED__"   	"forbidden TAs in Hand over Restriction List" ] \
               [list forbiddenLA         optional   "string"        "__UN_DEFINED__"   	"forbidden LAs in Hand over Restriction List" ] \
               [list forbiddenInterRATs  optional   "string"        "__UN_DEFINED__"   	"forbidden Inter RATs in Hand over Restriction List" ] \
               [list nasLen             optional    "string"         "$nasPdu"             "Nas Length to be used for the message"] \
               [list streamId            optional   "numeric"       "__UN_DEFINED__"   	"The streamid to be used for the UE transaction" ] \
               ]
     
     set msgName "downlink_nas_transport"
     set msgType "class2"

     if {![info exists MMEIndex]} {
          ##getFromTestMap returns MMEIndex incase of load balancing case of S1Flex scenario
          if {[getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "MMEIndex"] != -1} {
               set MMEIndex [getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "MMEIndex"]
               print -info "Using MMEIndex $MMEIndex among load balanced MMEs"
          } else {
               #Keeping default value of 0
               set MMEIndex "0"
               print -info "Using default MMEIndex $MMEIndex"
          }
     } else {
          print -info "Using MMEIndex $MMEIndex passed from script"
     }
     
     switch $operation {
          "send" {
               set simType "MME"
               
               # While sending the message to the HeNBGW we need to use the same streamId as the one on which initialUE was received
               if {![info exists streamId]} {
                    set streamId [getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "mStreamId"]
               }
               if {![info exists eNBUES1APId]} { set eNBUES1APId [getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "vENBUES1APId"]}
               if {![info exists MMEUES1APId]} { set MMEUES1APId [getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "MMEUES1APId"]}

               set MultiS1Link $::ARR_LTE_TEST_PARAMS(MultiS1Link)

               if {$MultiS1Link == "yes"} {
                  set globaleNBId [getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "eNBId"]
                  set eNBType [getFromTestMap -HeNBIndex $HeNBIndex -param "eNBType"]
                  if {! [ info exists eNBType ]} {
                     set eNBType "macro"
                  }
                  if {[info exists globaleNBId]} {
                     set globaleNBId "\{${eNBType}ENB_ID=$globaleNBId\}"
                  }
               }
          }
          "expect" {
               set simType "HeNB"
               # The verify the downlinkNASTransport message we first have to update the vMMEUES1APID
               #set result [updateValAndExecute "verifyUEContext -HeNBIndex HeNBIndex -MMEIndex MMEIndex \
               -UEIndex UEIndex -state state -updateVar updateVar -MMEUES1APId MMEUES1APId"]
               
               set MMEUES1APId [getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "vENBUES1APId"]
               #Expect the message on the same stream as the one on which the initialUE was sent
               if {[info exists UEIndex] && ![info exists streamId]} {
                    set streamId [expr $UEIndex + 1]
               }
               if {![info exists eNBUES1APId]} { set eNBUES1APId [getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "eNBUES1APId"]}
          }
          "don'texpect" {
               set simType "HeNB"
               set downlinkNas [list $msgName ""]
               return [updateValAndExecute "sendOrVerifyS1APProcedure -msgName msgName -msgType msgType \
                         -operation operation -HeNBIndex HeNBIndex -MMEIndex MMEIndex -simType simType -msgList downlinkNas"]
          }
     }
     
     set ueid   [getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "mmeUEId"]
     #set handOverRestcList ""
     
     #Unsetting the variable, for testing missing mandatory IE
     foreach param "MMEUES1APId eNBUES1APId" {
          if {[set $param] == ""} {
               print -dbg "No $param IE generated with -$param <val> option. will not send $param IE in the message"
               unset -nocomplain $param
          }
     }
     
     set gwIp   [getDataFromConfigFile "henbSignalingIpaddress" $fgwNum]
     set gwPort [getDataFromConfigFile "henbSctp" $fgwNum] 
     #Generate handOverRestcList only if all the subIEs indexes are passed to this proc, as this is optional IE
     if {[info exists servingPLMN] && [info exists equivalPLMN] && [info exists forbiddenTA] && [info exists forbiddenLA] && [info exists forbiddenInterRATs] } {
          
          if {$operation == "expect" && [array exists ARR_HORes]} {
               set handOverRestcList $ARR_HORes($HeNBIndex,$UEIndex)
          } else {
               set serPLMN [generateIEs -IEType "servingPLMN" -paramIndices $servingPLMN -HeNBIndex $HeNBIndex -MMEIndex $MMEIndex]
               set equiPLMN [generateIEs -IEType "equivalPLMN" -paramIndices $equivalPLMN -HeNBIndex $HeNBIndex -MMEIndex $MMEIndex]
               set forbiTA  [generateIEs -IEType "forbiddenTA" -paramIndices $forbiddenTA -HeNBIndex $HeNBIndex -MMEIndex $MMEIndex]
               set forbiLA  [generateIEs -IEType "forbiddenLA" -paramIndices $forbiddenLA -HeNBIndex $HeNBIndex -MMEIndex $MMEIndex]
               set handOverRestcList [list [concat $serPLMN $equiPLMN "forbiddenInterRATs=$forbiddenInterRATs" "forbiddenLAs=$forbiLA" "forbiddenTAs=$forbiTA"]]
               set ARR_HORes($HeNBIndex,$UEIndex) $handOverRestcList
          }
     }
                    	 
     set MMEId [getFromTestMap -MMEIndex $MMEIndex -param "MMEId"]

     set downlinkNas [updateValAndExecute "constructS1Procedure -simType simType -msgName msgName -msgType msgType\
               -ueid ueid -eNBUES1APId eNBUES1APId -MMEUES1APId MMEUES1APId -subProfileIdForRAT SubscriberProfileId\
               -handOverRestriction handOverRestcList -nasLen nasLen -streamId streamId -gwIp gwIp -gwPort gwPort -MMEId MMEId -globaleNBId globaleNBId"]
     
     print -info "downlinkNas $downlinkNas"
     
     if {$execute == "no"} { return "$simType $downlinkNas"}
     
     return [updateValAndExecute "sendOrVerifyS1APProcedure -msgName msgName -msgType msgType \
               -operation operation -msgList downlinkNas -simType simType \
               -HeNBIndex HeNBIndex -MMEIndex MMEIndex"]
}

proc uplinkNASTransport {args} {
     #-
     #- Procedure for sending/expecting Uplink NAS Transport message
     #-
     #- @return 0 on success, @return -1 on failure
     #-
     
     global ARR_UPLINK_NAS
     set nasPdu "05120358104f768062ccb90d9b98264bbfb2bd2010555d77652d0900ff493065c731ea4b86"
     parseArgs args \
               [list \
               [list operation          optional   "send|(don't|)expect"   "send"             "send or expect option"] \
               [list fgwNum             optional   "string"         "0"             "The Broadcasted TAC to be used" ] \
               [list execute            optional   "boolean"       "yes"              "To perform the operation or not. if no, will return the message"] \
               [list HeNBIndex          mandatory  "numeric"       "0"     	      "Index of HeNB whose values need to be retrieved" ] \
               [list UEIndex            mandatory  "numeric"       ""      	      "Index of UE whose values need to be retrieved" ] \
               [list MMEIndex           optional   "numeric"       "__UN_DEFINED__"   "Index of MME whose values need to be retrieved" ] \
               [list eNBUES1APId        optional   "string"        "__UN_DEFINED__"   "eNB UE S1AP Id value" ] \
               [list MMEUES1APId        optional   "string"        "__UN_DEFINED__"   "MME UE S1AP Id value" ] \
               [list TAI                optional   "string"        "0,0"              "TAI chosen from UE" ] \
               [list eCGI               optional   "string"        "0,0"              "e-UTRAN CGI chosen from UE" ] \
               [list GwTransportAddr    optional   "string"        "__UN_DEFINED__"   "GW Transport Layer Address value from UE" ] \
               [list nasLen             optional   "string"      "$nasPdu"             "Nas Length to be used for the message"] \
               [list streamId           optional   "numeric"       "__UN_DEFINED__"   "The streamid to be used for the UE transaction" ]\
               ]
     
     set msgName "uplink_nas_transport"
     set msgType "class2"
     
     if {![info exists MMEIndex]} {
          ##getFromTestMap returns MMEIndex incase of load balancing case of S1Flex scenario
          if {[getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "MMEIndex"] != -1} {
               set MMEIndex [getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "MMEIndex"]
               print -info "Using MMEIndex $MMEIndex among load balanced MMEs"
          } else {
               #Keeping default value of 0
               set MMEIndex "0"
               print -info "Using default MMEIndex $MMEIndex"
          }
     } else {
          print -info "Using MMEIndex $MMEIndex passed from script"
     }
     
     set HeNBId [getFromTestMap -HeNBIndex $HeNBIndex -param "HeNBId"]
     
     foreach ele "TAI eCGI" {
          if { [set $ele] != ""} {
               if {$operation == "send"} {
                    set val [generateIEs -IEType "$ele" -paramIndices [set $ele] -HeNBIndex $HeNBIndex -MMEIndex $MMEIndex -UEIndex $UEIndex]
                    set ARR_UPLINK_NAS($ele) $val
                    set $ele $val
               } else {
                    set $ele $ARR_UPLINK_NAS($ele)
               }
          }
     }
     
     if {$operation == "expect"} {
          unset -nocomplain ARR_UPLINK_NAS

          set MultiS1Link $::ARR_LTE_TEST_PARAMS(MultiS1Link)
          if {$MultiS1Link == "yes"} {
             set enbID [getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "eNBId"]
          }
     }
     
     switch -regexp $operation {
          "send" {
               set simType   "HeNB"
               #set paramList [list eNBUES1APId vENBUES1APId streamId mmeUEId]
               set paramList [list eNBUES1APId vENBUES1APId streamId ueid]
          }
          "expect" {
               set simType   "MME"
               set paramList [list vENBUES1APId MMEUES1APId mStreamId mmeUEId]
               
          }
     }
     
     #Update the dynamic variables
     foreach dynElement {eNBUES1APId MMEUES1APId streamId ueid} param $paramList {
          if {![info exists $dynElement]} {
               if {$param == "streamId"} {
                    set streamId [expr $UEIndex + 1]
                    continue
               }
               if {[catch {set $dynElement [getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "$param"]}]} {
                    print -abort "Failed to get the param $param"
                    return 1
               }
          }
     }
     
     #if the user passess an empty value for a mandatory argument then unset the variable
     foreach param "eNBUES1APId MMEUES1APId TAI eCGI"  {
          if {[set $param] == ""} {
               print -dbg "No $param IE generated with -$param <val> option. will not send $param IE in the message"
               unset -nocomplain $param
          }
     }
     
     set gwIp   [getDataFromConfigFile "henbSignalingIpaddress" $fgwNum]
     set gwPort [getDataFromConfigFile "henbSctp" $fgwNum] 
    
     set uplinkNas [updateValAndExecute "constructS1Procedure -simType simType -msgName msgName -msgType msgType\
               -HeNBId HeNBId -ueid ueid -eNBUES1APId eNBUES1APId -MMEUES1APId MMEUES1APId -TAI TAI -eCGI eCGI \
               -GwTransportAddr GwTransportAddr -nasLen nasLen -streamId streamId -gwIp gwIp -gwPort gwPort"]
     
     print -info "uplinkNas $uplinkNas"
     
     if {$execute == "no"} { return "$simType $uplinkNas"}
     
     return [updateValAndExecute "sendOrVerifyS1APProcedure -msgName msgName -msgType msgType \
               -operation operation -msgList uplinkNas -simType simType -enbID enbID \
               -HeNBIndex HeNBIndex -MMEIndex MMEIndex"]
}

proc NASNonDeliveryInd {args} {
     #-
     #- Procedure for sending/expecting NAS Non Delivery Indication message
     #-
     #- @return 0 on success, @return -1 on failure
     #-
     
     set nasPdu "05120358104f768062ccb90d9b98264bbfb2bd2010555d77652d0900ff493065c731ea4b86"
     parseArgs args \
               [list \
               [list operation          optional   "send|(don't|)expect" "send"    "send or expect option"] \
               [list execute            optional   "boolean"     "yes"         	   "To perform the operation or not. if no, will return the message"] \
               [list HeNBIndex          mandatory  "numeric"     "0"               "Index of HeNB whose values need to be retrieved" ] \
               [list UEIndex            mandatory  "numeric"     ""                "Index of UE whose values need to be retrieved" ] \
               [list MMEIndex           optional   "numeric"     "__UN_DEFINED__"  "Index of MME whose values need to be retrieved" ] \
               [list eNBUES1APId        optional   "string"      "__UN_DEFINED__"  "eNB UE S1AP Id value" ] \
               [list MMEUES1APId        optional   "string"      "__UN_DEFINED__"  "MME UE S1AP Id value" ] \
               [list causeType          optional   "string"      "misc"            "cause Type value from heNB" ] \
               [list cause              optional   "string"      "unspecified"     "cause value from heNB" ] \
               [list nasLen             optional   "numeric"     "$nasPdu"    "Nas Length to be used for the message"] \
               ]
     set msgName "nas_non_delivery_indication"
     set msgType "class2"
     
     if {![info exists MMEIndex]} {
          ##getFromTestMap returns MMEIndex incase of load balancing case of S1Flex scenario
          if {[getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "MMEIndex"] != -1} {
               set MMEIndex [getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "MMEIndex"]
               print -info "Using MMEIndex $MMEIndex among load balanced MMEs"
          } else {
               #Keeping default value of 0
               set MMEIndex "0"
               print -info "Using default MMEIndex $MMEIndex"
          }
     } else {
          print -info "Using MMEIndex $MMEIndex passed from script"
     }
     
     set HeNBId [getFromTestMap -HeNBIndex $HeNBIndex -param "HeNBId"]
     
     switch -regexp $operation {
          "send" {
               set simType   "HeNB"
               #set paramList [list eNBUES1APId vENBUES1APId streamId mmeUEId]
               set paramList [list eNBUES1APId vENBUES1APId streamId ueid]
          }
          "expect" {
               set simType   "MME"
               set paramList [list vENBUES1APId MMEUES1APId mStreamId mmeUEId]
          }

          set MultiS1Link $::ARR_LTE_TEST_PARAMS(MultiS1Link)
                    
	  if {$MultiS1Link == "yes"} {
             set enbID [getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "eNBId"]
          }
     }
     
     #Update the dynamic variables
     foreach dynElement {eNBUES1APId MMEUES1APId streamId ueid} param $paramList {
          if {![info exists $dynElement]} {
               if {$param == "streamId"} {
                    set streamId [expr $UEIndex + 1]
                    continue
               }
               if {[catch {set $dynElement [getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "$param"]}]} {
                    print -abort "Failed to get the param $param"
                    return 1
               }
          }
     }
     
     #if the user passess an empty value for a mandatory argument then unset the variable
     foreach var [list eNBUES1APId MMEUES1APId cause causeType] {
          if {[info exists $var]} {
               if {[set $var] == ""} {
                    unset -nocomplain $var
               }
          }
     }

     set gwIp   [getDataFromConfigFile "henbSignalingIpaddress" 0 ]
     set gwPort [getDataFromConfigFile "henbSctp" 0 ]

     if {[info exists causeType] && [info exists cause]} {
        set causeVal "\{$causeType=$cause\}"
     }

     set nasNonDelInd [updateValAndExecute "constructS1Procedure -simType simType -msgName msgName -msgType msgType \
               -HeNBId HeNBId -ueid ueid -eNBUES1APId eNBUES1APId -MMEUES1APId MMEUES1APId \
               -cause causeVal -streamId streamId -nasLen nasLen -gwIp gwIp -gwPort gwPort"]
     
     print -info "nasNonDeliveryInd $nasNonDelInd"
     
     if {$execute == "no"} { return "$simType $nasNonDelInd"}
     
     return [updateValAndExecute "sendOrVerifyS1APProcedure -msgName msgName -msgType msgType \
               -operation operation -msgList nasNonDelInd -simType simType -enbID enbID \
               -HeNBIndex HeNBIndex -MMEIndex MMEIndex"]
}

proc UEContextReleaseReq {args} {
     #-
     #- Procedure for sending/expecting UE context Release Request message
     #-
     #- @return 0 on success, @return -1 on failure
     #-
     
     parseArgs args \
               [list \
               [list operation          optional   "send|(don't|)expect"  "send"             "send or expect option"] \
               [list execute            optional   "boolean"              "yes"              "To perform the operation or not. if no, will return the message"] \
               [list HeNBIndex          optional   "numeric"              "0"                "Index of HeNB whose values need to be retrieved" ] \
               [list UEIndex            optional   "numeric"              ""                 "Index of UE whose values need to be retrieved" ] \
               [list MMEIndex           optional   "numeric"              "__UN_DEFINED__"   "Index of MME whose values need to be retrieved" ] \
               [list eNBUES1APId        optional   "string"               "__UN_DEFINED__"   "eNB UE S1AP Id value" ] \
               [list MMEUES1APId        optional   "string"               "__UN_DEFINED__"   "MME UE S1AP Id value" ] \
               [list causeType          optional   "string"               "misc"             "cause Type value from heNB" ] \
               [list cause              optional   "string"               "unspecified"      "cause value from heNB" ] \
               [list gwContextRelInd    optional   "string"               "__UN_DEFINED__"   "Gateway Context Release Indication value from heNB" ] \
               [list streamId           optional   "string"              "__UN_DEFINED__"   "The streamid to be used for the UE transaction" ]\
               ]
     
     set msgName "ue_context_release_request"
     set msgType "class2"
     
     if {![info exists MMEIndex]} {
          ##getFromTestMap returns MMEIndex incase of load balancing case of S1Flex scenario
          if {[getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "MMEIndex"] != -1} {
               set MMEIndex [getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "MMEIndex"]
               print -info "Using MMEIndex $MMEIndex among load balanced MMEs"
          } else {
               #Keeping default value of 0
               set MMEIndex "0"
               print -info "Using default MMEIndex $MMEIndex"
          }
     } else {
          print -info "Using MMEIndex $MMEIndex passed from script"
     }
     
     #if {![info exists eNBUES1APId]} { set eNBUES1APId [getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "eNBUES1APId"]}
     #if {![info exists MMEUES1APId]} { set MMEUES1APId [getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "MMEUES1APId"]}
     set HeNBId [getFromTestMap -HeNBIndex $HeNBIndex -param "HeNBId"]
     
     #The stream id cannot be zero as its used for S1 AP Non UE messages
     #if {[info exists UEIndex] && ![info exists streamId]} {
     #     set streamId [expr $UEIndex + 1]
     #}

     set MultiS1Link $::ARR_LTE_TEST_PARAMS(MultiS1Link)

     if {$MultiS1Link == "yes"} {
        set enbID [getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "eNBId"]
     }
     
     switch -regexp $operation {
          "send" {
               set simType "HeNB"
               set paramList [list eNBUES1APId vENBUES1APId streamId ueid]
               
          }
          "expect" {
               set simType "MME"
               set paramList [list vENBUES1APId MMEUES1APId mStreamId mmeUEId]
          }
     }
     
     #Update the dynamic variables
     foreach dynElement {eNBUES1APId MMEUES1APId streamId ueid} param $paramList {
          if {![info exists $dynElement]} {
               if {$param == "streamId"} {
                    set streamId [expr $UEIndex + 1]
                    continue
               }
               if {[catch {set $dynElement [getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "$param"]}]} {
                    print -abort "Failed to get the param $param"
                    return 1
               }
          }
     }
     
     #if the user passess an empty value for a mandatory argument then unset the variable
     foreach var [list eNBUES1APId MMEUES1APId cause causeType] {
          if {[info exists $var]} {
               if {[set $var] == ""} {
                    unset -nocomplain $var
               }
          }
     }

     
     if {[info exists causeType] && [info exists cause]} {
        set causeVal "\{$causeType=$cause\}"
     }

     set gwIp   [getDataFromConfigFile "henbSignalingIpaddress" 0 ]
     set gwPort [getDataFromConfigFile "henbSctp" 0 ]
     set HeNBId [getFromTestMap -HeNBIndex $HeNBIndex -param "HeNBId"]
     
     set ueContextRelReq [updateValAndExecute "constructS1Procedure -simType simType -HeNBId HeNBId -msgName msgName -msgType msgType \
               -HeNBId HeNBId -ueid ueid -eNBUES1APId eNBUES1APId -MMEUES1APId MMEUES1APId \
               -cause causeVal -gwContextRelInd gwContextRelInd -streamId streamId -gwIp gwIp -gwPort gwPort"]
     
     print -info "UEContextReleaseRequest $ueContextRelReq"
     
     if {$execute == "no"} { return "$simType $ueContextRelReq"}
     
     return [updateValAndExecute "sendOrVerifyS1APProcedure -HeNBId HeNBId -msgName msgName -msgType msgType \
               -operation operation -msgList ueContextRelReq -simType simType -enbID enbID \
               -HeNBIndex HeNBIndex -MMEIndex MMEIndex"]
}

proc UEContextRelease {args} {
     #-
     #- Procedure for sending/expecting UE context Release/UE context Release Complete message
     #-
     #- @return 0 on success, @return -1 on failure
     #-
     
     set validS1Msg        "request|response"
     
     parseArgs args \
               [list \
               [list UEIndex            mandatory  "numeric"              ""                 "Index of UE whose values need to be retrieved" ] \
               [list msg                optional   "$validS1Msg"          "request"          "The message to be sent" ] \
               [list operation          optional   "send|(don't|)expect"  "send"             "send or expect option"] \
               [list execute            optional   "boolean"              "yes"              "To perform the operation or not. if no, will return the message"] \
               [list MMEIndex           optional   "numeric"              "__UN_DEFINED__"   "Index of MME whose values need to be retrieved" ] \
               [list HeNBIndex          optional   "numeric"              "0"                "Index of HeNB whose values need to be retrieved" ] \
               [list eNBUES1APId        optional   "string"               "__UN_DEFINED__"   "eNB UE S1AP Id value" ] \
               [list MMEUES1APId        optional   "string"               "__UN_DEFINED__"   "MME UE S1AP Id value" ] \
               [list uES1APIDs          optional   "string"               "__UN_DEFINED__"   "UE S1AP Id value" ] \
               [list causeType          optional   "string"               "misc"             "cause Type value from heNB" ] \
               [list cause              optional   "string"               "unspecified"      "cause value from heNB" ] \
               [list streamId           optional   "string"               "__UN_DEFINED__"   "The streamid to be used for the UE transaction" ]\
               ]
     
     set msgName [string map "request ue_context_release_command response ue_context_release_complete" $msg]
     set msgType "class1"
     
     if {![info exists MMEIndex]} {
          ##getFromTestMap returns MMEIndex incase of load balancing case of S1Flex scenario
          if {[getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "MMEIndex"] != -1} {
               set MMEIndex [getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "MMEIndex"]
               print -info "Using MMEIndex $MMEIndex among load balanced MMEs"
          } else {
               #Keeping default value of 0
               set MMEIndex "0"
               print -info "Using default MMEIndex $MMEIndex"
          }
     } else {
          print -info "Using MMEIndex $MMEIndex passed from script"
     }
     
     #if {![info exists eNBUES1APId]} { set eNBUES1APId [getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "eNBUES1APId"]}
     #set ueid   [getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "ueid"]
     
     #if {[info exists UEIndex] && ![info exists streamId]} {
     #     set streamId [expr $UEIndex + 1]
     #}
    
     set MultiS1Link $::ARR_LTE_TEST_PARAMS(MultiS1Link)

     if {$MultiS1Link == "yes"} {
        set enbID [getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "eNBId"]
     }   
 
     switch -regexp $operation {
          "send" {
               switch -regexp $msg {
                    "request" {
                         set simType "MME"
                         set paramList [list vENBUES1APId MMEUES1APId mStreamId mmeUEId]

                         if {$MultiS1Link == "yes"} {
                            set eNBType [getFromTestMap -HeNBIndex $HeNBIndex -param "eNBType"]
                            if {! [ info exists eNBType ]} {
                               set eNBType "macro"
                            }
                            if {[info exists enbID]} {
                               set globaleNBId "\{${eNBType}ENB_ID=$enbID\}"
                            }
                         }
                         
                    }
                    "response" {
                         #MMEUES1APId is part of only UE Context rel response msg
                         #if {![info exists MMEUES1APId]} { set MMEUES1APId [getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "MMEUES1APId"]}
                         set simType "HeNB"
                         set HeNBId [getFromTestMap -HeNBIndex $HeNBIndex -param "HeNBId"]
                         set paramList [list eNBUES1APId vENBUES1APId streamId ueid]
                    }
               }
          }
          "expect" {
               switch -regexp $msg {
                    "request" {
                         set simType "HeNB"
                         set HeNBId [getFromTestMap -HeNBIndex $HeNBIndex -param "HeNBId"]
                         set paramList [list eNBUES1APId vENBUES1APId streamId ueid]
                    }
                    "response" {
                         #MMEUES1APId is part of only UE Context rel response msg
                         #if {![info exists MMEUES1APId]} { set MMEUES1APId [getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "MMEUES1APId"]}
                         set simType "MME"
                         set paramList [list vENBUES1APId MMEUES1APId mStreamId mmeUEId]
                    }
               }
          }
     }
     
     #Update the dynamic variables
     foreach dynElement {eNBUES1APId MMEUES1APId streamId ueid} param $paramList {
          if {![info exists $dynElement]} {
               if {$param == "streamId"} {
                    set streamId [expr $UEIndex + 1]
                    continue
               }
               if {[catch {set $dynElement [getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "$param"]}]} {
                    print -abort "Failed to get the param $param"
                    return 1
               }
          }
     }
     
     #if the user passess an empty value for a mandatory argument  then unset the variable
     #if the user passess an empty value for a eNBUES1APId  then unset the variable
     foreach var [list eNBUES1APId MMEUES1APId cause causeType] {
          if {[info exists $var]} {
               if {[set $var] == ""} {
                    unset -nocomplain $var
               }
          }
     }

     if {[info exists causeType] && [info exists cause]} {
        set causeVal "\{$causeType=$cause\}"
     }

     set gwIp   [getDataFromConfigFile "henbSignalingIpaddress" 0 ]
     set gwPort [getDataFromConfigFile "henbSctp" 0 ]
     set HeNBId [getFromTestMap -HeNBIndex $HeNBIndex -param "HeNBId"]
     set MMEId  [getFromTestMap -MMEIndex $MMEIndex -param "MMEId"]

     switch -regexp $msg {
          "request" {
             if {[info exists eNBUES1APId] && [info exists MMEUES1APId]} {
                set uES1APIDs "\{uE_S1AP_ID_pair=\{eNB_UE_S1AP_ID=$eNBUES1APId mME_UE_S1AP_ID=$MMEUES1APId\}\}"
             } elseif {![info exists eNBUES1APId] && [info exists MMEUES1APId]} {
                set uES1APIDs "\{mME_UE_S1AP_ID=$MMEUES1APId\}"
             }
             set ueContextRel [updateValAndExecute "constructS1Procedure -simType simType -msgName msgName -msgType msgType \
               -MMEId MMEId -ueid ueid -uES1APIDs uES1APIDs -globaleNBId globaleNBId \
               -cause causeVal -streamId streamId -gwIp gwIp -gwPort gwPort"]
           }
           "response" {
             set ueContextRel [updateValAndExecute "constructS1Procedure -simType simType -msgName msgName -msgType msgType \
               -HeNBId HeNBId -ueid ueid -eNBUES1APId eNBUES1APId -MMEUES1APId MMEUES1APId \
               -streamId streamId -gwIp gwIp -gwPort gwPort"]
           }
    }
     
    print -info "UEContextRelease $ueContextRel"
     
    if {$execute == "no"} { return "$simType $ueContextRel"}
     
      return [updateValAndExecute "sendOrVerifyS1APProcedure -msgName msgName -msgType msgType \
               -operation operation -msgList ueContextRel -simType simType -enbID enbID \
               -HeNBIndex HeNBIndex -MMEIndex MMEIndex"]
}

proc initialContext {args} {
     #-
     #- procedure to construct an initial context request
     #-
     #-  ------ INITIAL CONTEXT SETUP REQUEST ------
     #-
     #-  Message Type				M
     #-  MME UE S1AP ID 			M
     #-  eNB UE S1AP ID 			M
     #-  UE Aggregate Maximum Bit Rate		M
     #-  E-RAB to Be Setup List
     #-    >E-RAB to Be Setup Item IEs
     #-      >>E-RAB ID				M
     #-      >>E-RAB Level QoS Paramet		M
     #-      >>Transport Layer Address		M
     #-      >>GTP-TEID				M
     #-      >>NAS-PDU				O
     #-      >>Correlation ID			O
     #-  UE Security Capabilities		M
     #-  Security Key				M
     #-  Trace Activation			O
     #-  Handover Restriction List		O
     #-  UE Radio Capability			O
     #-  Subscriber Profile ID for RAT/Frequency priority	O
     #-  CS Fallback Indicator			O
     #-  SRVCC Operation Possible		O
     #-  CSG Membership Status			O
     #-  Registered LAI				O
     #-  GUMMEI					O
     #-  MME UE S1AP ID 2			O
     #-
     #- ------ INITIAL CONTEXT SETUP RESPONSE ------
     #-
     #-   Message Type				M
     #-   MME UE S1AP ID 			M
     #-   eNB UE S1AP ID 			M
     #-   E-RAB Setup List
     #-     > E-RAB Setup Item Ies
     #-       >>E-RAB ID			M
     #-       >>Transport Layer Address		M
     #-       >>GTP-TEID			M
     #-   E-RAB Failed to Setup List		O
     #-   Criticality Diagnostics		O
     #-
     #- ------ INITIAL CONTEXT SETUP RESPONSE ------
     #-
     #-   Message Type				M
     #-   MME UE S1AP ID 			M
     #-   eNB UE S1AP ID 			M
     #-   Cause					M
     #-   Criticality Diagnostics		O
     #-
     #- -------------- IE GENERATION ------------------
     #- * eRAB
     #- 1. eRAB {noOfErabs}   : Will create 2 eRABS
     #- 2. eRAB {noOfErabs,startERAB,e_RAB_ID,eRABQos,transAddr,gtpTeid,nas,corrId}
     #-      eRAB is a structure of all the All IEs
     #-      To enable the IE just make that param as 1; 0 would disable it
     #-      ex. To create 2 eRABs such that only e_RAB_ID,transAddr and gtpTeid are part of the container
     #-         eRAB 2,0,1,0,1,1,0,0
     #-
     #- * UESecCapability
     #-  UESecCapability IE is made up of encryptionAlgorithms and integrityProtectionAlgorithms
     #-  To create the IE pass 1; 0 would disable it
     #-     UESecCapability 1,1
     #-       Will create IE having both encryptionAlgorithms and integrityProtectionAlgorithms
     #-       The values for the above IEs are randomly selected from a list of supported ones
     #-
     #- * UEAggrBitRate
     #-   UEAggrBitRate IE is made up of maxBitRateDl and maxBitRateDl
     #-   To create the IE pass 1; 0 would disable it
     #-      UEAggrBitRate 1,1
     #-       Will create IE having both maxBitRateDl and maxBitRateDl
     #-       The values for these IEs are genearted in a predective random method
     #-
     #-@return 0 on success, @return -1 on failure
     #-
     
     global ARR_INIT_CONTEXT
     set validMsg          "request|response|failure"
     set validTraceDepth   "minimum|medium|maximum|MinimumWithoutVendorSpecificExtension|MediumWithoutVendorSpecificExtension|MaximumWithoutVendorSpecificExtension"
     set validCSFB         "cs_fallback_required|cs_fallback_high_priority"
     set validSrvccOp      "possible"
     set validCsgMemStat   "member|not_member"
     set secKey            "0e47818519f76cc13d8414ba08e0b48dc7405d46890334860a9c5083baf1446e"
     #set traceIp           [::ip::contract [getDataFromConfigFile "henbBearerIpaddress" 0]]
     set traceIp           "01010101"
     set defaultCause      "message_not_compatible_with_receiver_state"
     
     parseArgs args \
               [list \
               [list msg                  optional   "$validMsg"      "request"           "The message to be sent" ] \
               [list operation            optional   "send|(don't|)expect" "send"        "send or expect option"] \
               [list fgwNum               optional   "string"         "0"             "The Broadcasted TAC to be used" ] \
               [list execute              optional   "boolean"        "yes"               "To perform the operation or not. if no, will return the message"] \
               [list HeNBIndex            mandatory  "numeric"        ""                  "Index of HeNB whose values need to be retrieved" ] \
               [list UEIndex              mandatory  "numeric"        ""                  "Index of UE whose values need to be retrieved" ] \
               [list MMEIndex             optional   "numeric"        "__UN_DEFINED__"   "Index of MME whose values need to be retrieved" ] \
               [list eNBUES1APId          optional   "string"         "__UN_DEFINED__"    "eNB UE S1AP Id value" ] \
               [list MMEUES1APId          optional   "string"         "__UN_DEFINED__"    "MME UE S1AP Id value" ] \
               [list causeType            optional   "string"         "protocol"          "Identifies the cause choice group"] \
               [list cause                optional   "string"         "$defaultCause"     "Identifies the cause value"] \
               [list criticalityDiag      optional   "string"         "__UN_DEFINED__"    "The critical diag to be enabled or not"] \
               [list procedureCode        optional   "string"         "__UN_DEFINED__"    "The procedure code to be used diag"] \
               [list triggerMsg           optional   "string"         "__UN_DEFINED__"    "Identifies the triggering message"] \
               [list procedureCriticality optional   "string"         "__UN_DEFINED__"    "Identifies the procedure Criticality"] \
               [list IECriticality        optional   "string"         "__UN_DEFINED__"    "Identifies the IE Criticality list"] \
               [list IEId                 optional   "numeric"        "__UN_DEFINED__"    "Identifies the IE Id list"] \
               [list typeOfError          optional   "string"         "__UN_DEFINED__"    "Identifies the type of error list"] \
               [list isHeNB               optional   "boolean"        "__UN_DEFINED__"    "Identifies the type of eNB"] \
               ]
     
     set msgName [string map "\
               request    initial_context_setup_request \
               response   initial_context_setup_response \
               failure    initial_context_setup_failure" \
               $msg]
     set msgType "class1"
     
     if {![info exists MMEIndex]} {
          ##getFromTestMap returns MMEIndex incase of load balancing case of S1Flex scenario
          if {[getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "MMEIndex"] != -1} {
               set MMEIndex [getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "MMEIndex"]
               print -info "Using MMEIndex $MMEIndex among load balanced MMEs"
          } else {
               #Keeping default value of 0
               set MMEIndex "0"
               print -info "Using default MMEIndex $MMEIndex"
          }
     } else {
          print -info "Using MMEIndex $MMEIndex passed from script"
     }
     
     # For a Macro eNB the HeNBGW should not forward the MMEUES1APID2 and GUMMEI IE in the Initial Context Setup request
     if {[info exists ::IS_HENB] && ![info exists isHeNB]} {
          set isHeNB 1
     } else {
          set isHeNB 0
     }

     set gwIp   [getDataFromConfigFile "henbSignalingIpaddress" $fgwNum] 

     set MultiS1Link $::ARR_LTE_TEST_PARAMS(MultiS1Link)

     if {$MultiS1Link == "yes"} {
        set enbID [getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "eNBId"]
     }  

     switch -regexp $msg {
          "request"  {
               set gwIp   [getDataFromConfigFile "mmeSignalingIpaddress" $fgwNum]
               set mandatoryIEs "MMEUES1APId eNBUES1APId UEAggMaxBitRate ERABs UESecurityCap securityKey"
               parseArgs args \
                         [list \
                         [list UEAggMaxBitRate      optional   "string"           "1,1"               "The UE aggregate max bit rate" ] \
                         [list ERABs                optional   "string"           "1"                 "The number of E-RAB to be setup" ] \
                         [list UESecurityCap        optional   "string"           "1,1"               "The UE security capability to be used" ] \
                         [list securityKey          optional   "string"           "$secKey"           "The security key to be used" ] \
                         [list traceActivation      optional   "boolean"          "__UN_DEFINED__"    "The trace activation to be enabled" ] \
                         [list eURTANTraceId        optional   "string"           "[random 99999999]" "The trace id to be enabled" ] \
                         [list intToTrace           optional   "string"           "50"                "The interface to be traced" ] \
                         [list traceDepth           optional   "$validTraceDepth" "maximum"           "The trace depth to be used" ] \
                         [list traceIp              optional   "ip"               "$traceIp"          "The trace ip to be used" ] \
                         [list MDTConfig            optional   "string"           "__UN_DEFINED__"    "The MDT configuration for trace" ] \
                         [list servingPLMN          optional   "string"           "__UN_DEFINED__"    "serving PLMN in Hand over Restriction List" ] \
                         [list equivalPLMN          optional   "string"           "__UN_DEFINED__"    "equivalent PLMNs in Hand over Restriction List" ] \
                         [list forbiddenTA          optional   "string"           "__UN_DEFINED__"    "forbidden TAs in Hand over Restriction List" ] \
                         [list forbiddenLA          optional   "string"           "__UN_DEFINED__"    "forbidden LAs in Hand over Restriction List" ] \
                         [list forbiddenInterRATs   optional   "string"           "__UN_DEFINED__"    "forbidden Inter RATs in Hand over Restriction List" ] \
                         [list UERadioCapability    optional   "string"           "__UN_DEFINED__"    "Defines the UE Radio capability" ] \
                         [list SubscriberProfileId  optional   "numeric"          "__UN_DEFINED__"    "Defines the subscriber profile for RAT/Freq priority" ] \
                         [list CSFallbackInd        optional   "$validCSFB"       "__UN_DEFINED__"    "Defines the CS fallback indicator" ] \
                         [list SRVCCOperation       optional   "$validSrvccOp"    "__UN_DEFINED__"    "Defines the SRVCC operation" ] \
                         [list CSGMembership        optional   "$validCsgMemStat" "__UN_DEFINED__"    "Defines the CSG membership" ] \
                         [list LAI                  optional   "string"           "__UN_DEFINED__"    "Defines the registered LAI" ] \
                         [list GUMMEI               optional   "string"           "__UN_DEFINED__"    "Defines the registered LAI" ] \
                         [list MMEUES1APId2         optional   "string"           "__UN_DEFINED__"    "Defines the MMEUES1APId assigned by MME" ] \
                         [list streamId             optional   "numeric"          "__UN_DEFINED__"    "Defines the streamId assigned by MME" ] \
                         ]
               
               #Update the dynamic variables
               if {$operation == "send"} {
                    set simType "MME"
                    set paramList [list vENBUES1APId MMEUES1APId mStreamId mmeUEId]
               } else {
                    set simType "HeNB"
                    set paramList [list eNBUES1APId vENBUES1APId streamId mmeUEId]
                    
                    if {$isHeNB} {
                         # SRS-HeNBGW-CP-414
                         # With this requirement in mind the HeNBGw would send GUMMEI IE irrespective of the fact it was received from MME or not
                         # The value of which would be the first entities from RAT0
                         set GUMMEI "0,0,0,0"
                         set MMEUES1APId2 [getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "MMEUES1APId"]
                    }
               }
               
               #For IEs which itself is a structure, construct it only if the user has defined the variable
               foreach structIE [list UEAggMaxBitRate ERABs UESecurityCap GUMMEI LAI traceActivation] {
                    if {[info exists $structIE]} {
                         if {[set $structIE] != ""} {
                              switch -regexp $structIE {
                                   "UEAggMaxBitRate" {set UEAggMaxBitRate [generateIEs -IEType "UEAggrBitRate" -paramIndices $UEAggMaxBitRate -HeNBIndex $HeNBIndex -MMEIndex $MMEIndex]}
                                   "ERABs"           {set ERABs           [generateIEs -IEType "ERABs" -paramIndices $ERABs -HeNBIndex $HeNBIndex -MMEIndex $MMEIndex]}
                                   "UESecurityCap"   {set UESecurityCap   [generateIEs -IEType "UESecCapability" -paramIndices $UESecurityCap -HeNBIndex $HeNBIndex -MMEIndex $MMEIndex]}
                                   "LAI"             {set LAI             [generateIEs -IEType "LAI" -paramIndices $LAI  -HeNBIndex $HeNBIndex]                         }
                                   "traceActivation" {
                                        foreach simVar [list e_UTRAN_Trace_ID interfacesToTrace traceCollectionEntityIPAddress traceDepth mDTConfiguration_ext] \
                                                  procVar [list eURTANTraceId intToTrace traceIp traceDepth MDTConfig] {
                                                       if {[info exists $procVar]} {
                                                            if {$procVar == "MDTConfig"} {
                                                                 set MDTConfig [generateIEs -IEType "MDTConfig" -paramIndices "" -HeNBIndex $HeNBIndex -MMEIndex $MMEIndex -UEIndex $UEIndex]
                                                            }
                                                            append TraceActivation "$simVar=[set $procVar] "
                                                       }
                                                  }
                                        set TraceActivation "{$TraceActivation}"
                                   }
                                   "GUMMEI"          {
                                        if {$simType == "MME"} {
                                             set GUMMEI          [generateIEs -IEType "GUMMEI" -paramIndices $GUMMEI -HeNBIndex $HeNBIndex -MMEIndex $MMEIndex]
                                        } else {
                                             set gPlmn ""
                                             foreach \
                                                       gMcc [getFromTestMap -MMEIndex $MMEIndex -GUMMEIIndex 0 -param "MCC"] \
                                                       gMnc [getFromTestMap -MMEIndex $MMEIndex -GUMMEIIndex 0 -param "MNC"] {
                                                            lappend gPlmn [createLteIdentifier -identifier PLMNId -MCC $gMcc -MNC $gMnc]
                                                       }
                                             foreach {mc2 mc1 mn1 mc3 mn3 mn2} [split [lindex [lsort $gPlmn] 0] ""] {break}
                                             set gMcc   "${mc1}${mc2}${mc3}"
                                             set gMnc   "${mn1}${mn2}${mn3}"
                                             set gMmec  [lindex [lsort [getFromTestMap -MMEIndex $MMEIndex -GUMMEIIndex 0 -param "MMECode"]] 0]
                                             set gMmegi [lindex [lsort [getFromTestMap -MMEIndex $MMEIndex -GUMMEIIndex 0 -param "MMEGroupId"]] 0]
                                             set GUMMEI "{mME_Code=$gMmec mME_Group_ID=$gMmegi pLMN_Identity={MCC=$gMcc MNC=$gMnc}}"
                                             print -debug "Using GUMMEI: $GUMMEI for verification of HeNB"
                                        }
                                   }
                              }
                         }
                    }
               }
               #Construct the handover restriction list
               if {[info exists servingPLMN] && [info exists equivalPLMN] && [info exists forbiddenTA] && [info exists forbiddenLA] && [info exists forbiddenInterRATs] } {
                    set serPLMN  [generateIEs -IEType "servingPLMN" -paramIndices $servingPLMN -HeNBIndex $HeNBIndex -MMEIndex $MMEIndex]
                    set equiPLMN [generateIEs -IEType "equivalPLMN" -paramIndices $equivalPLMN -HeNBIndex $HeNBIndex -MMEIndex $MMEIndex]
                    set forbiTA  [generateIEs -IEType "forbiddenTA" -paramIndices $forbiddenTA -HeNBIndex $HeNBIndex -MMEIndex $MMEIndex]
                    set forbiLA  [generateIEs -IEType "forbiddenLA" -paramIndices $forbiddenLA -HeNBIndex $HeNBIndex -MMEIndex $MMEIndex]
                    set handOverRestriction "{[concat $serPLMN $equiPLMN forbiddenInterRATs=$forbiddenInterRATs forbiddenLAs=$forbiLA forbiddenTAs=$forbiTA]}"
               }

               if {$MultiS1Link == "yes"} {
                  set eNBType [getFromTestMap -HeNBIndex $HeNBIndex -param "eNBType"]
                  if {! [ info exists eNBType ]} {
                     set eNBType "macro"
                  }
                  if {[info exists enbID]} {
                     set globaleNBId "\{${eNBType}ENB_ID=$enbID\}"
                  }

               }
          }
          "response|failure" {
               if {$msg == "response"} {
                    set mandatoryIEs "MMEUES1APId eNBUES1APId ERABs"
                    parseArgs args \
                              [list \
                              [list ERABs                optional   "string"     "1,0"               "The number of E-RAB sucessfully setup" ] \
                              [list eRABsFailedToSetup   optional   "string"     "__UN_DEFINED__"    "The number of E-RAB failed to setup" ] \
                              ]
                    # If the value of ERABs is not null then generate it
                    set HeNBId [getFromTestMap -HeNBIndex $HeNBIndex -param "HeNBId"]
                    if {$ERABs != ""} {
                         set paramIndices ""
                         foreach erab [split $ERABs ";"] {
                              foreach {noOfeRabs starteRabId} [split $erab ,] {break}
                              set eRabId       1 ;#include IE
                              set eRabQos      0 ;#exclude IE
                              set address      1 ;#include IE
                              set gtpTeid      1 ;#include IE
                              set nas          0 ;#exclude IE
                              set corrId       0 ;#exclude IE
                              lappend paramIndices "$noOfeRabs,$starteRabId,$eRabId,$eRabQos,$address,$gtpTeid,$nas,$corrId"
                         }
                         set paramIndices [join $paramIndices ";"]
                         set ERABs        [generateIEs -IEType "ERABs" -paramIndices $paramIndices -HeNBIndex $HeNBIndex -MMEIndex $MMEIndex]
                    }
                    
                    # Create the fail list if specified
                    if {[info exists eRABsFailedToSetup]} {
                         set eRabList   [generateIEs -IEType "eRABsList" -paramIndices $eRABsFailedToSetup -HeNBIndex $HeNBIndex -MMEIndex $MMEIndex]
                    }
                    
               } else {
                    set mandatoryIEs "MMEUES1APId eNBUES1APId cause causeType"
               }
               set HeNBId [getFromTestMap -HeNBIndex $HeNBIndex -param "HeNBId"]
               #If the user has specified the criticalDiag, create the Critical Diags IE structure
               if {[info exists criticalityDiag]} {
                    set criticDiag [updateValAndExecute "getCriticDiag -criticalityDiag criticalityDiag \
                              -procedureCode procedureCode -triggerMsg triggerMsg -procedureCriticality procedureCriticality \
                              -IECriticality IECriticality -IEId IEId -typeOfError typeOfError"]
               }
               
               #Update the dynamic variables
               if {$operation == "send"} {
                    set simType "HeNB"
                    set paramList [list eNBUES1APId vENBUES1APId streamId ueid]
               } else {
                    set simType "MME"
                    set eNBUES1APId [getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "vENBUES1APId"]
                    set paramList [list vENBUES1APId MMEUES1APId mStreamId mmeUEId]
               }
          }
     }
     
     #Update the dynamic variables
     foreach dynElement {eNBUES1APId MMEUES1APId streamId ueid} param $paramList {
          if {![info exists $dynElement]} {
               if {$param == "streamId"} {
                    set streamId [expr $UEIndex + 1]
                    continue
               }
               if {[catch {set $dynElement [getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "$param"]}]} {
                    print -abort "Failed to get the param $param"
                    return 1
               }
          }
     }
     
     # Unset the IE if not intended to be sent in the message
     foreach mandIE $mandatoryIEs {
          if {[info exists mandIE]} {
               if {[set $mandIE] == ""} {unset $mandIE}
          }
     }

     if {$msg == "failure"} {
        if {[info exists causeType] && [info exists cause]} {
           set causeVal "\{$causeType=$cause\}"
        }
     }
     
     set gwPort [getDataFromConfigFile "henbSctp" $fgwNum] 
     set MMEId [getFromTestMap -MMEIndex $MMEIndex -param "MMEId"]
     # Since the initial context setup messages are relayed to the peer ent and no info is stored in the UE context table expect the UES1APIDs
     # Will would generate the data only while sending and store it in a global array
     # The contents of the array would be accessed while expecting the message on the peer entity
     # Also few of the params/IEs like the UES1APIDs and streamId would be modified before accessing for verification
     if {$operation == "send"} {
          #Construct the message that has to be sent to the simulator
          set initialContext [updateValAndExecute "constructS1Procedure -simType simType -msgName msgName -msgType msgType \
                    -HeNBId HeNBId -ueid ueid -eNBUES1APId eNBUES1APId -MMEUES1APId MMEUES1APId -UEAggMaxBitRate UEAggMaxBitRate \
                    -UESecurityCap UESecurityCap -securityKey securityKey -UERadioCapability UERadioCapability \
                    -subProfileIdForRAT SubscriberProfileId -CSFallInd CSFallbackInd -srvccOperation SRVCCOperation \
                    -CSGMembershipStatus CSGMembership -LAI LAI -GUMMEI GUMMEI -MMEUES1APId2 MMEUES1APId2\
                    -MDTConf MDTConfig -eRAB ERABs -handOverRestriction handOverRestriction -globaleNBId globaleNBId \
                    -TraceActivation TraceActivation -eRABsList eRabList -gwIp gwIp -gwPort gwPort\
                    -cause causeVal  -criticalityDiag criticDiag -streamId streamId -MMEId MMEId"]
          
          array set ARR_INIT_CONTEXT $initialContext
     } else {
          set initialContext [array get ARR_INIT_CONTEXT]
          foreach msgEle [list eNB_UE_S1AP_ID mME_UE_S1AP_ID StreamNo] updateVar [list eNBUES1APId MMEUES1APId streamId] {
               if {![info exists $updateVar]} {continue}
               if {[regsub "${msgEle}=\[0-9\]+" $initialContext "${msgEle}=[set $updateVar]" initialContext] != 1} {
                    print -fail "Failed to update variable $msgEle to [set $updateVar]"
                    return 1
               }
               # SRS-HeNBGW-CP-414
               # Since these values may not be generated while constructing the input we need to expicitly specify while expecting
               # This is only applicable for MacroENB
               if {$msgEle == "StreamNo" && $isHeNB} {
                    if {[info exists GUMMEI]} {
                         if {[regexp "gUMMEI_ID=\{" $initialContext]} {
                              regsub "gUMMEI_ID=\{.*mmegroupid=\[0-9]+\} " $initialContext "gUMMEI_ID=$GUMMEI " initialContext
                         } else {
                              regsub "${msgEle}=[set $updateVar]" $initialContext "${msgEle}=[set $updateVar] gUMMEI_ID=$GUMMEI " initialContext
                         }
                    }
                    if {[info exists MMEUES1APId2]} {
                         if {[regexp "mME_UE_S1AP_ID_2=" $initialContext]} {
                              regsub "mME_UE_S1AP_ID_2=\[0-9\]+" $initialContext "mME_UE_S1AP_ID_2=$MMEUES1APId2" initialContext
                         } else {
                              regsub "${msgEle}=[set $updateVar]" $initialContext "${msgEle}=[set $updateVar] mME_UE_S1AP_ID_2=$MMEUES1APId2 " initialContext
                         }
                    }
               }

               unset -nocomplain ARR_INIT_CONTEXT
          }

          if {[info exists causeType] && [info exists cause] && $msg == "failure"} {
             if {![regexp "cause=" $initialContext]} {
                regsub "${msgEle}=[set $updateVar]" $initialContext "${msgEle}=[set $updateVar] cause=$causeVal " initialContext 
             }  else {
                 regsub "cause=\{\[a-z\]+=(\[a-z\]*(_)*\[0-9\]*)*\} " $initialContext "cause=$causeVal " initialContext
             }
          }

     }
     
     print -info "initialContext $initialContext"
     if {$execute == "no"} { return "$simType $initialContext"}
     
     return [updateValAndExecute "sendOrVerifyS1APProcedure -msgName msgName -msgType msgType \
               -operation operation -msgList initialContext -simType simType -enbID enbID \
               -HeNBIndex HeNBIndex -MMEIndex MMEIndex"]
     
     return 0
}

proc reset {args} {
     #-
     #- Procedure for send/receive a RESET message from HeNB or MME
     #-          Cause  M               9.2.1.3         YES     ignore
     #-          CHOICE Reset Type      M                               YES     reject
     #-          >S1 interface
     #-           >>Reset All           M               ENUMERATED (Reset all,)         -
     #-          >Part of S1 interface
     #-           >>UE-associated logical S1-connection list            1                       -
     #-           >>>UE-associated logical S1-connection Item           1 to < maxnoofIndividualS1ConnectionsToReset
     #-           >>>>MME UE S1AP ID    O               9.2.3.3         -
     #-           >>>>eNB UE S1AP ID    O               9.2.3.4         -
     #-
     #-
     #- UEIndex : can be single UE index or comma seperated list; based upon these indexes UES1AP Id's will be taken in the proc, and is mandatory only for "resetPartial"
     #-         format 1: -UEIndex "0"
     #-         format 2: -UEIndex "0,1"
     #-         format 3: -UEIndex "0-10,11-100"
     #-
     #- resetType : can be either of resetpartial or resetall
     #-           format 1: -resetType "resetPartial"
     #-
     #-           format 2: -resetType "resetAll"
     #-
     #- resetS1Map : says which type of UES1AP Ids to be taken for "UEIndex" indexes. Takes one of these values: eNB,MME,both
     #-            format 1: -UEIndex "0" -resetS1Map "eNB"
     #-            format 2: -UEIndex "0" -resetS1Map "MME"
     #-            format 3: -UEIndex "0" -resetS1Map "both"
     #-            format 4: -UEIndex "0,1,2" -resetS1Map "eNB,MME,eNB"
     #-            format 5: -UEIndex "0-10,11-100,101-255" -resetS1Map "eNB,MME,both"
     #-            format 6: -UEIndex "0,1,x" -resetS1Map "eNB:x,x:MME,both"
     #-(here, first entry in eNB:x is for eNB and 2nd for MME)
     #-            format 7: -UEIndex "0,1,2-10" -resetS1Map "eNB:1,0:MME,x"
     #-            format 8: -UEIndex "0,1,2-10" -resetS1Map "eNB,MME,x"
     #-
     #- format of constructing Reset message from MME to multipleHeNB
     #- HeNBIndex,UEIndex and resetS1Map should be lists of same length;
     #-            format 1: -HeNBIndex "0 1 2" -resetS1Map "{eNB,MME,both} {both,MME} {both,eNB}"\
     #-                      -UEIndex "{0-10,11-100,101-255} {0-100,101-255} {0-255}" -resetS1Map "eNB,MME,both"
     #-                      {HeNBIndex 0 maps to UEIndex {0-10,11-100,101-255} with resetS1Map {eNB,MME,both}}
     #-                      {HeNBIndex 1 maps to UEIndex {0-100,101-255} with resetS1Map {both,MME}}
     #-                      {HeNBIndex 2 maps to UEIndex {0-255} with resetS1Map {both,eNB}}
     #-
     #-@return 0 on success, @return -1 on failure
     #-
     
     parseArgs args \
               [list \
               [list operation            optional   "send|(don't|)expect"  "send"            "send or expect option"] \
               [list simType              mandatory  "HeNB|MME"        	    ""                "Identifies the sim type on which send/expect operatoin done"] \
               [list execute              optional   "boolean"        	    "yes"             "To perform the operation or not. if no, will return the message"] \
               [list MMEIndex             optional   "numeric"     	    "__UN_DEFINED__"  "Index of MME whose values need to be retrieved" ] \
               [list HeNBIndex            mandatory  "numeric"     	    ""       		    "Index of HeNB whose values need to be retrieved" ] \
               [list UEIndex              optional   "string"               ""                "Index of UE whose values need to be retrieved" ] \
               [list resetS1Map           optional   "string"               "both"            "Identifies the UE associated S1 Map list"] \
               [list msgName              optional   "reset(|_acknowledge)" "reset"           "Message that has to be sent"] \
               [list resetType            optional   "reset(Partial|_all|All)"   "__UN_DEFINED__"  "defines the RESET type" ] \
               [list causeType            optional   "string"               "__UN_DEFINED__"  "Identifies the cause choice group"] \
               [list cause                optional   "string"               "__UN_DEFINED__"  "Identifies the cause value"] \
               [list criticalityDiag      optional   "string"               "__UN_DEFINED__"             "The critical diag to be enabled or not"] \
               [list procedureCode        optional   "string"               "__UN_DEFINED__"             "The procedure code to be used diag"] \
               [list triggerMsg           optional   "string"               "__UN_DEFINED__"             "Identifies the triggering message"] \
               [list procedureCriticality optional   "string"               "__UN_DEFINED__"             "Identifies the procedure Criticality"] \
               [list IECriticality        optional   "string"               "__UN_DEFINED__"             "Identifies the IE Criticality"] \
               [list IEId                 optional   "string"               "__UN_DEFINED__"             "Identifies the IE Id"] \
               [list typeOfError          optional   "string"               "__UN_DEFINED__"             "Identifies the type of error"] \
               [list getS1MsgRetryAttemps optional   "numeric"              "__UN_DEFINED__"      "The no of attempts to retry"] \
               [list getS1MsgRetryAfter   optional   "numeric"              "__UN_DEFINED__"      "To retry after"] \
               [list eNBUES1APId          optional   "string"         "__UN_DEFINED__"    "eNB UE S1AP Id value" ] \
               [list MMEUES1APId          optional   "string"         "__UN_DEFINED__"    "MME UE S1AP Id value" ] \
               [list streamId             optional   "numeric"        	    "__UN_DEFINED__"  "Defines the streamId assigned" ] \
               [list mandatoryIEs            optional   "string"         ""             "Miss the mandatory IE" ] \
               ]
     
     set msgType "class1"
     set flag    0
     
     if {![info exists MMEIndex]} {
          ##getFromTestMap returns MMEIndex incase of load balancing case of S1Flex scenario
          if {[getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "MMEIndex"] != -1} {
               set MMEIndex [getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "MMEIndex"]
               print -info "Using MMEIndex $MMEIndex among load balanced MMEs"
          } else {
               #Keeping default value of 0
               set MMEIndex "0"
               print -info "Using default MMEIndex $MMEIndex"
          }
     } else {
          print -info "Using MMEIndex $MMEIndex passed from script"
     }

     if {$simType == "HeNB"} {
        set gwIp   [getDataFromConfigFile "henbSignalingIpaddress" 0 ]
     } else {
        set gwIp   [getDataFromConfigFile "mmeSignalingIpaddress" 0 ]
        set MMEId  [getFromTestMap -MMEIndex $MMEIndex -param "MMEId"]
     }

     set gwPort [getDataFromConfigFile "henbSctp" 0 ]

     set MultiS1Link $::ARR_LTE_TEST_PARAMS(MultiS1Link)
     if {$MultiS1Link == "yes"} {
        set enbID [getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "eNBId"]
        if {$simType == "MME"} {
           set eNBType [getFromTestMap -HeNBIndex $HeNBIndex -param "eNBType"]
           if {! [ info exists eNBType ]} {
              set eNBType "macro"
           }
           if {[info exists enbID]} {
              set globaleNBId "\{${eNBType}ENB_ID=$enbID\}"
           }
        }
     }
     
     if {$msgName == "reset"} {
          if {![info exists resetType]} { set resetType "resetPartial" }
          if {![info exists causeType]} { set causeType "misc"         }
          if {![info exists cause]}     { set cause     "unspecified"  }
          if { $resetType == "resetAll" } { set resetType "reset_all" }

          # Unset the IE if not intended to be sent in the message
          foreach mandIE $mandatoryIEs {
            if {[info exists mandIE]} {
               if {[set $mandIE] == ""} {unset $mandIE}
            }
          }
         
          if {[info exists causeType] && [info exists cause]} {
             set causeVal "\{$causeType=$cause\}"
          }
 
          if {[regexp -nocase "reset_all" $resetType] && $operation == "send"} {
               print -info "Sending message with resetAll option from $simType"
               if {$simType == "HeNB"} { set HeNBId [getFromTestMap -HeNBIndex $HeNBIndex -param "HeNBId"] }
               set resetInterface "s1_Interface"
               
               set resetTypeVal "\{$resetInterface=$resetType\}" 

               set reset [updateValAndExecute "constructS1Procedure -msgName msgName -simType simType -msgType msgType \
			 -HeNBId HeNBId -MMEId MMEId -cause causeVal -resetType resetTypeVal \
                         -StreamNo streamId -gwIp gwIp -gwPort gwPort"]
               print -info "reset $reset"
               
               if {$execute == "no"} { return "$simType $reset"}
               
               return [updateValAndExecute "sendOrVerifyS1APProcedure -msgName msgName -msgType msgType \
                         -operation operation -msgList reset -simType simType \
                         -HeNBIndex HeNBIndex -MMEIndex MMEIndex -getS1MsgRetryAttemps getS1MsgRetryAttemps -getS1MsgRetryAfter getS1MsgRetryAfter"]
          }
     }
     
     # for the context where we are expecting ack for resetAll message
     if {$resetS1Map == "empty" && $simType == "MME"} {
          set reset [updateValAndExecute "constructS1Procedure -msgName msgName -simType simType -msgType msgType \
                         -StreamNo streamId -gwIp gwIp -gwPort gwPort"]
          return [updateValAndExecute "sendOrVerifyS1APProcedure -msgName msgName -msgType msgType \
                    -operation operation -msgList reset -simType simType -MMEIndex MMEIndex"]
     }
     
     if {$resetS1Map == "empty" && $simType == "HeNB"} {
          set reset [updateValAndExecute "constructS1Procedure -msgName msgName -simType simType -msgType msgType \
                         -StreamNo streamId -gwIp gwIp -gwPort gwPort"]
          return [updateValAndExecute "sendOrVerifyS1APProcedure -msgName msgName -msgType msgType \
                    -operation operation -msgList reset -simType simType -MMEIndex MMEIndex -HeNBIndex HeNBIndex"]
     }
     
     if {$resetS1Map == "empty" && $simType == "HeNB"} {
          set reset [updateValAndExecute "constructS1Procedure -msgName msgName -simType simType -msgType msgType \
                         -StreamNo streamId -gwIp gwIp -gwPort gwPort"]
          return [updateValAndExecute "sendOrVerifyS1APProcedure -msgName msgName -msgType msgType \
                    -operation operation -msgList reset -simType simType -MMEIndex MMEIndex -HeNBIndex HeNBIndex"]
     }
     
     # validate data lengths
     if {[llength $MMEIndex] != [llength $HeNBIndex] || [llength $MMEIndex] != [llength $UEIndex] || [llength $MMEIndex] != [llength $resetS1Map]} {
          print -fail "data length mismatch MMEIndex([llength $MMEIndex]), HeNBIndex([llength $HeNBIndex]), UEIndex([llength $UEIndex]), resetS1Map([llength $resetS1Map])"
          return -1
     }
     
     switch $simType {
          "MME" {
               #ues1list including ues1's for multiple mme's ue's
               foreach mmeIndex $MMEIndex henbIndexList $HeNBIndex resetS1MapList $resetS1Map ueIndexList $UEIndex {
                    if {[llength $henbIndexList] != [llength $resetS1MapList] && [llength $henbIndexList] != [llength $ueIndexList]} {
                         print -fail "Inputs are not sufficient for henbIndexList=$henbIndexList ueIndexList=$ueIndexList and resetS1MapList=$resetS1MapList"
                         set flag -1
                         continue
                    }

                    set ues1List ""
                    if {![info exists eNBUES1APId] && ![info exists MMEUES1APId]} {
                       foreach henbIndex $henbIndexList resets1map $resetS1MapList ueIndex $ueIndexList {
                         lappend ues1List [getUEContextS1AP -MMEIndex $mmeIndex -HeNBIndex $henbIndex -UEIndex $ueIndex \
                                   -resetS1Map $resets1map -simType $simType]
                       }
                       if {$ues1List==-1} {
                         print -fail "No UES1 map constructed for MME ($mmeIndex), HeNB ($henbIndex), UEs ($ueIndex), resetMap ($resets1map)"
                         set flag -1
                         continue
                       }
                    } else {
                       foreach enbues1apid $eNBUES1APId mmeues1apid $MMEUES1APId {
                         #lappend ues1List "es1id=$enbues1apid ms1id=$mmeues1apid"
                         lappend ues1List "eNB_UE_S1AP_ID=$enbues1apid mME_UE_S1AP_ID=$mmeues1apid"
                       }
                       set ues1List "\{$ues1List\}"

                       set henbIndex $henbIndexList
                       set resets1map $resetS1MapList
                       set ueIndex $ueIndexList
                    }

                    set ues1List [join $ues1List ,]
                    set MMEId  [getFromTestMap -MMEIndex $MMEIndex -param "MMEId"]
                     
                    set resetInterface "partOfS1_Interface"
                    if {[info exists cause] && [info exists causeType]} {
                       #set causeVal "\{$causeType=$cause\}"
                       set resetTypeVal "\{$resetInterface=$ues1List\}"
                    } else {
                       print -info "cause and causeType IE values are not set. So, skipping cause IE"
                    }

                    if {$msgName == "reset_acknowledge"} {
                       set reset [updateValAndExecute "constructS1Procedure -msgName msgName -simType simType -msgType msgType\
                           -MMEId MMEId -ueid ueid -uE_associatedLogicalS1_ConnectionListResAck ues1List\
                           -criticalityDiagnostics criticalityDiagnostics -StreamNo streamId \
                           -gwIp gwIp -gwPort gwPort -globaleNBId globaleNBId"]
                    } else {
                       set reset [updateValAndExecute "constructS1Procedure -msgName msgName -simType simType -msgType msgType \
                              -MMEId MMEId -ueid ueid -cause causeVal -resetType resetTypeVal -globaleNBId globaleNBId \
                              -criticalityDiag criticDiag -StreamNo streamId -gwIp gwIp -gwPort gwPort"]
                    }
                    print -info "$reset"

                    
                    if {$execute == "no"} { return "$simType $reset"}
                    
                    set result [updateValAndExecute "sendOrVerifyS1APProcedure -MMEId MMEId -msgName msgName -msgType msgType \
                              -operation operation -msgList reset -simType simType -globaleNBId globaleNBId \
                              -HeNBIndex henbIndex -MMEIndex mmeIndex -getS1MsgRetryAttemps getS1MsgRetryAttemps -getS1MsgRetryAfter getS1MsgRetryAfter"]
                    if {$result != 0} {
                         print -fail "Msg $operation on MME with details MME ($mmeIndex), HeNB ($henbIndex), UEs ($ueIndex), resetMap ($resets1map) failed"
                         set flag -1
                    } else {
                         print -pass "Msg $operation on MME with details MME ($mmeIndex), HeNB ($henbIndex), UEs ($ueIndex), resetMap ($resets1map) successful"
                    }
               }
               if {$flag != 0} {
                    print -fail "Few/All $msgName messages [string totitle $operation] on corresponding MME(s) failed"
               } else {
                    print -pass "All $msgName messages [string totitle $operation] on corresponding MME(s) successful"
               }
               return $flag
          }
          "HeNB" {
               #ues1list including ues1's for multiple mme's ue's
               foreach mmeIndex $MMEIndex henbIndexList $HeNBIndex resetS1MapList $resetS1Map ueIndexList $UEIndex {
                    if {[llength $henbIndexList] != [llength $resetS1MapList] && [llength $henbIndexList] != [llength $ueIndexList]} {
                         print -fail "Inputs are not sufficient for henbIndexList=$henbIndexList ueIndexList=$ueIndexList and resetS1MapList=$resetS1MapList"
                         set flag -1
                         continue
                    }
                    foreach henbIndex $henbIndexList resets1map $resetS1MapList ueIndex $ueIndexList {
                         set ues1List ""
                         lappend ues1List [getUEContextS1AP -MMEIndex $mmeIndex -HeNBIndex $henbIndex -UEIndex $ueIndex \
                                   -resetS1Map $resets1map -simType $simType]
                         
                         if {$ues1List==-1} {
                              print -fail "No UES1 map constructed for MME ($mmeIndex), HeNB ($henbIndex), UEs ($ueIndex), resetMap ($resets1map)"
                              set flag -1
                              continue
                         }
                         # retrieve HeNB id to filter messages from specified HeNB
                         set HeNBId [getFromTestMap -HeNBIndex $henbIndex -param "HeNBId"]
                         set ues1List [join $ues1List ,]
			 
                         set resetInterface "partOfS1_Interface"
                         if {[info exists cause] && [info exists causeType]} {
                            #set causeVal "\{$causeType=$cause\}"
                            set resetTypeVal "\{$resetInterface=\{$ues1List\}\}"
                         } else {
                            print -info "cause and causeType IE values are not set. So, skipping cause IE"
                         }

                         if {$msgName == "reset_acknowledge"} {
                             set reset [updateValAndExecute "constructS1Procedure -msgName msgName -simType simType -msgType msgType\
                              -HeNBId HeNBId -ueid ueid -uE_associatedLogicalS1_ConnectionListResAck ues1List\
                              -criticalityDiagnostics criticalityDiagnostics -StreamNo streamId \
                             -gwIp gwIp -gwPort gwPort"]
                         } else {
                             set reset [updateValAndExecute "constructS1Procedure -msgName msgName -simType simType -msgType msgType\
                              -HeNBId HeNBId -ueid ueid -cause causeVal -resetType resetTypeVal \
                              -criticalityDiag criticDiag -StreamNo streamId -gwIp gwIp -gwPort gwPort"]
                         }

                         print -info "$reset"

                         
                         if {$execute == "no"} { return "$simType $reset"}
                         
                         set result [updateValAndExecute "sendOrVerifyS1APProcedure -msgName msgName -msgType msgType \
                                   -operation operation -msgList reset -simType simType -HeNBId HeNBId -enbID enbID \
                                   -HeNBIndex henbIndex -MMEIndex mmeIndex -getS1MsgRetryAttemps getS1MsgRetryAttemps -getS1MsgRetryAfter getS1MsgRetryAfter"]
                         if {$result != 0} {
                              print -fail "Msg $operation on HeNB with details MME ($mmeIndex), HeNB ($henbIndex), UEs ($ueIndex), resetMap ($resets1map) failed"
                              set flag -1
                         } else {
                              print -pass "Msg $operation on HeNB with details MME ($mmeIndex), HeNB ($henbIndex), UEs ($ueIndex), resetMap ($resets1map) successful"
                         }
                    }
               }
               if {$flag != 0} {
                    print -fail "Few/All $msgName messages [string totitle $operation] on corresponding HeNB(s) failed"
               } else {
                    print -pass "All $msgName messages [string totitle $operation] on corresponding HeNB(s) successful"
               }
               return $flag
          }
     }
}

proc resetAck {args} {
     #-
     #- Procedure for send/receive a RESETAck message from HeNB or MME
     #-
     #-UE-associated logical S1-connection list
     #->UE-associated logical S1-connection Item
     #->>MME UE S1AP ID
     #->>eNB UE S1AP ID
     #-Criticality Diagnostics
     #-
     #-
     #- UEIndex : can be single UE index or comma seperated list; based upon these indexes UES1AP Id's will be taken in the proc,
     #-         format 1: -UEIndex "0"
     #-         format 2: -UEIndex "0,1"
     #-         format 3: -UEIndex "0-10,11-100"
     #-
     #-@return 0 on success, @return -1 on failure
     #-
     parseArgs args \
               [list \
               [list operation            optional   "send|(don't|)expect"  "send"             "send or expect option"] \
               [list simType              mandatory  "HeNB|MME"     	    ""                 "Identifies the sim type on which send/expect operatoin done"] \
               [list execute              optional   "boolean"              "yes"              "To perform the operation or not. if no, will return the message"] \
               [list HeNBIndex            mandatory  "numeric"              ""                 "Index of HeNB whose values need to be retrieved" ] \
               [list UEIndex              mandatory  "string"               ""                 "Index of UEs whose values need to be retrieved" ] \
               [list MMEIndex             optional   "numeric"              "__UN_DEFINED__"   "Index of MME whose values need to be retrieved" ] \
               [list resetS1Map           optional   "string"               "eNB,MME,both"     "Identifies the UE associated S1 list"] \
               [list causeType            optional   "string"      	    "__UN_DEFINED__"   "Identifies the cause choice group"] \
               [list cause                optional   "string"      	    "__UN_DEFINED__"   "Identifies the cause value"] \
               [list criticalityDiag      optional   "string"               "__UN_DEFINED__"   "The critical diag to be enabled or not"] \
               [list procedureCode        optional   "string"               "__UN_DEFINED__"   "The procedure code to be used diag"] \
               [list triggerMsg           optional   "string"               "__UN_DEFINED__"   "Identifies the triggering message"] \
               [list procedureCriticality optional   "string"               "__UN_DEFINED__"   "Identifies the procedure Criticality"] \
               [list IECriticality        optional   "string"               "__UN_DEFINED__"   "Identifies the IE Criticality"] \
               [list IEId                 optional   "string"               "__UN_DEFINED__"   "Identifies the IE Id"] \
               [list typeOfError          optional   "string"               "__UN_DEFINED__"   "Identifies the type of error"] \
               [list streamId             optional   "numeric"        	    "__UN_DEFINED__"   "Defines the streamId assigned" ] \
               ]
     
     set msgName "reset_acknowledge"
     
     if {![info exists MMEIndex]} {
          ##getFromTestMap returns MMEIndex incase of load balancing case of S1Flex scenario
          if {[getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "MMEIndex"] != -1} {
               set MMEIndex [getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "MMEIndex"]
               print -info "Using MMEIndex $MMEIndex among load balanced MMEs"
          } else {
               #Keeping default value of 0
               set MMEIndex "0"
               print -info "Using default MMEIndex $MMEIndex"
          }
     } else {
          print -info "Using MMEIndex $MMEIndex passed from script"
     }
     set optIEs "-procedureCode procedureCode -procedureCriticality procedureCriticality -triggeringMessage triggerMsg"
     if {[info exists IECriticality] && [info exists IEId] && [info exists typeOfError]} {
        set mandatoryIEs "iECriticality=$IECriticality iE_ID=$IEId typeOfError=$typeOfError"
        set criticalityDiagnostics "criticalityDiagnostics=\{iEsCriticalityDiagnostics=\{$mandatoryIEs\} $optIEs\}"
     } else {
        print -info "Mandatory IE is missing. iECriticality, iE_ID and typeOfErrord IEs are mandatory. So, Skipping criticalityDiagnostics IE"
     }

     return [updateValAndExecute "reset -operation operation -simType simType -execute execute -MMEIndex MMEIndex -HeNBIndex HeNBIndex \
               -UEIndex UEIndex -resetS1Map resetS1Map -msgName msgName -uE_associatedLogicalS1_ConnectionListResAck ues1List\
               -criticalityDiagnostics criticalityDiagnostics -StreamNo streamId -gwIp gwIp -gwPort gwPort"]

}

proc eRABSetup {args} {
     #-
     #- procedure to setup eRAB
     #-
     #-  ------ E-RAB SETUP REQUEST ------
     #-
     #-  Message Type				M
     #-  MME UE S1AP ID 			M
     #-  eNB UE S1AP ID 			M
     #-  UE Aggregate Maximum Bit Rate		O
     #-  E-RAB to Be Setup List                 (1)
     #-    >E-RAB to Be Setup Item IEs          (1..256)
     #-      >>E-RAB ID				M
     #-      >>E-RAB Level QoS Paramet		M
     #-      >>Transport Layer Address		M
     #-      >>GTP-TEID				M
     #-      >>NAS-PDU				M
     #-      >>Correlation ID			O
     #-
     #- ------ E-RAB SETUP RESPONSE ------
     #-
     #-   Message Type				M
     #-   MME UE S1AP ID 			M
     #-   eNB UE S1AP ID 			M
     #-   E-RAB Setup List                      (0..1)
     #-     > E-RAB Setup Item Ies              (1..256)
     #-       >>E-RAB ID			M
     #-       >>Transport Layer Address		M
     #-       >>GTP-TEID			M
     #-   E-RAB Failed to Setup List		O
     #-   Criticality Diagnostics		O
     #-
     #- -------------- IE GENERATION ------------------
     #  USAGE:
     #- *** eRAB
     #-     eRAB {noOfErabs}
     #-     eRAB {noOfErabs,startERAB,e_RAB_ID,eRABQos,transAddr,gtpTeid,nas,corrId}
     #-     eRAB {noOfErabs,startERAB,e_RAB_ID,eRABQos,transAddr,gtpTeid,nas,corrId};{noOfErabs,startERAB,e_RAB_ID,eRABQos,transAddr,gtpTeid,nas,corrId}
     #-
     #- For eRAB Setup request
     #- 1. eRAB 2               : Will create 2 eRABs will all mandatory IEs as part of the container
     #- 2. eRAB 2,0,1,0,1,1,0,0 : Will create 2 eRABS, with eRAB ID starting from 0 and only
     #-                           e_RAB_ID,transAddr and gtpTeid as part of the container
     #- 3. eRAB 1,0,1,1,1,1,1,1;1,8,1,1,1,1,1,1;1,11,1,1,1,1,1,1
     #-                         : Will create 3 eRABs with eRABIDs 0,8,11
     #-                           with all the mandatory and optional IEs as part of the container
     #-
     #- For eRAB Setup response
     #- 1. eRAB 1,0         : Successful response for 1 eRAB with e_RAB_ID 0
     #- 1. eRAB 2,0;1,10    : Successful response for 3 eRAB with e_RAB_ID 0,1 and 10
     #-
     #- *** UEAggrBitRate
     #-     UEAggrBitRate {maxBitRateDl,maxBitRateDl}
     #-     UEAggrBitRate 1,1    : Randomly generate maxBitRateDl and maxBitRateDl
     #-     UEAggrBitRate 1,0    : Send only maxBitRateDl IE in UEAggrBitRate
     #-
     #-@return 0 on success, @return -1 on failure
     #-
     
     global ARR_eRAB_SETUP
     set validMsg          "request|response"
     set defaultCause      "message_not_compatible_with_receiver_state"
     
     parseArgs args \
               [list \
               [list msg                  optional   "$validMsg"      "request"           "The message to be sent" ] \
               [list operation            optional   "send|(don't|)expect"    "send"      "send or expect option"] \
               [list execute              optional   "boolean"        "yes"               "To perform the operation or not. if no, will return the message"] \
               [list HeNBIndex            mandatory  "numeric"        ""                  "Index of HeNB whose values need to be retrieved" ] \
               [list UEIndex              mandatory  "numeric"        ""                  "Index of UE whose values need to be retrieved" ] \
               [list MMEIndex             optional   "numeric"        "__UN_DEFINED__"    "Index of MME whose values need to be retrieved" ] \
               [list eNBUES1APId          optional   "string"         "__UN_DEFINED__"    "eNB UE S1AP Id value" ] \
               [list MMEUES1APId          optional   "string"         "__UN_DEFINED__"    "MME UE S1AP Id value" ] \
               [list causeType            optional   "string"         "protocol"          "Identifies the cause choice group"] \
               [list cause                optional   "string"         "$defaultCause"     "Identifies the cause value"] \
               [list criticalityDiag      optional   "string"         "__UN_DEFINED__"    "The critical diag to be enabled or not"] \
               [list procedureCode        optional   "string"         "__UN_DEFINED__"    "The procedure code to be used diag"] \
               [list triggerMsg           optional   "string"         "__UN_DEFINED__"    "Identifies the triggering message"] \
               [list procedureCriticality optional   "string"         "__UN_DEFINED__"    "Identifies the procedure Criticality"] \
               [list IECriticality        optional   "string"         "__UN_DEFINED__"    "Identifies the IE Criticality list"] \
               [list IEId                 optional   "numeric"        "__UN_DEFINED__"    "Identifies the IE Id list"] \
               [list typeOfError          optional   "string"         "__UN_DEFINED__"    "Identifies the type of error list"] \
               [list streamId             optional   "numeric"        "__UN_DEFINED__"    "Defines the streamId assigned" ] \
               ]
     
     set msgName [string map "\
               request    e-rab_setup_request \
               response   e-rab_setup_response" \
               $msg]
     set msgType "class1"
     
     if {![info exists MMEIndex]} {
          ##getFromTestMap returns MMEIndex incase of load balancing case of S1Flex scenario
          if {[getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "MMEIndex"] != -1} {
               set MMEIndex [getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "MMEIndex"]
               print -info "Using MMEIndex $MMEIndex among load balanced MMEs"
          } else {
               #Keeping default value of 0
               set MMEIndex "0"
               print -info "Using default MMEIndex $MMEIndex"
          }
     } else {
          print -info "Using MMEIndex $MMEIndex passed from script"
     }

     set gwPort [getDataFromConfigFile "henbSctp" 0 ]

     set MultiS1Link $::ARR_LTE_TEST_PARAMS(MultiS1Link)

     if {$MultiS1Link == "yes"} {
        set enbID [getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "eNBId"]
     } 
     
     switch -regexp $msg {
          "request"  {
               set mandatoryIEs "MMEUES1APId eNBUES1APId ERABs"
               parseArgs args \
                         [list \
                         [list UEAggMaxBitRate      optional   "string"           "__UN_DEFINED__"    "The UE aggregate max bit rate" ] \
                         [list ERABs                optional   "string"           "1"                 "The number of E-RAB to be setup" ] \
                         ]

               
               #Update the dynamic variables
               if {$operation == "send"} {
                    set simType "MME"
                    set paramList [list vENBUES1APId MMEUES1APId mStreamId mmeUEId]

                    if {$MultiS1Link == "yes"} {
                       set eNBType [getFromTestMap -HeNBIndex $HeNBIndex -param "eNBType"]
                       if {! [ info exists eNBType ]} {
                          set eNBType "macro"
                       }
                       if {[info exists enbID]} {
                          set globaleNBId "\{${eNBType}ENB_ID=$enbID\}"
                       }
                    }
               } else {
                    set simType "HeNB"
                    set paramList [list eNBUES1APId vENBUES1APId streamId mmeUEId]
               }

               set gwIp   [getDataFromConfigFile "mmeSignalingIpaddress" 0 ]
               set MMEId  [getFromTestMap -MMEIndex $MMEIndex -param "MMEId"]
               
               #For IEs which itself is a structure, construct it only if the user has defined the variable
               if {$ERABs != ""} {
                    if {[regexp "," $ERABs]} {
                         # Construct the way the user wants to pass it
                         set paramIndices $ERABs
                    } else {
                         set noOfeRabs    $ERABs
                         set starteRabId  0
                         set eRabId       1 ;#include IE
                         set eRabQos      1 ;#include IE
                         set address      1 ;#include IE
                         set gtpTeid      1 ;#include IE
                         set nas          1 ;#include IE
                         set corrId       0 ;#exclude IE
                         set paramIndices "$noOfeRabs,$starteRabId,$eRabId,$eRabQos,$address,$gtpTeid,$nas,$corrId"
                    }
                    set ERABs [generateIEs -IEType "ERABs" -paramIndices $paramIndices -HeNBIndex $HeNBIndex -MMEIndex $MMEIndex]
               }
               if {[info exists UEAggMaxBitRate]} {set UEAggMaxBitRate [generateIEs -IEType "UEAggrBitRate" -paramIndices $UEAggMaxBitRate -HeNBIndex $HeNBIndex -MMEIndex $MMEIndex]}
          }
          "response" {
               set mandatoryIEs "MMEUES1APId eNBUES1APId ERABs"
               parseArgs args \
                         [list \
                         [list ERABs                optional   "string"     "1,0"               "The number of E-RAB sucessfully setup" ] \
                         [list eRABsFailedToSetup   optional   "string"     "__UN_DEFINED__"    "The number of E-RAB failed to setup" ] \
                         ]
               # If the value of ERABs is not null then generate it
               set HeNBId [getFromTestMap -HeNBIndex $HeNBIndex -param "HeNBId"]
               set gwIp   [getDataFromConfigFile "henbSignalingIpaddress" 0 ]

               print -info "EARBS: $ERABs"
               if {$ERABs != ""} {
                    if {[regexp ";" $ERABs]} {
                         set noofElms [llength [split [lindex [split $ERABs ;] 0] ,] ]
                    } else {
                         set noofElms [llength [split $ERABs ,]]
                    }
                    if {$noofElms > 2} {
                         # The user may specify exactly want IE he wants to include or exclude
                         # In that case pass what the user has entered
                         set paramIndices $ERABs
                    } else {
                         set paramIndices ""
                         foreach erab [split $ERABs ";"] {
                              foreach {noOfeRabs starteRabId} [split $erab ,] {break}
                              set eRabId       1 ;#include IE
                              set eRabQos      0 ;#exclude IE
                              set address      1 ;#include IE
                              set gtpTeid      1 ;#include IE
                              set nas          0 ;#exclude IE
                              set corrId       0 ;#exclude IE
                              if {$starteRabId == ""} { set starteRabId 0 }
                              lappend paramIndices "$noOfeRabs,$starteRabId,$eRabId,$eRabQos,$address,$gtpTeid,$nas,$corrId"
                         }
                         set paramIndices [join $paramIndices ";"]
                    }
                    set ERABs        [generateIEs -IEType "ERABs" -paramIndices $paramIndices -HeNBIndex $HeNBIndex -MMEIndex $MMEIndex]
               }
               
               # Create the fail list if specified
               if {[info exists eRABsFailedToSetup]} {
                    set eRabList   [generateIEs -IEType "eRABsList" -paramIndices $eRABsFailedToSetup -HeNBIndex $HeNBIndex -MMEIndex $MMEIndex]
               }
               
               #If the user has specified the criticalDiag, create the Critical Diags IE structure
               if {[info exists criticalityDiag]} {
                    set criticDiag [updateValAndExecute "getCriticDiag -criticalityDiag criticalityDiag \
                              -procedureCode procedureCode -triggerMsg triggerMsg -procedureCriticality procedureCriticality \
                              -IECriticality IECriticality -IEId IEId -typeOfError typeOfError"]
               }
               
               #Update the dynamic variables
               if {$operation == "send"} {
                    set simType "HeNB"
                    set paramList [list eNBUES1APId vENBUES1APId streamId ueid]
               } else {
                    set simType "MME"
                    set paramList [list vENBUES1APId MMEUES1APId mStreamId mmeUEId]
               }
          }
     }
     
     #Update the dynamic variables
     foreach dynElement {eNBUES1APId MMEUES1APId streamId ueid} param $paramList {
          if {![info exists $dynElement]} {
               #While sending UE data from eNB simulator use the streamId that is one greater then the UEIndex
               if {$param == "streamId"} {
                    set streamId [expr $UEIndex + 1]
                    continue
               }
               if {[catch {set $dynElement [getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "$param"]}]} {
                    print -abort "Failed to get the param $param"
                    return 1
               }
          }
     }
     
     # Unset the IE if not intended to be sent in the message
     foreach mandIE $mandatoryIEs {
          if {[info exists mandIE]} {
               if {[set $mandIE] == ""} {unset $mandIE}
          }
     }
    
     # Since the eRAB request is relayed to the eNB and no info is stored in the UE context table expect the UES1APIDs
     # Will would generate the data only while sending and store it in a global array
     # The contents of the array would be accessed while expecting the message on the peer entity
     # Also few of the params/IEs like the UES1APIDs and streamId would be modified before accessing for verification
     if {$operation == "send"} {
          #Construct the message that has to be sent to the simulator
          set eRabSetup [updateValAndExecute "constructS1Procedure -simType simType -msgName msgName -msgType msgType \
                    -HeNBId HeNBId -MMEId MMEId -eNBUES1APId eNBUES1APId -MMEUES1APId MMEUES1APId -UEAggMaxBitRate UEAggMaxBitRate \
                    -eRABsList eRabList -eRAB ERABs -criticalityDiag criticDiag -streamId streamId -gwIp gwIp -gwPort gwPort -globaleNBId globaleNBId"]
          #	array set ARR_eRAB_SETUP $eRabSetup
          if { [info exists ARR_eRAB_SETUP($msg)] } {
               unset -nocomplain ARR_eRAB_SETUP($msg)
          }
          set ARR_eRAB_SETUP($msg) $eRabSetup
     } else {
          set eRabSetup $ARR_eRAB_SETUP($msg)
          # 	  set eRabSetup [array get ARR_eRAB_SETUP]
          foreach msgEle [list eNB_UE_S1AP_ID mME_UE_S1AP_ID StreamNo] updateVar [list eNBUES1APId MMEUES1APId streamId] {
               if {![info exists $updateVar]} {continue}
               if {[regsub "${msgEle}=\[0-9\]+" $eRabSetup "${msgEle}=[set $updateVar]" eRabSetup] != 1} {
                    print -fail "Failed to update variable $msgEle to [set $updateVar]"
                    return 1
               }
               # unset -nocomplain ARR_eRAB_SETUP
          }
          unset -nocomplain ARR_eRAB_SETUP($msg)
     }
     
     print -info "eRabSetup $eRabSetup"
     if {$execute == "no"} { return "$simType $eRabSetup"}
     
     return [updateValAndExecute "sendOrVerifyS1APProcedure -msgName msgName -msgType msgType \
               -operation operation -msgList eRabSetup -simType simType -enbID enbID \
               -HeNBIndex HeNBIndex -MMEIndex MMEIndex"]
     
     return 0
}

proc eRABModify {args} {
     #-
     #- procedure to modify eRABs
     #-
     #-  ------ E-RAB MODIFY REQUEST ------
     #-
     #-  Message Type				M
     #-  MME UE S1AP ID 			M
     #-  eNB UE S1AP ID 			M
     #-  UE Aggregate Maximum Bit Rate		O
     #-  E-RAB to Be Setup List                 (1)
     #-    >E-RAB to Be Setup Item IEs          (1..256)
     #-      >>E-RAB ID				M
     #-      >>E-RAB Level QoS Paramet		M
     #-      >>NAS-PDU				M
     #-
     #- ------ E-RAB MODIFY RESPONSE ------
     #-
     #-   Message Type				M
     #-   MME UE S1AP ID 			M
     #-   eNB UE S1AP ID 			M
     #-   E-RAB Modify List                     (0..1)
     #-     > E-RAB Modify Item IEs             (1..256)
     #-       >>E-RAB ID			M
     #-   E-RAB Failed to Modify List           O
     #-   Criticality Diagnostics		O
     #-
     #- -------------- IE GENERATION ------------------
     #  USAGE:
     #- *** eRAB
     #-     eRAB {noOfErabs,eRabId}
     #-     eRAB {noOfErabs,e_RAB_ID};{noOfErabs,e_RAB_ID}
     #-
     #- For eRAB Modify request
     #- 1. eRAB 1,0         : Modify eRAB for 1 eRAB with e_RAB_ID 0
     #- 1. eRAB 2,0;1,10    : Modify 3 eRAB with e_RAB_ID 0,1 and 10
     #-
     #- For eRAB Modify response
     #- 1. eRAB 1,0         : Successfully modified 1 eRAB with eRABID 0
     #- 2. eRAB 2,0;1,10    : Successfully modified 3 eRAB with eRABID 0,1 and 10
     #-
     #- *** UEAggrBitRate
     #-     UEAggrBitRate {maxBitRateDl,maxBitRateDl}
     #-     UEAggrBitRate 1,1    : Randomly generate maxBitRateDl and maxBitRateDl
     #-     UEAggrBitRate 1,0    : Send only maxBitRateDl IE in UEAggrBitRate
     #-
     #-@return 0 on success, @return -1 on failure
     #-
     
     global ARR_eRAB_MODIFY
     set validMsg          "request|response"
     set defaultCause      "message_not_compatible_with_receiver_state"
     
     parseArgs args \
               [list \
               [list msg                  optional   "$validMsg"      "request"           "The message to be sent" ] \
               [list operation            optional   "send|(don't|)expect"  "send"        "send or expect option"] \
               [list execute              optional   "boolean"        "yes"               "To perform the operation or not. if no, will return the message"] \
               [list HeNBIndex            mandatory  "numeric"        ""                  "Index of HeNB whose values need to be retrieved" ] \
               [list UEIndex              mandatory  "numeric"        ""                  "Index of UE whose values need to be retrieved" ] \
               [list MMEIndex             optional   "numeric"        "__UN_DEFINED__"    "Index of MME whose values need to be retrieved" ] \
               [list eNBUES1APId          optional   "string"        "__UN_DEFINED__"    "eNB UE S1AP Id value" ] \
               [list MMEUES1APId          optional   "string"        "__UN_DEFINED__"    "MME UE S1AP Id value" ] \
               [list ERABs                optional   "string"         "1,0"               "The number of E-RAB to be setup with start id" ] \
               [list causeType            optional   "string"         "protocol"          "Identifies the cause choice group"] \
               [list cause                optional   "string"         "$defaultCause"     "Identifies the cause value"] \
               [list criticalityDiag      optional   "string"         "__UN_DEFINED__"    "The critical diag to be enabled or not"] \
               [list procedureCode        optional   "string"         "__UN_DEFINED__"    "The procedure code to be used diag"] \
               [list triggerMsg           optional   "string"         "__UN_DEFINED__"    "Identifies the triggering message"] \
               [list procedureCriticality optional   "string"         "__UN_DEFINED__"    "Identifies the procedure Criticality"] \
               [list IECriticality        optional   "string"         "__UN_DEFINED__"    "Identifies the IE Criticality list"] \
               [list IEId                 optional   "numeric"        "__UN_DEFINED__"    "Identifies the IE Id list"] \
               [list typeOfError          optional   "string"         "__UN_DEFINED__"    "Identifies the type of error list"] \
               [list streamId             optional   "numeric"        "__UN_DEFINED__"    "Defines the streamId assigned" ] \
               ]
     
     set msgName [string map "\
               request    e-rab_modify_request \
               response   e-rab_modify_response" \
               $msg]
     set msgType "class1"
     
     if {![info exists MMEIndex]} {
          ##getFromTestMap returns MMEIndex incase of load balancing case of S1Flex scenario
          if {[getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "MMEIndex"] != -1} {
               set MMEIndex [getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "MMEIndex"]
               print -info "Using MMEIndex $MMEIndex among load balanced MMEs"
          } else {
               #Keeping default value of 0
               set MMEIndex "0"
               print -info "Using default MMEIndex $MMEIndex"
          }
     } else {
          print -info "Using MMEIndex $MMEIndex passed from script"
     }
    
     set gwPort [getDataFromConfigFile "henbSctp" 0 ]

     set MultiS1Link $::ARR_LTE_TEST_PARAMS(MultiS1Link)

     if {$MultiS1Link == "yes"} {
        set enbID [getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "eNBId"]
     } 
 
     switch -regexp $msg {
          "request"  {
               set mandatoryIEs "MMEUES1APId eNBUES1APId ERABs"
               parseArgs args \
                         [list \
                         [list UEAggMaxBitRate      optional   "string"           "__UN_DEFINED__"    "The UE aggregate max bit rate" ] \
                         ]
               set gwIp   [getDataFromConfigFile "mmeSignalingIpaddress" 0 ]
               set MMEId  [getFromTestMap -MMEIndex $MMEIndex -param "MMEId"]
            
               if {$MultiS1Link == "yes"} {
                  set eNBType [getFromTestMap -HeNBIndex $HeNBIndex -param "eNBType"]
                  if {! [ info exists eNBType ]} {
                     set eNBType "macro"
                  }
                  if {[info exists enbID]} {
                     set globaleNBId "\{${eNBType}ENB_ID=$enbID\}"
                  }
               }
               # If the value of ERABs is not null then generate it
               if {$ERABs != ""} {
                    if {[regexp ";" $ERABs]} {
                         set noofElms [llength [split [lindex [split $ERABs ;] 0] ,] ]
                    } else {
                         set noofElms [llength [split $ERABs ,]]
                    }
                    if {$noofElms > 2} {
                         # The user may specify exactly want IE he wants to include or exclude
                         # In that case pass what the user has entered
                         set paramIndices $ERABs
                    } else {
                         set paramIndices ""
                         foreach erab [split $ERABs ";"] {
                              foreach {noOfeRabs starteRabId} [split $erab ,] {break}
                              set eRabId       1 ;#include IE
                              set eRabQos      1 ;#include IE
                              set address      0 ;#exclude IE
                              set gtpTeid      0 ;#exclude IE
                              set nas          1 ;#include IE
                              set corrId       0 ;#exclude IE
                              lappend paramIndices "$noOfeRabs,$starteRabId,$eRabId,$eRabQos,$address,$gtpTeid,$nas,$corrId"
                         }
                         set paramIndices [join $paramIndices ";"]
                    }
                    set ERABs        [generateIEs -IEType "ERABs" -paramIndices $paramIndices -HeNBIndex $HeNBIndex -MMEIndex $MMEIndex]
               }
               
               if {[info exists UEAggMaxBitRate]} {set UEAggMaxBitRate [generateIEs -IEType "UEAggrBitRate" -paramIndices $UEAggMaxBitRate -HeNBIndex $HeNBIndex -MMEIndex $MMEIndex]}
               #Update the dynamic variables
               if {$operation == "send"} {
                    set simType "MME"
                    set paramList [list vENBUES1APId MMEUES1APId mStreamId mmeUEId]
               } else {
                    set simType "HeNB"
                    set paramList [list eNBUES1APId vENBUES1APId streamId mmeUEId]
               }
          }
          "response" {
               set mandatoryIEs "MMEUES1APId eNBUES1APId ERABs"

               set gwIp   [getDataFromConfigFile "henbSignalingIpaddress" 0 ]
               set HeNBId [getFromTestMap -HeNBIndex $HeNBIndex -param "HeNBId"]

               parseArgs args \
                         [list \
                         [list eRABsFailedToSetup   optional   "string"     "__UN_DEFINED__"    "The number of E-RAB failed to setup" ] \
                         ]
               
               # If the value of ERABs is not null then generate it
               if {$ERABs != ""} {
                    foreach {noOfeRabs starteRabId} [split $ERABs ,] {break}
                    set eRabId       1 ;#include IE
                    set eRabQos      0 ;#exclude IE
                    set address      0 ;#exclude IE
                    set gtpTeid      0 ;#exclude IE
                    set nas          0 ;#exclude IE
                    set corrId       0 ;#exclude IE
                    set paramIndices "$noOfeRabs,$starteRabId,$eRabId,$eRabQos,$address,$gtpTeid,$nas,$corrId"
                    set ERABs        [generateIEs -IEType "ERABs" -paramIndices $paramIndices -HeNBIndex $HeNBIndex -MMEIndex $MMEIndex]
               }
               
               # Generate the eRAB fail list
               if {[info exists eRABsFailedToSetup]} {
                    set eRabList   [generateIEs -IEType "eRABsList" -paramIndices $eRABsFailedToSetup -HeNBIndex $HeNBIndex -MMEIndex $MMEIndex]
               }
               
               set HeNBId [getFromTestMap -HeNBIndex $HeNBIndex -param "HeNBId"]
               
               #If the user has specified the criticalDiag, create the Critical Diags IE structure
               if {[info exists criticalityDiag]} {
                    set criticDiag [updateValAndExecute "getCriticDiag -criticalityDiag criticalityDiag \
                              -procedureCode procedureCode -triggerMsg triggerMsg -procedureCriticality procedureCriticality \
                              -IECriticality IECriticality -IEId IEId -typeOfError typeOfError"]
               }
               
               #Update the dynamic variables
               if {$operation == "send"} {
                    set simType "HeNB"
                    set paramList [list eNBUES1APId vENBUES1APId streamId ueid]
               } else {
                    set simType "MME"
                    set paramList [list vENBUES1APId MMEUES1APId mStreamId mmeUEId]
               }
          }
     }
     
     #Update the dynamic variables
     foreach dynElement {eNBUES1APId MMEUES1APId streamId ueid} param $paramList {
          if {![info exists $dynElement]} {
               #While sending UE data from eNB simulator use the streamId that is one greater then the UEIndex
               if {$param == "streamId"} {
                    set streamId [expr $UEIndex + 1]
                    continue
               }
               if {[catch {set $dynElement [getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "$param"]}]} {
                    print -abort "Failed to get the param $param"
                    return 1
               }
          }
     }
     
     # Unset the IE if not intended to be sent in the message
     foreach mandIE $mandatoryIEs {
          if {[info exists mandIE]} {
               if {[set $mandIE] == ""} {unset $mandIE}
          }
     }
     
     # Since the eRAB request is relayed to the eNB and no info is stored in the UE context table expect the UES1APIDs
     # Will would generate the data only while sending and store it in a global array
     # The contents of the array would be accessed while expecting the message on the peer entity
     # Also few of the params/IEs like the UES1APIDs and streamId would be modified before accessing for verification
     if {$operation == "send"} {
          #Construct the message that has to be sent to the simulator
          set eRabModify [updateValAndExecute "constructS1Procedure -simType simType -msgName msgName -msgType msgType \
                    -HeNBId HeNBId -MMEId MMEId -eNBUES1APId eNBUES1APId -MMEUES1APId MMEUES1APId -UEAggMaxBitRate UEAggMaxBitRate \
                    -eRABsList eRabList -eRAB ERABs -criticalityDiag criticDiag -streamId streamId -gwIp gwIp -gwPort gwPort -globaleNBId globaleNBId"]
          
          #          array set ARR_eRAB_MODIFY $eRabModify
          
          if { [info exists ARR_eRAB_MODIFY($msg)] } { unset -nocomplain ARR_eRAB_MODIFY($msg) }
          set ARR_eRAB_MODIFY($msg) $eRabModify
     } else {
          #          set eRabModify [array get ARR_eRAB_MODIFY]
          set eRabModify $ARR_eRAB_MODIFY($msg)
          foreach msgEle [list eNB_UE_S1AP_ID mME_UE_S1AP_ID StreamNo] updateVar [list eNBUES1APId MMEUES1APId streamId] {
               if {![info exists $updateVar]} {continue}
               if {[regsub "${msgEle}=\[0-9\]+" $eRabModify "${msgEle}=[set $updateVar]" eRabModify] != 1} {
                    print -fail "Failed to update variable $msgEle to [set $updateVar]"
                    return 1
               }
               #               unset -nocomplain ARR_eRAB_MODIFY
          }
          unset -nocomplain ARR_eRAB_MODIFY
     }
     
     print -info "eRabModify $eRabModify"
     if {$execute == "no"} { return "$simType $eRabModify"}
     
     return [updateValAndExecute "sendOrVerifyS1APProcedure -msgName msgName -msgType msgType \
               -operation operation -msgList eRabModify -simType simType -enbID enbID \
               -HeNBIndex HeNBIndex -MMEIndex MMEIndex"]
     
     return 0
}

proc eRABRelease {args} {
     #-
     #- procedure to delete eRABs
     #-
     #-  ------ E-RAB RELEASE COMMAND -------
     #-
     #-  Message Type				M
     #-  MME UE S1AP ID 			M
     #-  eNB UE S1AP ID 			M
     #-  UE Aggregate Maximum Bit Rate		O
     #-  E-RAB to Be Released List              (1..256)
     #-  NAS-PDU				O
     #-
     #- ------ E-RAB RELEASE RESPONSE ------
     #-
     #-   Message Type				M
     #-   MME UE S1AP ID 			M
     #-   eNB UE S1AP ID 			M
     #-   E-RAB Release List                    (0..1)
     #-     > E-RAB Release Item IEs            (1..256)
     #-       >>E-RAB ID			M
     #-   E-RAB Failed to Release List          O
     #-   Criticality Diagnostics		O
     #-
     #- ------ E-RAB RELEASE INDICATION ------
     #-
     #-   Message Type				M
     #-   MME UE S1AP ID 			M
     #-   eNB UE S1AP ID 			M
     #-   E-RAB Released List                   (1..256)
     #-
     #- -------------- IE GENERATION ------------------
     #  USAGE:
     #- *** eRAB
     #-     eRAB {noOfErabs,eRabId}
     #-     eRAB {noOfErabs,e_RAB_ID};{noOfErabs,e_RAB_ID}
     #-
     #- For eRAB Release response
     #- 1. eRAB 1,0         : Release eRAB for 1 eRAB with e_RAB_ID 0
     #- 2. eRAB 2,0;1,10    : Release 3 eRAB with e_RAB_ID 0,1 and 10
     #-
     #- *** eRAB Fail/Release List
     #-     eRAB {noOfErabs,eRabId,causeType,cause}
     #-     eRAB {noOfErabs,eRabId,causeType,cause};{noOfErabs,eRabId,causeType,cause}
     #-
     #- eg
     #- 1. eRABsFailedToSetup/eRABsReleaseList 1,0,misc,control_processing_overload
     #-           : 1 eRABs with e_RAB_ID 0 released or failed to release with cause.misc=control_processing_overload
     #- 2. eRABsFailedToSetup/eRABsReleaseList 1,0,misc,control_processing_overload;2,3,misc,unknown
     #-           : 3 eRABS released or failed to release; eRABID 0 with cause.misc=control_processing_overload
     #-                and eRABID 3 and 4 with cause.misc=unknown
     #-
     #- *** UEAggrBitRate
     #-     UEAggrBitRate {maxBitRateDl,maxBitRateDl}
     #-     UEAggrBitRate 1,1    : Randomly generate maxBitRateDl and maxBitRateDl
     #-     UEAggrBitRate 1,0    : Send only maxBitRateDl IE in UEAggrBitRate
     #-
     #-@return 0 on success, @return -1 on failure
     #-
     
     global ARR_eRAB_RELEASE
     set validMsg          "command|response|indication"
     set defaultCause      "message_not_compatible_with_receiver_state"
     set relCauseType      "misc"
     set relCause          "control_processing_overload"
     
     parseArgs args \
               [list \
               [list msg                  optional   "$validMsg"      "command"           "The message to be sent" ] \
               [list operation            optional   "send|(don't|)expect"  "send"        "send or expect option"] \
               [list execute              optional   "boolean"        "yes"               "To perform the operation or not. if no, will return the message"] \
               [list HeNBIndex            mandatory  "numeric"        ""                  "Index of HeNB whose values need to be retrieved" ] \
               [list UEIndex              mandatory  "numeric"        ""                  "Index of UE whose values need to be retrieved" ] \
               [list MMEIndex             optional   "numeric"        "__UN_DEFINED__"    "Index of MME whose values need to be retrieved" ] \
               [list eNBUES1APId          optional   "string"        "__UN_DEFINED__"    "eNB UE S1AP Id value" ] \
               [list MMEUES1APId          optional   "string"        "__UN_DEFINED__"    "MME UE S1AP Id value" ] \
               [list causeType            optional   "string"         "protocol"          "Identifies the cause choice group"] \
               [list cause                optional   "string"         "$defaultCause"     "Identifies the cause value"] \
               [list criticalityDiag      optional   "string"         "__UN_DEFINED__"    "The critical diag to be enabled or not"] \
               [list procedureCode        optional   "string"         "__UN_DEFINED__"    "The procedure code to be used diag"] \
               [list triggerMsg           optional   "string"         "__UN_DEFINED__"    "Identifies the triggering message"] \
               [list procedureCriticality optional   "string"         "__UN_DEFINED__"    "Identifies the procedure Criticality"] \
               [list IECriticality        optional   "string"         "__UN_DEFINED__"    "Identifies the IE Criticality list"] \
               [list IEId                 optional   "numeric"        "__UN_DEFINED__"    "Identifies the IE Id list"] \
               [list typeOfError          optional   "string"         "__UN_DEFINED__"    "Identifies the type of error list"] \
               [list streamId             optional   "numeric"        "__UN_DEFINED__"    "Defines the streamId assigned" ] \
               ]
     
     set msgName [string map "\
               command    e-rab_release_command \
               response   e-rab_release_response \
               indication e-rab_release_indication " \
               $msg]
     if {[regexp "command|response" $msg]} {
          set msgType "class1"
     } else {
          set msgType "class2"
     }
     
     if {![info exists MMEIndex]} {
          ##getFromTestMap returns MMEIndex incase of load balancing case of S1Flex scenario
          if {[getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "MMEIndex"] != -1} {
               set MMEIndex [getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "MMEIndex"]
               print -info "Using MMEIndex $MMEIndex among load balanced MMEs"
          } else {
               #Keeping default value of 0
               set MMEIndex "0"
               print -info "Using default MMEIndex $MMEIndex"
          }
     } else {
          print -info "Using MMEIndex $MMEIndex passed from script"
     }

     set gwIp   [getDataFromConfigFile "henbSignalingIpaddress" 0 ]
     set gwPort [getDataFromConfigFile "henbSctp" 0 ]

     set MultiS1Link $::ARR_LTE_TEST_PARAMS(MultiS1Link)

     if {$MultiS1Link == "yes"} {
        set enbID [getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "eNBId"]
     }    
     
     switch -regexp $msg {
          "command"  {
               set mandatoryIEs "MMEUES1APId eNBUES1APId eRABsReleaseList"
               set gwIp   [getDataFromConfigFile "mmeSignalingIpaddress" 0 ]
               set MMEId  [getFromTestMap -MMEIndex $MMEIndex -param "MMEId"]
               parseArgs args \
                         [list \
                         [list eRABsReleaseList     optional   "string"     "1,0,$relCauseType,$relCause"  "The eRABs to be released for UE" ] \
                         [list UEAggMaxBitRate      optional   "string"     "__UN_DEFINED__"               "The UE aggregate max bit rate" ] \
                         [list NASLength            optional   "numeric"    "__UN_DEFINED__"               "Define the length of the NAS message" ] \
                         ]
               
               # If the value of ERABs is not null then generate it
               if {$eRABsReleaseList != ""} {
                    set eRabRelList   [generateIEs -IEType "eRABsList" -paramIndices $eRABsReleaseList -HeNBIndex $HeNBIndex -MMEIndex $MMEIndex]
               }
               
               # Generate the UEAggMaxBitRate IE
               if {[info exists UEAggMaxBitRate]} {set UEAggMaxBitRate [generateIEs -IEType "UEAggrBitRate" -paramIndices $UEAggMaxBitRate -HeNBIndex $HeNBIndex -MMEIndex $MMEIndex]}
               
               #Update the dynamic variables
               if {$operation == "send"} {
                    set simType "MME"
                    set paramList [list vENBUES1APId MMEUES1APId mStreamId mmeUEId]

                    if {$MultiS1Link == "yes"} {
                       set eNBType [getFromTestMap -HeNBIndex $HeNBIndex -param "eNBType"]
                       if {! [ info exists eNBType ]} {
                          set eNBType "macro"
                       }
                       if {[info exists enbID]} {
                          set globaleNBId "\{${eNBType}ENB_ID=$enbID\}"
                       }
                    }
               } else {
                    set simType "HeNB"
                    set paramList [list eNBUES1APId vENBUES1APId streamId mmeUEId]
               }
          }
          "response" {
               set mandatoryIEs "MMEUES1APId eNBUES1APId"
               parseArgs args \
                         [list \
                         [list ERABs              optional   "string"     "1,0"               "The number of E-RAB successfully released" ] \
                         [list eRABsFailedToRel   optional   "string"     "__UN_DEFINED__"    "The number of E-RAB failed to setup" ] \
                         ]
               
               # If the value of ERABs is not null then generate it
               if {$ERABs != ""} {
                    foreach {noOfeRabs starteRabId} [split $ERABs ,] {break}
                    set eRabId       1 ;#include IE
                    set eRabQos      0 ;#exclude IE
                    set address      0 ;#exclude IE
                    set gtpTeid      0 ;#exclude IE
                    set nas          0 ;#exclude IE
                    set corrId       0 ;#exclude IE
                    set paramIndices "$noOfeRabs,$starteRabId,$eRabId,$eRabQos,$address,$gtpTeid,$nas,$corrId"
                    set ERABs        [generateIEs -IEType "ERABs" -paramIndices $paramIndices -HeNBIndex $HeNBIndex -MMEIndex $MMEIndex]
               }
               
               set HeNBId [getFromTestMap -HeNBIndex $HeNBIndex -param "HeNBId"]
               # If the value of ERABs is not null then generate it
               if {[info exists eRABsFailedToRel]} {
                    set eRabRelList   [generateIEs -IEType "eRABsList" -paramIndices $eRABsReleaseList -HeNBIndex $HeNBIndex -MMEIndex $MMEIndex]
               }
               
               #If the user has specified the criticalDiag, create the Critical Diags IE structure
               if {[info exists criticalityDiag]} {
                    set criticDiag [updateValAndExecute "getCriticDiag -criticalityDiag criticalityDiag \
                              -procedureCode procedureCode -triggerMsg triggerMsg -procedureCriticality procedureCriticality \
                              -IECriticality IECriticality -IEId IEId -typeOfError typeOfError"]
               }
               
               #Update the dynamic variables
               if {$operation == "send"} {
                    set simType "HeNB"
                    set paramList [list eNBUES1APId vENBUES1APId streamId ueid]
               } else {
                    set simType "MME"
                    set paramList [list vENBUES1APId MMEUES1APId mStreamId mmeUEId]
               }
          }
          "indication" {
               set mandatoryIEs "MMEUES1APId eNBUES1APId eRABsReleaseList"
               parseArgs args \
                         [list \
                         [list eRABsReleaseList   optional   "string"     "1,0,$relCauseType,$relCause"    "The number of E-RAB Released" ] \
                         ]
              
               if {$eRABsReleaseList != ""} {
                    set eRabRelList   [generateIEs -IEType "eRABsList" -paramIndices $eRABsReleaseList -HeNBIndex $HeNBIndex -MMEIndex $MMEIndex]
               }
               
               set HeNBId [getFromTestMap -HeNBIndex $HeNBIndex -param "HeNBId"]
               #Update the dynamic variables
               if {$operation == "send"} {
                    set simType "HeNB"
                    set paramList [list eNBUES1APId vENBUES1APId streamId ueid]
               } else {
                    set simType "MME"
                    set paramList [list vENBUES1APId MMEUES1APId mStreamId mmeUEId]
               }
               
          }
     }
     
     #Update the dynamic variables
     foreach dynElement {eNBUES1APId MMEUES1APId streamId ueid} param $paramList {
          if {![info exists $dynElement]} {
               #While sending UE data from eNB simulator use the streamId that is one greater then the UEIndex
               if {$param == "streamId"} {
                    set streamId [expr $UEIndex + 1]
                    continue
               }
               if {[catch {set $dynElement [getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "$param"]}]} {
                    print -abort "Failed to get the param $param"
                    return 1
               }
          }
     }
     
     # Unset the IE if not intended to be sent in the message
     foreach mandIE $mandatoryIEs {
          if {[info exists mandIE]} {
               if {[set $mandIE] == ""} {unset $mandIE}
          }
     }
     
     # Since the eRAB request is relayed to the eNB and no info is stored in the UE context table expect the UES1APIDs
     # Will would generate the data only while sending and store it in a global array
     # The contents of the array would be accessed while expecting the message on the peer entity
     # Also few of the params/IEs like the UES1APIDs and streamId would be modified before accessing for verification
     if {$operation == "send"} {
          #Construct the message that has to be sent to the simulator
          set eRabRelease [updateValAndExecute "constructS1Procedure -simType simType -msgName msgName -msgType msgType \
                    -HeNBId HeNBId -MMEId MMEId -eNBUES1APId eNBUES1APId -MMEUES1APId MMEUES1APId -UEAggMaxBitRate UEAggMaxBitRate \
                    -eRABsList eRabRelList -eRAB ERABs -criticalityDiag criticDiag -streamId streamId -gwIp gwIp -gwPort gwPort -globaleNBId globaleNBId"]
          
          #      array set ARR_eRAB_RELEASE $eRabRelease
          if { [info exists ARR_eRAB_RELEASE($msg) ] } {unset -nocomplain ARR_eRAB_RELEASE($msg)}
          set ARR_eRAB_RELEASE($msg) $eRabRelease
     } else {
          #          set eRabRelease [array get ARR_eRAB_RELEASE]
          set eRabRelease $ARR_eRAB_RELEASE($msg)
          foreach msgEle [list eNB_UE_S1AP_ID mME_UE_S1AP_ID StreamNo] updateVar [list eNBUES1APId MMEUES1APId streamId] {
               if {![info exists $updateVar]} {continue}
               if {[regsub "${msgEle}=\[0-9\]+" $eRabRelease "${msgEle}=[set $updateVar]" eRabRelease] != 1} {
                    print -fail "Failed to update variable $msgEle to [set $updateVar]"
                    return 1
               }
               #               unset -nocomplain ARR_eRAB_RELEASE
          }
          unset -nocomplain ARR_eRAB_RELEASE($msg)
     }
     
     print -info "eRabRelease $eRabRelease"
     if {$execute == "no"} { return "$simType $eRabRelease"}
     
     return [updateValAndExecute "sendOrVerifyS1APProcedure -msgName msgName -msgType msgType \
               -operation operation -msgList eRabRelease -simType simType -enbID enbID \
               -HeNBIndex HeNBIndex -MMEIndex MMEIndex"]
     
     return 0
}

proc handoverRequired {args} {
     #-
     #- The purpose of the Handover Preparation procedure is to request the preparation of resources at the target side via the EPC.
     #- There is only one Handover Preparation procedure ongoing at the same time for a certain UE.
     #- The source eNB initiates the handover preparation by sending the HANDOVER REQUIRED message to the serving MME
     #-
     #-    Message Type				M
     #-    MME UE S1AP ID			M
     #-    eNB UE S1AP ID			M
     #-    Handover Type			M
     #-    Cause				M
     #-    Target ID				M
     #-    Direct Forwarding Path Availability	O
     #-    SRVCC HO Indication			O
     #-    Source to Target Transparent Container	M
     #-    Source to Target Transparent Container Secondary	O
     #-    MS Classmark 2			C-ifSRVCCtoGERAN
     #-    MS Classmark 3			C-ifSRVCCtoGERAN
     #-    CSG Id				O
     #-    Cell Access Mode			O
     #-    PS Service Not Available		O
     #-
     
     global ARR_HO_REQUIRED
     set msgName   "handover_required"
     set msgType   "class1"
     set validHandoverType      "INTRALTE"
     set defaultCause           "authentication_failure"
     set validSRVCCHOInd        "psandcs"
     set validSrcToTgtTransCont "ae98"
     set validTargetIds         "enb|rnc|cgi"
     
     parseArgs args \
               [list \
               [list operation            optional   "send|(don't|)expect"  "send"              "send or expect option"] \
               [list execute              optional   "boolean"              "yes"               "To perform the operation or not"] \
               [list HeNBIndex            mandatory  "numeric"              ""                  "Index of HeNB whose values need to be retrieved" ] \
               [list UEIndex              mandatory  "numeric"              ""                  "Index of UE whose values need to be retrieved" ] \
               [list MMEIndex             optional   "numeric"              "__UN_DEFINED__"    "Index of MME whose values need to be retrieved" ] \
               [list eNBUES1APId          optional   "string"               "__UN_DEFINED__"    "eNB UE S1AP Id value" ] \
               [list MMEUES1APId          optional   "string"               "__UN_DEFINED__"    "MME UE S1AP Id value" ] \
               [list handoverType         optional   "$validHandoverType"   "INTRALTE"          "The handover type" ] \
               [list causeType            optional   "string"         	    "nas"               "Identifies the cause choice group"] \
               [list cause                optional   "string"         	    "$defaultCause"     "Identifies the cause value"] \
               [list targetId             optional   "$validTargetIds"      "enb"               "Identifies the target of the handover"] \
               [list DFPAvailability      optional   "string"         	    "__UN_DEFINED__"    "Identifies the direct forwarding path in handover"] \
               [list SRVCCHOIndication    optional   "$validSRVCCHOInd"     "__UN_DEFINED__"    "Identifies the SRVCC HO Indication"] \
               [list srcToTgtTransCont    optional   "string"               "0,0"           "Identifies the source to target container"] \
               [list srcToTgtTransCont2   optional   "string"               "__UN_DEFINED__" "Identifies the secondary source to target container"] \
               [list MSClassmark2         optional   "string"         	    "__UN_DEFINED__"    "Identifies the MS classmark 2"] \
               [list MSClassmark3         optional   "string"         	    "__UN_DEFINED__"    "Identifies the MS classmark 3"] \
               [list CSGId                optional   "string"      	    "__UN_DEFINED__"    "CSGId value from UE" ] \
               [list CellAccessMode       optional   "string"      	    "__UN_DEFINED__"    "Cell Access Mode value from UE" ] \
               [list PSServiceNA          optional   "string"      	    "__UN_DEFINED__"    "Indicates UE is not available for PS service" ] \
               [list streamId             optional   "numeric"              "__UN_DEFINED__"    "Defines the streamId assigned" ] \
               [list gwIp                 optional   "string"               "__UN_DEFINED__"    "cocurrent warning msg indicator in wr-rep-warn msg" ] \
               [list gwPort               optional   "string"               "__UN_DEFINED__"    "cocurrent warning msg indicator in wr-rep-warn msg" ] \
               ]
     
     if {![info exists MMEIndex]} {
          ##getFromTestMap returns MMEIndex incase of load balancing case of S1Flex scenario
          if {[getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "MMEIndex"] != -1} {
               set MMEIndex [getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "MMEIndex"]
               print -info "Using MMEIndex $MMEIndex among load balanced MMEs"
          } else {
               #Keeping default value of 0
               set MMEIndex "0"
               print -info "Using default MMEIndex $MMEIndex"
          }
     } else {
          print -info "Using MMEIndex $MMEIndex passed from script"
     }
     
     # Define the mandatory arguments
     set mandatoryIEs "MMEUES1APId eNBUES1APId handoverType causeType cause targetId srcToTgtTransCont"
     set HeNBId   [getFromTestMap -HeNBIndex $HeNBIndex -param "HeNBId"]
     set gwIp   [getDataFromConfigFile "henbSignalingIpaddress" 0 ]
     set gwPort [getDataFromConfigFile "henbSctp" 0 ]

     
     # Update the dynamic variables
     if {$operation == "send"} {
          set simType "HeNB"
          set paramList [list eNBUES1APId vENBUES1APId streamId ueid]
     } else {
          set simType "MME"
          set paramList [list vENBUES1APId MMEUES1APId mStreamId mmeUEId]
   
          set MultiS1Link $::ARR_LTE_TEST_PARAMS(MultiS1Link)

          if {$MultiS1Link == "yes"} {
             set enbID [getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "eNBId"]
          }   
     }
     
     # Update the dynamic variables
     foreach dynElement {eNBUES1APId MMEUES1APId streamId ueid} param $paramList {
          if {![info exists $dynElement]} {
               # While sending UE data from eNB simulator use the streamId that is one greater then the UEIndex
               if {$param == "streamId"} {
                    set streamId [expr $UEIndex + 1]
                    continue
               }
               if {[catch {set $dynElement [getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "$param"]}]} {
                    print -abort "Failed to get the param $param"
                    return 1
               }
          }
     }
     
     # Unset the IE if not intended to be sent in the message
     foreach mandIE $mandatoryIEs {
          if {[info exists $mandIE]} {
               if {[set $mandIE] == ""} {unset $mandIE}
          }
     }
     
     foreach structIE [list targetId srcToTgtTransCont srcToTgtTransCont2] {
          if {[info exists $structIE]} {
               if {[set $structIE] != ""} {
                    switch -regexp $structIE {
                         "srcToTgtTransCont" {
                              set eCGI [generateIEs -IEType "eCGI" -paramIndices "$srcToTgtTransCont" -HeNBIndex $HeNBIndex -MMEIndex $MMEIndex -UEIndex $UEIndex]
                              #set srcToTgtTransCont "{rRC_Container=01020304 targetCell_ID=$eCGI uE_HistoryInformation={e_UTRAN_Cell={cellType={cell_Size=VERYSMALL} global_Cell_ID={cell_ID=0 pLMNidentity={MCC=120 MNC=110}} time_UE_StayedInCell=0}}}"
                              set srcToTgtTransCont "{rRC_Container=01020304 targetCell_ID=$eCGI uE_HistoryInformation={uTRAN_Cell=01}}"
                         }
                         "targetId" {
                              switch $targetId {
                                   "enb" {
                                        parseArgs args \
                                                  [list \
                                                  [list enbId             optional   "string"    "x,x"    "Identifies the enb target index of the handover"] \
                                                  ]
                                        #enbId is target enbId index
                                        foreach {henbIndex taiInd} [split $enbId ","] { break }
                                        set globalEnbId [generateIEs -IEType "globalEnbId" -paramIndices $henbIndex ]

                                        if {$henbIndex == "x"} {
                                           set eNBType  "macro"
                                           set henbId   [random 65000]
                                           set henbMnc   [getRandomUniqueListInRange 10 999]
                                           set henbMcc   [getRandomUniqueListInRange 100  999]

               				} else {
                    			   set eNBType  [getFromTestMap -HeNBIndex $paramIndices -param "eNBType"]
                    			   set henbId   [getFromTestMap -HeNBIndex $paramIndices -param "HeNBId"]
                    			   set henbMnc   [lindex [lindex [getFromTestMap -HeNBIndex $paramIndices -param "MNC"] 0] 0]
                                           set henbMcc   [lindex [lindex [getFromTestMap -HeNBIndex $paramIndices -param "MCC"] 0] 0]
                                        }

                                        set globalEnbId "{mcc=$henbMcc mnc=$henbMnc ${eNBType}enbid=$henbId}"
                                        set tai         [generateIEs -IEType "tgtTai" -HeNBIndex $henbIndex -paramIndices $taiInd ]
                                        set targetId "{targeteNB_ID={global_ENB_ID={eNB_ID={macroENB_ID=$henbId} pLMNidentity={MCC=$henbMcc MNC=$henbMnc}} selected_TAI=$tai}}"
                                        
                                   }
                                   "rnc" {
                                   }
                                   "cgi" {
                                   }
                              }
                         }
                         "srcToTgtTransCont2" {
                         }
                    }
               }
          }
     }
     
     if {$operation == "send"} {
          
          if {[info exists causeType] && [info exists cause]} {
             set causeVal "\{$causeType=$cause\}"
          }

          # Construct the message that has to be sent to the simulator
          set handoverRequired [updateValAndExecute "constructS1Procedure -simType simType -msgName msgName -msgType msgType \
                    -HeNBId HeNBId -ueid ueid -eNBUES1APId eNBUES1APId -MMEUES1APId MMEUES1APId \
                    -handoverType handoverType -cause causeVal -targetId targetId \
                    -DFPathAvail DFPAvailability -srvccHOIndication SRVCCHOIndication \
                    -srcToTgtTransContainer srcToTgtTransCont srcToTgtTransContainer2 srcToTgtTransCont2 \
                    -MSClassMask2 MSClassmark2 -MSClassMask3 MSClassMask3 -CSGIdList CSGId \
                    -cellAccessMode CellAccessMode -PSService PSServiceNA -streamId streamId -gwIp gwIp -gwPort gwPort"]
          
          array set ARR_HO_REQUIRED $handoverRequired
     } else {
          #To be removed once srcToTgtContainer simulator output is in format
          set handoverRequired [array get ARR_HO_REQUIRED]
          foreach msgEle [list eNB_UE_S1AP_ID mME_UE_S1AP_ID StreamNo] updateVar [list eNBUES1APId MMEUES1APId streamId] {
               if {![info exists $updateVar]} {continue}
               if {[regsub "${msgEle}=\[0-9\]+" $handoverRequired "${msgEle}=[set $updateVar]" handoverRequired] != 1} {
                    print -fail "Failed to update variable $msgEle to [set $updateVar]"
                    return 1
               }
               unset -nocomplain ARR_HO_REQUIRED
          }
     }
     
     print -info "handoverRequired $handoverRequired"
     if {$execute == "no"} { return "$simType $handoverRequired"}
     
     return [updateValAndExecute "sendOrVerifyS1APProcedure -msgName msgName -msgType msgType \
               -operation operation -msgList handoverRequired -simType simType -enbID enbID \
               -HeNBIndex HeNBIndex -MMEIndex MMEIndex"]
     
     return 0
}

proc handoverCommand {args} {
     #-
     #- The purpose of the Handover Preparation procedure is to request the preparation of resources at the target side via the EPC.
     #- There is only one Handover Preparation procedure ongoing at the same time for a certain UE.
     #- When the preparation, including the reservation of resources at the target side is ready,
     #- the MME responds with the HANDOVER COMMAND message to the source eNB
     #-
     #-    Message Type				M
     #-    MME UE S1AP ID			M
     #-    eNB UE S1AP ID			M
     #-    Handover Type			M
     #-    NAS Security Parameters from E-UTRAN	C-iftoUTRANGERAN
     #-    E-RABs Subject to Forwarding List   (0 - 1)
     #-      >E-RABs Subject to Forwarding Item IEs (1 to <maxnoof E-RABs>)
     #-        >>E-RAB ID			M
     #-        >>DL Transport Layer Address	O
     #-        >>DL GTP-TEID			O
     #-        >>UL Transport Layer Address	O
     #-        >>UL GTP-TEID			O
     #-    E-RABs to Release List		O
     #-    Target to Source Transparent Container	        M
     #-    Target to Source Transparent Container Secondary	O
     #-    Criticality Diagnostics			        O
     #-
     #-   ---------------- IE USAGE ----------------
     #-  1. E-RABs Subject to Forwarding Item IEs
     #-      (noOfErabs erabStartId e_RAB_ID dladdress dlGtpTeid uladdress ulGtpTeid)
     #-  Usage:
     #-    -ERABsSubjectToFI 2        : 2 ERABS to be setup starting with erab id 0 with default sub IEs
     #-    -ERABsSubjectToFI 2,3      : 2 ERABS to be setup starting with erab id 3 with default sub IEs
     #-    -ERABsSubjectToFI 2,1;3,6  : 5 ERABS to be setup for erabs 1,2 and 6,7,8 with default sub IEs
     #-    -ERABsSubjectToFI 2,9,1,0,1,1,0 : 2 ERABS to be setup for erabs 9 and 10 with granular control on sub IEs
     #-                                      only erabid, dlGtpTeid and uladdress would be used as part of IE generation
     #-
     #-
     #-  2. E-RABs to Release List
     #-     (noOfErabs eRabId causeType cause)
     #-  Usage:
     #-    -ERABsReleaseList 1,1,misc,unknown : Release a single erab with id 1 with cause.misc=unknown
     #-    -ERABsReleaseList 1,1,misc,unknown;1,8,misc,unknown :
     #-        Release 2 erabs with id 1 and 8 with cause.misc=unknown
     #-
     
     global ARR_HO_COMMAND
     set msgName   "handover_command"
     set msgType   "class1"
     set validHandoverType      "ltetoutran"
     
     parseArgs args \
               [list \
               [list operation            optional   "send|(don't|)expect"  "send"              "send or expect option"] \
               [list execute              optional   "boolean"              "yes"               "To perform the operation or not"] \
               [list HeNBIndex            mandatory  "numeric"              ""                  "Index of HeNB whose values need to be retrieved" ] \
               [list UEIndex              mandatory  "numeric"              ""                  "Index of UE whose values need to be retrieved" ] \
               [list MMEIndex             optional   "numeric"              "__UN_DEFINED__"    "Index of MME whose values need to be retrieved" ] \
               [list eNBUES1APId          optional   "string"               "__UN_DEFINED__"    "eNB UE S1AP Id value" ] \
               [list MMEUES1APId          optional   "string"               "__UN_DEFINED__"    "MME UE S1AP Id value" ] \
               [list handoverType         optional   "$validHandoverType"   "ltetoutran"        "The handover type" ] \
               [list NASSecurityParam     optional   "string"               "__UN_DEFINED__"    "Defines the NAS security param for handover" ] \
               [list ERABsSubjectToFI     optional   "string"               "2,0"               "Defines the ERABs subject to Forwarding Items IEs" ] \
               [list ERABsReleaseList     optional   "string"               "__UN_DEFINED__"    "Defines the ERABs to be released" ] \
               [list tgtToSrcTransCont    optional   "string"               "012345"             "Identifies the source to target container"] \
               [list tgtToSrcTransCont2   optional   "string"               "__UN_DEFINED__"    "Identifies the secondary source to target container"] \
               [list criticalityDiag      optional   "string"               "__UN_DEFINED__"    "The critical diag to be enabled or not"] \
               [list procedureCode        optional   "string"               "__UN_DEFINED__"    "The procedure code to be used diag"] \
               [list triggerMsg           optional   "string"               "__UN_DEFINED__"    "Identifies the triggering message"] \
               [list procedureCriticality optional   "string"               "__UN_DEFINED__"    "Identifies the procedure Criticality"] \
               [list IECriticality        optional   "string"               "__UN_DEFINED__"    "Identifies the IE Criticality list"] \
               [list IEId                 optional   "numeric"              "__UN_DEFINED__"    "Identifies the IE Id list"] \
               [list typeOfError          optional   "string"               "__UN_DEFINED__"    "Identifies the type of error list"] \
               [list streamId             optional   "numeric"              "__UN_DEFINED__"    "Defines the streamId assigned" ] \
               ]
     
     if {![info exists MMEIndex]} {
          ##getFromTestMap returns MMEIndex incase of load balancing case of S1Flex scenario
          if {[getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "MMEIndex"] != -1} {
               set MMEIndex [getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "MMEIndex"]
               print -info "Using MMEIndex $MMEIndex among load balanced MMEs"
          } else {
               #Keeping default value of 0
               set MMEIndex "0"
               print -info "Using default MMEIndex $MMEIndex"
          }
     } else {
          print -info "Using MMEIndex $MMEIndex passed from script"
     }
     
     # Define the mandatory arguments
     set mandatoryIEs "MMEUES1APId eNBUES1APId handoverType ERABsSubjectToFI tgtToSrcTransCont"
     
     # For IEs which itself is a structure, construct it only if the user has defined the variable
     foreach structIE [list ERABsSubjectToFI ERABsReleaseList criticalityDiag] {
          if {[info exists $structIE]} {
               if {[set $structIE] != ""} {
                    switch -regexp $structIE {
                         "ERABsSubjectToFI"   {set $structIE [generateIEs -IEType "ERABsForwardingItem" -paramIndices $ERABsSubjectToFI -HeNBIndex $HeNBIndex -MMEIndex $MMEIndex -UEIndex $UEIndex]}
                         "ERABsReleaseList"   {set $structIE [generateIEs -IEType "eRABsList" -paramIndices $ERABsReleaseList -HeNBIndex $HeNBIndex -MMEIndex $MMEIndex -UEIndex $UEIndex]}
                         "criticalityDiag"    {
                              set criticalDiag [updateValAndExecute "getCriticDiag -criticalityDiag criticalityDiag \
                                        -procedureCode procedureCode -triggerMsg triggerMsg -procedureCriticality procedureCriticality \
                                        -IECriticality IECriticality -IEId IEId -typeOfError typeOfError"]
                         }
                    }
               }
          }
     }


     set MultiS1Link $::ARR_LTE_TEST_PARAMS(MultiS1Link)

     if {$MultiS1Link == "yes"} {
        set enbID [getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "eNBId"]
     }   
     
     # Update the dynamic variables
     if {$operation == "send"} {
          set simType "MME"
          set paramList [list vENBUES1APId MMEUES1APId mStreamId mmeUEId]

          if {$MultiS1Link == "yes"} {
             set eNBType [getFromTestMap -HeNBIndex $HeNBIndex -param "eNBType"]
             if {! [ info exists eNBType ]} {
                set eNBType "macro"
             }
             if {[info exists enbID]} {
                set globaleNBId "\{${eNBType}ENB_ID=$enbID\}"
             }
          }

     } else {
          set simType "HeNB"
          set paramList [list eNBUES1APId vENBUES1APId streamId ueid]
     }
     
     # Update the dynamic variables
     foreach dynElement {eNBUES1APId MMEUES1APId streamId ueid} param $paramList {
          if {![info exists $dynElement]} {
               # While sending UE data from eNB simulator use the streamId that is one greater then the UEIndex
               if {$param == "streamId"} {
                    set streamId [expr $UEIndex + 1]
                    continue
               }
               if {[catch {set $dynElement [getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "$param"]}]} {
                    print -abort "Failed to get the param $param"
                    return 1
               }
          }
     }
     
     # Unset the IE if not intended to be sent in the message
     foreach mandIE $mandatoryIEs {
          if {[info exists $mandIE]} {
               if {[set $mandIE] == ""} {unset $mandIE}
          }
     }
      
     set gwIp   [getDataFromConfigFile "mmeSignalingIpaddress" 0 ]
     set gwPort [getDataFromConfigFile "henbSctp" 0 ]
     set MMEId  [getFromTestMap -MMEIndex $MMEIndex -param "MMEId"]
 
     if {$operation == "send"} {
          # Construct the message that has to be sent to the simulator
          set handoverCommand [updateValAndExecute "constructS1Procedure -simType simType -msgName msgName -msgType msgType \
                    -HeNBId HeNBId -MMEId MMEId -eNBUES1APId eNBUES1APId -MMEUES1APId MMEUES1APId -globaleNBId globaleNBId \
                    -handoverType handoverType -nasSecurityParams NASSecurityParam -eRAB ERABsSubjectToFI \
                    -eRABsList ERABsReleaseList -tgtToSrcTransContainer tgtToSrcTransCont -tgtToSrcTransContainer2 tgtToSrcTransCont2 \
                    -criticalityDiag criticalDiag -streamId streamId -gwIp gwIp -gwPort gwPort"]
          
          array set ARR_HO_COMMAND $handoverCommand
     } else {
          set handoverCommand [array get ARR_HO_COMMAND]
          foreach msgEle [list eNB_UE_S1AP_ID mME_UE_S1AP_ID StreamNo] updateVar [list eNBUES1APId MMEUES1APId streamId] {
               if {![info exists $updateVar]} {continue}
               if {[regsub "${msgEle}=\[0-9\]+" $handoverCommand "${msgEle}=[set $updateVar]" handoverCommand] != 1} {
                    print -fail "Failed to update variable $msgEle to [set $updateVar]"
                    return 1
               }
               unset -nocomplain ARR_HO_COMMAND
          }
     }
     
     print -info "handoverCommand $handoverCommand"
     if {$execute == "no"} { return "$simType $handoverCommand"}
     
     return [updateValAndExecute "sendOrVerifyS1APProcedure -msgName msgName -msgType msgType \
               -operation operation -msgList handoverCommand -simType simType -enbID enbID \
               -HeNBIndex HeNBIndex -MMEIndex MMEIndex"]
     
     return 0
}

proc handoverPrepFailure {args} {
     #-
     #- If the EPC or the target system is not able to accept any of the bearers or a failure occurs during the Handover Preparation,
     #- the MME sends the HANDOVER PREPARATION FAILURE message with an appropriate cause value to the source eNB.
     #-
     #-    Message Type	        M
     #-    MME UE S1AP ID	M
     #-    eNB UE S1AP ID	M
     #-    Cause	        M
     #-    Criticality Diagnostics	O
     #-
     
     global ARR_HO_PREP_FAILURE
     set msgName   "handover_preparation_failure"
     set msgType   "class1"
     set defaultCause "control_processing_overload"
     
     parseArgs args \
               [list \
               [list operation            optional   "send|(don't|)expect"  "send"              "send or expect option"] \
               [list execute              optional   "boolean"              "yes"               "To perform the operation or not"] \
               [list HeNBIndex            mandatory  "numeric"              ""                  "Index of HeNB whose values need to be retrieved" ] \
               [list UEIndex              mandatory  "numeric"              ""                  "Index of UE whose values need to be retrieved" ] \
               [list MMEIndex             optional   "numeric"              "__UN_DEFINED__"    "Index of MME whose values need to be retrieved" ] \
               [list eNBUES1APId          optional   "string"               "__UN_DEFINED__"    "eNB UE S1AP Id value" ] \
               [list MMEUES1APId          optional   "string"               "__UN_DEFINED__"    "MME UE S1AP Id value" ] \
               [list causeType            optional   "string"               "misc"              "Identifies the cause choice group"] \
               [list cause                optional   "string"               "$defaultCause"     "Identifies the cause value"] \
               [list criticalityDiag      optional   "string"               "__UN_DEFINED__"    "The critical diag to be enabled or not"] \
               [list procedureCode        optional   "string"               "__UN_DEFINED__"    "The procedure code to be used diag"] \
               [list triggerMsg           optional   "string"               "__UN_DEFINED__"    "Identifies the triggering message"] \
               [list procedureCriticality optional   "string"               "__UN_DEFINED__"    "Identifies the procedure Criticality"] \
               [list IECriticality        optional   "string"               "__UN_DEFINED__"    "Identifies the IE Criticality list"] \
               [list IEId                 optional   "numeric"              "__UN_DEFINED__"    "Identifies the IE Id list"] \
               [list typeOfError          optional   "string"               "__UN_DEFINED__"    "Identifies the type of error list"] \
               [list streamId             optional   "numeric"              "__UN_DEFINED__"    "Defines the streamId assigned" ] \
               [list gwIp                 optional   "string"               "__UN_DEFINED__"    "cocurrent warning msg indicator in wr-rep-warn msg" ] \
               [list gwPort               optional   "string"               "__UN_DEFINED__"    "cocurrent warning msg indicator in wr-rep-warn msg" ] \

               ]
     
     if {![info exists MMEIndex]} {
          ##getFromTestMap returns MMEIndex incase of load balancing case of S1Flex scenario
          if {[getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "MMEIndex"] != -1} {
               set MMEIndex [getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "MMEIndex"]
               print -info "Using MMEIndex $MMEIndex among load balanced MMEs"
          } else {
               #Keeping default value of 0
               set MMEIndex "0"
               print -info "Using default MMEIndex $MMEIndex"
          }
     } else {
          print -info "Using MMEIndex $MMEIndex passed from script"
     }
     
     # Define the mandatory arguments
     set mandatoryIEs "MMEUES1APId eNBUES1APId causeType cause"
     
     if {[info exists criticalityDiag]} {
          set criticalDiag [updateValAndExecute "getCriticDiag -criticalityDiag criticalityDiag \
                    -procedureCode procedureCode -triggerMsg triggerMsg -procedureCriticality procedureCriticality \
                    -IECriticality IECriticality -IEId IEId -typeOfError typeOfError"]
     }
     set HeNBId [getFromTestMap -HeNBIndex $HeNBIndex -param "HeNBId"]

     set MultiS1Link $::ARR_LTE_TEST_PARAMS(MultiS1Link)

     if {$MultiS1Link == "yes"} {
        set enbID [getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "eNBId"]
     }  

     # Update the dynamic variables
     if {$operation == "send"} {
          set simType "MME"
          set paramList [list vENBUES1APId MMEUES1APId mStreamId mmeUEId]

          if {$MultiS1Link == "yes"} {
             set eNBType [getFromTestMap -HeNBIndex $HeNBIndex -param "eNBType"]
             if {! [ info exists eNBType ]} {
                set eNBType "macro"
             }
             if {[info exists enbID]} {
                set globaleNBId "\{${eNBType}ENB_ID=$enbID\}"
             }
          }

     } else {
          set simType "HeNB"
          set paramList [list eNBUES1APId vENBUES1APId streamId ueid]
     }
     
     # Update the dynamic variables
     foreach dynElement {eNBUES1APId MMEUES1APId streamId ueid} param $paramList {
          if {![info exists $dynElement]} {
               # While sending UE data from eNB simulator use the streamId that is one greater then the UEIndex
               if {$param == "streamId"} {
                    set streamId [expr $UEIndex + 1]
                    continue
               }
               if {[catch {set $dynElement [getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "$param"]}]} {
                    print -abort "Failed to get the param $param"
                    return 1
               }
          }
     }
     
     # Unset the IE if not intended to be sent in the message
     foreach mandIE $mandatoryIEs {
          if {[info exists $mandIE]} {
               if {[set $mandIE] == ""} {unset $mandIE}
          }
     }

     set gwIp   [getDataFromConfigFile "mmeSignalingIpaddress" 0 ]
     set gwPort [getDataFromConfigFile "henbSctp" 0 ]
     set MMEId  [getFromTestMap -MMEIndex $MMEIndex -param "MMEId"]

     
     if {[info exists causeType] && [info exists cause]} {
        set causeVal "\{$causeType=$cause\}"
     }
 
          # Construct the message that has to be sent to the simulator
          set handoverPrepFailure [updateValAndExecute "constructS1Procedure -simType simType -msgName msgName -msgType msgType \
                    -MMEId MMEId -ueid ueid -eNBUES1APId eNBUES1APId -MMEUES1APId MMEUES1APId -globaleNBId  globaleNBId \
                    -cause causeVal -criticalityDiag criticalDiag -streamId streamId -gwIp gwIp -gwPort gwPort"]
          
          #array set ARR_HO_PREP_FAILURE $handoverPrepFailure
          #set handoverPrepFailure [array get ARR_HO_PREP_FAILURE]
          #foreach msgEle [list eNB_UE_S1AP_ID mME_UE_S1AP_ID StreamNo cause] updateVar [list eNBUES1APId MMEUES1APId streamId causeVal] {
          #     if {![info exists $updateVar]} {continue}
          #     if {[regsub "${msgEle}=\[0-9\]+" $handoverPrepFailure "${msgEle}=[set $updateVar]" handoverPrepFailure] != 1} {
          #          print -fail "Failed to update variable $msgEle to [set $updateVar]"
          #          return 1
          #     }
          #     unset -nocomplain ARR_HO_PREP_FAILURE
          #}
     
     print -info "handoverPrepFailure $handoverPrepFailure"
     if {$execute == "no"} { return "$simType $handoverPrepFailure"}
     
     return [updateValAndExecute "sendOrVerifyS1APProcedure -msgName msgName -msgType msgType \
               -operation operation -msgList handoverPrepFailure -simType simType -enbID enbID \
               -HeNBIndex HeNBIndex -MMEIndex MMEIndex"]
     
     return 0
}

proc handoverRequest {args} {
     #-
     #- The purpose of the Handover Resource Allocation procedure is to reserve resources at the target eNB for the handover of a UE
     #-
     #- The MME initiates the procedure by sending the HANDOVER REQUEST message to the target eNB
     #-
     #- After all necessary resources for the admitted E-RABs have been allocated the target eNB generates the HANDOVER REQUEST ACKNOWLEDGE message
     #-
     #- If the target eNB does not admit at least one non-GBR E-RAB, or a failure occurs during the Handover Preparation,
     #- it shall send the HANDOVER FAILURE message to the MME with an appropriate cause value
     #-
     #-    ------ HANDOFF_REQUEST ------
     #-    Message Type				M
     #-    MME UE S1AP ID			M
     #-    Handover Type			M
     #-    Cause				M
     #-    UE Aggregate Maximum Bit Rate	M
     #-    E-RABs To Be Setup List
     #-      >E-RABs To Be Setup Item IEs
     #-        >>E-RAB ID 			M
     #-        >>Transport Layer Address	M
     #-        >>GTP-TEID			M
     #-        >>E-RAB Level QoS Parameters	M
     #-        >>Data Forwarding Not Possible	O
     #-    Source to Target Transparent Container	M
     #-    UE Security Capabilities		M
     #-    Handover Restriction List		O
     #-    Trace Activation			O
     #-    Request Type				O
     #-    SRVCC Operation Possible		O
     #-    Security Context			M
     #-    NAS Security Parameters to E-UTRAN	C-iffromUTRANGERAN
     #-    CSG Id				O
     #-    CSG Membership Status		O
     #-    GUMMEI				O
     #-    MME UE S1AP ID 2			O
     #-
     #-    ------ HANDOVER_REQUEST_ACK ------
     #-    Message Type				M
     #-    MME UE S1AP ID			M
     #-    eNB UE S1AP ID			M
     #-    E-RABs Admitted List
     #-      >E-RABs Admitted Item IEs
     #-        >>E-RAB ID 			M
     #-        >>Transport Layer Address	M
     #-        >>GTP-TEID			M
     #-        >>DL Transport Layer Address	O
     #-        >>DL GTP-TEID	    		O
     #-        >>UL Transport Layer Address	O
     #-        >>UL GTP-TEID			O
     #-    E-RABs Failed to Setup List		O
     #-    Target to Source Transparent Container	M
     #-    CSG Id				O
     #-    Criticality Diagnostics		O
     #-
     #-    ------ HANDOFF_FAILURE ------
     #-    Message Type				M
     #-    MME UE S1AP ID			M
     #-    Cause				M
     #-    Criticality Diagnostics		O
     #-
     #-   ---------------- IE USAGE ----------------
     #
     #-  1. E-RABs To Be Setup List in HANDOVER_REQUEST
     #-      (noOfErabs erabStartId e_RAB_ID address GTPTEID ErabLevelQosInfo DataForwardingNotPossible)
     #-
     #-  Usage:
     #-    -ERABsToBeSetupHOReq 2        : 2 ERABS to be setup starting with erab id 0 with default sub IEs
     #-    -ERABsToBeSetupHOReq 2,3      : 2 ERABS to be setup starting with erab id 3 with default sub IEs
     #-    -ERABsToBeSetupHOReq 2,1;3,6  : 5 ERABS to be setup for erabs 1,2 and 6,7,8 with default sub IEs
     #-    -ERABsToBeSetupHOReq 2,9,1,0,1,1,0 : 2 ERABS to be setup for erabs 9 and 10 with granular control on sub IEs
     #-                                      only erabid, gtpid and ErabLevelQosInfo would be included
     #-    -ERABsToBeSetupHOReq 2,9,1,0,1,1,0,;1,3,1,0,1,1,0 : 3 ERABS to be setup for erabs 9 and 10 and 3 with granular control on sub IEs
     #-
     #-
     #-  2. E-RABs Admitted Item IEs in HANDOVER_REQUEST_ACK
     #-      (noOfErabs erabStartId e_RAB_ID transportlayeraddr gtpteid dl_transportlayeraddr dlgtpteid ul_transportlayeraddr ulgtpteid)
     #-
     #-  Usage:
     #-    -ERABsAdmittedList 2        : 2 ERABS to be setup starting with erab id 0 with default sub IEs
     #-    -ERABsAdmittedList 2,3      : 2 ERABS to be setup starting with erab id 3 with default sub IEs
     #-    -ERABsAdmittedList 2,1;3,6  : 5 ERABS to be setup for erabs 1,2 and 6,7,8 with default sub IEs
     #-    -ERABsToBeSetupHOReq 2,9,1,0,1,1,0,1,0 : 2 ERABS to be setup for erabs 9 and 10 with granular control on sub IEs
     #-                                      only erabid, gtpteid dl_transportlayeraddr and ul_transportlayeraddr would be used as part of IE generation
     #-    -ERABsAdmittedList 2,9,1,0,1,1,0,1,0;1,3,1,0,1,1,0,1,0 : 3 ERABS to be setup for erabs 9 and 10 and 3 with granular control on sub IEs
     #-
     #-
     #-  3. E-RABs to Release List
     #-     (noOfErabs eRabId causeType cause)
     #-  Usage:
     #-    -ERABsFailedToSetup 1,1,misc,unknown : erab setup failed a single erab with id 1 with cause.misc=unknown
     #-    -ERABsFailedToSetup 1,1,misc,unknown;1,8,misc,unknown :
     #-        erab setup failed for 2 erabs with id 1 and 8 with cause.misc=unknown
     #-
     #-
     #-  4  UESecCapability
     #-     (encryptionAlgorithms integrityProtectionAlgorithms)
     #-  Usage:
     #-    -UESecCapability 1,1 :
     #-       Will create IE having both encryptionAlgorithms and integrityProtectionAlgorithms
     #-       The values for the above IEs are randomly selected from a list of supported ones
     #-
     #-
     #-  5. UEAggrBitRate
     #-     (maxBitRateDl maxBitRateDl)
     #-  Usage:
     #-      UEAggrBitRate 1,1 :
     #-       Will create IE having both maxBitRateDl and maxBitRateDl
     #-       The values for these IEs are genearted in a predective random method
     #-
     #-  6. SecurityContext
     #-     (nexthopchainingcount securityKey)
     #-  Usage:
     #-      SecurityContext 10,123456
     #-
     #-  7. requestType
     #-     (eventType reportArea)
     #-  Usage:
     #-      requestType direct,ecgi
     #-
     #- 8. srcToTgtTransCont
     #- Usage:
     #-      (henbIndex,plmnIndex)
     #-    srcToTgtTransCont "0,0" will put eCGI value of HeNBIndex 0 with bcPLMN 0
     #-    srcToTgtTransCont "x,x" will put random eCGI value
     #-
     
     global ARR_HO_REQUEST
     global ARR_HO_ACK
     global ARR_HO_FAIL
     set validMsg "request|ack|failure"
     set msgType   "class1"
     set defaultCause      "control_processing_overload"
     set validHandoverType "IntraLTE|LTEtoUTRAN|LTEtoGERAN|UTRANtoLTE|GERANtoLTE"
     set validSrvccOp      "possible"
     set validTraceDepth   "minimum|medium|maximum|MinimumWithoutVendorSpecificExtension|MediumWithoutVendorSpecificExtension|MaximumWithoutVendorSpecificExtension"
     set traceIp           [getDataFromConfigFile "henbBearerIpaddress" 0]
     set nexthopchainingcount [random 7]
     set securityKey          [randomDataString 64 allDigits]
     set defaultSC            "$nexthopchainingcount,$securityKey"
     
     parseArgs args \
               [list \
               [list msg                  optional   "$validMsg"            "request"           "The message to be sent" ] \
               [list operation            optional   "send|(don't|)expect"  "send"              "send or expect option"] \
               [list execute              optional   "boolean"              "yes"               "To perform the operation or not"] \
               [list HeNBIndex            mandatory  "numeric"              ""                  "Index of HeNB whose values need to be retrieved" ] \
               [list UEIndex              mandatory  "numeric"              ""                  "Index of UE whose values need to be retrieved" ] \
               [list MMEIndex             optional   "numeric"              "0"                 "Index of MME whose values need to be retrieved" ] \
               [list eNBUES1APId          optional   "string"               "__UN_DEFINED__"    "eNB UE S1AP Id value" ] \
               [list MMEUES1APId          optional   "string"               "__UN_DEFINED__"    "MME UE S1AP Id value" ] \
               [list handoverType         optional   "$validHandoverType"   "IntraLTE"          "The handover type" ] \
               [list causeType            optional   "string"               "misc"              "Identifies the cause choice group"] \
               [list cause                optional   "string"               "$defaultCause"     "Identifies the cause value"] \
               [list UEAggMaxBitRate      optional   "string"               "1,1"               "The UE aggregate max bit rate" ] \
               [list ERABsToBeSetupHOReq  optional   "string"               "1,0"               "The ERABs to be setup during handover" ] \
               [list srcToTgtTransCont    optional   "string"               "0,0"           "Identifies the source to target container"] \
               [list UESecurityCap        optional   "string"               "1,1"               "The UE security capability to be used" ] \
               [list servingPLMN          optional   "string"               "__UN_DEFINED__"    "serving PLMN in Hand over Restriction List" ] \
               [list equivalPLMN          optional   "string"               "__UN_DEFINED__"    "equivalent PLMNs in Hand over Restriction List" ] \
               [list forbiddenTA          optional   "string"               "__UN_DEFINED__"    "forbidden TAs in Hand over Restriction List" ] \
               [list forbiddenLA          optional   "string"               "__UN_DEFINED__"    "forbidden LAs in Hand over Restriction List" ] \
               [list forbiddenInterRATs   optional   "string"               "__UN_DEFINED__"    "forbidden Inter RATs in Hand over Restriction List" ] \
               [list traceActivation      optional   "boolean"              "__UN_DEFINED__"    "The trace activation to be enabled" ] \
               [list eURTANTraceId        optional   "string"               "[random 99999999]" "The trace id to be enabled" ] \
               [list intToTrace           optional   "string"               "50"                "The interface to be traced" ] \
               [list traceDepth           optional   "$validTraceDepth"     "maximum"           "The trace depth to be used" ] \
               [list traceIp              optional   "ip"                   "$traceIp"          "The trace ip to be used" ] \
               [list MDTConfig            optional   "string"               "__UN_DEFINED__"    "The MDT configuration for trace" ] \
               [list requestType          optional   "string"               "__UN_DEFINED__"    "The request type in the handover request" ] \
               [list SRVCCOperation       optional   "$validSrvccOp"        "__UN_DEFINED__"    "Defines the SRVCC operation" ] \
               [list securityContext      optional   "string"               "$defaultSC"        "Defines the Security context" ] \
               [list nasSecurityParams    optional   "string"               "__UN_DEFINED__"    "Defines the NAS Security param to UTRAN" ] \
               [list CSGId                optional   "string"               "__UN_DEFINED__"    "The CSGId param to be used in HeNB"] \
               [list CSGMembershipStatus  optional   "string"               "__UN_DEFINED__"    "Defines the CSG membership status" ] \
               [list GUMMEI               optional   "string"               "__UN_DEFINED__"    "GUMMEI from UE of format gummeiInd,plmnInd,mmecInd,mmegiInd" ] \
               [list MMEUES1APId2         optional   "string"               "__UN_DEFINED__"    "Defines the MMEUES1APId assigned by MME" ] \
               [list ERABsAdmittedList    optional   "string"               "1,0"               "Defines the ERAB Admit list" ] \
               [list ERABsFailedToSetup   optional   "string"               "__UN_DEFINED__"    "The number of E-RAB failed to setup" ] \
               [list tgtToSrcTransCont    optional   "string"               "123456"           "Identifies the source to target container"] \
               [list criticalityDiag      optional   "string"               "__UN_DEFINED__"    "The critical diag to be enabled or not"] \
               [list procedureCode        optional   "string"               "__UN_DEFINED__"    "The procedure code to be used diag"] \
               [list triggerMsg           optional   "string"               "__UN_DEFINED__"    "Identifies the triggering message"] \
               [list procedureCriticality optional   "string"               "__UN_DEFINED__"    "Identifies the procedure Criticality"] \
               [list IECriticality        optional   "string"               "__UN_DEFINED__"    "Identifies the IE Criticality list"] \
               [list IEId                 optional   "numeric"              "__UN_DEFINED__"    "Identifies the IE Id list"] \
               [list typeOfError          optional   "string"               "__UN_DEFINED__"    "Identifies the type of error list"] \
               [list streamId             optional   "numeric"              "__UN_DEFINED__"    "Defines the streamId assigned" ] \
               [list isHeNB               optional   "boolean"        "__UN_DEFINED__"    "Identifies the type of eNB"] \
               ]
     
     set msgName [string map "\
               request handover_request \
               ack     handover_request_ackowledge \
               failure handover_failure" $msg]

     # For a Macro eNB the HeNBGW should not forward the MMEUES1APID2 and GUMMEI IE in the Initial Context Setup request
     if {[info exists ::IS_HENB] && ![info exists isHeNB]} {
          set isHeNB 1
     } else {
          set isHeNB 0
     }
     ## Not extracting MMEIndex from load balanced scenario, as this is first msg initiated by MME itself
     ## Even for ack and fail MMEIndex doesnt depend on load balanced scenario
    
     if {$operation == "send"} {
          set simType "MME"
     } else {
          set simType "HeNB"
          if {$isHeNB} {
               # SRS-HeNBGW-CP-414
               # With this requirement in mind the HeNBGw would send GUMMEI IE irrespective of the fact it was received from MME or not
               # The value of which would be the first entities from RAT0
               print -debug "Setting GUMMEI and MMEUES1APId2"
               set GUMMEI "0,0,0,0"
               set MMEUES1APId2 [getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "MMEUES1APId"]
          }
     }
     set HeNBId   [getFromTestMap -HeNBIndex $HeNBIndex -param "HeNBId"]
     switch -regexp $msg {
          "request" {
               # Define the mandatory arguments
               set mandatoryIEs "MMEUES1APId causeType cause handoverType ERABsToBeSetupHOReq UEAggMaxBitRate srcToTgtTransCont UESecurityCap securityContext"
               
               # For IEs which itself is a structure, construct it only if the user has defined the variable
               foreach structIE [list UEAggMaxBitRate ERABsToBeSetupHOReq UESecurityCap traceActivation GUMMEI securityContext requestType srcToTgtTransCont] {
                    if {[info exists $structIE]} {
                         if {[set $structIE] != ""} {
                              switch -regexp $structIE {
                                   "UEAggMaxBitRate|ERABsToBeSetupHOReq|UESecurityCap"  {
                                        set IEType    [string map "UEAggMaxBitRate UEAggrBitRate ERABsToBeSetupHOReq ERABsSetupItem UESecurityCap UESecCapability" $structIE]
                                        set $structIE [generateIEs -IEType "$IEType" -paramIndices [set $structIE] -HeNBIndex $HeNBIndex -MMEIndex $MMEIndex]
                                   }
                                   "traceActivation"     {
                                        foreach simVar [list eutrantraceid interfacestotrace address tracedepth MDTconfig] \
                                                  procVar [list eURTANTraceId intToTrace traceIp traceDepth MDTConfig] {
                                                       if {[info exists $procVar]} {
                                                            if {$procVar == "MDTConfig"} {
                                                                 set MDTConfig [generateIEs -IEType "MDTConfig" -paramIndices "" -HeNBIndex $HeNBIndex -MMEIndex $MMEIndex -UEIndex $UEIndex]
                                                            }
                                                            append TraceActivation "$simVar=[set $procVar] "
                                                       }
                                                  }
                                        set TraceActivation "{$TraceActivation}"
                                   }
                                   "GUMMEI"          {
                                        if {$simType == "MME"} {
                                             set GUMMEI          [generateIEs -IEType "GUMMEI" -paramIndices $GUMMEI -HeNBIndex $HeNBIndex -MMEIndex $MMEIndex]
                                        } else {
                                             set gPlmn ""
                                             foreach \
                                                       gMcc [getFromTestMap -MMEIndex $MMEIndex -GUMMEIIndex 0 -param "MCC"] \
                                                       gMnc [getFromTestMap -MMEIndex $MMEIndex -GUMMEIIndex 0 -param "MNC"] {
                                                            lappend gPlmn [createLteIdentifier -identifier PLMNId -MCC $gMcc -MNC $gMnc]
                                                       }
                                             foreach {mc2 mc1 mn1 mc3 mn3 mn2} [split [lindex [lsort $gPlmn] 0] ""] {break}
                                             set gMcc   "${mc1}${mc2}${mc3}"
                                             set gMnc   "${mn1}${mn2}${mn3}"
                                             set gMmec  [lindex [lsort [getFromTestMap -MMEIndex $MMEIndex -GUMMEIIndex 0 -param "MMECode"]] 0]
                                             set gMmegi [lindex [lsort [getFromTestMap -MMEIndex $MMEIndex -GUMMEIIndex 0 -param "MMEGroupId"]] 0]
                                             set GUMMEI "{mME_Code=$gMmec mME_Group_ID=$gMmegi pLMN_Identity={MCC=$gMcc MNC=$gMnc}}"
                                             print -debug "Using GUMMEI: $GUMMEI for verification of HeNB"
                                        }

                                   }
                                   "securityContext" {
                                        foreach {NextHopChainingCount securityKey} [split $securityContext ,] {break}
                                        set securityContext "{nextHopChainingCount=$NextHopChainingCount nextHopParameter=$securityKey}"
                                   }
                                   "requestType" {
                                        foreach {eventType reportArea} [split $requestType ,] {break}
                                        set requestType "{eventType=$eventType reportArea=$reportArea}"
                                   }
                                   "srcToTgtTransCont" {
                                        set eCGI [generateIEs -IEType "eCGI" -paramIndices "$srcToTgtTransCont" -HeNBIndex $HeNBIndex -MMEIndex $MMEIndex -UEIndex $UEIndex]
                                        #Need to check on MCC and MNC values.. right hardcoded 400 and 260
                                        set srcToTgtTransCont "{targetCell_ID=$eCGI rRC_Container=01020304  uE_HistoryInformation={e_UTRAN_Cell={cellType={cell_Size=verysmall} global_Cell_ID={cell_ID=0 pLMNidentity={MCC=400 MNC=260}} time_UE_StayedInCell=0}}}"
                                   }
                              }
                         }
                    }
               }
               #Construct the handover restriction list
               if {[info exists servingPLMN] && [info exists equivalPLMN] && [info exists forbiddenTA] && [info exists forbiddenLA] && [info exists forbiddenInterRATs] } {
                    set serPLMN  [generateIEs -IEType "servingPLMN" -paramIndices $servingPLMN -HeNBIndex $HeNBIndex -MMEIndex $MMEIndex]
                    set equiPLMN [generateIEs -IEType "equivalPLMN" -paramIndices $equivalPLMN -HeNBIndex $HeNBIndex -MMEIndex $MMEIndex]
                    set forbiTA  [generateIEs -IEType "forbiddenTA" -paramIndices $forbiddenTA -HeNBIndex $HeNBIndex -MMEIndex $MMEIndex]
                    set forbiLA  [generateIEs -IEType "forbiddenLA" -paramIndices $forbiddenLA -HeNBIndex $HeNBIndex -MMEIndex $MMEIndex]
                    set handOverRestriction "{[concat $serPLMN $equiPLMN forbiddeninterrats=$forbiddenInterRATs forbiddenlas=$forbiLA forbiddentas=$forbiTA]}"
               }
               
               # Define the dynamic variables that would be later updated
               if {$operation == "send"} {
                    # Since the handover request is the first UE message sent from the MME we need to explicitly create UE context on the MME simulator
                    # The UE context creation requires user to pass the stream and the UE id for the user
                    if {![info exists streamId]} {set streamId [expr $UEIndex + 1]}
                   
                    #set ueid [expr $UEIndex + 1]
                    #UEIndex + 1 can't be used incase of calls for multipleHeNBs
                    set ueid     [getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "ueid"]
                    set result [createDummyUE -streamid $streamId -ueId $ueid  -simType "MME" -MMEIndex $MMEIndex]
                    if {$result != 0} {
                         print -fail "UE creation failed on the MME simulator"
                         return -1
                    } else {
                         print -info "Successfully created a dummy UE context on the MME simulator"
                         
                    }
                    set simType "MME"
                    set paramList  [list MMEUES1APId mmeUEId]
                    set dynEleList [list MMEUES1APId ueid]
                    
                    set params [list [list mmeUEId $ueid] [list mStreamId $streamId]]
                    print -info "Updating the mmeUEId and mStreamId for HeNB=$HeNBIndex UE=$UEIndex with value $ueid"
                    set result [updateLteParamData -HeNBIndex $HeNBIndex -MMEIndex $MMEIndex -UEIndex $UEIndex -paramList $params]
                    
               } elseif {$operation == "expect"} {
                    set simType "HeNB"
                    set paramList  [list vENBUES1APId ueid]
                    set dynEleList [list MMEUES1APId  ueid]
                    
                    if {![info exists MMEUES1APId]} {
                         set MMEUES1APId [getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "MMEUES1APId"]
                    }
                    
                    set state "update"
                    foreach updVar [list vENBUES1APId hStreamId] {
                         # to verify the MMEUEID received on the simulator we need to update the virtual MME UE S1ID generated by the GW
                         set result [updateValAndExecute "verifyUEContext -HeNBIndex HeNBIndex -MMEIndex MMEIndex \
                                   -UEIndex UEIndex -state state -updateVar updVar -MMEUES1APId MMEUES1APId"]
                         if {$result < 0} {
                              print -fail "Updation of the $updVar failed cant continue"
                              return -1
                         }
                    }
                    
                    #Updating the correct MMEUES1APId to be expected on HeNB
                    set MMEUES1APId [getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "vENBUES1APId"]
                    set HeNBId   [getFromTestMap -HeNBIndex $HeNBIndex -param "HeNBId"]
                    set ueid     [getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "ueid"]
                    set streamId [getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "hStreamId"]
                    set result [createDummyUE -streamid $streamId -ueId $ueid  -simType "HeNB" -henbid $HeNBId]
                    if {$result != 0} {
                         print -fail "UE creation failed on the MME simulator"
                         return -1
                    } else {
                         print -info "Successfully created a dummy UE context on the MME simulator"
                         
                    }
                    
               } elseif {$operation == "don'texpect"} {
                    set simType "HeNB"
                    set paramList ""
                    set dynEleList ""
               }
          }
          "ack|failure" {
               # Define the mandatory arguments
               if {$msg == "ack"} {
                    set mandatoryIEs "MMEUES1APId eNBUES1APId ERABsAdmittedList tgtToSrcTransCont"
                    # For IEs which itself is a structure, construct it only if the user has defined the variable
                    foreach structIE [list ERABsAdmittedList ERABsFailedToSetup] {
                         if {[info exists $structIE]} {
                              if {[set $structIE] != ""} {
                                   set IEType    [string map "ERABsAdmittedList ERABsAdmittedItem ERABsFailedToSetup eRABsList" $structIE]
                                   set $structIE [generateIEs -IEType "$IEType" -paramIndices [set $structIE] -HeNBIndex $HeNBIndex -MMEIndex $MMEIndex]
                              }
                         }
                    }
                    # Define the dynamic variables that would be later updated
                    if {$operation == "send"} {
                         set simType "HeNB"
                         set paramList  [list eNBUES1APId vENBUES1APId streamId ueid]
                         set dynEleList [list eNBUES1APId MMEUES1APId streamId ueid]
                         set HeNBId     [getFromTestMap -HeNBIndex $HeNBIndex -param "HeNBId"]
                    } else {
                         set simType "MME"
                         set paramList [list vENBUES1APId MMEUES1APId streamId mmeUEId]
                         set dynEleList [list eNBUES1APId MMEUES1APId streamId ueid]
                    }
               } else {
                    set mandatoryIEs "MMEUES1APId causeType cause"
                    # Define the dynamic variables that would be later updated
                    if {$operation == "send"} {
                         set simType "HeNB"
                         set paramList  [list vENBUES1APId streamId ueid]
                         set dynEleList [list MMEUES1APId streamId ueid]
                    } else {
                         set simType "MME"
                         set paramList [list MMEUES1APId streamId mmeUEId]
                         set dynEleList [list MMEUES1APId streamId ueid]
                    }
               }
               
               if {[info exists criticalityDiag]} {
                    set criticalityDiag [updateValAndExecute "getCriticDiag -criticalityDiag criticalityDiag \
                              -procedureCode procedureCode -triggerMsg triggerMsg -procedureCriticality procedureCriticality \
                              -IECriticality IECriticality -IEId IEId -typeOfError typeOfError"]
               }
          }
     }
     
     # Update the dynamic variables
     foreach dynElement $dynEleList param $paramList {
          if {![info exists $dynElement]} {
               # While sending UE data from eNB simulator use the streamId that is one greater then the UEIndex
               if {$param == "streamId"} {
                    set streamId [expr $UEIndex + 1]
                    continue
               }
               if {[catch {set $dynElement [getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "$param"]}]} {
                    print -abort "Failed to get the param $param"
                    return 1
               }
          }
     }
     
     # Unset the IE if not intended to be sent in the message
     foreach mandIE $mandatoryIEs {
          if {[info exists $mandIE]} {
               if {[set $mandIE] == ""} {unset $mandIE}
          }
     }
     
     #This is required when message sent is different from the subsequent message expect
     set hoArrName [string map "\
               request ARR_HO_REQUEST \
               ack ARR_HO_ACK \
               failure ARR_HO_FAIL" $msg]
     
     print -info "hoArrName $hoArrName"

     set gwIp   [getDataFromConfigFile "henbSignalingIpaddress" 0 ]
     set gwPort [getDataFromConfigFile "henbSctp" 0 ]
     set MMEId  [getFromTestMap -MMEIndex $MMEIndex -param "MMEId"]

     if {[info exists causeType] && [info exists cause]} { 
        set causeVal "\{$causeType=$cause\}"
     }

     if {$operation == "send" || [regexp "expect" $operation] && ![array exists $hoArrName]} {
          # Construct the message that has to be sent to the simulator
          switch $msg {
               "request" {
                    set gwIp   [getDataFromConfigFile "mmeSignalingIpaddress" 0 ]
                    set handoverMsg [updateValAndExecute "constructS1Procedure -simType simType -msgName msgName -msgType msgType \
                              -MMEId MMEId  -MMEUES1APId MMEUES1APId -cause causeVal -criticalityDiag criticalityDiag \
                              -handoverType handoverType -UEAggMaxBitRate UEAggMaxBitRate -srcToTgtTransContainer srcToTgtTransCont -UESecurityCap UESecurityCap \
                              -handOverRestriction handOverRestriction -TraceActivation TraceActivation -handoverReqType requestType \
                              -srvccOperation SRVCCOperation -securityContext securityContext -NASSecParamsToEutran nasSecurityParams \
                              -CSGIdList CSGId -CSGMembershipStatus CSGMembershipStatus -GUMMEI GUMMEI -MMEUES1APId2 MMEUES1APId2 \
                              -eRAB ERABsToBeSetupHOReq -streamId streamId -gwIp gwIp -gwPort gwPort"]
                    if {$operation == "send" } {
                         array set ARR_HO_REQUEST $handoverMsg
                    }
               }
               "ack" {
                    set handoverMsg [updateValAndExecute "constructS1Procedure -simType simType -msgName msgName -msgType msgType \
                              -HeNBId HeNBId -ueid ueid -eNBUES1APId eNBUES1APId -MMEUES1APId MMEUES1APId \
                              -eRABsAdmitList ERABsAdmittedList -eRABsFailList ERABsFailedToSetup -CSGIdList CSGId \
                              -tgtToSrcTransContainer tgtToSrcTransCont -criticalityDiag criticalityDiag -streamId streamId -gwIp gwIp -gwPort gwPort"]
                    if {$operation == "send" } {
                         array set ARR_HO_ACK $handoverMsg
                    }
               }
               "failure" {
                    set handoverMsg [updateValAndExecute "constructS1Procedure -simType simType -msgName msgName -msgType msgType \
                              -HeNBId HeNBId -ueid ueid -MMEUES1APId MMEUES1APId -cause causeVal \
                              -criticalityDiag criticalityDiag -streamId streamId -gwIp gwIp -gwPort gwPort"]
                    if {$operation == "send" } {
                         array set ARR_HO_FAIL $handoverMsg
                    }
               }
          }
          
     } else {
          set handoverMsg [array get $hoArrName]
          foreach msgEle [list eNB_UE_S1AP_ID mME_UE_S1AP_ID StreamNo] updateVar [list eNBUES1APId MMEUES1APId streamId] {
               if {![info exists $updateVar]} {continue}
               print -debug "msgEle: $msgEle : $handoverMsg"
               if {[regsub "${msgEle}=\[0-9\]+" $handoverMsg "${msgEle}=[set $updateVar]" handoverMsg] != 1} {
                    print -fail "Failed to update variable $msgEle to [set $updateVar]"
                    return 1
               }
               # SRS-HeNBGW-CP-414
               # Since these values may not be generated while constructing the input we need to expicitly specify while expecting
               # This is only applicable for MacroENB
               if {$msgEle == "StreamNo" && $isHeNB && $msg == "request"} {
                    if {[info exists GUMMEI]} {
                         if {[regexp "gUMMEI_ID=\{" $handoverMsg]} {
                              regsub "gUMMEI_ID=\{.*mmegroupid=\[0-9]+\} " $handoverMsg "gUMMEI_ID=$GUMMEI " handoverMsg
                         } else {
                              regsub "${msgEle}=[set $updateVar]" $handoverMsg "${msgEle}=[set $updateVar] gUMMEI_ID=$GUMMEI " handoverMsg
                         }
                    }
                    if {[info exists MMEUES1APId2]} {
                         if {[regexp "mME_UE_S1AP_ID_2=" $handoverMsg]} {
                              regsub "mME_UE_S1AP_ID_2=\[0-9\]+" $handoverMsg "mME_UE_S1AP_ID_2=$MMEUES1APId2" handoverMsg
                         } else {
                              regsub "${msgEle}=[set $updateVar]" $handoverMsg "${msgEle}=[set $updateVar] mME_UE_S1AP_ID_2=$MMEUES1APId2 " handoverMsg
                         }
                    }
               }
               unset -nocomplain $hoArrName
          }

          if {[info exists causeType] && [info exists cause] && $msg != "ack"} {
             if {![regexp "cause=" $handoverMsg]} {
                regsub "${msgEle}=[set $updateVar]" $handoverMsg "${msgEle}=[set $updateVar] cause=$causeVal " handoverMsg
             }  else {
                 regsub "cause=\{\[a-z\]+=(\[a-z\]*(_)*\[0-9\]*)*\} " $handoverMsg "cause=$causeVal " handoverMsg
             }
          }
     }

     print -info "handoverMsg $handoverMsg"
     if {$execute == "no"} { return "$simType $handoverMsg"}
     
     return [updateValAndExecute "sendOrVerifyS1APProcedure -msgName msgName -msgType msgType \
               -operation operation -msgList handoverMsg -simType simType \
               -HeNBIndex HeNBIndex -MMEIndex MMEIndex"]
     
     return 0
}

proc handoverNotify {args} {
     #-
     #- The purpose of the Handover Notification procedure is to indicate to the MME that the UE has arrived to the target cell
     #- and the S1 handover has been successfully completed
     #- The target eNB shall send the HANDOVER NOTIFY message to the MME when the UE has been identified in the target cell
     #- and the S1 handover has been successfully completed
     #-
     #-    Message Type		M
     #-    MME UE S1AP ID	M
     #-    eNB UE S1AP ID	M
     #-    E-UTRAN CGI		M
     #-    TAI			M
     #-
     
     global ARR_HO_NOTIFY
     set msgName "handover_notify"
     set msgType "class1"
     
     parseArgs args \
               [list \
               [list operation            optional   "send|(don't|)expect"  "send"              "send or expect option"] \
               [list execute              optional   "boolean"              "yes"               "To perform the operation or not"] \
               [list HeNBIndex            mandatory  "numeric"              ""                  "Index of HeNB whose values need to be retrieved" ] \
               [list UEIndex              mandatory  "numeric"              ""                  "Index of UE whose values need to be retrieved" ] \
               [list MMEIndex             optional   "numeric"              "0"                 "Index of MME whose values need to be retrieved" ] \
               [list eNBUES1APId          optional   "string"               "__UN_DEFINED__"    "eNB UE S1AP Id value" ] \
               [list MMEUES1APId          optional   "string"               "__UN_DEFINED__"    "MME UE S1AP Id value" ] \
               [list eCGI                 optional   "string"               "0,0"               "e-UTRAN CGI chosen from UE" ] \
               [list TAI                  optional   "string"               "0,0"               "TAI chosen from UE" ] \
               [list streamId             optional   "numeric"              "__UN_DEFINED__"    "Defines the streamId assigned" ] \
               ]
     
     ##Not extracting MMEIndex from load balanced scenario, as this msg doesnt depend on that
     ##Expecting MMEIndex from script itself
     
     # Define the mandatory arguments
     set mandatoryIEs "MMEUES1APId eNBUES1APId eCGI TAI"
     
     # For IEs which itself is a structure, construct it only if the user has defined the variable
     foreach structIE [list eCGI TAI] {
          if {[info exists $structIE]} {
               if {[set $structIE] != ""} {
                    set $structIE [generateIEs -IEType "$structIE" -paramIndices [set $structIE] \
                              -HeNBIndex $HeNBIndex -MMEIndex $MMEIndex -UEIndex $UEIndex]
               }
          }
     }
     
     # Update the dynamic variables
     if {$operation == "send"} {
          set simType "HeNB"
          set paramList [list eNBUES1APId vENBUES1APId streamId ueid]
     } else {
          set simType "MME"
          set paramList [list vENBUES1APId MMEUES1APId mStreamId mmeUEId]
     }
     
     # Update the dynamic variables
     foreach dynElement {eNBUES1APId MMEUES1APId streamId ueid} param $paramList {
          if {![info exists $dynElement]} {
               # While sending UE data from eNB simulator use the streamId that is one greater then the UEIndex
               if {$param == "streamId"} {
                    set streamId [expr $UEIndex + 1]
                    continue
               }
               if {[catch {set $dynElement [getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "$param"]}]} {
                    print -abort "Failed to get the param $param"
                    return 1
               }
          }
     }
     
     # Unset the IE if not intended to be sent in the message
     foreach mandIE $mandatoryIEs {
          if {[info exists $mandIE]} {
               if {[set $mandIE] == ""} {unset $mandIE}
          }
     }
     
     set HeNBId [getFromTestMap -HeNBIndex $HeNBIndex -param "HeNBId"]
     set gwIp   [getDataFromConfigFile "henbSignalingIpaddress" 0 ]
     set gwPort [getDataFromConfigFile "henbSctp" 0 ]
     
     if {$operation == "send"} {
          # Construct the message that has to be sent to the simulator
          set handoverNotify [updateValAndExecute "constructS1Procedure -simType simType -msgName msgName -msgType msgType \
                    -HeNBId HeNBId -ueid ueid -MMEUES1APId MMEUES1APId -eNBUES1APId eNBUES1APId \
                    -TAI TAI -eCGI eCGI -streamId streamId -gwIp gwIp -gwPort gwPort"]
          
          array set ARR_HO_NOTIFY $handoverNotify
     } else {
          set handoverNotify [array get ARR_HO_NOTIFY]
          foreach msgEle [list eNB_UE_S1AP_ID mME_UE_S1AP_ID StreamNo] updateVar [list eNBUES1APId MMEUES1APId streamId] {
               if {![info exists $updateVar]} {continue}
               if {[regsub "${msgEle}=\[0-9\]+" $handoverNotify "${msgEle}=[set $updateVar]" handoverNotify] != 1} {
                    print -fail "Failed to update variable $msgEle to [set $updateVar]"
                    return 1
               }
               unset -nocomplain ARR_HO_NOTIFY
          }
     }
     
     print -info "handoverNotify $handoverNotify"
     if {$execute == "no"} { return "$simType $handoverNotify"}
     
     return [updateValAndExecute "sendOrVerifyS1APProcedure -msgName msgName -msgType msgType \
               -operation operation -msgList handoverNotify -simType simType \
               -HeNBIndex HeNBIndex -MMEIndex MMEIndex"]
     
     return 0
}

proc pathSwitch {args} {
     #-
     #- The purpose of the Path Switch Request procedure is to request the switch of a downlink GTP tunnel towards a new GTP tunnel endpoint.
     #- The eNB initiates the procedure by sending the PATH SWITCH REQUEST message to the MME.
     #-
     #- The MME shall send the PATH SWITCH REQUEST ACKNOWLEDGE message to the eNB and the procedure ends.
     #- The UE-associated logical S1-connection shall be established at reception of the PATH SWITCH REQUEST ACKNOWLEDGE message.
     #-
     #- If the EPC fails to switch the downlink GTP tunnel endpoint towards a new GTP tunnel endpoint for all E-RAB included in the
     #- E-RAB To Be Switched in Downlink List IE during the execution of the Path Switch Request procedure,
     #- the MME shall send the PATH SWITCH REQUEST FAILURE message to the eNB with an appropriate cause value
     #-
     #-    ------ PATH_SWITCH_REQUEST ------
     #-    Message Type				M
     #-    eNB UE S1AP ID			M
     #-    E-RAB To Be Switched in Downlink List
     #-      >E-RABs Switched in Downlink Item IEs
     #-        >>E-RAB ID 			M
     #-        >>Transport layer address	M
     #-        >>GTP-TEID			M
     #-    Source MME UE S1AP ID		M
     #-    E-UTRAN CGI				M
     #-    TAI					M
     #-    UE Security Capabilities		M
     #-    CSG Id				O
     #-    Cell Access Mode			O
     #-    Source MME GUMMEI			O
     #-
     #-    ------ PATH_SWITCH_REQ_ACK ------
     #-    Message Type				M
     #-    MME UE S1AP ID			M
     #-    eNB UE S1AP ID			M
     #-    UE Aggregate Maximum Bit Rate	O
     #-    E-RAB To Be Switched in Uplink List
     #-    >E-RABs Switched in Uplink Item IEs
     #-    >>E-RAB ID				M
     #-    >>Transport Layer Address		M
     #-    >>GTP-TEID				M
     #-    E-RAB To Be Released List		O
     #-    Security Context			M
     #-    Criticality Diagnostics		O
     #-
     #-    ------ PATH_SWITCH_REQ_FAILURE ------
     #-    Message Type				M
     #-    MME UE S1AP ID			M
     #-    eNB UE S1AP ID			M
     #-    Cause				M
     #-    Criticality Diagnostics		O
     #-
     
     global ARR_PATH_REQUEST
     global ARR_PATH_ACK
     global ARR_PATH_FAIL
     set validMsg "request|ack|failure"
     set msgType   "class1"
     set defaultCause "unknown"
     set nexthopchainingcount [random 7]
     set securityKey          [randomDataString 64 allDigits]
     set defaultSC            "$nexthopchainingcount,$securityKey"
     
     parseArgs args \
               [list \
               [list msg                  optional   "$validMsg"            "request"           "The message to be sent" ] \
               [list operation            optional   "send|(don't|)expect"  "send"              "send or expect option"] \
               [list execute              optional   "boolean"              "yes"               "To perform the operation or not"] \
               [list HeNBIndex            mandatory  "numeric"              ""                  "Index of HeNB whose values need to be retrieved" ] \
               [list UEIndex              mandatory  "numeric"              ""                  "Index of UE whose values need to be retrieved" ] \
               [list MMEIndex             optional   "numeric"              "0"                 "Index of MME whose values need to be retrieved" ] \
               [list eNBUES1APId          optional   "string"               "__UN_DEFINED__"    "eNB UE S1AP Id value" ] \
               [list srcMMEUES1APId       optional   "string"               "__UN_DEFINED__"    "Source MME UE S1AP Id value" ] \
               [list ERABsToBeSwitchedDL  optional   "string"               "1,0"               "ERABs to be switched in the DL" ] \
               [list eCGI                 optional   "string"               "0,0"               "e-UTRAN CGI chosen from UE" ] \
               [list TAI                  optional   "string"               "0,0"               "TAI chosen from UE" ] \
               [list UESecurityCap        optional   "string"               "1,1"               "The UE security capability to be used" ] \
               [list CSGId                optional   "string"               "__UN_DEFINED__"    "The CSGId param to be used in HeNB"] \
               [list CellAccessMode       optional   "string"               "__UN_DEFINED__"    "Cell Access Mode value from UE" ] \
               [list srcGUMMEI            optional   "string"               "0,0,0,0"           "The source GUMMEI to be used" ] \
               [list MMEUES1APId          optional   "string"               "__UN_DEFINED__"    "MME UE S1AP Id value from the MME" ] \
               [list UEAggMaxBitRate      optional   "string"               "__UN_DEFINED__"    "The UE aggregate max bit rate" ] \
               [list ERABsToBeSwitchedUL  optional   "string"               "__UN_DEFINED__"    "ERABs to be switched in the UL" ] \
               [list ERABsReleaseList     optional   "string"               "__UN_DEFINED__"    "Defines the ERABs to be released" ] \
               [list securityContext      optional   "string"               "$defaultSC"    "Defines the Security context" ] \
               [list criticalityDiag      optional   "string"               "__UN_DEFINED__"    "The critical diag to be enabled or not"] \
               [list procedureCode        optional   "string"               "__UN_DEFINED__"    "The procedure code to be used diag"] \
               [list triggerMsg           optional   "string"               "__UN_DEFINED__"    "Identifies the triggering message"] \
               [list procedureCriticality optional   "string"               "__UN_DEFINED__"    "Identifies the procedure Criticality"] \
               [list IECriticality        optional   "string"               "__UN_DEFINED__"    "Identifies the IE Criticality list"] \
               [list IEId                 optional   "numeric"              "__UN_DEFINED__"    "Identifies the IE Id list"] \
               [list typeOfError          optional   "string"               "__UN_DEFINED__"    "Identifies the type of error list"] \
               [list causeType            optional   "string"               "nas"          "Identifies the cause choice group"] \
               [list cause                optional   "string"               "authentication_failure"     "Identifies the cause value"] \
               [list streamId             optional   "numeric"              "__UN_DEFINED__"    "Defines the streamId assigned" ] \
               [list isHeNB               optional   "boolean"        "__UN_DEFINED__"    "Identifies the type of eNB"] \
               ]
     
     ##Not extracting MMEIndex from load balanced scenario, as this msg doesnt depend on that
     ##Expecting MMEIndex from script itself
     
     set msgName [string map "\
               request path_switch_request \
               ack     path_switch_request_ackowledge \
               failure path_switch_request_failure" $msg]
     # For a Macro eNB the HeNBGW should not forward the MMEUES1APID2 and GUMMEI IE in the Initial Context Setup request
     if {[info exists ::IS_HENB] && ![info exists isHeNB]} {
          set isHeNB 1
     } else {
          set isHeNB 0
     }
     
     set HeNBId [getFromTestMap -HeNBIndex $HeNBIndex -param "HeNBId"]
     set MMEId  [getFromTestMap -MMEIndex $MMEIndex -param "MMEId"]
     switch -regexp $msg {
          "request" {
               # Define the mandatory arguments
               set mandatoryIEs "eNBUES1APId srcMMEUES1APId ERABsToBeSwitchedDL eCGI TAI UESecurityCap srcGUMMEI"
               
               # For IEs which itself is a structure, construct it only if the user has defined the variable
               foreach structIE [list ERABsToBeSwitchedDL eCGI TAI UESecurityCap srcGUMMEI] {
                    if {[info exists $structIE]} {
                         if {[set $structIE] != ""} {
                              switch -regexp $structIE {
                                   "ERABsToBeSwitchedDL" {
                                        set $structIE [generateIEs -IEType "ERABsSwitchedList"  -paramIndices [set $structIE] \
                                                  -HeNBIndex $HeNBIndex -MMEIndex $MMEIndex -UEIndex $UEIndex]
                                   }
                                   "eCGI|TAI" {
                                        set $structIE [generateIEs -IEType "$structIE" -paramIndices [set $structIE] \
                                                  -HeNBIndex $HeNBIndex -MMEIndex $MMEIndex -UEIndex $UEIndex]
                                   }
                                   "UESecurityCap"  {
                                        set UESecurityCap   [generateIEs -IEType "UESecCapability" -paramIndices $UESecurityCap -HeNBIndex $HeNBIndex -MMEIndex $MMEIndex]
                                   }
                                   "srcGUMMEI" {
                                        set srcGUMMEI [generateIEs -IEType "GUMMEI" -paramIndices $srcGUMMEI -HeNBIndex $HeNBIndex -MMEIndex $MMEIndex]
                                   }
                              }
                         }
                    }
               }

               # Define the dynamic variables that would be later updated
               if {$operation == "send"} {
                    set simType "HeNB"
                    set HeNBId [getFromTestMap -HeNBIndex $HeNBIndex -param "HeNBId"]
                    # Since the pathswitch request is the first UE message sent from the MME we need to explicitly create UE context on the MME simulator
                    # The UE context creation requires user to pass the stream and the UE id for the user
                    set ueid     [getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "ueid"]
                    if {![info exists streamId]} {set streamId [expr $UEIndex + 1]}
                    
                    set result [createDummyUE -streamid $streamId -ueId $ueid -simType "HeNB" -henbid $HeNBId]
                    if {$result != 0} {
                         print -fail "UE creation failed on the MME simulator"
                         return -1
                    } else {
                         print -info "Successfully created a dummy UE context on the MME simulator"
                    }
                    
                    set paramList  [list eNBUES1APId MMEUES1APId streamId ueid]
                    set dynEleList [list eNBUES1APId srcMMEUES1APId streamId ueid]
               } elseif {$operation == "don'texpect"} {
                    set simType "MME"
                    set paramList ""
                    set dynEleList ""
               } else {
                    set simType "MME"
                    # After sending the path switch request message a partial ue context would be created
                    # We need to update the vENBUES1APID for the UE
                    # This is similar to what is done in the initial UE message
                    set updateVar "vENBUES1APId mStreamId"
                    set state "update"
                    
                    #Introducing delay before verifying partial context on GW
                    #halt 0.5
                    
                    # to verify the eNBID received on the simulator we need to update the virtual eNB ID generated by the GW
                    set result [updateValAndExecute "verifyUEContext -HeNBIndex HeNBIndex -MMEIndex MMEIndex \
                              -UEIndex UEIndex -state state -updateVar updateVar -eNBUES1APId eNBUES1APId"]
                    if {$result < 0} {
                         print -fail "Updation of the vENBUES1APId failed cant continue"
                         return -1
                    }
                    
                    #set ueid [expr $UEIndex + 1]
                    set ueid     [getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "ueid"]
                    set streamId [getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "mStreamId"]
                    
                    if {![info exists ::dummyUeId]} {
                         set ueid     [expr $UEIndex + 1]
                         set ::dummyUeId $ueid
                    } else {
                         set ueid    [incr ::dummyUeId]
                    }
                    
                    set result [createDummyUE -streamid $streamId -ueId $ueid -simType "MME" -MMEIndex $MMEIndex]
                    if {$result != 0} {
                         print -fail "UE creation failed on the MME simulator"
                         return -1
                    } else {
                         print -info "Successfully created a dummy UE context on the MME simulator"
                    }
                    
                    set paramList [list [list mmeUEId $ueid]]
                    print -info "Updating the mmeUEId for HeNB=$HeNBIndex UE=$UEIndex with value $ueid"
                    set result [updateLteParamData -HeNBIndex $HeNBIndex -MMEIndex $MMEIndex -UEIndex $UEIndex -paramList $paramList]
                    set paramList  [list vENBUES1APId MMEUES1APId mStreamId ueid]
                    set dynEleList [list eNBUES1APId  srcMMEUES1APId streamId ueid]
               }
          }
          "ack|failure" {
               # Define the mandatory arguments
               if {$msg == "ack"} {
                    set ueid   [getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "mmeUEId"]
                    set mandatoryIEs "MMEUES1APId eNBUES1APId ERABsToBeSwitchedUL securityContext"
                    # For IEs which itself is a structure, construct it only if the user has defined the variable
                    foreach structIE [list ERABsToBeSwitchedUL UEAggMaxBitRate criticalityDiag securityContext] {
                         if {[info exists $structIE]} {
                              if {[set $structIE] != ""} {
                                   switch -regexp $structIE {
                                        "ERABsToBeSwitchedUL" {
                                             set $structIE [generateIEs -IEType "ERABsSwitchedList"  -paramIndices [set $structIE] \
                                                       -HeNBIndex $HeNBIndex -MMEIndex $MMEIndex -UEIndex $UEIndex]
                                        }
                                        "UEAggMaxBitRate" {
                                             set UEAggMaxBitRate [generateIEs -IEType "UEAggrBitRate" -paramIndices $UEAggMaxBitRate -HeNBIndex $HeNBIndex -MMEIndex $MMEIndex]
                                        }
                                        "criticalityDiag" {
                                             set criticalityDiag [updateValAndExecute "getCriticDiag -criticalityDiag criticalityDiag \
                                                       -procedureCode procedureCode -triggerMsg triggerMsg -procedureCriticality procedureCriticality \
                                                       -IECriticality IECriticality -IEId IEId -typeOfError typeOfError"]
                                        }
                                        "securityContext" {
                                             foreach {NextHopChainingCount securityKey} [split $securityContext ,] {break}
                                             set securityContext "{nextHopChainingCount=$NextHopChainingCount nextHopParameter=$securityKey}"
                                        }
                                        "ERABsReleaseList" {set $structIE [generateIEs -IEType "eRABsList" -paramIndices $ERABsReleaseList -HeNBIndex $HeNBIndex -MMEIndex $MMEIndex -UEIndex $UEIndex]
                                        }
                                        
                                   }
                              }
                         }
                    }
               } else {
                    set mandatoryIEs "MMEUES1APId eNBUES1APId causeType cause"
                    # Construct the criticality diag
                    if {[info exists criticalityDiag]} {
                         set criticalityDiag [updateValAndExecute "getCriticDiag -criticalityDiag criticalityDiag \
                                   -procedureCode procedureCode -triggerMsg triggerMsg -procedureCriticality procedureCriticality \
                                   -IECriticality IECriticality -IEId IEId -typeOfError typeOfError"]
                    }
                    
               }
               
               # Define the dynamic variables that would be later updated
               if {$operation == "send"} {
                    set simType "MME"
                    set paramList  [list vENBUES1APId MMEUES1APId mStreamId mmeUEId]
                    set dynEleList [list eNBUES1APId  MMEUES1APId streamId ueid]
               } elseif {$operation == "don'texpect"} {
                    set simType "HeNB"
                    set paramList ""
                    set dynEleList ""
               }   else {
                    if {$isHeNB} {
                         # SRS-HeNBGW-CP-414
                         # With this requirement in mind the HeNBGw would send GUMMEI IE irrespective of the fact it was received from MME or not
                         # The value of which would be the first entities from RAT0
                         print -debug "Setting GUMMEI and MMEUES1APId2"
                         set MMEUES1APId2 [getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "MMEUES1APId"]
                    }
                    
                    set simType "HeNB"
                    set paramList  [list eNBUES1APId vENBUES1APId streamId ueid]
                    set dynEleList [list eNBUES1APId  MMEUES1APId streamId ueid]
               }
          }
          
     }
     
     # Update the dynamic variables
     foreach dynElement $dynEleList param $paramList {
          if {![info exists $dynElement]} {
               # While sending UE data from eNB simulator use the streamId that is one greater then the UEIndex
               if {$param == "streamId"} {
                    set streamId [expr $UEIndex + 1]
                    continue
               }
               if {[catch {set $dynElement [getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "$param"]}]} {
                    print -abort "Failed to get the param $param"
                    return 1
               }
          }
     }
     
     # Unset the IE if not intended to be sent in the message
     foreach mandIE $mandatoryIEs {
          if {[info exists $mandIE]} {
               if {[set $mandIE] == ""} {unset $mandIE}
          }
     }
     
     set psArrName [string map "\
               request ARR_PATH_REQUEST \
               ack ARR_PATH_ACK \
               failure ARR_PATH_FAIL" $msg]

     set gwIp   [getDataFromConfigFile "henbSignalingIpaddress" 0 ]
     set gwPort [getDataFromConfigFile "henbSctp" 0 ]

     if {$operation == "send" || $operation=="expect" && ![array exists $psArrName]} {
          # Construct the message that has to be sent to the simulator
          switch $msg {
               "request" {
                    set pathSwitch [updateValAndExecute "constructS1Procedure -simType simType -msgName msgName -msgType msgType \
                              -HeNBId HeNBId -eNBUES1APId eNBUES1APId -MMEUES1APId srcMMEUES1APId \
                              -eRABsSwitchedDL ERABsToBeSwitchedDL -eCGI eCGI -TAI TAI -UESecurityCap UESecurityCap \
                              -CSGIdList CSGId -cellAccessMode CellAccessMode -GUMMEI srcGUMMEI -streamId streamId \
                              -gwIp gwIp -gwPort gwPort"]
                    if {$operation == "send" } {
                         array set ARR_PATH_REQUEST $pathSwitch
                    }
               }
               "ack" {
                    set pathSwitch [updateValAndExecute "constructS1Procedure -simType simType -msgName msgName -msgType msgType \
                              -MMEId MMEId -criticalityDiag criticalityDiag -eNBUES1APId eNBUES1APId -MMEUES1APId MMEUES1APId \
                              -UEAggMaxBitRate UEAggMaxBitRate -eRABsSwitchedUL ERABsToBeSwitchedUL \
                              -securityContext securityContext -erabtobereleased ERABsReleaseList -streamId streamId\
                              -gwIp gwIp -gwPort gwPort"]
                    if {$operation == "send" } {
                         array set ARR_PATH_ACK $pathSwitch
                    }
               }
               "failure" {
 		    if {[info exists causeType] && [info exists cause]} {
        	       set causeVal "\{$causeType=$cause\}"
     		    }
                    set pathSwitch [updateValAndExecute "constructS1Procedure -simType simType -msgName msgName -msgType msgType \
                              -MMEId MMEId -eNBUES1APId eNBUES1APId -MMEUES1APId MMEUES1APId \
                              -criticalityDiag criticalityDiag -streamId streamId -cause causeVal -gwIp gwIp -gwPort gwPort"]
                    if {$operation == "send" } {
                         array set ARR_PATH_FAIL $pathSwitch
                    }
               }
          }
     } else {
          set pathSwitch [array get $psArrName]
          if {[info exists srcGUMMEI]} {
               #if {[regexp "source_mme_gummei=\{" $pathSwitch]} {
               #     regsub "source_mme_gummei=\{.*mmegroupid=\[0-9]+\} " $pathSwitch "" pathSwitch
               #}
               if {[regexp "sourceMME_GUMMEI=\{" $pathSwitch]} {
                    regsub "sourceMME_GUMMEI=\{.*mME_Group_ID=\[0-9]+\} " $pathSwitch "" pathSwitch
               }
          }
          foreach msgEle [list eNB_UE_S1AP_ID mME_UE_S1AP_ID StreamNo] updateVar [list eNBUES1APId MMEUES1APId streamId] {
               if {![info exists $updateVar]} {continue}
               if {[regsub "${msgEle}=\[0-9\]+" $pathSwitch "${msgEle}=[set $updateVar]" pathSwitch] != 1} {
                    print -fail "Failed to update variable $msgEle to [set $updateVar]"
                    return 1
               }
               # SRS-HeNBGW-CP-414
               # Since these values may not be generated while constructing the input we need to expicitly specify while expecting
               # This is only applicable for MacroENB
               if {$isHeNB && $msg == "ack"} {
                    print -debug "entered1"
                    if {[info exists MMEUES1APId2]} {
                         print -debug "entered2"
                         if {[regexp "mME_UE_S1AP_ID_2=" $pathSwitch]} {
                              regsub "mME_UE_S1AP_ID_2=\[0-9\]+" $pathSwitch "mME_UE_S1AP_ID_2=$MMEUES1APId2" pathSwitch
                         } else {
                              regsub "${msgEle}=[set $updateVar]" $pathSwitch "${msgEle}=[set $updateVar] mME_UE_S1AP_ID_2=$MMEUES1APId2 " pathSwitch
                         }
                    }
               }
               
               unset -nocomplain $psArrName
          }

          if {[info exists causeType] && [info exists cause] && $msg == "failure"} {
             set causeVal "\{$causeType=$cause\}"
             if {![regexp "cause=" $pathSwitch]} {
                regsub "${msgEle}=[set $updateVar]" $pathSwitch "${msgEle}=[set $updateVar] cause=$causeVal " pathSwitch
             }  else {
                 regsub "cause=\{\[a-z\]+=(\[a-z\]*(_)*\[0-9\]*)*\} " $pathSwitch "cause=$causeVal " pathSwitch
             }
          }

     }
     
     print -info "pathSwitch $pathSwitch"
     if {$execute == "no"} { return "$simType $pathSwitch"}
     
     return [updateValAndExecute "sendOrVerifyS1APProcedure -msgName msgName -msgType msgType \
               -operation operation -msgList pathSwitch -simType simType \
               -HeNBIndex HeNBIndex -MMEIndex MMEIndex"]
     
     return 0
}

proc setUpX2 {args} {
     #-
     #- Procedure to setup X2 handover sequence
     #-
     #- @return 0 on success, @return -1 on failure
     #-
     
     set validMessages "request|ack|failure"
     set defaultCause "unknown"
     set nexthopchainingcount [random 7]
     set securityKey          [randomDataString 64 allDigits]
     set defaultSC            "$nexthopchainingcount,$securityKey"
     parseArgs args \
               [list \
               [list sendSeq             optional   "$validMessages"    "request ack"     "To perform the operation or not. if no, will return the message"] \
               [list operation          optional   "send|(don't|)expect"        "send"        "send or expect option"] \
               [list execute             optional   "boolean"           "yes"         "To perform the operation or not. if no, will return the message"] \
               [list HeNBIndex          mandatory  "numeric"             ""      "Index of HeNB whose values need to be retrieved" ] \
               [list UEIndex            mandatory  "string" ""      "Index of UE whose values need to be retrieved" ] \
               [list MMEIndex           optional   "numeric" "0"      "Index of MME whose values need to be retrieved" ] \
               [list eNBUES1APId        optional   "string" "__UN_DEFINED__"   "eNB UE S1AP Id value" ] \
               [list MMEUES1APId        optional   "string" "__UN_DEFINED__"   "MME UE S1AP Id value" ] \
               [list srcMMEUES1APId       optional   "string"               "__UN_DEFINED__"    "Source MME UE S1AP Id value" ] \
               [list ERABsToBeSwitchedDL  optional   "string"               "1,0"               "ERABs to be switched in the DL" ] \
               [list eCGI                 optional   "string"               "0,0"               "e-UTRAN CGI chosen from UE" ] \
               [list TAI                  optional   "string"               "0,0"               "TAI chosen from UE" ] \
               [list UESecurityCap        optional   "string"               "1,1"               "The UE security capability to be used" ] \
               [list CSGId                optional   "string"               "__UN_DEFINED__"    "The CSGId param to be used in HeNB"] \
               [list CellAccessMode       optional   "string"               "__UN_DEFINED__"    "Cell Access Mode value from UE" ] \
               [list srcGUMMEI            optional   "string"               "0,0,0,0"           "The source GUMMEI to be used" ] \
               [list UEAggMaxBitRate      optional   "string"               "__UN_DEFINED__"    "The UE aggregate max bit rate" ] \
               [list ERABsToBeSwitchedUL  optional   "string"               "__UN_DEFINED__"    "ERABs to be switched in the UL" ] \
               [list ERABsReleaseList     optional   "string"               "__UN_DEFINED__"    "Defines the ERABs to be released" ] \
               [list securityContext      optional   "string"               "$defaultSC"    "Defines the Security context" ] \
               [list criticalityDiag      optional   "string"               "__UN_DEFINED__"    "The critical diag to be enabled or not"] \
               [list procedureCode        optional   "string"               "__UN_DEFINED__"    "The procedure code to be used diag"] \
               [list triggerMsg           optional   "string"               "__UN_DEFINED__"    "Identifies the triggering message"] \
               [list procedureCriticality optional   "string"               "__UN_DEFINED__"    "Identifies the procedure Criticality"] \
               [list IECriticality        optional   "string"               "__UN_DEFINED__"    "Identifies the IE Criticality list"] \
               [list IEId                 optional   "numeric"              "__UN_DEFINED__"    "Identifies the IE Id list"] \
               [list typeOfError          optional   "string"               "__UN_DEFINED__"    "Identifies the type of error list"] \
               [list causeType            optional   "string"               "nas"          "Identifies the cause choice group"] \
               [list cause                optional   "string"               "authentication_failure"     "Identifies the cause value"] \
               [list streamId             optional   "numeric"              "__UN_DEFINED__"    "Defines the streamId assigned" ] \
               ]
     
     if {[regexp "," $UEIndex]} {set UEIndex [split $UEIndex ,]}
     
     foreach ueId $UEIndex {
          print -info "X2 handover for UEIndex $ueId"
          foreach msg $sendSeq {
               switch $msg {
                    "request" {
                         foreach op [list send expect] {
                              print -info "Path Switch request $op"
                              set result [updateValAndExecute "pathSwitch -operation op -execute execute -simType simType -msg msg -msgType msgType \
                                        -HeNBIndex HeNBIndex -UEIndex ueId -eNBUES1APId eNBUES1APId -MMEUES1APId srcMMEUES1APId \
                                        -eRABsSwitchedDL ERABsToBeSwitchedDL -eCGI eCGI -TAI TAI -UESecurityCap UESecurityCap \
                                        -CSGIdList CSGId -cellAccessMode CellAccessMode -GUMMEI srcGUMMEI -streamId streamId \
                                        -MMEIndex MMEIndex"]
                              
                              if {$result != 0} {
                                   print -fail "Path Switch request $op failed to MMEIndex $MMEIndex"
                                   return -1
                              } else {
                                   print -pass "Path Switch request $op successful to MMEIndex $MMEIndex"
                              }
                         }
                    }
                    "ack" {
                         foreach op [list send expect] {
                              print -info "Path Switch ack $op"
                              set result [updateValAndExecute "pathSwitch -operation op -execute execute -simType simType -msg msg -msgType msgType \
                                        -UEIndex ueId -HeNBIndex HeNBIndex -IECriticality IECriticality -IEId IEId -typeOfError typeOfError \
                                        -procedureCode procedureCode -triggerMsg triggerMsg -procedureCriticality procedureCriticality \
                                        -criticalityDiag criticalityDiag -eNBUES1APId eNBUES1APId \
                                        -MMEUES1APId MMEUES1APId \
                                        -UEAggMaxBitRate UEAggMaxBitRate -eRABsSwitchedUL ERABsToBeSwitchedUL \
                                        -securityContext securityContext -erabtobereleased ERABsReleaseList -streamId streamId \
                                        -MMEIndex MMEIndex"]
                              if {$result != 0} {
                                   print -fail "Path Switch ack $op operation unsuceesful for MMEIndex $MMEIndex"
                                   return -1
                              } else {
                                   print -pass "Path Switch ack $op operation suceesfull for MMEIndex $MMEIndex"
                              }
                         }
                    }
                    "failure"   {
                         foreach op [list send expect] {
                              print -info "Path Switch failure $op"
                              set result [updateValAndExecute "pathSwitch -operation op -execute execute -simType simType -msg msg -msgType msgType \
                                        -UEIndex ueId -HeNBIndex HeNBIndex -eNBUES1APId eNBUES1APId -MMEUES1APId MMEUES1APId -IECriticality IECriticality \
                                        -IEId IEId -typeOfError typeOfError -procedureCode procedureCode -triggerMsg triggerMsg \
                                        -procedureCriticality procedureCriticality \
                                        -criticalityDiag criticalityDiag -streamId streamId -causeType causeType -cause cause \
                                        -MMEIndex MMEIndex"]
                              
                              if {$result != 0} {
                                   print -fail "Path Switch failure $op operation from MME $MMEIndex unsuceesful"
                                   return -1
                              } else {
                                   print -pass "Path Switch failure $op operation from MME $MMEIndex suceesful"
                              }
                         }
                    }
               }
          }
     }
     return 0
}

proc setUpS1handover {args} {
     #-
     #- Procedure to setup S1 handover sequence
     #-
     #- @return 0 on success, @return -1 on failure
     #-
     
     set defaultCause      "control_processing_overload"
     set validHandoverType "IntraLTE|LTEtoUTRAN|LTEtoGERAN|UTRANtoLTE|GERANtoLTE"
     set validHandoverType "IntraLTE|LTEtoUTRAN|LTEtoGERAN|UTRANtoLTE|GERANtoLTE"
     set validMessages "request|reqAck|reqFail|notify"
     
     parseArgs args \
               [list \
               [list sendSeq              optional   "$validMessages"       "request reqAck notify"    "The sequence to be followed"] \
               [list execute              optional   "boolean"              "yes"               "To perform the operation or not"] \
               [list HeNBIndex            mandatory  "numeric"              ""                  "Index of HeNB whose values need to be retrieved" ] \
               [list UEIndex              mandatory  "string"               ""                  "Index of UE whose values need to be retrieved" ] \
               [list MMEIndex             optional   "numeric"              "0"                 "Index of MME whose values need to be retrieved" ] \
               [list eNBUES1APId          optional   "string"               "__UN_DEFINED__"    "eNB UE S1AP Id value" ] \
               [list MMEUES1APId          optional   "string"               "__UN_DEFINED__"    "MME UE S1AP Id value" ] \
               [list handoverType         optional   "$validHandoverType"   "IntraLTE"          "The handover type" ] \
               [list causeType            optional   "string"               "misc"              "Identifies the cause choice group"] \
               [list cause                optional   "string"               "$defaultCause"     "Identifies the cause value"] \
               [list UEAggMaxBitRate      optional   "string"               "1,1"               "The UE aggregate max bit rate" ] \
               [list ERABsToBeSetupHOReq  optional   "string"               "1,0"               "The ERABs to be setup during handover" ] \
               [list srcToTgtTransCont    optional   "string"               "0,0"           "Identifies the source to target container"] \
               [list UESecurityCap        optional   "string"               "1,1"               "The UE security capability to be used" ] \
               [list servingPLMN          optional   "string"               "__UN_DEFINED__"    "serving PLMN in Hand over Restriction List" ] \
               [list equivalPLMN          optional   "string"               "__UN_DEFINED__"    "equivalent PLMNs in Hand over Restriction List" ] \
               [list forbiddenTA          optional   "string"               "__UN_DEFINED__"    "forbidden TAs in Hand over Restriction List" ] \
               [list forbiddenLA          optional   "string"               "__UN_DEFINED__"    "forbidden LAs in Hand over Restriction List" ] \
               [list forbiddenInterRATs   optional   "string"               "__UN_DEFINED__"    "forbidden Inter RATs in Hand over Restriction List" ] \
               [list traceActivation      optional   "boolean"              "__UN_DEFINED__"    "The trace activation to be enabled" ] \
               [list eURTANTraceId        optional   "string"               "[random 99999999]" "The trace id to be enabled" ] \
               [list intToTrace           optional   "string"               "50"                "The interface to be traced" ] \
               [list MDTConfig            optional   "string"               "__UN_DEFINED__"    "The MDT configuration for trace" ] \
               [list requestType          optional   "string"               "__UN_DEFINED__"    "The request type in the handover request" ] \
               [list nasSecurityParams    optional   "string"               "__UN_DEFINED__"    "Defines the NAS Security param to UTRAN" ] \
               [list CSGId                optional   "string"               "__UN_DEFINED__"    "The CSGId param to be used in HeNB"] \
               [list CSGMembershipStatus  optional   "string"               "__UN_DEFINED__"    "Defines the CSG membership status" ] \
               [list GUMMEI               optional   "string"               "__UN_DEFINED__"    "GUMMEI from UE of format gummeiInd,plmnInd,mmecInd,mmegiInd" ] \
               [list MMEUES1APId2         optional   "string"               "__UN_DEFINED__"    "Defines the MMEUES1APId assigned by MME" ] \
               [list ERABsAdmittedList    optional   "string"               "1,0"               "Defines the ERAB Admit list" ] \
               [list ERABsFailedToSetup   optional   "string"               "__UN_DEFINED__"    "The number of E-RAB failed to setup" ] \
               [list tgtToSrcTransCont    optional   "string"               "123456"           "Identifies the source to target container"] \
               [list criticalityDiag      optional   "string"               "__UN_DEFINED__"    "The critical diag to be enabled or not"] \
               [list procedureCode        optional   "string"               "__UN_DEFINED__"    "The procedure code to be used diag"] \
               [list triggerMsg           optional   "string"               "__UN_DEFINED__"    "Identifies the triggering message"] \
               [list procedureCriticality optional   "string"               "__UN_DEFINED__"    "Identifies the procedure Criticality"] \
               [list IECriticality        optional   "string"               "__UN_DEFINED__"    "Identifies the IE Criticality list"] \
               [list IEId                 optional   "numeric"              "__UN_DEFINED__"    "Identifies the IE Id list"] \
               [list typeOfError          optional   "string"               "__UN_DEFINED__"    "Identifies the type of error list"] \
               [list TAI                  optional   "string"               "0,0"               "TAI chosen from UE" ] \
               [list eCGI                 optional   "string"               "0,0"               "e-UTRAN CGI chosen from UE" ] \
               [list streamId             optional   "numeric"              "__UN_DEFINED__"    "Defines the streamId assigned" ] \
               ]
     
     if {[regexp "," $UEIndex]} {set UEIndex [split $UEIndex ,]}
     
     foreach ueId $UEIndex {
          print -info "S1 handover for UE $ueId"
          foreach msg $sendSeq {
               switch $msg {
                    "request" {
                         foreach op [list send expect] {
                              print -info "Handover Request $op"
                              set result [updateValAndExecute "handoverRequest -simType simType -operation op -msg msg -msgType msgType \
                                        -HeNBIndex HeNBIndex -UEIndex ueId -MMEIndex MMEIndex -MMEUES1APId MMEUES1APId -eNBUES1APId eNBUES1APId \
                                        -causeType causeType -cause cause -handoverType handoverType -UEAggMaxBitRate UEAggMaxBitRate \
                                        -UESecurityCap UESecurityCap -srcToTgtTransCont srcToTgtTransCont \
                                        -handOverRestriction handOverRestriction -TraceActivation TraceActivation -handoverReqType requestType \
                                        -srvccOperation SRVCCOperation -securityContext securityContext -NASSecParamsToEutran nasSecurityParams \
                                        -CSGIdList CSGId -CSGMembershipStatus CSGMembershipStatus -GUMMEI GUMMEI -MMEUES1APId2 MMEUES1APId2 \
                                        -eRAB ERABsToBeSetupHOReq -streamId streamId"]
                              
                              if {$result != 0} {
                                   print -fail "Handover Request $op operation for MME $MMEIndex unsuceesful"
                                   return -1
                              } else {
                                   print -pass "Handover Request $op operation for MME $MMEIndex suceesfull"
                              }
                         }
                    }
                    
                    "reqAck" {
                         set msgName "ack"
                         foreach op [list send expect] {
                              print -info "Handover Request Ack $op"
                              set result [updateValAndExecute "handoverRequest -simType simType -operation op -msg msgName \
                                        -HeNBIndex HeNBIndex -UEIndex ueId -MMEIndex MMEIndex -eNBUES1APId eNBUES1APId -MMEUES1APId MMEUES1APId \
                                        -eRABsAdmitList ERABsAdmittedList -ERABsFailedToSetup ERABsFailedToSetup -CSGId CSGId \
                                        -tgtToSrcTransCont tgtToSrcTransCont -cause cause -causeType causeType -criticalityDiag criticalityDiag \
                                        -procedureCode procedureCode -procedureCriticality procedureCriticality -IEId IEId \
                                        -IECriticality IECriticality -triggerMsg triggerMsg -typeOfError typeOfError -streamId streamId"]
                              
                              if {$result != 0} {
                                   print -fail "Handover Request ack $op not successful"
                                   return -1
                              } else {
                                   print -pass "Handover Request ack $op successful"
                              }
                         }
                    }
                    "reqFail" {
                         set msgName "failure"
                         foreach op [list send expect] {
                              print -info "Handover Request Fail $op"
                              set result [updateValAndExecute "handoverRequest -simType simType -operation op -msg msgName -msgType msgType \
                                        -HeNBIndex HeNBIndex -UEIndex ueId -MMEUES1APId MMEUES1APId -causeType causeType -cause cause \
                                        -criticalityDiag criticalityDiag -procedureCode procedureCode -procedureCriticality procedureCriticality \
                                        -IEId IEId -IECriticality IECriticality -triggerMsg triggerMsg -typeOfError typeOfError -MMEIndex MMEIndex -streamId streamId"]
                              
                              if {$result != 0} {
                                   print -fail "Handover Request failure $op operation for MME $MMEIndex unsuceesful"
                                   return -1
                              } else {
                                   print -pass "Handover Request failure $op operation for MME $MMEIndex suceesfull"
                              }
                         }
                    }
                    "notify" {
                         foreach op [list send expect] {
                              print -info "Handover Notify $op"
                              set result [updateValAndExecute "handoverNotify -simType simType -operation op -msgType msgType \
                                        -HeNBIndex HeNBIndex -UEIndex ueId -MMEUES1APId MMEUES1APId -eNBUES1APId eNBUES1APId \
                                        -TAI TAI -eCGI eCGI -MMEIndex MMEIndex -streamId streamId"]
                              
                              if {$result != 0} {
                                   print -fail "Handover Notify $op operation for HeNB $HeNBIndex unsuceesful"
                                   return -1
                              } else {
                                   print -pass "Handover Notify $op operation for HeNB $HeNBIndex suceesfull"
                              }
                         }
                    }
                    
               }
          }
     }
     return 0
}

proc handoverCancel {args} {
     #-
     #- The purpose of the Handover Cancel procedure is to enable a source eNB to cancel an ongoing handover preparation or an already prepared handover.
     #- The source eNB initiates the procedure by sending a HANDOVER CANCEL message to the EPC.
     #-
     #- The HANDOVER CANCEL message shall indicate the reason for cancelling the handover by the appropriate value of the Cause IE
     #-
     #- Upon reception of a HANDOVER CANCEL message, the EPC shall terminate the ongoing Handover Preparation procedure,
     #-  release any resources associated with the handover preparation and send a HANDOVER CANCEL ACKNOWLEDGE message to the source eNB.
     #- Transmission and reception of a HANDOVER CANCEL ACKNOWLEDGE message terminate the procedure in the EPC and in the source eNB.
     #-  After this, the source eNB does not have a prepared handover for that UE-associated logical S1-connection.
     #-
     #-    ------ HANDOFF_CANCEL ------
     #-    Message Type		M
     #-    MME UE S1AP ID	M
     #-    eNB UE S1AP ID	M
     #-    Cause		M
     #-
     #-    ------ HANDOFF_CANCEL_ACK ------
     #-    Message Type	        M
     #-    MME UE S1AP ID	M
     #-    eNB UE S1AP ID	M
     #-    Criticality Diagnostics	O
     #-
     #-
     
     global ARR_HO_CANCEL
     set validMsg "cancel|ack"
     set defaultCause "AUTHENTICATION_FAILURE"
     
     parseArgs args \
               [list \
               [list msg                  optional   "$validMsg"            "cancel"            "The message to be sent" ] \
               [list operation            optional   "send|(don't|)expect"  "send"              "send or expect option"] \
               [list execute              optional   "boolean"              "yes"               "To perform the operation or not"] \
               [list HeNBIndex            mandatory  "numeric"              ""                  "Index of HeNB whose values need to be retrieved" ] \
               [list UEIndex              mandatory  "numeric"              ""                  "Index of UE whose values need to be retrieved" ] \
               [list MMEIndex             optional   "numeric"              "__UN_DEFINED__"    "Index of MME whose values need to be retrieved" ] \
               [list eNBUES1APId          optional   "string"               "__UN_DEFINED__"    "eNB UE S1AP Id value" ] \
               [list MMEUES1APId          optional   "string"               "__UN_DEFINED__"    "MME UE S1AP Id value" ] \
               [list criticalityDiag      optional   "string"               "__UN_DEFINED__"    "The critical diag to be enabled or not"] \
               [list procedureCode        optional   "string"               "__UN_DEFINED__"    "The procedure code to be used diag"] \
               [list triggerMsg           optional   "string"               "__UN_DEFINED__"    "Identifies the triggering message"] \
               [list procedureCriticality optional   "string"               "__UN_DEFINED__"    "Identifies the procedure Criticality"] \
               [list IECriticality        optional   "string"               "__UN_DEFINED__"    "Identifies the IE Criticality list"] \
               [list IEId                 optional   "numeric"              "__UN_DEFINED__"    "Identifies the IE Id list"] \
               [list typeOfError          optional   "string"               "__UN_DEFINED__"    "Identifies the type of error list"] \
               [list causeType            optional   "string"               "nas"               "Identifies the cause choice group"] \
               [list cause                optional   "string"               "$defaultCause"     "Identifies the cause value"] \
               [list streamId             optional   "numeric"              "__UN_DEFINED__"    "Defines the streamId assigned" ] \
               [list gwIp                 optional   "string"               "__UN_DEFINED__"    "cocurrent warning msg indicator in wr-rep-warn msg" ] \
               [list gwPort               optional   "string"               "__UN_DEFINED__"    "cocurrent warning msg indicator in wr-rep-warn msg" ] \
               ]
     
     set msgName [string map "\
               cancel  handover_cancel \
               ack     handover_cancel_ackowledge" $msg]
     
     if {![info exists MMEIndex]} {
          ##getFromTestMap returns MMEIndex incase of load balancing case of S1Flex scenario
          if {[getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "MMEIndex"] != -1} {
               set MMEIndex [getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "MMEIndex"]
               print -info "Using MMEIndex $MMEIndex among load balanced MMEs"
          } else {
               #Keeping default value of 0
               set MMEIndex "0"
               print -info "Using default MMEIndex $MMEIndex"
          }
     } else {
          print -info "Using MMEIndex $MMEIndex passed from script"
     }
     
     set MultiS1Link $::ARR_LTE_TEST_PARAMS(MultiS1Link)

     set msgType   "class1"
     set defaultCause ""
     set HeNBId   [getFromTestMap -HeNBIndex $HeNBIndex -param "HeNBId"]
     switch $msg {
          "cancel" {
               # Define the mandatory arguments
               set mandatoryIEs "MMEUES1APId eNBUES1APId cause causeType"
               
               # Update the dynamic variables
               if {$operation == "send"} {
                    set ueid   [getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "ueid"]
                    set simType "HeNB"
                    set paramList [list eNBUES1APId vENBUES1APId streamId ueid]
               } else {
                    set simType "MME"
                    set paramList [list vENBUES1APId MMEUES1APId mStreamId mmeUEId]
               }
          }
          "ack" {
               set mandatoryIEs "MMEUES1APId eNBUES1APId"
               
               # Update the dynamic variables
               if {$operation == "send"} {
                    set simType "MME"
                    set paramList [list vENBUES1APId MMEUES1APId mStreamId mmeUEId]
               } else {
                    set ueid   [getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "ueid"]
                    set simType "HeNB"
                    set paramList [list eNBUES1APId vENBUES1APId streamId ueid]
               }
               
               # Construct the criticality diag
               if {[info exists criticalityDiag]} {
                    set criticalityDiag [updateValAndExecute "getCriticDiag -criticalityDiag criticalityDiag \
                              -procedureCode procedureCode -triggerMsg triggerMsg -procedureCriticality procedureCriticality \
                              -IECriticality IECriticality -IEId IEId -typeOfError typeOfError"]
               }
               
          }
     }
     # Update the dynamic variables
     foreach dynElement {eNBUES1APId MMEUES1APId streamId ueid} param $paramList {
          if {![info exists $dynElement]} {
               # While sending UE data from eNB simulator use the streamId that is one greater then the UEIndex
               if {$param == "streamId"} {
                    set streamId [expr $UEIndex + 1]
                    continue
               }
               if {[catch {set $dynElement [getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "$param"]}]} {
                    print -abort "Failed to get the param $param"
                    return 1
               }
          }
     }
     
     # Unset the IE if not intended to be sent in the message
     foreach mandIE $mandatoryIEs {
          if {[info exists $mandIE]} {
               if {[set $mandIE] == ""} {unset $mandIE}
          }
     }

     set gwPort [getDataFromConfigFile "henbSctp" 0 ]
     set MMEId  [getFromTestMap -MMEIndex $MMEIndex -param "MMEId"]
     set HeNBId [getFromTestMap -HeNBIndex $HeNBIndex -param "HeNBId"]

     if {$MultiS1Link == "yes"} {
        set enbID [getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "eNBId"]
     }

     if {[info exists causeType] && [info exists cause]} {
        set causeVal "\{$causeType=$cause\}"
     }
     
     if {$operation == "send"} {
          # Construct the message that has to be sent to the simulator
          switch $msg {
               "cancel" {
                    set gwIp   [getDataFromConfigFile "henbSignalingIpaddress" 0 ]
                    set handoverCancel [updateValAndExecute "constructS1Procedure -simType simType -msgName msgName -msgType msgType \
                              -HeNBId HeNBId -ueid ueid -eNBUES1APId eNBUES1APId -MMEUES1APId MMEUES1APId \
                              -cause causeVal -streamId streamId -gwIp gwIp -gwPort gwPort"]
               }
               "ack" {
                    set gwIp   [getDataFromConfigFile "mmeSignalingIpaddress" 0 ]

                    if {$MultiS1Link == "yes"} {
                       set eNBType [getFromTestMap -HeNBIndex $HeNBIndex -param "eNBType"]
                       if {! [ info exists eNBType ]} {
                          set eNBType "macro"
                       }
                       if {[info exists enbID]} {
                          set globaleNBId "\{${eNBType}ENB_ID=$enbID\}"
                       }
                    }

                    set handoverCancel [updateValAndExecute "constructS1Procedure -simType simType -msgName msgName -msgType msgType \
                              -MMEId MMEId -ueid ueid -eNBUES1APId eNBUES1APId -MMEUES1APId MMEUES1APId -globaleNBId globaleNBId \
                              -criticalityDiag criticalityDiag -streamId streamId -gwIp gwIp -gwPort gwPort"]
               }
          }
          array set ARR_HO_CANCEL $handoverCancel
     } else {
          set handoverCancel [array get ARR_HO_CANCEL]
          foreach msgEle [list eNB_UE_S1AP_ID mME_UE_S1AP_ID StreamNo] updateVar [list eNBUES1APId MMEUES1APId streamId] {
               if {![info exists $updateVar]} {continue}
               if {[regsub "${msgEle}=\[0-9\]+" $handoverCancel "${msgEle}=[set $updateVar]" handoverCancel] != 1} {
                    print -fail "Failed to update variable $msgEle to [set $updateVar]"
                    return 1
               }

               unset -nocomplain ARR_HO_CANCEL
          }

          if {[info exists causeType] && [info exists cause] && $msg == "cancel"} {
             if {![regexp "cause=" $handoverCancel]} {
                regsub "${msgEle}=[set $updateVar]" $handoverCancel "${msgEle}=[set $updateVar] cause=$causeVal " handoverCancel
             } else {
                 regsub "cause=\{\[a-z\]+=(\[a-z\]*(_)*\[0-9\]*)*\} " $handoverCancel "cause=$causeVal " handoverCancel
             }


          }
     }
     
     print -info "handoverCancel $handoverCancel"
     if {$execute == "no"} { return "$simType $handoverCancel"}
     
     return [updateValAndExecute "sendOrVerifyS1APProcedure -msgName msgName -msgType msgType \
               -operation operation -msgList handoverCancel -simType simType -enbID enbID \
               -HeNBIndex HeNBIndex -MMEIndex MMEIndex"]
     return 0
}

proc findNumOfMMEs {args} {
     #-
     #-Procedure to find number of MMEs defined for the execution
     #-
     global ARR_LTE_TEST_PARAMS_MAP
     set keys [array names ::ARR_LTE_TEST_PARAMS_MAP M,*,Region]
     
     print -info "Number of MMEs is [llength $keys]"
     return [llength $keys]
}

proc getUEsOfMME {args} {
     #-
     #-Procedure to find all the UEs associated with an MME, in S1Flex load balanced scenario
     #-
     global ARR_LTE_TEST_PARAMS_MAP
     parseArgs args \
               [list \
               [list MMEIndex             mandatory   "string" "__UN_DEFINED__"      "Index of MME whose values need to be retrieved" ] \
               [list HeNBIndex            mandatory   "string" "__UN_DEFINED__"      "Index of MME whose values need to be retrieved" ] \
               ]
     
     global ARR_LTE_TEST_PARAMS_MAP
     set keys [array names ::ARR_LTE_TEST_PARAMS_MAP H,*,*,MMEIndex]
     
     set ueList ""
     foreach key $keys {
          if {$::ARR_LTE_TEST_PARAMS_MAP($key) == $MMEIndex} {
               set henbInd [lindex [split $key ","] 1]
               if {$henbInd == $HeNBIndex} {
                    lappend ueList [lindex [split $key ","] 3]
               } else {
                    continue
               }
          } else {
               continue
          }
     }
     if {$ueList != ""} {
          print -info "UEs assosicated with MME $MMEIndex and from HeNB $HeNBIndex are: $ueList"
          return $ueList
     } else {
          print -dbg "No UEs are associated with MME $MMEIndex and from HeNB $HeNBIndex"
          return -1
     }
}

proc getFromTestMap {args} {
     #-
     #- To read from ::ARR_LTE_TEST_PARAMS_MAP matching "param" and MMEIndex/HeNBIndex
     #- Returns list of matched elements
     #-
     parseArgs args \
               [list \
               [list HeNBIndex            optional   "string" "__UN_DEFINED__"      "Index of HeNB whose values need to be retrieved" ] \
               [list MMEIndex             optional   "string" "__UN_DEFINED__"      "Index of MME whose values need to be retrieved" ] \
               [list UEIndex              optional   "string" "__UN_DEFINED__"      "Index of UE whose values need to be retrieved" ] \
               [list GUMMEIIndex          optional   "numeric" "0"                   "Index of GUMMEI Index whose values need to be retrieved" ] \
               [list RegionIndex          optional   "numeric" "0"                   "Index of Region whose values need to be retrieved" ] \
               [list S1MMEIndex           optional   "numeric" "0"                   "Index of no Of S1links for a MME" ] \
               [list SubRegionIndex       optional   "numeric" "0"                   "Index of no Of S1links for a MME" ] \
               [list  enbId               optional   "numeric"  "0"                 "enbid for respective moid and mmeindex" ] \
               [list param                optional   "string" "__UN_DEFINED__"      "Index of MME whose values need to be retrieved" ] \
               ]
     set valList ""
     if {[info exists UEIndex]} {
          if {[catch {set val $::ARR_LTE_TEST_PARAMS_MAP(H,$HeNBIndex,U,$UEIndex,$param)} err]} {
               #param 'MMEIndex' is updated in global array, only incase of load balancing in s1flex
               #so, if this param is not present, not exiting and returning -1
               if {$param == "MMEIndex"} {
                    return -1
               } else {
                    print -fail "Failure in extracting UE data"
                    print -fail "Got error: $err"
                    exit -1
               }
          }
          return $val
     }
     
     if { [info exists HeNBIndex] } {
          if { $HeNBIndex == "all"} {
               set HeNBIndex ""
               #for { set i 0 } { $i < [llength $::ARR_LTE_TEST_PARAMS(HeNBId)] } { incr i } { lappend HeNBIndex $i }
               
               set lst [array get ::ARR_LTE_TEST_PARAMS_MAP H,*,Region]
               foreach {key val} $lst {
                    if {[lsearch -exact $val $RegionIndex] != -1} {
                         lappend HeNBIndex [lindex [split $key ","] 1]
                    }
               }
               set HeNBIndex [lsort -dictionary $HeNBIndex]
               
          }
          
          foreach i $HeNBIndex {
               if {[catch {set val $::ARR_LTE_TEST_PARAMS_MAP(H,$i,$param)} err]} {
                    print -fail "Failure in extracting HeNB data"
                    print -fail "Got error: $err"
                    exit -1
               }
               
               #If HeNB is having PLMNs from more than 2 regions
               if {[llength $::ARR_LTE_TEST_PARAMS_MAP(H,$i,Region)] > 1} {
                    if {[regexp {MCC|MNC} $param]} {
                         set mmes [array get ::ARR_LTE_TEST_PARAMS_MAP M,*,Region]
                         foreach {mmeKey regVal} $mmes {
                              print -info "mme $mmeKey regVal $regVal"
                              #In this case, taking PLMN from that particualr region's one of the MME
                              if {[lsearch -exact $regVal $RegionIndex] != -1 } {
                                   set mmeKey [regsub {Region} $mmeKey "G0,$param"]
                                   set val  $::ARR_LTE_TEST_PARAMS_MAP($mmeKey)
                                   print -info "Retrieved $param value of HeNB $i from one of the MME $mmeKey of region $RegionIndex: $val"
                                   break
                              }
                         }
                    }
               }
               lappend valList $val
          }
     }
     if { [info exists MMEIndex] } {
          if { $MMEIndex == "all"} {
               #Returning all MMEs of Region
               set MMEIndex ""
               
               set lst [array get ::ARR_LTE_TEST_PARAMS_MAP M,*,Region]
               foreach {key val} $lst {
                    if {[lsearch -exact $val $RegionIndex] != -1} {
                         lappend MMEIndex [lindex [split $key ","] 1]
                    }
               }
               return $MMEIndex
          } elseif {$param == "Region"} {
               return "$::ARR_LTE_TEST_PARAMS_MAP(M,$MMEIndex,Region)"
          } elseif {$param == "MMEId"} {
               return "$::ARR_LTE_TEST_PARAMS_MAP(M,$MMEIndex,MMEId)"
          } elseif {[catch {set val $::ARR_LTE_TEST_PARAMS_MAP(M,$MMEIndex,G${GUMMEIIndex},$param)} err]} {
               print -fail "Failure in extracting MME data"
               print -fail "Got error: $err"
               exit -1
          }
          return $val
     }
      if { ([info exists RegionIndex]) && ($param == "maxS1Links")} {
       foreach i $RegionIndex {
         if {[catch {set val $::ARR_LTE_TEST_PARAMS_MAP(R,$i,$param)} err]} {
              print -fail "Failure in extracting max S1 links for a region"
              print -fail "Got error: $err"
              exit -1
        }
      }
      return $val
    }
    
    if { ([info exists RegionIndex]) && ($param == "noOfRegMMEs")} {
       foreach i $RegionIndex {
         if {[catch {set val $::ARR_LTE_TEST_PARAMS_MAP(R,$i,$param)} err]} {
              print -fail "Failure in extracting no of mmes in a region"
              print -fail "Got error: $err"
              exit -1
        }
      }
      return $val
    }
    if { ([info exists RegionIndex]) && ([info exists SubRegionIndex]) && ($param == "eNBId")} {
       foreach i $RegionIndex j $SubRegionIndex {
         if {[catch {set val $::ARR_LTE_TEST_PARAMS_MAP(R,$i,SubR,$j,$param)} err]} {
              print -fail "Failure in extracting globalEnb Id in a region"
              print -fail "Got error: $err"
              exit -1
        }
      }
      return $val
    }
 
    if { ([info exists RegionIndex]) && ($param == "noOfHenbs")} {
       foreach i $RegionIndex {
         if {[catch {set val $::ARR_LTE_TEST_PARAMS_MAP(R,$i,$param)} err]} {
              print -fail "Failure in extracting no of Henbs in a region"
              print -fail "Got error: $err"
              exit -1
        }
      }
      return $val
    } 
    if { ([info exists S1MMEIndex]) && ($param == "noOfS1MMEs")} {
       foreach i $S1MMEIndex {
         if {[catch {set val $::ARR_LTE_TEST_PARAMS_MAP(M,$i,$param)} err]} {
              print -fail "Failure in extracting no of S1 Links for a MME"
              print -fail "Got error: $err"
              exit -1
        }
      }
      return $val
    }


    
     return $valList
}

proc getFromTestParam {param} {
     #-
     #- To read from ::ARR_LTE_TEST_PARAMS matching 'param'
     #- Returns list of matched elements
     
     return "$::ARR_LTE_TEST_PARAMS($param)"
}

proc getTA {args} {
     #-
     #- code to compute syntax of TA on simulator from MNCs, MCCs and TAC
     #- Format is: tac=x mcc=y mnc=z where y and z can be y=y1,y2,... z=z1,z2,...
     #-
     #supportedTAs={broadcastPLMNs={ MCC=229 MNC=117},{MCC=229 MNC=117},{MCC=229 MNC=117} tAC=9281},
     #{broadcastPLMNs={ MCC=229 MNC=117},{MCC=229 MNC=117},{MCC=229 MNC=117} tAC=9281},
     #{broadcastPLMNs={ MCC=229 MNC=117},{MCC=229 MNC=117},{MCC=229 MNC=117} tAC=9281}
     parseArgs args \
               [list \
               [list TACList            optional   "string" "__UN_DEFINED__"      "Index of HeNB whose values need to be retrieved" ] \
               [list MCCList            optional   "string" "__UN_DEFINED__"      "Index of MME whose values need to be retrieved" ] \
               [list MNCList            optional   "string" "__UN_DEFINED__"      "Index of MME whose values need to be retrieved" ] \
               ]

     set supportedTaList ""
     set broadcastPLMNs ""

     set MCCList [string map {\{ "" \} ""} $MCCList]
     set MNCList [string map {\{ "" \} ""} $MNCList]


     foreach TAC $TACList {
          set plmnList ""
          foreach MCC $MCCList MNC $MNCList {
               lappend plmn "\{MCC=$MCC MNC=$MNC\}"
          }
          set plmnList "broadcastPLMNs=[join $plmn , ]"
          lappend supportedTaList "\{$plmnList tAC=$TAC\}"
     }
     return "[join $supportedTaList ","]"
}


proc getTAList {args} {
     parseArgs args \
               [list \
               [list TACList            optional   "string" "__UN_DEFINED__"      "Index of HeNB whose values need to be retrieved" ] \
               [list MCCList            optional   "string" "__UN_DEFINED__"      "Index of MME whose values need to be retrieved" ] \
               [list MNCList            optional   "string" "__UN_DEFINED__"      "Index of MME whose values need to be retrieved" ] \
               ]
     
     set supportedTaList ""
     set taiList ""
     set i 0 
     foreach TAC $TACList {
          foreach MCC $MCCList MNC $MNCList {
             if { $i == 0 } {
                set plmnList "\{tAI=\{pLMNidentity=\{MCC=$MCC MNC=$MNC\} tAC=$TAC\}\}"
             } else { 
                set plmnList "tAIList=\{tAI=\{pLMNidentity=\{MCC=$MCC MNC=$MNC\} tAC=$TAC\}\}"
             }
             set taiList "$taiList $plmnList"
             set plmnList ""
             set i [incr i]
          }
     }

     set supportedTaList "$taiList"
     return $supportedTaList
}

proc getServedGUMMEIList {args} {
     #-
     #- code to compute syntax of servedGUMMEI on simulator from MNCs, MCCs, MMECs, MMEGIs
     #-
     #- Format is: {mmecode=x mmegroupid=y mnc=z mcc=a},{mmecode=X mmegroupid=Y mnc=Z mcc=A}
     #- where x y z a can be x=x1,x2,... y=y1,y2,... z=z1,z2,... a=a1,a2,...
     #- servedGUMMEIs={servedGroupIDs=12,34 servedMMECs=56,78 servedPLMNs={MCC=111 MNC=222},{MCC=333 MNC=444}},{servedGroupIDs=12,34 servedMMECs=56,78 servedPLMNs={MCC=111 MNC=222},{MCC=333 MNC=444}}
     
     parseArgs args \
               [list \
               [list GUMMEIIndex        optional   "string" "__UN_DEFINED__"      "GUMMEI index" ] \
               [list MMEIndex           optional   "string" "__UN_DEFINED__"      "GUMMEI index" ] \
               [list RegionIndex        optional   "string" "__UN_DEFINED__"      "Region index" ] \
               ]
     
     if { $GUMMEIIndex == "all"} {
          #set GUMMEIIndex ""
          #if {$::ARR_LTE_TEST_PARAMS($MMEIndex,GUMMEIs) == 0} {
          #     set GUMMEIIndex 0
          #} else {
          #     set GUMMEIIndex [listOfIncrEle 0 $::ARR_LTE_TEST_PARAMS($MMEIndex,GUMMEIs)]
          #}
          set GUMMEIIndex [listOfIncrEle 0 8]
     }
     
     if {$MMEIndex == "all"} {
          set MMEIndex [getFromTestMap -RegionIndex $RegionIndex -MMEIndex "all"]
     }
     
     set paramList "MMECode MMEGroupId MCC MNC"
     set servedGUMMEIList ""
     foreach gummeIndex $GUMMEIIndex {
          set GUMMEIList ""
          
          foreach param $paramList { set arr_gummei($param) ""}
          
          foreach mmeIndex $MMEIndex {
               #If GUMMEI RAT is not defined for mme index
               if {$gummeIndex >= $::ARR_LTE_TEST_PARAMS($mmeIndex,GUMMEIs)} {
                    continue
               }
               
               foreach param $paramList {
                    #- servedGUMMEIs={servedGroupIDs=12,34 servedMMECs=56,78 servedPLMNs={MCC=111 MNC=222},{MCC=333 MNC=444}},
                    #{servedGroupIDs=12,34 servedMMECs=56,78 servedPLMNs={MCC=111 MNC=222},{MCC=333 MNC=444}}
                    set arr_gummei($param) "[concat $arr_gummei($param) [getFromTestMap -GUMMEIIndex $gummeIndex -MMEIndex $mmeIndex -param $param]]"
               }
          }
          
          set serverdplmnlist ""
          foreach mmc $arr_gummei(MCC) mnc  $arr_gummei(MNC) {
               if {$mmc == "" || $mnc == "" } { continue }
               lappend serverdplmnlist "\{MCC=$mmc MNC=$mnc\}"
          }
          if { $arr_gummei(MMEGroupId) == "" ||  $arr_gummei(MMECode) == "" } {continue}
          set servedPLMNs    "servedPLMNs=[join $serverdplmnlist ,]"                                                                                                      
          set servedGroupIDs "servedGroupIDs=[join $arr_gummei(MMEGroupId) , ]"                                                                                           
          set servedMMECs    "servedMMECs=[join $arr_gummei(MMECode) ,]" 

          lappend GUMMEIList "$servedGroupIDs $servedMMECs $servedPLMNs"
          
          # parray arr_gummei ; puts "########### $GUMMEIList"
          
          if {$GUMMEIList != ""} {
               lappend servedGUMMEIList [list $GUMMEIList]
          }
          unset -nocomplain arr_gummei
     }
     print -info "servedGUMMEIList $servedGUMMEIList"
     
     #return [lindex [join $servedGUMMEIList ","] 0]
     return [lindex [join $servedGUMMEIList " "] 0]
}

proc getCriticDiag {args} {
     #-
     #- code to compute syntax of criticality diagnostris on simulator from defined arguments
     #-
     parseArgs args \
               [list \
               [list criticalityDiag      optional   "string"         "__UN_DEFINED__"         "The critical diag to be enabled or not"] \
               [list procedureCode        optional   "string"         "__UN_DEFINED__"         "The procedure code to be used diag"] \
               [list triggerMsg           optional   "string"         "__UN_DEFINED__"         "Identifies the triggering message"] \
               [list procedureCriticality optional   "string"         "__UN_DEFINED__"         "Identifies the procedure Criticality"] \
               [list IECriticality        optional   "string"         "__UN_DEFINED__"         "Identifies the IE Criticality"] \
               [list IEId                 optional   "numeric"        "__UN_DEFINED__"         "Identifies the IE Id"] \
               [list typeOfError          optional   "string"         "__UN_DEFINED__"         "Identifies the type of error"] \
               ]
     
     set criticDiag ""
     if {[info exists procedureCode]} {
          append criticDiag "procedureCode=$procedureCode "
     }
     
     if {[info exists triggerMsg]} {
          #append criticDiag "triggeringMessage=[ string map {initiating_message 0  successful_outcome 1 unsuccessful_outcome 2} $triggerMsg ] "
          append criticDiag "triggeringMessage=$triggerMsg "
     }
     
     if {[info exists procedureCriticality]} {
          #append criticDiag "procedureCriticality=[ string map  {reject 0  ignore 1 notify 2} $procedureCriticality ] "
          append criticDiag "procedureCriticality=$procedureCriticality "
     }
     
     if {[info exists IECriticality] && [info exists IEId] && [info exists typeOfError]} {
          set ieCriticDiag "iEsCriticalityDiagnostics="
          foreach ieId $IEId ieErr $typeOfError ieCritic $IECriticality {
               #append ieCriticDiag "{iE_ID=$ieId iECriticality=[ string map  {reject 0  ignore 1 notify 2} $IECriticality ] typeOfError=$ieErr} "
               append ieCriticDiag "{iE_ID=$ieId iECriticality=[ string map  {0 reject 1 ignore 2 notify} $ieCritic ] typeOfError=$ieErr} "
          }
          append criticDiag [string trim $ieCriticDiag ","]
     }
     
     return [list $criticDiag]
}

proc generateIEs {args} {
     #-
     #-Procedure for generating IE Lists of the simulator command
     #-
     
     parseArgs args \
               [list \
               [list HeNBIndex          optional   "numeric" "0"      "Index of HeNB whose values need to be retrieved" ] \
               [list UEIndex            optional   "numeric" "0"      "Index of UE whose values need to be retrieved" ] \
               [list MMEIndex           optional   "numeric" "0"      "Index of MME whose values need to be retrieved" ] \
               [list GUMMEIIndex        optional   "numeric" "0"      "Index of GUMMEI of MME whose values need to be retrieved" ] \
               [list IEType             mandatory   "string"  ""      "parameter/IE type" ] \
               [list paramIndices       optional   "string"  ""      "parameter Index list from script" ] \
               ]
     
     switch $IEType {
          "TAI" {
               #TAC bcMCC bcMNC
               foreach {tacInd plmnInd} [split $paramIndices ","] {break}
               print -info "tacInd $tacInd plmnInd $plmnInd"
               set tac [getIEVal -ieType "TAC" -ieIndex $tacInd -HeNBIndex $HeNBIndex]
               set mcc [getIEVal -ieType "bcMCC" -ieIndex $plmnInd -HeNBIndex $HeNBIndex]
               set mnc [getIEVal -ieType "bcMNC" -ieIndex $plmnInd -HeNBIndex $HeNBIndex]
               #tAI={ pLMNidentity={ MCC=<mcc> MNC=<mnc> } tAC=<int> }
               #set ieList [concat "mcc=$mcc" "mnc=$mnc" "tac=$tac"]
               set ieList "pLMNidentity={MCC=$mcc MNC=$mnc} tAC=$tac "
          }
          "LAI" {
               foreach {lacInd plmnInd} [split $paramIndices ","] {break}
               print -info "lacInd $lacInd plmnInd $plmnInd"
               set lac [getIEVal -ieType "TAC" -ieIndex $lacInd -HeNBIndex $HeNBIndex]
               set mcc [getIEVal -ieType "bcMCC" -ieIndex $plmnInd -HeNBIndex $HeNBIndex]
               set mnc [getIEVal -ieType "bcMNC" -ieIndex $plmnInd -HeNBIndex $HeNBIndex]
               #set ieList "\{pLMNidentity=\{MCC=$mcc MNC=$mnc\} lAC=$lac\}"
               set ieList "lAC=$lac pLMNidentity=\{MCC=$mcc MNC=$mnc\}"
          }
          "eCGI" {
               #CGI bcMCC bcMNC
               foreach {cgiInd plmnInd} [split $paramIndices ","] {break}
               print -info "cgiInd $cgiInd plmnInd $plmnInd"
               set cgi [getIEVal -ieType "CGI" -ieIndex $cgiInd -HeNBIndex $HeNBIndex]
               set mcc [getIEVal -ieType "bcMCC" -ieIndex $plmnInd -HeNBIndex $HeNBIndex]
               set mnc [getIEVal -ieType "bcMNC" -ieIndex $plmnInd -HeNBIndex $HeNBIndex]
               set ieList "cell_ID=$cgi pLMNidentity={MCC=$mcc MNC=$mnc}"
               #set ieList [concat "mcc=$mcc" "mnc=$mnc" "cellid=$cgi"]
          }
          "GUMMEI" {
               #serMCC MMEC MMEGI serMNC
               foreach {gummeiInd plmnInd mmecInd mmegiInd} [split $paramIndices ","] {break}
               print -info "gummeiInd $gummeiInd plmnInd $plmnInd mmecInd $mmecInd mmegiInd $mmegiInd"
               set mcc   [getIEVal -ieType "serMCC" -ieIndex $plmnInd -MMEIndex $MMEIndex -GUMMEIIndex $gummeiInd]
               set mnc   [getIEVal -ieType "serMNC" -ieIndex $plmnInd -MMEIndex $MMEIndex -GUMMEIIndex $gummeiInd]
               set mmec  [getIEVal -ieType "MMEC" -ieIndex $mmecInd -MMEIndex $MMEIndex -GUMMEIIndex $gummeiInd]
               set mmegi [getIEVal -ieType "MMEGI" -ieIndex $mmegiInd -MMEIndex $MMEIndex -GUMMEIIndex $gummeiInd]
               #set ieList [concat "mcc=$mcc" "mnc=$mnc" "mmecode=$mmec" "mmegroupid=$mmegi"]
               set ieList "mME_Code=$mmec mME_Group_ID=$mmegi pLMN_Identity=\{ MCC=$mcc MNC=$mnc \}"
          }
          "sTMSI" {
               #mTMSI MMEC
               foreach {mTmsiInd gummeiInd mmecInd} [split $paramIndices ","] {break}
               print -info "mTmsiInd $mTmsiInd gummeiInd $gummeiInd mmecInd $mmecInd"
               set mTmsi [getIEVal -ieType "mTMSI" -ieIndex $mTmsiInd -HeNBIndex $HeNBIndex -UEIndex $UEIndex]
               set mmec  [getIEVal -ieType "MMEC"  -ieIndex $mmecInd  -GUMMEIIndex $gummeiInd]
               #set ieList [concat "mtmsi=$mTmsi" "mmecode=$mmec"]
               set ieList "m_TMSI=$mTmsi mMEC=$mmec"
          }
          "CSGId" {
               set csgId $paramIndices
               print -info "csgIdIndex $csgId"
               set csgId [getIEVal -ieType "csgId" -ieIndex $csgId -HeNBIndex $HeNBIndex]
               set ieList "$csgId"
               return $ieList
          }
          "traceActivation" {
               
               set TraceActivation ""
               set e_UTRAN_Trace_ID  "12345678"
               set interfacesToTrace 0
               set traceCollectionEntityIPAddress "01010101"
               set traceDepth "minimum"
               set MDTConfig [generateIEs -IEType "MDTConfig" -paramIndices "" -HeNBIndex $HeNBIndex -MMEIndex $MMEIndex -UEIndex $UEIndex]
               # It is commented for testing purpose. once we get the clarification on MDTconfiguration values, then need to uncomment it.
               #set ieList  "{e_UTRAN_Trace_ID=$e_UTRAN_Trace_ID interfacesToTrace=$interfacesToTrace  \
                            traceCollectionEntityIPAddress=$traceCollectionEntityIPAddress traceDepth=$traceDepth mDTConfiguration_ext=$MDTConfig}"
               set ieList  "{e_UTRAN_Trace_ID=$e_UTRAN_Trace_ID interfacesToTrace=$interfacesToTrace  \
                            traceCollectionEntityIPAddress=$traceCollectionEntityIPAddress traceDepth=$traceDepth}"
               return $ieList
          }

          "servingPLMN" {
               set plmnIndex $paramIndices
               print -info "plmnInd $plmnIndex"
               set mcc [getIEVal -ieType "gwMcc" -ieIndex $plmnIndex]
               set mnc [getIEVal -ieType "gwMnc" -ieIndex $plmnIndex]
               set ieList "\{ MCC=$mcc MNC=$mnc \}"
               print -info "ieList $ieList"
               return "servingPLMN=$ieList"
          }
          "equivalPLMN" {
               set i 0
               foreach plmnElems [split $paramIndices ";"] {
                    print -info "plmnElems $plmnElems"
                    set mcc [getIEVal -ieType "equivalMcc" -ieIndex $plmnElems]
                    set mnc [getIEVal -ieType "equivalMnc" -ieIndex $plmnElems]

                    foreach MCC [split $mcc "," ] MNC [split $mnc ","] { 
                      if { $i > 0 } {
                         lappend ieList "equivalentPLMNs=\{MCC=$MCC MNC=$MNC\}"
                      } else {
                         lappend ieList "\{MCC=$MCC MNC=$MNC\}"
                      }
                      set i [incr i]
                    }
               }
               
               print -info "ieList $ieList"
               return "equivalentPLMNs=[join $ieList " "]"
          }
          "forbiddenTA" {
               foreach taElems [split $paramIndices ";"] {
                    print -info "taElems $taElems"
                    #Retrieving plmn index and deleting it from the list
                    set plmnIndex [string range $taElems 0 0]
                    set taElems [string trimleft $taElems "$plmnIndex,"]
                    print -info "plmnIndex $plmnIndex taElems $taElems"
                    
                    set mcc [getIEVal -ieType "gwMcc" -ieIndex $plmnIndex]
                    set mnc [getIEVal -ieType "gwMnc" -ieIndex $plmnIndex]
                    #tacInd is of noOfTacs,tacIndex format
                    set tacs [getIEVal -ieType "forbTacs" -ieIndex $taElems]
                    
                    lappend forbTa "{pLMN_Identity={MCC=$mcc MNC=$mnc} forbiddenTACs=$tacs}"
               }
               set ieList "[join $forbTa ","]"
               print -info "ieList $ieList"
               return $ieList
          }
          "forbiddenLA" {
               foreach laElems [split $paramIndices ";"] {
                    print -info "laElems $laElems"
                    foreach {plmnIndex noOfLacs} [split $laElems ","] {break}
                    print -info "plmnIndex $plmnIndex noOfLacs $noOfLacs"
                    
                    set mcc [getIEVal -ieType "gwMcc" -ieIndex $plmnIndex]
                    set mnc [getIEVal -ieType "gwMnc" -ieIndex $plmnIndex]
                    set lacs [getIEVal -ieType "forbLacs" -ieIndex $noOfLacs]
                    
                    lappend forbLa "{pLMN_Identity={MCC=$mcc MNC=$mnc} forbiddenLACs=$lacs}"
               }
               
               set ieList "[join $forbLa ","]"
               print -info "ieList $ieList"
               return $ieList
               
          }
          "globalEnbId" {
               if {$paramIndices == "x"} {
                    set eNBType  "macro"
                    set henbId   [random 65000]
                    set henbMnc   [getRandomUniqueListInRange 10 999]
                    set henbMcc   [getRandomUniqueListInRange 100  999]
                    
               } else {
                    set eNBType  [getFromTestMap -HeNBIndex $paramIndices -param "eNBType"]
                    set henbId   [getFromTestMap -HeNBIndex $paramIndices -param "HeNBId"]
                    set henbMnc   [lindex [lindex [getFromTestMap -HeNBIndex $paramIndices -param "MNC"] 0] 0]
                    set henbMcc   [lindex [lindex [getFromTestMap -HeNBIndex $paramIndices -param "MCC"] 0] 0]
               }
               set globalEnbId "{eNB_ID={${eNBType}ENB_ID=$henbId} pLMNidentity={MCC=$henbMcc MNC=$henbMnc}}"
               return $globalEnbId
          }
          "globaleNBid" {
               set eNBType [lindex [split $paramIndices ","] 1]
               set henbindex [lindex [split $paramIndices ","] 0]
               if {$henbindex == "x"} {
                    switch $eNBType {
                         "macro" {
                              set henbId   [random 65000]
                              set henbMnc   [getRandomUniqueListInRange 10 999]
                              set henbMcc   [getRandomUniqueListInRange 100  999]
                         }
                         "home" {
                              set henbId   [random 268435455]
                              set henbMnc   [getRandomUniqueListInRange 10 999]
                              set henbMcc   [getRandomUniqueListInRange 100  999]
                         }
                    }
               } else {
                    switch $eNBType {
                         "macro" {
                              set henbId    [getFromTestMap -HeNBIndex $henbindex  -param "HeNBId"]
                              set henbMnc   [lindex [lindex [getFromTestMap -HeNBIndex $henbindex  -param "MNC"] 0] 0]
                              set henbMcc   [lindex [lindex [getFromTestMap -HeNBIndex $henbindex  -param "MCC"] 0] 0]
                         }
                         "home" {
                              set henbId    [getFromTestMap -HeNBIndex $henbindex  -param "HeNBId"]
                              set henbMnc   [lindex [lindex [getFromTestMap -HeNBIndex $henbindex -param "MNC"] 0] 0]
                              set henbMcc   [lindex [lindex [getFromTestMap -HeNBIndex $henbindex -param "MCC"] 0] 0]
                         }
                    }
               }
               set globaleNBid "{eNB_ID={${eNBType}ENB_ID=$henbId} pLMNidentity={MCC=$henbMcc MNC=$henbMnc}}"
               return $globaleNBid
          }
          
          "tgtTai" {
               if {$paramIndices == "x"} {
                    set tac   [random 65000]
                    set mnc   [getRandomUniqueListInRange 10 999]
                    set mcc   [getRandomUniqueListInRange 100  999]
               } else {
                    set tac   [getFromTestMap -HeNBIndex $HeNBIndex -param "TAC"]
                    set mnc   [lindex [lindex [getFromTestMap -HeNBIndex $HeNBIndex -param "MNC"] $paramIndices] 0]
                    set mcc   [lindex [lindex [getFromTestMap -HeNBIndex $HeNBIndex -param "MCC"] $paramIndices] 0]
               }
               set tai "{pLMNidentity={MCC=$mcc MNC=$mnc} tAC=$tac}"
               return $tai
               
          }
          "UEAggrBitRate" {
               set ieList ""
               foreach ele1 {uEaggregateMaximumBitRateDL uEaggregateMaximumBitRateUL} ele2 [split $paramIndices ,] ele3 "maxBitRateDl maxBitRateUl" {
                    if {$ele2 != 0 || $ele2 != ""} {
                         set value [getIEVal -ieType "bitRate" -UEIndex $UEIndex -ieIndex "$ele2,$ele3"]
                         set ueAggrMaxBitRateUl [getIEVal -ieType "bitRate" -UEIndex $UEIndex -ieIndex "$paramIndices,maxBitRateUl"]
                         #set ele4 [ string map "maxBitRateDl  uEaggregateMaximumBitRateDL maxBitRateUl uEaggregateMaximumBitRateUL" $ele1 ]
                         append ieList "$ele1=$value "
                    }
               }
          }
          "UESecCapability" {
               set ieList ""
               foreach ele1 {encryptionAlgorithms integrityProtectionAlgorithms} ele2 [split $paramIndices ,] {
                    if {$ele2 != 0 || $ele2 != ""} {
                         set value [getIEVal -ieType "$ele1" -UEIndex $UEIndex -ieIndex "$ele2"]
                         append ieList "$ele1=$value "
                    }
               }
               #set ieList "\{$ieList\}"
          }
          "AllocAndRetPriority" {
               set priorityLevel     [getIEVal -ieType "priorityLevel" -UEIndex $UEIndex -ieIndex $paramIndices]
               set preEmptionCap     [getIEVal -ieType "preEmptionCap" -UEIndex $UEIndex -ieIndex $paramIndices]
               set preEmptionVul     [getIEVal -ieType "preEmptionVal" -UEIndex $UEIndex -ieIndex $paramIndices]
               #set ieList "\{priorityLevel=$priorityLevel pre_emptionCapability=$preEmptionCap preemeptionvulnerability=$preEmptionVul\}"
               set ieList "priorityLevel=$priorityLevel pre_emptionCapability=$preEmptionCap pre_emptionVulnerability=$preEmptionVul"
          }
          "GBRQos" {
               set eRabMaxBitRateDl  [getIEVal -ieType "bitRate" -UEIndex $UEIndex -ieIndex "$paramIndices,maxBitRateDl"]
               set eRabMaxBitRateUl  [getIEVal -ieType "bitRate" -UEIndex $UEIndex -ieIndex "$paramIndices,maxBitRateUl"]
               set eRabGrBitRateDl   [getIEVal -ieType "bitRate" -UEIndex $UEIndex -ieIndex "$paramIndices,grBitRateDl"]
               set eRabGrBitRateUl   [getIEVal -ieType "bitRate" -UEIndex $UEIndex -ieIndex "$paramIndices,grBitRateUl"]
               #set ieList "\{ e_RAB_MaximumBitrateDL=$eRabMaxBitRateDl e_RAB_MaximumBitrateUL=$eRabMaxBitRateUl \
                         e_RAB_GuaranteedBitrateDL=$eRabGrBitRateDl e_RAB_GuaranteedBitrateUL=$eRabGrBitRateUl\}"
               set ieList "e_RAB_MaximumBitrateDL=$eRabMaxBitRateDl e_RAB_MaximumBitrateUL=$eRabMaxBitRateUl \
                         e_RAB_GuaranteedBitrateDL=$eRabGrBitRateDl e_RAB_GuaranteedBitrateUL=$eRabGrBitRateUl"
          }
          "eRABLevelQosInfo" {
               set QCI                 [getIEVal -ieType "QCI" -ieIndex $paramIndices]
               set AllocAndRetPriority [generateIEs -IEType "AllocAndRetPriority"  -paramIndices $paramIndices \
                         -HeNBIndex $HeNBIndex -UEIndex $UEIndex]
               set GBRQos              [generateIEs -IEType "GBRQos"  -paramIndices $paramIndices \
                         -HeNBIndex $HeNBIndex -UEIndex $UEIndex]
               set ieList "qCI=$QCI allocationRetentionPriority=$AllocAndRetPriority gbrQosInformation=$GBRQos"
          }
          "ERABs" {
               set ieList ""
               if {[isDigit $paramIndices]} {
                    set erabStartId  0
                    set paramIndices "$paramIndices,0,1,1,1,1,0,0"
               }
               foreach ieSubList [split $paramIndices ";"] {
                    foreach {noOfErabs startERAB e_RAB_ID eRABLevelQosInfo address gtpTeid naslen correlationID} [split $ieSubList ","] {break}
                    for {set erab $startERAB} {$erab < [expr $noOfErabs + $startERAB]} {incr erab} {
                         set erabList ""
                         foreach ele "e_RAB_ID eRABLevelQosInfo address gtpTeid naslen correlationID" {
                              if {[info exists $ele]} {
                                   if {$ele == "e_RAB_ID" || [set $ele] != 0} {
                                        switch -regexp $ele {
                                             "e_RAB_ID|address|gtpTeid|correlationID" {
                                                  set param    [string map "gtpTeid gtpTEID address transAddr" $ele]
                                                  set $ele     [getIEVal -ieType "$param" -ieIndex $erab]
                                             }
                                             "naslen" {
                                                  set naslen     [getIEVal -ieType "naslen" -ieIndex $naslen]
                                             }
                                             "eRABLevelQosInfo" {
                                                  set eRABLevelQosInfo   [generateIEs -IEType "eRABLevelQosInfo" -paramIndices $erab -HeNBIndex $HeNBIndex -UEIndex $UEIndex -MMEIndex $MMEIndex]
                                             }
                                        }
                                        set ele1 [ string map "e_RAB_ID e_RAB_ID gtpTeid gTP_TEID  address transportLayerAddress naslen nAS_PDU \
                                                  correlationID correlation_ID_ext eRABLevelQosInfo e_RABLevelQoSParameters" $ele ]
                                        append erabList "$ele1=[set $ele] "
                                   }
                              }
                         }
                         lappend ieList "{$erabList}"
                    }
               }
               set ieList "[join $ieList ","]"
               print -info $ieList
               return $ieList
          }
          "MDTConfig" {
              foreach {tacInd plmnInd} [split 0,0 ","] {break}
              set mcc [getIEVal -ieType "bcMCC" -ieIndex $plmnInd -HeNBIndex $HeNBIndex]
              set mnc [getIEVal -ieType "bcMNC" -ieIndex $plmnInd -HeNBIndex $HeNBIndex]
              set plmn "{MCC=$mcc MNC=$mnc}"
              set mdt_Activation "immediate_MDT_only"
              #set mdt_Activation "immediate-MDT-only"

              return "{areaScopeOfMDT={ cellBased={ cellIdListforMDT={ cell_ID=1 pLMNidentity=[set plmn] } } } \
                  mDTMode={loggedMDT={loggingDuration=m10 loggingInterval=ms128 } }  mdt_Activation=$mdt_Activation }"

          }
          "eRABsList" {
               set ieList ""
               foreach ieSubList [split $paramIndices ";"] {
                    foreach {noOfErabs startERAB causeType cause} [split $ieSubList ","] {break}
                    if {$noOfErabs == "0"} {
                         foreach ele "causeType cause" {
                              append erabList "$ele=[set $ele] "
                         }
                         lappend ieList "{$erabList}"
                    } else {
                         for {set e_RAB_ID $startERAB} {$e_RAB_ID < [expr $noOfErabs + $startERAB]} {incr e_RAB_ID} {
                              set erabList ""
                              foreach ele "e_RAB_ID {causeType cause}" {
                                   if {$ele != "e_RAB_ID" } {
                                        append erabList "cause=\{$causeType=$cause \} "
                                   } else {
                                        append erabList "$ele=[set $ele] "
                                   }
                              }
                              lappend ieList "{$erabList}"
                         }
                    }
               }
               set ieList "[join $ieList ","]"
               print -info $ieList
               return $ieList
          }
          "ERABsForwardingItem" {
               #-    --------- IE STRUCTURE ----------
               #-
               #-    >E-RABs Subject to Forwarding Item IEs (1 to <maxnoof E-RABs>)
               #-        >>E-RAB ID                       M
               #-        >>DL Transport Layer Address     O
               #-        >>DL GTP-TEID                    O
               #-        >>UL Transport Layer Address     O
               #-        >>UL GTP-TEID                    O
               #-
               
               set ieList ""
               if {[isDigit $paramIndices]} {
                    set erabStartId    0
                    set erabId         1
                    set dlTransAddress 1
                    set dlGtpTeid      1
                    set ulTransAddress 1
                    set ulGtpTeid      1
                    set paramIndices   "$paramIndices,$erabStartId,$erabId,$dlTransAddress,$dlGtpTeid,$ulTransAddress,$ulGtpTeid"
               } elseif {[llength [split [lindex [split $paramIndices ";"] 0] ","]] == "2"} {
                    set sub2 ""
                    foreach sub1 [split $paramIndices ";"] {
                         foreach {noOfErabs erabStartId} [split $sub1 ","] {break}
                         lappend sub2 "$noOfErabs,$erabStartId,1,1,1,1,1"
                    }
                    set paramIndices [join $sub2 ";"]
               }
               foreach ieSubList [split $paramIndices ";"] {
                    foreach {noOfErabs erabStartId e_RAB_ID dL_transportLayerAddress dL_gTP_TEID uL_TransportLayerAddress uL_GTP_TEID} [split $ieSubList ","] {break}
                    for {set erab $erabStartId} {$erab < [expr $noOfErabs + $erabStartId]} {incr erab} {
                         set erabList ""
                         foreach ele1 "e_RAB_ID dL_transportLayerAddress dL_gTP_TEID uL_TransportLayerAddress uL_GTP_TEID" \
                                   ele2 "e_RAB_ID transAddr gtpTEID transAddr gtpTEID" {
                                        if {[info exists $ele1]} {
                                             if {$ele1 == "e_RAB_ID" || [set $ele1] != 0} {
                                                  set $ele1     [getIEVal -ieType "$ele2" -ieIndex $erab]
                                                  append erabList "$ele1=[set $ele1] "
                                             }
                                        }
                                   }
                         lappend ieList "{[string trim $erabList]}"
                    }
               }
               set ieList "[join $ieList ","]"
               print -info $ieList
               return $ieList
          }
          "ERABsSetupItem" {
               #-    --------- IE STRUCTURE ----------
               #-
               #-    >E-RABs To Be Setup Item IEs
               #-        >>E-RAB ID                       M
               #-        >>Transport Layer Address        M
               #-        >>GTP-TEID                       M
               #-        >>E-RAB Level QoS Parameters     M
               #-        >>Data Forwarding Not Possible   O
               #-
               
               set ieList ""
               if {[isDigit $paramIndices]} {
                    set erabStartId    0
                    set erabId         1
                    set transAddress   1
                    set gtpTeid        1
                    set eRabQOS        1
                    set dataForwarding 0
                    set paramIndices   "$paramIndices,$erabStartId,$erabId,$transAddress,$gtpTeid,$eRabQOS,$dataForwarding"
               } elseif {[llength [split [lindex [split $paramIndices ";"] 0] ","]] == "2"} {
                    set sub2 ""
                    foreach sub1 [split $paramIndices ";"] {
                         foreach {noOfErabs erabStartId} [split $sub1 ","] {break}
                         lappend sub2 "$noOfErabs,$erabStartId,1,1,1,1,0"
                    }
                    set paramIndices [join $sub2 ";"]
               }
               
               foreach ieSubList [split $paramIndices ";"] {
                    foreach {noOfErabs erabStartId e_RAB_ID address GTPTEID ErabLevelQosInfo DataForwardingNotPossible} [split $ieSubList ","] {break}
                    for {set erab $erabStartId} {$erab < [expr $noOfErabs + $erabStartId]} {incr erab} {
                         set erabList ""
                         foreach ele1 "e_RAB_ID address GTPTEID ErabLevelQosInfo DataForwardingNotPossible" \
                                   ele2 "e_RAB_ID transAddr gtpTEID eRABLevelQosInfo dataForwarding" {
                                        if {[info exists $ele1]} {
                                             if {$ele1 == "e_RAB_ID" || [set $ele1] != 0} {
                                                  switch -regexp $ele1 {
                                                       "ErabLevelQosInfo" {
                                                            set $ele1 [generateIEs -IEType "eRABLevelQosInfo" -paramIndices $erab -HeNBIndex $HeNBIndex -UEIndex $UEIndex -MMEIndex $MMEIndex]
                                                       }
                                                       "dataForwarding" {
                                                            set $ele1 [set $ele1]
                                                       }
                                                       default {
                                                            set $ele1 [getIEVal -ieType "$ele2" -ieIndex $erab]
                                                       }
                                                  }
                                                  append erabList "$ele1=[set $ele1] "
                                             }
                                        }
                                   }  
                         lappend ieList "{[string trim $erabList]}"
                    }
               }
               set ieList [string map "e_RAB_ID e_RAB_ID address transportLayerAddress GTPTEID gTP_TEID ErabLevelQosInfo e_RABlevelQosParameters DataForwardingNotPossible data_Forwarding_Not_Possible_ext" $ieList] 
               set ieList "[join $ieList ","]"
               print -info $ieList
               return $ieList
          }
          "ERABsAdmittedItem" {
               #-    --------- IE STRUCTURE ----------
               #-
               #-    >E-RABs Admitted Item IEs
               #-        >>E-RAB ID                       M
               #-        >>Transport Layer Address        M
               #-        >>GTP-TEID                       M
               #-        >>DL Transport Layer Address     O
               #-        >>DL GTP-TEID                    O
               #-        >>UL Transport Layer Address     O
               #-        >>UL GTP-TEID                    O
               #-
               
               set ieList ""
               if {[isDigit $paramIndices]} {
                    set erabStartId    0
                    set erabId         1
                    set transAddr      1
                    set gtpTeid        1
                    set dlTransAddress 0
                    set dlGtpTeid      0
                    set ulTransAddress 0
                    set ulGtpTeid      0
                    set paramIndices   "$paramIndices,$erabStartId,$erabId,$transAddr,$gtpTeid,$dlTransAddress,$dlGtpTeid,$ulTransAddress,$ulGtpTeid"
               } elseif {[llength [split [lindex [split $paramIndices ";"] 0] ","]] == "2"} {
                    set sub2 ""
                    foreach sub1 [split $paramIndices ";"] {
                         foreach {noOfErabs erabStartId} [split $sub1 ","] {break}
                         lappend sub2 "$noOfErabs,$erabStartId,1,1,1,0,0,0,0"
                    }
                    set paramIndices [join $sub2 ";"]
               }
               
               foreach ieSubList [split $paramIndices ";"] {
                    foreach {noOfErabs erabStartId e_RAB_ID transportLayerAddress gTP_TEID dL_transportLayerAddress dL_gTP_TEID uL_TransportLayerAddress uL_GTP_TEID} [split $ieSubList ","] {break}
                    for {set erab $erabStartId} {$erab < [expr $noOfErabs + $erabStartId]} {incr erab} {
                         set erabList ""
                         foreach ele1 "e_RAB_ID transportLayerAddress gTP_TEID dL_transportLayerAddress dL_gTP_TEID uL_TransportLayerAddress uL_GTP_TEID" \
                                   ele2 "e_RAB_ID transAddr gtpTEID transAddr gtpTEID transAddr gtpTEID" {
                                        if {[info exists $ele1]} {
                                             if {$ele1 == "e_RAB_ID" || [set $ele1] != 0} {
                                                  set $ele1     [getIEVal -ieType "$ele2" -ieIndex $erab]
                                                  append erabList "$ele1=[set $ele1] "
                                             }
                                        }
                                   }
                         lappend ieList "{[string trim $erabList]}"
                    }
               }
               set ieList "[join $ieList ","]"
               print -info $ieList
               return $ieList
          }
          "ERABsSwitchedList" {
               #-   --------- IE STRUCTURE ----------
               #-
               #-   >E-RABs Switched in Downlink Item IEs
               #-        >>E-RAB ID                       M
               #-        >>Transport layer address        M
               #-        >>GTP-TEID                       M
               #-
               #-   >E-RABs Switched in Uplink Item IEs
               #-        >>E-RAB ID                       M
               #-        >>Transport Layer Address        M
               #-        >>GTP-TEID                       M
               #-
               
               set ieList ""
               if {[isDigit $paramIndices]} {
                    set erabStartId    0
                    set e_RAB_ID       1
                    set transAddr      1
                    set gTP_TEID       1
                    set paramIndices   "$paramIndices,$erabStartId,$e_RAB_ID,$transAddr,$gTP_TEID"
               } elseif {[llength [split [lindex [split $paramIndices ";"] 0] ","]] == "2"} {
                    set sub2 ""
                    foreach sub1 [split $paramIndices ";"] {
                         foreach {noOfErabs erabStartId} [split $sub1 ","] {break}
                         lappend sub2 "$noOfErabs,$erabStartId,1,1,1"
                    }
                    set paramIndices [join $sub2 ";"]
               }
               
               foreach ieSubList [split $paramIndices ";"] {
                    foreach {noOfErabs erabStartId e_RAB_ID transportLayerAddress gTP_TEID} [split $ieSubList ","] {break}
                    for {set erab $erabStartId} {$erab < [expr $noOfErabs + $erabStartId]} {incr erab} {
                         set erabList ""
                         foreach ele1 "e_RAB_ID transportLayerAddress gTP_TEID" \
                                   ele2 "e_RAB_ID transAddr gtpTEID" {
                                        if {[info exists $ele1]} {
                                             if {$ele1 == "e_RAB_ID" || [set $ele1] != 0} {
                                                  set $ele1     [getIEVal -ieType "$ele2" -ieIndex $erab]
                                                  append erabList "$ele1=[set $ele1] "
                                             }
                                        }
                                   }
                         lappend ieList "{[string trim $erabList]}"
                    }
               }
               set ieList "[join $ieList ","]"
               print -info $ieList
               return $ieList
          }
          
          "ENBStatusTransfer" {
               set rxStatePdcpSdVal [ string repeat 0 1024 ]
               set ieList ""
               foreach ieSubList [split $paramIndices ";"] {
                    foreach { erbId dlHfn dlPdcpSn ulHfn ulPdcpSn rxStatePdcpSd } [ split $ieSubList , ] { break }
                    set ieElem "bearers_SubjectToStatusTransferList=\{e_RAB_ID=[set erbId] dL_COUNTvalue={hFN=[set dlHfn] pDCP_SN=[set dlPdcpSn]} uL_COUNTvalue={hFN=[set ulHfn] pDCP_SN=[set ulPdcpSn]}"
                    if { $rxStatePdcpSd } { append ieElem " receiveStatusofULPDCPSDUs=$rxStatePdcpSdVal" }
                    append ieElem "\}"
                    lappend ieList [ list $ieElem ]
               }
               return  [ join $ieList , ]
          }

          "interSystemInfoTransferTypeEDT" {
          
          set rIMRoutingAddressType [ lindex "gERAN_Cell_ID targetRNC_ID" [getRandomUniqueListInRange 0 1] ]
          set LAI          [generateIEs -IEType "LAI" -paramIndices "0,0"  -HeNBIndex $HeNBIndex]
          set rac          [getRandomUniqueListInRange 0 255]
          set rIMInfo      "10"
          set rIMRtngAddRes ""

          switch  $rIMRoutingAddressType {
               

               "gERAN_Cell_ID" {
                    set cI           [getRandomUniqueListInRange 0 1]
                    set  rIMRtngAddRes "rIMRoutingAddress=\{gERAN_Cell_ID=\{cI=$cI lAI=\{[lindex $LAI 0]\} rAC=$rac\}\}"
               }
               "targetRNC_ID" {
                    set rncId        [getRandomUniqueListInRange 0 4095 ]
                    set rIMRtngAddRes  "rIMRoutingAddress=\{targetRNC_ID=\{lAI=\{[lindex $LAI 0 ] \} rAC=$rac rNC_ID=$rncId\}\}"
               }
          }
          
          set result "\{ rIMTransfer=\{rIMInformation=$rIMInfo $rIMRtngAddRes \} \}"
          return $result
     }
          "eRABSubjecttoDataForwardingList" {
               foreach ele1 "e_RAB_ID transAddr gtpTEID transAddr gtpTEID transAddr" {
                    set $ele1     [getIEVal -ieType "$ele1" -ieIndex "0" ]
               }
               set result "\{dL_gTP_TEID=$gtpTEID dL_transportLayerAddress=$transAddr e_RAB_ID=$e_RAB_ID \
                         uL_GTP_TEID=$gtpTEID uL_TransportLayerAddress=$transAddr\}"
               return $result
          }
          
          "cdma2000OneXSRVCCInfo" {
               set cdma2000OneXMEID "10101010101"
               set cdma2000OneXMSI  "10101010101"
               set cdma2000OneXPilot "10101010101"
               set result "\{cdma2000OneXMEID=$cdma2000OneXMEID cdma2000OneXMSI=$cdma2000OneXMSI cdma2000OneXPilot=$cdma2000OneXPilot\}"
               return $result
          }

          
          "default" {
               print -info "No IE Type is matched, got $IEType"
               exit
          }
     }
     
     print -info "$IEType : $ieList"
     return [list $ieList]
}

proc getIEVal {args} {
     #-
     #-Procedure for generating Value of particular IE
     #-
     
     parseArgs args \
               [list \
               [list HeNBIndex          optional   "numeric" "0"      "Index of HeNB whose values need to be retrieved" ] \
               [list UEIndex            optional   "numeric" "0"      "Index of UE whose values need to be retrieved" ] \
               [list MMEIndex           optional   "numeric" "0"      "Index of MME whose values need to be retrieved" ] \
               [list GUMMEIIndex        optional   "string"  "0"      "Index of GUMMEIIndex of MME whose values need to be retrieved" ] \
               [list ieType             mandatory   "string"  ""      "parameter/IE type" ] \
               [list ieIndex            optional   "string"  ""      "parameter Index list from script" ] \
               ]
     
     global ARR_LTE_TEST_PARAMS
     global ARR_LTE_TEST_PARAMS_MAP
     
     set ieVal ""
     switch $ieType {
          "TAC" {
               if {$ieIndex == "x"} {
                    set tac [random 65535]
                    print -info "Generating random TAC value: $tac"
               } else {
                    set tac [getFromTestMap -HeNBIndex $HeNBIndex -param "TAC"]
                    print -info "Reading TAC value from HeNB index $HeNBIndex: $tac"
               }
               set ieVal "$tac"
          }
          
          "bcMCC" {
               if {$ieIndex == "x" } {
                    set mcc [getRandomUniqueListInRange 100 999]
                    print -info "Generating random MCC value: $mcc"
                    
               } elseif {[regexp {y=(\d+):(\d+)} $ieIndex -> mccVal mncVal ] } {
                    
                    set mcc $mccVal
               } else {
                    set mccList [getFromTestMap -HeNBIndex $HeNBIndex -param "MCC"]
                    set mcc [getListElem -ind $ieIndex -lst $mccList]
                    print -info "Reading MCC value of index $ieIndex from HeNB index $HeNBIndex: $mcc"
               }
               set ieVal "$mcc"
          }
          "bcMNC" {
               
               if {$ieIndex == "x" } {
                    set mnc [getRandomUniqueListInRange 10 999]
                    print -info "Generating random MNC value: $mnc"
                    
               } elseif {[regexp {y=(\d+):(\d+)} $ieIndex -> mccVal mncVal ] } {
                    
                    set mnc $mncVal
                    
               } else {
                    set mncList [getFromTestMap -HeNBIndex $HeNBIndex -param "MNC"]
                    set mnc [getListElem -ind $ieIndex -lst $mncList]
                    print -info "Reading MNC value of index $ieIndex from HeNB index $HeNBIndex: $mnc"
               }
               set ieVal "$mnc"
          }
          
          "serMCC" {
               if {$ieIndex == "x"} {
                    set mcc [getRandomUniqueListInRange 100 999]
                    print -info "Generating random MCC value"
               } else {
                    set mccList [getFromTestMap -MMEIndex $MMEIndex -GUMMEIIndex $GUMMEIIndex -param "MCC"]
                    set mcc [getListElem -ind $ieIndex -lst $mccList]
                    print -info "Reading MCC value of index $ieIndex from MME index $MMEIndex,GUMMEI Index $GUMMEIIndex: $mcc"
               }
               set ieVal "$mcc"
          }
          "serMNC" {
               if {$ieIndex == "x"} {
                    print -info "Generating random MCC value"
                    set mnc [getRandomUniqueListInRange 10 999]
               } else {
                    set mncList [getFromTestMap -MMEIndex $MMEIndex -GUMMEIIndex $GUMMEIIndex -param "MNC"]
                    set mnc [getListElem -ind $ieIndex -lst $mncList]
                    print -info "Reading MNC value of index $ieIndex from MME index $MMEIndex,GUMMEI Index $GUMMEIIndex: $mnc"
               }
               set ieVal "$mnc"
          }
          "MMEC" {
               if {$ieIndex == "x"} {
                    print -info "Generating random MMEC value"
                    set mmec [random 255]
               } else {
                    set mmecList [getFromTestMap -MMEIndex $MMEIndex -GUMMEIIndex $GUMMEIIndex -param "MMECode"]
                    set mmec [getListElem -ind $ieIndex -lst $mmecList]
               }
               set ieVal "$mmec"
               
          }
          "MMEGI" {
               if {$ieIndex == "x"} {
                    print -info "Generating random MMEGI value"
                    set mmegi [random 65535]
               } else {
                    set mmegiList [getFromTestMap -MMEIndex $MMEIndex -GUMMEIIndex $GUMMEIIndex -param "MMEGroupId"]
                    set mmegi [getListElem -ind $ieIndex -lst $mmegiList]
               }
               set ieVal "$mmegi"
          }
          "CGI" {
               if {[regexp {^x$} $ieIndex]} {
                    set cgi [random 268435455]
                    print -info "Generating random CGI value: $cgi"
               } elseif {[regexp {x=\d+} $ieIndex]} {
                    set cgi [lindex [split $ieIndex "="] 1]
                    print -info "Generating user input CGI value: $cgi"
               } else {
                    if {![info exists ::IS_HENB]} {
                         set eNBType [getFromTestMap -HeNBIndex $HeNBIndex -param "eNBType"]
                         print -info "Getting eCGI value of eNBType $eNBType"
                         if {$eNBType == "macro"} {
                              set cgi [getCGIdFromeNBId [getFromTestMap -HeNBIndex $HeNBIndex -param "HeNBId"]]
                         } else {
                              set cgi [getFromTestMap -HeNBIndex $HeNBIndex -param "HeNBId"]
                         }
                    } else {
                         print -info "Getting eCGI value of eNBType HeNB"
                         set cgi [getFromTestMap -HeNBIndex $HeNBIndex -param "HeNBId"]
                    }
                    print -info "CGI value taking from HeNB index $HeNBIndex: $cgi"
               }
               set ieVal "$cgi"
               
          }
          "mTMSI" {
               if {$ieIndex == "x"} {
                    set mTmsi [random 4294967295]
                    print -info "Generating random mTMSI value: $mTmsi"
               } else {
                    set henbId [getFromTestMap -HeNBIndex $HeNBIndex -param "HeNBId"]
                    set ueId   [getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "ueid"]
                    set mTmsi $henbId$ueId
                    print -info "Reading mTMSI value from UE index $UEIndex of HeNB $HeNBIndex: $mTmsi"
               }
               set ieVal "$mTmsi"
          }
          "csgId" {
               if {$ieIndex == "x"} {
                    set csgId 1000
               } else {
                    set csgIdList [getFromTestMap -HeNBIndex $HeNBIndex -param "CSGId"]
                    set csgId [getListElem -ind $ieIndex -lst $csgIdList]
               }
               set ieVal "$csgId"
          }
          "forbTacs" {
               set tacs ""
               foreach tacInd [split $ieIndex ":"] {
                    foreach {noOfTacs tacIndex} [split $tacInd ","] {
                         if {$tacIndex == "x"} {
                              set tacs [concat $tacs [getRandomUniqueListInRange 1 10000 $noOfTacs]]
                         } else {
                              set tacs [concat $tacs [lrange $ARR_LTE_TEST_PARAMS(TAC) $tacIndex [expr $noOfTacs + $tacIndex -1]]]
                         }
                    }
               }
               set tacs [join $tacs ","]
               print -info "forbiddenTacs generated: $tacs"
               set ieVal "$tacs"
          }
          "forbLacs" {
               set lacs ""
               if {[regexp {^\d+$} $ieIndex ]} {
                    set lacs [getRandomUniqueListInRange 1 10000 $ieIndex]
               }
               set lacs [join $lacs ","]
               print -info "forbiddenLacs generated: $lacs"
               set ieVal "$lacs"
          }
          "gwMcc" {
               if {$ieIndex == "x"} {
                    set mcc [getRandomUniqueListInRange 100 999]
                    
               } else {
                    set mcc [lindex $ARR_LTE_TEST_PARAMS(MCC) $ieIndex]
               }
               set ieVal "$mcc"
          }
          "gwMnc" {
               if {$ieIndex == "x"} {
                    set mnc [getRandomUniqueListInRange 10 999]
               } else {
                    set mnc [lindex $ARR_LTE_TEST_PARAMS(MNC) $ieIndex]
                    
               }
               set ieVal "$mnc"
          }
          "serMcc" {
               if {$ieIndex == "x"} {
                    set mcc [getRandomUniqueListInRange 100 999]
                    
               } else {
                    set mcc [lindex $ARR_LTE_TEST_PARAMS(MCC) $ieIndex]
               }
               set ieVal "$mcc"
          }
          "serMnc" {
               if {$ieIndex == "x"} {
                    set mnc [getRandomUniqueListInRange 10 999]
               } else {
                    set mnc [lindex $ARR_LTE_TEST_PARAMS(MNC) $ieIndex]
                    
               }
               set ieVal "$mnc"
          }
          "equivalMcc" {
               set mcc ""
               foreach plmnIndElem [split $ieIndex ":"] {
                    foreach {noOfPlmns plmnIndex} [split $plmnIndElem ","] { break}
                    print -info "noOfPlmns $noOfPlmns plmnIndex $plmnIndex"
                    if {$plmnIndex == "x"} {
                         set mcc [concat $mcc [getRandomUniqueListInRange 100 999 $noOfPlmns]]
                    } else {
                         set mcc [concat $mcc [lrange $ARR_LTE_TEST_PARAMS(MCC) $plmnIndex [expr $noOfPlmns + $plmnIndex - 1]]]
                    }
               }
               set mcc [join $mcc ","]
               print -info "equivalent MCCs generated: $mcc"
               set ieVal "$mcc"
          }
          "equivalMnc" {
               set mnc ""
               foreach plmnIndElem [split $ieIndex ":"] {
                    foreach {noOfPlmns plmnIndex} [split $plmnIndElem ","] { break}
                    print -info "noOfPlmns $noOfPlmns plmnIndex $plmnIndex"
                    if {$plmnIndex == "x"} {
                         set mnc [concat $mnc [getRandomUniqueListInRange 10 999 $noOfPlmns]]
                    } else {
                         set mnc [concat $mnc [lrange $ARR_LTE_TEST_PARAMS(MNC) $plmnIndex [expr $noOfPlmns + $plmnIndex - 1]]]
                    }
               }
               set mnc [join $mnc ","]
               print -info "equivalent MNCs generated: $mnc"
               set ieVal "$mnc"
          }
          "e_RAB_ID" {
               if {[isDigit $ieIndex]} {
                    set ieVal $ieIndex
               } else {
                    set ieVal [random 5 15]
               }
          }
          "QCI" {
               set ieVal $ieIndex
          }
          "transAddr" {
               set ieVal "01010101"
          }
          "gtpTEID" {
               set ieVal [random 9999]
          }
          "correlationID" {
               set ieVal [random 9999]
          }
          "naslen" {
               set ieVal "05120358104f768062ccb90d9b98264bbfb2bd2010555d77652d0900ff493065c731ea4b86"
               #if {$ieIndex == "1"} {
               #     set ieVal [random 1000]
               #} elseif {$ieIndex > 1} {
               #     set ieVal $ieIndex
               #}
          }
          "bitRate" {
               foreach {erab param} [split $ieIndex ,] {break}
               set ieVal [expr 10000 * ($erab + 1)]
          }
          "priorityLevel" {
               set validOptions "lowest highest"
               set ieVal        [lindex $validOptions [expr ($ieVal + 1) % [llength $validOptions]]]
               #set ieVal        [string map "lowest 0  highest 1" $ieVal ] 
          }
          "preEmptionCap" {
               set validOptions "may_trigger_pre_emption shall_not_trigger_pre_emption"
               set ieVal        [lindex $validOptions [expr ($ieVal + 1) % [llength $validOptions]]]
               #set ieVal        [ string map "may_trigger_pre_emption 0 shall_not_trigger_pre_emption 1" $ieVal ]
          }
          "preEmptionVal" {
               set validOptions "not_pre_emptable pre_emptable"
               set ieVal        [lindex $validOptions [expr ($ieVal + 1) % [llength $validOptions]]]
               #set ieVal        [string map  "not_pre_emptable 0 pre_emptable 1" $ieVal ] 
          }
          "encryptionAlgorithms" {
               set validOptions "EEA0 128-EEA1 128-EEA2"
               set validOptions "ae98"
               set ieVal        [lindex $validOptions [expr ($ieVal + 1) % [llength $validOptions]]]
          }
          "integrityProtectionAlgorithms" {
               set validOptions "EIA0 128-EIA1 128-EIA2"
               set validOptions "80ef"
               set ieVal        [lindex $validOptions [expr ($ieVal + 1) % [llength $validOptions]]]
          }
     }
     return $ieVal
}

proc getListElem {args} {
     #-
     #-Procedure for getting element based on index
     #-
     
     parseArgs args \
               [list \
               [list ind          mandatory   "numeric" ""      "Index of HeNB whose values need to be retrieved" ] \
               [list lst            mandatory   "string" ""      "Index of HeNB whose values need to be retrieved" ] \
               ]
     
     set lst [string trim $lst "{}"]
     set len [llength $lst]
     if { $ind >= $len } {
          print -info "Reading last index from List $lst"
          return [lindex $lst [expr $len-1]]
     } else {
          return [lindex $lst $ind]
     }
}

proc UEContextRelSequence {args} {
     #-
     #- Procedure for sending/receiving UE context release messages based upon sequence input given by user
     #- Sequence format: "<simType>,<message>,<operation> <simType>,<message>,<operation> <gw>,<stateToVerify> <otherCommand>"
     #- UEContextRelSequence -sequence "HeNB,UEContextRelReq,send MME,UEContextRelReq,expect GW,ReadyToRelease halt,5"
     #- UEContextRelReq,UEContextRel,UEContextRelComplete,ErrorIndication,Reset
     #-
     
     parseArgs args \
               [list \
               [list sequence           mandatory  "string"  ""                 "specifies sequence of UE context rel messages to be sent or received"] \
               [list MMEIndex           optional   "numeric" "__UN_DEFINED__"   "Index of MME whose values need to be retrieved" ] \
               [list UEIndex            mandatory  "numeric" ""                 "Index of UE whose values need to be retrieved" ] \
               [list HeNBIndex          optional   "numeric" "0"                "Index of HeNB whose values need to be retrieved" ] \
               [list eNBUES1APId        optional   "string"  "__UN_DEFINED__"   "eNB UE S1AP Id value" ] \
               [list MMEUES1APId        optional   "string"  "__UN_DEFINED__"   "MME UE S1AP Id value" ] \
               [list causeType          optional   "string"  "__UN_DEFINED__"   "cause Type value from heNB" ] \
               [list cause              optional   "string"  "__UN_DEFINED__"   "cause value from heNB" ] \
               [list gwContextRelInd    optional   "string"  "__UN_DEFINED__"   "Gateway Context Release Indication value from heNB" ] \
               ]
     
     if {![info exists MMEIndex]} {
          ##getFromTestMap returns MMEIndex incase of load balancing case of S1Flex scenario
          if {[getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "MMEIndex"] != -1} {
               set MMEIndex [getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "MMEIndex"]
               print -info "Using MMEIndex $MMEIndex among load balanced MMEs"
          } else {
               #Keeping default value of 0
               set MMEIndex "0"
               print -info "Using default MMEIndex $MMEIndex"
          }
     } else {
          print -info "Using MMEIndex $MMEIndex passed from script"
     }
     
     # <display>
     # display the sequence of operations that we are going to perform
     # make the command name in the same format as defined procedrues (UEContextRel = UEContextRelease)
     set sequence [regsub -all ",UEContextRel(|ease)" $sequence ",UEContextRelease"]
     set sequence [regsub -all ",error(|Indication)"  $sequence ",errorIndication"]
     set sequence [regsub -all "GW,Full"              $sequence "GW,full"]
     set sequence [regsub -all "GW,ReadyToRelease"    $sequence "GW,ready_for_release"]
     
     set validMsgList   "UEContextRelReq UEContextRelease UEContextRelComplete reset errorIndication"
     set invalidSeqList ""
     set seqId 0
     foreach seq $sequence {
          incr seqId
          foreach {sim msg op} [split $seq ","] {break}
          if {$sim == "halt"} {
               print -dbg "[format %.2d $seqId]: Waiting for $msg before next command"
          } elseif {$sim == "GW"} {
               print -dbg "[format %.2d $seqId]: Expect $msg state on $sim"
          } else {
               if {$op == "send"} {
                    print -dbg "[format %.2d $seqId]: [string totitle $op] $msg from $sim"
               } else {
                    print -dbg "[format %.2d $seqId]: [string totitle $op] $msg on $sim"
               }
               if {![regexp "^[join $validMsgList |]$" $msg]} {
                    print -err "\"$msg\" is not a valid UE message to verify UE context release sequence"
                    lappend invalidSeqList [list $msg $seq]
               }
          }
     }
     # <display/>
     
     # <validate seq>
     if {$invalidSeqList != ""} {
          foreach seq $invalidSeqList {
               foreach {msg seq} $seq {break}
               print -fail "\"$msg\" is not valid UE sequence verification message in \"$seq\""
          }
          return -1
     }
     # <validate seq/>
     
     # <code>
     foreach seq $sequence {
          foreach {sim msg op} [split $seq ","] {break}
          switch $sim {
               "halt" {
                    print -nonewline "Before starting next operation ... "
                    halt $msg
                    continue
               }
               "GW" {
                    print -info "Check for UE status to be \"$msg\" on the Gateway"
                    set result [verifyUEContext -state $msg -HeNBIndex $HeNBIndex -UEIndex $UEIndex -MMEIndex $MMEIndex]
               }
               default {
                    if {$msg == "UEContextRelease" } {
                         set msgType "request"
                    } elseif { $msg == "UEContextReleaseComplete" } {
                         set msg "UEContextRelease"
                         set msgType "response"
                    } else {
                         unset -nocomplain msgType
                    }
                    # converting the operation to compatible with what library supports (mostly it will be in lowercase)
                    set op [string tolower $op]
                    
                    set result [updateValAndExecute "$msg -msg msgType -operation op -HeNBIndex HeNBIndex -UEIndex UEIndex -MMEIndex MMEIndex \
                              -eNBUES1APId eNBUES1APId -MMEUES1APId MMEUES1APId -causeType causeType -cause cause -gwContextRelInd gwContextRelInd \
                              -criticalityDiag criticalityDiag -procedureCode procedureCode -triggerMsg triggerMsg -procedureCriticality procedureCriticality \
                              -IECriticality IECriticality -IEId IEId -typeOfError typeOfError -verifyLog verifyLog -streamId streamId -simType sim" ]
               }
          }
          if {$result != 0} {
               print -fail "\"$seq\" verification failed"
               return -1
          }
     }
     # <code/>
     return 0
}

proc processSimulatorOutput {result {dataType mmesim} {parse verify} {verifyLatest no}} {
     #-
     #- To process HeNB/MME simulator output which is going to printed in a aligned format
     #-
     #- will process the data and make a array of elements
     #-
     
     array set arr_local {}
     set dataBlock ""
     
     set result [split [string trim $result] "\n"]
     set result [extractOutputFromResult $result]
    
     if {$dataType == "mmesim"} {
          #To extract only last message contents from output, if verifyLatest is true
          if {$verifyLatest == "yes"} {
               set lineNum 0
               foreach line $result {
                    #if {[findInitSpaces $line] == 0 && ![regexp {(Additional Info)|(StreamID)|(FromAddr)} $line]} 
                    set test [findInitSpaces $line]
                    if {[findInitSpaces $line] == 0 && ![regexp {gwIP|(Additional Info)|(StreamID)|(FromAddr)|(enb_ID.macroENB_ID)} $line]} {
                         lappend msgLineNum $lineNum
                    }
                    incr lineNum
               }
               
               set lastMsgNum [lindex $msgLineNum end]
               set result [lrange $result $lastMsgNum end]
          }
          # extracting the message name from the output
          set arr_local(msgName) [lindex [split [lindex $result 0] ":"] 0]
          
          # start processing the data after message name because the entire data is indented with reference to the next line from message name line
          set result [lrange $result 1 end]
          
     }
     
     set prevSpace [findInitSpaces [lindex $result 0]]
     set initSpace $prevSpace
     set index ""

     array set spaceIndList {} 
     foreach line $result {
          set currSpace [findInitSpaces $line]
          set line [string trim $line]
          if {$line == ""} {continue}
          
          foreach {index1 val} [split $line ":"] {break}
          set index1 [string trim $index1]
          set val    [string trim $val]

          if {$val == ""} {
               if {![regexp "Item" $index1]} {
                  #lappend index $index1
                  set i 0
                  foreach arrEle $index {
                    if {[info exists spaceIndList($arrEle)]} {
                      set eleSpace $spaceIndList($arrEle)
                      if {$currSpace <= $eleSpace} {
                        #regsub $arrEle $index "" index
                        set index [ldelete $index $i]
                      }
                    }
                    incr i
                  }

                  lappend index $index1
                  set spaceIndList($index1) $currSpace
               } else { continue }
          } else {
               if {$currSpace < $prevSpace} {
                  #set index [ldelete $index end]
                  set i 0
                  foreach arrEle $index {
                    if {[info exists spaceIndList($arrEle)]} {
                       set eleSpace $spaceIndList($arrEle)
                       if {$currSpace <= $eleSpace} {
                         set index [ldelete $index $i]
                       }
                    }
                    incr i
                  }
               }

               if {$index == ""} {
                    set arr_local($index1) $val
               } else {
                    lappend arr_local([join $index ","]) $line
               }
          }
          set prevSpace $currSpace
          continue
     }
     
     #parray arr_local ; puts "\n\n"
     if {$dataType == "ueCtx"} {
          return [array get arr_local]
     }

     foreach index [array names arr_local] {
          # multiple ":" indicates it is a container. needs further processing
          if {[regexp -all ":" $arr_local($index) ] == 0} {
               if {( $index == "uEIdentityIndexValue" ) &&  ([ llength $arr_local($index) ] == 2) } {
                    if { [ regexp {\((\d+)\)} [ lindex $arr_local($index) 1 ] - decimalVal ] == 1 } {
                         set arr_local($index) $decimalVal
                    }
               } else {
                    # Handing cases where the value is represented in both hex and deicmal
                    if {[regexp {^0x[a-fA-F0-9]+} $arr_local($index)] && ![regexp {\((\d+)\)} $arr_local($index) - arr_local($index)]} {
                         set arr_local($index) [string trim [regsub (^0x) $arr_local($index) ""]]
                    } elseif {[regexp {(\d+)\(([a-zA-Z]+)\)} $arr_local($index)]} {
                         set arr_local($index) [regsub {\(([a-zA-Z]+)\)} $arr_local($index) ""]
                    } elseif {[regexp {^([a-zA-Z]+) \((\d+)\)} $arr_local($index)]} {
                         set arr_local($index) [lindex [regsub {\((\d+)\)} $arr_local($index) ""] 0]
                    }
               }
               continue
          } elseif {$dataType != "mmesim" && [regexp "PLMN ID" $arr_local($index)] && [regexp -all ":" $arr_local($index) ] > 1} {
               # For context verification from debug door some of the lines would have multiple variables
               regsub "PLMN ID"      $arr_local($index) "PLMNID" arr_local($index)
               regsub -all {( : ?)}  $arr_local($index) ":"      arr_local($index)
               set arr_local($index) [lindex $arr_local($index) 0]
          }
          set count 0
          foreach ele $arr_local($index) {
               foreach {param val} [split $ele ":"] {break}
               set val   [string trim $val]
               set param [string trim $param]

               # when the param is represented as Item, the take the sub-block name to distingush data
               if {[regexp "Item " $param]} {
                    if {[regexp {,} $index]} {
                         set param [lindex [split $index ","] end]
                    } elseif {[regexp {\.} $index]} {
                         #For cases where only "." are present in index
                         set param [lindex [split $index "."] end]
                    }
               }
               
               # for NAS messages, plmn identity will be at multiple places like tai, gummei_id, eUTRAN_CGI etc.,
               # (for ex: initUE ... refer to simOutParserUT.tcl in unitTests directory)
               # below code will handle such cases
               if {[regexp -nocase "^plmn" $param] && ![regexp {global_ENB_ID$} $index]} {
                    set param "[lindex [split $index ,] end],$param"
               }
               # extract the decimal value if it is represented in hex and also in decimal
               if {[regexp {^0x[a-fA-F0-9]+} $val] && ![regexp {\((\d+)\)} $val - val]} {
                    set val [string trim [regsub (^0x) $val ""]]
               } elseif {[regexp {(\d+)\(([a-zA-Z]+)\)} $val]} {
                    set val [regsub {\(([a-zA-Z]+)\)} $val ""]
               } elseif {[regexp {^([a-zA-Z]+) \((\d+)\)} $val]} {
                    set val [lindex [regsub {\((\d+)\)} $val ""] 0]
               }
               
               # supportedTas will be represented as
               # supportedTas -> Tac values
               # supportedTas,broadcastPLMNs -> plmn values
               # below will logic seperates it out
               # below logic will also identifies multiple TAs and index them by their count
               if {[regexp "(supportedTAs|forbiddenLAs)" $index]} {
                    if {[regexp "," $index]} {
                         if {[regexp "(Item 1:)" $ele]} { incr count }
                         # when count is 0, no need to update the count to the param
                         if {$count > 0} { set param "${param}${count}" }
                    } else {
                         incr count
                         set param "broadcastPLMNs${count},${param}"
                    }
               }
               lappend arr_local($param) $val
          }
          
          if {$index == "supportedTAs"} { set arr_local(broadcastPLMNs) $count }
          
          # The reset message, the top line has the resettype defined
          # Extract the data before unsetting the top level index
          if {[regexp "resetType\." $index] && ![regexp "," $index]} {
               foreach {paramT valueT} [split $index "."] {break}
               set arr_local($paramT) $valueT
          }
          unset -nocomplain arr_local($index)
     }
     
     # Some variables are used only for internal simulator reference or may
     # not be logically verified, so unset those variables
     if {$parse == "verify"} {
          foreach ele [list nAS_PDU UEID FromAddr source_ToTarget_TransparentContainer resetType gwIP] {
               if {[info exists arr_local($ele)]} {
                    print -dbg "Ignoring $ele info ..."
                    unset -nocomplain arr_local($ele)
               }
          }
          #Temp workaround to ignore some variables verification for error indication messages only
          if {[info exists arr_local(msgName)]} {
               if {[string tolower $arr_local(msgName)] == "errorindication"} {
                    print -dbg "Ignoring the stream id verification for errorindication messages in output"
                    foreach ele "iE_ID iECriticality typeOfError StreamID" {
		    	unset -nocomplain arr_local($ele)
		    }
                    #unset -nocomplain arr_local(StreamID)
               }

               if {[string tolower $arr_local(msgName)] == "s1setupfailure"} {
                    print -dbg "Ignoring the triggeringMessage verification for s1setupfailure messages in output"
                    unset -nocomplain arr_local(triggeringMessage)
               }
          }
     }
     
     # sort the PLMNs (broadcast plmns)
     #sortPlmnData
     
     # ????? temporary hack to handle stream id when we have multiple messages ?????
     if {[regexp "reset$" [pwd]]} {
          if {[info exists arr_local(StreamID)]} { set arr_local(StreamID) [lsort -unique $arr_local(StreamID)] }
          foreach index [array names arr_local -regexp "^cause"] {
               set arr_local($index) [lsort -unique $arr_local($index)]
          }
     }
     
     printHeader "Processed output data" 50 "-"
     parray arr_local
     print -nolog [string repeat - 50]
     
     return [array get arr_local]
}

proc sortPlmnData {} {
     #-
     #- proc to be used only by processSimInput, processSimulatorOutput  procedures to generate a sorted data list for comparision
     #-
     
     upvar arr_local arr_local
     set paramList "broadcastPLMNs"
     
     foreach param $paramList {
          # sorting is required only if the specified parameter has more than one element
          if {[info exists arr_local($param)] && $arr_local($param) > 1} {
               for {set i 1} {$i <= $arr_local($param)} {incr i} {
                    set param1 ${param}${i}
                    lappend newIndex "$arr_local(${param1}),$param1"
               }
               # cleanup data holder
               unset -nocomplain arr_local1
               array set arr_local1 {}
               set i 0
               foreach index [lsort -dictionary $newIndex] {
                    incr i
                    foreach {val paramx} [split $index ,] {break}
                    set arr_local1(${param}${i}) $val
                    switch $param {
                         "broadcastPLMNs" { set arr_local1(${param}${i},tAC) $arr_local($paramx,tAC) }
                    }
               }
               
               foreach {index val} [array get arr_local1] {
                    uplevel "set arr_local($index) \"$val\""
               }
          }
     }
}

proc createLteIdentifier {args} {
     #-
     #- This procedure is used to construct the LTE identifier
     #- The procedure returns the list of the constructed values
     #-
     
     parseArgs args \
               [list \
               [list identifier       mandatory  "string"       "_"                    "Name of the S1AP message that we are sending"] \
               [list MCC              optional   "numeric"      "__UN_DEFINED__"       "The MNC"] \
               [list MNC              optional   "string"       "__UN_DEFINED__"       "The MNC"] \
               [list TAC              optional   "numeric"      "__UN_DEFINED__"        "The TAC"] \
               ]
     
     set returnList ""
     foreach id $identifier {
          switch $id {
               "PLMNId" {
                    foreach mcc $MCC mnc $MNC {
                         # represent MNC in 3 digit format
                         if {[string length $mnc] == 2} { set mnc "F$mnc" }
                         set plmn ""
                         foreach {mc1 mc2 mc3} [split $mcc ""] {break}
                         foreach {mn1 mn2 mn3} [split $mnc ""] {break}
                         append plmn $mc2 $mc1 $mn1 $mc3 $mn3 $mn2
                         lappend plmnList $plmn
                    }
                    lappend returnList $plmnList
               }
               "TAI" {
                    set plmnList [createLteIdentifier -identifier "PLMNId" \
                              -MCC $MCC -MNC $MNC]
                    set plmnList [lindex $plmnList 0]
                    foreach plmn $plmnList {
                         append tai $plmn $TAC
                         lappend taiList $tai
                    }
                    lappend returnList $taiList
               }
          }
     }
     return $returnList
}

proc intTo {integer digits} {
     #-
     #- This procedure is used to construct the LTE identifier
     #- example [intTo 1 3] will give output as 001
     #-
     #- @in integer  the integer to be mapped
     #- @in digits  the digit doundary to be mapped
     #-
     #- @return the integer mapped to the digits boundary
     #-
     
     return [format %.${digits}d $integer]
}

proc isMultiValueIEList {ie} {
     #-
     #- Check if its a multi value list
     #-
     #- @in ie  the ie list to be verified
     #-
     #- @return 1 if it has more than one values 0 on single value
     #-
     
     if {([llength $ie] > 1) || [regexp "," $ie]} {
          return 1
     } else {
          return 0
     }
}

proc trimBraces {ie} {
     # remove the braces from the IE and return
     set ie [ string trim $ie ]
     return [ string trim $ie "{}" ]
}

proc simMsgNameMapper {msgName} {
     #-
     #- Maps the simulator input name to the actual msg name received in the sim output
     #-
     #- @in msgName  The message name as passed in sim input
     #-
     #- @return The mapped sim name as expected in the output
     #-
     
     return [string map " \
               s1setupreq            S1SetupRequest \
               s1setuprsp            S1SetupResponse \
               s1setupfail           S1SetupFailure \
               dlnastransport        DownlinkNASTransport \
               initialuemessage      InitialUEMessage \
               InitialContextReq     InitialContextSetupRequest \
               eRabSetupRequest      E_RABSetupRequest \
               eRabSetupResponse     E_RABSetupResponse \
               eRabReleaseCommand    E_RABReleaseCommand \
               eRabModifyRequest     E_RABModifyRequest \
               eRabReleaseIndication E_RABRELEASEINDICATION \
               eRabModifyRequest     E_RABMODIFYREQUEST \
               eRabModifyResponse    E_RABMODIFYRESPONSE \
               eRabReleaseResponse   E_RABRELEASERESPONSE \
               eRabReleaseIndication E_RABRELEASEINDICATION \
               eRabReleaseCommand    E_RABRELEASECOMMAND \
               pathswitchreqfail     PathSwitchRequestFailure \
               pathswitchreqack      PathSwitchRequestAcknowledge \
               HANDOVERPREPERATIONFAILURE  HANDOVERPREPARATIONFAILURE \
               enbconfigtransfer	ENBConfigurationTransfer \
               enbconfigupdateack  ENBConfigurationUpdateAcknowledge \
               enbconfigupdatefail	ENBConfigurationUpdateFailure \
               enbconfigupdate	      ENBConfigurationUpdate \
               mmeconfigtransfer	MMEConfigurationTransfer \
               writereplacewarningrequest  WriteReplaceWarningRequest \
               writereplacewarningresponse WriteReplaceWarningResponse \
               mmeconfigupdateack	   MMEConfigurationUpdateAcknowledge \
               mmeconfigupdatefail      MMEConfigurationUpdateFailure \
               mmeconfigupdate             MMEConfigurationUpdate \
               " $msgName]
}

proc simIENameMapper {args} {
     #-
     #- Maps the IE name from sim dump to sim command
     #-
     #- @return the expected ieName in the sim command
     #-
     
     parseArgs args \
               [list \
               [list msgName              mandatory  "string"       ""                    "Name of the S1AP message that we are sending"] \
               [list msgType              optional   "string"       ""                    "Type of S1AP message that we are sending"] \
               [list IE                   mandatory  "string"       ""                    "The IE"] \
               [list IEContainer          optional   "string"       ""                    "The IE container name"] \
               ]
     
     if {[regexp -nocase "^(mcc|mnc)$" $IE]} {
          switch -regexp $msgName {
               "s1_setup_request"             {set mappedName broadcastPLMNs}
               "s1_setup_response|s1setuprsp|mme_configuration_update" {set mappedName servedPLMNs}
               "s1_setup_failure"             {set mappedName servedPLMNs}
               default                        {set mappedName $msgName}
          }
          return $mappedName
     }
     # Handle some IEs which has the same name across containers
     set mappedAddress "address1"
     set mappedKey     "securityKey"
     set mappedGwAddr  "gW_TransportLayerAddress"
     set mappedEnbId   "eNB_ID.macroENB_ID"
     if {$IEContainer != ""} {
          switch -regexp [string tolower $IEContainer] {
               "^(erabtobesetupctxtsureq|erabid|erabsetuplist|erabsetupbearersures|erabtobesetupbearersureq|erabtobesetuphoreq)$" { set mappedAddress "transportLayerAddress" }
               "^traceactivation$"    { set mappedAddress "traceCollectionEntityIPAddress" }
               "^securitycontext$"    { set mappedKey     "nextHopParameter"}
               "^erabswitcheddllist$" { set mappedGwAddr  "transportLayerAddress"}
               "^(sourceenbid|targetenbid)$" { set mappedEnbId  "eNB_ID.type"}
          }
     }
     # handling mmecode, mmegroupid for s1 response and initial context req
     switch -regexp [string tolower $msgType] {
          "initialcontextreq|initialue|handoverrequest|overloadstart|overloadstop" {
               switch -regexp [string tolower $IEContainer] {
                    "^stmsi$" {set mappedMMECode    "mMEC"}
                    default   {set mappedMMECode    "mME_Code"}
               }
               set mappedMMEGroupId "mME_Group_ID"
          }
          "paging" {
               set mappedMMECode    "mMEC"
               set mappedMMEGroupId "servedGroupIDs"
          }
          default {
               set mappedMMECode    "servedMMECs"
               set mappedMMEGroupId "servedGroupIDs"
          }
     }
     
     return [string map "\
               msgtype                       msgName\
               mmename                       mMEname\
               mmecode                       $mappedMMECode\
               mmegroupid                    $mappedMMEGroupId\
               mmerelaysupportindicator      mMERelaySupportIndicator\
               criticalitydiag               criticalityDiagnostics\
               globaleNBId                   $mappedEnbId \
               henbmcc                       pLMNidentity \
               henbmnc                       pLMNidentity \
               csgid                         cSG_Id\
               cellidlist                    eCGI \
               tailistforwarning             tAIList \
               errorType                     typeOfError \
               triggeringmsg                 triggeringMessage \
               ieid                          iE_ID  \
               iecriticality                 iECriticality \
               spidrfp                       subscriberProfileIDforRFP \
               forbiddeninterrats            forbiddenInterRATs \
               emccs                         equivalentPLMNs \
               emncs                         equivalentPLMNs \
               smcc                          servingPLMN \
               smnc                          servingPLMN \
               csgidlist                     cSG_Id \
               cndomain                      cNDomain \
               mtmsi                         m_TMSI \
               ueidentityindexvalue          uEIdentityIndexValue \
               RRCEstablishmentCause         rRC_Establishment_Cause \
               cellid                        cell_ID \
               timetowait                    timeToWait \
               dladdress                     dL_transportLayerAddress \
               uladdress                     uL_TransportLayerAddress \
               e_RAB_ID 	             e_RAB_ID \
               dlGtpTeid                     dL_gTP_TEID \
               ulGtpTeid                     uL_GTP_TEID \
               gtpTeid	                     gTP_TEID \
               correlationID                 correlation_ID_ext \
               registeredLAI                 registeredLAI \
               overloadAction                overloadResponse.overloadAction \
               address1 		     $mappedAddress \
               CSFallbackIndicator           cSFallbackIndicator \
               csgMemberShipStatus           cSGMembershipStatus \
               eutrantraceid                 e_UTRAN_Trace_ID \
               interfacestotrace	     interfacesToTrace \
               srvccOperationPossible        sRVCCOperationPossible \
               tracedepth                    traceDepth \
               UERadioCapability             uERadioCapability \
               lac                           lAC \
               iMSI                          uEPagingID.iMSI \
               homeENB_ID                    eNB_ID.homeENB_ID \
               macroENB_ID                   eNB_ID.macroENB_ID \
               macroENBId                    eNB_ID.macroENB_ID \
               StreamNo                      StreamID \
               resettype 		     resetType \
               cellaccessmode                cellAccessMode \
               gatewayaddress                $mappedGwAddr \
               relaynodeindicator            relayNode_Indicator \
               cause.radionetwork            cause.radioNetwork \
               handovertype                  handoverType \
               nexthopchainingcount          nextHopChainingCount \
               securitykey                   $mappedKey \
               rrccontainer                  rRC_Container \
               TgttosrcTransContAIner        target_ToSource_TransparentContainer \
               TargetToSourceContAIner       target_ToSource_TransparentContainer \
               pdcpsn                        pDCP_SN \
               hfn                           hFN \
               uTRAN_Cell                    uE_HistoryInformation \
               eNBX2addresses                eNBX2TransportLayerAddresses \
               sONInformationRequest         sONInformation.sONInformationRequest \
               sONInformationReply           sONInformation.sONInformationReply \
               stratumlevel		     stratumLevel \
               synchronizationstatus	     synchronizationStatus \
               gtptlas                       gTPTLAa \
               ipsectla                      iPsecTLA \
               messageidentifier             messageIdentifier \
               serialnumber                  serialNumber \
               warningmessagecontents        warningMessageContents \
               repetitionperiod              repetitionPeriod \
               numofbroadcastreq             numberofBroadcastRequest \
               emergencyareaidlist           emergencyAreaIDList \
               numbroadcasts                 numberOfBroadcasts \
               concurrentwarningind          concurrentWarningMessageIndicator \
               datACodingscheme              dataCodingScheme \
               extendedrepetitionPeriod      extendedRepetitionPeriod \
               warningsecurityinfo           warningSecurityInfo \
               warningtype                   warningType \
               " $IE]
}

proc mapIEToIEGroup {args} {
     #-
     #- This procedure is used to verify the expected S1AP message against the received one
     #-
     #- @out 0 on pass, -1 fail (mismatch)
     #-
     
     parseArgs args \
               [list \
               [list msgName              mandatory  "string"       ""                    "Name of the S1AP message that we are sending"] \
               [list msgType              optional   "string"       ""                    "Type of S1AP message that we are sending"] \
               [list IE                   mandatory  "string"       ""                    "The IE"] \
               ]
     
     switch -regexp $msgName {
          "s1_setup_request" {
               set mappedIEGroup [string map "\
                         cSG_Id cSG_IdList \
                         eNB_ID.macroENB_ID global_ENB_ID \
                         pLMNidentity global_ENB_ID \
                         pLMNidentity global_ENB_ID \
                         broadcastPLMNs supportedTAs \
                         tAC supportedTAs" $IE]
          }
          "s1_setup_response|s1_setup_failure" {
               set mappedIEGroup [string map "\
                         servedGroupIDs servedGUMMEIs \
                         servedMMECs servedGUMMEIs \
                         servedPLMNs servedGUMMEIs" $IE]
          }
     }
     return $mappedIEGroup
}

proc verifyIEValue {ie rcvdVal expVal} {
     #-
     #- This procedure is used to validate the IE value against the expected value
     #-
     #- @in ie       The IE to be verified
     #- @in rcvdVal  The value to be verified
     #- @in expVal   The value aginst which to be verified
     #-
     #- @return 1 on validation success and 0 on failure
     #-
     
     set rcvdVal [string trim $rcvdVal "\""]
     switch -regexp $ie {
          "msgtype" {
               set toVerify [string map "s1setupreq S1SetupRequest" $rcvdVal]
          }
          "mcc|mnc" {
               #Convert the received value to BCD
               set rcvdVal [format %x $rcvdVal]
               
               print -debug "The verification is as per S1AP specs"
               foreach {mc2 mc1 mn1 mc3 mn3 mn2} [split $rcvdVal ""] {break}
               if {[regexp "mnc" $ie]} {
                    if {[string length $expVal] == 2} {set expVal "f${expVal}"}
                    set toVerify "${mn1}${mn2}${mn3}"
               } else {
                    set toVerify "${mc1}${mc2}${mc3}"
               }
          }
          "pagingdrx" {set toVerify [string tolower $rcvdVal]}
          default     {set toVerify $rcvdVal}
     }
     if {[string trim $toVerify] == [string trim $expVal]} {
          return 1
     }
     return 0
}

proc setUpS1ToMME {args} {
     #-
     #- Procedure to setup an S1 interface towards MME
     #-
     #- @return 0 on success, @return -1 on failure
     #-
     
     set defaultCauseValue "message_not_compatible_with_receiver_state"
     parseArgs args \
               [list \
               [list MMEIndex             optional   "numeric"        "0"                          "The MME index" ] \
               [list streamId             optional   "string"         "0"                          "The sctp string to send or receive data"] \
               [list TAC                  optional   "string"         "__UN_DEFINED__"             "The Broadcasted TAC to be used" ] \
               [list eNBName              optional   "string"         [getLTEParam "HeNBGWName"]   "eNB name"] \
               [list globaleNBId          optional   "string"         [getLTEParam "globaleNBId"]  "eNB ID"] \
               [list pagingDRX            optional   "string"         "v[getLTEParam defaultPagingDrx]" "Pagging DRX value"] \
               [list MCC                  optional   "string"         "__UN_DEFINED__"             "The MCC param to be used"] \
               [list MNC                  optional   "string"         "__UN_DEFINED__"             "The MNC param to be used"] \
               [list MMEName              optional   "string"         "__UN_DEFINED__"             "The MME Name to be sent"] \
               [list HeNBMCC              optional   "string"         "__UN_DEFINED__"             "The MCC param to be used in HeNB"] \
               [list HeNBMNC              optional   "string"         "__UN_DEFINED__"             "The MNC param to be used in HeNB"] \
               [list MMEGroupId           optional   "string"         [getLTEParam "MMEGroupId"]   "The MME group ID to be used"] \
               [list MMECode              optional   "string"         [getLTEParam "MMECode"]      "The MME Code to be used"] \
               [list relMMECapability     optional   "string"         "__UN_DEFINED__"             "The relMMECapability to be used"] \
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
               [list MultiS1Link                 optional     "yes|no"   "no"                            "To know multis1link enable towards mme"] \
               [list typeOfError          optional   "string"         "__UN_DEFINED__"             "Identifies the type of error"] \
               [list supportedTAs          optional   "string"        "__UN_DEFINED__"             "Identifies supported TAI"] \
               [list verifyLog            optional   "start|stop|no"  "no"                         "Option to start log verification"] \
               [list verifyLatest         optional   "yes|no"         "yes"                        "Option to verify latest message's value in output message"] \
               ]
     
     set msgType       "request response"
     set operationType "expect send"

     global ARR_LTE_TEST_PARAMS_MAP
     global prevRegion
     global subReg
     global totalSubReg

     #S1Flex call can have multiple MMEIndexes
     set flag 0
     if {$MultiS1Link == "yes"} {
      if { ! [info exists prevRegion] } {
        set prevRegion 0
      }

      if { ! [info exists subReg] } {
        set subReg 1
      }

      foreach mmeIndex $MMEIndex {
        set MMEId [getFromTestMap -MMEIndex $mmeIndex -param "MMEId"]
        set region [getFromTestMap -MMEIndex $mmeIndex -param "Region"]
        set maxS1Links [getFromTestMap -RegionIndex $region -param "maxS1Links"]
        if {$region == $prevRegion} {
        if { $region == 0 } {
           set subReg 1   
       
	} else {
            set subReg $totalSubReg
            print -info "subReg is in region1 $totalSubReg"
       }
	 } else {
           set prevRegion $region
	set totalSubReg $subReg
         print -info "totalSubreg is $totalSubReg"
        }
 

        for {set i 0} {$i < $maxS1Links} {incr i} {
            set globaleNBId [getFromTestMap -RegionIndex $region -SubRegionIndex $subReg -param "eNBId"]
            print -info "Setting up S1 Interface towards MME for MME with index \"$mmeIndex\""
            set msgType       "request response"
            set operationType "expect send"
            foreach operation $operationType msg $msgType {
               # First expect an S1 setup request from HeNBGW
               # On receving a request send a response from MME simulator
               set result [updateValAndExecute "S1Setup -MMEIndex mmeIndex -msg msg -operation operation \
                         -streamId streamId -TAC TAC -eNBName eNBName -globaleNBId globaleNBId -supportedTAs supportedTAs \
                         opagingDRX pagingDRX -MCC MCC -MNC MNC -MMEName MMEName -HeNBMCC HeNBMCC -MMEGroupId MMEGroupId \
                         -MMECode MMECode -relMMECapability relMMECapability -MMERelaySupportInd MMERelaySupportInd \
                         -timeToWait timeToWait -causeType causeType -cause cause -criticalityDiag criticalityDiag \
                         -procedureCode procedureCode -triggerMsg triggerMsg -procedureCriticality procedureCriticality \
                         -IECriticality IECriticality -IEId IEId -typeOfError typeOfError -verifyLog verifyLog \
                         -verifyLatest verifyLatest -MultiS1Link MultiS1Link"]
               if {$result < 0} {
                    print -fail "$operation of S1 message failed"
                    print -fail "S1 Setup towards MME failed"
                    set flag 1
               } else {
                    print -info "$operation of S1 successfull"
               }

               switch $operation {
                    "send" {
                         # After sending and s1 setup response from MME verify if the MME context is created
                         #set msgType "s1response"
                         set msgType "response"
                         set result [updateValAndExecute "verifyMsgRcvdOnGw -msgType msgType -MMEIndex mmeIndex \
                                   -streamId streamId -TAC TAC -eNBName eNBName -globaleNBId globaleNBId \
                                   -pagingDRX pagingDRX -MCC MCC -MNC MNC -MMEName MMEName -HeNBMCC HeNBMCC -MMEGroupId MMEGroupId \
                                   -MMECode MMECode -relMMECapability relMMECapability -MMERelaySupportInd MMERelaySupportInd \
                                   -timeToWait timeToWait -causeType causeType -cause cause -criticalityDiag criticalityDiag \
                                   -procedureCode procedureCode -triggerMsg triggerMsg -procedureCriticality procedureCriticality \
                                   -IECriticality IECriticality -IEId IEId -typeOfError typeOfError -verifyLog verifyLog -MultiS1Link MultiS1Link"]
                         if {$result < 0} {
                              print -fail "Verification of MME context failed"
                              set flag 1
                         } else {
                              print -info "MME context created"
                         }
                      }
                    default {}
               }
          }
          set subReg [incr subReg]
       }
      }
     } else {
     foreach mmeIndex $MMEIndex {
          print -info "Setting up S1 Interface towards MME for MME with index \"$mmeIndex\""
          foreach operation $operationType msg $msgType {
               # First expect an S1 setup request from HeNBGW
               # On receving a request send a response from MME simulator
               set result [updateValAndExecute "S1Setup -MMEIndex mmeIndex -msg msg -operation operation \
                         -streamId streamId -TAC TAC -eNBName eNBName -globaleNBId globaleNBId -supportedTAs supportedTAs \
                         -pagingDRX pagingDRX -MCC MCC -MNC MNC -MMEName MMEName -HeNBMCC HeNBMCC -MMEGroupId MMEGroupId \
                         -MMECode MMECode -relMMECapability relMMECapability -MMERelaySupportInd MMERelaySupportInd \
                         -timeToWait timeToWait -causeType causeType -cause cause -criticalityDiag criticalityDiag \
                         -procedureCode procedureCode -triggerMsg triggerMsg -procedureCriticality procedureCriticality \
                         -IECriticality IECriticality -IEId IEId -typeOfError typeOfError -verifyLog verifyLog \
                         -verifyLatest verifyLatest"]
               if {$result < 0} {
                    print -fail "$operation of S1 message failed"
                    print -fail "S1 Setup towards MME failed"
                    set flag 1
               } else {
                    print -info "$operation of S1 successfull"
               }
               
               switch $operation {
                    "send" {
                         # After sending and s1 setup response from MME verify if the MME context is created
                         set msgType "s1response"
                         set result [updateValAndExecute "verifyMsgRcvdOnGw -msgType msgType -MMEIndex mmeIndex \
                                   -streamId streamId -TAC TAC -eNBName eNBName -globaleNBId globaleNBId \
                                   -pagingDRX pagingDRX -MCC MCC -MNC MNC -MMEName MMEName -HeNBMCC HeNBMCC -MMEGroupId MMEGroupId \
                                   -MMECode MMECode -relMMECapability relMMECapability -MMERelaySupportInd MMERelaySupportInd \
                                   -timeToWait timeToWait -causeType causeType -cause cause -criticalityDiag criticalityDiag \
                                   -procedureCode procedureCode -triggerMsg triggerMsg -procedureCriticality procedureCriticality \
                                   -IECriticality IECriticality -IEId IEId -typeOfError typeOfError -verifyLog verifyLog"]
                         if {$result < 0} {
                              print -fail "Verification of MME context failed"
                              set flag 1
                         } else {
                              print -info "MME context created"
                         }
                    }
                    default {}
               }
          }
     }
    }
     if {$flag == 1} {
          #return -1
     }
     return 0
}

proc setUpS1ToHeNBGW {args} {
     #-
     #- Procedure to setup an S1 interface towards HeNBGW
     #-
     #- @return 0 on success, @return -1 on failure
     #-
     
     #MMEIndex is expected from script even in case of S1Flex for this procedure and it has to be list of MME indices
     
     set defaultCauseValue "message_not_compatible_with_receiver_state"
     
     parseArgs args \
               [list \
               [list HeNBIndex            optional   "numeric"        "0"                          "The HeNB index" ] \
               [list streamId             optional   "string"         "0"                          "The sctp string to send or receive data"] \
               [list TAC                  optional   "string"         "__UN_DEFINED__"             "The Broadcasted TAC to be used" ] \
               [list eNBName              optional   "string"         [getLTEParam "HeNBGWName"]   "eNB name"] \
               [list eNBType              optional   "home|macro"     "__UN_DEFINED__"             "eNB type"] \
               [list globaleNBId          optional   "string"         [getLTEParam "globaleNBId"]  "eNB ID"] \
               [list pagingDRX            optional   "string"         "v[getLTEParam defaultPagingDrx]" "Pagging DRX value"] \
               [list MCC                  optional   "string"         "__UN_DEFINED__"             "The MCC param to be used"] \
               [list MNC                  optional   "string"         "__UN_DEFINED__"             "The MNC param to be used"] \
               [list MMEName              optional   "string"         "__UN_DEFINED__"             "The MME Name to be sent"] \
               [list HeNBMCC              optional   "string"         "__UN_DEFINED__"             "The MCC param to be used in HeNB"] \
               [list HeNBMNC              optional   "string"         "__UN_DEFINED__"             "The MNC param to be used in HeNB"] \
               [list MMEGroupId           optional   "string"         [getLTEParam "MMEGroupId"]   "The MME group ID to be used"] \
               [list MMECode              optional   "string"         [getLTEParam "MMECode"]      "The MME Code to be used"] \
               [list GUMMEIIndex          optional   "string"         "all"                        "Index of GUMMEI"] \
               [list relMMECapability     optional   "string"         "255"                        "The relMMECapability to be used"] \
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
               [list verifyLog            optional   "start|stop|no"  "no"                         "Option to start log verification"] \
               ]
     
     set msgType       "request response"
     set operationType "send expect"
     set flag 0
     foreach operation $operationType msg $msgType {
          # First expect an S1 setup request from HeNBGW
          # On receving a request send a response from MME simulator
          set result [updateValAndExecute "S1Setup -operation operation -msg msg -HeNBIndex HeNBIndex -streamId streamId\
                    -TAC TAC -eNBName eNBName -eNBType eNBType -globaleNBId globaleNBId -pagingDRX pagingDRX \
                    -MCC MCC -MNC MNC -MMEName MMEName -HeNBMCC HeNBMCC -HeNBMNC HeNBMNC -MMEGroupId MMEGroupId \
                    -MMECode MMECode -relMMECapability relMMECapability -MMERelaySupportInd MMERelaySupportInd \
                    -timeToWait timeToWait -causeType causeType -cause cause -criticalityDiag criticalityDiag \
                    -procedureCode procedureCode -triggerMsg triggerMsg -procedureCriticality procedureCriticality \
                    -IECriticality IECriticality -IEId IEId -typeOfError typeOfError \
                    -GUMMEIIndex GUMMEIIndex -verifyLog verifyLog"]
          if {$result != 0} {
               print -fail "Setup of S1 interface from HeNB failed"
               set flag 1
          } else {
               print -pass "Setup of S1 interface from HeNB successful"
          }
          
          switch $operation {
               "expect" {
                    # After sending and s1 setup response from MME verify if the MME context is created
                    set result [updateValAndExecute "verifyHeNBGWContext -HeNBIndex HeNBIndex -TAC TAC -streamId streamId\
                              eNBName eNBName -eNBType eNBType -globaleNBId globaleNBId -pagingDRX pagingDRX \
                              -MCC MCC -MNC MNC -MMEName MMEName -HeNBMCC HeNBMCC -HeNBMNC HeNBMNC -MMEGroupId MMEGroupId \
                              -MMECode MMECode -relMMECapability relMMECapability -MMERelaySupportInd MMERelaySupportInd \
                              -timeToWait timeToWait -causeType causeType -cause cause -criticalityDiag criticalityDiag \
                              -procedureCode procedureCode -triggerMsg triggerMsg -procedureCriticality procedureCriticality \
                              -IECriticality IECriticality -IEId IEId -typeOfError typeOfError \
                              -GUMMEIIndex GUMMEIIndex -verifyLog verifyLog"]
                    if {$result < 0} {
                         print -fail "Verification of HeNB context failed"
                         set flag 1
                    } else {
                         print -info "HeNB context created"
                    }
               }
               default {}
          }
          
     }
     if {$flag == 1} {
          # return -1
     }
     return 0
     
}

proc setUpS1HeNbToMME {args} {
     #-
     #- Procedure to setup an S1 interface
     #-
     #- @return 0 on success, @return -1 on failure
     #-
     
     #MMEIndex is expected from script even in case of S1Flex for this procedure and it has to be list of MME indices
     
     set defaultCauseValue "message_not_compatible_with_receiver_state"
     
     parseArgs args \
               [list \
               [list HeNBIndex            optional   "numeric"        "0"                          "The HeNB index" ] \
               [list MMEIndex             optional   "numeric"        "0"                          "The MME index" ] \
               [list streamId             optional   "string"         "0"                          "The sctp string to send or receive data"] \
               [list TAC                  optional   "string"         "__UN_DEFINED__"             "The Broadcasted TAC to be used" ] \
               [list eNBName              optional   "string"         [getLTEParam "HeNBGWName"]   "eNB name"] \
               [list eNBType              optional   "home|macro"     "__UN_DEFINED__"             "eNB type"] \
               [list globaleNBId          optional   "string"         [getLTEParam "globaleNBId"]  "eNB ID"] \
               [list pagingDRX            optional   "string"         "v[getLTEParam defaultPagingDrx]" "Pagging DRX value"] \
               [list MCC                  optional   "string"         "__UN_DEFINED__"             "The MCC param to be used"] \
               [list MNC                  optional   "string"         "__UN_DEFINED__"             "The MNC param to be used"] \
               [list MMEName              optional   "string"         "__UN_DEFINED__"             "The MME Name to be sent"] \
               [list HeNBMCC              optional   "string"         "__UN_DEFINED__"             "The MCC param to be used in HeNB"] \
               [list HeNBMNC              optional   "string"         "__UN_DEFINED__"             "The MNC param to be used in HeNB"] \
               [list MMEGroupId           optional   "string"         [getLTEParam "MMEGroupId"]   "The MME group ID to be used"] \
               [list MMECode              optional   "string"         [getLTEParam "MMECode"]      "The MME Code to be used"] \
               [list GUMMEIIndex          optional   "string"         "all"                        "Index of GUMMEI"] \
               [list relMMECapability     optional   "string"         "__UN_DEFINED__"             "The relMMECapability to be used"] \
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
               [list supportedTAs          optional   "string"        "__UN_DEFINED__"             "Identifies supported TAI"] \
               [list typeOfError          optional   "string"         "__UN_DEFINED__"             "Identifies the type of error"] \
               [list verifyLog            optional   "start|stop|no"  "no"                         "Option to start log verification"] \
               [list MultiS1Link                 optional     "yes|no"   "no"                            "To know multis1link enable towards mme"] \
               [list verifyLatest         optional   "yes|no"         "yes"                        "Option to verify latest message's value in output message"] \
               ]
     set flag 0
     foreach mmeIndex $MMEIndex {
          print -info "Setting up S1 Interface towards MME for MME with index \"$mmeIndex\""
          set result [updateValAndExecute "setUpS1ToMME -MMEIndex mmeIndex -TAC TAC -eNBName eNBName -globaleNBId globaleNBId \
                    -pagingDRX pagingDRX -MCC MCC -MNC MNC -MMEName MMEName -HeNBMCC HeNBMCC -MMEGroupId MMEGroupId \
                    -MMECode MMECode -relMMECapability relMMECapability -MMERelaySupportInd MMERelaySupportInd \
                    -timeToWait timeToWait -causeType causeType -cause cause -criticalityDiag criticalityDiag -supportedTAs supportedTAs \
                    -procedureCode procedureCode -triggerMsg triggerMsg -procedureCriticality procedureCriticality \
                    -IECriticality IECriticality -IEId IEId -typeOfError typeOfError -verifyLog verifyLog \
                    -verifyLatest verifyLatest -MultiS1Link MultiS1Link"]
          if {$result != 0} {
               print -fail "Setup of S1 towards MME failed for MME with index \"$mmeIndex\""
               set flag 1
          } else {
               print -pass "Successfully setup S1 interface towards MME with index \"$mmeIndex\""
          }
     }
     
     foreach heNBIndex $HeNBIndex {
          print -info "Setting up S1 Interface towards HeNBGW from HeNB with index \"$heNBIndex\""
          set result [updateValAndExecute "setUpS1ToHeNBGW -HeNBIndex heNBIndex -streamId streamId\
                    -TAC TAC -eNBName eNBName -eNBType eNBType -globaleNBId globaleNBId -pagingDRX pagingDRX \
                    -MCC MCC -MNC MNC -MMEName MMEName -HeNBMCC HeNBMCC -HeNBMNC HeNBMNC -MMEGroupId MMEGroupId \
                    -MMECode MMECode -relMMECapability relMMECapability -MMERelaySupportInd MMERelaySupportInd \
                    -timeToWait timeToWait -causeType causeType -cause cause -criticalityDiag criticalityDiag \
                    -procedureCode procedureCode -triggerMsg triggerMsg -procedureCriticality procedureCriticality \
                    -IECriticality IECriticality -IEId IEId -typeOfError typeOfError -MultiS1Link MultiS1Link\
                    -GUMMEIIndex GUMMEIIndex -verifyLog verifyLog"]
          if {$result != 0} {
               print -fail "Setup of S1 towards HeNBGW failed for HeNB with index \"$heNBIndex\""
               set flag 1
          } else {
               print -pass "Successfully setup S1 interface towards HeNBGW for HeNB with index \"$heNBIndex\""
          }
     }
     if {$flag ==1} {
          #return -1
     }
     return 0
}

proc setUpUEInitialContext {args} {
     #-
     #- Procedure to setup initial context messages
     #-
     #- @return 0 on success, @return -1 on failure
     #-
     
     set validNASMessages "initContextRequest|initContextResponse|initContextFailure"
     set validTraceDepth   "minimum|medium|maximum|MinimumWithoutVendorSpecificExtension|MediumWithoutVendorSpecificExtension|MaximumWithoutVendorSpecificExtension"
     set validCSFB         "cs_fallback_required|cs_fallback_high_priority"
     set validSrvccOp      "possible"
     set validCsgMemStat   "member|not_member"
     set secKey            "0e47818519f76cc13d8414ba08e0b48dc7405d46890334860a9c5083baf1446e"
     set traceIp           [getDataFromConfigFile "henbBearerIpaddress" 0]
     set defaultCause      "message_not_compatible_with_receiver_state"
     
     parseArgs args \
               [list \
               [list sendSeq              optional   "$validNASMessages"    "initContextRequest initContextResponse"     "To perform the operation or not. if no, will return the message"] \
               [list execute              optional   "boolean"              "yes"         				"To perform the operation or not. if no, will return the message"] \
               [list HeNBIndex            mandatory  "numeric"              ""      					"Index of HeNB whose values need to be retrieved" ] \
               [list UEIndex              mandatory  "numeric"              ""      					"Index of UE whose values need to be retrieved" ] \
               [list MMEIndex             optional   "numeric"              "0"      					"Index of MME whose values need to be retrieved" ] \
               [list eNBUES1APId          optional   "string"               "__UN_DEFINED__"   				"eNB UE S1AP Id value" ] \
               [list MMEUES1APId          optional   "string"               "__UN_DEFINED__"   				"MME UE S1AP Id value" ] \
               [list SubscriberProfileId  optional   "numeric"              "__UN_DEFINED__"   				"Subscriber Profile ID for RAT/Frequency priority" ] \
               [list servingPLMN          optional   "numeric"              "__UN_DEFINED__"   				"serving PLMN in Hand over Restriction List" ] \
               [list equivalPLMN          optional   "numeric"              "__UN_DEFINED__"   				"equivalent PLMNs in Hand over Restriction List" ] \
               [list forbiddenTA          optional   "numeric"              "__UN_DEFINED__"   				"forbidden TAs in Hand over Restriction List" ] \
               [list forbiddenLA          optional   "numeric"              "__UN_DEFINED__"   				"forbidden LAs in Hand over Restriction List" ] \
               [list forbiddenInterRATs   optional   "numeric"              "__UN_DEFINED__"   				"forbidden Inter RATs in Hand over Restriction List" ] \
               [list TAI                  optional   "string"               "0,0"               			"TAI chosen from UE" ] \
               [list eCGI                 optional   "string"               "0,0"               			"e-UTRAN CGI chosen from UE" ] \
               [list RRCEstablishCause    optional   "string"               "MO_DATA"           			"RRC Establishment cause from UE" ] \
               [list sTMSI                optional   "string"               "__UN_DEFINED__"   				"M-TMSI value of S-TMSI from UE" ] \
               [list GUMMEI               optional   "string"               "__UN_DEFINED__"   				"GUMMEI from UE of format gummeiInd,plmnInd,mmecInd,mmegiInd" ] \
               [list CellAccessMode       optional   "string"               "__UN_DEFINED__"   				"Cell Access Mode value from UE" ] \
               [list GwTransportAddr      optional   "string"               "__UN_DEFINED__"   				"GW Transport Layer Address value from UE" ] \
               [list RelayNodeInd         optional   "string"               "__UN_DEFINED__"   				"Relay Node Indicator value from UE" ] \
               [list henbUeId             optional   "numeric"              "__UN_DEFINED__"   				"" ] \
               [list UEAggMaxBitRate      optional   "string"               "1,1"               			"The UE aggregate max bit rate" ] \
               [list ERABs                optional   "string"               "1"                 			"The number of E-RAB to be setup" ] \
               [list eRABSuccessList      optional   "string"               "1,0"                 			"The E-RAB success list" ] \
               [list eRABFailList         optional   "string"               "__UN_DEFINED__"            		"The E-RAB failure list" ] \
               [list UESecurityCap        optional   "string"               "1,1"               			"The UE security capability to be used" ] \
               [list securityKey          optional   "string"               "$secKey"           			"The security key to be used" ] \
               [list traceActivation      optional   "boolean"              "__UN_DEFINED__"    			"The trace activation to be enabled" ] \
               [list eURTANTraceId        optional   "string"               "[random 99999999]" 			"The trace id to be enabled" ] \
               [list intToTrace           optional   "string"               "50"                			"The interface to be traced" ] \
               [list traceDepth           optional   "$validTraceDepth"     "maximum"           			"The trace depth to be used" ] \
               [list traceIp              optional   "ip"                   "$traceIp"          			"The trace ip to be used" ] \
               [list MDTConfig            optional   "string"               "__UN_DEFINED__"    			"The MDT configuration for trace" ] \
               [list UERadioCapability    optional   "string"               "__UN_DEFINED__"    			"Defines the UE Radio capability" ] \
               [list SubscriberProfileId  optional   "$validCSFB"           "__UN_DEFINED__"    			"Defines the subscriber profile for RAT/Freq priority" ] \
               [list CSFallbackInd        optional   "numeric"              "__UN_DEFINED__"    			"Defines the CS fallback indicator" ] \
               [list SRVCCOperation       optional   "$validSrvccOp"        "__UN_DEFINED__"    			"Defines the SRVCC operation" ] \
               [list CSGMembership        optional   "$validCsgMemStat"     "__UN_DEFINED__"    			"Defines the CSG membership" ] \
               [list LAI                  optional   "numeric"              "__UN_DEFINED__"    			"Defines the registered LAI" ] \
               [list GUMMEI               optional   "numeric"              "__UN_DEFINED__"    			"Defines the registered LAI" ] \
               [list MMEUES1APId2         optional   "string"               "__UN_DEFINED__"    			"Defines the MMEUES1APId assigned by MME" ] \
               [list streamId             optional   "numeric"              "__UN_DEFINED__"    			"Defines the streamId assigned by MME" ] \
               
     ]
     
     foreach ueId $UEIndex {
          print -info "UE context setup for UE $ueId"
          foreach msg $sendSeq {
               switch -regexp $msg {
                    "initContextRequest" {
                         foreach op [list send expect] {
                              print -info "[string totitle $op]ing initial context setup request"
                              set result [updateValAndExecute "initialContext -msg request -operation op -HeNBIndex HeNBIndex -ERABs ERABs \
                                        -UEIndex UEIndex -MMEIndex MMEIndex -eNBUES1APId eNBUES1APId -MMEUES1APId MMEUES1APId \
                                        -causeType causeType -cause cause -criticalityDiag criticalityDiag \
                                        -procedureCode procedureCode -triggerMsg triggerMsg -procedureCriticality \
                                        -IECriticality IECriticality -IEId IEId -typeOfError typeOfError \
                                        -UEAggMaxBitRate UEAggMaxBitRate -ERABs ERABs -UESecurityCap UESecurityCap \
                                        -securityKey securityKey -traceActivation traceActivation -eURTANTraceId eURTANTraceId \
                                        -intToTrace intToTrace -traceDepth traceDepth -traceIp traceIp -MDTConfig MDTConfig \
                                        -servingPLMN servingPLMN -equivalPLMN equivalPLMN -forbiddenTA forbiddenTA \
                                        -forbiddenLA forbiddenLA -forbiddenInterRATs forbiddenInterRATs \
                                        -UERadioCapability  -SubscriberProfileId SubscriberProfileId -CSFallbackInd CSFallbackInd \
                                        -SRVCCOperation SRVCCOperation -CSGMembership CSGMembership -LAI LAI -GUMMEI GUMMEI \
                                        -MMEUES1APId2 MMEUES1APId2 -streamId streamId -execute execute"]
                              
                              if {$result < 0} {
                                   print -fail "Failed to $op initial UE context request"
                                   return -1
                              } else {
                                   print -pass "Initial UE context request $op successfull"
                              }
                              
                         }
                    }
                    "initContextResponse|initContextFailure" {
                         if {$msg == "initContextResponse"} {
                              set msgType response
                         } else {
                              set msgType failure
                         }
                         foreach op [list send expect] {
                              print -info "[string totitle $op]ing initial UE context $msgType"
                              set result [updateValAndExecute "initialContext -msg msgType -operation op -HeNBIndex HeNBIndex \
                                        -UEIndex UEIndex -MMEIndex MMEIndex -eNBUES1APId eNBUES1APId -MMEUES1APId MMEUES1APId\
                                        -causeType causeType -cause cause -criticalityDiag criticalityDiag \
                                        -procedureCode procedureCode -triggerMsg triggerMsg -procedureCriticality \
                                        -IECriticality IECriticality -IEId IEId -typeOfError typeOfError \
                                        -ERABs eRABSuccessList -eRABsFailedToSetup eRABFailList \
                                        -streamId streamId -execute execute"]
                              if {$result < 0} {
                                   print -fail "Failed to $op initial UE context $msgType"
                                   return -1
                              } else {
                                   print -pass "Initial UE context $msgType $op successfull"
                              }
                         }
                    }
               }
          }
     }
     return 0
}

proc setUpNASTransport {args} {
     #-
     #- Procedure to setup initial UE with Downlink NAS and Uplink NAS
     #-
     #- @return 0 on success, @return -1 on failure
     #-
     
     set validNASMessages "initialUE|downlinkNAS|uplinkNAS"
     set nasPdu "05120358104f768062ccb90d9b98264bbfb2bd2010555d77652d0900ff493065c731ea4b86"
     parseArgs args \
               [list \
               [list sendSeq             optional   "$validNASMessages"    "initialUE downlinkNAS uplinkNAS"         "To perform the operation or not. if no, will return the message"] \
               [list operation          optional   "send|expect" "send"        "send or expect option"] \
               [list execute             optional   "boolean"    "yes"         "To perform the operation or not. if no, will return the message"] \
               [list HeNBIndex          mandatory  "numeric" ""      "Index of HeNB whose values need to be retrieved" ] \
               [list UEIndex            mandatory  "string" ""      "Index of UE whose values need to be retrieved" ] \
               [list MMEIndex           optional   "numeric" "__UN_DEFINED__"      "Index of MME whose values need to be retrieved" ] \
               [list eNBUES1APId        optional   "string" "__UN_DEFINED__"   "eNB UE S1AP Id value" ] \
               [list MMEUES1APId        optional   "string" "__UN_DEFINED__"   "MME UE S1AP Id value" ] \
               [list SubscriberProfileId optional   "numeric" "__UN_DEFINED__"   "Subscriber Profile ID for RAT/Frequency priority" ] \
               [list servingPLMN         optional   "numeric" "__UN_DEFINED__"   "serving PLMN in Hand over Restriction List" ] \
               [list equivalPLMN         optional   "numeric" "__UN_DEFINED__"   "equivalent PLMNs in Hand over Restriction List" ] \
               [list forbiddenTA         optional   "numeric" "__UN_DEFINED__"   "forbidden TAs in Hand over Restriction List" ] \
               [list forbiddenLA         optional   "numeric" "__UN_DEFINED__"   "forbidden LAs in Hand over Restriction List" ] \
               [list forbiddenInterRATs  optional   "numeric" "__UN_DEFINED__"   "forbidden Inter RATs in Hand over Restriction List" ] \
               [list TAI                optional   "string" "0,0"               "TAI chosen from UE" ] \
               [list eCGI               optional   "string" "0,0"               "e-UTRAN CGI chosen from UE" ] \
               [list RRCEstablishCause   optional   "string" "MO_DATA"           "RRC Establishment cause from UE" ] \
               [list sTMSI              optional   "string" "__UN_DEFINED__"   "M-TMSI value of S-TMSI from UE" ] \
               [list GUMMEI             optional   "string"  "__UN_DEFINED__"   "GUMMEI from UE of format gummeiInd,plmnInd,mmecInd,mmegiInd" ] \
               [list CellAccessMode     optional   "string" "__UN_DEFINED__"   "Cell Access Mode value from UE" ] \
               [list GwTransportAddr    optional   "string" "__UN_DEFINED__"   "GW Transport Layer Address value from UE" ] \
               [list RelayNodeInd       optional   "string" "__UN_DEFINED__"   "Relay Node Indicator value from UE" ] \
               [list henbUeId           optional   "numeric" "__UN_DEFINED__"   "" ] \
               [list nasLen             optional   "numeric" "$nasPdu"               "Nas Length to be used for the message"] \
               ]
     
     if {[regexp "," $UEIndex]} {set UEIndex [split $UEIndex ,]}
    
     foreach ueId $UEIndex {
          print -info "UE context setup for UE $ueId"
          foreach msg $sendSeq {
               ##getFromTestMap returns MMEIndex incase of load balancing case of S1Flex scenario
               if {[getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "MMEIndex"] != -1} {
                    set MMEIndex [getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "MMEIndex"]
                    print -info "Using MMEIndex $MMEIndex among load balanced MMEs"
               } else {
                    #Keeping default value of 0
                    set MMEIndex "0"
                    print -info "Using default MMEIndex $MMEIndex"
               }
               switch $msg {
                    "initialUE" {
                         foreach op [list send expect] {
                              print -info "Setting up a initial UE COntext"
                              set result [updateValAndExecute "initialUE -operation op -execute execute -HeNBIndex HeNBIndex -UEIndex ueId -MMEIndex MMEIndex \
                                        -eNBUES1APId eNBUES1APId -TAI TAI -eCGI eCGI -RRCEstablishCause RRCEstablishCause -sTMSI sTMSI -GUMMEI GUMMEI \
                                        -CellAccessMode CellAccessMode -GwTransportAddr GwTransportAddr -RelayNodeInd RelayNodeInd -henbUeId henbUeId -nasLen nasLen"]
                              
                              if {$result != 0} {
                                   print -fail "Initial UE Setup failed towards MME $MMEIndex"
                                   return -1
                              } else {
                                   print -pass "Initial UE Setup successful towards MME $MMEIndex"
                              }
                         }
                    }
                    "downlinkNAS" {
                         foreach op [list send expect] {
                              print -info "Downlink NAS Transport"
                              set result [updateValAndExecute "downlinkNASTransport -operation op -execute execute -MMEIndex MMEIndex -UEIndex ueId \
                                        -HeNBIndex HeNBIndex -eNBUES1APId eNBUES1APId -MMEUES1APId MMEUES1APId -SubscriberProfileId SubscriberProfileId \
                                        -servingPLMN servingPLMN -equivalPLMN equivalPLMN -forbiddenTA forbiddenTA -forbiddenLA forbiddenLA \
                                        -forbiddenInterRATs forbiddenInterRATs -nasLen nasLen"]
                              if {$result != 0} {
                                   print -fail "Downlink NAS Tranport $op operation for MME $MMEIndex unsuceesful"
                                   return -1
                              } else {
                                   print -pass "Downlink NAS Tranport $op operation for MME $MMEIndex suceesfull"
                              }
                         }
                    }
                    "uplinkNAS"   {
                         foreach op [list send expect] {
                              print -info "Uplink NAS Transport"
                              set result [updateValAndExecute "uplinkNASTransport -operation op -execute execute -HeNBIndex HeNBIndex -UEIndex ueId \
                                        -MMEIndex MMEIndex -eNBUES1APId eNBUES1APId -MMEUES1APId MMEUES1APId -TAI TAI -eCGI eCGI -GwTransportAddr GwTransportAddr -nasLen nasLen"]
                              if {$result != 0} {
                                   print -fail "Uplink NAS Tranport $op operation from HeNB $HeNBIndex unsuceesful"
                                   return -1
                              } else {
                                   print -pass "Uplink NAS Tranport $op operation from HeNB $HeNBIndex suceesful"
                              }
                         }
                    }
               }
          }
     }
     return 0
}

proc UEAttachDetach {noOfHeNBs noOfUEs} {
     #-
     #- Peforms UE attach and detach in S1Flex setups
     #- Performs initialUE/downlinkNAS/uplinkNAS UEContextRel/UEContextRelComplete/UEContextRelAck
     #-
     
     set flag 0
     # create UE contexts
     for {set henbInd 0} {$henbInd < $noOfHeNBs} {incr henbInd} {
          for {set ueInd 0} {$ueInd < $noOfUEs} {incr ueInd} {
               printHeader "UEAttach HeNBIndex $henbInd UEIndex $ueInd" 100
               set result [setUpNASTransport -HeNBIndex $henbInd -UEIndex $ueInd]
               if { $result != 0} {
                    print -fail "Initial UE and NAS Transport setup between the HeNB and MME failed"
                    set flag 1
               } else {
                    print -pass "Initial UE and NAS Transport setup between the HeNB and MME succesful"
               }
          }
     }
     
     set sequence "HeNB,UEContextRelReq,send MME,UEContextRelReq,expect GW,Full MME,UEContextRel,send HeNB,UEContextRel,expect GW,ReadyToRelease HeNB,UEContextRelComplete,send MME,UEContextRelComplete,expect GW,empty"
     for {set henbInd 0} {$henbInd < $noOfHeNBs} {incr henbInd} {
          for {set ueInd 0} {$ueInd < $noOfUEs} {incr ueInd}   {
               # verify clearing of UE Contexts
               printHeader "UEAttach HeNBIndex $henbInd UEIndex $ueInd" 100
               
               set result [UEContextRelSequence -sequence $sequence -HeNBIndex $henbInd -UEIndex $ueInd]
               if { $result != 0 } {
                    print -fail "UE Context Release sequence is not as expected"
                    set flag 1
               } else {
                    print -pass "UE Context Release sequence is as expected"
               }
          }
     }
     
     if {$flag} {
          print -fail "UE attach failed"
          return -1
     } else {
          return 0
     }
}

proc setUpERAB {args} {
     #-
     #- Wrapper script to setup eRABS
     #- This wrapper can be used to setup eRABs for multiple UEs when passed as a list
     #-
     #- @ return 0 on successfull execution and -1 on failure
     #-
     
     global ARR_eRAB_SETUP
     set validMsg          "request|response"
     set defaultCause      "message_not_compatible_with_receiver_state"
     
     parseArgs args \
               [list \
               [list sendSeq              optional   "$validMsg"      "request response"  "The message to be sent" ] \
               [list execute              optional   "boolean"        "yes"               "To perform the operation or not. if no, will return the message"] \
               [list HeNBIndex            mandatory  "numeric"        ""                  "Index of HeNB whose values need to be retrieved" ] \
               [list UEIndex              mandatory  "numeric"        ""                  "Index of UE whose values need to be retrieved" ] \
               [list MMEIndex             optional   "numeric"        "0"                 "Index of MME whose values need to be retrieved" ] \
               [list causeType            optional   "string"         "protocol"          "Identifies the cause choice group"] \
               [list cause                optional   "string"         "$defaultCause"     "Identifies the cause value"] \
               [list criticalityDiag      optional   "string"         "__UN_DEFINED__"    "The critical diag to be enabled or not"] \
               [list procedureCode        optional   "string"         "__UN_DEFINED__"    "The procedure code to be used diag"] \
               [list triggerMsg           optional   "string"         "__UN_DEFINED__"    "Identifies the triggering message"] \
               [list procedureCriticality optional   "string"         "__UN_DEFINED__"    "Identifies the procedure Criticality"] \
               [list IECriticality        optional   "string"         "__UN_DEFINED__"    "Identifies the IE Criticality list"] \
               [list IEId                 optional   "numeric"        "__UN_DEFINED__"    "Identifies the IE Id list"] \
               [list typeOfError          optional   "string"         "__UN_DEFINED__"    "Identifies the type of error list"] \
               [list streamId             optional   "numeric"        "__UN_DEFINED__"    "Defines the streamId assigned" ] \
               [list UEAggMaxBitRate      optional   "string"         "__UN_DEFINED__"    "The UE aggregate max bit rate" ] \
               [list ERABsToBeSetup       optional   "string"         "1"                 "The number of E-RAB to be setup" ] \
               [list ERABsSuccessList     optional   "string"         "1,0"               "The E-RABs that were successfully setup" ] \
               [list eRABsFailedToSetup   optional   "string"         "__UN_DEFINED__"    "The number of E-RAB failed to setup" ] \
               [list execute              optional   "boolean"        "yes"               "Execute the constructed command or not" ] \
               ]
     
     foreach ueId $UEIndex {
          print -info "eRAB setup for UE $ueId"
          foreach msg $sendSeq {
               switch $msg {
                    "request"  {set ERABs $ERABsToBeSetup}
                    "response" {set ERABs $ERABsSuccessList}
               }
               foreach op [list send expect] {
                    print -info "Procedure: eRABSetup[string totitle $msg] Operation: $op"
                    set result [updateValAndExecute "eRABSetup -msg msg -operation op -HeNBIndex HeNBIndex -UEIndex UEIndex -MMEIndex MMEIndex \
                              -causeType causeType -cause cause -criticalityDiag criticalityDiag -procedureCode procedureCode \
                              -triggerMsg triggerMsg -procedureCriticality procedureCriticality -IECriticality IECriticality \
                              -IEId IEId -typeOfError typeOfError -streamId streamId -UEAggMaxBitRate UEAggMaxBitRate \
                              -ERABs ERABs -eRABsFailedToSetup eRABsFailedToSetup -execute execute"]
                    if {$result != 0} {
                         print -fail "[string totitle $op] of eRABSetup $msg failed"
                         return -1
                    } else {
                         print -pass "[string totitle $op]ing of eRABSetup $msg successfull"
                    }
               }
          }
     }
     return 0
}

proc setUpPaging {args} {
     #-
     #- Wrapper procedure to verify paging between MME and HeNB
     #-
     #- @return 0 on success and -1 on failure
     #-
     #-
     set validS1Msg        "paging"
     
     parseArgs args \
               [list \
               [list execute                 optional   "boolean"        "yes"                        "To perform the operation or not. if no, will return the message"] \
               [list MMEIndex                optional   "string"         "0"                          "The MME Index"] \
               [list HeNBIndex               optional   "string"         "0"                          "The HeNB Index"] \
               [list streamId                optional   "string"         "0"                          "The sctp string to send or receive data"] \
               [list TAC                     optional   "string"         "__UN_DEFINED__"             "The Broadcasted TAC to be used" ] \
               [list pagingDRX               optional   "string"         "v32"                        "Pagging DRX value"] \
               [list MCC                     optional   "string"         "__UN_DEFINED__"             "The MCC param to be used"] \
               [list MNC                     optional   "string"         "__UN_DEFINED__"             "The MNC param to be used"] \
               [list HeNBId                  optional   "string"         "__UN_DEFINED__"             "The heNBId param to be used in HeNB"] \
               [list CSGId                   optional   "string"         "__UN_DEFINED__"             "The CSGId param to be used in HeNB"] \
               [list MMECode                 optional   "string"         [getLTEParam "MMECode"]      "The MME Code to be used"] \
               [list ueIdentityIndexValue    optional   "numeric"        "100"                        "Index of MME"] \
               [list uePagingId              optional   "stmsi|imsi"     "stmsi"                      "UE paging ID IMSI or s-TMSI "] \
               [list cnDomain                optional   "cs|ps"          "cs"                         "CN domain CS or PS" ] \
               [list pagingPriority          optional   "string"         "__UN_DEFINED__"             "Paging Priority" ] \
               [list drxPaging               optional   "string"         "__UN_DEFINED__"             "Paging Priority" ] \
               [list testTAI                 optional   "string"         "no"                         "Send paging message with only test TAI" ] \
               [list GUMMEIIndex             optional   "string"         "0"                          "Index of GUMMEI"] \
               [list needCsgId               optional   "string"         "no"                         "Index of GUMMEI"] \
               [list missMandIe              optional   "string"         "__UN_DEFINED__"             "Miss the mandatory IE" ] \
               ]
     
     foreach op [list send expect] sim [list MME HeNB] {
          print -info "\"$sim\" : [string totitle $op]ing Paging message"
          set result [updateValAndExecute "paging -msg paging -operation op -HeNBIndex HeNBIndex -MMEIndex MMEIndex \
                    -streamId streamId -TAC TAC -pagingDRX pagingDRX -MCC MCC -MNC MNC \
                    -HeNBId  -CSGId CSGId -MMECode MMECode -ueIdentityIndexValue ueIdentityIndexValue \
                    -uePagingId uePagingId -cnDomain cnDomain -pagingPriority pagingPriority -drxPaging drxPaging \
                    -testTAI testTAI -GUMMEIIndex GUMMEIIndex -MMEIndex MMEIndex -needCsgId needCsgId -missMandIe missMandIe"]
          if {$result != 0} {
               print -fail "[string totitle $op] of paging msg failed"
               return -1
          } else {
               print -pass "[string totitle $op]ing of paging msg successfull"
          }
     }
     return 0
}

proc processSimInput {msgName input {msgType ""} {IEContainer ""}} {
     #-
     #- Code to processes the simulator input command data so as to directly match with the
     #- processed output data recieved on simulator
     #-
     
     array set arr_local {}
     
     # extracting message type
     set index   [lsearch -regexp $input "(M|m)sg(t|T)ype="]
     if {$index >= 0} { set input   [lindex $input $index] }

     # if it is single list, not sure if input is single list or list of lists, below logic converts it into single list
     if {[llength $input] == 1} { set input [lindex $input 0] }
    
     # extract the variables out of the input
     set varList [processList -data $input -splitter "="]
     if {$index >= 0} {
          set msgType [lindex [lindex $varList 0] end]
          set varList [lrange $varList 1 end]
          set arr_local(msgName) [simMsgNameMapper $msgType]
     }
     
     # -------- different conditional statements used in this code earlier --------
     # -------- retaining them as backup to do analysis if any issues encounter in future ----
     # -
     # if {[regexp -nocase "error|r(e|)sp|paging|reset" $msgType] && [regexp "=" $expVal] && ![regexp "," $expVal]} {}
     # if {[regexp "=" $expVal] && ![isListOfLists $expVal]} {}
     # if {[regexp "=" $expVal] && (([regexp "," $expVal] && [regexp -nocase "mmecode" $expVal]) || ![regexp "," $expVal])} {}
     # -
     
     foreach ele $varList {
          extractVarAndValue expVar expVal $ele
          set mappedSimDumpVar [simIENameMapper -msgName $msgName -msgType $msgType -IE $expVar -IEContainer $IEContainer]
          # when we have multiple container elements, use this proc in recurssion to process the data (error message scenario)
          #if {[regexp "=" $expVal] && ( ![regexp -nocase "^(ta(|ilistforwarning)|tai|e(|utran)(cgi|_cgi)|cellidlist|taiList|registeredLAI|gummei(|s)|globale(NBI|nbi)d|forbidden(l|t)as|global_Cell_ID)$" $expVar])}
          if {[regexp "=" $expVal] && ( ![regexp -nocase "^(ta(|ilistforwarning)|selected_TAI|tai|e(|utran)(cgi|_cgi)|cellidlist|taiList|pLMNidentity|registeredLAI|gummei(|s)|globale(NBI|nbi)d|forbidden(L|T)As|global_Cell_ID|targetCell_ID|gUMMEIList|gUMMEI_ID|supportedTAs|equivalentPLMNs|servingPLMN)$" $expVar])} {

               # sometimes there will be mismatch in the list parsing (for ex: expVar=ieid , expVal=106 iecriticality=junk1 errortype=junk2)
               # below logic will handle such cases


               if {[llength $expVal] > 1 && ([regexp -all "=" $expVal]  != [llength $expVal])} { set expVal [list "$expVar=$expVal"] }
               if {[regexp "^cause$" $expVar]} {
                  set expVal [trimBraces $expVal]
                  set expVal "\{$expVar.$expVal\}"
               }


               foreach {arrIndex arrVal} [processSimInput $msgName $expVal $msgType $expVar] {
                    if {![info exists arr_local($arrIndex)]} {set arr_local($arrIndex) ""}
                    set arr_local($arrIndex) [concat $arr_local($arrIndex) $arrVal]
               }
          } else {
               # consider henbMnc, henbMcc as single entity to generate PLMN_ID
               if {[regexp -nocase "m(n|c)c" $expVar match]} { set expVal "$match=$expVal" }
               # Some of the variables require special processing
               # One case would be varibles that are used only as reference to the simulator and dont figure in the actual data
               # Some may require the value to be mapped to a different value
               switch -regexp -nocase $mappedSimDumpVar {
                    "^(naslen|henbid|ueid|gwPort|gwIP|MMEId|nAS_PDU|assocID)$" {continue}
                    "resetType$"                 {set expVal [string map "resetPartial partOfS1_Interface" $expVal]}
                    "relayNode_Indicator$"                 {set expVal [string map "true TRUE_" $expVal]}
                    #"pagingPriority" {
                    #      set j [expr $expVal + 1]
   		#	  set expVal [ string map "$expVal PRIOLEVEL$j" $expVal ]
                #     }
               }
               lappend arr_local($mappedSimDumpVar) $expVal
          }
     }
     
     foreach param "pLMNidentity servedPLMNs equivalentPLMNs servingPLMN ta supportedTAs cause forbiddenLAs forbiddenTAs eNB_ID.macroENB_ID tAI eUTRAN_CGI eCGI tAIList registeredLAI gUMMEI_ID global_Cell_ID eNB_ID.type gUMMEIList selected_TAI targetCell_ID mME_UE_S1AP_ID" {
          if {![info exists arr_local($param)]} {print -info "Skipping $param" ; continue }
          switch -regexp $param {
               "pLMNidentity|servedPLMNs|equivalentPLMNs|servingPLMN" {
                    # when there are no mcc|mnc in the data, no need to calculate PLMN ID
                    if {![regexp -nocase "m(n|c)c" $arr_local($param)]} {continue}
                    set cmd "createLteIdentifier -identifier PLMNId "
                    foreach ele $arr_local($param) {
                         set ele [trimBraces $ele]
			 foreach ele1 [split $ele] {
                           if {[regexp -nocase "mcc=" $ele1]} {
   			      set mcc [lindex [split $ele1 =] end]
			      append cmd "-MCC $mcc "
			   } elseif {[regexp -nocase "mnc=" $ele1]} {
   			     set mnc [lindex [split $ele1 =] end]
			     append cmd "-MNC $mnc "
			   }
                        }
                    }
                    set arr_local($param) [lindex [eval $cmd] 0]
               }
               "^ta$|supportedTAs" {
                    set arr_local(broadcastPLMNs) 0
                    foreach ta [lindex $arr_local($param) 0] {
                      #set cmd "createLteIdentifier -identifier PLMNId "
                      incr arr_local(broadcastPLMNs)
                      set index1 broadcastPLMNs$arr_local(broadcastPLMNs)
                    
                      foreach ele [split $ta ","] {
                         set cmd "createLteIdentifier -identifier PLMNId "
                         foreach ele1 [split $ele] {
                            if {[regexp -nocase "mcc=" $ele1]} {
                               set mcc [trimBraces [lindex [split $ele1 =] end] ]
                               append cmd "-MCC $mcc "
                            } elseif {[regexp -nocase "mnc=" $ele1]} {
                               set mnc [trimBraces [lindex [split $ele1 =] end]]
                               append cmd "-MNC $mnc "
                            } elseif {[regexp -nocase "tAC=" $ele1]} {
                               set tAC [trimBraces [lindex [split $ele1 =] end]]
                               set arr_local($index1,tAC) $tAC
                            }
                         }
                         #set arr_local($index1) [lindex [eval $cmd] 0]
                         append arr_local($index1) [lindex [eval $cmd] 0] " "
                      }

                         #set arr_local($index1,tAC) [lindex [split [lindex $ta 0] "="] end]
                         #foreach ele  [lrange $ta 1 end] {
                         #     foreach {var val} [split $ele "="] {break}
                         #     append cmd "-[string toupper $var] [list [split $val ,]] "
                         #}
                      #set arr_local($index1) [lindex [eval $cmd] 0]
                    }
                    unset -nocomplain arr_local($param)
               }
               "forbiddenLAs|forbiddenTAs" {
                    # if it is forbiddenlas, then change it to forbiddenLACs, if it is forbiddentas, forbiddenTACs
                    if {![regsub "LAs$" $param "LACs" param1]} { set param1 [regsub "TAs$" $param "TACs"] }
                    if {![regsub "LAs$" $param "LAs" param2]}  { set param2 [regsub "TAs$" $param "TAs"] }
                    set arr_local($param1) 0
                    foreach la [lindex $arr_local($param) 0] {
                         set cmd "createLteIdentifier -identifier PLMNId "
                         incr arr_local($param1)
                         set index1 ${param1}$arr_local($param1)
                         foreach ele $la {
                              if {[regexp "forbidden" $ele]} {
                                 set arr_local($index1) [split [lindex [split $ele "="] end] ","]
                                 continue
                              }
                              #foreach {var val} [split $ele "="] {break}
                              if {[regexp -nocase "mcc=" $ele]} {
                                 set mcc [trimBraces [lindex [split $ele =] end] ]
                                 append cmd "-MCC $mcc "
                              } elseif {[regexp -nocase "mnc=" $ele]} {
                                set mnc [trimBraces [lindex [split $ele =] end]]
                                append cmd "-MNC $mnc "
                              }

                              #append cmd "-[string toupper $var] [list [split $val ,]] "
                         }
                         lappend arr_local($param2,pLMN_Identity) [lindex [eval $cmd] 0]
                    }
                    unset -nocomplain arr_local($param)
                    unset -nocomplain arr_local($param1)
               }
               "cause" {
                    # concat cause and causeType as single entity (error indication message)
                    set causeType [array names arr_local -regexp ${param}(T|t)ype]
                    if {$causeType != ""} {
                         set arr_local($causeType) [string map "transport transport radionetwork radioNetwork" [string tolower $arr_local($causeType)]]
                         set arr_local(${param}.$arr_local($causeType)) $arr_local($param)
                    }
                    unset -nocomplain arr_local($param)
                    unset -nocomplain arr_local($causeType)
               }
               "mME_UE_S1AP_ID" {
                    #Commented below block and it is needed only if we send mmeues1apid (without enbues1apid) 
                    # in uecontextreleasecmd msg
                    #if {[regexp -nocase "ue_context_release_command" $msgName]} {
                    #   set arr_local(uE_S1AP_IDs.${param}) $arr_local($param)
                    #   unset -nocomplain arr_local($param)
                    #}
               }

               "eNB_ID.macroENB_ID" {
                    # process only if the mcc,mnc,macroenbid are grouped together
                    if {[regexp -nocase "mcc=" $arr_local($param)]} {
                         foreach {mcc mnc enbId} [lindex [lindex $arr_local($param) 0] 0] {break}
                         set mcc [lindex [split $mcc =] end]
                         set mnc [lindex [split $mnc =] end]
                         set arr_local($param) [lindex [split $enbId =] end]
                         set arr_local(pLMNidentity) [eval "createLteIdentifier -identifier PLMNId -MCC $mcc -MNC $mnc"]
                    }
               }
               "eNB_ID.type" {
                    # process only if the mcc,mnc,macroenbid are grouped together
                    if {[regexp -nocase "mcc=" $arr_local($param)]} {
                         foreach {mcc mnc enbId} [lindex [lindex $arr_local($param) 0] 0] {break}
                         set mcc [lindex [split $mcc =] end]
                         set mnc [lindex [split $mnc =] end]
                         set param1 [string map "homeenbid eNB_ID.homeENB_ID macroenbid eNB_ID.macroENB_ID" [lindex [split $enbId = ] 0]]
                         set arr_local($param1) [lindex [split $enbId =] end]
                         set arr_local(pLMNidentity) [eval "createLteIdentifier -identifier PLMNId -MCC $mcc -MNC $mnc"]
                         unset arr_local($param)
                    }
               }
               
               "^tAIList$" {
                    if {[regexp -nocase "mcc=" $arr_local($param)]} {
                         #if {[regexp -all -nocase "mcc" $arr_local($param)] > 1 } { set arr_local($param) [ lindex $arr_local($param) 0 ] }
                         foreach ele [lindex $arr_local($param) 0] {
                              if {[regexp -nocase "writereplacewarningrequest|killrequest" $msgName]} { foreach {mcc mnc id} [split $ele] {break}
                              } else {
                                  set id ""
                                  foreach ele1 [split $ele] {
                                  if {[regexp -nocase "mcc=" $ele1]} {
                                     set mcc [lindex [split $ele1 =] end]
                                  } elseif {[regexp -nocase "mnc=" $ele1]} {
                                     set mnc [lindex [split $ele1 =] end]
                                  } else {
                                     set id "$id $ele1"
                                  }  
                                } 
                              }
                              
                              set mcc [lindex [split $mcc =] end]
                              set mnc [lindex [split $mnc =] end]
                              set mapId [simIENameMapper -msgName $msgName -msgType $msgType -IE [lindex [split $id =] 0] ]
			      set mcc [trimBraces $mcc] 
                              set mnc [trimBraces $mnc] 
                              set id [trimBraces $id] 
                              set mapId [trimBraces $mapId]
                               
                              lappend arr_local($mapId) [lindex [split $id =] end]
                              if { [ regexp -nocase "paging"  $msgName ] } {
                                   lappend arr_local(tAI,pLMNidentity) [eval "createLteIdentifier -identifier PLMNId -MCC $mcc -MNC $mnc"]
                              } elseif { [ regexp -nocase "writereplacewarningrequest|killrequest" $msgName]} {
                                   lappend arr_local(warningAreaList.trackingAreaListforWarning,pLMNidentity) [eval "createLteIdentifier -identifier PLMNId -MCC $mcc -MNC $mnc"]
                              } else {
                                   lappend arr_local($param,pLMNidentity) [eval "createLteIdentifier -identifier PLMNId -MCC $mcc -MNC $mnc"]
                              }
                         }
                         unset -nocomplain arr_local($param)
                    }
               }
               "tAI|eUTRAN_CGI|eCGI|registeredLAI|global_Cell_ID|selected_TAI|targetCell_ID" {
                    parray arr_local
                    if {[regexp -nocase "mcc=" $arr_local($param)]} {
                         foreach ele [lindex $arr_local($param) 0] {
                              set id ""
                              #foreach { mcc mnc id } $ele {break}
                              foreach ele1 $ele {
  				if {[regexp -nocase "mcc=" $ele1]} {
     				   set mcc [lindex [split $ele1 =] end]
  				} elseif {[regexp -nocase "mnc=" $ele1]} {
    				   set mnc [lindex [split $ele1 =] end]
  				} else {
    				   set id "$id $ele1"
  				}
		              }

                              set mcc [lindex [split $mcc =] end]
                              set mnc [lindex [split $mnc =] end]
                              set mapId [simIENameMapper -msgName $msgName -msgType $msgType -IE [lindex [split $id =] 0] ]
			      set mcc [trimBraces $mcc] 
                              set mnc [trimBraces $mnc] 
                              set mapId [trimBraces $mapId]
                              set id [trimBraces $id] 
                              if {[info exists arr_local($mapId)]} {
                                   lappend arr_local($mapId) [lindex [split $id =] end]
                              } else {
                                   set arr_local($mapId) [lindex [split $id =] end]
                              }

                              if {[regexp -nocase "HandoverRequest|handover_request|HandoverRequired|handover_required|enbconfigtransfer|ENBConfigurationTransfer|enb_configuration_transfer|mmeconfigtransfer|MMEConfigurationTransfer|mme_config_transfer|mmeconfigupdate|MMEConfigurationUpdate|mmeconfigupdateack|MMEConfigurationUpdateAcknowledge|mmeconfigupdatefail|MMEConfigurationUpdateFailure" $msgName]} {
                                   switch $param {
                                        "eUTRAN_CGI"     {set param1 targetCell_ID}
                                        "global_Cell_ID" {set param1 global_Cell_ID}
                                        "tAI"            {set param1 selected_TAI}
                                        default          {set param1 $param}
                                   }
                                   set arr_local($param1,pLMNidentity) [eval "createLteIdentifier -identifier PLMNId -MCC $mcc -MNC $mnc"]
                              } elseif {[regexp -nocase "writereplacewarningrequest|killrequest" $msgName]} {
                                   lappend arr_local(warningAreaList.cellIDList,pLMNidentity) [eval "createLteIdentifier -identifier PLMNId -MCC $mcc -MNC $mnc"]
                              } else {
                                   set arr_local($param,pLMNidentity) [eval "createLteIdentifier -identifier PLMNId -MCC $mcc -MNC $mnc"]
                              }
                         }
                         unset -nocomplain arr_local($param)
                    }
               }
               "gUMMEIList|gUMMEI_ID" {
                    if {[regexp -nocase "mcc=" $arr_local($param)]} {
                         foreach ele [lindex $arr_local($param) 0] {
                              set cmd "createLteIdentifier -identifier PLMNId "
                              foreach ie $ele {
                                   if {[regexp -nocase "mcc|mnc" $ie]} {
                                        if {[regexp -nocase "mcc=" $ie]} {
                                           set mcc [lindex [split $ie =] end]
                                           set mcc [trimBraces $mcc]
                                           append cmd "-MCC $mcc "
                                        } elseif {[regexp -nocase "mnc=" $ie]} {
                                          set mnc [lindex [split $ie =] end]
                                          set mnc [trimBraces $mnc]
                                          append cmd "-MNC $mnc "
                                        }
                                        continue
                                   } else {
                                        set ie [string trim [string map {\{ "" \} ""} $ie]]
                                        set mapId [simIENameMapper -msgName $msgName -msgType $msgType -IE [lindex [split $ie =] 0] ]
                                        puts "mapId $mapId ie [lindex [split $ie =] end]"
                                        if { [string length $ie ] > 0 && [string length $mapId ] > 0 } {
                                           set ieVal [lindex [split $ie =] end]
                                           if { [string length $ieVal ] > 0 } {
                                             #lappend arr_local($mapId) [lindex [split $ie =] end]
                                             lappend arr_local($mapId) $ieVal 
                                           }
                                        }
                                   }
                              }
                              lappend arr_local($param,pLMN_Identity) [lindex [eval $cmd] 0]
                              set cmd ""
                         }
                         unset -nocomplain arr_local($param)
                    }
               }
          }
     }
     
     # index >=0 indicates it is not a recursive call. So this help avoiding dump of data for recursive call
     # data will be dumped only in the first procedure call ... not in recursion
     if {$index >= 0} {
          # check for any list with comma seperated values, and convert them to a space seperated list
          foreach param [array names arr_local] {
               set arr_local($param) [regsub -all "," $arr_local($param) " "]
          }
          
          # Temp workaround to ignore streamId verification for error indication messages only
          if {[info exists arr_local(msgName)]} {
               if {[string tolower $arr_local(msgName)] == "errorindication"} {
                    print -dbg "Ignoring the stream id verification for errorindication messages in input"
                    #unset -nocomplain arr_local(StreamID)
                    foreach ele "iE_ID iECriticality typeOfError StreamID" {
                        unset -nocomplain arr_local($ele)
                    }
               }
               # Ignore some of the fields which are not needed to compare for paging
               if {[string tolower $arr_local(msgName)] == "paging"} {
                   unset -nocomplain arr_local(tAIList)
               }
          }

          # sort the PLMNs (broadcast plmns)
          #sortPlmnData
          
          # display
          printHeader "Processed input message : $arr_local(msgName)" 50 "-"
          parray arr_local
          print -nolog [string repeat - 50]
          
     }

     #remove if msgName is added in the arrary to compare with simulator output
     unset -nocomplain arr_local($msgName)
     
     return [array get arr_local]
}

proc verifySimOutput {input output} {
     #-
     #- to process output received on simulator
     #-
     #- @in input  expected output
     #- @in output output recieved on simualtor
     #-
     array set arr_local1 $input
     array set arr_local2 $output
     set flag 0
    
     #remove some of the fields which are not needed to compare
     if {[lsearch $input "PathSwitchRequest"] >= 0} {
        unset -nocomplain arr_local1(mME_Code)
        unset -nocomplain arr_local1(mME_Group_ID)
     }

     if {[lsearch $input "HandoverRequired"] >= 0} {
       unset -nocomplain arr_local1(uE_HistoryInformation)
     }
     #Remove some of the fields which are not displayed for DownlinkS1cdma2000tunneling msg in the output to compare
     if {[lsearch $input "DownlinkS1cdma2000tunneling"] >= 0} {
        foreach param "dL_gTP_TEID dL_transportLayerAddress e_RAB_ID uL_GTP_TEID uL_TransportLayerAddress" {
          unset -nocomplain arr_local1($param)
        }
     }
    
     #remove some of the fields which are not needed to compare
     foreach param "eNB_ID.macroENB_ID enbID MMEId Region" { unset -nocomplain arr_local1($param) }
     foreach param "enb_ID.macroENB_ID assocID gwIPPorts" { unset -nocomplain arr_local2($param) }

     if {[lsearch $output "S1SetupRequest"] >= 0 || [lsearch $output "HandoverRequired"] >= 0} {
        unset -nocomplain arr_local2(eNB_ID.macroENB_ID)
        unset -nocomplain arr_local2(01)
     }

     set indexList1 [lsort -dictionary [array names arr_local1]]
     set indexList2 [lsort -dictionary [array names arr_local2]]
     
     if {![isEmptyList [ldiff $indexList1 $indexList2]]} {
          print -fail "Indices mismatch between input and output data"
          set flag 1
     }
     
     foreach index $indexList1 {
          if {![info exists arr_local2($index)]} {
               print -fail "Not found INDEX : \"$index\" in output"
               set flag 1
               continue
          }
          set val1 $arr_local1($index)
          set val2 $arr_local2($index)
          # handling strings
          if {[regexp {[a-zA-Z]+} $val1]} {
               set val1 [string toupper [string trim $val1 \"]]
               set val2 [string toupper [string trim $val2 \"]]
          }
          
          # Trim the spaces before comparing the values
          set val1 [string trim $val1]
          set val2 [string trim $val2]

          if {[info exists ::IS_BKGND_SCRIPT] && $::IS_BKGND_SCRIPT == 1} {
             set retVal [verifyDUTValues $val1 $val2 $index]
             if { $retVal == 1 } {
                set flag 1
             } 
          } else {
            if {[llength $val1] == 1 && [llength $val2] == 1} {
               if {$val1 != $val2} {
                    set flag 1
                    set exp "!="
                    set tag fail
               } else {
                    set exp "=="
                    set tag pass
               }
               print -$tag "Verifying $index \($val1 $exp $val2\)"
            } else {
               print -info "Verifying $index \(\"$val1\" == \"$val2\"\)"
               foreach val $val1 {
                    set found [lsearch $val2 $val]
                    if {$found < 0} {
                         print -fail "\"$val\" not found in \"$val2\""
                         set flag 1
                    } else {
                         print -pass "\"$val\" found in \"$val2\""
                         set val2 [ldelete $val2 $found]
                    }
               }
               if {[llength $val2] != 0} {
                    print -fail "Found additional values in output \"[join $val2 ,]\""
                    set flag 1
               } else {
                    print -pass "Found all values in output"
               }
            }
         }
     }

     if {$flag} {
          print -fail "Output recieved on simulator is not as expected"
          return -1
     } else {
          print -pass "Output recieved on simulator is as expected"
          return 0
     }
}

proc processContextData {args} {
     #-
     #- Procedure to create context data for processing
     #-
     #- @return 0 on success, @return -1 on failure
     #-
     
     parseArgs args \
               [list \
               [list context              optional   "MME|HeNB|UE"    "MME"             "The context to be verified against" ] \
               [list MMEIndex             optional   "numeric"        "0"               "The MME index" ] \
               [list HeNBIndex            optional   "numeric"        "0"               "The HeNB Index" ] \
               [list GUMMEIIndex          optional   "numeric"        "__UN_DEFINED__"  "The GUMMEI index to be searched" ] \
               ]
     
     array set arr_local {}
     switch $context {
          "MME" {
               
               foreach ele [array names ::ARR_LTE_TEST_PARAMS_MAP -regexp "M,$MMEIndex"] {
                    set index [lindex [split $ele ,] end]
                    #set index [string map "MMECode \"MME Code\" MMEGroupId \"Group Id\"" $index]
                    set index [string map "MMEGroupId GroupId" $index]
                    append arr_local($index) "$::ARR_LTE_TEST_PARAMS_MAP($ele) "
               }
               
               #define the search pattern
               if {[info exists GUMMEIIndex]} {
                    set id $GUMMEIIndex
               } else {
                    set id "\[0-9\]+"
               }
               
               #create the list of noofGUMMEI elements per GUMMEI
               foreach ele1 {MMEGroupId MMECode MNC} ele2 {ServedGrpIdList ServedMMECodeList ServedPLMNList} {
                    foreach index [array names ::ARR_LTE_TEST_PARAMS_MAP -regexp "M,$MMEIndex,G$id,$ele1"] {
                         append arr_local($ele2) "[llength $::ARR_LTE_TEST_PARAMS_MAP($index)] "
                    }
               }
               
               foreach plmn [lindex [createLteIdentifier -identifier "PLMNId" -MCC $arr_local(MCC) -MNC $arr_local(MNC)] 0] {
                    append arr_local(Served\ GUMMEI\ List,PLMNId) "$plmn "
               }
               #create gummui list
               set arr_local(RATIndex) [listOfIncrEle 0 $::ARR_LTE_TEST_PARAMS($MMEIndex,GUMMEIs)]
               unset -nocomplain arr_local(MNC)
               unset -nocomplain arr_local(MCC)
          }
          "HeNB" {
               #Construct only the values that need to be verified
               foreach ele1 [list CSGId TAC "MME ID"]  ele2 [list "CSG ID" "TAC" "MME ID"] {
                    if {$ele1 == "MME ID"} {
                         set arr_local($ele2) [expr $MMEIndex + 1]
                         continue
                    }
                    set arr_local($ele2) [set ::ARR_LTE_TEST_PARAMS_MAP(H,$HeNBIndex,$ele1)]
               }
               foreach plmn [lindex [createLteIdentifier -identifier "PLMNId" \
                         -MCC $::ARR_LTE_TEST_PARAMS_MAP(H,$HeNBIndex,MCC) -MNC $::ARR_LTE_TEST_PARAMS_MAP(H,$HeNBIndex,MNC)] 0] {
                              append arr_local(Serving\ TAI\ List,PLMNID) "$plmn "
                         }
          }
          "UE" {
               parseArgs args \
                         [list \
                         [list UEIndex             optional   "numeric"    "0"                        "The UE index" ] \
                         [list state               optional   "string"     "full"                     "The UE state to be verified" ] \
                         [list initiatingMsg       optional   "string"     "downlink_nas_transport"   "The UE state to be verified" ] \
                         ]
               
               #ARR_LTE_TEST_PARAMS_MAP(H,0,U,0,MMEUES1APId) = 9820124
               set arr_local(HeNB\ ID)                [getHeNbIdInHeNBGrp $HeNBIndex]
               set arr_local(HeNB\ In\ Stream\ ID)    [expr $UEIndex   + 1]
               set arr_local(HeNB\ Out\ Stream\ ID)   [expr $UEIndex   + 1] ;# The logic for this would change later
               set arr_local(IsUserPlaneEnabled)      false
               set arr_local(MME\ ID)                 [expr $MMEIndex  + 1]
               if {[info exists ::ARR_LTE_TEST_PARAMS_MAP(H,$HeNBIndex,U,$UEIndex,mStreamId)]} {
                    set arr_local(MME\ Out\ Stream\ ID)     $::ARR_LTE_TEST_PARAMS_MAP(H,$HeNBIndex,U,$UEIndex,mStreamId)
                    set arr_local(MME\ In\ Stream\ ID)      $::ARR_LTE_TEST_PARAMS_MAP(H,$HeNBIndex,U,$UEIndex,mStreamId)
               }
               set arr_local(ENB\ UE\ S1\ AP\ ID)      $::ARR_LTE_TEST_PARAMS_MAP(H,$HeNBIndex,U,$UEIndex,eNBUES1APId)
               if {[info exists ::ARR_LTE_TEST_PARAMS_MAP(H,$HeNBIndex,U,$UEIndex,vENBUES1APId)]} {
                    set arr_local(Virtual\ ENB\ UE\ S1\ AP\ ID)  $::ARR_LTE_TEST_PARAMS_MAP(H,$HeNBIndex,U,$UEIndex,vENBUES1APId)
                    set arr_local(Virtual\ MME\ UE\ S1\ AP\ ID)  $::ARR_LTE_TEST_PARAMS_MAP(H,$HeNBIndex,U,$UEIndex,vENBUES1APId)
               }
               switch -regexp $state {
                    "partial" {
                         set arr_local(MME\ UE\ S1\ AP\ ID)   0
                         set arr_local(State/Substate)       "UE_CONTEXT_STATE_INITIAL_UE/UE_CONTEXT_SUBSTATE_AWAITING_MME_RSP"
                    }
                    "full" {
                         set arr_local(MME\ UE\ S1\ AP\ ID)   $::ARR_LTE_TEST_PARAMS_MAP(H,$HeNBIndex,U,$UEIndex,MMEUES1APId)
                         switch -regexp $initiatingMsg {
                              "downlink_nas_transport|uplink_nas_transport" {
                                   set arr_local(State/Substate)    "UE_CONTEXT_STATE_FIRST_DL_MSG_RCVD/UE_CONTEXT_SUBSTATE_DEFAULT"
                              }
                              "initial_context_setup_request" {
                                   set arr_local(State/Substate)    "UE_CONTEXT_STATE_INITIAL_CONTEXT_SETUP/UE_CONTEXT_SUBSTATE_AWAITING_HENB_RSP"
                              }
                              "initial_context_setup_response|ue_context_release_request" {
                                   set arr_local(State/Substate)    "UE_CONTEXT_STATE_OPERATIONAL/UE_CONTEXT_SUBSTATE_DEFAULT"
                              }
                              "ue_context_release_command" {
                                   set arr_local(State/Substate)    "UE_CONTEXT_STATE_UE_CONTEXT_RELEASE/UE_CONTEXT_SUBSTATE_AWAITING_HENB_RSP"
                              }
                         }
                    }
               }
          }
     }
     printHeader "Processed input data" 50 "-"
     parray arr_local
     print -nolog [string repeat - 50]
     return [array get arr_local]
}

proc getUEContextS1AP {args} {
     #-
     #- To get All UE Context S1AP Ids from DD
     #-
     #- @return ues1List sim command on success and -1 on failure
     
     parseArgs args \
               [list \
               [list simType            mandatory  "HeNB|MME"     ""                    "Identifies the sim type on which send/expect operatoin done"] \
               [list HeNBIndex          mandatory  "numeric"     "__UN_DEFINED__"       "Index of HeNB whose values need to be retrieved" ] \
               [list MMEIndex           optional    "numeric"    "0"      "Index of MME whose values need to be retrieved" ] \
               [list UEIndex            mandatory   "string"     ""       "UE Index passed from script"] \
               [list resetS1Map         mandatory   "string"     ""       "Identifies the UE associated S1 Map list"] \
               ]
     
     switch $simType {
          "HeNB" {
               set arr_local(eNB) "eNBUES1APId"
               set arr_local(MME) "vENBUES1APId"
          }
          "MME" {
               set arr_local(MME) "MMEUES1APId"
               set arr_local(eNB) "vENBUES1APId"
          }
          "default" {
               print -fail "incorrect $simType passed to the proc"
               return -1
          }
     }
     
     if {[llength [split $UEIndex ","]]!=[llength [split $resetS1Map ","]]} {
          print -fail "UEIndex elements and S1Map elements do not match"
          return -1
     }
     
     #for multiple UE index
     foreach indList [split $UEIndex ","] mapList [split $resetS1Map ","] {
          #If range is defined
          if {[regexp {\-} $indList]} {
               foreach {first end} [split $indList "-"] {break}
               if {![info exists first] && ![info exists end]} {
                    print -fail "UE range passed is not valid, $indList"
                    return -1
               }
               set indList ""
               set indList [listOfIncrEle $first [expr $end-$first+1]]
               
          }
          
          #foreach index within range
          foreach ind $indList {
               
               #foreach map entry of xx:xxx format
               #first entry in xx:xxx is for eNB and 2nd is for MME
               set ues1 ""
               foreach map [split $mapList ":"] {
                    switch -regexp $map {
                         "^eNB$" {
                              #non-existent ue index
                              if {$ind=="x"} {
                                   append ues1 "eNB_UE_S1AP_ID=[random 16777215] "
                              } else {
                                   append ues1 "eNB_UE_S1AP_ID=[getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $ind -param $arr_local($map)] "
                              }
                         }
                         "^MME$" {
                              #non-existent ue index
                              if {$ind=="x"} {
                                   append ues1 "mME_UE_S1AP_ID=[random 16777215] "
                              } else {
                                   append ues1 "mME_UE_S1AP_ID=[getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $ind -param $arr_local($map)] "
                              }
                         }
                         "^both$" {
                              #non-existent ue index
                              if {$ind=="x"} {
                                   append ues1 "eNB_UE_S1AP_ID=[random 16777215] "
                                   append ues1 "mME_UE_S1AP_ID=[random 16777215] "
                              } else {
                                   append ues1 "eNB_UE_S1AP_ID=[getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $ind -param $arr_local(eNB)] "
                                   append ues1 "mME_UE_S1AP_ID=[getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $ind -param $arr_local(MME)] "
                              }
                         }
                         "^\\d+$" {
                              #first entry is for eNB
                              if {[lsearch -regexp [split $mapList ":"] $map]==0} {
                                   append ues1 "eNB_UE_S1AP_ID=[getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $map -param $arr_local(eNB)] "
                                   # 1:eNB is invalid format
                                   if {[string match -nocase "eNB" [lindex [split $mapList ":"] 1]]} {
                                        print -fail "$mapList is invalid format"
                                        return -1
                                   }
                              } elseif {[lsearch -regexp [split $mapList ":"] $map]==1} {
                                   #second entry is for MME
                                   append ues1 "mME_UE_S1AP_ID=[getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $map -param $arr_local(MME)] "
                                   # MME:1 is invalid format
                                   if {[string match -nocase "MME" [lindex [split $mapList ":"] 0]]} {
                                        print -fail "$mapList is invalid format"
                                        return -1
                                   }
                              } else {
                                   print -fail "Not able to extract UES1 id for $map entry in $mapList"
                              }
                         }
                         "^x$" {
                              if {$ind =="x"} {
                                   print -info "ueind is $ind, so $mapList doesnt matter"
                                   continue
                              }
                              #first entry is for eNB
                              if {[lsearch -regexp [split $mapList ":"] $map]==0} {
                                   append ues1 "eNB_UE_S1AP_ID=[random 16777215] "
                                   
                                   # 1:eNB is invalid format
                                   if {[string match -nocase "eNB" [lindex [split $mapList ":"] 1]]} {
                                        print -fail "$mapList is invalid format"
                                        return -1
                                   }
                              } elseif {[lsearch -regexp [split $mapList ":"] $map]==1} {
                                   #second entry is for MME
                                   # for format like eNB:x or 1:x
                                   append ues1 "mME_UE_S1AP_ID=[random 16777215] "
                                   
                                   # MME:1 is invalid format
                                   if {[string match -nocase "MME" [lindex [split $mapList ":"] 0]]} {
                                        print -fail "$mapList is invalid format"
                                        return -1
                                   }
                              }
                         }
                         "=" {
                              foreach {type val} [split $map "="] {break}
                              if {$type == "eNB"} { append ues1 "eNB_UE_S1AP_ID=$val "}
                              if {$type == "MME"} { append ues1 "mME_UE_S1AP_ID=$val "}
                         }
                         "default" {
                              print -fail "Incorrect UES1Map $map passed to this procedure"
                              return -1
                         }
                    }
               }
               append ues1List "{[string trim $ues1 ","]},"
               print -info "ueind $ind map $mapList on HeNB ($HeNBIndex) is {[string trim $ues1 ","]}"
          }
     }
     set ues1List [string trim $ues1List ","]
     return $ues1List
     
}

proc paging {args} {
     
     #- This procedure is used to send and verify the paging message.
     #- @return 0 on success, @return -1 on failure
     
     global  arr_paging_msg
     
     set validS1Msg        "paging"
     
     parseArgs args \
               [list \
               [list msg                     optional   "$validS1Msg"    "paging"                    "The message to be sent" ] \
               [list operation               optional   "send|(don't|)expect"    "send"        	     "send or expect option" ] \
               [list execute                 optional   "boolean"        "yes"                        "To perform the operation or not. if no, will return the message"] \
               [list streamId                optional   "string"         "0"                          "The sctp string to send or receive data"] \
               [list TAC                     optional   "string"         "__UN_DEFINED__"             "The Broadcasted TAC to be used" ] \
               [list pagingDRX               optional   "string"         "v[getLTEParam defaultPagingDrx]" "Pagging DRX value"] \
               [list MCC                     optional   "string"         "__UN_DEFINED__"             "The MCC param to be used"] \
               [list MNC                     optional   "string"         "__UN_DEFINED__"             "The MNC param to be used"] \
               [list HeNBId                  optional   "string"         "__UN_DEFINED__"             "The heNBId param to be used in HeNB"] \
               [list CSGId                   optional   "string"         "__UN_DEFINED__"             "The CSGId param to be used in HeNB"] \
               [list MMECode                 optional   "string"         [getLTEParam "MMECode"]      "The MME Code to be used"] \
               [list ueIdentityIndexValue    optional   "numeric"        "100"                        "Index of MME"] \
               [list uePagingId              optional   "stmsi|imsi"     "stmsi"                      "UE paging ID IMSI or s-TMSI "] \
               [list cnDomain                optional   "cs|ps"          "cs"                         "CN domain CS or PS" ] \
               [list pagingPriority          optional   "string"         "__UN_DEFINED__"             "Paging Priority" ] \
               [list drxPaging               optional   "string"         "__UN_DEFINED__"             "Paging Priority" ] \
               [list testTAI                 optional   "string"         "no"                         "Send paging message with only test TAI" ] \
               [list GUMMEIIndex             optional   "string"         "0"                          "Index of GUMMEI"] \
               [list MMEIndex                optional   "string"         "0"                          "Index of GUMMEI"] \
               [list needCsgId               optional   "string"         "no"                         "Index of GUMMEI"] \
               [list missMandIe              optional   "string"         "__UN_DEFINED__"             "Miss the mandatory IE" ] \
               ]
     
     set msgName [string map "paging paging" $msg]
     set msgType "class2"
     
     switch $operation {
          
          "send" {
               
               array set arr_paging_msg {}
               set simType "MME"
              
               set gwIp   [getDataFromConfigFile "mmeSignalingIpaddress" 0 ]
               set gwPort [getDataFromConfigFile "henbSctp" 0 ]
               set MMEId  [getFromTestMap -MMEIndex $MMEIndex -param "MMEId"]
 
               if { $needCsgId != "no" } {
                    if { ![info exists CSGId] }  { set CSGId  [ join [ lindex [getFromTestMap -HeNBIndex "all"  -param "CSGId"] 0 ] , ] }
                    
                    foreach param "CSGId pagingDRX" {
                         if {[set $param] == ""} {
                              print -dbg "No $param IE generated with -$param <val> option. will not send $param IE in the message"
                              unset -nocomplain $param
                         }
                    }
               }
               
               if { ![info exists TAC] }    { set TAC      [getFromTestMap -HeNBIndex "all" -param "TAC"] }
               if { ![info exists MNC] }    { set MNC      [getFromTestMap -HeNBIndex "all" -param "MNC"] }
               if { ![info exists MCC] }    { set MCC      [getFromTestMap -HeNBIndex "all" -param "MCC"] }
               
               set supportedTAs [getTAList -TACList $TAC -MNCList $MNC -MCCList $MCC]
               print -info "supportedTAs $supportedTAs"
               if {$supportedTAs == ""} {
                    print -info "No supportedTAs IE generated with -TAC $TAC -MCC $MCC -MNC $MNC ... \
                              will not send supportedTAs IE in the message"
                    unset -nocomplain supportedTAs
               }
               
               if { $testTAI != "no" } {
                    set testTAC $::ARR_LTE_TEST_PARAMS(testTAC)
                    set testMNC $::ARR_LTE_TEST_PARAMS(testMNC)
                    set testMCC $::ARR_LTE_TEST_PARAMS(testMCC)
                    set supportedTestTAs [getTA -TACList $testTAC -MNCList $testMNC -MCCList $testMCC]
                    
                    if { $testTAI == "testTAIOnly" } { set supportedTAs $supportedTestTAs }
                    if { $testTAI == "yes" } { set supportedTAs "$supportedTAs,$supportedTestTAs" }
               }
               
               switch  $uePagingId  {
                    "stmsi"  {
                         set mmecList [getFromTestMap -MMEIndex $MMEIndex -GUMMEIIndex $GUMMEIIndex -param "MMECode"]
                         set mmeCode [ lindex $mmecList 0 ]
                         set mTmsi [ random 429496729 ]
                         set uePagingId [ list "s_TMSI=[list [ list mMEC=$mmeCode m_TMSI=$mTmsi]]" ]
                    }
                    
                    "imsi"  {
                         set mnc  [ lindex [getFromTestMap -MMEIndex $MMEIndex -GUMMEIIndex $GUMMEIIndex -param "MNC"] 0 ]
                         set mcc  [ lindex [getFromTestMap -MMEIndex $MMEIndex -GUMMEIIndex $GUMMEIIndex -param "MCC"] 0 ]
                         set msin [ random 429496729 ]
                         set imsi "[format %x $mcc][format %x $mnc][format %x $msin]"
                         if { [ expr [ string len $imsi ] % 2 ] } { set imsi "0$imsi" }
                         set uePagingId  "{iMSI=$imsi}"
                         print -info "imsi --> $uePagingId"
                    }
               }
               #### Code to avoide sending the mandator IE ##########
               if { [ info exists missMandIe ] } {
                    foreach ele [ split $missMandIe ,] {
                         if { ![ regexp "ueIdentityIndexValue|uePagingId|cnDomain|taiList" $ele ] } {
                              print -fail "ERROR: Does not find the IE : $ele"
                              return -1
                         }
                         set tempName [ string map "taiList supportedTAs" $ele ] ;
                         unset -nocomplain $tempName
                    }
               }
               ##########################################################
          }
          
          "expect" {
               set simType "HeNB"
               parseArgs args \
                         [list \
                         [list HeNBIndex   mandatory  "numeric"        ""        "Index of HeNB"] \
                         ]
               set HeNBId [getFromTestMap -HeNBIndex $HeNBIndex -param "HeNBId"]
          }
          
     }
     
     if { $operation == "send"  } {
          set paging [ updateValAndExecute "constructS1Procedure -simType simType -msgName msgName -msgType msgType -MMEId MMEId -HeNBId HeNBId \
                    -pagingDRX pagingDRX -CSGIdList CSGId -MCC MCC -MNC MNC -supportedTAs supportedTAs \
                    -ueIdentityIndexValue ueIdentityIndexValue  -MMECode MMECode  -MMERelaySupportInd MMERelaySupportInd \
                    -drxPaging drxPaging  -criticalityDiag criticDiag  -pagingPriority pagingPriority -timeToWait timeToWait \
                    -servedGUMMEIList servedGUMMEIList -streamId streamId -uePagingId uePagingId -cnDomain cnDomain -gwIp gwIp -gwPort gwPort" ]
          
          array set arr_paging_msg $paging
     }
     
     if { $operation == "expect" } {
          # Removing the CSGID LIST since its not relayed to the HeNB
          set paging [ array get arr_paging_msg ]
          if { [ regsub {csgidlist=\d+} $paging "" paging ] != 1 } { print -info "CSG ID LIST is missing" }
          if { [ regsub {StreamNo=\d+} $paging "StreamNo=0" paging ] == 1 } { print -info "Stream No is replaced with 0; \
                         HenBGW has to send paging on stream Id 0 towards HeNB" }
          #if { [ regsub {imsi=} $paging "imsi=0x" paging ] != 1 }  { print -info "Replaced imsi value with 0ximsi" }
          if { [ regexp {pagingPriority=(\d+)} $paging - prioVal ] } {
               regsub {pagingPriority=(\d+)} $paging "pagingPriority=PRIOLEVEL[incr prioVal]" paging
          }
          #unset -nocomplain arr_paging_msg
     }
     
     if {$execute == "no"} { return "$simType $paging"}
     
     return [updateValAndExecute "sendOrVerifyS1APProcedure -msgName msgName -msgType msgType \
               -operation operation -msgList paging -simType simType \
               -HeNBIndex HeNBIndex -MMEIndex MMEIndex -henbId HeNBId \
               -getS1MsgRetryAttemps getS1MsgRetryAttemps -getS1MsgRetryAfter getS1MsgRetryAfter"]
     
}

proc getSetArrayTestParam { args } {
     
     global ARR_LTE_TEST_PARAMS_MAP
     
     parseArgs args \
               [list \
               [list HeNBIndex       "optional"     "numeric"        "__UN_DEFINED__"              "HeNB index" ] \
               [list MMEIndex        "optional"     "numeric"        "__UN_DEFINED__"              "MME index"  ] \
               [list ueOrGummieId    "optional"     "numeric"        "__UN_DEFINED__"              "MME index"  ] \
               [list param           "optional"     "string"         "__UN_DEFINED__"              "rarameter to be read from array" ] \
               [list operation       "optional"      "string"        "read"                         "The ppid to be used to decode the pcap file" ] \
               ]
     
     if { [ info exists HeNBIndex ] && [ info exists MMEIndex ] } {
          print -info "MME and HeNB index both set, Procdure can handle one operation at a time" ;
          return -1
     }
     
     if {  [ info exists HeNBIndex ] }    { set arrKey "H,$HeNBIndex," }
     if {  [ info exists MMEIndex ] }     { set arrKey "M,$MMEIndex," }
     if { ![ info exists arrKey ] }       { print -info "Error : MMEIndex and HeNBIndex not set" ; return -1  }
     
     if {  [info exists ueOrGummieId ]}   {
          if { [regexp "H" $arrKey ] }    { append arrKey "U,$ueOrGummieId,"  }
          if { [regexp "M" $arrKey ] }    { append arrKey "G$ueOrGummieId," }
     }
     
     append arrKey $param
     print -info "arrKey --> $arrKey"
     
     switch $operation {
          "write"  {
               parseArgs args \
                         [list \
                         [list val            "mandatory"      "string"         "__UN_DEFINED__"              "Value of the parameter if operation is write"   ]
               ]
               
               if {[ llength [ array names ARR_LTE_TEST_PARAMS_MAP -exact $arrKey] ] != 1  } {
                    print -info "Error :Cannot find array element $arrKey" ; return -1
               }
               
               print -info "Value before modification ARR_LTE_TEST_PARAMS_MAP($arrKey) == $ARR_LTE_TEST_PARAMS_MAP($arrKey)"
               set ARR_LTE_TEST_PARAMS_MAP($arrKey) $val
               print -info "Value after modification ARR_LTE_TEST_PARAMS_MAP($arrKey) == $ARR_LTE_TEST_PARAMS_MAP($arrKey)"
               return 0
          }
          
          "read" {
               
               if {[ llength [ array names ARR_LTE_TEST_PARAMS_MAP -exact $arrKey] ] != 1  } {
                    print -info "Error :Cannot find array element $arrKey" ; return -1
               }
               print -info "Value of array ARR_LTE_TEST_PARAMS_MAP($arrKey) == $ARR_LTE_TEST_PARAMS_MAP($arrKey)"
               return $ARR_LTE_TEST_PARAMS_MAP($arrKey)
          }
     }
}

proc dumpCallFlowInScript {} {
     #-
     #- Procedure to dump the call flow that happens in the script
     #-
     
     global ARR_CALL_FLOW
     if {[array exists ARR_CALL_FLOW]} {
          printHeader "Dumping the S1 Message exchange call flow in the script" "100" "*"
          print -nolog ""
          print -nolog [string repeat - 66]
          print -nolog [format "%+6s %+6s %+6s %12s %-40s" "SeqNo" "SIM" "Index" "Direction" "   Message"]
          print -nolog [string repeat - 66]
          set arrow1 "--------"
          foreach index [lsort -dictionary [array names ARR_CALL_FLOW]] {
               foreach {seqNo simType simIndex direction} [split $index ","] {break}
               if {![isDigit $seqNo]} {continue}
               if {$direction == "expect"} {
                    set arrow2 "<$arrow1"
               } else {
                    set arrow2 "$arrow1>"
               }
               print -nolog [format "%+6s %+6s %+6s %12s %-40s" $seqNo $simType $simIndex $arrow2 "  $ARR_CALL_FLOW($index)"]
          }
          print -nolog [string repeat - 66]
     }
}

proc getLastInitiatedMessage {args} {
     #-
     #- Procedure to get the last message that was sent from the simulator
     #-
     #- @ return the last s1 message call or -1 if no previous state exists
     #-
     
     parseArgs args \
               [list \
               [list MMEIndex             optional   "numeric"        "0"               "The MME index" ] \
               [list HeNBIndex            optional   "numeric"        "0"               "The HeNB Index" ] \
               ]
     
     global ARR_CALL_FLOW
     if {![info exists ARR_CALL_FLOW]} {return -1}
     
     set eleList [lreverse [lsort -dictionary [array names ARR_CALL_FLOW]]]
     if {[llength $eleList] < 2} {return -1}
     foreach ele $eleList {
          # Get the last state of the call flow, ignore error_indication
          if {$ele == "seqNo"} {continue}
          if {[lindex $ARR_CALL_FLOW($ele) 0] == "error_indication"} {continue}
          if {![regexp {[subst {(\d+),((MME|HeNB)),($MMEIndex|$HeNBIndex)}]} $ele]} {print $ele; continue}
          print -debug "The Last initiated message from [lindex [split $ele ,] 0] is \"[string trim [lindex $ARR_CALL_FLOW($ele) 0]]\""
          return [string trim [lindex $ARR_CALL_FLOW($ele) 0]]
     }
     return -1
}

proc getHeNbIdInHeNBGrp {HeNBIndex} {
     #-
     #- This procedure is used to get the HeNbId from the HeNB Group info
     #-
     #- @ return 1 if the info cant be retried else returns the id
     #-
     
     if {[array exist ::ARR_HeNBGRP_MAP]} {
          foreach henb [array names ::ARR_HeNBGRP_MAP] {
               lappend arr_local($::ARR_HeNBGRP_MAP($henb)) $henb
          }
          
          set index [lsearch $arr_local($::ARR_HeNBGRP_MAP($HeNBIndex)) $HeNBIndex]
          if {$index >= 0} {
               return [expr $index + 1]
          }
     }
     return 1
}

proc enbStatusTransfer { args } {
     
     #global ARR_LTE_TEST_PARAMS_MAP
     #set ::ARR_LTE_TEST_PARAMS_MAP(H,0,U,0,vENBUES1APId) "123456"
     #set ::ARR_LTE_TEST_PARAMS_MAP(H,0,U,0,mmeUEId)   "232323"
     
     set validS1Msg     "enbStatusTransfer"
     set msgType        "class2"
     
     parseArgs args \
               [list \
               [list msg                  optional   "$validS1Msg"          "enbStatusTransfer"    "The message to be sent" ] \
               [list operation            optional   "send|(don't|)expect"  "send"                 "send or expect option" ] \
               [list execute              optional   "boolean"              "yes"                  "To perform the operation or not. if no, will return the message"] \
               [list streamId             optional   "numeric"              "__UN_DEFINED__"       "Defines the streamId assigned" ]\
               [list HeNBIndex            mandatory  "numeric"              ""                     "Index of HeNB whose values need to be retrieved" ] \
               [list UEIndex              mandatory  "numeric"              ""                     "Index of UE whose values need to be retrieved" ] \
               [list MMEIndex             optional   "numeric"              "0"                    "Index of MME whose values need to be retrieved" ] \
               [list eNBUES1APId          optional   "string"               "__UN_DEFINED__"       "eNB UE S1AP Id value" ] \
               [list MMEUES1APId          optional   "string"               "__UN_DEFINED__"       "MME UE S1AP Id value" ] \
               [list fgwNum               optional   "string"         "0"             "The Broadcasted TAC to be used" ] \
               [list eNBStusTsfrCntier    optional   "string"               "1,1,1,1,1,1"          "PDCP Sequence Number value" ] \
               [list missManIe            optional   "string"               "__UN_DEFINED__"       "Mandatory IE that needs to missed" ] \
               ]
     
     set msgName [string map "enbstatustransfer enb_status_transfer" [ string tolower $msg ] ]
     if {$operation == "send"} { set simType "HeNB"  } else {  set simType "MME"  }
     set mandatoryIEs "MMEUES1APId eNBUES1APId eNBStusTsfrCntier"
     set eNBStusTsfrCntier [generateIEs -IEType "ENBStatusTransfer" -paramIndices $eNBStusTsfrCntier -HeNBIndex $HeNBIndex -MMEIndex $MMEIndex]
     
     if {$operation == "send"} {
          set simType "HeNB"
          set dynEleList [list eNBUES1APId MMEUES1APId streamId ueid]
          set paramList  [list eNBUES1APId vENBUES1APId streamId ueid]
          set HeNBId     [getFromTestMap -HeNBIndex $HeNBIndex -param "HeNBId"]
          set gwIp   [getDataFromConfigFile "henbSignalingIpaddress" $fgwNum]
          set gwPort [getDataFromConfigFile "henbSctp" $fgwNum] 
     } else {
          set simType "MME"
          set paramList [list vENBUES1APId MMEUES1APId streamId mmeUEId]
          set dynEleList [list eNBUES1APId MMEUES1APId streamId ueid]
          set HeNBId     [getFromTestMap -HeNBIndex $HeNBIndex -param "HeNBId"]

          set MultiS1Link $::ARR_LTE_TEST_PARAMS(MultiS1Link)
          if {$MultiS1Link == "yes"} {
             set enbID [getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "eNBId"]
          }   
     }
     
     foreach dynElement $dynEleList param $paramList {
          if {![info exists $dynElement]} {
               if {$param == "streamId"} {
                    set streamId [expr $UEIndex + 1]
                    continue
               }
               if {[catch {set $dynElement [getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "$param"]}]} {
                    print -abort "Failed to get the param $param"
                    return 1
               }
          }
     }
     
     if { [ info exists missManIe ] } { foreach mandIE [ split $missManIe ,] { unset $mandIE } }
     print -info "msgName ---> $msgName" ;
     set enbStatusTransferMsg [updateValAndExecute "constructS1Procedure -simType simType -msgName msgName -msgType msgType \
               -HeNBId HeNBId -ueid ueid -eNBUES1APId eNBUES1APId -MMEUES1APId MMEUES1APId  -eNBStusTsfrCntier eNBStusTsfrCntier \
               -streamId streamId -gwIp gwIp -gwPort gwPort"]
     
     print -info "enbStatusTransferMsg $enbStatusTransferMsg" ;
     if {$execute == "no"} { return "$simType $handoverMsg"}
     
     return [updateValAndExecute "sendOrVerifyS1APProcedure -msgName msgName -msgType msgType \
               -operation operation -msgList enbStatusTransferMsg -simType simType -enbID enbID \
               -HeNBIndex HeNBIndex -MMEIndex MMEIndex"]
     
}
proc eNBConfigUpdate { args } {
     
     #-
     #- The purpose of eNBConfigUpdate is to update application level configuration data needed for eNB and MME to interoperate corretly on the s1-interface.
     #-
     #- This procedure does not affect existing UE-related contexts, if any
     #-
     #- HeNB initiates this procedure to update its supporting TAs, eNB Name, Default Paging DRX, CSG ID by sending eNBConfigUpdate message towards GW.
     #-
     #- GW replies back with eNBConfigUpdateAck or eNBConfigUpdateFailure towards HeNB depending on the contents of eNBConfigUpdate message contents.
     #-
     #-  ---------eNBConfigUpdate-------------
     #-
     #-  Message Type                     M
     #-  eNB Name                         O
     #-  Supported TAS
     #-  CSG Id List
     #-  Default paging DRX               O
     #-
     #-   ------------IE------------------------
     #- 1. Supported TAs
     #-   >TAC                            M
     #-   >Broadcast PLMNs                M
     #-     >>PLMN Identity               M
     #-
     #- 2. CSG Id List
     #-   >CSG Id
     #-  ---------------------------------------
     
     global ARR_eNB_CONFIG_UPDATE
     set msgType   "class1"
     set validMsg "update|ack|failure"
     parseArgs args \
               [list \
               [list msg                  optional   "$validMsg"            "update"                         "The message to be sent" ] \
               [list operation            optional   "send|(don't|)expect"  "send"                           "send or expect or don't expect option"] \
               [list execute              optional   "boolean"              "yes"                            "To perform the operation or not"] \
               [list eNBName              optional   "string"              "__UN_DEFINED__"                  "eNB name"] \
               [list pagingDRX            optional   "string"              "__UN_DEFINED__"                  "Pagging DRX value"] \
               [list CSGIdList            optional   "string"              "__UN_DEFINED__"                  "The CSGId param to be used in HeNB"] \
               [list supportedTAs         optional   "string"              "__UN_DEFINED__"                  "supported TAs" ] \
               [list noIEs                optional   "yes|no"               "no"                             "whether to include IEs or not"] \
               [list MMEIndex             optional   "numeric"              "0"                              "from which mme to fetch or expect value" ] \
               [list HeNBIndex            optional   "numeric"              "__UN_DEFINED__"                 "which HeNB's configuration would you like to change"] \
               [list RefHeNBIndex         optional   "numeric"              "__UN_DEFINED__"                 "which HeNB's configuration would you like to use"] \
               [list cause                optional   "string"               "unspecified"                 "cause for enb config update failure"] \
               [list causeType            optional   "string"               "protocol"                       "Identifies the cause choice group"] \
               [list timeToWait           optional   "string"               "__UN_DEFINED__"                 "time to wait for the subsequent enb config update retry"] \
               [list TACListElements      optional   "string"               "__UN_DEFINED__"                 "For OAM changes, need TAC to compute supported TA" ] \
               [list MCCListElements      optional   "string"               "__UN_DEFINED__"                 "For OAM changes, need MCC to compute supported TA" ] \
               [list MNCListElements      optional   "string"               "__UN_DEFINED__"                 "For OAM changes, need MNC to compute supported TA" ] \
               [list criticalityDiag      optional   "string"               "__UN_DEFINED__"                 "The critical diag to be enabled or not"] \
               [list sourceConfig	  optional   "numeric"              "__UN_DEFINED__"		     "source HeNB configuration" ] \
               [list procedureCode        optional   "string"               "__UN_DEFINED__"                 "The procedure code to be used diag"] \
               [list triggerMsg           optional   "string"               "__UN_DEFINED__"                 "Identifies the triggering message"] \
               [list procedureCriticality optional   "string"               "__UN_DEFINED__"                 "Identifies the procedure Criticality"] \
               [list IECriticality        optional   "string"               "__UN_DEFINED__"                 "Identifies the IE Criticality list"] \
               [list IEId                 optional   "numeric"              "__UN_DEFINED__"                 "Identifies the IE Id list"] \
               [list typeOfError          optional   "string"               "__UN_DEFINED__"                 "Identifies the type of error list"] \
               [list streamId             optional   "numeric"              "__UN_DEFINED__"                 "Defines the streamId assigned" ] \
               [list globaleNBId          optional   "numeric"              "__UN_DEFINED__"                 "Defines the global enbid" ] \
               ]
     set msgName [string map "\
               update  enb_configuration_update  \
               ack     enb_configuration_update_ackowledge \
               failure enb_configuration_update_failure" $msg]

     set gwPort [getDataFromConfigFile "henbSctp" 0 ]
     set gwIp   [getDataFromConfigFile "mmeSignalingIpaddress" 0 ]

     set MultiS1Link $::ARR_LTE_TEST_PARAMS(MultiS1Link)
     if {$MultiS1Link == "yes"} {
        if {[info exists globaleNBId]} {
           set eNBType [getFromTestMap -HeNBIndex $HeNBIndex -param "eNBType"]
           if {! [ info exists eNBType ]} {
              set eNBType "macro"
           }
           set globaleNBId "\{${eNBType}ENB_ID=$globaleNBId\}"
        }
     }   

     switch $msg {
          
          "update" {
               
               if {$operation == "send"} {
                    set simType "HeNB"
                    set HeNBId     [getFromTestMap -HeNBIndex $HeNBIndex -param "HeNBId"]
                    set gwIp   [getDataFromConfigFile "henbSignalingIpaddress" 0 ]
                    if { ![info exists eNBName ] } { set eNBName [getLTEParam "HeNBGWName"] }
                    if { [info exists eNBName ] } { if { $eNBName == "" } { unset -nocomplain eNBName } }
                    
                    if { ![info exists pagingDRX ] } { set pagingDRX "v[getLTEParam defaultPagingDrx]" }
                    if { [info exists pagingDRX ] } { if {  $pagingDRX == "" } { unset -nocomplain  pagingDRX } }
                    
                    if { [info exists supportedTAs ] } { if { $supportedTAs == "" } { unset -nocomplain supportedTAs } }
                    
                    if { ![info exists CSGIdList ] } {set CSGIdList    [join [getFromTestMap -HeNBIndex $HeNBIndex -param "CSGId"] ","] }

                    if { [info exists CSGIdList ] } { if {  $CSGIdList == "" } { unset -nocomplain  CSGIdList } }
                    if { ([info exists RefHeNBIndex]) && ($supportedTAs == "yes" )  } {
                         set RefTAC      [getFromTestMap -HeNBIndex $RefHeNBIndex -param "TAC"]
                         set RefMNC      [getFromTestMap -HeNBIndex $RefHeNBIndex -param "MNC"]
                         set RefMCC      [getFromTestMap -HeNBIndex $RefHeNBIndex -param "MCC"]
                         if { [info exists sourceConfig] } {
                              lappend RefTAC [getFromTestMap -HeNBIndex $sourceConfig -param "TAC"]
                              lappend RefMNC [getFromTestMap -HeNBIndex $sourceConfig -param "MNC"]
                              lappend RefMCC [getFromTestMap -HeNBIndex $sourceConfig -param "MCC"]
                         }
                         set supportedTAs [getTA -TACList $RefTAC -MNCList $RefMNC -MCCList $RefMCC]
                    }
                    
                    if {$noIEs == "yes" } {
                         
                         foreach param "eNBName pagingDRX CSGIdList supportedTAs" {
                              unset -nocomplain $param
                         }
                         
                    }
                    set CSGIdList "\{cSG_Id=$CSGIdList\}" 
                    
               } else {
                    set simType "MME"
                    
                    foreach param "eNBName pagingDRX CSGIdList supportedTAs" {
                         if {$param == ""} {
                              set $param "__UN_DEFINED__"
                         }
                    }
                    if { ([info exists TACListElements]) && ([info exists MCCListElements]) && ([info exists MNCListElements]) && ($supportedTAs == "yes") } {
                         set supportedTAs [getTA -TACList $TACListElements -MNCList $MNCListElements -MCCList $MCCListElements ]
                    }
                    
               }
               
          }
          "ack" {
               if {$operation == "send"} {
                    set simType "MME"
                    set MMEId  [getFromTestMap -MMEIndex $MMEIndex -param "MMEId"]
               } else {
                    set simType "HeNB"
                    set HeNBId     [getFromTestMap -HeNBIndex $HeNBIndex -param "HeNBId"]
               }
               if {[info exists criticalityDiag]} {
                    set criticalityDiag [updateValAndExecute "getCriticDiag -criticalityDiag criticalityDiag \
                              -procedureCode procedureCode -triggerMsg triggerMsg \
                              -procedureCriticality procedureCriticality \
                              -IECriticality IECriticality -IEId IEId -typeOfError typeOfError"]
               }
               
          }
          "failure" {
               set mandatoryIEs "msgType cause"
               if {$operation == "send"} {
                    set simType "MME"
                    set MMEId  [getFromTestMap -MMEIndex $MMEIndex -param "MMEId"]
               } else {
                    set simType "HeNB"
                    set HeNBId     [getFromTestMap -HeNBIndex $HeNBIndex -param "HeNBId"]
               }
               if {[info exists criticalityDiag]} {
                    set criticalityDiag [updateValAndExecute "getCriticDiag -criticalityDiag criticalityDiag \
                              -procedureCode procedureCode -triggerMsg triggerMsg \
                              -procedureCriticality procedureCriticality \
                              -IECriticality IECriticality -IEId IEId -typeOfError typeOfError"]
                    
               }
               
          }
          
     }
     set causeVal "\{$causeType=$cause\}" 
     set enbConfigUpdate [updateValAndExecute "constructS1Procedure -simType simType -msgName msgName -msgType msgType -HeNBId HeNBId -MMEId MMEId -globaleNBId globaleNBId \ 
               -streamId streamId -eNBName eNBName -supportedTAs supportedTAs -pagingDRX pagingDRX -CSGIdList CSGIdList -criticalityDiag criticalityDiag -timeToWait timeToWait -cause causeVal -gwIp gwIp -gwPort gwPort"]
     array set ARR_eNB_CONFIG_UPDATE $enbConfigUpdate
     
     if {$execute == "no"} { return "$simType $enbConfigUpdate"}
     return [updateValAndExecute "sendOrVerifyS1APProcedure -msgName msgName -msgType msgType -operation operation -msgList enbConfigUpdate -enbID globaleNBId \
               -simType simType -HeNBIndex HeNBIndex -MMEIndex MMEIndex"]
     
}

proc eNBConfigTransfer { args } {
     
     #-
     #- The purpose of eNBConfigTransfer procedure is to transfer RAN configuration information from eNB to MME/HeNBGW in unacknowledge mode
     #-
     #- This includes request/response for X2 - Transport Network Layer Address of target eNB
     #-
     #- The source eNB initiates this procedure towards HeNBGW. The message sent may/maynot include SON Configuration Transfer IE. If it includes, then, if HeNBGW doesnt host \
     #- the target eNB , then the message is forwarded to MME.
     #-
     #-  ---------eNBConfigTransfer-------------
     #-
     #-  Message Type                     M
     #-  SON Configuration Transfer       O
     #-
     #-   ------------IE----------------------
     #- 1. SON Configuration Transfer
     #-   >Target eNB-ID                   M
     #-     >>Global eNB ID                M
     #-     >>Selected TAI                 M
     #-   >Souce eNB ID                    M
     #-     >>Global eNB ID                M
     #-     >>Selected TAI                 M
     #-   >SON Information                 M
     #-   >X2 TNL Confiration Info         O
     #-
     #- 2.SON Information
     #- >CHOICE SON Information
     #-   >>SON Information Request
     #-     >>>SON Information Request
     #-   >>SON Information Reply
     #-     >>>SON Information Reply
     #-
     #- 3.SON Inforamtion Reply
     #-   >X2 TNL configuration Info       O
     #-   >Time synchronization Info       O
     #-  ---------------------------------------
     
     global ARR_eNB_CONFIG_TRANSFER
     set msgName "enb_configuration_transfer"
     #set eNBx2addr      "192.168.0.1,192.168.0.2"
     set eNBx2addr      "01010101"
     parseArgs args \
               [list \
               [list operation          optional        "send|(don't|)expect"  "send"                   "send or expect or don't expect option"] \
               [list execute            optional        "boolean"              "yes"                    "To perform the operation or not"] \
               [list HeNBIndex          optional        "numeric"              "__UN_DEFINED__" 	"Index of HeNB whose values need to be retrieved"] \
               [list MMEIndex           optional        "numeric"              "__UN_DEFINED__"	        "Index of MME whose values need to be retrieved"] \
               [list eNBx2addr          optional        "string"               $eNBx2addr               "eNB X2 address" ] \
               [list srcTAI             optional        "string"               "0"                      "Source TAI" ] \
               [list tgtTAI             optional        "string"               "0"                      "Target TAI" ] \
               [list SONInfo            optional        "string"               "x2tnl_configuration_info"       "SON Information IE" ]\
               [list SONconfigTransfer  optional        "boolean"              "yes"                    "To include SON Config Information or not" ] \
               [list SONInfoType        optional        "request|reply"         "request"               "SON Info type is request or reply type" ] \
               [list tgtGlobaleNBId     optional        "string"               "x,home"                 "HeNBIndex, eNBType" ] \
               [list srcGlobaleNBId     optional        "string"               "0,home"         	"HeNBIndex, eNBType" ] \
               [list stratumLevel       optional        "numeric"              "2"                      "Time synchronization information 1" ] \
               [list syncStatus         optional        "string"                "synchronous"           "Time synchronization information 2" ] \
               [list streamId           optional        "numeric"              "__UN_DEFINED__"         "Defines the streamId assigned" ] \
               ]
     
     set msgName $msgName
     set msgType "class2"
     
     switch $operation {
          "send" {
               set simType "HeNB"
               set result [extractMMEIndexInS1FlexForeNBConfigSent -op "snap"]

               set gwIp   [getDataFromConfigFile "henbSignalingIpaddress" 0 ]
               set gwPort [getDataFromConfigFile "henbSctp" 0 ]
               
               set targetGlobaleNBID   [generateIEs -IEType "globaleNBid" -paramIndices $tgtGlobaleNBId ]
               set sourceGlobaleNBID   [generateIEs -IEType "globaleNBid" -paramIndices $srcGlobaleNBId ]
               set targetHeNBIndex [lindex [split $tgtGlobaleNBId ","] 0]
               set sourceHeNBIndex [lindex [split $srcGlobaleNBId ","] 0]
               set tgtTAI [generateIEs -IEType "tgtTai" -paramIndices $tgtTAI -HeNBIndex $targetHeNBIndex]
               set srcTAI [generateIEs -IEType "tgtTai" -paramIndices $srcTAI -HeNBIndex $sourceHeNBIndex]
               
               if {$SONInfoType == "request" } {
                    
                    set SONconfigTransferIE "\{"
                    append SONconfigTransferIE "sONInformation=\{sONInformationRequest=$SONInfo\} "
                    append SONconfigTransferIE "targeteNB_ID=\{global_ENB_ID=$targetGlobaleNBID selected_TAI=$tgtTAI\} "
                    append SONconfigTransferIE "sourceeNB_ID=\{global_ENB_ID=$sourceGlobaleNBID selected_TAI=$srcTAI\}"
                    append SONconfigTransferIE "\}"
                    set HeNBIndex $sourceHeNBIndex
                    set HeNBId     [getFromTestMap -HeNBIndex $sourceHeNBIndex -param "HeNBId"]
                    
                    if {$SONconfigTransfer == "no"} {unset -nocomplain SONconfigTransferIE}
                    print -info "Sending eNB Configuration Transfer message from HeNB $$sourceHeNBIndex"
                    set enbConfigTransfer [updateValAndExecute "constructS1Procedure -simType simType -msgName msgName -msgType msgType -HeNBId HeNBId \
                              -streamId streamId -SONInfo SONconfigTransferIE -gwIp gwIp -gwPort gwPort"]
                    array set ARR_eNB_CONFIG_TRANSFER $enbConfigTransfer
                    
               } elseif {$SONInfoType == "reply" } {
                    #Construct SON configuration transfer IE
                    set SONconfigTransferIE "\{"
                    append SONconfigTransferIE "sONInformation=\{sONInformationReply=\{x2TNLConfigurationInfo="
                    append SONconfigTransferIE "\{eNBX2TransportLayerAddresses=$eNBx2addr\} time_Synchronization_Info_ext=\{stratumLevel=$stratumLevel synchronizationStatus=$syncStatus\}\}\} "
                    append SONconfigTransferIE "targeteNB_ID=\{global_ENB_ID=$targetGlobaleNBID selected_TAI=$tgtTAI\} "
                    append SONconfigTransferIE "sourceeNB_ID=\{global_ENB_ID=$sourceGlobaleNBID selected_TAI=$srcTAI\}"
                    append SONconfigTransferIE "\}"
                    set HeNBIndex $sourceHeNBIndex
                    set HeNBId     [getFromTestMap -HeNBIndex $sourceHeNBIndex -param "HeNBId"]
                    
                    if {$SONconfigTransfer == "no"} {unset -nocomplain SONconfigTransferIE}
                    print -info "Sending eNB Configuration Transfer message from HeNB $targetHeNBIndex"
                    set enbConfigTransfer [updateValAndExecute "constructS1Procedure -simType simType -msgName msgName -msgType msgType -HeNBId HeNBId \
                              -streamId streamId -SONInfo SONconfigTransferIE -gwIp gwIp -gwPort gwPort"]
                    array set ARR_eNB_CONFIG_TRANSFER $enbConfigTransfer
                    
               }
               
               if {$execute == "no"} { return "$simType $enbConfigTransfer"}
               return [updateValAndExecute "sendOrVerifyS1APProcedure -msgName msgName -msgType msgType -operation operation -msgList enbConfigTransfer \
                         -simType simType -HeNBIndex HeNBIndex"]
               
          }
          
          "expect" {
               set simType "MME"
               print -info "Expect eNB Configuration Transfer message from HeNB $HeNBIndex on MME "
               if {![info exists MMEIndex]} {
                    if {[findNumOfMMEs] > 1} {
                         set tai [generateIEs -IEType "TAI" -paramIndices "0,0" -HeNBIndex $HeNBIndex]
                         set result [mmeAccessList -HeNBIndex $HeNBIndex -tai $tai]
                         
                         set MultiS1Link $::ARR_LTE_TEST_PARAMS(MultiS1Link)
                         print -info "More than one instance of MME found.."
                         print -info "Finding the MME index from debug door on which eNBConfigTransfer message is sent"
                         if {$MultiS1Link != "yes"} {
                           set MMEIndex [expr [extractMMEIndexInS1Flex -op "extract" -HeNBIndex $HeNBIndex] -1]
                         } else {
                           set MMEIndex [extractMMEIndexInS1Flex -op "extract" -HeNBIndex $HeNBIndex]
                         }

                         if {[llength $MMEIndex] > 1 || $MMEIndex < 0} {
                              print -fail "MMEIndex extraction failed, got $MMEIndex"
                              return -1
                         } else {
                              print -info "Extracted MMEIndex from debug door is $MMEIndex ..... "
                              print -info "Updating MMEIndex $MMEIndex in test map array"
                              #Updating MMEIndex in global array
                              if {$MultiS1Link != "yes"} {
                                 set paramList [list [list "MMEIndex" $MMEIndex]]
                              } else {
                                 set paramList [list [list "MMEIndex" $::ARR_LTE_TEST_PARAMS_MAP(MOID,$MMEIndex,MMEIndex)]]
                                 set tmpMMEIndex $::ARR_LTE_TEST_PARAMS_MAP(MOID,$MMEIndex,MMEIndex)
                                 set subR $::ARR_LTE_TEST_PARAMS_MAP(MOID,$MMEIndex,SubReg)
                                 set RegionNo $::ARR_LTE_TEST_PARAMS_MAP(SubReg,$subR,Region)
                                 set enbId [list [list "eNBId" $::ARR_LTE_TEST_PARAMS_MAP(R,$RegionNo,SubR,$subR,eNBId)]]
                                 updateLteParamData -HeNBIndex $HeNBIndex -UEIndex $UEIndex -paramList $enbId
                              }
                              updateLteParamData -HeNBIndex $HeNBIndex -UEIndex $UEIndex -paramList $paramList
                         }

                    } else {
                         print -info "USE default MMEIndex as 0"
                         set MMEIndex 0
                    }
               } else {
                    print -info "Using the MME index passed from script $MMEIndex"
               }

               set enbConfigTransfer [array get ARR_eNB_CONFIG_TRANSFER]
               
          }
          
          "don'texpect" {
               set simType "MME"
               
               set enbConfigTransfer [list $msgName ""]
               return [updateValAndExecute "sendOrVerifyS1APProcedure -msgName msgName -msgType msgType -operation operation -msgList enbConfigTransfer \
                         -simType simType -HeNBIndex HeNBIndex -MMEIndex MMEIndex"]
               
          }
     }
     
     if {$execute == "no"} { return "$simType $enbConfigTransfer"}
     return [updateValAndExecute "sendOrVerifyS1APProcedure -msgName msgName -msgType msgType -operation operation -msgList enbConfigTransfer \
               -simType simType -HeNBIndex HeNBIndex -MMEIndex MMEIndex -enbID enbId"]
     
     return 0
     
}

proc mmeStatusTransfer { args } {
     
     #global ARR_LTE_TEST_PARAMS_MAP
     #set ::ARR_LTE_TEST_PARAMS_MAP(H,0,U,0,vENBUES1APId) "123456"
     #set ::ARR_LTE_TEST_PARAMS_MAP(H,0,U,0,mmeUEId)   "232323"
     
     set validS1Msg     "mmeStatusTransfer"
     set msgType        "class2"
     
     parseArgs args \
               [list \
               [list msg                  optional   "$validS1Msg"          "enbStatusTransfer"    "The message to be sent" ] \
               [list operation            optional   "send|(don't|)expect"  "send"                 "send or expect option" ] \
               [list execute              optional   "boolean"              "yes"                  "To perform the operation or not. if no, will return the message"] \
               [list streamId             optional   "numeric"              "__UN_DEFINED__"       "Defines the streamId assigned" ]\
               [list HeNBIndex            mandatory  "numeric"              ""                     "Index of HeNB whose values need to be retrieved" ] \
               [list UEIndex              mandatory  "numeric"              ""                     "Index of UE whose values need to be retrieved" ] \
               [list MMEIndex             optional   "numeric"              "0"                    "Index of MME whose values need to be retrieved" ] \
               [list eNBUES1APId          optional   "string"               "__UN_DEFINED__"       "eNB UE S1AP Id value" ] \
               [list MMEUES1APId          optional   "string"               "__UN_DEFINED__"       "MME UE S1AP Id value" ] \
               [list eNBStusTsfrCntier    optional   "string"               "1,1,1,1,1,1"          "PDCP Sequence Number value" ] \
               [list missManIe            optional   "string"               "__UN_DEFINED__"       "Mandatory IE that needs to missed" ] \
               ]
     
     set msgName [string map "mmestatustransfer mme_status_transfer" [ string tolower $msg ] ]
     if {$operation == "send"} { set simType "MME"  } else {  set simType "HeNB"  }
     set mandatoryIEs "MMEUES1APId eNBUES1APId eNBStusTsfrCntier"
     set eNBStusTsfrCntier [generateIEs -IEType "ENBStatusTransfer" -paramIndices $eNBStusTsfrCntier -HeNBIndex $HeNBIndex -MMEIndex $MMEIndex]

     if {$operation == "send"} {
          set simType "MME"
          set paramList [list vENBUES1APId MMEUES1APId streamId mmeUEId]
          set dynEleList [list eNBUES1APId MMEUES1APId streamId ueid]
          set MMEId  [getFromTestMap -MMEIndex $MMEIndex -param "MMEId"]
          
          set MultiS1Link $::ARR_LTE_TEST_PARAMS(MultiS1Link)
          if {$MultiS1Link == "yes"} {
             set enbID [getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "eNBId"]
             if {$simType == "MME"} {
                set eNBType [getFromTestMap -HeNBIndex $HeNBIndex -param "eNBType"]
                if {! [ info exists eNBType ]} {
                   set eNBType "macro"
                }
                if {[info exists enbID]} {
                   set globaleNBId "\{${eNBType}ENB_ID=$enbID\}"
                }
             }
          }

     } else {
          set simType "HeNB"
          set paramList  [list eNBUES1APId vENBUES1APId streamId ueid]
          set dynEleList [list eNBUES1APId MMEUES1APId streamId ueid]
          set HeNBId     [getFromTestMap -HeNBIndex $HeNBIndex -param "HeNBId"]
     }
     
     foreach dynElement $dynEleList param $paramList {
          if {![info exists $dynElement]} {
               if {$param == "streamId"} {
                    set streamId [expr $UEIndex + 1]
                    continue
               }
               if {[catch {set $dynElement [getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "$param"]}]} {
                    print -abort "Failed to get the param $param"
                    return 1
               }
          }
     }
     
     if { [ info exists missManIe ] } { foreach mandIE [ split $missManIe ,] { unset $mandIE } }
     print -info "msgName ---> $msgName" ;
     set mmeStatusTransferMsg [updateValAndExecute "constructS1Procedure -simType simType -msgName msgName -msgType msgType \
               -HeNBId HeNBId -MMEId MMEId -eNBUES1APId eNBUES1APId -MMEUES1APId MMEUES1APId  -eNBStusTsfrCntier eNBStusTsfrCntier \
               -streamId streamId -globaleNBId globaleNBId"]
     
     print -info "mmeStatusTransferMsg $mmeStatusTransferMsg" ;
     if {$execute == "no"} { return "$simType $handoverMsg"}
     
     return [updateValAndExecute "sendOrVerifyS1APProcedure -msgName msgName -msgType msgType \
               -operation operation -msgList mmeStatusTransferMsg -simType simType \
               -HeNBIndex HeNBIndex -MMEIndex MMEIndex"]
}
proc mmeConfigTransfer { args } {
     
     #Proc to perform MME configuration transfer sequence
     #tgtGlobaleNBId "0,home"  : target global eNBId is a valid type and is a home type
     #               "x,macro" : target global eNBId is invalid and macro type
     #srcGloabaleNBId "home"   : source global eNBId is home type
     #                "macro"  : source global eNBId is macro type
     #tgtTAI format:  -tgtTAI "0,1" (TAC matching     with HeNB info,PLMN index within HeNB broadcast list)
     #-               -tgtTAI "x,x" (TAC not matching with HeNB info,PLMN not   within HeNB broadcast list)
     #When the source is random-
     #                 Send srcHeNBIndex "x"   (This will take random values for source eNBId and TAI)
     #                 Send srcTAI       "x,x" (Or you maynot pass anything)
     #When the source is from a known HeNB-
     #                 Send srcHeNBIndex $HeNBIndex (The HeNBIndex of the source HeNB)
     #                 Send srcTAI       "0,0"      (It will take the TAI value for the HeNBIndex you specify in srcHeNBIndex)
     #
     #
     global ARR_MME_CONFG_TRANSFER
     set validS1Msg     "mmeConfigTransfer"
     set msgType        "class2"
     #set eNBx2addr      "192.168.0.1,192.168.0.2"
     set eNBx2addr      "01010101"
     set gtptlas        "10.3.100.2,10.3.100.4"
     set iptla1         10.3.100.1
     set iptla2         10.3.100.5
     parseArgs args \
               [list \
               [list msg                  optional   "$validS1Msg"          "mmeConfigTransfer"    "The message to be sent" ] \
               [list operation            optional   "send|(don't|)expect"  "send"                 "send or expect option" ] \
               [list execute              optional   "boolean"              "yes"                  "To perform the operation or not. if no, will return the message"] \
               [list streamId             optional   "numeric"              "0"                    "Defines the streamId assigned" ] \
               [list eNBx2addr            optional   "string"               $eNBx2addr             "eNB X2 address" ] \
               [list gtptlas              optional   "string"               $gtptlas               "gtptlas" ] \
               [list iptla1               optional   "string"               $iptla1                "ipsectla" ] \
               [list iptla2               optional   "string"               $iptla2                "ipsectla" ] \
               [list HeNBIndex            optional   "numeric"              "0"                    "Index of HeNB where the message is to be sent" ] \
               [list MMEIndex             optional   "numeric"              "0"                    "Index of MME from where the message is to be sent" ] \
               [list SONInfo              optional   "string"               "x2tnl_configuration_info"       "SON Information IE" ] \
               [list SONinfoReply         optional   "string"               ""                     "SON info reply" ] \
               [list SONcnfgTrnsfr        mandatory  "string"               "1"                    "SON Configuration Transfer IE" ] \
               [list eNBtypa              optional   "home|macro"           "home"                 "Whether the target eNB is home or macro type" ] \
               [list tgtGlobaleNBId       optional   "string"               "0,home"               "Target global eNB Id" ] \
               [list tgtTAI               optional   "string"               "0,0"                  "Target selected TAI" ] \
               [list srcGlobaleNBId       optional   "string"               "x,home"               "Source global eNB Id" ] \
               [list srcTAI               optional   "string"               "x,x"                  "Source selected TAI" ] \
               [list x2tnlconfig          optional   "numeric"              "__UN_DEFINED__"        "x2tnlconfig" ] \
               [list stratumlevel         optional   "numeric"             "2"                     "stratum level value" ] \
               [list eNBX2addresses       optional   "string"               $eNBx2addr 		   "eNBX2addresses" ] \
               [list synchronizationstatus optional  "string"               "synchronous"            "synchronizationstatus" ] \
               ]
     set msgName "mme_config_transfer"
     
     set mandatoryIEs "SONInfo"
     set HeNBIndex      [lindex [split $tgtGlobaleNBId ","] 0]
     set MultiS1Link $::ARR_LTE_TEST_PARAMS(MultiS1Link)
     if {$operation == "send"} {
          set simType "MME"
          set MMEId  [getFromTestMap -MMEIndex $MMEIndex -param "MMEId"]
          set gwIp   [getDataFromConfigFile "mmeSignalingIpaddress" 0 ]
          set gwPort [getDataFromConfigFile "henbSctp" 0 ]
          ## In S1Flex scenario ###
          ## Finding MME index from debug door, if GUMMEI and sTMSI are not used in initialUE send
          if {![info exists MMEIndex]} {
               if {[findNumOfMMEs] > 1} {
                   
                    set MultiS1Link $::ARR_LTE_TEST_PARAMS(MultiS1Link) 
                    print -info "More than one instance of MME found.."
                    print -info "Finding the MME index from debug door on which initialUE message is sent"
                    if {$MultiS1Link != "yes"} {
                           set MMEIndex [expr [extractMMEIndexInS1Flex -op "extract" -HeNBIndex $HeNBIndex] -1]
                         } else {
                           set MMEIndex [extractMMEIndexInS1Flex -op "extract" -HeNBIndex $HeNBIndex]
                         }


                         if {[llength $MMEIndex] > 1 || $MMEIndex < 0} {
                              print -fail "MMEIndex extraction failed, got $MMEIndex"
                              return -1
                         } else {
                              print -info "Extracted MMEIndex from debug door is $MMEIndex ..... "
                              print -info "Updating MMEIndex $MMEIndex in test map array"
                              #Updating MMEIndex in global array
                              if {$MultiS1Link != "yes"} {
                                 set paramList [list [list "MMEIndex" $MMEIndex]]
                              } else {
                                 set paramList [list [list "MMEIndex" $::ARR_LTE_TEST_PARAMS_MAP(MOID,$MMEIndex,MMEIndex)]]
                                 set tmpMMEIndex $::ARR_LTE_TEST_PARAMS_MAP(MOID,$MMEIndex,MMEIndex)
                                 set subR $::ARR_LTE_TEST_PARAMS_MAP(MOID,$MMEIndex,SubReg)
                                 set RegionNo $::ARR_LTE_TEST_PARAMS_MAP(SubReg,$subR,Region)
                                 set enbId [list [list "eNBId" $::ARR_LTE_TEST_PARAMS_MAP(R,$RegionNo,SubR,$subR,eNBId)]]
                                 updateLteParamData -HeNBIndex $HeNBIndex -UEIndex $UEIndex -paramList $enbId
                              }
                              updateLteParamData -HeNBIndex $HeNBIndex -UEIndex $UEIndex -paramList $paramList
                         }
               }
          } else {
               print -info "Using the MME index passed from script $MMEIndex"
          }
     } else {
          set simType "HeNB"
          set HeNBId     [getFromTestMap -HeNBIndex $HeNBIndex -param "HeNBId"]
     }

     if {$MultiS1Link == "yes"} {
       set eNBType [getFromTestMap -HeNBIndex $HeNBIndex -param "eNBType"]
       if {$simType == "MME"} {
          if {[info exists enbId]} {
              set globaleNBId "\{${eNBType}ENB_ID=$enbId\}"
          }
       }
     }
     set srcHeNBIndex   [lindex [split $srcGlobaleNBId ","] 0]
     set tgtGlobaleNBId [generateIEs -IEType "globaleNBid" -paramIndices $tgtGlobaleNBId -HeNBIndex $HeNBIndex]
     set srcGlobaleNBId [generateIEs -IEType "globaleNBid" -paramIndices $srcGlobaleNBId -HeNBIndex $HeNBIndex]


     if {![regexp "y" $tgtTAI]} {
          set tgtTAI         [generateIEs -IEType "TAI" -paramIndices $tgtTAI -HeNBIndex $HeNBIndex]
     }
     #srcTAI
     if {$srcHeNBIndex == "x"} {
          set srcTAI         [generateIEs -IEType "TAI" -paramIndices $srcTAI -HeNBIndex 0]
     } else {
          set srcTAI         [generateIEs -IEType "TAI" -paramIndices $srcTAI -HeNBIndex $srcHeNBIndex]
     }


     set tac [lindex [split [lindex [split [lindex [split $srcTAI " "] 2] "="] 1] "\}"] 0]
     set mcc [lindex [split [lindex [split $srcGlobaleNBId " "] 0] "="] 1]
     set mnc [lindex [split [lindex [split $srcGlobaleNBId " "] 1] "="] 1]
     
     #if {$srcHeNBIndex == "x"} {
          #set srcTAI [concat "mcc=$mcc" "mnc=$mnc" "tac=$tac"]
          #set srcTAI [list $srcTAI]
          #set srcTAI "\{pLMNidentity=\{MCC=$mcc MNC=$mnc\} tAC=$tac\}"
     #}

     #NOTE: Below lines are commented to avoid mismatch in tac value.  But need to check why below logic is needed. 
     #When eNB config transfer is sent with tgtTAI "x" the tgtTAI value has to be updated while sending mme config transfer
     #if {[regexp "y" $tgtTAI]} {
     #     set henbindex [lindex [split $tgtTAI ","] 1]
     #     if {$henbindex == ""} {
     #        set henbindex 0
     #     }
     #     set tac [getSetArrayTestParam -HeNBIndex $henbindex -param "TAC" -operation "read"]
     #     set mcc [getSetArrayTestParam -HeNBIndex $henbindex -param "MCC" -operation "read"]
     #     set mnc [getSetArrayTestParam -HeNBIndex $henbindex -param "MNC" -operation "read"]
     #
     #     set tgtTAI  "\{pLMNidentity=\{MCC=$mcc MNC=$mnc\} tAC=$tac\}"
     #}

     #Constructing the SON configuration transfer IE
     set enbid "enbid"
     if {$SONcnfgTrnsfr != ""} {
          set SONcnfgTrnsfr "{"
               if {[info exists SONInfo]} {
                    append SONcnfgTrnsfr "sONInformation=\{sONInformationRequest=$SONInfo\} "
               }
               
               if {[info exists tgtGlobaleNBId] && [info exists tgtTAI]} {
                    set tgtENB "targeteNB_ID="
                    append tgtENB "{global_ENB_ID=$tgtGlobaleNBId "
                         append tgtENB "selected_TAI=$tgtTAI}"
               }
               append SONcnfgTrnsfr "$tgtENB "
               if {[info exists srcGlobaleNBId] && [info exists srcTAI]} {
                    set srcENB "sourceeNB_ID="
                    append srcENB "{global_ENB_ID=$srcGlobaleNBId "
                         append srcENB "selected_TAI=$srcTAI}"
               }
               append SONcnfgTrnsfr "$srcENB "
               if {[info exists x2tnlconfig]} {
                    set x2tnl "x2TNLConfigurationInfo_ext="
                    append x2tnl "{eNBX2TransportLayerAddresses=$eNBx2addr eNBX2ExtendedTransportLayerAddresses_ext={iPsecTLA=$iptla1 gTPTLAa=$gtptlas},{iPsecTLA=$iptla2}}"
                    append SONcnfgTrnsfr "$x2tnl"
               }
               append SONcnfgTrnsfr "}"
     }
     
     #Constructing the SON Info Reply
     if {$SONinfoReply != ""} {
          unset -nocomplain $SONcnfgTrnsfr
          set enbid "enbid"
          set SONcnfgTrnsfr "{"
               append SONcnfgTrnsfr "sONInformation=\{sONInformationReply=\{x2TNLConfigurationInfo="
               append SONcnfgTrnsfr "\{eNBX2TransportLayerAddresses=$eNBX2addresses\} time_Synchronization_Info_ext=\{stratumLevel=$stratumlevel synchronizationStatus=$synchronizationstatus\}\}\} "

               if {[info exists tgtGlobaleNBId] && [info exists tgtTAI]} {
                    set tgtENB "targeteNB_ID="
                    append tgtENB "{global_ENB_ID=$tgtGlobaleNBId "
                    append tgtENB "selected_TAI=$tgtTAI}"

               }
               append SONcnfgTrnsfr "$tgtENB "
               if {[info exists srcGlobaleNBId] && [info exists srcTAI]} {
                    set srcENB "sourceeNB_ID="
                    append srcENB "{global_ENB_ID=$srcGlobaleNBId "
                    append srcENB "selected_TAI=$srcTAI}"
               }
               append SONcnfgTrnsfr "$srcENB "
               append SONcnfgTrnsfr "}"
     }
     #If the SON configuration transfer IE is not to be sent
     if {[info exists SONcnfgTrnsfr]} {
          if {[set SONcnfgTrnsfr] == ""} {unset -nocomplain SONcnfgTrnsfr}
     }
     
     if {$operation == "send"} {
          print -info "Sending MME Configuration Transfer message from MME $MMEIndex"
          set mmeConfigTransfer [updateValAndExecute "constructS1Procedure -simType simType -msgName msgName -MMEId MMEId -msgType msgType \
                    -streamId streamId -SONInfo SONcnfgTrnsfr -SONInfoReply SONinfoReply -gwIp gwIp -gwPort gwPort -globaleNBId globaleNBId"]
          array set ARR_MME_CONFG_TRANSFER $mmeConfigTransfer
     } elseif {$operation == "expect" } {
          print -info "Expecting MME Configuration Transfer message from MME $MMEIndex at HeNBIndex $HeNBIndex"
          set mmeConfigTransfer [array get ARR_MME_CONFG_TRANSFER]
          if {![array exists ARR_MME_CONFG_TRANSFER]} {
               set mmeConfigTransfer [updateValAndExecute "constructS1Procedure -simType simType -msgName msgName -msgType msgType \
                         -streamId streamId -SONInfo SONcnfgTrnsfr -SONInfoReply SONinfoReply"]
          }
          
     } elseif {$operation == "don'texpect" } {
          set simType "HeNB"
          set mmeConfigTransfer [list $msgName ""]
          return [updateValAndExecute "sendOrVerifyS1APProcedure -msgName msgName -msgType msgType -operation operation -msgList mmeConfigTransfer \
                    -simType simType -HeNBIndex HeNBIndex -MMEIndex MMEIndex"]
     }
     if {$execute == "no"} { return "$simType $mmeConfigTransfer" }
     return [updateValAndExecute "sendOrVerifyS1APProcedure -msgName msg -msgType msgType -operation operation -msgList mmeConfigTransfer \
               -simType simType -HeNBIndex HeNBIndex -MMEIndex MMEIndex"]
     
     return 0
}

proc mmeOverloadStart { args } {
     
     #Proc to perform MME Overload tion transfer sequence
     #overloadresponce "send"   : The Overload Response IE indicates the required behaviour(Overload Action) of the eNB
     #                            in an overload situation .The Overload Action IE indicates which signalling traffic is subject
     #                            to rejection by the eNB in an MME overload situation.
     #GUMMEI           "string" : GUMMEI from UE of format gummeiInd,plmnInd,mmecInd,mmegiInd
     #traficLoadReductionIndication "0"  :(1-99 percentage of the type of traffic to be rejected)
     #
     #
     global ARR_MME_OVERLOAD_START
     set validS1Msg     "overloadstart"
     set msgType        "class2"
     parseArgs args \
               [list \
               [list msg               optional   "$validS1Msg"         "overloadstart" "The message to be sent" ] \
               [list operation         optional   "send|(don't|)expect" "send"              "send or expect option" ] \
               [list HeNBIndex         optional   "numeric"             "0"                 "Index of HeNB where the message is to be sent" ] \
               [list MMEIndex          optional   "numeric"             "0"                 "Index of MME from where the message is to be sent" ] \
               [list streamId          optional   "numeric"             "0"                 "Defines the streamId assigned" ] \
               [list overloadAction    optional   "string"         "__UN_DEFINED__" "which kind of signalling traffic to be rejection" ] \
               [list GUMMEIIndex       optional   "string"              "all"               "Index of GUMMEI"] \
               [list trafficLoadReductionIndication  optional "numeric"  "__UN_DEFINED__"   "1-99 percentage of the type of traffic to be rejected" ] \
               [list execute              optional   "boolean"              "yes"                  "To perform the operation or not. if no, will return the message"] \
               ]
     
     set msgName "overload_start"
     
     if {$operation == "send"} {
          set simType "MME"
          set gwIp   [getDataFromConfigFile "mmeSignalingIpaddress" 0 ]
          set gwPort [getDataFromConfigFile "henbSctp" 0 ]
          set MMEId  [getFromTestMap -MMEIndex $MMEIndex -param "MMEId"]
     } else {
          set simType "HeNB"
          set henbId     [getFromTestMap -HeNBIndex $HeNBIndex -param "HeNBId"]
     }
     
     if {$operation == "send"} {
          if {[info exists GUMMEIIndex]} {
               set GUMMEI [getServedGUMMEIList -MMEIndex $MMEIndex -GUMMEIIndex $GUMMEIIndex]
          }
          print -info "Sending MME Overload Start message from MME $MMEIndex"
     } else {
          set GUMMEIIndex "all"
          set GUMMEI [getServedGUMMEIList -MMEIndex $MMEIndex -GUMMEIIndex $GUMMEIIndex]
          print -info "Expecting MME Overload Start message from MME $MMEIndex at HeNBIndex $HeNBIndex"
          if {![info exists overloadAction]} {
               set overloadAction "reject_non_emergency_mo_dt"
          }
     }

     # replace servedGroupIDs with mME_Group_ID 
     #         servedMMECs    with mME_Code
     #         servedPLMNs    with pLMN_Identity
     regsub -all "servedGroupIDs" $GUMMEI "mME_Group_ID" GUMMEI
     regsub -all "servedMMECs" $GUMMEI "mME_Code" GUMMEI
     regsub -all "servedPLMNs" $GUMMEI "pLMN_Identity" GUMMEI

     if {[info exists overloadAction]} {
        set overloadAction "\{overloadAction=$overloadAction\}" 
     }
     
     set overloadstart [updateValAndExecute "constructS1Procedure -simType simType -msgName msgName -MMEId MMEId -msgType msgType -streamId streamId\
               -overloadAction overloadAction -GUMMEI GUMMEI -trafficLoadReductionIndication trafficLoadReductionIndication -HeNBIndex HeNBIndex\
               -gwIp gwIp -gwPort gwPort"]
     
     return [updateValAndExecute "sendOrVerifyS1APProcedure -msgName msg -msgType msgType -operation operation -msgList overloadstart \
               -simType simType -HeNBIndex HeNBIndex -MMEIndex MMEIndex -henbId henbId"]
     
}

proc mmeOverloadStop { args } {
     
     #Proc to send MME Overload Stop message to indicate that the MME is no longer overloaded.
     #GUMMEI           "string" : GUMMEI from UE of format gummeiInd,plmnInd,mmecInd,mmegiInd
     #
     #
     global ARR_MME_OVERLOAD_START
     set validS1Msg     "overloadstop"
     set msgType        "class2"
     parseArgs args \
               [list \
               [list msg            optional  "$validS1Msg"          "overloadstop"      "The message to be sent" ] \
               [list operation      optional   "send|(don't|)expect" "send"              "send or expect option" ] \
               [list streamId       optional   "numeric"             "0"                 "Defines the streamId assigned" ] \
               [list GUMMEIIndex    optional   "string"              "__UN_DEFINED__"    "Index of GUMMEI"] \
               [list HeNBIndex      optional   "numeric"             "0"                 "Index of HeNB where the message is to be sent" ] \
               [list MMEIndex       optional   "numeric"             "0"                 "Index of MME from where the message is to be sent" ] \
               [list execute        optional   "boolean"              "yes"              "To perform the operation or not. if no, will return the message"]\
               ]
     set msgName "overload_stop"
     
     if {$operation == "send"} {
          set simType "MME"
          set gwIp   [getDataFromConfigFile "mmeSignalingIpaddress" 0 ]
          set gwPort [getDataFromConfigFile "henbSctp" 0 ]
          set MMEId  [getFromTestMap -MMEIndex $MMEIndex -param "MMEId"]
     } else {
          set simType "HeNB"
          set henbId     [getFromTestMap -HeNBIndex $HeNBIndex -param "HeNBId"]
     }
     
     if {[info exists GUMMEIIndex]} {
          set GUMMEI $GUMMEIIndex
     } else {
          set GUMMEIIndex "all"
          set GUMMEI [generateIEs -IEType "GUMMEI" -paramIndices "0,0,0,0" -HeNBIndex $HeNBIndex -MMEIndex $MMEIndex]
          print -info "Expecting MME Overload Start message from MME $MMEIndex at HeNBIndex $HeNBIndex"
     }
     if {$operation == "send"} {
          print -info "Sending MME Overload Stop message from MME $MMEIndex"
     } else {
          print -info "Expecting MME Overload Stop message from MME $MMEIndex at HeNBIndex $HeNBIndex"
     }
     
     set overloadstop [updateValAndExecute "constructS1Procedure -simType simType -msgName msgName -msgType msgType -GUMMEI GUMMEI\
               -streamId streamId -MMEId MMEId -HeNBIndex HeNBIndex -gwIp gwIp -gwPort gwPort"]
     
     return [updateValAndExecute "sendOrVerifyS1APProcedure -msgName msg -msgType msgType -operation operation -msgList overloadstop \
               -simType simType -HeNBIndex HeNBIndex -MMEIndex MMEIndex"]
     
}

proc writeReplaceWarning {args} {
     #-
     #- The purpose of the write Replace Warning procedure is to indicate HeNB/eNBs to start/overwrite broadcasting warning messages
     #-
     #-         Message Type    M
     #-         Message Identifier      M
     #-         Serial Number   M
     #-         Warning Area List       O
     #-         Repetition Period       M
     #-         Extended Repetition Period      O
     #-         Number of Broadcasts Requested  M
     #-         Warning Type    O
     #-         Warning Security Information    O
     #-         Data Coding Scheme      O
     #-         Warning Message Contents        O
     #-         Concurrent Warning Message Indicator    O
     #-
     #- warnAreaList/bcCompAreaList contains warningAreaChoice i.e eCGI or TAI or emergency & list of Henb indexes, to which message is to be sent
     #-              eg:- 1. "eCGI 0 1 2"
     #-              eg:- 2. "eCGI 0 1 2 x"
     #-              eg:- 3. "TAI 0 1 2"
     #-              eg:- 4. "emergency 0 1 2"
     
     global ARR_WR_REP
     set validMsg     "request|response"
     set defMsgId     [randomDataString 16 allDigits]
     set defSerialNum [randomDataString 16 allDigits]
     set defRepPeriod [random 4095]
     set defNumOfBc   [random 65535]
     set msgType      "class2"
     
     set defMsgId     1000
     set defSerialNum 1
     set defRepPeriod 360
     set defNumOfBc   5
     
     parseArgs args \
               [list \
               [list msg                  optional   "$validMsg"            "request"       "The message to be sent" ] \
               [list operation            optional   "send|(don't|)expect"  "send"          "send or expect option"] \
               [list execute              optional   "boolean"              "yes"           "To perform the operation or no
     t"] \
               [list HeNBIndex            optional   "numeric"               ""              "List of HeNB Indices to whichmsg needs to be sent" ] \
               [list MMEIndex             optional   "numeric"              "0"             "Index of MME from which msg has to be sent" ] \
               [list msgId                optional   "numeric"              "$defMsgId"     "Identifies Msg Identifier of msg" ] \
               [list serialNum            optional   "numeric"              "$defSerialNum" "Identifies serial number of Msg" ] \
               [list warnAreaList         optional   "string"               "__UN_DEFINED__" "Identifies the warningAreaList i.e CellId List/taiList/emergencyAreaList"] \
               [list bcCompAreaList       optional   "string"               "__UN_DEFINED__" "Identifies the broadcast Complete Area List i.e CellId List/taiList/emergencyAreaList"] \
               [list repPeriod            optional   "numeric"              "$defRepPeriod"  "Identifies repetition period (in secs) of msg" ] \
               [list extRepPeriod         optional   "numeric"              "__UN_DEFINED__" "Identifies extension repetition period of msg" ] \
               [list numOfBc              optional   "numeric"              "$defNumOfBc"    "Identifies number of broadcasts of msg" ] \
               [list warnType             optional   "string"               "__UN_DEFINED__" "Identifies warning type in the msg" ] \
               [list warnSecInfo          optional   "string"               "__UN_DEFINED__" "Identifies warning security information in the msg" ] \
               [list dataCodeScheme       optional   "string"               "__UN_DEFINED__" "Identifies data coding scheme in the msg" ] \
               [list warnMsgCont          optional   "string"               "__UN_DEFINED__" "Identifies warning msg content" ] \
               [list concurWarnMsgInd     optional   "string"               "__UN_DEFINED__" "Identifies cocurrent warning msg indicator" ] \
               ]
     
     set msgName [string map "\
               request  write-replace_warning_request \
               response write-replace_warning_response" $msg]
     
     switch -regexp $msg {
          "request"  {
               set mandatoryIEs "msgId serialNum repPeriod numOfBc"
               if {$operation == "expect"} {
                    unset -nocomplain warnAreaList
                    if {[info exists concurWarnMsgInd]} {
                         #set concurWarnMsgInd "TRUE_"
                         set concurWarnMsgInd "TRUE"
                    }
               }
               #Constructing warning area list when user has defined this variable
               if {[info exists warnAreaList]} {
                    set warnAreaChoice [lindex $warnAreaList 0]
                    set henbIndices [lrange $warnAreaList 1 end]
                    set warnAreaList ""
                    for {set i 0} {$i < [llength $henbIndices]} {incr i} {
                         set henbInd [lindex $henbIndices $i]
                         if {[regexp {\d+} $henbInd]} {
                              set paramIndices "0,0"
                         } else {
                              set paramIndices "0,x"
                              #HeNBINdex passed to generateIEs, can't be non-numeric
                              set henbInd 0
                         }
                         switch $warnAreaChoice {
                              "eCGI" {
                                   lappend warnAreaList "[generateIEs -IEType eCGI -paramIndices $paramIndices -HeNBIndex $henbInd -MMEIndex $MMEIndex]"
                                   if {$i == [expr [llength $henbIndices] -1]} {set warnAreaList "{cellIDList=[join $warnAreaList ","]}"}
                              }
                              "tai" {
                                   lappend warnAreaList "[generateIEs -IEType TAI -paramIndices $paramIndices -HeNBIndex $henbInd -MMEIndex $MMEIndex]"
                                   if {$i == [expr [llength $henbIndices] -1]} {set warnAreaList "{trackingAreaListforWarning=[join $warnAreaList ","]}"}
                                   
                              }
                              "emergency" {
                                   lappend warnAreaList "[random 65536]"
                                   if {$i == [expr [llength $henbIndices] -1]} {set warnAreaList "{emergencyAreaID_Broadcast=[join $warnAreaList ","]}"}
                              }
                         }
                    }
               }
               if {$operation == "send"} {
                    set simType "MME"
                    set MMEId  [getFromTestMap -MMEIndex $MMEIndex -param "MMEId"]
                    set gwIp   [getDataFromConfigFile "mmeSignalingIpaddress" 0 ]
                    set gwPort [getDataFromConfigFile "henbSctp" 0 ]
               } else {
                    set simType "HeNB"
                    set HeNBId [getFromTestMap -HeNBIndex $HeNBIndex -param "HeNBId"]
               }
          }
          "response" {
               set mandatoryIEs "msgId serialNum"
               #Constructing bc Complete area list when user has defined this variable
               if {$operation == "expect"} {
                    set mcc [lindex [getFromTestMap -MMEIndex $MMEIndex -param "MCC"] 0]
                    set mnc [lindex [getFromTestMap -MMEIndex $MMEIndex -param "MNC"] 0]
                    set bcCompAreaList "{cellID_Broadcast={eCGI={pLMNidentity={MCC=$mcc MNC=$mnc} cell_ID=[getCGIdFromeNBId [getLTEParam globaleNBId] 0]}}}"
                    
               } else {
                    if {[info exists bcCompAreaList]} {
                         set choice [lindex $bcCompAreaList 0]
                         set henbIndices [lrange $bcCompAreaList 1 end]
                         set bcCompAreaList ""
                         for {set i 0} {$i < [llength $henbIndices]} {incr i} {
                              set henbInd [lindex $henbIndices $i]
                              if {[regexp {\d+} $henbInd]} {
                                   set paramIndices "0,0"
                              } else {
                                   set paramIndices "0,x"
                                   #HeNBINdex passed to generateIEs, can't be non-numeric
                                   set henbInd 0
                              }
                              switch $choice {
                                   "eCGI" {
                                        lappend bcCompAreaList "{eCGI=[generateIEs -IEType eCGI -paramIndices $paramIndices -HeNBIndex $henbInd -MMEIndex $MMEIndex]}"
                                        if {$i == [expr [llength $henbIndices] -1]} {set bcCompAreaList "{cellID_Broadcast=[join $bcCompAreaList ","]}"}
                                        
                                   }
                                   "tai" {
                                        set cellList "tAI=[generateIEs -IEType TAI -paramIndices $paramIndices -HeNBIndex $henbInd -MMEIndex $MMEIndex]"
                                        set ecgiList " eCGI=[generateIEs -IEType eCGI -paramIndices $paramIndices -HeNBIndex $henbInd -MMEIndex $MMEIndex]"
                                        lappend bcCompAreaList "{completedCellinTAI={$ecgiList} $cellList}"
                                        if {$i == [expr [llength $henbIndices] -1]} {set bcCompAreaList "{tAI_Broadcast=[join $bcCompAreaList ","]}"}
                                   }
                                   "emergency" {
                                        set cellList "emergencyAreaID=[random 65536]"
                                        append cellList " {eCGI=[generateIEs -IEType eCGI -paramIndices $paramIndices -HeNBIndex $henbInd -MMEIndex $MMEIndex]}"
                                        lappend bcCompAreaList "{completedCellinTAI={$cellList}}"
                                        if {$i == [expr [llength $henbIndices] -1]} {set bcCompAreaList "{emergencyAreaID_Broadcast=[join $bcCompAreaList ","]}"}
                                   }
                              }
                         }
                    }
               }
               if {$operation == "send"} {
                    set simType "HeNB"
                    set HeNBId [getFromTestMap -HeNBIndex $HeNBIndex -param "HeNBId"]
                    set gwIp   [getDataFromConfigFile "henbSignalingIpaddress" 0 ]
                    set gwPort [getDataFromConfigFile "henbSctp" 0 ]
               } else {
                    set simType "MME"
               }
          }
     }
     # Unset the IE if not intended to be sent in the message
     foreach mandIE $mandatoryIEs {
          if {[info exists mandIE]} {
               if {[set $mandIE] == ""} {unset $mandIE}
          }
     }
     
     if {$operation == "expect" && [array exists ARR_WR_REP]} {
          set wrRepWarn [array get ARR_WR_REP]
     } else {
          # Construct the message that has to be sent to the simulator
          switch $msg {
               "request" {
                    set wrRepWarn [updateValAndExecute "constructS1Procedure -simType simType -msgName msgName -msgType msgType \
                              -HeNBId HeNBId -MMEId MMEId -msgId msgId -serialNum serialNum -warnAreaList warnAreaList \
                              -repPeriod repPeriod -extRepPeriod extRepPeriod -numOfBc numOfBc -warnType warnType \
                              -warnSecInfo warnSecInfo -dataCodeScheme dataCodeScheme -warnMsgCont warnMsgCont \
                              -concurWarnMsgInd concurWarnMsgInd -streamId streamId -gwIp gwIp -gwPort gwPort"]
                    if {[info exists warnAreaChoice]} {
                         if {$warnAreaChoice == "emergency"} { array set ARR_WR_REP $wrRepWarn }
                    }
                    
               }
               "response" {
                    set wrRepWarn [updateValAndExecute "constructS1Procedure -simType simType -msgName msgName -msgType msgType \
                              -HeNBId HeNBId -msgId msgId -serialNum serialNum -bcCompAreaList bcCompAreaList \
                              -criticalityDiag criticalityDiag -streamId streamId -gwIp gwIp -gwPort gwPort"]
                    
               }
          }
     }
     
     print -info "Write-Replace-Warning $wrRepWarn"
     
     if {$execute == "no"} { return "$simType $wrRepWarn"}
     
     return [updateValAndExecute "sendOrVerifyS1APProcedure -msgName msgName -msgType msgType \
               -operation operation -msgList wrRepWarn -simType simType \
               -HeNBIndex HeNBIndex -MMEIndex MMEIndex -henbId HeNBId"]
     
}

proc kill {args} {
     #-
     #- The purpose of the kill procedure is to indicate HeNB/eNBs to kill braodcasting of warning messages
     #-
     #-         Message Type	M
     #-         Message Identifier	M
     #-         Serial Number	M
     #-         Warning Area List	O
     #-
     #- warnAreaList/bcCancAreaList contains warningAreaChoice i.e eCGI or TAI or emergency & list of Henb indexes, to which message is to be sent
     #-              eg:- 1. "eCGI 0 1 2"
     #-              eg:- 2. "eCGI 0 1 2 x"
     #-              eg:- 3. "TAI 0 1 2"
     #-              eg:- 4. "emergency 0 1 2"
     
     global ARR_WR_REP
     set validMsg     "request|response"
     set defMsgId     [randomDataString 16 allDigits]
     set defSerialNum [randomDataString 16 allDigits]
     set defRepPeriod [random 4095]
     set defNumOfBc   [random 65535]
     set msgType      "class2"
     
     set defMsgId     1000
     set defSerialNum 1
     set defRepPeriod 360
     set defNumOfBc   5
     
     parseArgs args \
               [list \
               [list msg                  optional   "$validMsg"            "request"       "The message to be sent" ] \
               [list operation            optional   "send|(don't|)expect"  "send"          "send or expect option"] \
               [list execute              optional   "boolean"              "yes"           "To perform the operation or no
     t"] \
               [list HeNBIndex            optional   "numeric"               ""              "List of HeNB Indices to whichmsg needs to be sent" ] \
               [list MMEIndex             optional   "numeric"              "0"             "Index of MME from which msg has to be sent" ] \
               [list msgId                optional   "numeric"              "$defMsgId"     "Identifies Msg Identifier of msg" ] \
               [list serialNum            optional   "numeric"              "$defSerialNum" "Identifies serial number of Msg" ] \
               [list warnAreaList         optional   "string"               "__UN_DEFINED__" "Identifies the warningAreaList i.e CellId List/taiList/emergencyAreaList"] \
               [list bcCancAreaList       optional   "string"               "__UN_DEFINED__" "Identifies the broadcast Complete Area List i.e CellId List/taiList/emergencyAreaList"] \
               [list numOfBc              optional   "numeric"              "$defNumOfBc"    "Identifies number of broadcasts of msg" ] \
               [list warnType             optional   "string"               "__UN_DEFINED__" "Identifies warning type in the msg" ] \
               ]
     
     set msgName [string map "\
               request  kill_request \
               response kill_response" $msg]
     
     switch -regexp $msg {
          "request"  {
               set mandatoryIEs "msgId serialNum"
               if {$operation == "expect"} { unset -nocomplain warnAreaList}
               
               #Constructing warning area list when user has defined this variable
               if {[info exists warnAreaList]} {
                    set warnAreaChoice [lindex $warnAreaList 0]
                    set henbIndices [lrange $warnAreaList 1 end]
                    set warnAreaList ""
                    for {set i 0} {$i < [llength $henbIndices]} {incr i} {
                         set henbInd [lindex $henbIndices $i]
                         if {[regexp {\d+} $henbInd]} {
                              set paramIndices "0,0"
                         } else {
                              set paramIndices "0,x"
                              #HeNBINdex passed to generateIEs, can't be non-numeric
                              set henbInd 0
                         }
                         switch $warnAreaChoice {
                              "eCGI" {
                                   lappend warnAreaList "[generateIEs -IEType eCGI -paramIndices $paramIndices -HeNBIndex $henbInd -MMEIndex $MMEIndex]"
                                   if {$i == [expr [llength $henbIndices] -1]} {set warnAreaList "{cellIDList=[join $warnAreaList ","]}"}
                              }
                              "tai" {
                                   lappend warnAreaList "[generateIEs -IEType TAI -paramIndices $paramIndices -HeNBIndex $henbInd -MMEIndex $MMEIndex]"
                                   if {$i == [expr [llength $henbIndices] -1]} {set warnAreaList "{trackingAreaListforWarning=[join $warnAreaList ","]}"}
                                   
                              }
                              "emergency" {
                                   lappend warnAreaList "[random 65536]"
                                   if {$i == [expr [llength $henbIndices] -1]} {set warnAreaList "{emergencyAreaIDList=[join $warnAreaList ","]}"}
                              }
                         }
                    }
               }
               if {$operation == "send"} {
                    set simType "MME"
                    set MMEId  [getFromTestMap -MMEIndex $MMEIndex -param "MMEId"]
               } else {
                    set simType "HeNB"
                    set HeNBId [getFromTestMap -HeNBIndex $HeNBIndex -param "HeNBId"]
               }
          }
          "response" {
               set mandatoryIEs "msgId serialNum"
               set numOfBc 0
               
               #Constructing bc Complete area list when user has defined this variable
               if {$operation == "expect"} {
                    set mcc [lindex [getFromTestMap -MMEIndex $MMEIndex -param "MCC"] 0]
                    set mnc [lindex [getFromTestMap -MMEIndex $MMEIndex -param "MNC"] 0]
                    set bcCancAreaList "{cellID_Cancelled={numberOfBroadcasts=$numOfBc eCGI={MCC=$mcc MNC=$mnc cell_ID=[getCGIdFromeNBId [getLTEParam globaleNBId] 0]}}}"
               } else {
                    if {[info exists bcCancAreaList]} {
                         set choice [lindex $bcCancAreaList 0]
                         set henbIndices [lrange $bcCancAreaList 1 end]
                         set bcCancAreaList ""
                         for {set i 0} {$i < [llength $henbIndices]} {incr i} {
                              set henbInd [lindex $henbIndices $i]
                              if {[regexp {\d+} $henbInd]} {
                                   set paramIndices "0,0"
                              } else {
                                   set paramIndices "0,x"
                                   #HeNBINdex passed to generateIEs, can't be non-numeric
                                   set henbInd 0
                              }
                              switch $choice {
                                   "eCGI" {
                                        lappend bcCancAreaList "{numberOfBroadcasts=$numOfBc ecgi=[generateIEs -IEType eCGI -paramIndices $paramIndices -HeNBIndex $henbInd -MMEIndex $MMEIndex]}"
                                        if {$i == [expr [llength $henbIndices] -1]} {set bcCancAreaList "{cellID_Cancelled=[join $bcCancAreaList ","]}"}
                                        
                                   }
                                   "tai" {
                                        set cellList "{numberOfBroadcasts=$numOfBc eCGI=[generateIEs -IEType eCGI -paramIndices $paramIndices -HeNBIndex $henbInd -MMEIndex $MMEIndex]}"
                                        append cellList " tAI=[generateIEs -IEType TAI -paramIndices $paramIndices -HeNBIndex $henbInd -MMEIndex $MMEIndex]"
                                        lappend bcCancAreaList "{cancelledCellinTAI=$cellList}"
                                        if {$i == [expr [llength $henbIndices] -1]} {set bcCancAreaList "{tAI_Cancelled=[join $bcCancAreaList ","]}"}
                                   }
                                   "emergency" {
                                        set cellList "emergencyAreaID=[random 65536]"
                                        append cellList " {numberOfBroadcasts=$numOfBc eCGI=[generateIEs -IEType eCGI -paramIndices $paramIndices -HeNBIndex $henbInd -MMEIndex $MMEIndex]}"
                                        lappend bcCancAreaList "{cancelledCellinEAI={$cellList}}"
                                        if {$i == [expr [llength $henbIndices] -1]} {set bcCancAreaList "{emergencyAreaID_Cancelled=[join $bcCancAreaList ","]}"}
                                   }
                              }
                         }
                    }
               }
               if {$operation == "send"} {
                    set simType "HeNB"
                    set HeNBId [getFromTestMap -HeNBIndex $HeNBIndex -param "HeNBId"]
               } else {
                    set simType "MME"
               }
          }
     }
     # Unset the IE if not intended to be sent in the message
     foreach mandIE $mandatoryIEs {
          if {[info exists mandIE]} {
               if {[set $mandIE] == ""} {unset $mandIE}
          }
     }
     
     if {$operation == "expect" && [array exists ARR_KILL]} {
          set kill [array get ARR_KILL]
     } else {
          # Construct the message that has to be sent to the simulator
          switch $msg {
               "request" {
                    set kill [updateValAndExecute "constructS1Procedure -simType simType -msgName msgName -msgType msgType \
                              -HeNBId HeNBId -MMEId MMEId -msgId msgId -serialNum serialNum -warnAreaList warnAreaList \
                              -repPeriod repPeriod -extRepPeriod extRepPeriod -numOfBc numOfBc -warnType warnType \
                              -warnSecInfo warnSecInfo -dataCodeScheme dataCodeScheme -warnMsgCont warnMsgCont \
                              -concurWarnMsgInd concurWarnMsgInd -streamId streamId"]
                    if {[info exists warnAreaChoice]} {
                         if {$warnAreaChoice == "emergency"} { array set ARR_KILL $kill }
                    }
                    
               }
               "response" {
                    set kill [updateValAndExecute "constructS1Procedure -simType simType -msgName msgName -msgType msgType \
                              -HeNBId HeNBId -msgId msgId -serialNum serialNum -bcCancAreaList bcCancAreaList \
                              -criticalityDiag criticalityDiag -streamId streamId"]
                    
               }
          }
     }
     
     print -info "Kill $kill"
     
     if {$execute == "no"} { return "$simType $kill"}
     
     return [updateValAndExecute "sendOrVerifyS1APProcedure -msgName msgName -msgType msgType \
               -operation operation -msgList kill -simType simType \
               -HeNBIndex HeNBIndex -MMEIndex MMEIndex -henbId HeNBId"]
     
}

proc broadcastWrRep {args} {
     #-
     #- To send WrRepReq from MME, expect WrRepResponse on MME; Expect WrRepReq on HeNBs, send WrRepResponse from HeNBs
     #-
     set validMsg     "request|response"
     set defMsgId     [randomDataString 16 allDigits]
     set defSerialNum [randomDataString 16 allDigits]
     set defRepPeriod [random 4095]
     set defNumOfBc   [random 65535]
     set msgType      "class2"
     
     set defMsgId     1000
     set defSerialNum 1
     set defRepPeriod 360
     set defNumOfBc   5
     
     parseArgs args \
               [list \
               [list execute              optional   "boolean"              "yes"           "To perform the operation or not"] \
               [list HeNBIndex            optional   "string"               ""              "List of HeNB Indices to whichmsg needs to be sent" ] \
               [list MMEIndex             optional   "numeric"              "0"             "Index of MME from which msg has to be sent" ] \
               [list msgId                optional   "numeric"              "$defMsgId"     "Identifies Msg Identifier of msg" ] \
               [list serialNum            optional   "numeric"              "$defSerialNum" "Identifies serial number of Msg" ] \
               [list areaList             optional   "string"               "__UN_DEFINED__" "Identifies the warningAreaList i.e CellId List/taiList/emergencyAreaList"] \
               [list bcCompAreaList       optional   "string"               "__UN_DEFINED__" "Identifies the broadcast Complete Area List i.e CellId List/taiList/emergencyAreaList"] \
               [list repPeriod            optional   "numeric"              "$defRepPeriod"  "Identifies repetition period (in secs) of msg" ] \
               [list extRepPeriod         optional   "numeric"              "__UN_DEFINED__" "Identifies extension repetition period of msg" ] \
               [list numOfBc              optional   "numeric"              "$defNumOfBc"    "Identifies number of broadcasts of msg" ] \
               [list warnType             optional   "string"               "__UN_DEFINED__" "Identifies warning type in the msg" ] \
               [list warnSecInfo          optional   "string"               "__UN_DEFINED__" "Identifies warning security information in the msg" ] \
               [list dataCodeScheme       optional   "string"               "__UN_DEFINED__" "Identifies data coding scheme in the msg" ] \
               [list warnMsgCont          optional   "string"               "__UN_DEFINED__" "Identifies warning msg content" ] \
               [list concurWarnMsgInd     optional   "string"               "__UN_DEFINED__" "Identifies cocurrent warning msg indicator" ] \
               ]
     set flag 0
     set i 0
     set henbIndSeq "0 [split $HeNBIndex]"
     set origAreaList $areaList
     
     foreach henbInd $henbIndSeq {
          ### send/expect on MME ###
          if {$i == 0} {
               set opSeq  "send expect"
          } else {
               ### send/expect on each of HeNBs ###
               set opSeq "expect send"
               
               set areaList [regsub [lrange [split $origAreaList] 1 end] $origAreaList $henbInd]
               print -info "henbAreaList $areaList"
          }
          foreach msg "request response" op $opSeq {
               switch $msg {
                    "request" {
                         set result [updateValAndExecute "writeReplaceWarning -msg msg -operation op -HeNBIndex henbInd -MMEIndex MMEIndex \
                                   -msgId msgId -serialNum serialNum -warnAreaList areaList \
                                   -repPeriod repPeriod -extRepPeriod extRepPeriod -numOfBc numOfBc -warnType warnType -warnSecInfo warnSecInfo \
                                   -dataCodeScheme dataCodeScheme -warnMsgCont warnMsgCont -concurWarnMsgInd concurWarnMsgInd" ]
                         if {$result != 0} {
                              print -fail "Wr-Replace request $op failed for henbIndex $henbInd"
                              set flag 1
                         } else {
                              print -pass "Wr-Replace request $op successful for henbIndex $henbInd"
                         }
                    }
                    "response" {
                         ### Response expect on MME ####
                         set result [updateValAndExecute "writeReplaceWarning -msg msg -operation op -HeNBIndex henbInd -MMEIndex MMEIndex \
                                   -msgId msgId -serialNum serialNum -bcCompAreaList areaList -criticalityDiag criticalityDiag" ]
                         
                         if {$result != 0} {
                              print -fail "Wr-Replace response $op failed for henbIndex $henbInd"
                              set flag 1
                         } else {
                              print -pass "Wr-Replace response $op successful for henbIndex $henbInd"
                         }
                    }
               }
          }
          incr i
     }
     
     return $flag
}

proc broadcastKill {args} {
     #-
     #- To send WrRepReq from MME, expect WrRepResponse on MME; Expect WrRepReq on HeNBs, send WrRepResponse from HeNBs
     #-
     set defMsgId     [randomDataString 16 allDigits]
     set defSerialNum [randomDataString 16 allDigits]
     set defRepPeriod [random 4095]
     set defNumOfBc   [random 65535]
     set msgType      "class2"
     
     set defMsgId     1000
     set defSerialNum 1
     set defRepPeriod 360
     set defNumOfBc   5
     
     parseArgs args \
               [list \
               [list execute              optional   "boolean"              "yes"           "To perform the operation or not"] \
               [list HeNBIndex            optional   "string"               ""              "List of HeNB Indices to whichmsg needs to be sent" ] \
               [list MMEIndex             optional   "numeric"              "0"             "Index of MME from which msg has to be sent" ] \
               [list msgId                optional   "numeric"              "$defMsgId"     "Identifies Msg Identifier of msg" ] \
               [list serialNum            optional   "numeric"              "$defSerialNum" "Identifies serial number of Msg" ] \
               [list areaList             optional   "string"               "__UN_DEFINED__" "Identifies the warningAreaList i.e CellId List/taiList/emergencyAreaList"] \
               [list numOfBc              optional   "numeric"              "$defNumOfBc"    "Identifies number of broadcasts of msg" ] \
               [list warnType             optional   "string"               "__UN_DEFINED__" "Identifies warning type in the msg" ] \
               ]
     set flag 0
     set i 0
     set henbIndSeq "0 [split $HeNBIndex]"
     set origAreaList $areaList
     
     foreach henbInd $henbIndSeq {
          ### send/expect on MME ###
          if {$i == 0} {
               set opSeq  "send expect"
          } else {
               ### send/expect on each of HeNBs ###
               set opSeq "expect send"
               
               set areaList [regsub [lrange [split $origAreaList] 1 end] $origAreaList $henbInd]
               print -info "henbAreaList $areaList"
          }
          foreach msg "request response" op $opSeq {
               switch $msg {
                    "request" {
                         set result [updateValAndExecute "kill -msg msg -operation op -HeNBIndex henbInd -MMEIndex MMEIndex \
                                   -msgId msgId -serialNum serialNum -warnAreaList areaList \
                                   -numOfBc numOfBc -warnType warnType" ]
                         if {$result != 0} {
                              print -fail "Kill request $op failed for henbIndex $henbInd"
                              set flag 1
                         } else {
                              print -pass "Kill request $op successful for henbIndex $henbInd"
                         }
                    }
                    "response" {
                         ### Response expect on MME ####
                         set result [updateValAndExecute "kill -msg msg -operation op -HeNBIndex henbInd -MMEIndex MMEIndex \
                                   -msgId msgId -serialNum serialNum -bcCancAreaList areaList -criticalityDiag criticalityDiag" ]
                         
                         if {$result != 0} {
                              print -fail "Kill response $op failed for henbIndex $henbInd"
                              set flag 1
                         } else {
                              print -pass "Kill response $op successful for henbIndex $henbInd"
                         }
                    }
               }
          }
          incr i
     }
     
     return $flag
}

proc generateGUMMEIsForMMEConfigUpdate {args} {
     #-
     #- to generat GUMMEIS
     #-
     #- input representation  <G1a:G1b>;<G2>
     #- G1a:G1b ":" represents a GUMMEI that is a combination of MCC, MNCs from different indicies
     #-          for ex: we want 2 MCC, MNCs that are part of Gateway configuration and 1 MCC, MNC that are not part
     #-                  of Gateway configuratino, we can use this representation
     #-          ";"  used to seperate out GUMMEIs
     #-          "," used to seperate GUMMEI parameters (like MCC,MNCs,MMECode,MMEGroupId)
     #-
     
     global ARR_LTE_TEST_PARAMS
     global ARR_LTE_TEST_PARAMS_MAP
     
     global ARR_LTE_MME_CONFIG_UPDATE_PARAMS
     global ARR_LTE_MME_CONFIG_UPDATE_PARAMS_MAP
     parseArgs args \
               [list \
               [list GUMMEIs    "optional"  "string"    ""                 "defines gummei parameters for generating" ] \
               [list mmeIndex   "optional"   "string" "__UN_DEFINED__"      "MME index" ] \
               [list noOfMMEs   "optional"  "numeric"   "1"                "defines total number of MMEs" ] \
               [list noOfRegions  "optional" "numeric"  "1"                "defines total number of regions" ] \
               [list mmeRegions   "optional" "string"   ""                 "defines mme assignment to region, i.e MMEC, MMEGI assignment" ] \
               [list mmePLMNs     "optional" "string"   "__UN_DEFINED__"   "defines plmn assignment to MMEs" ] \
               
     ]
     set eleParams {noOfplmns plmnIndex noOfmmecs mmecIndex noOfmmegis mmegiIndex}
     foreach {paramList} $GUMMEIs {
          set i 0 ;# gummei index
          foreach params [split $paramList ";"] {
               set arrIndex "M,$mmeIndex,G${i}"
               foreach param "MCC MNC MMECode MMEGroupId" {
                    set ARR_LTE_MME_CONFIG_UPDATE_PARAMS_MAP($arrIndex,$param) ""
               }
               foreach  eleList [split $params ":"] {
                    foreach $eleParams [split $eleList ","] {break}
                    # Generating PLMNs
                    if {$plmnIndex == "x"} {
                         set plmnIndex 0
                         set ARR_LTE_MME_CONFIG_UPDATE_PARAMS_MAP($arrIndex,MCC) [concat $ARR_LTE_MME_CONFIG_UPDATE_PARAMS_MAP($arrIndex,MCC) [lrange $ARR_LTE_TEST_PARAMS(testMCC) $plmnIndex [expr $noOfplmns + $plmnIndex -1]]]
                         set ARR_LTE_MME_CONFIG_UPDATE_PARAMS_MAP($arrIndex,MNC) [concat $ARR_LTE_MME_CONFIG_UPDATE_PARAMS_MAP($arrIndex,MNC) [lrange $ARR_LTE_TEST_PARAMS(testMNC) $plmnIndex [expr $noOfplmns + $plmnIndex -1]]]
                    } else {
                         set ARR_LTE_MME_CONFIG_UPDATE_PARAMS_MAP($arrIndex,MCC) [lindex $ARR_LTE_TEST_PARAMS(MCC) $plmnIndex]
                         set ARR_LTE_MME_CONFIG_UPDATE_PARAMS_MAP($arrIndex,MNC) [lindex $ARR_LTE_TEST_PARAMS(MNC) $plmnIndex]
                    }
                    # GENERATING MME Index
                    if {$mmecIndex == "x"} {
                         set ARR_LTE_MME_CONFIG_UPDATE_PARAMS_MAP($arrIndex,MMECode) [concat $ARR_LTE_MME_CONFIG_UPDATE_PARAMS_MAP($arrIndex,MMECode) [getRandomUniqueListInRange 1 100 $noOfmmecs]]
                    } else {
                        for {set i 0} {$i <$noOfmmecs} {incr i} {
                             lappend ARR_LTE_MME_CONFIG_UPDATE_PARAMS_MAP($arrIndex,MMECode) [lindex $ARR_LTE_TEST_PARAMS(MMECode) [expr "$mmecIndex" + "$i"]]
                         }

                    }
                    # generate MME Group ID
                    if {$mmegiIndex == "x"} {
                         set ARR_LTE_MME_CONFIG_UPDATE_PARAMS_MAP($arrIndex,MMEGroupId) [concat $ARR_LTE_MME_CONFIG_UPDATE_PARAMS_MAP($arrIndex,MMEGroupId) [getRandomUniqueListInRange 1 100 $noOfmmegis]]
                    } else {
                         set ARR_LTE_MME_CONFIG_UPDATE_PARAMS_MAP($arrIndex,MMEGroupId) [lindex $ARR_LTE_TEST_PARAMS(MMEGroupId) $mmegiIndex]
                    }
               }
               incr i
               set ARR_LTE_TEST_PARAMS($mmeIndex,GUMMEIs) $i
          }
     }
     #if no of mmes > 1
     if {$noOfMMEs > 1} {
          for {set i 0} {$i < $noOfMMEs} {incr i} {
               if {![info exists ARR_LTE_TEST_PARAMS_MAP(M,$i,G0,MCC)]} {
                    #Assigning all the generated MCC and MNC
                    set ARR_LTE_MME_CONFIG_UPDATE_PARAMS_MAP(M,$i,G0,MCC) "$ARR_LTE_TEST_PARAMS(MCC)"
                    set ARR_LTE_MME_CONFIG_UPDATE_PARAMS_MAP(M,$i,G0,MCC) "$ARR_LTE_TEST_PARAMS(MNC)"
               }
          }
     } elseif {$noOfMMEs == 1} {
          #### Retaining old way of default MMEC,MMEGI,PLMN assignment, for single MME
          if {![info exists ARR_LTE_TEST_PARAMS_MAP(M,0,G0,MMECode)]} {
               #Keeping the earlier method, for single MME
               set ARR_LTE_MME_CONFIG_UPDATE_PARAMS_MAP(M,0,G0,MMECode)  "$ARR_LTE_TEST_PARAMS(MMECode)"
               set ARR_LTE_MME_CONFIG_UPDATE_PARAMS_MAP(M,0,G0,MMEGroupId) "$ARR_LTE_TEST_PARAMS(MMEGroupId)"
               
               #Assigning all the generated MCC and MNC
               set ARR_LTE_MME_CONFIG_UPDATE_PARAMS_MAP(M,0,G0,MCC) "$ARR_LTE_TEST_PARAMS(MCC)"
               set ARR_LTE_MME_CONFIG_UPDATE_PARAMS_MAP(M,0,G0,MNC) "$ARR_LTE_TEST_PARAMS(MNC)"
               set ARR_LTE_TEST_PARAMS(0,GUMMEIs) 1
          }
          
          set ARR_LTE_MME_CONFIG_UPDATE_PARAMS_MAP(M,0,Region) 0
     }
     
     return 0
}
proc generateServedGuMMEIList {args} {
     parseArgs args \
               [list \
               [list GUMMEIIndex        optional   "string" "__UN_DEFINED__"      "GUMMEI index" ] \
               [list MMEIndex           optional   "string" "__UN_DEFINED__"      "GUMMEI index" ] \
               [list RegionIndex        optional   "string" "__UN_DEFINED__"      "Region index" ] \
               [list MCC                  optional   "string"         "__UN_DEFINED__"             "The MCC param to be used"] \
               [list MNC                  optional   "string"         "__UN_DEFINED__"             "The MNC param to be used"] \
               [list MMEGroupId           optional   "string"         [getLTEParam "MMEGroupId"]   "The MME group ID to be used"] \
               [list MMECode              optional   "string"         [getLTEParam "MMECode"]      "The MME Code to be used"] \
               [list execute              optional   "boolean"        "yes"               "To perform the operation or not. if no, will return the message"] \
               ]
     if { $GUMMEIIndex == "all"} {
          set GUMMEIIndex [listOfIncrEle 0 8]
     }
     if {$MMEIndex == "all"} {
          set MMEIndex [getFromConfigTestMap -RegionIndex $RegionIndex -MMEIndex "all"]
     }
     #set paramList "MMECode MMEGroupId MCC MNC"
     set IEsList "servedMMECs servedGroupIDs servedPLMNs"
     set servedGUMMEIList ""
     foreach gummeIndex $GUMMEIIndex {
          set GUMMEIList ""
          
          foreach param $IEsList { set arr_gummei($param) ""}
          
          #If GUMMEI RAT is not defined for mme index
          if {$gummeIndex >= $::ARR_LTE_TEST_PARAMS($MMEIndex,GUMMEIs)} {
               continue
          }

          set servedMMECs [getFromConfigTestMap -GUMMEIIndex $gummeIndex -MMEIndex $MMEIndex -param "MMECode"]
          set servedGroupIDs [getFromConfigTestMap -GUMMEIIndex $gummeIndex -MMEIndex $MMEIndex -param "MMEGroupId"]
          set MCC [getFromConfigTestMap -GUMMEIIndex $gummeIndex -MMEIndex $MMEIndex -param "MCC"]
          set MNC [getFromConfigTestMap -GUMMEIIndex $gummeIndex -MMEIndex $MMEIndex -param "MNC"]
          set servedPLMNs "{MCC=$MCC MNC=$MNC}"

          foreach IE $IEsList {
            set arr_gummei($IE) "[concat $arr_gummei($IE) [set $IE]]"
          }
     
          foreach param [array names arr_gummei] {
               if {$arr_gummei($param) != ""} {
                    #lappend GUMMEIList "$param=[join [lsort -unique $arr_gummei($param)] ,]"
                    if {$param == "servedPLMNs"} {
                       append GUMMEIList " $param=$arr_gummei($param)"
                    } else {
                       lappend GUMMEIList "$param=[join [dupRem $arr_gummei($param)] ,]"
                    }
               }
          }

          if {$GUMMEIList != ""} {
               lappend servedGUMMEIList [list $GUMMEIList]
          }
          unset -nocomplain arr_gummei
     }
     print -info "servedGUMMEIList $servedGUMMEIList"
     
     return [join $servedGUMMEIList ","]
     
}
proc getFromConfigTestMap {args} {
     #-
     #- To read from ARR_LTE_MME_CONFIG_UPDATE_PARAMS_MAP matching "param" and MMEIndex/HeNBIndex
     #- Returns list of matched elements
     #-
     parseArgs args \
               [list \
               [list HeNBIndex            optional   "string" "__UN_DEFINED__"      "Index of HeNB whose values need to be retrieved" ] \
               [list MMEIndex             optional   "string" "__UN_DEFINED__"      "Index of MME whose values need to be retrieved" ] \
               [list UEIndex              optional   "string" "__UN_DEFINED__"      "Index of UE whose values need to be retrieved" ] \
               [list GUMMEIIndex          optional   "numeric" "0"                   "Index of GUMMEI Index whose values need to be retrieved" ] \
               [list RegionIndex          optional   "numeric" "0"                   "Index of Region whose values need to be retrieved" ] \
               [list  enbId               optional   "numeric"  "0"                 "enbid for respective moid and mmeindex" ] \
               [list param                optional   "string" "__UN_DEFINED__"      "Index of MME whose values need to be retrieved" ] \
               ]
     set valList ""
     if {[info exists UEIndex]} {
          if {[catch {set val $::ARR_LTE_MME_CONFIG_UPDATE_PARAMS_MAP(H,$HeNBIndex,U,$UEIndex,$param)} err]} {
               #param 'MMEIndex' is updated in global array, only incase of load balancing in s1flex
               #so, if this param is not present, not exiting and returning -1
               if {$param == "MMEIndex"} {
                    return -1
               } else {
                    print -fail "Failure in extracting UE data"
                    print -fail "Got error: $err"
                    exit -1 }
          }
          return $val
     }
     
     if { [info exists HeNBIndex] } {
          if { $HeNBIndex == "all"} {
               set HeNBIndex ""
               #for { set i 0 } { $i < [llength $::ARR_LTE_TEST_PARAMS(HeNBId)] } { incr i } { lappend HeNBIndex $i }
               
               set lst [array get ::ARR_LTE_MME_CONFIG_UPDATE_PARAMS_MAP H,*,Region]
               foreach {key val} $lst {
                    if {[lsearch -exact $val $RegionIndex] != -1} {
                         lappend HeNBIndex [lindex [split $key ","] 1]
                    }
               }
               print -info "list [lsort -dictionary $HeNBIndex]"
               set HeNBIndex [lsort -dictionary $HeNBIndex]
               
          }
          foreach i $HeNBIndex {
               if {[catch {set val $::ARR_LTE_MME_CONFIG_UPDATE_PARAMS_MAP(H,$i,$param)} err]} {
                    print -fail "Failure in extracting HeNB data"
                    print -fail "Got error: $err"
                    exit -1
               }
               #If HeNB is having PLMNs from more than 2 regions
               if {[llength $::ARR_LTE_MME_CONFIG_UPDATE_PARAMS_MAP(H,$i,Region)] > 1} {
                    if {[regexp {MCC|MNC} $param]} {
                         set mmes [array get ::ARR_LTE_MME_CONFIG_UPDATE_PARAMS_MAP M,*,Region]
                         foreach {mmeKey regVal} $mmes {
                              print -info "mme $mmeKey regVal $regVal"
                              #In this case, taking PLMN from that particualr region's one of the MME
                              if {[lsearch -exact $regVal $RegionIndex] != -1 } {
                                   set mmeKey [regsub {Region} $mmeKey "G0,$param"]
                                   set val  $::ARR_LTE_MME_CONFIG_UPDATE_PARAMS_MAP($mmeKey)
                                   print -info "Retrieved $param value of HeNB $i from one of the MME $mmeKey of region $RegionIndex: $val"
                                   break
                              }
                         }
                    }
               }
               lappend valList $val
          }
     }
     if { [info exists MMEIndex] } {
          if { $MMEIndex == "all"} {
               #Returning all MMEs of Region
               set MMEIndex ""
               
               set lst [array get ::ARR_LTE_MME_CONFIG_UPDATE_PARAMS_MAP M,*,Region]
               foreach {key val} $lst {
                    if {[lsearch -exact $val $RegionIndex] != -1} {
                         lappend MMEIndex [lindex [split $key ","] 1]
                    }
               }
               return $MMEIndex
          } elseif {$param == "Region"} {
               return "$::ARR_LTE_MME_CONFIG_UPDATE_PARAMS_MAP(M,$MMEIndex,Region)"
          } elseif {[catch {set val $::ARR_LTE_MME_CONFIG_UPDATE_PARAMS_MAP(M,$MMEIndex,G${GUMMEIIndex},$param)} err]} {
               print -fail "Failure in extracting MME data"
               print -fail "Got error: $err"
               exit -1
          }
          return $val
     }
     print -debug "IngetFromConfigTestMap(),valList:$valList"
     return $valList
     
}

proc mmeConfigUpdate { args } {
     #-
     #- procedure to construct an MME CONFIG UPDATE, MME CONFIGURATION UPDATE ACKNOWLEDGE,MME CONFIGURATION UPDATE FAILURE
     #- MME CONFIGURATION UPDATE
     # Message Type                     M
     # MME Name                         O
     # Served GUMMEIs                   M
     # Relative MME Capacity            O
     
     ########################################
     
     # MME CONFIGURATION UPDATE ACKNOWLEDGE
     # Message Type              M
     # Criticality Diagnostics	O
     
     ###########################################
     
     # MME CONFIGURATION UPDATE FAILURE
     
     # Message Type	M
     # Cause       	M
     #Time to wait	O
     #Criticality Diagnostics	O
     
     global ARR_MME_CONFIG_UPDATE
     set validMsg      "update|ack|failure"
     set msgType      "class2"
     set defaultCause "unspecified"
     set defaultRelCap [getRandomUniqueListInRange 1 255]
     parseArgs args \
               [list \
               [list msg                  optional   "$validMsg"      "update"         "The message to be sent" ] \
               [list operation            optional   "send|(don't|)expect" "send"        "send or expect option"] \
               [list execute              optional   "boolean"        "yes"               "To perform the operation or not. if no, will return the message"] \
               [list HeNBIndex            mandatory  "numeric"        ""                  "Index of HeNB whose values need to be retrieved" ] \
               [list MMEName              optional   "string"         "__UN_DEFINED__"             "The MME Name to be sent"] \
               [list timeToWait           optional   "string"         "__UN_DEFINED__"             "Value of time to wait indication in failure msg"] \
               [list causeType            optional   "string"         "misc"          "Identifies the cause choice group"] \
               [list cause                optional   "string"         "$defaultCause"     "Identifies the cause value"] \
               [list criticalityDiag      optional   "string"         "__UN_DEFINED__"    "The critical diag to be enabled or not"] \
               [list procedureCode        optional   "string"         "__UN_DEFINED__"             "The procedure code to be used diag"] \
               [list triggerMsg           optional   "string"         "__UN_DEFINED__"             "Identifies the triggering message"] \
               [list procedureCriticality optional   "string"         "__UN_DEFINED__"             "Identifies the procedure Criticality"] \
               [list IECriticality        optional   "string"         "__UN_DEFINED__"             "Identifies the IE Criticality"] \
               [list IEId                 optional   "string"         "__UN_DEFINED__"             "Identifies the IE Id"] \
               [list typeOfError          optional   "string"         "__UN_DEFINED__"             "Identifies the type of error"] \
               [list relMMECapacity       optional   "string"         "$defaultRelCap"  "The relMMECapacity to be used"] \
               [list GUMMEIIndex          optional   "string"         "all"              "Index of GUMMEI"] \
               [list MMEIndex             mandatory  "numeric"        ""                 "Index of MME"] \
               [list servedGUMMEIList     optional   "string"         "__UN_DEFINED__"   "served gummei"]\
               ]
     
     set msgName [string map "\
               update     mme_configuration_update \
               ack        mme_configuration_update_acknowledge \
               failure    mme_configuration_update_failure" $msg]

     set gwPort [getDataFromConfigFile "henbSctp" 0 ]

     set MultiS1Link $::ARR_LTE_TEST_PARAMS(MultiS1Link)
     if {$MultiS1Link == "yes"} {
        if {[info exists globaleNBId]} {
           set eNBType [getFromTestMap -HeNBIndex $HeNBIndex -param "eNBType"]
           if {! [ info exists eNBType ]} {
              set eNBType "macro"
           }
           set globaleNBId "\{${eNBType}ENB_ID=$globaleNBId\}"
        }
     }    

     switch -regexp $msg {
          "update"  {
               set mandatoryIEs "msgType"
               set gwIp   [getDataFromConfigFile "mmeSignalingIpaddress" 0 ]
               
               if {$operation == "send"} {
                    set simType "MME"
                    set MMEId  [getFromTestMap -MMEIndex $MMEIndex -param "MMEId"]
               } elseif { $operation == "expect" || $operation == "don'texpect"} {
                    set simType "HeNB"
                    set MMEName  [getFromTestParam "HeNBGWName"]
                    set relMMECapacity "255"
               }
          }
          "ack" {
               set simType "HeNB"
               parseArgs args \
                         [list \
                         [list HeNBIndex   mandatory  "numeric"      ""     "Index of HeNB"] \
                         ]
               set gwIp   [getDataFromConfigFile "henbSignalingIpaddress" 0 ]
               if {[info exists criticalityDiag]} {
                    set criticalityDiag [updateValAndExecute "getCriticDiag -criticalityDiag criticalityDiag \
                              -procedureCode procedureCode -triggerMsg triggerMsg \
                              -procedureCriticality procedureCriticality \
                              -IECriticality IECriticality -IEId IEId -typeOfError typeOfError"]
               }
               if {$operation == "send"} {
                    set simType "HeNB"
                    set HeNBId [getFromTestMap -HeNBIndex $HeNBIndex -param "HeNBId"]
               } elseif { $operation == "expect"} {
                    set simType "MME"
               }
          }
          "failure" {
               set simType "HeNB"
               set mandatoryIEs "msgType cause"
               set gwIp   [getDataFromConfigFile "henbSignalingIpaddress" 0 ]
               if {[info exists criticalityDiag]} {
                    set criticalityDiag [updateValAndExecute "getCriticDiag -criticalityDiag criticalityDiag \
                              -procedureCode procedureCode -triggerMsg triggerMsg \
                              -procedureCriticality procedureCriticality \
                              -IECriticality IECriticality -IEId IEId -typeOfError typeOfError"]
               }
               if {$operation == "send"} {
                    set simType "HeNB"
                    set HeNBId [getFromTestMap -HeNBIndex $HeNBIndex -param "HeNBId"]
               } elseif { $operation == "expect"} {
                    set simType "MME"
               }
          }
     }
     set mmeConfigMsg [updateValAndExecute "constructS1Procedure -simType simType -msgName msgName \
               -msgType msgType -HeNBId HeNBId -MMEId MMEId -MMEName MMEName  -relMMECapability relMMECapacity \
               -criticalityDiag criticalityDiag -causeType causeType -cause cause -timeToWait timeToWait \
               -servedGUMMEIList servedGUMMEIList -gwIp gwIp -gwPort gwPort -globaleNBId  globaleNBId " ]

     print -info "mmeConfigMsg $mmeConfigMsg"
     
     if {$execute == "no"} { return "$simType $mmeConfigMsg"}
     
     return [updateValAndExecute "sendOrVerifyS1APProcedure -msgName msgName -msgType msgType \
               -operation operation -simType simType -msgList mmeConfigMsg -enbID globaleNBId \
               -HeNBIndex HeNBIndex -MMEIndex MMEIndex -henbId HeNBId"]
}

proc traceStart {args} {
     
     #- This procedure is used to send and verify the traceStart message.
     #- @return 0 on success, @return -1 on failure
     
     set validS1Msg        "trace_start"
     
     parseArgs args \
               [list \
               [list msgName                optional   "$validS1Msg"    "trace_start"                    "The message to be sent" ] \
               [list msgType                optional   "string"        "class2"                    "The message to be sent" ] \
               [list operation               optional   "send|(don't|)expect"    "send"              "send or expect option" ] \
               [list execute                 optional   "boolean"        "yes"                        "To perform the operation or not. if no, will return the message"] \
               [list streamId                optional   "numeric"      "__UN_DEFINED__"       "The streamID to be used for the UE transaction" ] \
               [list eNBUES1APId             optional   "string"         "__UN_DEFINED__"    "eNB UE S1AP Id value" ] \
               [list MMEUES1APId             optional   "string"         "__UN_DEFINED__"    "MME UE S1AP Id value" ] \
               [list HeNBId                  optional   "string"         "__UN_DEFINED__"             "The heNBId param to be used in HeNB"] \
               [list MMEIndex                optional   "string"         "0"                          "Index of GUMMEI"] \
               [list HeNBIndex               optional   "string"         "0"                          "Index of GUMMEI"] \
               [list UEIndex                 optional   "string"         "0"                          "Index of GUMMEI"] \
               [list traceActivation        optional   "string"               "__UN_DEFINED__"    "cocurrent warning msg indicator in wr-rep-warn msg" ] \
               [list mandatoryIEs            optional   "string"         ""             "Miss the mandatory IE" ] \
               ]
     
     if {$operation == "send"} {
          set simType "MME"
          set paramList [list vENBUES1APId MMEUES1APId streamId mmeUEId]

          set MultiS1Link $::ARR_LTE_TEST_PARAMS(MultiS1Link)
          if {$MultiS1Link == "yes"} {
             set enbID [getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "eNBId"]
             set eNBType [getFromTestMap -HeNBIndex $HeNBIndex -param "eNBType"]
             if {! [ info exists eNBType ]} {
                set eNBType "macro"
             }
             if {[info exists enbID]} {
                set globaleNBId "\{${eNBType}ENB_ID=$enbID\}"
             }
          }

     } else {
          set simType "HeNB"
          set paramList [list eNBUES1APId vENBUES1APId mStreamId mmeUEId]
     }
     set gwIp   [getDataFromConfigFile "mmeSignalingIpaddress" 0 ]
     set gwPort [getDataFromConfigFile "henbSctp" 0 ]
     set MMEId  [getFromTestMap -MMEIndex $MMEIndex -param "MMEId"]

     #Update the dynamic variables
     foreach dynElement {eNBUES1APId MMEUES1APId streamId ueid} param $paramList {
          
          if {![info exists $dynElement]} {
               if {$param == "streamId"} {
                    set streamId [expr $UEIndex + 1]
                    continue
               }
               if {[catch {set $dynElement [getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "$param"]}]} {
                    print -abort "Failed to get the param $param"
                    return 1
               }
          }
     }

     set traceActivation [generateIEs -IEType "traceActivation" -HeNBIndex $HeNBIndex -MMEIndex $MMEIndex]

     foreach mandIE $mandatoryIEs {
        if {[info exists mandIE]} {
               unset $mandIE
        }
     }
  
     foreach param "eNBUES1APId MMEUES1APId" {
        if {[set $param] == ""} {
           print -dbg "No $param IE generated with -$param <val> option. will not send $param IE in the message"
           unset -nocomplain $param
        }      
     }

     if { $operation == "send" || 1 } {
          set traceStart [ updateValAndExecute "constructS1Procedure -simType simType -msgName msgName -MMEId MMEId -msgType msgType -HeNBId HeNBId -globaleNBId globaleNBId \
                    -eNBUES1APId eNBUES1APId -MMEUES1APId MMEUES1APId -traceActivation traceActivation -msgType msgType -streamId streamId -gwIp gwIp -gwPort gwPort"]
          
          array set arr_traceStart_msg $traceStart
     }
     
     print -info "traceStart $traceStart"
     if {$execute == "no"} { return "$simType $traceStart""}
     return [updateValAndExecute "sendOrVerifyS1APProcedure -msgName msgName -MMEId MMEId -msgType msgType \
               -operation operation -msgList traceStart -simType simType \
               -HeNBIndex HeNBIndex -MMEIndex MMEIndex -traceActivation traceActivation"]
     
}
proc traceFailureIndication {args} {
     
     #- This procedure is used to send and verify the traceStart message.
     #- @return 0 on success, @return -1 on failure
     
     global  arr_trace_failure_indication_msg
     
     set validS1Msg "trace_failure_indication"
     
     parseArgs args \
               [list \
               [list msgName                  optional   "$validS1Msg"    "trace_failure_indication"                    "The message to be sent" ] \
               [list msgType                optional   "string"        "class2"                    "The message to be sent" ] \
               [list operation            optional   "send|(don't|)expect"    "send"              "send or expect option" ] \
               [list execute              optional   "boolean"        "yes"                        "To perform the operation or not. if no, will return the message"] \
               [list streamId             optional   "string"         "__UN_DEFINED__"             "The sctp string to send or receive data"] \
               [list eNBUES1APId          optional   "string"         "__UN_DEFINED__"    "eNB UE S1AP Id value" ] \
               [list MMEUES1APId          optional   "string"         "__UN_DEFINED__"    "MME UE S1AP Id value" ] \
               [list HeNBId               optional   "string"         "__UN_DEFINED__"             "The heNBId param to be used in HeNB"] \
               [list MMEIndex                optional   "string"         "0"                          "Index of GUMMEI"] \
               [list HeNBIndex               optional   "string"         "0"                          "Index of GUMMEI"] \
               [list UEIndex                 optional   "string"         "0"                          "Index of GUMMEI"] \
               [list mandatoryIEs            optional   "string"         ""             "Miss the mandatory IE" ] \
               [list eUtranTraceId        optional   "string"         "0"                          "Index of GUMMEI"] \
               [list cause                optional   "string"         "Unspecified"                          "Index of GUMMEI"] \
               [list causeType             optional   "string"        "misc"                          "Index of GUMMEI"] \
               [list missMandIe           optional   "string"         "__UN_DEFINED__"             "Miss the mandatory IE" ] \
               ]
     
     if {$operation == "send"} {
          set simType "HeNB"
          set paramList [list eNBUES1APId vENBUES1APId streamId mmeUEId]
     } else {
          set simType "MME"
          set paramList [list vENBUES1APId MMEUES1APId mStreamId mmeUEId]
          
     }

     set gwIp   [getDataFromConfigFile "henbSignalingIpaddress" 0 ]
     set gwPort [getDataFromConfigFile "henbSctp" 0 ]
     set HeNBId [getFromTestMap -HeNBIndex $HeNBIndex -param "HeNBId"]


     set MultiS1Link $::ARR_LTE_TEST_PARAMS(MultiS1Link)

     if {$MultiS1Link == "yes"} {
        set enbID [getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "eNBId"]
     }    

     #Update the dynamic variables
     foreach dynElement {eNBUES1APId MMEUES1APId streamId ueid} param $paramList {
          
          if {![info exists $dynElement]} {
               if {$param == "streamId"} {
                    set streamId [expr $UEIndex + 1]
                    continue
               }
               if {[catch {set $dynElement [getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "$param"]}]} {
                    print -abort "Failed to get the param $param"
                    return 1
               }
          }
     }
     set causeVal "\{$causeType=$cause\}"
     
     foreach mandIE $mandatoryIEs {
        if {[info exists mandIE]} { 
               unset $mandIE
        } 
     }
 
     foreach param "eNBUES1APId MMEUES1APId" {
        if {[set $param] == ""} {
           print -dbg "No $param IE generated with -$param <val> option. will not send $param IE in the message"
           unset -nocomplain $param
        }
     }

     if { $operation == "send" || 1 } {
          set traceFailureIndication [ updateValAndExecute "constructS1Procedure -simType simType -msgName msgName -HeNBId HeNBId -msgType msgType \
                    -eNBUES1APId eNBUES1APId -MMEUES1APId MMEUES1APId -cause causeVal -eUtranTraceId eUtranTraceId -streamId streamId -gwIp gwIp -gwPort gwPort "]
          
          array set arr_trace_failure_indication_msg $traceFailureIndication
     }
     
     print -info "traceFailureIndication- $traceFailureIndication"
     if {$execute == "no"} { return "$simType $traceFailureIndication"}
     
     return [updateValAndExecute "sendOrVerifyS1APProcedure -msgName msgName -HeNBId HeNBId -msgType msgType \
               -operation operation -msgList traceFailureIndication -simType simType -enbID enbID \
               -HeNBIndex HeNBIndex -MMEIndex MMEIndex"]
     
}

proc deactivateTrace { args } {
    
    set validS1Msg "deactivate_trace"
     parseArgs args \
               [list \
               [list msgName              optional   "$validS1Msg"    "deactivate_trace"                    "The message to be sent" ] \
               [list msgType                optional   "string"        "class2"                    "The message to be sent" ] \
               [list operation            optional   "send|(don't|)expect"    "send"              "send or expect option" ] \
               [list execute              optional   "boolean"        "yes"                        "To perform the operation or not. if no, will return the message"] \
               [list streamId             optional   "string"         "__UN_DEFINED__"             "The sctp string to send or receive data"] \
               [list eNBUES1APId          optional   "string"         "__UN_DEFINED__"    "eNB UE S1AP Id value" ] \
               [list MMEUES1APId          optional   "string"         "__UN_DEFINED__"    "MME UE S1AP Id value" ] \
               [list HeNBId               optional   "string"         "__UN_DEFINED__"             "The heNBId param to be used in HeNB"] \
               [list MMEIndex             optional   "string"         "0"                          "Index of GUMMEI"] \
               [list eUtranTraceId        optional   "string"         "0"                          "Index of GUMMEI"] \
               [list HeNBIndex               optional   "string"         "0"                          "Index of GUMMEI"] \
               [list UEIndex                 optional   "string"         "0"                          "Index of GUMMEI"] \
               [list mandatoryIEs            optional   "string"         ""             "Miss the mandatory IE" ] \
               [list missMandIe           optional   "string"         "__UN_DEFINED__"             "Miss the mandatory IE" ] \
               ]
     
     if {$operation == "send"} {
          set simType "MME"
          set paramList [list vENBUES1APId MMEUES1APId streamId mmeUEId]

          set MultiS1Link $::ARR_LTE_TEST_PARAMS(MultiS1Link)
          if {$MultiS1Link == "yes"} {
             set enbID [getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "eNBId"]
             set eNBType [getFromTestMap -HeNBIndex $HeNBIndex -param "eNBType"]
             if {! [ info exists eNBType ]} {
                set eNBType "macro"
             }
             if {[info exists enbID]} {
                set globaleNBId "\{${eNBType}ENB_ID=$enbID\}"
             }
          }

     } else {
          set simType "HeNB"
          set paramList [list eNBUES1APId vENBUES1APId mStreamId mmeUEId]
     }
     #Update the dynamic variables
     foreach dynElement {eNBUES1APId MMEUES1APId streamId ueid} param $paramList {
          
          if {![info exists $dynElement]} {
               if {$param == "streamId"} {
                    set streamId [expr $UEIndex + 1]
                    continue
               }
               if {[catch {set $dynElement [getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "$param"]}]} {
                    print -abort "Failed to get the param $param"
                    return 1
               }
          }
     }

     set gwIp   [getDataFromConfigFile "mmeSignalingIpaddress" 0 ]
     set gwPort [getDataFromConfigFile "henbSctp" 0 ]
     set MMEId  [getFromTestMap -MMEIndex $MMEIndex -param "MMEId"]

     foreach mandIE $mandatoryIEs {
        if {[info exists mandIE]} { 
               unset $mandIE
        } 
     }

     foreach param "eNBUES1APId MMEUES1APId" {
               if {[set $param] == ""} {
                     print -dbg "No $param IE generated with -$param <val> option. will not send $param IE in the message"
                     unset -nocomplain $param
               }
     }

     if { $operation == "send" || 1 } {
          set deactivateTrace [ updateValAndExecute "constructS1Procedure -simType simType -msgName msgName -MMEId MMEId -msgType msgType -HeNBId HeNBId \
                    -eNBUES1APId eNBUES1APId -MMEUES1APId MMEUES1APId -eUtranTraceId eUtranTraceId -streamId streamId -gwIp gwIp -gwPort gwPort -globaleNBId globaleNBId"]
          
          array set arr_deactivate_trace $deactivateTrace
     }
     
     print -info "deactivateTrace $deactivateTrace"
     if {$execute == "no"} { return "$simType $deactivateTrace"}
     
     return [updateValAndExecute "sendOrVerifyS1APProcedure -msgName msgName -HeNBId HeNBId -msgType msgType \
               -operation operation -msgList deactivateTrace -simType simType \
               -HeNBIndex HeNBIndex -MMEIndex MMEIndex"]
     
}

###########################################################################

proc locationReportingControl {args} {

     #- This procedure is used to send and verify the ueContextModificationRequest message.
     #- @return 0 on success, @return -1 on failure

     global  arr_locationReportingControl

     parseArgs args \
               [list \
               [list operation               optional   "send|(don't|)expect"    "send"      "send or expect option" ] \
               [list execute                 optional   "boolean"        "yes"               "To perform the operation or not. if no, will return the message"] \
               [list streamId                optional   "numeric"      "__UN_DEFINED__"       "The streamID to be used for the UE transaction" ] \
               [list eNBUES1APId             optional   "string"         "__UN_DEFINED__"    "eNB UE S1AP Id value" ] \
               [list MMEUES1APId             optional   "string"         "__UN_DEFINED__"    "MME UE S1AP Id value" ] \
               [list missMandIe              optional   "string"         "__UN_DEFINED__"    "Miss the mandatory IE" ] \
               [list eventType               optional   "string"        "Direct"                 "Defines the CSG membership status" ] \
               [list reportArea              optional   "string"        "ECGI"                 "Defines the registered LAI" ] \
               [list requestType             optional   "string"        ""                 "Defines the registered LAI" ] \
               [list MMEIndex                optional   "string"         "0"                 "Index of GUMMEI"] \
               [list HeNBIndex               optional   "string"         "0"                 "Index of GUMMEI"] \
               [list UEIndex                 optional   "string"         "0"                 "Index of GUMMEI"] \
               [list mandatoryIEs            optional   "string"         ""                  "Miss the mandatory IE" ] \
               [list UnknownIE               optional   "string"         ""                  "Miss the mandatory IE" ] \
               ]

     set msgName "location_reporting_control"
     if {$operation == "send" } {
          set simType "MME"
          set paramList [list vENBUES1APId MMEUES1APId streamId mmeUEId]
          set MMEId  [getFromTestMap -MMEIndex $MMEIndex -param "MMEId"]

          set MultiS1Link $::ARR_LTE_TEST_PARAMS(MultiS1Link)
          if {$MultiS1Link == "yes"} {
             set enbID [getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "eNBId"]
             set eNBType [getFromTestMap -HeNBIndex $HeNBIndex -param "eNBType"]
             if {! [ info exists eNBType ]} {
                set eNBType "macro"
             }
             if {[info exists enbID]} {
                set globaleNBId "\{${eNBType}ENB_ID=$enbID\}"
             }
          }


     } else {
          set simType "HeNB"
          set paramList [list eNBUES1APId vENBUES1APId mStreamId mmeUEId]
          set HeNBId [getFromTestMap -HeNBIndex $HeNBIndex -param "HeNBId"]

     }
     #Update the dynamic variables
     foreach dynElement {eNBUES1APId MMEUES1APId streamId ueid} param $paramList {

          if {![info exists $dynElement]} {
               if {$param == "streamId"} {
                    set streamId [expr $UEIndex + 1]
                    continue
               }
               if {[catch {set $dynElement [getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "$param"]}]} {
                    print -abort "Failed to get the param $param"
                    return 1
               }
          }
     }

     set requestType "\{eventType=$eventType reportArea=$reportArea\}"
     set gwIp   [getDataFromConfigFile "henbSignalingIpaddress" 0 ]
     set gwPort [getDataFromConfigFile "henbSctp" 0 ]

     foreach mandIE $mandatoryIEs {
          if {[info exists mandIE]} {
               unset $mandIE
          }
     }

     if {[info exists $UnknownIE]} {
          set eventType  "3"
          set reportArea "1"
          set requestType "\{eventType=$eventType reportArea=$reportArea\}"
     }

     foreach param "eNBUES1APId MMEUES1APId" {
               if {[set $param] == ""} {
                     print -dbg "No $param IE generated with -$param <val> option. will not send $param IE in the message"
                     unset -nocomplain $param
               }
     }
 
     if { $operation == "send" || 1  } {
          set locationReportingControl [ updateValAndExecute "constructS1Procedure -simType simType -msgName msgName -msgType msgType \
                                         -HeNBId HeNBId -gwIp gwIp -gwPort gwPort -eNBUES1APId eNBUES1APId -MMEUES1APId MMEUES1APId \
                                         -requestType requestType -streamId streamId -MMEId MMEId -globaleNBId globaleNBId"]

          array set arr_locationReportingControl $locationReportingControl
     }

     print -info "locationReportingControl $locationReportingControl"
     if {$execute == "no"} { return "$simType $locationReportingControl" }

     return [updateValAndExecute "sendOrVerifyS1APProcedure -HeNBId HeNBId -MMEId MMEId -msgName msgName -msgType msgType \
               -operation operation -msgList locationReportingControl -simType simType \
               -HeNBIndex HeNBIndex -MMEIndex MMEIndex"]

}
     
###################################################################################################################

proc locationReportingFailureIndication {args} {

     #- This procedure is used to send and verify the traceStart message.
     #- @return 0 on success, @return -1 on failure

     global  arr_locationReportingFailureIndication_msg


     parseArgs args \
               [list \
               [list msg                  optional   "string"    "locationReportingFailureIndication"                    "The message to be sent" ] \
               [list operation            optional   "send|(don't|)expect"    "send"              "send or expect option" ] \
               [list execute              optional   "boolean"        "yes"                        "To perform the operation or not. if no, will return the message"] \
               [list streamId             optional   "string"         "__UN_DEFINED__"             "The sctp string to send or receive data"] \
               [list eNBUES1APId          optional   "string"         "__UN_DEFINED__"    "eNB UE S1AP Id value" ] \
               [list MMEUES1APId          optional   "string"         "__UN_DEFINED__"    "MME UE S1AP Id value" ] \
               [list MMEIndex                optional   "string"         "0"                 "Index of GUMMEI"] \
               [list HeNBIndex               optional   "string"         "0"                 "Index of GUMMEI"] \
               [list cause                optional   "string"         "control_processing_overload"       "Index of GUMMEI"] \
               [list UEIndex                 optional   "string"         "0"                 "Index of GUMMEI"] \
               [list causeType             optional   "string"        "protocol"                          "Index of GUMMEI"] \
               [list missMandIe           optional   "string"         "__UN_DEFINED__"             "Miss the mandatory IE" ] \
               [list mandatoryIEs            optional   "string"         ""                  "Miss the mandatory IE" ] \
               ]

     if {$operation == "send"} {
          set simType "HeNB"
          set paramList [list eNBUES1APId vENBUES1APId streamId mmeUEId ]
          set HeNBId [getFromTestMap -HeNBIndex $HeNBIndex -param "HeNBId"]
     } else {
          set simType "MME"
          set paramList [list vENBUES1APId MMEUES1APId mStreamId mmeUEId ]
          set MMEId  [getFromTestMap -MMEIndex $MMEIndex -param "MMEId"]
     }

     set msgName location_reporting_failure_indication
     #Update the dynamic variables
     foreach dynElement {eNBUES1APId MMEUES1APId streamId ueid } param $paramList {

          if {![info exists $dynElement]} {
               if {$param == "streamId"} {
                    set streamId [expr $UEIndex + 1]
                    continue
               }
               if {[catch {set $dynElement [getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "$param"]}]} {
                    print -abort "Failed to get the param $param"
                    return 1
               }

          }
     }

     set gwIp   [getDataFromConfigFile "henbSignalingIpaddress" 0 ]
     set gwPort [getDataFromConfigFile "henbSctp" 0 ]
     set causeType "misc"

     set MultiS1Link $::ARR_LTE_TEST_PARAMS(MultiS1Link)

     if {$MultiS1Link == "yes"} {
        set enbID [getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "eNBId"]
     }    

     foreach mandIE $mandatoryIEs {
          if {[info exists mandIE]} {
               if {[set $mandIE] == ""} {unset $mandIE}
          }
     }

     if {[info exists causeType] && [info exists cause]} {
        set causeVal "\{$causeType=$cause\}"
     }

     if { $operation == "send" || 1 } {
          set locationReportingFailureIndication [ updateValAndExecute "constructS1Procedure -simType simType -msgName msgName \
                                                  -msgType msgType -HeNBId HeNBId -gwIp gwIp -gwPort gwPort -MMEId MMEId\
                                                  -streamId streamId -eNBUES1APId eNBUES1APId -MMEUES1APId MMEUES1APId -cause causeVal"]

          array set arr_locationReportingFailureIndication_msg $locationReportingFailureIndication
     }

     print -info "locationReportingFailureIndication $locationReportingFailureIndication"
     if {$execute == "no"} { return "$simType $locationReportingFailureIndication"}

     return [updateValAndExecute "sendOrVerifyS1APProcedure -msgName msgName -msgType msgType -MMEId MMEId\
               -operation operation -msgList locationReportingFailureIndication -simType simType -HeNBId HeNBId\
               -HeNBIndex HeNBIndex -MMEIndex MMEIndex -enbID enbID"]

}

############################################################################################################################################

proc locationReport {args} {
     
     #- This procedure is used to send and verify the ueContextModificationRequest message.
     #- @return 0 on success, @return -1 on failure
     
     global  arr_locationReport
     
     parseArgs args \
               [list \
               [list operation               optional   "send|(don't|)expect"    "send"      "send or expect option" ] \
               [list execute                 optional   "boolean"        "yes"               "To perform the operation or not. if no, will return the message"] \
               [list streamId                optional   "string"         "__UN_DEFINED__"    "The sctp string to send or receive data"] \
               [list eNBUES1APId             optional   "string"         "__UN_DEFINED__"    "eNB UE S1AP Id value" ] \
               [list MMEUES1APId             optional   "string"         "__UN_DEFINED__"    "MME UE S1AP Id value" ] \
               [list missMandIe              optional   "string"         "__UN_DEFINED__"    "Miss the mandatory IE" ] \
               [list eventType               optional   "string"        "Direct"                 "Defines the CSG membership status" ] \
               [list reportArea              optional   "string"        "ECGI"                 "Defines the registered LAI" ] \
               [list MMEIndex                optional   "string"         "0"                 "Index of GUMMEI"] \
               [list HeNBIndex               optional   "string"         "0"                 "Index of GUMMEI"] \
               [list UEIndex                 optional   "string"         "0"                 "Index of GUMMEI"] \
               [list mandatoryIEs            optional   "string"         ""                  "Miss the mandatory IE" ] \
               ]
     
     set msgName "location_report"

     if {$operation == "send" } {
          set simType "HeNB"
          set paramList [list eNBUES1APId vENBUES1APId streamId mmeUEId]
          set HeNBId [getFromTestMap -HeNBIndex $HeNBIndex -param "HeNBId"]
          set ueid   [getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "ueid"]
     } else {
          set simType "MME"
          set paramList [list vENBUES1APId MMEUES1APId mStreamId mmeUEId]
          set MMEId  [getFromTestMap -MMEIndex $MMEIndex -param "MMEId"]
     }

     #Update the dynamic variables
     foreach dynElement {eNBUES1APId MMEUES1APId streamId ueid} param $paramList {
          
          if {![info exists $dynElement]} {
               if {$param == "streamId"} {
                    set streamId [expr $UEIndex + 1]
                    continue
               }
               if {[catch {set $dynElement [getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "$param"]}]} {
                    print -abort "Failed to get the param $param"
                    return 1
               }
          }
     }
     
     set eCGI  [generateIEs -IEType eCGI -paramIndices "1,1" -HeNBIndex $HeNBIndex -MMEIndex $MMEIndex]
     set tai   [generateIEs -IEType TAI -paramIndices "1,1 " -HeNBIndex $HeNBIndex -MMEIndex $MMEIndex]
     
     set requestType "\{eventType=$eventType reportArea=$reportArea\}"
     set gwIp   [getDataFromConfigFile "henbSignalingIpaddress" 0 ]
     set gwPort [getDataFromConfigFile "henbSctp" 0 ]
     
     foreach mandIE $mandatoryIEs {
          if {[info exists mandIE]} {
             unset $mandIE
          }
     }

     set MultiS1Link $::ARR_LTE_TEST_PARAMS(MultiS1Link)

     if {$MultiS1Link == "yes"} {
        set enbID [getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "eNBId"]
     }    
     
     foreach param "eNBUES1APId MMEUES1APId " {
          if {[set $param] == ""} {
               print -dbg "No $param IE generated with -$param <val> option. will not send $param IE in the message"
               unset -nocomplain $param
          }
     }
     
     if { $operation == "send" || 1  } {
          set locationReport [ updateValAndExecute "constructS1Procedure -simType simType -msgName msgName -msgType msgType \
                    -HeNBId HeNBId -ueid ueid -gwIp gwIp -gwPort gwPort -eNBUES1APId eNBUES1APId -MMEUES1APId MMEUES1APId \
                    -requestType requestType -streamId streamId -eCGI eCGI -TAI tai -MMEId MMEId"  ]
          
          array set arr_locationReport $locationReport
     }
     
     print -info "locationReport $locationReport"
     if {$execute == "no"} { return "$simType $locationReport" }
     
     return [updateValAndExecute "sendOrVerifyS1APProcedure -HeNBId HeNBId -MMEId MMEId -msgName msgName -msgType msgType \
               -operation operation -msgList locationReport -simType simType -enbID enbID \
               -HeNBIndex HeNBIndex -MMEIndex MMEIndex"]
     
}

############################################################################################################################################
 
proc ueContextModificationFailure {args} {
     
     global  arr_ueContextModificationFailure_msg
     set msgName "ue_context_modification_failure"
     set msgType "class1"
     set flag 0
     set defaultCause "message_not_compatible_with_receiver_state"
     
     parseArgs args \
               [list \
               [list msgName              optional   "string"        "ue_context_modification_failure" "The message to be sent" ] \
               [list operation            optional   "send|(don't|)expect"    "send"              "send or expect option" ] \
               [list execute              optional   "boolean"        "yes"   "To perform the operation or not. if no, will return the message"] \
               [list streamId                optional   "string"         "__UN_DEFINED__"    "The sctp string to send or receive data"] \
               [list eNBUES1APId          optional   "string"         "__UN_DEFINED__"    "eNB UE S1AP Id value" ] \
               [list MMEUES1APId          optional   "string"         "__UN_DEFINED__"    "MME UE S1AP Id value" ] \
               [list HeNBId               optional   "string"         "__UN_DEFINED__"   "The heNBId param to be used in HeNB"] \
               [list MMEIndex             optional   "string"         "0"                "Index of GUMMEI"] \
               [list HeNBIndex            optional   "string"         "0"                "Index of GUMMEI"] \
               [list UEIndex              optional   "string"         "0"                "Index of GUMMEI"] \
               [list mandatoryIEs         optional   "string"         ""                 "Miss the mandatory IE" ] \
               [list missMandIe           optional   "string"         ""   "Miss the mandatory IE" ] \
               [list criticalityDiag      optional   "string"         "__UN_DEFINED__"   "The critical diag to be enabled or not"] \
               [list cause                optional   "string"         "$defaultCause"     "Index of GUMMEI"] \
               [list causeType            optional   "string"         "protocol"          "Index of GUMMEI"] \
               ]

     set mandatoryIEs "MMEUES1APId eNBUES1APId causeType cause"
     
     if {$operation == "send"} {
          set simType "HeNB"
          set paramList [list eNBUES1APId vENBUES1APId streamId mmeUEId]
          set HeNBId [getFromTestMap -HeNBIndex $HeNBIndex -param "HeNBId"]
     } else {
          set simType "MME"
          set paramList [list vENBUES1APId MMEUES1APId mStreamId mmeUEId]
          set MMEId  [getFromTestMap -MMEIndex $MMEIndex -param "MMEId"]
          
     }
     #Update the dynamic variables
     foreach dynElement {eNBUES1APId MMEUES1APId streamId ueid} param $paramList {
          
          if {![info exists $dynElement]} {
               if {$param == "streamId"} {
                    set streamId [expr $UEIndex + 1]
                    continue
               }
               if {[catch {set $dynElement [getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "$param"]}]} {
                    print -abort "Failed to get the param $param"
                    return 1
               }
          }
     }
     
     set gwIp   [getDataFromConfigFile "henbSignalingIpaddress" 0 ]
     set gwPort [getDataFromConfigFile "henbSctp" 0 ]

     # Check if the user has passed criticalityDiag
     if {[info exists criticalityDiag]} {
          set criticDiag [updateValAndExecute "getCriticDiag -criticalityDiag criticalityDiag \
                    -procedureCode procedureCode -triggerMsg triggerMsg -procedureCriticality procedureCriticality \
                    -IECriticality IECriticality -IEId IEId -typeOfError typeOfError"]
     }
     
     foreach mandIE $mandatoryIEs {
          if {[info exists mandIE]} {
               if {[set $mandIE] == ""} {unset $mandIE}
          }
     }

     foreach mandIE $missMandIe {
        unset $mandIE
     }

     set MultiS1Link $::ARR_LTE_TEST_PARAMS(MultiS1Link)

     
     if {[info exists causeType] && [info exists cause]} {
        set causeVal "\{$causeType=$cause\}"
     }

     if {$MultiS1Link == "yes"} {
        set enbID [getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "eNBId"]
     }    

     if { $operation == "send" || 1 } {
          set ueContextModificationFailure [ updateValAndExecute "constructS1Procedure -simType simType -msgName msgName \
                    -msgType msgType -HeNBId HeNBId -eNBUES1APId eNBUES1APId -MMEUES1APId MMEUES1APId -HeNBId HeNBId -MMEId MMEId \
                    -criticalityDiag criticDiag  -cause causeVal -streamId streamId -gwIp gwIp -gwPort gwPort "]
          
          array set arr_UEContextModificationFailure $ueContextModificationFailure
     }

     
     print -info "ueContextModificationFailure $ueContextModificationFailure "
     if {$execute == "no"} { return "$simType  $ueContextModificationFailure"}
     
     return [updateValAndExecute "sendOrVerifyS1APProcedure -msgName msgName -msgType msgType \
               -operation operation -msgList ueContextModificationFailure -simType simType \
               -HeNBIndex HeNBIndex -MMEIndex MMEIndex -enbID enbID"]
     
}

proc ueContextModificationResponse {args} {
     
     global  arr_UEContextModificationResponse_msg
     set msgName "ue_context_modification_response"
        
     set msgType "class1"
     set flag 0

     parseArgs args \
               [list \
               [list msgName                     optional   "string"    "ue_context_modification_response" "The message to be sent" ] \
               [list operation               optional   "send|(don't|)expect"    "send"              "send or expect option" ] \
               [list execute                 optional   "boolean"        "yes"   "To perform the operation or not. if no, will return the message"] \
               [list streamId                optional   "string"         "__UN_DEFINED__"    "The sctp string to send or receive data"] \
               [list eNBUES1APId          optional   "string"         "__UN_DEFINED__"    "eNB UE S1AP Id value" ] \
               [list MMEUES1APId          optional   "string"         "__UN_DEFINED__"    "MME UE S1AP Id value" ] \
               [list HeNBId                  optional   "string"      "__UN_DEFINED__"             "The heNBId param to be used in HeNB"] \
               [list MMEIndex                optional   "string"      "0"                          "Index of GUMMEI"] \
               [list HeNBIndex               optional   "string"         "0"                 "Index of GUMMEI"] \
               [list UEIndex                 optional   "string"         "0"                 "Index of GUMMEI"] \
               [list missMandIe              optional   "string"      "__UN_DEFINED__"             "Miss the mandatory IE" ] \
               [list mandatoryIEs            optional   "string"         ""                  "Miss the mandatory IE" ] \
               [list criticalityDiag      optional   "string"         "__UN_DEFINED__"             "The critical diag to be enabled or not"] \
               ]
    
     set mandatoryIEs "MMEUES1APId eNBUES1APId"
 
     if {$operation == "send"} {
          set simType "HeNB"
          set paramList [list eNBUES1APId vENBUES1APId streamId mmeUEId]
          set HeNBId [getFromTestMap -HeNBIndex $HeNBIndex -param "HeNBId"]
     } else {
          set simType "MME"
          set paramList [list vENBUES1APId MMEUES1APId mStreamId mmeUEId]
          set MMEId  [getFromTestMap -MMEIndex $MMEIndex -param "MMEId"]
          
     }
     #Update the dynamic variables
     foreach dynElement {eNBUES1APId MMEUES1APId streamId ueid} param $paramList {
          
          if {![info exists $dynElement]} {
               if {$param == "streamId"} {
                    set streamId [expr $UEIndex + 1]
                    continue
               }
               if {[catch {set $dynElement [getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "$param"]}]} {
                    print -abort "Failed to get the param $param"
                    return 1
               }
          }
     }
     
     set gwIp   [getDataFromConfigFile "henbSignalingIpaddress" 0 ]
     set gwPort [getDataFromConfigFile "henbSctp" 0 ]

     # Check if the user has passed criticalityDiag
     if {[info exists criticalityDiag]} {
          set criticDiag [updateValAndExecute "getCriticDiag -criticalityDiag criticalityDiag \
                    -procedureCode procedureCode -triggerMsg triggerMsg -procedureCriticality procedureCriticality \
                    -IECriticality IECriticality -IEId IEId -typeOfError typeOfError"]
     }
     
     foreach mandIE $mandatoryIEs {
          if {[info exists mandIE]} {
               if {[set $mandIE] == ""} {unset $mandIE}
          }
     }
 
     set MultiS1Link $::ARR_LTE_TEST_PARAMS(MultiS1Link)

     if {$MultiS1Link == "yes"} {
        set enbID [getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "eNBId"]
     }    

     if { $operation == "send"  || 1  } {
          set ueContextModificationResponse [ updateValAndExecute "constructS1Procedure -simType simType -msgName msgName \
                    -msgType msgType -HeNBId HeNBId -eNBUES1APId eNBUES1APId -MMEUES1APId MMEUES1APId -HeNBId HeNBId -MMEId MMEId -gwIp gwIp -gwPort gwPort \
                    -criticalityDiag criticDiag -streamId streamId"]
          
          array set arr_UEContextModificationResponse $ueContextModificationResponse
     }
     
     print -info "ueContextModificationResponse $ueContextModificationResponse"
     if {$execute == "no"} { return "$simType $traceFailureIndication"}
     
     return [updateValAndExecute "sendOrVerifyS1APProcedure -msgName msgName -msgType msgType \
               -operation operation -msgList ueContextModificationResponse -simType simType \
               -HeNBIndex HeNBIndex -MMEIndex MMEIndex -enbID enbID"]
}

proc ueContextModificationRequest {args} {
     
     #- This procedure is used to send and verify the ueContextModificationRequest message.
     #- @return 0 on success, @return -1 on failure
     
     global  arr_ueContextModificationRequest
     set secKey            "0e47818519f76cc13d8414ba08e0b48dc7405d46890334860a9c5083baf1446e"
     
     set msgName "ue_context_modification_request"
     set msgType "class1"
     set  flag 0
     
     parseArgs args \
               [list \
               [list msgName              optional   "string"    "ue_context_modification_request"                    "The message to be sent" ] \
               [list operation            optional   "send|(don't|)expect"    "send"              "send or expect option" ] \
               [list execute              optional   "boolean"        "yes"                        "To perform the operation or not. if no, will return the message"] \
               [list streamId                optional   "string"         "__UN_DEFINED__"    "The sctp string to send or receive data"] \
               [list eNBUES1APId          optional   "string"         "__UN_DEFINED__"    "eNB UE S1AP Id value" ] \
               [list MMEUES1APId          optional   "string"         "__UN_DEFINED__"    "MME UE S1AP Id value" ] \
               [list HeNBId               optional   "string"         "__UN_DEFINED__"             "The heNBId param to be used in HeNB"] \
               [list MMEIndex             optional   "string"         "0"                          "Index of GUMMEI"] \
               [list HeNBIndex            optional   "string"         "0"                 "Index of GUMMEI"] \
               [list UEIndex              optional   "string"         "0"                 "Index of GUMMEI"] \
               [list missMandIe           optional   "string"         "__UN_DEFINED__"             "Miss the mandatory IE" ] \
               [list securityKey          optional   "string"           "$secKey"           "The security key to be used" ] \
               [list SubscriberProfileId  optional   "numeric"          "__UN_DEFINED__"    "Defines the subscriber profile for RAT/Freq priority" ] \
               [list UEAggMaxBitRate      optional   "string"           "__UN_DEFINED__"               "The UE aggregate max bit rate" ] \
               [list UESecurityCap        optional   "string"           "__UN_DEFINED__"               "The UE security capability to be used" ] \
               [list CSFallInd            optional   "string"             "__UN_DEFINED__"      "Identifies the CS fallback indicator"] \
               [list CSGMembershipStatus  optional   "string"               "__UN_DEFINED__"    "Defines the CSG membership status" ] \
               [list LAI                  optional   "numeric"              "__UN_DEFINED__"                "Defines the registered LAI" ] \
               [list mandatoryIEs            optional   "string"         ""                  "Miss the mandatory IE" ] \
               ]

     set mandatoryIEs "MMEUES1APId eNBUES1APId"
     
     if {$operation == "send"} {
          set simType "MME"
          set paramList [list vENBUES1APId MMEUES1APId streamId mmeUEId]
          set MMEId  [getFromTestMap -MMEIndex $MMEIndex -param "MMEId"]
     } else {
          set simType "HeNB"
          set paramList [list eNBUES1APId vENBUES1APId mStreamId mmeUEId]
          set HeNBId [getFromTestMap -HeNBIndex $HeNBIndex -param "HeNBId"]
          
     }
     #Update the dynamic variables
     foreach dynElement {eNBUES1APId MMEUES1APId streamId ueid} param $paramList {
          
          if {![info exists $dynElement]} {
               if {$param == "streamId"} {
                    set streamId [expr $UEIndex + 1]
                    continue
               }
               if {[catch {set $dynElement [getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "$param"]}]} {
                    print -abort "Failed to get the param $param"
                    return 1
               }
          }
     }
     
     foreach structIE [list UEAggMaxBitRate UESecurityCap LAI] {
          if {[info exists $structIE]} {
               if {[set $structIE] != ""} {
                    switch -regexp $structIE {
                         "UEAggMaxBitRate" {set UEAggMaxBitRate [generateIEs -IEType "UEAggrBitRate" -paramIndices "1,1" -HeNBIndex $HeNBIndex -MMEIndex $MMEIndex]; }
                         "UESecurityCap"   {set UESecurityCap   [generateIEs -IEType "UESecCapability" -paramIndices $UESecurityCap -HeNBIndex $HeNBIndex -MMEIndex $MMEIndex]; }
                         "LAI"             {set LAI             [generateIEs -IEType "LAI" -paramIndices "1,1"  -HeNBIndex $HeNBIndex]; }
                    }
               }
          }
     }

     set gwIp   [getDataFromConfigFile "henbSignalingIpaddress" 0 ]
     set gwPort [getDataFromConfigFile "henbSctp" 0 ]

     foreach mandIE $mandatoryIEs {
          if {[info exists mandIE]} {
               if {[set $mandIE] == ""} {unset $mandIE}
          }
     }
     if { $operation == "send"  || 1  } {
          set ueContextModificationRequest [ updateValAndExecute "constructS1Procedure -simType simType -msgName msgName -msgType msgType -HeNBId HeNBId \
                    -eNBUES1APId eNBUES1APId -MMEUES1APId MMEUES1APId  -LAI LAI  -UEAggMaxBitRate UEAggMaxBitRate -CSFallInd CSFallbackInd \
                    -securityKey securityKey -UESecurityCap UESecurityCap  -subProfileIdForRAT SubscriberProfileId  -HeNBId HeNBId -MMEId MMEId \
                    -CSGMembershipStatus CSGMembershipStatus -streamId streamId -gwIp gwIp -gwPort gwPort "]
          
          array set arr_ueContextModificationRequest $ueContextModificationRequest
     }
     
     print -info "ueContextModificationRequest $ueContextModificationRequest"
     if {$execute == "no"} { return "$simType $ueContextModificationRequest "}
     
     return [updateValAndExecute "sendOrVerifyS1APProcedure -msgName msgName -msgType msgType \
               -operation operation -msgList ueContextModificationRequest -simType simType \
               -HeNBIndex HeNBIndex -MMEIndex MMEIndex"]
     
}


proc enbDirectInformationTransfer {args} {
     
     #- This procedure is used to send and verify the traceStart message.
     #- @return 0 on success, @return -1 on failure
     
     global  arr_cellTrafficTrace_msg
     
     set msgName "enb_direct_information_transfer"
     
     parseArgs args \
               [list \
               [list msgName              optional   "string"         "enb_direct_information_transfer"   "The message to be sent" ] \
               [list operation            optional   "send|(don't|)expect"    "send"       "send or expect option" ] \
               [list execute              optional   "boolean"        "yes"                "To perform the operation or not. if no, will return the message"] \
               [list streamId                optional   "string"         "0"    "The sctp string to send or receive data"] \
               [list HeNBId               optional   "string"         "__UN_DEFINED__"     "The heNBId param to be used in HeNB"] \
               [list MMEIndex             optional   "string"         "0"                  "Index of GUMMEI"] \
               [list HeNBIndex               optional   "string"         "0"                 "Index of GUMMEI"] \
               [list UEIndex                 optional   "string"         "0"                 "Index of GUMMEI"] \
               [list mandatoryIEs            optional   "string"         ""                  "Miss the mandatory IE" ] \
               [list interSystemInfoTransferTypeEDT   optional   "string"         "__UN_DEFINED__"                  "Index of GUMMEI"] \
               [list missMandIe           optional   "string"         "__UN_DEFINED__"     "Miss the mandatory IE" ] \
               ]
     
     if {$operation == "send"} {
          set simType "HeNB"
          set paramList [list streamId]
          set HeNBId [getFromTestMap -HeNBIndex $HeNBIndex -param "HeNBId"]
     } else {
          set simType "MME"
          set paramList [list mStreamId]
          set MMEId  [getFromTestMap -MMEIndex $MMEIndex -param "MMEId"]
          
     }

     if {0} {
     #Update the dynamic variables
     foreach dynElement {streamId} param $paramList {
          
          if {![info exists $dynElement]} {
               if {$param == "streamId"} {
                    set streamId [expr $UEIndex + 1]
                    continue
               }
               if {[catch {set $dynElement [getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "$param"]}]} {
                    print -abort "Failed to get the param $param"
                    return 1
               }
          }
     }
     }

     if (![info exists interSystemInfoTransferTypeEDT ]) {
          set interSystemInfoTransferTypeEDT [generateIEs -IEType "interSystemInfoTransferTypeEDT" -HeNBIndex $HeNBIndex -MMEIndex $MMEIndex]
     }
     foreach mandIE $mandatoryIEs {
          if {[info exists mandIE]} {
               if {[set $mandIE] == ""} {unset $mandIE}
          }
     }
     
     set gwIp   [getDataFromConfigFile "henbSignalingIpaddress" 0 ]
     set gwPort [getDataFromConfigFile "henbSctp" 0 ]

     if { $operation == "send" || 1 } {
          set enbDirectInformationTransfer [ updateValAndExecute "constructS1Procedure -simType simType -msgName msgName -msgType msgType -HeNBId HeNBId \
                      -streamId streamId -gwIp gwIp -gwPort gwPort -interSystemInfoTransferTypeEDT interSystemInfoTransferTypeEDT " ]
          
          array set arr_enbDirectInformationTransfer_msg $enbDirectInformationTransfer
     }
     
     print -info "enbDirectInformationTransfer $enbDirectInformationTransfer"
     if {$execute == "no"} { return "$simType $enbDirectInformationTransfer"}
     
     return [updateValAndExecute "sendOrVerifyS1APProcedure -msgName msgName -msgType msgType \
               -operation operation -msgList enbDirectInformationTransfer -simType simType \
               -HeNBIndex HeNBIndex -MMEIndex MMEIndex"]
}


proc mmeDirectInformationTransfer {args} {
     
     #- This procedure is used to send and verify the traceStart message.
     #- @return 0 on success, @return -1 on failure
     
     global  arr_mmeDirectInformationTransfer_msg
     
     set msgName "mme_direct_information_transfer"
     
     parseArgs args \
               [list \
               [list msgName              optional   "string"         "mme_direct_information_transfer"   "The message to be sent" ] \
               [list operation            optional   "send|(don't|)expect"    "send"       "send or expect option" ] \
               [list execute              optional   "boolean"        "yes"                "To perform the operation or not. if no, will return the message"] \
               [list streamId             optional   "string"         "0"                  "The sctp string to send or receive data"] \
               [list HeNBId               optional   "string"         "__UN_DEFINED__"     "The heNBId param to be used in HeNB"] \
               [list MMEIndex             optional   "string"         "0"                  "Index of GUMMEI"] \
               [list MMEd               optional   "string"         "__UN_DEFINED__"     "The heNBId param to be used in HeNB"] \
               [list HeNBIndex               optional   "string"         "0"                 "Index of GUMMEI"] \
               [list UEIndex                 optional   "string"         "0"                 "Index of GUMMEI"] \
               [list mandatoryIEs            optional   "string"         ""                  "Miss the mandatory IE" ] \
               [list interSystemInfoTransferTypeEDT   optional   "string"         "__UN_DEFINED__"                  "Index of GUMMEI"] \
               [list missMandIe           optional   "string"         "__UN_DEFINED__"     "Miss the mandatory IE" ] \
               ]
     
     if {$operation == "send"} {
          set simType "MME"
          set paramList [list vENBUES1APId MMEUES1APId streamId mmeUEId]
          set MMEId  [getFromTestMap -MMEIndex $MMEIndex -param "MMEId"]
     } else {
          set simType "HeNB"
          set paramList [list eNBUES1APId vENBUES1APId mStreamId mmeUEId]
          set HeNBId [getFromTestMap -HeNBIndex $HeNBIndex -param "HeNBId"]
          
     }

     if {0} {
     #Update the dynamic variables
     foreach dynElement {eNBUES1APId MMEUES1APId streamId ueid} param $paramList {
          
          if {![info exists $dynElement]} {
               if {$param == "streamId"} {
                    set streamId [expr $UEIndex + 1]
                    continue
               }
               if {[catch {set $dynElement [getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "$param"]}]} {
                    print -abort "Failed to get the param $param"
                    return 1
               }
          }
     }
     }

     if (![info exists interSystemInfoTransferTypeEDT ]) {
          set interSystemInfoTransferTypeEDT [generateIEs -IEType "interSystemInfoTransferTypeEDT" -HeNBIndex $HeNBIndex -MMEIndex $MMEIndex]
     }
     foreach mandIE $mandatoryIEs {
          if {[info exists mandIE]} {
               if {[set $mandIE] == ""} {unset $mandIE}
          }
     }
     
     if { $operation == "send" || 1 } {
          set mmeDirectInformationTransfer [ updateValAndExecute "constructS1Procedure -simType simType -msgName msgName -msgType msgType \
                                                    -interSystemInfoTransferTypeEDT interSystemInfoTransferTypeEDT \
                                                    -streamId streamId -HeNBId HeNBId -MMEId MMEId -gwIp gwIp -gwPort gwPort" ]
          
          array set arr_mmeDirectInformationTransfer_msg $mmeDirectInformationTransfer
     }
     
     print -info "mmeDirectInformationTransfer $mmeDirectInformationTransfer"
     if {$execute == "no"} { return "$simType $mmeDirectInformationTransfer"}
     
     return [updateValAndExecute "sendOrVerifyS1APProcedure -msgName msgName -msgType msgType \
               -operation operation -msgList mmeDirectInformationTransfer -simType simType \
               -HeNBIndex HeNBIndex -MMEIndex MMEIndex"]
}


proc downlinkNonUEAssociatedLPPaTransport {args} {
     
     #- This procedure is used to send and verify the traceStart message.
     #- @return 0 on success, @return -1 on failure
     
     global  arr_downlinkNonUEAssociatedLPPaTransport_msg
     
     set msgName "downlink_non_ue_associated_lppa_transport" 
     set lppapdufieldval "00020000001C000003000200010000030001000005000B04000B000100000B00010C" 
     
     parseArgs args \
               [list \
               [list msgName                  optional   "string"         "downlink_non_ue_associated_lppa_transport"    "The message to be sent" ] \
               [list operation            optional   "send|(don't|)expect"    "send"       "send or expect option" ] \
               [list execute              optional   "boolean"        "yes"                "To perform the operation or not. if no, will return the message"] \
               [list streamId             optional   "string"         "0"                  "The sctp string to send or receive data"] \
               [list HeNBId               optional   "string"         "__UN_DEFINED__"     "The heNBId param to be used in HeNB"] \
               [list MMEIndex             optional   "string"         "0"                  "Index of GUMMEI"] \
               [list MMEd               optional   "string"         "__UN_DEFINED__"     "The heNBId param to be used in HeNB"] \
               [list HeNBIndex               optional   "string"         "0"                 "Index of GUMMEI"] \
               [list UEIndex                 optional   "string"         "0"                 "Index of GUMMEI"] \
               [list mandatoryIEs            optional   "string"         ""                  "Miss the mandatory IE" ] \
               [list routingId            optional   "string"         "10"                  "Index of GUMMEI"] \
               [list lppaPdu              optional   "string"         "$lppapdufieldval"    "Index of GUMMEI"] \
               [list missMandIe           optional   "string"         "__UN_DEFINED__"     "Miss the mandatory IE" ] \
               ]
     
     if {$operation == "send"} {
          set simType "MME"
          set paramList [list vENBUES1APId MMEUES1APId streamId mmeUEId]
          set MMEId  [getFromTestMap -MMEIndex $MMEIndex -param "MMEId"]
     } else {
          set simType "HeNB"
          set paramList [list eNBUES1APId vENBUES1APId mStreamId mmeUEId]
          set HeNBId [getFromTestMap -HeNBIndex $HeNBIndex -param "HeNBId"]
     }
     
     if {0} { 
     #Update the dynamic variables
     foreach dynElement {eNBUES1APId MMEUES1APId streamId ueid} param $paramList {
          
          if {![info exists $dynElement]} {
               if {$param == "streamId"} {
                    set streamId [expr $UEIndex + 1]
                    continue
               }
               if {[catch {set $dynElement [getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "$param"]}]} {
                    print -abort "Failed to get the param $param"
                    return 1
               }
          }
     }
     }
     
     set gwIp   [getDataFromConfigFile "henbSignalingIpaddress" 0 ]
     set gwPort [getDataFromConfigFile "henbSctp" 0 ]

     foreach mandIE $mandatoryIEs {
          if {[info exists mandIE]} {
               if {[set $mandIE] == ""} {unset $mandIE}
          }
     }
     
     if { $operation == "send" || 1 } {
          set downlinkNonUEAssociatedLPPaTransport [ updateValAndExecute "constructS1Procedure -simType simType -msgName msgName -msgType msgType -HeNBId HeNBId \
                    -HeNBId HeNBId -MMEId MMEId -streamId streamId -gwIp gwIp -gwPort gwPort -routingId routingId -lppaPdu lppaPdu" ]
          
          array set arr_downlinkNonUEAssociatedLPPaTransport_msg $downlinkNonUEAssociatedLPPaTransport
     }
     
     print -info "downlinkNonUEAssociatedLPPaTransport $downlinkNonUEAssociatedLPPaTransport"
     if {$execute == "no"} { return "$simType $downlinkNonUEAssociatedLPPaTransport"}
     
     return [updateValAndExecute "sendOrVerifyS1APProcedure -msgName msgName -msgType msgType \
               -operation operation -msgList downlinkNonUEAssociatedLPPaTransport -simType simType \
               -HeNBIndex HeNBIndex -MMEIndex MMEIndex"]
}

proc downlinkUEAssociatedLPPaTransport {args} {
     
     #- This procedure is used to send and verify the traceStart message.
     #- @return 0 on success, @return -1 on failure
     
     global  arr_downlinkUEAssociatedLPPaTransport_msg
     
     set msgName "downlink_ue_associated_lppa_transport"
     set msgType "class2"
     set flag 0
     
     parseArgs args \
               [list \
               [list msgName              optional   "string"         "downlink_ue_associated_lppa_transport"   "The message to be sent" ] \
               [list operation            optional   "send|(don't|)expect"    "send"       "send or expect option" ] \
               [list execute              optional   "boolean"        "yes"                "To perform the operation or not. if no, will return the message"] \
               [list streamId             optional   "string"         "__UN_DEFINED__"     "The sctp string to send or receive data"] \
               [list HeNBId               optional   "string"         "__UN_DEFINED__"     "The heNBId param to be used in HeNB"] \
               [list MMEIndex             optional   "string"         "0"                  "Index of GUMMEI"] \
               [list MMEd               optional   "string"         "__UN_DEFINED__"     "The heNBId param to be used in HeNB"] \
               [list HeNBIndex               optional   "string"         "0"                 "Index of GUMMEI"] \
               [list UEIndex                 optional   "string"         "0"                 "Index of GUMMEI"] \
               [list mandatoryIEs            optional   "string"         ""                  "Miss the mandatory IE" ] \
               [list routingId            optional   "string"         "10"                  "Index of GUMMEI"] \
               [list lppaPdu              optional   "string"         "0a"                  "Index of GUMMEI"] \
               [list missMandIe           optional   "string"         ""     "Miss the mandatory IE" ] \
               ]

     set lppaPdu "00020000001C000003000200010000030001000005000B04000B000100000B00010C"

     set mandatoryIEs "eNBUES1APId MMEUES1APId routingId lppaPdu"
     
     if {$operation == "send"} {
          set simType "MME"
          set paramList [list vENBUES1APId MMEUES1APId streamId mmeUEId]
          set MMEId  [getFromTestMap -MMEIndex $MMEIndex -param "MMEId"]
     } else {
          set simType "HeNB"
          set paramList [list eNBUES1APId vENBUES1APId mStreamId mmeUEId]
          set HeNBId [getFromTestMap -HeNBIndex $HeNBIndex -param "HeNBId"]
     }
     
     #Update the dynamic variables
     foreach dynElement {eNBUES1APId MMEUES1APId streamId ueid} param $paramList {
          
          if {![info exists $dynElement]} {
               if {$param == "streamId"} {
                    set streamId [expr $UEIndex + 1]
                    continue
               }
               if {[catch {set $dynElement [getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "$param"]}]} {
                    print -abort "Failed to get the param $param"
                    return 1
               }
          }
     }
     
     set gwIp   [getDataFromConfigFile "henbSignalingIpaddress" 0 ]
     set gwPort [getDataFromConfigFile "henbSctp" 0 ]

     foreach mandIE $mandatoryIEs {
          if {[info exists mandIE]} {
               if {[set $mandIE] == ""} {unset $mandIE}
          }
     }
    
     foreach mandIE $missMandIe {
               unset $mandIE
          }
 
     if { $operation == "send" || 1  } {
          set downlinkUEAssociatedLPPaTransport [ updateValAndExecute "constructS1Procedure -simType simType -msgName msgName -msgType msgType -HeNBId HeNBId \
                   -HeNBId HeNBId -MMEId MMEId -gwIp gwIp -gwPort gwPort -streamId streamId -routingId routingId -lppaPdu lppaPdu -eNBUES1APId eNBUES1APId -MMEUES1APId MMEUES1APId " ]
          
          array set arr_downlinkUEAssociatedLPPaTransport_msg $downlinkUEAssociatedLPPaTransport
     }
     
     print -info "downlinkUEAssociatedLPPaTransport $downlinkUEAssociatedLPPaTransport"
     if {$execute == "no"} { return "$simType $downlinkUEAssociatedLPPaTransport"}
     
     return [updateValAndExecute "sendOrVerifyS1APProcedure -msgName msgName -msgType msgType \
               -operation operation -msgList downlinkUEAssociatedLPPaTransport -simType simType \
               -HeNBIndex HeNBIndex -MMEIndex MMEIndex"]
}

proc uplinkNonUEAssociatedLPPaTransport {args} {
     
     #- This procedure is used to send and verify the traceStart message.
     #- @return 0 on success, @return -1 on failure
     
     global  arr_uplinkNonUEAssociatedLPPaTransport_msg
     
     set msgName "uplink_non_ue_associated_lppa_transport"
     
     parseArgs args \
               [list \
               [list msgName                  optional   "string"         "uplink_non_ue_associated_lppa_transport"   "The message to be sent" ] \
               [list operation            optional   "send|(don't|)expect"    "send"       "send or expect option" ] \
               [list execute              optional   "boolean"        "yes"                "To perform the operation or not. if no, will return the message"] \
               [list streamId             optional   "string"         "0"                  "The sctp string to send or receive data"] \
               [list HeNBId               optional   "string"         "__UN_DEFINED__"     "The heNBId param to be used in HeNB"] \
               [list MMEIndex             optional   "string"         "0"                  "Index of GUMMEI"] \
               [list MMEd               optional   "string"         "__UN_DEFINED__"     "The heNBId param to be used in HeNB"] \
               [list HeNBIndex               optional   "string"         "0"                 "Index of GUMMEI"] \
               [list UEIndex                 optional   "string"         "0"                 "Index of GUMMEI"] \
               [list mandatoryIEs            optional   "string"         ""                  "Miss the mandatory IE" ] \
               [list routingId            optional   "string"         "10"                  "Index of GUMMEI"] \
               [list lppaPdu              optional   "string"         "0a"                  "Index of GUMMEI"] \
               [list missMandIe           optional   "string"         "__UN_DEFINED__"     "Miss the mandatory IE" ] \
               ]
     
     if {$operation == "send"} {
          set simType "HeNB"
          set paramList [list eNBUES1APId vENBUES1APId streamId mmeUEId]
          set HeNBId [getFromTestMap -HeNBIndex $HeNBIndex -param "HeNBId"]
     } else {
          set simType "MME"
          set paramList [list vENBUES1APId MMEUES1APId mStreamId mmeUEId]
          set MMEId  [getFromTestMap -MMEIndex $MMEIndex -param "MMEId"]
     }
     
     set gwIp   [getDataFromConfigFile "henbSignalingIpaddress" 0 ]
     set gwPort [getDataFromConfigFile "henbSctp" 0 ]

     if {0} {
     #Update the dynamic variables
     foreach dynElement {eNBUES1APId MMEUES1APId streamId ueid} param $paramList {
          
          if {![info exists $dynElement]} {
               if {$param == "streamId"} {
                    set streamId [expr $UEIndex + 1]
                    continue
               }
               if {[catch {set $dynElement [getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "$param"]}]} {
                    print -abort "Failed to get the param $param"
                    return 1
               }
          }
     }
     }
     
     foreach mandIE $mandatoryIEs {
          if {[info exists mandIE]} {
               if {[set $mandIE] == ""} {unset $mandIE}
          }
     }
     
     if { $operation == "send" || 1 } {
          set uplinkNonUEAssociatedLPPaTransport [ updateValAndExecute "constructS1Procedure -simType simType -msgName msgName -msgType msgType -HeNBId HeNBId \
                  -HeNBId HeNBId -MMEId MMEId -streamId streamId -gwIp gwIp -gwPort gwPort  -routingId routingId -lppaPdu lppaPdu" ]
          
          array set arr_uplinkNonUEAssociatedLPPaTransport_msg $uplinkNonUEAssociatedLPPaTransport
     }
     
     print -info "uplinkNonUEAssociatedLPPaTransport $uplinkNonUEAssociatedLPPaTransport"
     if {$execute == "no"} { return "$simType $uplinkNonUEAssociatedLPPaTransport"}
     
     return [updateValAndExecute "sendOrVerifyS1APProcedure -msgName msgName -msgType msgType \
               -operation operation -msgList uplinkNonUEAssociatedLPPaTransport -simType simType \
               -HeNBIndex HeNBIndex -MMEIndex MMEIndex"]
}

proc uplinkUEAssociatedLPPaTransport {args} {
     
     #- This procedure is used to send and verify the traceStart message.
     #- @return 0 on success, @return -1 on failure
     
     global  arr_uplinkUEAssociatedLPPaTransport_msg
     
     set msgName "uplink_ue_associated_lppa_transport"
     set msgType "class2"
      set flag 0
     
     parseArgs args \
               [list \
               [list msgName              optional   "string"         "uplink_ue_associated_lppa_transport"   "The message to be sent" ] \
               [list operation            optional   "send|(don't|)expect"    "send"       "send or expect option" ] \
               [list execute              optional   "boolean"        "yes"                "To perform the operation or not. if no, will return the message"] \
               [list streamId             optional   "string"         "__UN_DEFINED__"     "The sctp string to send or receive data"] \
               [list HeNBId               optional   "string"         "__UN_DEFINED__"     "The heNBId param to be used in HeNB"] \
               [list MMEIndex             optional   "string"         "0"                  "Index of GUMMEI"] \
               [list MMEd               optional   "string"         "__UN_DEFINED__"     "The heNBId param to be used in HeNB"] \
               [list HeNBIndex               optional   "string"         "0"                 "Index of GUMMEI"] \
               [list UEIndex                 optional   "string"         "0"                 "Index of GUMMEI"] \
               [list mandatoryIEs            optional   "string"         ""                  "Miss the mandatory IE" ] \
               [list routingId            optional   "string"         "10"                  "Index of GUMMEI"] \
               [list lppaPdu              optional   "string"         "0a"                  "Index of GUMMEI"] \
               [list missMandIe           optional   "string"         ""     "Miss the mandatory IE" ] \
               ]

     set lppaPdu "00020000001C000003000200010000030001000005000B04000B000100000B00010C"

     set mandatoryIEs "eNBUES1APId MMEUES1APId routingId lppaPdu"
     
     if {$operation == "send"} {
          set simType "HeNB"
          set paramList [list eNBUES1APId vENBUES1APId streamId mmeUEId]
          set HeNBId [getFromTestMap -HeNBIndex $HeNBIndex -param "HeNBId"]
     } else {
          set simType "MME"
          set paramList [list vENBUES1APId MMEUES1APId mStreamId mmeUEId]
          set MMEId  [getFromTestMap -MMEIndex $MMEIndex -param "MMEId"]
     }
     
     set gwIp   [getDataFromConfigFile "henbSignalingIpaddress" 0 ]
     set gwPort [getDataFromConfigFile "henbSctp" 0 ]

     #Update the dynamic variables
     foreach dynElement {eNBUES1APId MMEUES1APId streamId ueid} param $paramList {
          
          if {![info exists $dynElement]} {
               if {$param == "streamId"} {
                    set streamId [expr $UEIndex + 1]
                    continue
               }
               if {[catch {set $dynElement [getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "$param"]}]} {
                    print -abort "Failed to get the param $param"
                    return 1
               }
          }
     }
     
     foreach mandIE $mandatoryIEs {
          if {[info exists mandIE]} {
               if {[set $mandIE] == ""} {unset $mandIE}
          }
     }

     foreach mandIE $missMandIe {
               unset $mandIE
          }

     
     if { $operation == "send" || 1 } {
          set uplinkUEAssociatedLPPaTransport [ updateValAndExecute "constructS1Procedure -simType simType -msgName msgName -msgType msgType -HeNBId HeNBId \
          -streamId streamId -HeNBId HeNBId -MMEId MMEId -gwIp gwIp -gwPort gwPort  -routingId routingId -lppaPdu lppaPdu -eNBUES1APId eNBUES1APId -MMEUES1APId MMEUES1APId " ]
          
          array set arr_uplinkUEAssociatedLPPaTransport_msg $uplinkUEAssociatedLPPaTransport
     }
     
     print -info "uplinkUEAssociatedLPPaTransport $uplinkUEAssociatedLPPaTransport"
     if {$execute == "no"} { return "$simType $uplinkUEAssociatedLPPaTransport"}
     
     return [updateValAndExecute "sendOrVerifyS1APProcedure -msgName msgName -msgType msgType \
               -operation operation -msgList uplinkUEAssociatedLPPaTransport -simType simType \
               -HeNBIndex HeNBIndex -MMEIndex MMEIndex"]
}


proc cellTrafficTrace {args} {
     
     #- This procedure is used to send and verify the traceStart message.
     #- @return 0 on success, @return -1 on failure
     
     global  arr_cellTrafficTrace_msg
     
     set msgName "cell_traffic_trace"
     
     parseArgs args \
               [list \
               [list msgName                  optional   "string"         "cell_traffic_trace"   "The message to be sent" ] \
               [list operation            optional   "send|(don't|)expect"    "send"       "send or expect option" ] \
               [list execute              optional   "boolean"        "yes"                "To perform the operation or not. if no, will return the message"] \
               [list streamId             optional   "string"         "__UN_DEFINED__"     "The sctp string to send or receive data"] \
               [list eNBUES1APId          optional   "string"         "__UN_DEFINED__"     "eNB UE S1AP Id value" ] \
               [list MMEUES1APId          optional   "string"         "__UN_DEFINED__"     "MME UE S1AP Id value" ] \
               [list HeNBId               optional   "string"         "__UN_DEFINED__"     "The heNBId param to be used in HeNB"] \
               [list eUtranTraceId        optional   "string"         "0"                          "Index of GUMMEI"] \
               [list MMEIndex             optional   "string"         "0"                  "Index of GUMMEI"] \
               [list HeNBIndex               optional   "string"         "0"                 "Index of GUMMEI"] \
               [list UEIndex                 optional   "string"         "0"                 "Index of GUMMEI"] \
               [list mandatoryIEs            optional   "string"         ""                  "Miss the mandatory IE" ] \
               [list eCGI                 optional   "string"         "0,0"                "e-UTRAN CGI chosen from UE" ] \
               [list traceCollectionEntityIPAddress                 optional   "string"         "01010101"      "e-UTRAN CGI chosen from UE" ] \
               [list missMandIe           optional   "string"         "__UN_DEFINED__"     "Miss the mandatory IE" ] \
               ]
     
     if {$operation == "send"} {
          set simType "HeNB"
          set paramList [list eNBUES1APId vENBUES1APId streamId mmeUEId]
          set HeNBId [getFromTestMap -HeNBIndex $HeNBIndex -param "HeNBId"]
     } else {
          set simType "MME"
          set paramList [list vENBUES1APId MMEUES1APId mStreamId mmeUEId]
          set MMEId  [getFromTestMap -MMEIndex $MMEIndex -param "MMEId"]
     }
     #Update the dynamic variables
     foreach dynElement {eNBUES1APId MMEUES1APId streamId ueid} param $paramList {
          
          if {![info exists $dynElement]} {
               if {$param == "streamId"} {
                    set streamId [expr $UEIndex + 1]
                    continue
               }
               if {[catch {set $dynElement [getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "$param"]}]} {
                    print -abort "Failed to get the param $param"
                    return 1
               }
          }
     }
    
     set traceCollectionEntityIPAddress "01010101" 
     set eCGI [generateIEs -IEType "eCGI" -paramIndices $eCGI -HeNBIndex $HeNBIndex -MMEIndex $MMEIndex -UEIndex $UEIndex]
     set gwIp   [getDataFromConfigFile "henbSignalingIpaddress" 0 ]
     set gwPort [getDataFromConfigFile "henbSctp" 0 ]
     
     foreach mandIE $mandatoryIEs {
          if {[info exists mandIE]} {
               unset $mandIE
          }
     }
     
     if { $operation == "send" || 1 } {
          set cellTrafficTrace [ updateValAndExecute "constructS1Procedure -simType simType -msgName msgName -msgType msgType \
                                                     -HeNBId HeNBId -eNBUES1APId eNBUES1APId -MMEUES1APId MMEUES1APId -ueid ueid \
                                                     -eUtranTraceId eUtranTraceId -eCGI eCGI -gwIp gwIp -gwPort gwPort \
                                                     -traceCollectionEntityIPAddress traceCollectionEntityIPAddress -streamId streamId" ] 
          
          array set arr_cellTrafficTrace_msg $cellTrafficTrace
     }
     
     print -info "cellTrafficTrace $cellTrafficTrace"
     if {$execute == "no"} { return "$simType $cellTrafficTrace"}
     
     return [updateValAndExecute "sendOrVerifyS1APProcedure -msgName msgName -msgType msgType \
               -operation operation -msgList cellTrafficTrace -simType simType \
               -HeNBIndex HeNBIndex -MMEIndex MMEIndex"]
}


proc downlinkS1cdma2000tunneling {args} {
     
     #- This procedure is used to send and verify the ueContextModificationRequest message.
     #- @return 0 on success, @return -1 on failure
     
     # cdma2000HOStatus = hOSuccess
     # Cdma2000RATType = onexRTT
     # Cdma2000PDU = 10101010101010101
     
     global  arr_downlink_s1_cdma2000_tunneling_msg
     
     set msgName "downlink_s1_cdma2000_tunneling"
     set msgType "class2"
     
     parseArgs args \
               [list \
               [list msgName                 optional   "string"    "downlink_s1_cdma2000_tunneling"  "The message to be sent" ] \
               [list operation               optional   "send|(don't|)expect"    "send"      "send or expect option" ] \
               [list execute                 optional   "boolean"        "yes"               "To perform the operation or not. if no, will return the message"] \
               [list streamId                optional   "string"         "__UN_DEFINED__"     "The sctp string to send or receive data"] \
               [list eNBUES1APId             optional   "string"         "__UN_DEFINED__"    "eNB UE S1AP Id value" ] \
               [list MMEUES1APId             optional   "string"         "__UN_DEFINED__"    "MME UE S1AP Id value" ] \
               [list MMEIndex                optional   "string"         "0"                 "Index of GUMMEI"] \
               [list HeNBIndex               optional   "string"         "0"                 "Index of GUMMEI"] \
               [list UEIndex                 optional   "string"         "0"                 "Index of GUMMEI"] \
               [list cdma2000HOStatus        optional   "string"         "hOSuccess"         "Index of GUMMEI"] \
               [list cdma2000RATType         optional   "string"         "onexRTT"           "Index of GUMMEI"] \
               [list cdma2000PDU             optional   "string"         "01" "Index of GUMMEI"] \
               [list mandatoryIEs            optional   "string"         ""                  "Miss the mandatory IE" ] \
	       [list missMandIe           optional   "string"         ""     "Miss the mandatory IE" ] \
               ]
     
     set mandatoryIEs "eNBUES1APId MMEUES1APId cdma2000RATType cdma2000PDU"
     
     if {$operation == "send"} {
          set simType "MME"
          set paramList [list vENBUES1APId MMEUES1APId streamId mmeUEId]
          set MMEId  [getFromTestMap -MMEIndex $MMEIndex -param "MMEId"]
     } else {
          set simType "HeNB"
          set paramList [list eNBUES1APId vENBUES1APId mStreamId mmeUEId]
          set HeNBId [getFromTestMap -HeNBIndex $HeNBIndex -param "HeNBId"]
          
     }
     #Update the dynamic variables
     foreach dynElement {eNBUES1APId MMEUES1APId streamId ueid} param $paramList {
          
          if {![info exists $dynElement]} {
               if {$param == "streamId"} {
                    set streamId [expr $UEIndex + 1]
                    continue
               }
               if {[catch {set $dynElement [getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "$param"]}]} {
                    print -abort "Failed to get the param $param"
                    return 1
               }
          }
     }
     
     set eRabSubDataFwdList [generateIEs -IEType "eRABSubjecttoDataForwardingList" -paramIndices "0,0" -HeNBIndex $HeNBIndex -MMEIndex $MMEIndex -UEIndex $UEIndex]
     
     set gwIp   [getDataFromConfigFile "henbSignalingIpaddress" 0 ]
     set gwPort [getDataFromConfigFile "henbSctp" 0 ]
     
     foreach mandIE $mandatoryIEs {
          if {[info exists mandIE]} {
               if {[set $mandIE] == ""} {unset $mandIE}
          }
     }

     # For checking missing erabid (mandatory) in side an optional IE 
     set erabid ""
     if ([regexp -nocase "erabId" $missMandIe]) {
                if (![regsub "e_RAB_ID=\[0-9\]+" $eRabSubDataFwdList "" eRabSubDataFwdList]) {
                        print -error "Cannot delete the ERAB ID from eRabSubDataFwdList"
                }
     }

     foreach mandIE $missMandIe {
               if ([info exists mandIE]) { unset $mandIE }
          }


     if { $operation == "send"  || 1 } {
          set downlinkS1cdma2000tunneling [ updateValAndExecute "constructS1Procedure -simType simType -msgName msgName -msgType msgType -HeNBId HeNBId \
                    -HeNBId HeNBId -MMEId MMEId -gwIp gwIp -gwPort gwPort  -eNBUES1APId eNBUES1APId -MMEUES1APId MMEUES1APId -streamId streamId\
                    -eRabSubDataFwdList eRabSubDataFwdList -cdma2000HOStatus cdma2000HOStatus -cdma2000RATType cdma2000RATType -cdma2000PDU cdma2000PDU"  ]
          
          array set arr_downlinkS1cdma2000tunneling_msg $downlinkS1cdma2000tunneling
     }
     
     print -info "downlinkS1cdma2000tunneling $downlinkS1cdma2000tunneling"
     if {$execute == "no"} { return "$simType $downlinkS1cdma2000tunneling" }
     
     return [updateValAndExecute "sendOrVerifyS1APProcedure -msgName msgName -msgType msgType \
               -operation operation -msgList downlinkS1cdma2000tunneling -simType simType \
               -HeNBIndex HeNBIndex -MMEIndex MMEIndex"]
}

proc uplinkS1cdma2000tunneling {args} {
     
     #- This procedure is used to send and verify the ueContextModificationRequest message.
     #- @return 0 on success, @return -1 on failure
     
     # cdma2000HOStatus = hOSuccess
     # Cdma2000RATType = onexRTT
     # Cdma2000PDU = 10101010101010101
     
     global  arr_uplink_s1_cdma2000_tunneling_msg
     
     set msgName "uplink_s1_cdma2000_tunneling"
     set msgType "class2"
     
     parseArgs args \
               [list \
               [list msgName                 optional   "string"    "uplink_s1_cdma2000_tunneling"  "The message to be sent" ] \
               [list operation               optional   "send|(don't|)expect"    "send"      "send or expect option" ] \
               [list execute                 optional   "boolean"        "yes"               "To perform the operation or not. if no, will return the message"] \
               [list streamId                optional   "string"         "__UN_DEFINED__"     "The sctp string to send or receive data"] \
               [list eNBUES1APId             optional   "string"         "__UN_DEFINED__"    "eNB UE S1AP Id value" ] \
               [list MMEUES1APId             optional   "string"         "__UN_DEFINED__"    "MME UE S1AP Id value" ] \
               [list MMEIndex                optional   "string"         "0"                 "Index of GUMMEI"] \
               [list HeNBIndex               optional   "string"         "0"                 "Index of GUMMEI"] \
               [list UEIndex                 optional   "string"         "0"                 "Index of GUMMEI"] \
               [list cdma2000SectorID        optional   "string"         "01"         "Index of GUMMEI"] \
               [list cdma2000RATType         optional   "string"         "onexRTT"           "Index of GUMMEI"] \
               [list cdma2000HOReqInd        optional   "string"         "true"           "Index of GUMMEI"] \
               [list cdma2000PDU             optional   "string"         "01" "Index of GUMMEI"] \
               [list cdma2000OneXRAND        optional   "string"         "01" "Index of GUMMEI"] \
               [list eutranRounddTripDelay   optional   "string"         "1"                 "Index of GUMMEI"] \
               [list cdma2000OneXSRVCCInfo   optional   "string"         "1"                 "Index of GUMMEI"] \
               [list mandatoryIEs            optional   "string"         ""                  "Miss the mandatory IE" ] \
               [list missMandIe              optional   "string"         ""                  "Miss the mandatory IE" ] \
               ]
     
     #cdma2000RATType=<enum>
     #cdma2000SectorID=<hex>
     #cdma2000HORequiredIndication=<enum>
     #cdma2000OneXSRVCCInfo={
     #  cdma2000OneXMEID=<hex>
     #  cdma2000OneXMSI=<hex>
     #  cdma2000OneXPilot=<hex>
     #}
     #cdma2000OneXRAND=<hex>
     #cdma2000PDU=<hex>
     #eUTRANRoundTripDelayEstimationInfo=<int>
    
     set mandatoryIEs "eNBUES1APId MMEUES1APId cdma2000RATType cdma2000SectorID cdma2000PDU"
 
     if {$operation == "send"} {
          set simType "HeNB"
          set paramList [list eNBUES1APId vENBUES1APId streamId mmeUEId]
          set HeNBId [getFromTestMap -HeNBIndex $HeNBIndex -param "HeNBId"]
     } else {
          set simType "MME"
          set paramList [list vENBUES1APId MMEUES1APId mStreamId mmeUEId]
          set MMEId  [getFromTestMap -MMEIndex $MMEIndex -param "MMEId"]
          
     }
     #Update the dynamic variables
     foreach dynElement {eNBUES1APId MMEUES1APId streamId ueid} param $paramList {
          
          if {![info exists $dynElement]} {
               if {$param == "streamId"} {
                    set streamId [expr $UEIndex + 1]
                    continue
               }
               if {[catch {set $dynElement [getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "$param"]}]} {
                    print -abort "Failed to get the param $param"
                    return 1
               }
          }
     }
     
#     set cdma2000OneXSRVCCInfo [generateIEs -IEType "cdma2000OneXSRVCCInfo" -paramIndices "0,0" -HeNBIndex $HeNBIndex -MMEIndex $MMEIndex -UEIndex $UEIndex]

     set gwIp   [getDataFromConfigFile "henbSignalingIpaddress" 0 ]
     set gwPort [getDataFromConfigFile "henbSctp" 0 ]
     
     foreach mandIE $mandatoryIEs {
          if {[info exists mandIE]} {
               if {[set $mandIE] == ""} {unset $mandIE}
          }
     }

     foreach mandIE $missMandIe {
               unset $mandIE
     }

     if { $operation == "send"  || 1 } {
          set uplinkS1cdma2000tunneling [ updateValAndExecute "constructS1Procedure -simType simType -msgName msgName -msgType msgType -HeNBId HeNBId \
                    -HeNBId HeNBId -MMEId MMEId -gwIp gwIp -gwPort gwPort  -eNBUES1APId eNBUES1APId -MMEUES1APId MMEUES1APId -streamId streamId\
                    -cdma2000HOStatus cdma2000HOStatus -cdma2000RATType cdma2000RATType -cdma2000PDU cdma2000PDU  -cdma2000SectorID cdma2000SectorID \
                    -cdma2000HOReqInd cdma2000HOReqInd -cdma2000OneXRAND cdma2000OneXRAND -eutranRounddTripDelay eutranRounddTripDelay"  ]
          
          array set arr_uplinkS1cdma2000tunneling_msg $uplinkS1cdma2000tunneling
     }
     
     print -info "uplinkS1cdma2000tunneling $uplinkS1cdma2000tunneling"
     if {$execute == "no"} { return "$simType $uplinkS1cdma2000tunneling" }
     
     return [updateValAndExecute "sendOrVerifyS1APProcedure -msgName msgName -msgType msgType \
               -operation operation -msgList uplinkS1cdma2000tunneling -simType simType \
               -HeNBIndex HeNBIndex -MMEIndex MMEIndex"]
     
}


proc ueCapabilityInfoIndication {args} {
     
     #- This procedure is used to send and verify the traceStart message.
     #- @return 0 on success, @return -1 on failure
     
     global  arr_ueCapabilityInfoIndication_msg
     
     set msgName "ue_capability_info_indication"
     set msgType "class2"
     set flag 0
     
     parseArgs args \
               [list \
               [list msgName              optional   "string"         "ue_capability_info_indication"   "The message to be sent" ] \
               [list operation            optional   "send|(don't|)expect"    "send"       "send or expect option" ] \
               [list execute              optional   "boolean"        "yes"                "To perform the operation or not. if no, will return the message"] \
               [list streamId             optional   "string"         "__UN_DEFINED__"     "The sctp string to send or receive data"] \
               [list HeNBId               optional   "string"         "__UN_DEFINED__"     "The heNBId param to be used in HeNB"] \
               [list MMEIndex             optional   "string"         "0"                  "Index of GUMMEI"] \
               [list HeNBIndex            optional   "string"         "0"                 "Index of GUMMEI"] \
               [list UEIndex              optional   "string"         "0"                 "Index of GUMMEI"] \
               [list mandatoryIEs         optional   "string"         ""                  "Miss the mandatory IE" ] \
               [list uERadioCapability    optional   "string"         "10101010"                  "Index of GUMMEI"] \
	       [list missMandIe           optional   "string"         ""     "Miss the mandatory IE" ] \
               ]
     
     if {$operation == "send"} {
          set simType "HeNB"
          set paramList [list eNBUES1APId vENBUES1APId streamId mmeUEId]
          set HeNBId [getFromTestMap -HeNBIndex $HeNBIndex -param "HeNBId"]
     } else {
          set simType "MME"
          set paramList [list vENBUES1APId MMEUES1APId mStreamId mmeUEId]
          set MMEId  [getFromTestMap -MMEIndex $MMEIndex -param "MMEId"]
          
     }

     #Update the dynamic variables
     foreach dynElement {eNBUES1APId MMEUES1APId streamId ueid} param $paramList {
          
          if {![info exists $dynElement]} {
               if {$param == "streamId"} {
                    set streamId [expr $UEIndex + 1]
                    continue
               }
               if {[catch {set $dynElement [getFromTestMap -HeNBIndex $HeNBIndex -UEIndex $UEIndex -param "$param"]}]} {
                    print -abort "Failed to get the param $param"
                    return 1
               }
          }
     }

     foreach mandIE $mandatoryIEs {
          if {[info exists mandIE]} {
               if {[set $mandIE] == ""} {unset $mandIE}
          }
     }

     foreach mandIE $missMandIe {
               unset $mandIE
          }
     
     set gwIp   [getDataFromConfigFile "henbSignalingIpaddress" 0 ]
     set gwPort [getDataFromConfigFile "henbSctp" 0 ]
     
     if { $operation == "send" || 1 } {
          set ueCapabilityInfoIndication [ updateValAndExecute "constructS1Procedure -simType simType -msgName msgName -msgType msgType -HeNBId HeNBId \
                    -gwIp gwIp -gwPort gwPort -UERadioCapability uERadioCapability -eNBUES1APId eNBUES1APId -MMEUES1APId MMEUES1APId -streamId streamId" ]
          
          array set arr_ueCapabilityInfoIndication_msg $ueCapabilityInfoIndication
     }
     
     print -info "ueCapabilityInfoIndication $ueCapabilityInfoIndication"
     if {$execute == "no"} { return "$simType $ueCapabilityInfoIndication"}
     
     return [updateValAndExecute "sendOrVerifyS1APProcedure -msgName msgName -msgType msgType \
               -operation operation -msgList ueCapabilityInfoIndication -simType simType \
               -HeNBIndex HeNBIndex -MMEIndex MMEIndex"]
}


