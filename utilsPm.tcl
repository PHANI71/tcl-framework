# Below is the list of all the defined counter values in the PM SRS document

#   -----------------------------------------------------------------------------------------------------------------------
#   Type       Counter ID                                                   Counter Family
#   -----------------------------------------------------------------------------------------------------------------------
#   HeNBGW     VS.10GEthPort1RxPkts                                         Eth
#   HeNBGW     VS.10GGEthPort1TxPkts                                        Eth
#   HeNBGW     VS.10GEthPort2RxPkts                                         Eth
#   HeNBGW     VS.10GPort2TxPkts                                            Eth
#   HeNBGW     VS.1GPort1RxPkts                                             Eth
#   HeNBGW     VS.1GPort2RxPkts                                             Eth
#   HeNBGW     VS.Bono1GEthTxPktsMalban1                                    Eth
#   HeNBGW     VS.1GPort2TxPkts                                             Eth
#   HeNBGW     VS.10GPort1RxMBytes                                          Eth
#   HeNBGW     VS.10GPort2RxMBytes                                          Eth
#   HeNBGW     VS.10GPort1TxMBytes                                          Eth
#   HeNBGW     VS.10GPort2TxMBytes                                          Eth
#   HeNBGW     VS.1GPort1RxMBytes                                           Eth
#   HeNBGW     VS.1GPort2RxMBytes                                           Eth
#   HeNBGW     VS.1GPort1TxMBytes                                           Eth
#   HeNBGW     VS.ExternalPortTxMBytes                                      Eth
#   HeNBGW     VS.ExternalPortRxMBytes                                      Eth
#   HeNBGW     VS.num_recvd_VLAN_IP_packets                                 Eth
#   HeNBGW     VS.henb_sctp_assoc_active                                    HeNBGW Managed Object Performance Measurements
#   HeNBGW     VS.henb_sctp_assoc_protocol_error                            HeNBGW Managed Object Performance Measurements
#   HeNBGW     VS.mme_sctp_assoc_protocol_error                             HeNBGW Managed Object Performance Measurements
#   HeNBGW     VS.mme_sctp_assoc_active                                     HeNBGW Managed Object Performance Measurements
#   HeNBGW     VS.s1ap_non_ue_msg_rcvd_frm_henbs                            HeNBGW Managed Object Performance Measurements
#   HeNBGW     VS.s1ap_non_ue_msg_sent_to_henbs                             HeNBGW Managed Object Performance Measurements
#   HeNBGW     VS.s1ap_unsupp_non_ue_msg_rcvd_frm_henbs                     HeNBGW Managed Object Performance Measurements
#   HeNBGW     VS.s1ap_ue_msg_rcvd_frm_henbs                                HeNBGW Managed Object Performance Measurements
#   HeNBGW     VS.s1ap_ue_msg_sent_to_henbs                                 HeNBGW Managed Object Performance Measurements
#   HeNBGW     VS.s1ap_reset_msg_sent_to_henbs                              HeNBGW Managed Object Performance Measurements
#   HeNBGW     VS.s1ap_total_reset_msg_rcvd_frm_henbs                       HeNBGW Managed Object Performance Measurements
#   HeNBGW     VS.s1ap_err_msg_recvd_frm_henbs                              HeNBGW Managed Object Performance Measurements
#   HeNBGW     VS.s1ap_err_msg_recvd_frm_henbs_failed_UE_S1AP_ID_validation HeNBGW Managed Object Performance Measurements
#   HeNBGW     VS.s1ap_err_msg_sent_to_henbs                                HeNBGW Managed Object Performance Measurements
#   HeNBGW     VS.s1ap_err_msg_sent_to_henbs_failed UE _S1AP_ID_validation  HeNBGW Managed Object Performance Measurements
#   HeNBGW     VS.s1ap_S1SetupReq_msg_recvd_frm_henbs                       HeNBGW Managed Object Performance Measurements
#   HeNBGW     VS.s1ap_S1SetupResp_msg_sent_to_henbs                        HeNBGW Managed Object Performance Measurements
#   HeNBGW     VS.s1ap_S1SetupFail__Unknown_Plmn_sent_to_henbs              HeNBGW Managed Object Performance Measurements
#   HeNBGW     VS.s1ap_S1SetupFail_Unspecified_sent_to_henbs                HeNBGW Managed Object Performance Measurements
#   HeNBGW     VS.s1ap_S1SetupFail_Locked_sent_to_henbs                     HeNBGW Managed Object Performance Measurements
#   HeNBGW     VS.s1ap_S1SetupFail_Transport_Unavailable_sent_to_henbs      HeNBGW Managed Object Performance Measurements
#   HeNBGW     VS.MaxNumS1ConnectionsToMMEs                                 HeNBGW Managed Object Performance Measurements
#   HeNBGW     VS.TotS1ConnectionsToHeNBs                                   HeNBGW Managed Object Performance Measurements
#   HeNBGW     VS.UE Conn_Attempts_from_HeNBs                               HeNBGW Managed Object Performance Measurements
#   HeNBGW     VS.UE_Conn_Attempts_Fail_Overload                            HeNBGW Managed Object Performance Measurements
#   HeNBGW     VS.UE_Conn_Attempts_Fail_invalid_TAI                         HeNBGW Managed Object Performance Measurements
#   HeNBGW     VS.UE_Conn_Attempts_Fail_invalid_cell_id                     HeNBGW Managed Object Performance Measurements
#   HeNBGW     VS.s1ap_eNB_Config_trans_rcvd_from_henbs                     HeNBGW Managed Object Performance Measurements
#   HeNBGW     VS.s1ap_MME_Config_trans_sent_to_henbs                       HeNBGW Managed Object Performance Measurements
#   HeNBGW     VS.s1ap_MME_Config_trans_routed_to_henbs                     HeNBGW Managed Object Performance Measurements
#   HeNBGW     VS.s1ap_MME_Config_Update_Failure_rcvd_from_HeNBs            HeNBGW_Managed Object Performance Measurements
#   HeNBGW     VS.s1ap_MME_Config_Update_Failure_to_henbs                   HeNBGW Managed Object Performance Measurements
#   HeNBGW     VS.s1ap_eNB_Config_Update_rcvd_from_HeNBs                    HeNBGW_Managed Object Performance Measurements
#   HeNBGW     VS.s1ap_eNB_Config_Update_Failure_sent_to_HeNBs              HeNBGW_Managed Object Performance Measurements
#   HeNBGW     VS.s1ap_eNB_Config_Update_rcvd_from_HeNBs_changed_Region     HeNBGW_Managed Object Performance Measurements
#   HeNBGW     VS.s1ap_HO_Request_sent_to_HeNBs                             HeNBGW Managed Object Performance Measurements
#   HeNBGW     VS.s1ap_HO_Failure_rcvd_from_HeNBs                           HeNBGW Managed Object Performance Measurements
#   HeNBGW     VS.X2_HO_Path_Switch_Req_rcvd_from HeNB                      HeNBGW Managed Object Performance Measurements
#   HeNBGW     VS.X2_HO_Path_switch_Req_Failure_sent_to_HeNBs               HeNGW Managed Object Performance Measurements
#   HeNBGW     VS.X2_HO_Path_Switch_Req_Ack_sent_to_HeNBs                   HeNBGW Managed Object Performance Measurements
#   MME        VS.s1ap_unsupp_non_ue_msg_rcvd_frm_mme                       MME Managed Object Performance Measurements
#   MME        VS.s1ap_non_ue_msg_rcvd_frm_mme                              MME Managed Object Performance Measurements
#   MME        VS.s1ap_non_ue_msg_sent_to_mme                               MME Managed Object Performance Measurements
#   MME        VS.s1ap_ue_msg_rcvd_frm_mme                                  MME Managed Object Performance Measurements
#   MME        VS.s1ap_ue_msg_sent_to_mme                                   MME Managed Object Performance Measurements
#   MME        VS.s1ap_write_replace_wrn_req_recvd_frm_mme                  MME Managed Object Performance Measurements
#   MME        VS.s1ap_write_replace_wrn_req_recvd_emerg_frm_mme            MME Managed Object Performance Measurements
#   MME        VS.s1ap_write_replace_wrn_req_discarded_frm_mme              MME Managed Object Performance Measurements
#   MME        VS.s1ap_write_replace_wrn_req_sent_to_HeNBs                  MME Managed Object Performance Measurements
#   MME        VS.s1ap_kill_req_recvd_frm_mme                               MME Managed Object Performance Measurements
#   MME        VS.active_CMAS_sessions_mme_avg                              MME Managed Object Performance Measurements
#   MME        VS.active_CMAS_sessions_mme_max                              MME Managed Object Performance Measurements
#   MME        VS.active_CMAS_sessions_mme_min                              MME Managed Object Performance Measurements
#   MME        VS.s1ap_reset_msg_rcvd_frm_mme                               MME Managed Object Performance Measurements
#   MME        VS.s1ap_reset_msg_sent_to_mme                                MME Managed Object Performance Measurements
#   MME        VS.s1ap_no_resp_to_reset_msg_sent_to_mme                     MME Managed Object Performance Measurements
#   HeNBGW     VS.s1ap_reset_msg_sent_to_henbs_per_mme                      HeNBGW Managed Object Performance Measurements
#   MME        VS.s1ap_err_msg_sent_to_mme                                  MME Managed Object Performance Measurements
#   MME        VS.s1ap_err_msg_sent_to_mme_failed_UE_S1AP_ID_validation     MME Managed Object Performance Measurements
#   MME        VS.s1ap_err_msg_recvd_frm_mme                                MME Managed Object Performance Measurements
#   MME        VS.s1ap_err_msg_recvd_frm_mme_failed_UE S1AP ID_validation   MME Managed Object Performance Measurements
#   MME        VS.s1ap_paging_msg_ps_recvd_frm_mme                          MME Managed Object Performance Measurements
#   MME        VS.s1ap_paging_msg_cs_recvd_frm_mme                          MME Managed Object Performance Measurements
#   MME        VS.s1ap_paging_msg_sent_to_HeNBs                             MME Managed Object Performance Measurements
#   MME        VS.s1ap_paging_msg_not_sent_to_HeNBs                         MME Managed Object Performance Measurements
#   MME        VS.s1ap_paging_msg_not_sent_to_HeNBs_sctp                    MME Managed Object Performance Measurements
#   MME        VS. s1ap_paging_msg_not_sent_to_HeNBs_overload               MME Managed Object Performance Measurements
#   MME        VS.s1ap_S1SetupReq_msg_sent_to_MME                           MME Managed Object Performance Measurements
#   MME        VS.s1ap_S1SetupResp_msg_received_frm_mme                     MME Managed Object Performance Measurements
#   MME        VS.s1ap_ S1SetupResp_msg_received_frm_mme_unknown_plmns      MME Managed Object Performance Measurements
#   MME        VS.s1ap_ S1SetupResp_msg_received_frm_mme_duplicate_mmecs    MME Managed Object Performance Measurements
#   MME        VS.s1ap_S1SetupFail_received_frm_mme                         MME Managed Object Performance Measurements
#   MME        VS.UE_conn_attempts_to_mme                                   MME Managed Object Performance Measurements
#   MME        VS.tactive_UE_conn_henb_avg                                  MME Managed Object Performance Measurements
#   MME        VS.tactive_UE_conn_henb_max                                  MME Managed Object Performance Measurements
#   MME        VS.num_UL_partial_UE_conn_time_out                           MME Managed Object Performance Measurements
#   MME        RAB.AttemptEstablishment                                     MME Managed Object Performance Measurements
#   MME        VS.s1ap_eNB_Config_trans_sent_to_mme                         MME Managed Object Performance Measurements
#   MME        VS.s1ap_MME_Config_trans_rcvd_from_mme                       MME Managed Object Performance Measurements
#   MME        VS.s1ap_MME_Config_Update_rcvd_from_mme                      MME Managed Object Performance Measurements
#   MME        VS.s1ap_ MME_Config_Update_rcvd_frm_mme_unknown_plmns        MME Managed Object Performance Measurements
#   MME        VS.s1ap_ MME_Config_rcvd_frm_mme_duplicate_mmecs             MME Managed Object Performance Measurements
#   MME        VS.s1ap_MME_Config_Update_Failure_sent_to_mme                MME Managed Object Performance Measurements
#   MME        VS.s1ap_MME_Config_Update_sent_to_henbs                      MME Managed Object Performance Measurements
#   MME        VS.s1ap_Overload_Start_rcvd_from_mme                         MME Managed Object Performance Measurements
#   MME        VS.s1ap_Overload_Start_sent_to_HeNBs                         MME Managed Object Performance Measurements
#   MME        VS.s1ap_Overload_Stop_rcvd_from_mme                          MME Managed Object Performance Measurements
#   MME        VS.s1ap_Overload_Stop_sent_to_HeNBs                          MME Managed Object Performance Measurements
#   MME        VS.s1ap_Overload_Stop_discarded_from_mme                     MME Managed Object Performance Measurements
#   MME        VS.s1ap_HO_Request_rcvd_from_mme                             MME Managed Object Performance Measurements
#   MME        VS.s1ap_HO_Failure_sent_to_mme_unknown_target                MME Managed Object Performance Measurements
#   MME        VS.s1ap_HO_Failure_sent_to_mme_guard_timer_expires           MME Managed Object Performance Measurements
#   MME        VS.s1ap_HO_Notify_sent_to_mme                                MME Managed Object Performance Measurements
#   MME        VS.tactive_UE_conn_mme_avg                                   MME Managed Object Performance Measurements
#   MME        VS.tactive_UE_conn_mme_max                                   MME Managed Object Performance Measurements
#   MME        VS.X2_HO_Path_Switch_Req_sent_to_mme                         MME Managed Object Performance Measurements
#   MME        VS.X2_HO_Path_Switch_Req_Failure_rcvd_from_mme               MME Managed Object Performance Measurements
#   MME        VS.X2_HO_Path_Switch_Req_Ack_rcvd_from_mme                   MME Managed Object Performance Measurements
#   MME        VS.abnormal_releases_sent_to HeNBs                           MME Managed Object Performance Measurements
#   MME        VS.normal_releases_sent_to HeNBs                             MME Managed Object Performance Measurements
#   MME        VS.abnormal_releases_sent_to MME                             MME Managed Object Performance Measurements
#   MME        VS.normal_releases_sent_to MME                               MME Managed Object Performance Measurements
#   MMERegion  VS.Number_Of_HeNBs_Active_Per_Region                         MMERegion Managed Object Performance Measurements
#   MMERegion  VS.UE_connections_ in_mmeregion                              MMERegion Managed Object Performance Measurements
#   MMERegion  VS.s1ap_paging_msg_recvd_for_region                          MMERegion Managed Object Performance Measurements
#   -----------------------------------------------------------------------------------------------------------------------
proc getValidPmCounterLists {args} {
     #-
     #- This procedure is used to update the pm counters that are used for verification
     #-
     #- @return : updated the list one level up
     #-
     parseArgs args \
               [list\
               [list fgwNum               "optional"    "numeric"          "0"                  "The position of fgw in the testbed file"] \
               [list dutIp                "optional"    "ip"               "[getActiveBonoIp]"  "The dut ip address"] \
               [list simType              "optional"    "string"           "_"                  "The simulator type"] \
               ]
     
     catch {uplevel "unset -nocomplain arr_pm_counters"}
     set aaa [getNEType $dutIp]
     set FGW "FGW"
     print -info " in ------------------------- getValidPmCounterLists ::: $aaa "
     switch [$FGW] {
          "FGW" {
               uplevel "set arr_pm_counters(HENBGW)      [list \
                         VS.10GEthPort1RxPkts VS.10GGEthPort1TxPkts VS.10GEthPort2RxPkts VS.10GPort2TxPkts \
                         VS.1GPort1RxPkts VS.1GPort2RxPkts VS.Bono1GEthTxPktsMalban1 VS.1GPort2TxPkts VS.10GPort1RxMBytes \
                         VS.10GPort2RxMBytes VS.10GPort1TxMBytes VS.10GPort2TxMBytes VS.1GPort1RxMBytes VS.1GPort2RxMBytes \
                         VS.1GPort1TxMBytes VS.ExternalPortTxMBytes VS.ExternalPortRxMBytes  \
                         VS.henb_sctp_assoc_active VS.henb_sctp_assoc_protocol_error VS.mme_sctp_assoc_protocol_error \
                         VS.mme_sctp_assoc_active VS.s1ap_non_ue_msg_rcvd_frm_henbs VS.s1ap_non_ue_msg_sent_to_henbs \
                         VS.s1ap_unsupp_non_ue_msg_rcvd_frm_henbs VS.s1ap_ue_msg_rcvd_frm_henbs VS.s1ap_ue_msg_sent_to_henbs \
                         VS.s1ap_reset_msg_sent_to_henbs VS.s1ap_total_reset_msg_rcvd_frm_henbs VS.s1ap_err_msg_recvd_frm_henbs \
                         VS.s1ap_err_msg_recvd_frm_henbs_failed_UE_S1AP_ID_validation VS.s1ap_err_msg_sent_to_henbs \
                         VS.s1ap_err_msg_sent_to_henbs_failed_UE_S1AP_ID_validation VS.s1ap_S1SetupReq_msg_recvd_frm_henbs \
                         VS.s1ap_S1SetupResp_msg_sent_to_henbs VS.s1ap_S1SetupFail_Unknown_Plmn_sent_to_henbs \
                         VS.s1ap_S1SetupFail_Unspecified_sent_to_henbs VS.s1ap_S1SetupFail_Locked_sent_to_henbs \
                         VS.s1ap_S1SetupFail_Transport_Unavailable_sent_to_henbs VS.MaxNumS1ConnectionsToMMEs \
                         VS.TotS1ConnectionsToHeNBs VS.UE_Conn_Attempts_from_HeNBs VS.UE_Conn_Attempts_Fail_Overload \
                         VS.UE_Conn_Attempts_Fail_invalid_TAI VS.UE_Conn_Attempts_Fail_invalid_cell_id \
                         VS.s1ap_eNB_Config_trans_rcvd_from_henbs VS.s1ap_MME_Config_trans_sent_to_henbs \
                         VS.s1ap_MME_Config_trans_routed_to_henbs VS.s1ap_MME_Config_Update_Failure_rcvd_from_HeNBs \
                         VS.s1ap_MME_Config_Update_Failure_to_henbs VS.s1ap_eNB_Config_Update_rcvd_from_HeNBs \
                         VS.s1ap_eNB_Config_Update_Failure_sent_to_HeNBs VS.s1ap_eNB_Config_Update_rcvd_from_HeNBs_changed_Region \
                         VS.s1ap_HO_Request_sent_to_HeNBs VS.s1ap_HO_Failure_rcvd_from_HeNBs VS.X2_HO_Path_Switch_Req_rcvd_fromHeNB \
                         VS.X2_HO_Path_switch_Req_Failure_sent_to_HeNBs VS.X2_HO_Path_Switch_Req_Ack_sent_to_HeNBs \
                         VS.s1ap_reset_msg_sent_to_henbs_per_mme \
                         ]"
               
               uplevel "set arr_pm_counters(MME)          [list \
                         VS.s1ap_unsupp_non_ue_msg_rcvd_frm_mme VS.s1ap_non_ue_msg_rcvd_frm_mme VS.s1ap_non_ue_msg_sent_to_mme \
                         VS.s1ap_ue_msg_rcvd_frm_mme VS.s1ap_ue_msg_sent_to_mme VS.s1ap_write_replace_wrn_req_recvd_frm_mme \
                         VS.s1ap_write_replace_wrn_req_recvd_emerg_frm_mme VS.s1ap_write_replace_wrn_req_discarded_frm_mme \
                         VS.s1ap_write_replace_wrn_req_sent_to_HeNBs VS.s1ap_kill_req_recvd_frm_mme \
                         VS.active_CMAS_sessions_mme_avg VS.active_CMAS_sessions_mme_max VS.active_CMAS_sessions_mme_min \
                         VS.s1ap_reset_msg_sent_to_mme VS.s1ap_no_resp_to_reset_msg_sent_to_mme VS.s1ap_err_msg_sent_to_mme \
                         VS.s1ap_err_msg_sent_to_mme_failed_UE_S1AP_ID_validation VS.s1ap_err_msg_recvd_frm_mme \
                         VS.s1ap_err_msg_recvd_frm_mme_failed_UE_S1AP_ID_validation VS.s1ap_paging_msg_ps_recvd_frm_mme \
                         VS.s1ap_paging_msg_cs_recvd_frm_mme VS.s1ap_paging_msg_sent_to_HeNBs VS.s1ap_paging_msg_not_sent_to_HeNBs \
                         VS.s1ap_paging_msg_not_sent_to_HeNBs_sctp VS.s1ap_paging_msg_not_sent_to_HeNBs_overload \
                         VS.s1ap_S1SetupReq_msg_sent_to_MME VS.s1ap_S1SetupResp_msg_received_frm_mme \
                         VS.s1ap_S1SetupResp_msg_received_frm_mme_unknown_plmns VS.s1ap_S1SetupResp_msg_received_frm_mme_duplicate_mmecs \
                         VS.s1ap_S1SetupFail_received_frm_mme VS.UE_conn_attempts_to_mme VS.tactive_UE_conn_henb_avg \
                         VS.tactive_UE_conn_henb_max VS.num_UL_partial_UE_conn_time_out RAB.AttemptEstablishment \
                         VS.s1ap_eNB_Config_trans_sent_to_mme VS.s1ap_MME_Config_trans_rcvd_from_mme \
                         VS.s1ap_MME_Config_Update_rcvd_from_mme VS.s1ap_MME_Config_Update_rcvd_frm_mme_unknown_plmns \
                         VS.s1ap_MME_Config_rcvd_frm_mme_duplicate_mmecs VS.s1ap_MME_Config_Update_Failure_sent_to_mme \
                         VS.s1ap_MME_Config_Update_sent_to_henbs VS.s1ap_Overload_Start_rcvd_from_mme \
                         VS.s1ap_Overload_Start_sent_to_HeNBs VS.s1ap_Overload_Stop_rcvd_from_mme \
                         VS.s1ap_Overload_Stop_sent_to_HeNBs VS.s1ap_Overload_Stop_discarded_from_mme \
                         VS.s1ap_HO_Request_rcvd_from_mme VS.s1ap_HO_Failure_sent_to_mme_unknown_target \
                         VS.s1ap_HO_Failure_sent_to_mme_guard_timer_expires VS.s1ap_HO_Notify_sent_to_mme \
                         VS.tactive_UE_conn_mme_avg VS.tactive_UE_conn_mme_max VS.X2_HO_Path_Switch_Req_sent_to_mme \
                         VS.X2_HO_Path_Switch_Req_Failure_rcvd_from_mme VS.X2_HO_Path_Switch_Req_Ack_rcvd_from_mme \
                         VS.abnormal_releases_sent_to_Henbs VS.normal_releases_sent_to_Henbs VS.abnormal_releases_sent_to_mme \
                         VS.normal_releases_sent_to_mme VS.s1ap_reset_msg_rcvd_frm_mme \
                         ]"
               
               uplevel "set arr_pm_counters(MMERegion)       [list \
                         VS.Number_Of_HeNBs_Active_Per_Region VS.UE_connections_in_mmeregion VS.s1ap_paging_msg_recvd_for_region\
                         ]"
               
               # The below counter values would be skipped for verification
               uplevel "set arr_pm_counters(skipList)        [list \
                         VS.10GEthPort1RxPkts VS.10GGEthPort1TxPkts VS.10GEthPort2RxPkts VS.10GPort2TxPkts \
                         VS.1GPort1RxPkts VS.1GPort2RxPkts VS.Bono1GEthTxPktsMalban1 VS.1GPort2TxPkts VS.10GPort1RxMBytes \
                         VS.10GPort2RxMBytes VS.10GPort1TxMBytes VS.10GPort2TxMBytes VS.1GPort1RxMBytes VS.1GPort2RxMBytes \
                         VS.1GPort1TxMBytes VS.ExternalPortTxMBytes VS.ExternalPortRxMBytes  \
                         VS.10GEthPort1RxPkts VS.10GGEthPort1TxPkts VS.10GEthPort2RxPkts VS.10GPort2TxPkts\
                         VS.1GPort1RxPkts VS.1GPort2RxPkts VS.Bono1GEthTxPktsMalban1 VS.1GPort2TxPkts VS.10GPort1RxMBytes\
                         VS.10GPort2RxMBytes VS.10GPort1TxMBytes VS.10GPort2TxMBytes VS.1GPort1RxMBytes VS.1GPort2RxMBytes\
                         VS.1GPort1TxMBytes VS.1GPort1TxMBytes  VS.num_recvd_VLAN_IP_packets\
                         VS.ExternalPortTxMBytes VS.ExternalPortRxMBytes\
                         ]"
          }
     }
     print -info " in ------------------------- getValidPmCounterLists ::: $aaa "
     
}

