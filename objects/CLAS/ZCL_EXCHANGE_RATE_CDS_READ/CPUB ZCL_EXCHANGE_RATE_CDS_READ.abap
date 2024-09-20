CLASS zcl_exchange_rate_cds_read DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_rap_query_provider .


    DATA mv_entity_name TYPE char40.
    DATA mc_request_aggregation TYPE REF TO if_rap_query_aggregation.
    DATA mc_request_filter TYPE REF TO if_rap_query_filter.
    DATA mc_request_paging TYPE REF TO if_rap_query_paging.
    DATA mv_request_page_size TYPE i VALUE 100.
    DATA mv_request_offset TYPE i.
    DATA mv_entity_cds  TYPE string.
    DATA mv_entity_ext_url_path  TYPE string.
    DATA mt_request_range TYPE  if_rap_query_filter=>tt_name_range_pairs.
    DATA mv_comm_scenario TYPE char30 ."VALUE 'Z_API_PURORDER_PROCESS_SRV'.
    DATA mv_service_id TYPE char40. "VALUE 'Z_API_PURORDER_PROCESS_SRV_REST'.
    DATA mv_service_definition_name TYPE char40 ."VALUE 'Z_API_PURORDER_PROCESS_SRV'.
    DATA mv_odata TYPE char2 VALUE 'v2'.