proc parsePmXmlFile {parent} {
     #-
     #- This procedure is used to parse the PM XML file
     #- The parser is store the data in an array, indexed by the MOID
     #- This uses a recersive approach to span the xml tree to find all the nodes and its attributes
     #-
     #- This is a recursive function and proper exit handling is required
     #-
     
     # Get the parent name and type
     set type [$parent nodeType]
     set name [$parent nodeName]
     
     print -debug "$parent is a $type node named $name"
     
     if {$type != "ELEMENT_NODE"} then return
     
     switch -regexp $name {
          "measCollec"     {
               foreach attr [list beginTime endTime] {
                    if {[$parent hasAttribute $attr]} {
                         set $attr [$parent getAttribute $attr]
                         set ::ARR_XML_PM_DATA($attr) [set $attr]
                    }
               }
          }
          "measValue" {
               # Get the moid xml label. This is used as an index to store the data
               # Also map the label to a user friendly format
               set userLabel [$parent getAttribute measObjLdn]
               set userLabel [moidXmlMapper $userLabel]
               if {[lindex $::ARR_XML_PM_DATA(managedElement) end] == "temp"} {
                    set    ::ARR_XML_PM_DATA(managedElement)       [lreplace $::ARR_XML_PM_DATA(managedElement) end end $userLabel]
                    append ::ARR_XML_PM_DATA($userLabel,measTypes) " $::ARR_XML_PM_DATA(temp,measTypes)"
                    unset  ::ARR_XML_PM_DATA(temp,measTypes)
               }
          }
          "measTypes|measResults"   {
               # The data in the PM XML file is traversed to root to end
               # However the MOID info is defined after the measTypes block
               # So store the measTypes data in temp variable and once the actual tag is known copy the data
               set text [$parent text]
               if {$name == "measTypes"} {
                    set tag temp
                    lappend ::ARR_XML_PM_DATA(managedElement) $tag
                    set ::ARR_XML_PM_DATA($tag,measTypes) " $text"
               } else {
                    if {[info exists ::ARR_XML_PM_DATA(managedElement)]} {
                         set tag [lindex $::ARR_XML_PM_DATA(managedElement) end]
                    }
                    append ::ARR_XML_PM_DATA($tag,$name) " $text"
               }
          }
     }
     
     # Recusrse till no more child exists
     foreach child [$parent childNodes] {
          parsePmXmlFile $child
     }
}

proc dsssssparsePmXmlFile {parent} {
     #-
     #- This procedure is used to parse the PM XML file
     #- The parser is store the data in an array, indexed by the MOID
     #- This uses a recersive approach to span the xml tree to find all the nodes and its attributes
     #-
     #- This is a recursive function and proper exit handling is required
     #-
     
     # Get the parent name and type
     set type [$parent nodeType]
     set name [$parent nodeName]
     
     print -debug "$parent is a $type node named $name"
     
     if {$type != "ELEMENT_NODE"} then return
     print -info " -------------------- $name "
     switch -regexp $name {
          "measCollec"     {
               foreach attr [list beginTime endTime] {
                    if {[$parent hasAttribute $attr]} {
                         set $attr [$parent getAttribute $attr]
                         set ::ARR_XML_PM_DATA($attr) [set $attr]
                         print -info " measCollec -- $::ARR_XML_PM_DATA($attr)  ================ "
                    }
               }
          }
          "measValue" {
               # Get the moid xml label. This is used as an index to store the data
               # Also map the label to a user friendly format
               set userLabel [$parent getAttribute measObjLdn]
               set userLabel [moidXmlMapper $userLabel]
               if {[lindex $::ARR_XML_PM_DATA(managedElement) end] == "temp"} {
                    set    ::ARR_XML_PM_DATA(managedElement)       [lreplace $::ARR_XML_PM_DATA(managedElement) end end $userLabel]
                    print -info "  $::ARR_XML_PM_DATA(managedElement) end end $userLabel "
                    append ::ARR_XML_PM_DATA($userLabel,measTypes) " $::ARR_XML_PM_DATA(temp,measTypes)"
                    print -info " Added :: temp measTypes --> $measTypes   ----------- $::ARR_XML_PM_DATA(temp,measTypes) "
                    unset  ::ARR_XML_PM_DATA(temp,measTypes)
               }
          }
          "measTypes|measResults"   {
               # The data in the PM XML file is traversed to root to end
               # However the MOID info is defined after the measTypes block
               # So store the measTypes data in temp variable and once the actual tag is known copy the data
               set text [$parent text]
               if {$name == "measTypes"} {
                    set tag temp
                    lappend ::ARR_XML_PM_DATA(managedElement) $tag
                    set ::ARR_XML_PM_DATA($tag,measTypes) " $text"
               } else {
                    if {[info exists ::ARR_XML_PM_DATA(managedElement)]} {
                         set tag [lindex $::ARR_XML_PM_DATA(managedElement) end]
                    }
                    append ::ARR_XML_PM_DATA($tag,$name) " $text"
                    print -info " measTypes|measResults -- $::ARR_XML_PM_DATA($tag,$name)"
               }
          }
     }
     print -info " parsePmXmlFile ---- after for loop   "
     
     # Recusrse till no more child exists
     foreach child [$parent childNodes] {
          parsePmXmlFile $child
     }
}

proc moidXmlMapper {moid} {
     #-
     #- This procedure is used to map the MOID in the xml to a user understandable format
     #-
     #- @return the MOID
     #-
     print -info " MODI is ------------------- $moid "
     if {[regexp "((MME|MMERegion)=)" $moid]} {
          set result [join [split [lindex [split $moid ","] end] "="] ""]
     } else {
          set result "HENBGW"
          set result "Application4G1"
     }
     return $result
}
proc consolidatePMData { } {
     global ARR_XML_PM_DATA
     global ARR_XML_SUM_PM_DATA
     foreach index [ array names ARR_XML_PM_DATA] {
          if {[regexp "beginTime|endTime|managedElement" $index]} {continue}
          set valueOfElement $ARR_XML_PM_DATA($index)
          if {! [ info exists $valueOfElement ] } { set valueOfElement 0 }
          set ARR_XML_SUM_PM_DATA($index) [ expr [join $valueOfElement  +]]
     }
     return [array get ARR_XML_SUM_PM_DATA]
}

proc constructPmDataStruct {fileName} {
     #-
     #- This procedure is used to construct the PM data structure from the PM XML file
     #- The data would be stored in an array indexed with the MOID and will have the start and stop time
     #-
     #- @in fileName  The PM file to be parsed
     #-
     #- @return 0 on sucess and -1 on failure
     #-
     
     global ARR_XML_PM_DATA
     lappend ::auto_path "[getPath commSqa]/tools/tdom"
     package require tdom
     
     set fd   [open $fileName r]
     set xml  [read $fd]
     set doc  [dom parse $xml]
     set root [$doc documentElement]
     
     if {[catch {parsePmXmlFile $root} err]} {
          print -fail  "Parsing of PM XML file $fileName failed"
          print -debug "Got error: $err"
     }
     parray ARR_XML_PM_DATA
     
     foreach measData [array names ARR_XML_PM_DATA -regexp ",measTypes"] {
          set index [lindex [split $measData ","] 0]
          foreach var $ARR_XML_PM_DATA($index,measTypes) value $ARR_XML_PM_DATA($index,measResults) {
               lappend  ARR_XML_PM_DATA($index,$var) $value
          }
          unset ARR_XML_PM_DATA($index,measTypes)
          unset ARR_XML_PM_DATA($index,measResults)
     }
     
     parray ARR_XML_PM_DATA
     
     return 0
}

proc verifyPMCounters {args} {
     #-
     #- This procedure is used to verify the PM counters
     #- It builds the data structure as per TAG "Measurement Family"
     #-
     #- @return 0 on success and -1 on failure
     #-
     
     global ARR_XML_PM_DATA
     set pmVerify 0
     parseArgs args \
               [list\
               [list fgwNum               "optional"    "numeric"          "0"               "ip address of the host where backdoor port is opened"] \
               [list operation            "optional"    "init|verify"      "verify"          "The operation to be performed"] \
               [list pmMoid               "optional"    "string"           "__UN_DEFINED__"  "The PM Moids for test"] \
               [list noOfMMEs             "optional"    "string"           "1"               "The number of MMEs configures"] \
               [list noOfMMERegions       "optional"    "string"           "1"               "The number of MMEs configures"] \
               [list granularPeriod       "optional"    "string"           "min5"            "Configure the value of granular period in OAM_Preconfig.xml file"  ]
     ]
     
     if { [ info exists  granularPeriod ] } {
          set granularPeriod [ expr [regexp -inline -- {-?\d+(?:\.\d+)?} $granularPeriod] * 60 ]
     } else {
          set granularPeriod 300
          print -info " Default value of 300 seconds set as granularPeriod "
     }
     
     set pmIpList [list "[getActiveBonoIp $fgwNum] fgw"]
     # If user defined operation is init then cleanup all the stalexml files from the system
     switch $operation {
          "init" {
               if { 0 } {
                    uplevel "set   arr_pm_counters(HENBGW)      [list \
                       VS.henb_sctp_assoc_active VS.henb_sctp_assoc_protocol_error\
                       VS.mme_sctp_assoc_protocol_error VS.mme_sctp_assoc_active\
                       VS.s1ap_non_ue_msg_rcvd_frm_Henbs VS.s1ap_non_ue_msg_sent_to_Henbs\
                       VS.s1ap_unsupp_non_ue_msg_rcvd_frm_Henbs VS.s1ap_ue_msg_rcvd_frm_Henbs\
                       VS.s1ap_ue_msg_sent_to_Henbs VS.s1ap_reset_msg_sent_to_Henbs\
                       VS.s1ap_total_reset_msg_rcvd_frm_Henbs VS.s1ap_err_msg_recvd_frm_Henbs\
                       VS.s1ap_err_msg_recvd_frm_Henbs_failed_UE_S1AP_ID_validation VS.s1ap_err_msg_sent_to_Henbs\
                       VS.s1ap_err_msg_sent_to_Henbs_failed_UE_S1AP_ID_validation VS.s1ap_S1SetupReq_msg_recvd_frm_Henbs\
                       VS.s1ap_S1SetupResp_msg_sent_to_Henbs VS.s1ap_S1SetupFail_Unknown_Plmn_sent_to_Henbs\
                       VS.s1ap_S1SetupFail_Unspecified_sent_to_Henbs VS.s1ap_S1SetupFail_Locked_sent_to_Henbs\
                       VS.s1ap_S1SetupFail_Transport_Unavailable_sent_to_Henbs VS.MaxNumS1ConnectionsToMMEs\
                       VS.TotS1ConnectionsToHenbs VS.UE_Conn_Attempts_frm_Henbs\
                       VS.UE_Conn_Attempts_Fail_Overload VS.UE_Conn_Attempts_Fail_invalid_TAI\
                       VS.UE_Conn_Attempts_Fail_invalid_cell_id VS.s1ap_eNB_Config_trans_rcvd_frm_Henbs\
                       VS.s1ap_MME_Config_trans_sent_to_Henbs VS.s1ap_MME_Config_trans_routed_to_Henbs\
                       VS.s1ap_MME_Config_Update_Failure_rcvd_frm_Henbs VS.s1ap_MME_Config_Update_sent_to_Henbs\
                       VS.s1ap_eNB_Config_Update_rcvd_frm_Henbs VS.s1ap_eNB_Config_Update_Failure_sent_to_Henbs\
                       VS.s1ap_eNB_Config_Update_rcvd_frm_Henbs_changed_Region VS.s1ap_HO_Request_sent_to_Henbs\
                       VS.s1ap_HO_Failure_rcvd_frm_Henbs VS.X2_HO_Path_Switch_Req_rcvd_frm_Henb\
                       VS.X2_HO_Path_switch_Req_Failure_sent_to_Henbs VS.X2_HO_Path_Switch_Req_Ack_sent_to_Henbs\
                              ]"
                    
                    uplevel "set   arr_pm_counters(MME)          [list \
            VS.s1ap_unsupp_non_ue_msg_rcvd_frm_MME VS.s1ap_non_ue_msg_rcvd_frm_MME\
            VS.s1ap_non_ue_msg_sent_to_MME VS.s1ap_ue_msg_rcvd_frm_MME\
            VS.s1ap_ue_msg_sent_to_MME VS.s1ap_write_replace_wrn_req_recvd_frm_MME\
            VS.s1ap_write_replace_wrn_req_recvd_emerg_frm_MME VS.s1ap_write_replace_wrn_req_discarded_frm_MME\
            VS.s1ap_write_replace_wrn_req_sent_to_Henbs VS.s1ap_kill_req_recvd_frm_MME\
            VS.active_CMAS_sessions_MME_avg VS.active_CMAS_sessions_MME_max\
            VS.active_CMAS_sessions_MME_min VS.s1ap_reset_msg_rcvd_frm_MME\
            VS.s1ap_reset_msg_sent_to_MME VS.s1ap_no_resp_to_reset_msg_sent_to_MME\
            VS.s1ap_reset_msg_sent_to_Henbs_per_MME VS.s1ap_err_msg_sent_to_MME\
            VS.s1ap_err_msg_sent_to_MME_failed_UE_S1AP_ID_validation VS.s1ap_err_msg_recvd_frm_MME\
            VS.s1ap_err_msg_recvd_frm_MME_failed_UE_S1AP_ID_validation VS.s1ap_paging_msg_ps_recvd_frm_MME\
            VS.s1ap_paging_msg_cs_recvd_frm_MME VS.s1ap_paging_msg_sent_to_Henbs\
            VS.s1ap_paging_msg_not_sent_to_Henbs VS.s1ap_paging_msg_not_sent_to_Henbs_sctp\
            VS.s1ap_paging_msg_not_sent_to_Henbs_overload VS.s1ap_S1SetupReq_msg_sent_to_MME\
            VS.s1ap_S1SetupResp_msg_received_frm_MME VS.s1ap_S1SetupResp_msg_received_frm_MME_unknown_plmns\
            VS.s1ap_S1SetupResp_msg_received_frm_MME_duplicate_mmecs VS.s1ap_S1SetupFail_received_frm_MME\
            VS.UE_conn_attempts_to_MME VS.tactive_UE_conn_Henb_avg\
            VS.tactive_UE_conn_Henb_max VS.num_UL_partial_UE_conn_time_out\
            VS.s1ap_eNB_Config_trans_sent_to_MME\
            VS.s1ap_MME_Config_trans_rcvd_frm_MME VS.s1ap_MME_Config_Update_rcvd_frm_MME\
            VS.s1ap_MME_Config_Update_rcvd_frm_MME_unknown_plmns VS.s1ap_MME_Config_rcvd_frm_MME_duplicate_mmecs\
            VS.s1ap_MME_Config_Update_Failure_sent_to_MME VS.s1ap_MME_Config_Update_sent_to_Henbs\
            VS.s1ap_Overload_Start_rcvd_frm_MME VS.s1ap_Overload_Start_sent_to_Henbs\
            VS.s1ap_Overload_Stop_rcvd_frm_MME VS.s1ap_Overload_Stop_sent_to_Henbs\
            VS.s1ap_Overload_Stop_discarded_frm_MME VS.s1ap_HO_Request_rcvd_frm_MME\
            VS.s1ap_HO_Failure_sent_to_MME_unknown_target VS.s1ap_HO_Failure_sent_to_MME_guard_timer_expires\
            VS.s1ap_HO_Notify_sent_to_MME VS.tactive_UE_conn_MME_avg\
            VS.tactive_UE_conn_MME_max VS.X2_HO_Path_Switch_Req_sent_to_MME\
            VS.X2_HO_Path_Switch_Req_Failure_rcvd_frm_MME VS.X2_HO_Path_Switch_Req_Ack_rcvd_frm_MME\
            VS.abnormal_releases_sent_to_Henbs VS.normal_releases_sent_to_Henbs\
            VS.abnormal_releases_sent_to_MME VS.normal_releases_sent_to_MME\
                              ]"
                    
                    uplevel " set   arr_pm_counters(MMERegion)       [list \
                              VS.Number_Of_HeNBs_Active_Per_Region VS.UE_connections_in_mmeregion VS.s1ap_paging_msg_recvd_for_region\
                              ]"
                    
                    # The below counter values would be skipped for verification
                    uplevel "   set   arr_pm_counters(skipList)        [list \
                              VS.10GEthPort1RxPkts VS.10GGEthPort1TxPkts VS.10GEthPort2RxPkts VS.10GPort2TxPkts \
                              VS.1GPort1RxPkts VS.1GPort2RxPkts VS.Bono1GEthTxPktsMalban1 VS.1GPort2TxPkts VS.10GPort1RxMBytes \
                              VS.10GPort2RxMBytes VS.10GPort1TxMBytes VS.10GPort2TxMBytes VS.1GPort1RxMBytes VS.1GPort2RxMBytes \
                              VS.1GPort1TxMBytes VS.ExternalPortTxMBytes VS.ExternalPortRxMBytes  \
                              VS.10GEthPort1RxPkts VS.10GGEthPort1TxPkts VS.10GEthPort2RxPkts VS.10GPort2TxPkts\
                              VS.1GPort1RxPkts VS.1GPort2RxPkts VS.Bono1GEthTxPktsMalban1 VS.1GPort2TxPkts VS.10GPort1RxMBytes\
                              VS.10GPort2RxMBytes VS.10GPort1TxMBytes VS.10GPort2TxMBytes VS.1GPort1RxMBytes VS.1GPort2RxMBytes\
                              VS.1GPort1TxMBytes VS.1GPort1TxMBytes  VS.num_recvd_VLAN_IP_packets\
                              VS.ExternalPortTxMBytes VS.ExternalPortRxMBytes\
                              ]"
               }
               set ::PM_START_TIME [clock seconds]
               print -info " Value of Time is $::PM_START_TIME "
               foreach entity $pmIpList {
                    foreach {ip type} $entity {break}
                    set result [updateValAndExecute "cleanUpStaleXmlFiles -fgwNum fgwNum -dutIp ip -simType type"]
                    if {$result != 0} {
                         print -fail "Cleanup of stale XML files on the $ip\($type\) failed"
                         set pmVerify 1
                    } else {
                         print -pass "Successfully Cleanuped up all stale XML files on $ip\($type\)"
                    }
               }
               return 0
          }
          "verify" {
               if { 1 } {
                    set   arr_pm_counters(MMERegion)       [list \
                              VS.Number_Of_Henbs_Active_Per_Region VS.UE_connections_in_region VS.s1ap_paging_msg_recvd_for_region\
                              ]
                    set   arr_pm_counters(skipList)        [list \
                              VS.10GEthPort1RxPkts VS.10GGEthPort1TxPkts VS.10GEthPort2RxPkts VS.10GPort2TxPkts \
                              VS.1GPort1RxPkts VS.1GPort2RxPkts VS.Bono1GEthTxPktsMalban1 VS.1GPort2TxPkts VS.10GPort1RxMBytes \
                              VS.10GPort2RxMBytes VS.10GPort1TxMBytes VS.10GPort2TxMBytes VS.1GPort1RxMBytes VS.1GPort2RxMBytes \
                              VS.1GPort1TxMBytes VS.ExternalPortTxMBytes VS.ExternalPortRxMBytes  \
                              VS.10GEthPort1RxPkts VS.10GGEthPort1TxPkts VS.10GEthPort2RxPkts VS.10GPort2TxPkts\
                              VS.1GPort1RxPkts VS.1GPort2RxPkts VS.Bono1GEthTxPktsMalban1 VS.1GPort2TxPkts VS.10GPort1RxMBytes\
                              VS.10GPort2RxMBytes VS.10GPort1TxMBytes VS.10GPort2TxMBytes VS.1GPort1RxMBytes VS.1GPort2RxMBytes\
                              VS.1GPort1TxMBytes VS.1GPort1TxMBytes  VS.num_recvd_VLAN_IP_packets\
                              VS.ExternalPortTxMBytes VS.ExternalPortRxMBytes\
                              ]

                    set   arr_pm_counters(MME)          [list \
            VS.s1ap_unsupp_non_ue_msg_rcvd_frm_MME VS.s1ap_non_ue_msg_rcvd_frm_MME\
            VS.s1ap_non_ue_msg_sent_to_MME VS.s1ap_ue_msg_rcvd_frm_MME\
            VS.s1ap_ue_msg_sent_to_MME VS.s1ap_write_replace_wrn_req_recvd_frm_MME\
            VS.s1ap_write_replace_wrn_req_recvd_emerg_frm_MME VS.s1ap_write_replace_wrn_req_discarded_frm_MME\
            VS.s1ap_write_replace_wrn_req_sent_to_Henbs VS.s1ap_kill_req_recvd_frm_MME\
            VS.active_CMAS_sessions_MME_avg VS.active_CMAS_sessions_MME_max\
            VS.active_CMAS_sessions_MME_min VS.s1ap_reset_msg_rcvd_frm_MME\
            VS.s1ap_reset_msg_sent_to_MME VS.s1ap_no_resp_to_reset_msg_sent_to_MME\
            VS.s1ap_reset_msg_sent_to_Henbs_per_MME VS.s1ap_err_msg_sent_to_MME\
            VS.s1ap_err_msg_sent_to_MME_failed_UE_S1AP_ID_validation VS.s1ap_err_msg_recvd_frm_MME\
            VS.s1ap_err_msg_recvd_frm_MME_failed_UE_S1AP_ID_validation VS.s1ap_paging_msg_ps_recvd_frm_MME\
            VS.s1ap_paging_msg_cs_recvd_frm_MME VS.s1ap_paging_msg_sent_to_Henbs\
            VS.s1ap_paging_msg_not_sent_to_Henbs VS.s1ap_paging_msg_not_sent_to_Henbs_sctp\
            VS.s1ap_paging_msg_not_sent_to_Henbs_overload VS.s1ap_S1SetupReq_msg_sent_to_MME\
            VS.s1ap_S1SetupResp_msg_received_frm_MME VS.s1ap_S1SetupResp_msg_received_frm_MME_unknown_plmns\
            VS.s1ap_S1SetupResp_msg_received_frm_MME_duplicate_mmecs VS.s1ap_S1SetupFail_received_frm_MME\
            VS.UE_conn_attempts_to_MME VS.tactive_UE_conn_Henb_avg\
            VS.tactive_UE_conn_Henb_max VS.num_UL_partial_UE_conn_time_out\
            VS.s1ap_eNB_Config_trans_sent_to_MME\
            VS.s1ap_MME_Config_trans_rcvd_frm_MME VS.s1ap_MME_Config_Update_rcvd_frm_MME\
            VS.s1ap_MME_Config_Update_rcvd_frm_MME_unknown_plmns VS.s1ap_MME_Config_rcvd_frm_MME_duplicate_mmecs\
            VS.s1ap_MME_Config_Update_Failure_sent_to_MME VS.s1ap_MME_Config_Update_sent_to_Henbs\
            VS.s1ap_Overload_Start_rcvd_frm_MME VS.s1ap_Overload_Start_sent_to_Henbs\
            VS.s1ap_Overload_Stop_rcvd_frm_MME VS.s1ap_Overload_Stop_sent_to_Henbs\
            VS.s1ap_Overload_Stop_discarded_frm_MME VS.s1ap_HO_Request_rcvd_frm_MME\
            VS.s1ap_HO_Failure_sent_to_MME_unknown_target VS.s1ap_HO_Failure_sent_to_MME_guard_timer_expires\
            VS.s1ap_HO_Notify_sent_to_MME VS.tactive_UE_conn_MME_avg\
            VS.tactive_UE_conn_MME_max VS.X2_HO_Path_Switch_Req_sent_to_MME\
            VS.X2_HO_Path_Switch_Req_Failure_rcvd_frm_MME VS.X2_HO_Path_Switch_Req_Ack_rcvd_frm_MME\
            VS.abnormal_releases_sent_to_Henbs VS.normal_releases_sent_to_Henbs\
            VS.abnormal_releases_sent_to_MME VS.normal_releases_sent_to_MME\
                              ]


                    set   arr_pm_counters(Application4G)      [list \
                       VS.henb_sctp_assoc_active VS.henb_sctp_assoc_protocol_error\
                       VS.mme_sctp_assoc_protocol_error VS.mme_sctp_assoc_active\
                       VS.s1ap_non_ue_msg_rcvd_frm_Henbs VS.s1ap_non_ue_msg_sent_to_Henbs\
                       VS.s1ap_unsupp_non_ue_msg_rcvd_frm_Henbs VS.s1ap_ue_msg_rcvd_frm_Henbs\
                       VS.s1ap_ue_msg_sent_to_Henbs VS.s1ap_reset_msg_sent_to_Henbs\
                       VS.s1ap_total_reset_msg_rcvd_frm_Henbs VS.s1ap_err_msg_recvd_frm_Henbs\
                       VS.s1ap_err_msg_recvd_frm_Henbs_failed_UE_S1AP_ID_validation VS.s1ap_err_msg_sent_to_Henbs\
                       VS.s1ap_err_msg_sent_to_Henbs_failed_UE_S1AP_ID_validation VS.s1ap_S1SetupReq_msg_recvd_frm_Henbs\
                       VS.s1ap_S1SetupResp_msg_sent_to_Henbs VS.s1ap_S1SetupFail_Unknown_Plmn_sent_to_Henbs\
                       VS.s1ap_S1SetupFail_Unspecified_sent_to_Henbs VS.s1ap_S1SetupFail_Locked_sent_to_Henbs\
                       VS.s1ap_S1SetupFail_Transport_Unavailable_sent_to_Henbs VS.MaxNumS1ConnectionsToMMEs\
                       VS.TotS1ConnectionsToHenbs VS.UE_Conn_Attempts_frm_Henbs\
                       VS.UE_Conn_Attempts_Fail_Overload VS.UE_Conn_Attempts_Fail_invalid_TAI\
                       VS.UE_Conn_Attempts_Fail_invalid_cell_id VS.s1ap_eNB_Config_trans_rcvd_frm_Henbs\
                       VS.s1ap_MME_Config_trans_sent_to_Henbs VS.s1ap_MME_Config_trans_routed_to_Henbs\
                       VS.s1ap_MME_Config_Update_Failure_rcvd_frm_Henbs VS.s1ap_MME_Config_Update_sent_to_Henbs\
                       VS.s1ap_eNB_Config_Update_rcvd_frm_Henbs VS.s1ap_eNB_Config_Update_Failure_sent_to_Henbs\
                       VS.s1ap_eNB_Config_Update_rcvd_frm_Henbs_changed_Region VS.s1ap_HO_Request_sent_to_Henbs\
                       VS.s1ap_HO_Failure_rcvd_frm_Henbs VS.X2_HO_Path_Switch_Req_rcvd_frm_Henb\
                       VS.X2_HO_Path_switch_Req_Failure_sent_to_Henbs VS.X2_HO_Path_Switch_Req_Ack_sent_to_Henbs\
                      ]

               }
               # Define the various pmpe o                 pa
               #                  parray arr_pm_counters
               set namesss [ array names arr_pm_counters]
               foreach entity $pmIpList {
                    foreach {dutIp type} $entity {break}
                    printHeader "Verifying PM counters for \"$dutIp\" \($type\)" "100" "-"
                    # Build the array map of all the valid counters that needs to be verified
                    # This array list is used as a reference for the counter verification
                    #getValidPmCounterLists -fgwNum $fgwNum -dutIp $dutIp -simType $type
                    # Wait for the PM file to get generated
                    #                    getValidPmCounterLists -fgwNum $fgwNum -dutIp $dutIp -simType $type
                    
                    print -info "Waiting till the PM XML file is generated"
                    set result [waitForPMFileToUpdate -dutIp $dutIp -simType $type -granularPeriod $granularPeriod]
                    set cmdName "sed -i   's/></>0</g' /var/pm/A*xml"
                    set t [execCommandSU -dut $dutIp -command $cmdName ]
                    # Copy and extract the PM file for verification
                    set hostIp            "127.0.0.1"
                    set destPmFilePath    "/tmp"
                    set tempPmFilePrefix  "[getOwner]_$type\_pmFile"
                    
                    switch [getNEType $dutIp] {
                         "fgw" {
                              set pmFilePath     "/var/pm"
                              set dutUserName    $::ADMIN_USERNAME
                              set dutPassword    $::ADMIN_PASSWORD
                              set execCommand    constructPmDataStruct
                              set execConsData   consolidatePMData
                              set pmArray        ARR_XML_PM_DATA
                         }
                         "sim" {
                              set pmFilePath     "[getFgwParam [string tolower $path]Path]"
                              set dutUserName    $::ROOT_USERNAME
                              set dutPassword    $::ROOT_PASSWORD
                              set execCommand    constructSimPmDataStruct
                              set execConsData   consolidateSimPMData
                              set pmArray        ARR_XML_SIM_PM_DATA
                         }
                    }
                    
                    # Delete any older files in the destPmFilePath directory
                    print -info "Deleting temp xml files on host before copying"
                    set tmpFileList [getAllFiles $hostIp $destPmFilePath [getOwner] "" "yes" "" $tempPmFilePrefix]
                    if {$tmpFileList != "" && $tmpFileList != -1} {
                         foreach tmpFile $tmpFileList {
                              file delete -force $tmpFile
                         }
                    } else {
                         print -debug "No temp xml files exists on host .. continuing"
                    }
                    
                    print -info "Copying the PM files to host machine to analyze"
                    set pmFilePath     "/var/pm"
                    set dutUserName    $::ADMIN_USERNAME
                    set dutPassword    $::ADMIN_PASSWORD
                    set execCommand    constructPmDataStruct
                    set execConsData   consolidatePMData
                    set pmArray        ARR_XML_PM_DATA
                    print -info "dutIp - $dutIp :: pmFilePath - $pmFilePath :: dutUserName $dutUserName"
                    set pmFileList  [getAllFiles $dutIp $pmFilePath $dutUserName $dutPassword "yes" "" "*xml"]
                    if {$pmFileList != "" && $pmFileList != -1} {
                         print -debug "Copying \"$pmFileList\" files to the host for analysis"
                         set tempPmFileList ""
                         set fileCount 1
                         foreach pmFile $pmFileList {
                              set localFileName "${destPmFilePath}/${tempPmFilePrefix}${fileCount}.xml"
                              set result [scpFile -remoteHost $dutIp -localFileName $localFileName -remoteUser $dutUserName -remotePassword $dutPassword -remoteFileName $pmFile]
                              if {$result == -1} {
                                   print -fail "Copying of PM file $pmFile failed"
                                   return -1
                              }
                              lappend tempPmFileList $localFileName
                              incr fileCount
                         }
                    } else {
                         print -fail "No PM files were found on the system. Cannot continue further"
                         return -1
                    }
                    
                    # Parse the pm counters and store in an array
                    print -info "Parsing the PM xml file"
                    foreach tempFile $tempPmFileList {
                         set result [eval "$execCommand $tempFile"]
                         if {$result != 0} {
                              print -fail "Parsing of PM XML file $tempFile failed"
                              return -1
                         }
                         
                         # Validate the XML file after parsing
                         # This would be added later
                         # Here we would check if the xml schema is proper or not
                         set result [validateXmlSchema -xmlFile $tempFile -schema ""]
                    }
                    
                    # Consoludate the PM data
                    #                    catch {eval $execConsData}
                    
                    # If we get more than one XML file during script execution,
                    # we will add the elements to get total stats
#                  print -info "1--> If we get more than one XML file during script execution . we will add the elements to get total stats"
                    set PM_COUNTER_UNCHECKED ""
                    set pmVerifyList         ""
                    set levelUp   [info level]
                    #                    set levelUp [expr $level - 1]
                    foreach counterType [array names arr_pm_counters] {
                         if {$counterType == "skipList"} {continue}
#                     print -info "2--->  counterType $counterType  ######-----------------------------------------------------###########"
                         switch -exact [string trim $counterType] {
                              MME         {set maxMoid $noOfMMEs}
                              MMERegion   {set maxMoid $noOfMMERegions}
                              default     {set maxMoid 1}
                         }
                         
                         # The counters need to be checked for multiple instances of MOID
                         # Repeat the check for all the instances
#                         print -info "3---> ######-----------------------------------------------------###########"
                         for {set moidNo 1} {$moidNo <= $maxMoid} {incr moidNo} {
                              switch -regexp [string tolower $counterType] {
                                   "^Application4G$"      {set tag "${counterType}${moidNo}"}   
                                   "^(henb|mme|sgsn)$"    {set tag "${counterType}${moidNo}"}         
                                   default             {set tag "${counterType}${moidNo}"}
                              }
                              
                              # Verify each counter within the group
                              foreach counter $arr_pm_counters($counterType) {
                                   set counter [ string trim $counter ]
                                   # Check if the user has defined the PM counter to be verified
                                   # If yes verify the counter against the extracted value
                                   set  newVar "$tag\.$counter"
                                   unset newVar
                                   upvar 1 "$tag\.$counter" newVar
                                   
                             #      print -info "**^*^*^*^*^*^ $counterType -- counterType --    $tag\.$counter   newVar $newVar "
                                   if {[info exists newVar]} {
                                        if {[info exists [set pmArray]($tag,$counter)]} {
                                             if {[llength [set [set pmArray]($tag,$counter)]] > 1} {
                                                set pmcounter [expr [join [set [set pmArray]($tag,$counter)] +  ]]
                                                print -info "pm $pmcounter  \n \n \n -111- [expr [join [set [set pmArray]($tag,$counter)] + ]]"
                                             } else {
                                                  set pmcounter [set [set pmArray]($tag,$counter)]
                                             }
                              #          print -info "--- $counterType -- counterType -- $tag $counter $newVar "
#############################################################################################################
                                        if {[info exists [set pmArray]($tag,$counter)]} {
                                          if  { [regexp "tactive" $counter ] } {
                                             set orgValue [set [set pmArray]($tag,$counter)]
                                             set minValue [expr 0.7 * $orgValue]
                                             set maxValue [expr 1.3 * $orgValue]
                                             if {$newVar >= $minValue && $newVar <= $maxValue} {
                                                  set status "\[PASS\]"
                                             } else {
                                                  set status "\[FAIL\]"
                                                  set pmVerify 1
                                             }
                                             set pmValue [set [set pmArray]($tag,$counter)]
                                        lappend pmVerifyList "$tag $counter $status $newVar $pmValue"
                                        print -info " ===================== continue =========== $counter "
                                        continue
                                        }
                                          if  { [regexp "s1ap_S1SetupReq_msg_sent_to_MME" $counter ] } {
                                             set orgValue [set [set pmArray]($tag,$counter)]
                                             set minValue [expr 0.7 * $orgValue]
                                             set maxValue [expr 1.3 * $orgValue]
                                             if {$newVar > 0 } {
                                                  set status "\[PASS\]"
                                             } else {
                                                  set status "\[FAIL\]"
                                                  set pmVerify 1
                                             }
                                             set pmValue [set [set pmArray]($tag,$counter)]
                                        lappend pmVerifyList "$tag $counter $status $newVar $pmValue"
                                        print -info " ===================== continue =========== $counter "
                                        continue
                                        }
                                        print -info " ===================== continue"
                                        }
#############################################################################################################
                                        if {[info exists [set pmArray]($tag,$counter)]} {
                                             if {[set [set pmArray]($tag,$counter)] == $newVar} {
                                                  set status "\[PASS\]"
                                             } else {
                                                  set status "\[FAIL\]"
                                                  set pmVerify 1
                                             }
                                             set pmValue [set [set pmArray]($tag,$counter)]
                                        } else {
                                             set status "\[FAIL\]"
                                             set pmVerify 1
                                             set pmValue "__UNKNOWN__"
                                        }
                                        lappend pmVerifyList "$tag $counter $status $newVar $pmValue"
                                   } else {
                                        # Second level of verification
                                        # If the user has not defined the counter to be verified and if the value of counter
                                        # is greater then 0 then print the counter to get user attention that the counter value has incremented
 #                                       print -info "5---> ######-----------------------------------------------------###########"
                                        if {[info exists [set pmArray]($tag,$counter)]} {
                                             if {[lsearch -regexp $arr_pm_counters(skipList) [set [set pmArray]($tag,$counter)]] >= 0} {
                                                  # This counter is part of the skipList and should not be verified
                                                  continue
                                             } else {
                                                  # If the value of counter is greater then zero append to the list
                                                  if {[set [set pmArray]($tag,$counter)] > 0} {
                                                       lappend PM_COUNTER_UNCHECKED "$tag,$counter [set [set pmArray]($tag,$counter)]"
                                                  }
                                             }
                                             
                                        } else {
                                             # If the counter is not part of parsed data define it as unknown
                                             lappend PM_COUNTER_UNCHECKED "$tag,$counter __UNKNOWN__"
  #                                           print -info "6---> ######-----------------------------------------------------###########"
                                        }
                                   }
                              }
                         }
                         print -info " counterType is $counterType "
                    }
                    
                    # Print the extracted data
                    print -info "7---> ######-----------------------------------------------------###########"
                    set header    "GROUP COUNTER STATUS EXPECTED ACTUAL"
                    set alignList "l l c c c"
                    set spaceList "12 72 9 13 13"
                    print -nolog ""
                    printTablurFormat -header $header -dataList $pmVerifyList -alignList $alignList -spaceList $spaceList
                    print -nolog ""
                    
                    # Dump the list of counters whose values are greater than 0 and needs user attention
                    if {![isEmptyList $PM_COUNTER_UNCHECKED]} {
                         set header    "GROUP,COUNTER VALUE"
                         set alignList "l c"
                         set spaceList "75 13"
                         print -nolog ""
                         printTablurFormat -header $header -dataList $PM_COUNTER_UNCHECKED -alignList $alignList -spaceList $spaceList
                         print -nolog ""
                    }
                    
               }
               if {$pmVerify} {
                    print -fail "Pm counter verification failed"
                    return -1 
               } else {
                    print -pass "PM counter verification successfull"
                    return 0
               }
          }
     }
}
}

proc checkForXMLFile { time } {
     set HeNBGWNum 0
     print -info " in check XML FILES proc "
     for {set i 0} { $i < $time} {incr i} {
          set dut  [getActiveBonoIp $HeNBGWNum]
          set cmd  "ls -1 /var/pm"
          set t [execCommandSU -dut $dut -command $cmd ]
          set r [extractOutputFromResult [string trim $t]]
          set waiting [ expr $time - $i ]
          print -info " waiting for $waiting seconds "
          if { $r != "" } { return $r }
          sleep 1
     }
}
proc cleanUpStaleXmlFiles {args} {
     #-
     #- This procedure is used to cleanup any slate xml files that may be present in the system
     #-
     #- @return 0 on success and -1 on failure
     #-
     
     parseArgs args \
               [list\
               [list fgwNum               "optional"    "numeric"          "0"               "ip address of the host where backdoor port is opened"] \
               ]
     
     set HeNBGWNum 0
     set dut  [getActiveBonoIp $HeNBGWNum]
     set cmd " rm -f /var/pm/*xml"
     set result [execCommandSU -dut $dut -command $cmd ]
     print -info " - cleaning Up Stale Xml Files "
     return 0
}

proc waitForPMFileToUpdate {args} {
     #-
     #- This procedure is used to wait for the PM files to get updated
     #-
     #- @return 0 on success and -1 on failure
     #-
     parseArgs args \
               [list\
               [list dutIp                "optional"    "ip"        "[getActiveBonoIp]" "The ip address of the DUT where the pm updattion has to be verified"] \
               [list simType              "optional"    "string"    "_"                 "The simulator type"] \
               [list granularPeriod       "optional"    "numeric"   "0"                 "The granularity period of PM file generation"] \
               ]
     
     set path "/var/pm"
     switch [getNEType $dutIp] {
          "fgw" {
               set path "/var/pm"
          }
          "sim" {
               set path [getFgwParam "[string tolower $simType]Path"]
          }
     }
          set NumOfPMFiles 1
     for {set i 0} { $i <  330 } {incr i 30} {
               print -info " waiting for 1 seconds "
               set fgwNum 0  
               set dut  [getActiveBonoIp $fgwNum]
               set cmd  "ls -1 /var/pm | wc -l"
               set t [execCommandSU -dut $dut -command $cmd ]
               set NumOfPMFilesOnGW [extractOutputFromResult [string trim $t]]
               print -info " NumOfPMFilesOnGW is $NumOfPMFilesOnGW =========== "
               print -info " NumOfPMFilesOnGW is $NumOfPMFilesOnGW  =========== "
               print -info " t is $t ================ "
               if { $NumOfPMFilesOnGW == $NumOfPMFiles } { return $NumOfPMFilesOnGW }
          set cmd  "ls -1 $path"
          set t [execCommandSU -dut $dutIp -command $cmd ]
          set r [extractOutputFromResult [string trim $t]]

          set waiting [ expr 330 - $i ]
          print -info " waiting for $i  seconds "
          if { $r >= 1 } { return $r }
          print -info " waiting for $waiting seconds "
          halt  $i

               set waiting [ expr 900 - $i ]
               print -info " waiting for $waiting seconds "
               sleep 1
          }
}

proc faa {} {
     proc waitForPMFileToUpdate {granularPeriod} {
          #-
          #- This procedure is used to wait for the PM files to get updated
          #-
          #- @return 0 on success and -1 on failure
          #-
          set HeNBGWNum 0
          #     return 0
          #     set granularPeriod 900
          set PMExecTime  [expr [clock seconds] - $::PM_START_TIME ]
          set Itrn   [expr $PMExecTime / $granularPeriod ]
          set NumOfPMFiles [ incr $Itrn]
          set dut  [getActiveBonoIp $HeNBGWNum]
          print -info " PMExecTime - $PMExecTime ---- Itrn --- $Itrn ---  dut $dut --- granularPeriod is $granularPeriod "
          print -info " Enetering  waitForPMFileToUpdate proc -waiting --- "
          for {set i 0} { $i < 300 } {incr i} {
               print -info " waiting for 1 seconds "
               set dut  [getActiveBonoIp $HeNBGWNum]
               set cmd  "ls -1 /var/pm | wc -l"
               set t [execCommandSU -dut $dut -command $cmd ]
               set NumOfPMFilesOnGW [extractOutputFromResult [string trim $t]]
               print -info " NumOfPMFilesOnGW is $NumOfPMFilesOnGW =========== "
               print -info " NumOfPMFiles is $NumOfPMFiles =========== "
               print -info " t is $t ================ "
               if { $NumOfPMFilesOnGW == $NumOfPMFiles } { return $NumOfPMFilesOnGW }
               set waiting [ expr 900 - $i ]
               print -info " waiting for $waiting seconds "
               sleep 1
          }
          print -info " Leaving waitForPMFileToUpdate proc "
     }
}
proc aa {} {
     proc awaitForPMFileToUpdate {} {
          #-
          #- This procedure is used to wait for the PM files to get updated
          #-
          #- @return 0 on success and -1 on failure
          #-
          set HeNBGWNum 0
          set dut  [getActiveBonoIp $HeNBGWNum]
          for {set i 0} { $i < 900 } {incr i} {
               set dut  [getActiveBonoIp $HeNBGWNum]
               set cmd  "ls -1 /var/pm/*xml"
               set t [execCommandSU -dut $dut -command $cmd ]
               set r [extractOutputFromResult [string trim $t]]
               set waiting [ expr 900 - $i ]
               print -info " waiting for $waiting seconds "
               if { $r != "" } { return $r }
               sleep 1
          }
     }
}
proc validateXmlSchema {args} {
     #-
     #- This procedure is used to validate the xml file against schema
     #-
     #- @return 0 on success and -1 on failure
     #-
     
     parseArgs args \
               [list\
               [list xmlFile          "mandatory"    "file"          "_"               "The XML file that needs to be validated"] \
               [list schema           "optional"     "file"          "_"               "The XML schema file used for validation"] \
               ]
     return 0
}

proc verifyPMEthernetCounters {args} {
     #-
     #- This procedure is used to verify the PM counters
     #- It builds the data structure as per TAG "Measurement Family"
     #-
     #- @return 0 on success and -1 on failure
     #-
     
     global ARR_XML_PM_DATA
     set pmVerify 0
     parseArgs args \
               [list\
               [list fgwNum               "optional"    "numeric"          "0"               "ip address of the host where backdoor port is opened"] \
               [list operation            "optional"    "init|verify"      "verify"          "The operation to be performed"] \
               [list pmMoid               "optional"    "string"           "__UN_DEFINED__"  "The PM Moids for test"] \
               [list noOfMMEs             "optional"    "string"           "1"               "The number of MMEs configures"] \
               [list noOfMMERegions       "optional"    "string"           "1"               "The number of MMEs configures"] \
               [list granularPeriod       "optional"    "string"           "min5"            "Configure the value of granular period in OAM_Preconfig.xml file"  ]
     ]
     
     if { [ info exists  granularPeriod ] } {
          set granularPeriod [ expr [regexp -inline -- {-?\d+(?:\.\d+)?} $granularPeriod] * 60 ]
     } else {
          set granularPeriod 300
          print -info " Default value of 300 seconds set as granularPeriod "
     }
     
     set pmIpList [list "[getActiveBonoIp $fgwNum] fgw"]
     # If user defined operation is init then cleanup all the stalexml files from the system
     switch $operation {
          "init" {
               set ::PM_START_TIME [clock seconds]
               print -info " Value of Time is $::PM_START_TIME "
               foreach entity $pmIpList {
                    foreach {ip type} $entity {break}
                    set result [updateValAndExecute "cleanUpStaleXmlFiles -fgwNum fgwNum -dutIp ip -simType type"]
                    if {$result != 0} {
                         print -fail "Cleanup of stale XML files on the $ip\($type\) failed"
                         set pmVerify 1
                    } else {
                         print -pass "Successfully Cleanuped up all stale XML files on $ip\($type\)"
                    }
               }
               return 0
          }
          "verify" {
               if { 1 } {
                    set   arr_pm_counters(Application4G)      [list \
                              VS.10GPort1RxPkts VS.10GPort1TxPkts VS.10GPort2RxPkts VS.10GPort2TxPkts \
                              VS.1GPort1RxPkts VS.1GPort2RxPkts VS.1GPort1TxPkts VS.1GPort2TxPkts \
                              VS.10GPort1RxMBytes VS.10GPort2RxMBytes VS.10GPort1TxMBytes VS.10GPort2TxMBytes \
                              VS.1GPort1RxMBytes VS.1GPort2RxMBytes VS.1GPort1TxMBytes VS.1GPort2TxMBytes \
                              VS.Bono1GEthTxPktsMalban1 VS.ExternalPortTxMBytes VS.ExternalPortRxMBytes  \
                     ]

               }

               #                  parray arr_pm_counters
               set namesss [ array names arr_pm_counters]
               foreach entity $pmIpList {
                    foreach {dutIp type} $entity {break}
                    printHeader "Verifying PM counters for \"$dutIp\" \($type\)" "100" "-"
                    # Build the array map of all the valid counters that needs to be verified
                    # This array list is used as a reference for the counter verification
                    #getValidPmCounterLists -fgwNum $fgwNum -dutIp $dutIp -simType $type
                    # Wait for the PM file to get generated
                    #                    getValidPmCounterLists -fgwNum $fgwNum -dutIp $dutIp -simType $type
                    
                    print -info "Waiting till the PM XML file is generated"
                    set result [waitForPMFileToUpdate -dutIp $dutIp -simType $type -granularPeriod $granularPeriod]
                    set cmdName "sed -i   's/></>0</g' /var/pm/A*xml"
                    set t [execCommandSU -dut $dutIp -command $cmdName ]
                    # Copy and extract the PM file for verification
                    set hostIp            "127.0.0.1"
                    set destPmFilePath    "/tmp"
                    set tempPmFilePrefix  "[getOwner]_$type\_pmFile"
                    
                    switch [getNEType $dutIp] {
                         "fgw" {
                              set pmFilePath     "/var/pm"
                              set dutUserName    $::ADMIN_USERNAME
                              set dutPassword    $::ADMIN_PASSWORD
                              set execCommand    constructPmDataStruct
                              set execConsData   consolidatePMData
                              set pmArray        ARR_XML_PM_DATA
                         }
                         "sim" {
                              set pmFilePath     "[getFgwParam [string tolower $path]Path]"
                              set dutUserName    $::ROOT_USERNAME
                              set dutPassword    $::ROOT_PASSWORD
                              set execCommand    constructSimPmDataStruct
                              set execConsData   consolidateSimPMData
                              set pmArray        ARR_XML_SIM_PM_DATA
                         }
                    }
                    
                    # Delete any older files in the destPmFilePath directory
                    print -info "Deleting temp xml files on host before copying"
                    set tmpFileList [getAllFiles $hostIp $destPmFilePath [getOwner] "" "yes" "" $tempPmFilePrefix]
                    if {$tmpFileList != "" && $tmpFileList != -1} {
                         foreach tmpFile $tmpFileList {
                              file delete -force $tmpFile
                         }
                    } else {
                         print -debug "No temp xml files exists on host .. continuing"
                    }
                    
                    print -info "Copying the PM files to host machine to analyze"
                    set pmFilePath     "/var/pm"
                    set dutUserName    $::ADMIN_USERNAME
                    set dutPassword    $::ADMIN_PASSWORD
                    set execCommand    constructPmDataStruct
                    set execConsData   consolidatePMData
                    set pmArray        ARR_XML_PM_DATA
                    print -info "dutIp - $dutIp :: pmFilePath - $pmFilePath :: dutUserName $dutUserName"
                    set pmFileList  [getAllFiles $dutIp $pmFilePath $dutUserName $dutPassword "yes" "" "*xml"]
                    if {$pmFileList != "" && $pmFileList != -1} {
                         print -debug "Copying \"$pmFileList\" files to the host for analysis"
                         set tempPmFileList ""
                         set fileCount 1
                         foreach pmFile $pmFileList {
                              set localFileName "${destPmFilePath}/${tempPmFilePrefix}${fileCount}.xml"
                              set result [scpFile -remoteHost $dutIp -localFileName $localFileName -remoteUser $dutUserName -remotePassword $dutPassword -remoteFileName $pmFile]
                              if {$result == -1} {
                                   print -fail "Copying of PM file $pmFile failed"
                                   return -1
                              }
                              lappend tempPmFileList $localFileName
                              incr fileCount
                         }
                    } else {
                         print -fail "No PM files were found on the system. Cannot continue further"
                         return -1
                    }
                    
                    # Parse the pm counters and store in an array
                    print -info "Parsing the PM xml file"
                    foreach tempFile $tempPmFileList {
                         set result [eval "$execCommand $tempFile"]
                         if {$result != 0} {
                              print -fail "Parsing of PM XML file $tempFile failed"
                              return -1
                         }
                         
                         # Validate the XML file after parsing
                         # This would be added later
                         # Here we would check if the xml schema is proper or not
                         set result [validateXmlSchema -xmlFile $tempFile -schema ""]
                    }
                    
                    # Consoludate the PM data
                    #                    catch {eval $execConsData}
                    
                    # If we get more than one XML file during script execution,
                    # we will add the elements to get total stats
#                  print -info "1--> If we get more than one XML file during script execution . we will add the elements to get total stats"
                    set PM_COUNTER_UNCHECKED ""
                    set pmVerifyList         ""
                    set levelUp   [info level]
                    #                    set levelUp [expr $level - 1]
                    foreach counterType [array names arr_pm_counters] {
                         if {$counterType == "skipList"} {continue}
#                     print -info "2--->  counterType $counterType  ######-----------------------------------------------------###########"
                         switch -exact [string trim $counterType] {
                              MME         {set maxMoid $noOfMMEs}
                              MMERegion   {set maxMoid $noOfMMERegions}
                              default     {set maxMoid 1}
                         }
                         
                         # The counters need to be checked for multiple instances of MOID
                         # Repeat the check for all the instances
#                         print -info "3---> ######-----------------------------------------------------###########"
                         for {set moidNo 1} {$moidNo <= $maxMoid} {incr moidNo} {
                              switch -regexp [string tolower $counterType] {
                                   "^Application4G$"      {set tag "${counterType}${moidNo}"}   
                                   "^(henb|mme|sgsn)$"    {set tag "${counterType}${moidNo}"}         
                                   default             {set tag "${counterType}${moidNo}"}
                              }
                              
                              # Verify each counter within the group
                              foreach counter $arr_pm_counters($counterType) {
                                   set counter [ string trim $counter ]
                                   # Check if the user has defined the PM counter to be verified
                                   # If yes verify the counter against the extracted value
                                   set  newVar "$tag\.$counter"
                                   unset newVar
                                   upvar 1 "$tag\.$counter" newVar
                                   
                             #      print -info "**^*^*^*^*^*^ $counterType -- counterType --    $tag\.$counter   newVar $newVar "
                                   if {[info exists newVar]} {
                                        if {[info exists [set pmArray]($tag,$counter)]} {
                                             if {[llength [set [set pmArray]($tag,$counter)]] > 1} {
                                                set pmcounter [expr [join [set [set pmArray]($tag,$counter)] +  ]]
                                                print -info "pm $pmcounter  \n \n \n -111- [expr [join [set [set pmArray]($tag,$counter)] + ]]"
                                             } else {
                                                  set pmcounter [set [set pmArray]($tag,$counter)]
                                             }
                              #          print -info "--- $counterType -- counterType -- $tag $counter $newVar "
                                        if {[info exists [set pmArray]($tag,$counter)]} {
					     set orgValue [set [set pmArray]($tag,$counter)]
					     set minValue [expr 0.8 * $orgValue]
					     set maxValue [expr 1.2 * $orgValue]
                                             if {$newVar >= $minValue && $newVar <= $maxValue} {
                                                  set status "\[PASS\]"
                                             } else {
                                                  set status "\[FAIL\]"
                                                  set pmVerify 1
                                             }
                                             set pmValue [set [set pmArray]($tag,$counter)]
                                        } else {
                                             set status "\[FAIL\]"
                                             set pmVerify 1
                                             set pmValue "__UNKNOWN__"
                                        }
                                        lappend pmVerifyList "$tag $counter $status $newVar $pmValue"
                                   } else {
                                        # Second level of verification
                                        # If the user has not defined the counter to be verified and if the value of counter
                                        # is greater then 0 then print the counter to get user attention that the counter value has incremented
 #                                       print -info "5---> ######-----------------------------------------------------###########"
                                        if {[info exists [set pmArray]($tag,$counter)]} {
                                             if {[lsearch -regexp $arr_pm_counters(skipList) [set [set pmArray]($tag,$counter)]] >= 0} {
                                                  # This counter is part of the skipList and should not be verified
                                                  continue
                                             } else {
                                                  # If the value of counter is greater then zero append to the list
                                                  if {[set [set pmArray]($tag,$counter)] > 0} {
                                                       lappend PM_COUNTER_UNCHECKED "$tag,$counter [set [set pmArray]($tag,$counter)]"
                                                  }
                                             }
                                             
                                        } else {
                                             # If the counter is not part of parsed data define it as unknown
                                             lappend PM_COUNTER_UNCHECKED "$tag,$counter __UNKNOWN__"
  #                                           print -info "6---> ######-----------------------------------------------------###########"
                                        }
                                   }
                              }
                         }
                         print -info " counterType is $counterType "
                    }
                    
                    # Print the extracted data
                    print -info "7---> ######-----------------------------------------------------###########"
                    set header    "GROUP COUNTER STATUS EXPECTED ACTUAL"
                    set alignList "l l c c c"
                    set spaceList "12 72 9 13 13"
                    print -nolog ""
                    printTablurFormat -header $header -dataList $pmVerifyList -alignList $alignList -spaceList $spaceList
                    print -nolog ""
                    
                    # Dump the list of counters whose values are greater than 0 and needs user attention
                    if {![isEmptyList $PM_COUNTER_UNCHECKED]} {
                         set header    "GROUP,COUNTER VALUE"
                         set alignList "l c"
                         set spaceList "75 13"
                         print -nolog ""
                         printTablurFormat -header $header -dataList $PM_COUNTER_UNCHECKED -alignList $alignList -spaceList $spaceList
                         print -nolog ""
                    }
                    
               }
               if {$pmVerify} {
                    print -fail "Pm counter verification failed"
                    return -1 
               } else {
                    print -pass "PM counter verification successfull"
                    return 0
               }
          }
     }
}
}

proc execSARcmdonHeNBGW {args} {
     #-
     #-This procedure is used to execute SAR command on GW.
     #-Oftenly used with 'proc analyzeSARoutput'
     #-intervalDuration can be used to specify the time duration after which the command will be executed
     #-noofTimes can be used to specify the number of times SAR should be executed based on which the average will be calculated.
     
     global SARexecutionTime

     parseArgs args \
               [list \
               [list fgwNum                   "optional"     "numeric"        "0"       "The dut instance in the testbed file" ] \
               [list intervalDuration         "optional"     "numeric"        "1"      "The time duration for the command"    ] \
               [list noofTimes                "optional"     "numeric"        "180"       "The no. of times the command shall be executed" ]\
               [list fileName                 "optional"     "string"         "/tmp/trasferSARdate.txt"       "The loc of the file where the output of SAR command will be stored" ]\
               [list fileNameonGW             "optional"     "string"         "/home/admin/trasferSARdataexeconHeNBGW.txt"       "The loc of the file where the output of SAR command will be stored" ]\
               [list localFile                "optional"     "string"         "__UN_DEFINED__"       "The loc of the file where the output of SAR command will be stored after copying from the GW" ]\
               ]
     
     set dut [getActiveBonoIp]
     set localHost     [getConnectedHostMgmntIp 4]
     
     if {![info exists localFile]} {
          set localFile   "/tmp/[getOwner]_[file tail $fileName]"
     }
     
     if {![info exists boardIp]} {
          set fgwIpList [getActiveBonoIp $fgwNum]
     } else {
          if {$boardIp == "all"} {
               if {[isATCASetup]} {
                    et fgwIpList $::BONO_IP_LIST
               } else {
                    set fgwIpList [getActiveBonoIp $fgwNum]
               }
          } else {
               set fgwIpList $boardIp
          }
     }
     
     set cmd "sar -n DEV $intervalDuration $noofTimes > $fileName &"
     set fgwIp [getActiveBonoIp $fgwNum]
     set cmd1 "sar -n DEV $intervalDuration $noofTimes > $fileNameonGW &"
     
     set simIpList  [getDataFromConfigFile "getMmeSimulatorHostIp" $fgwNum]
     # Start or stop the application on the board
     foreach simIp $simIpList {
          print -debug "Performing \"$cmd\" on \"$simIp\""
          set SARexecutionTime [clock seconds]
          set result [execCommandSU -dut $simIp -command $cmd]
          if {[regexp "ERROR: " $result]} {
               print -fail "Not able execute $cmd on $simIp"
               return -1
          } else {
               print -info "Successfully executed $cmd on $simIp"
          }
          set result [execCommandSU -dut $fgwIp -command $cmd1]
          if {[regexp "ERROR: " $result]} {
               print -fail "Not able execute $cmd on $fgwIp"
               return -1
          } else {
               print -info "Successfully executed $cmd on $fgwIp"
          }
          
     }
     
     return 0
}

proc analyzeSARoutput {args} {
     #-
     #-This is the proc to parse SAR file output and display the same in the Log
     
     global SARexecutionTime 

     parseArgs args \
               [list \
               [list fgwNum         "optional"     "numeric"        "0"       "The dut instance in the testbed file" ] \
               [list fileName                 "optional"     "string"         "/tmp/trasferSARdate.txt"       "The loc of the file where the output of SAR command will be stored" ]\
               [list fileNameonGW                 "optional"     "string"         "/home/admin/trasferSARdataexeconHeNBGW.txt"       "The loc of the file where the output of SAR command will be stored" ]\
               [list localFile      "optional"     "string"         "__UN_DEFINED__"       "File Path and Name" ] \
               [list localFileofGW      "optional"     "string"         "__UN_DEFINED__"       "File Path and Name" ] \
               [list intervalDuration         "optional"     "numeric"        "180"      "The time duration for the command"    ] \
               [list interface                "optional"     "string"         "10Geth0"  "The interface name whose value has to be fetched"    ] \
               ]
     
     print -info "The SAR Execution time was : $SARexecutionTime"
     set SARextractionTime [clock seconds]
     print -info "The SAR Extraction Time is : $SARextractionTime"
     set SARexpectedExtractionTime [expr "$SARexecutionTime + $intervalDuration"]
     if {$SARexpectedExtractionTime > $SARextractionTime} {
          set sleepTime [expr "$SARexpectedExtractionTime - $SARextractionTime + 20"]
          halt $sleepTime
     }
     
     set dut [getActiveBonoIp]
     set simIp [getDataFromConfigFile "getMmeSimulatorHostIp" $fgwNum]
     set localHost     [getConnectedHostMgmntIp 4]
     
     if {![info exists localFile]} {
          set localFile "/tmp/[getOwner]_[file tail $fileName]"
     }
     if {![info exists localFileofGW]} {
          set localFileofGW "/tmp/[getOwner]_[file tail $fileNameonGW]"
     }
     
     #-The file generated by SAR command is copied from simulator to the local view
     set result [scpFile -remoteHost $simIp -localFileName $localFile -remoteUser "root" -remotePassword "$::ROOT_PASSWORD" \
               -remoteFileName $fileName -localHost $localHost]
     if {$result != 0} {
          print -fail "Failed to retrieve $fileName from $dut. Cannot perform data updation"
          return -1
     } else {
          print -pass "Successfully copied SAR output from GW to local host"
     }

     set cmd "\n"
     set result [execCommandSU -dut $dut -command "$cmd"]

     #-The file generated by SAR command is copied from GW to the local view
     set cmd "scp $fileNameonGW [getOwner]@192.168.0.200:$localFileofGW"
     set result [execCommandSU -dut $dut -command "$cmd" -cmdPasswd "[getOwner]"]
     #set result [scpFile -remoteHost $dut -localFileName $localFileofGW -remoteUser "admin" -remotePassword "$::ADMIN_PASSWORD" \
               -remoteFileName $fileNameonGW -localHost $localHost]
     if {$result == -1} {
          print -fail "Failed to retrieve $fileName from $dut. Cannot perform data updation"
          return -1
     } else {
          print -pass "Successfully copied SAR output from GW to local host"
     }
    
     set 10GcountersList ""

     #set data [exec cat $localFile]
     set data [exec cat $localFileofGW]
     print -info "The value of the data obtained from the SAR output : \n$data"
     
     print -info "Following is the detailed value of Received and transmitted packets from the GW on different ports"
     set header    "SAR Statictics on HeNBGW"
     printHeader "$header" "50" "-"
     foreach line [split $data "\r\n"] {
          if { [regexp "Average:" $line] } {
               #print -info "The Average value of received and transmitted packets are : \n$line"
               
               set lineValue1 [lindex $line 1]
               set lineValue2 [lindex $line 2]
               set lineValue3 [lindex $line 3]
               set lineValue4 [lindex $line 4]
               set lineValue5 [lindex $line 5]
               
 	       if {$interface == "10Geth0"} {               
	               if {$lineValue1 == "10Geth0"} {
	                    set 10Geth0RxPkts $lineValue2
				print -debug "The raw value in the file is :$10Geth0RxPkts"
	                    set 10Geth0RxPkts [expr $10Geth0RxPkts * 180]
				print -debug "The raw value in the file is :$10Geth0RxPkts"
			    lappend 10GcountersList $10Geth0RxPkts

	                    set 10Geth0TxPkts $lineValue3
				print -debug "The raw value in the file is :$10Geth0TxPkts"
	                    set 10Geth0TxPkts [expr $10Geth0TxPkts * 180]
				print -debug "The raw value in the file is :$10Geth0TxPkts"
			    lappend 10GcountersList $10Geth0TxPkts

	                    set 10Geth0RxMBytes $lineValue4
				print -debug "The raw value in the file is :$10Geth0RxMBytes"
	                    set 10Geth0RxMBytes [expr $10Geth0RxMBytes * 180]
				print -debug "The raw value in the file is :$10Geth0RxMBytes"
	                    set 10Geth0RxMBytes [expr $10Geth0RxMBytes / 1048576]
				print -debug "The raw value in the file is :$10Geth0RxMBytes"
			    lappend 10GcountersList $10Geth0RxMBytes

	                    set 10Geth0TxMBytes $lineValue5
				print -debug "The raw value in the file is :$10Geth0TxMBytes"
	                    set 10Geth0TxMBytes [expr $10Geth0TxMBytes * 180]
				print -debug "The raw value in the file is :$10Geth0TxMBytes"
	                    set 10Geth0TxMBytes [expr $10Geth0TxMBytes / 1048576]
				print -debug "The raw value in the file is :$10Geth0TxMBytes"
			    lappend 10GcountersList $10Geth0TxMBytes
	               }
	       } elseif {$interface == "10Geth1"} {
	               if {$lineValue1 == "10Geth1"} {
	                    set 10Geth1RxPkts $lineValue2
				print -debug "The raw value in the file is :$10Geth1RxPkts"
	                    set 10Geth1RxPkts [expr $10Geth1RxPkts * 180]
				print -debug "The raw value in the file is :$10Geth1RxPkts"
			    lappend 10GcountersList $10Geth1RxPkts

	                    set 10Geth1TxPkts $lineValue3
				print -debug "The raw value in the file is :$10Geth1TxPkts"
	                    set 10Geth1TxPkts [expr $10Geth1TxPkts * 180]
				print -debug "The raw value in the file is :$10Geth1TxPkts"
			    lappend 10GcountersList $10Geth1TxPkts

	                    set 10Geth1RxMBytes $lineValue4
				print -debug "The raw value in the file is :$10Geth1RxMBytes"
	                    set 10Geth1RxMBytes [expr $10Geth1RxMBytes * 180]
				print -debug "The raw value in the file is :$10Geth1RxMBytes"
	                    set 10Geth1RxMBytes [expr $10Geth1RxMBytes / 1048576]
				print -debug "The raw value in the file is :$10Geth1RxMBytes"
			    lappend 10GcountersList $10Geth1RxMBytes

	                    set 10Geth1TxMBytes $lineValue5
				print -debug "The raw value in the file is :$10Geth1TxMBytes"
	                    set 10Geth1TxMBytes [expr $10Geth1TxMBytes * 180]
				print -debug "The raw value in the file is :$10Geth1TxMBytes"
	                    set 10Geth1TxMBytes [expr $10Geth1TxMBytes / 1048576]
				print -debug "The raw value in the file is :$10Geth1TxMBytes"
			    lappend 10GcountersList $10Geth1TxMBytes
	               }
               }
              print -nolog "$lineValue1 --> $lineValue2"
          }
     }
      
     return $10GcountersList
     
}

proc execIfconfigcmdonHeNBGW {args} {
     #-
     #-This procedure is used to execute ifconfig command on GW.
     #-Oftenly used with 'proc analyzeIfconfigoutput'
     #-intervalDuration can be used to specify the time duration after which the command will be executed
     #-noofTimes can be used to specify the number of times SAR should be executed based on which the average will be calculated.
     
     parseArgs args \
               [list \
               [list fgwNum                   "optional"     "numeric"        "0"       "The dut instance in the testbed file" ] \
               [list interface                "optional"     "string"         "10G"     "The interface name with which this cmd is executed from our script on the HeNBGW"    ] \
               [list instance                 "optional"     "string"         "first"   "The instance num when this cmd is executed from our script on the HeNBGW"    ] \
               [list portNum                  "optional"     "string"         "0"       "The port on which ifconfig  shall be executed" ]\
               [list fileLocation             "optional"     "string"         "/tmp/"       "The loc of the file where the output of SAR command will be stored" ]\
               [list localFile                "optional"     "string"         "__UN_DEFINED__"       "The loc of the file where the output of SAR command will be stored after copying from the GW" ]\
               ]
     
     #set dut [getActiveBonoIp]
     #set localHost     [getConnectedHostMgmntIp 4]
     
     set fileName eth${portNum}data${instance}.txt
     set fileName "${fileLocation}${fileName}"
     
     if {![info exists localFile]} {
          set localFile   "/tmp/[getOwner]_[file tail $fileName]"
     }
     
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
    
     if {$interface == "10G"} { 
     	  set cmd "ifconfig 10Geth$portNum > $fileName"
     } elseif {$interface == "1G"} {
     	  set cmd "ifconfig eth$portNum > $fileName"
     } else {
	  print -fail "Wrong Interface name given...Exiting the script..."
          return -1
     }
     
     # set simIpList  [getDataFromConfigFile "getMmeSimulatorHostIp" $fgwNum]
     # Start or stop the application on the board
     foreach fgwIp $fgwIpList {
          print -debug "Performing \"$cmd\" on \"$fgwIp\""
          set result [execCommandSU -dut $fgwIp -command $cmd]
          if {[regexp "ERROR: " $result]} {
               print -fail "Not able execute $cmd on $fgwIp"
               return -1
          } else {
               print -info "Successfully executed $cmd on $fgwIp"
          }
     }
     
     return 0
}

proc analyzeIfconfigoutput {args} {
     #-
     #-This is the proc to parse ifconfig file output and display the same in the Log
     
     #global SARexecutionTime 

     parseArgs args \
               [list \
               [list fgwNum         "optional"     "numeric"        "0"       "The dut instance in the testbed file" ] \
               [list fileName                 "optional"     "string"         "/tmp/trasferIfconfigdate.txt"       "The loc of the file where the output of SAR command will be stored" ]\
               [list fileNameonGW                 "optional"     "string"         "/home/admin/trasferIfconfigdataexeconHeNBGW.txt"       "The loc of the file where the output of SAR command will be stored" ]\
               [list localFile      "optional"     "string"         "__UN_DEFINED__"       "File Path and Name" ] \
               [list localFileofGW      "optional"     "string"         "__UN_DEFINED__"       "File Path and Name" ] \
               [list intervalDuration         "optional"     "numeric"        "180"      "The time duration for the command"    ] \
               [list interface                "optional"     "string"         "10Geth0"  "The interface name whose value has to be fetched"    ] \
               ]
     
     print -info "The SAR Execution time was : $SARexecutionTime"
     set SARextractionTime [clock seconds]
     print -info "The SAR Extraction Time is : $SARextractionTime"
     set SARexpectedExtractionTime [expr "$SARexecutionTime + $intervalDuration"]
     if {$SARexpectedExtractionTime > $SARextractionTime} {
          set sleepTime [expr "$SARexpectedExtractionTime - $SARextractionTime + 20"]
          halt $sleepTime
     }

     set fileName eth${portNum}data${instance}.txt
     set fileName "${fileLocation}${fileName}"
    
     set dut [getActiveBonoIp]
     set simIp [getDataFromConfigFile "getMmeSimulatorHostIp" $fgwNum]
     set localHost     [getConnectedHostMgmntIp 4]
     
     if {![info exists localFile]} {
          set localFile "/tmp/[getOwner]_[file tail $fileName]"
     }
     if {![info exists localFileofGW]} {
          set localFileofGW "/tmp/[getOwner]_[file tail $fileNameonGW]"
     }
     
     #-The file generated by SAR command is copied from simulator to the local view
     set result [scpFile -remoteHost $simIp -localFileName $localFile -remoteUser "root" -remotePassword "$::ROOT_PASSWORD" \
               -remoteFileName $fileName -localHost $localHost]
     if {$result != 0} {
          print -fail "Failed to retrieve $fileName from $dut. Cannot perform data updation"
          return -1
     } else {
          print -pass "Successfully copied SAR output from GW to local host"
     }

     set cmd "\n"
     set result [execCommandSU -dut $dut -command "$cmd"]

     #-The file generated by SAR command is copied from GW to the local view
     set cmd "scp $fileNameonGW [getOwner]@192.168.0.200:$localFileofGW"
     set result [execCommandSU -dut $dut -command "$cmd" -cmdPasswd "[getOwner]"]
     #set result [scpFile -remoteHost $dut -localFileName $localFileofGW -remoteUser "admin" -remotePassword "$::ADMIN_PASSWORD" \
               -remoteFileName $fileNameonGW -localHost $localHost]
     if {$result == -1} {
          print -fail "Failed to retrieve $fileName from $dut. Cannot perform data updation"
          return -1
     } else {
          print -pass "Successfully copied SAR output from GW to local host"
     }
    
     set 10GcountersList ""

     #set data [exec cat $localFile]
     set data [exec cat $localFileofGW]
     print -info "The value of the data obtained from the SAR output : \n$data"
     
     print -info "Following is the detailed value of Received and transmitted packets from the GW on different ports"
     set header    "SAR Statictics on HeNBGW"
     printHeader "$header" "50" "-"
     foreach line [split $data "\r\n"] {
          if { [regexp "Average:" $line] } {
               #print -info "The Average value of received and transmitted packets are : \n$line"
               
               set lineValue1 [lindex $line 1]
               set lineValue2 [lindex $line 2]
               set lineValue3 [lindex $line 3]
               set lineValue4 [lindex $line 4]
               set lineValue5 [lindex $line 5]

	       if {$interface == "10Geth0"} {               
	               if {$lineValue1 == "10Geth0"} {
	                    set 10Geth0TxPkts $lineValue2
	               }
	       } elseif {$interface == "10Geth1"} {
	               if {$lineValue1 == "10Geth1"} {
	                    set 10Geth1TxPkts $lineValue2
	               }
               }
              print -nolog "$lineValue1 --> $lineValue2"
          }
     }
      
     return $10GcountersList
     
}

