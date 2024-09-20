  METHOD update_exchange_rates.

    DATA lv_query TYPE string.
    DATA lv_tcmb_key TYPE zde_tcmb_key.
    DATA lv_tcmb_date TYPE string.
    DATA lv_date TYPE abp_creation_date.
    DATA: lr_cscn TYPE if_com_scenario_factory=>ty_query-cscn_id_range.
    DATA(lo_factory) = cl_com_arrangement_factory=>create_instance( ).


    DATA: lt_exchange_rates TYPE cl_exchange_rates=>ty_exchange_rates,
          ls_exchange_rates TYPE cl_exchange_rates=>ty_exchange_rate,
          lt_return         TYPE cl_exchange_rates=>ty_messages.


    IF  iv_date IS NOT INITIAL.
      lv_date = iv_date.
    ELSE.
      lv_date = cl_abap_context_info=>get_system_date( ).
    ENDIF.


    lv_tcmb_date = lv_date+6(2) && '-' &&  lv_date+4(2) && '-' && lv_date+0(4).

    lr_cscn = VALUE #( ( sign = 'I' option = 'EQ' low = 'ZCS_TCMB_KUR' ) ).

    lo_factory->query_ca(
      EXPORTING
        is_query           = VALUE #( cscn_id_range = lr_cscn )
      IMPORTING
        et_com_arrangement = DATA(lt_ca) ).

    READ TABLE lt_ca INTO DATA(lo_ca) INDEX 1.

    DATA(lt_properties) = lo_ca->get_properties(  ).

    READ TABLE lt_properties INTO DATA(ls_property) WITH KEY name = 'TCMB_KEY'.
    IF sy-subrc EQ 0.
      lv_tcmb_key = ls_property-values[ 1 ].
    ENDIF.

    TRY.
        DATA(lo_destination) = cl_http_destination_provider=>create_by_comm_arrangement( comm_scenario  = 'ZCS_TCMB_KUR'
                                                                                         service_id     = 'ZOS_TCMB_REST'
                                                                                         comm_system_id = lo_ca->get_comm_system_id( ) ).
      CATCH cx_http_dest_provider_error.
        CLEAR lo_destination.
    ENDTRY.

    TRY.
        DATA(lo_http_client)  = cl_web_http_client_manager=>create_by_http_destination( lo_destination ).
      CATCH cx_web_http_client_error.
        CLEAR lo_http_client.
    ENDTRY.

    DATA(lo_request) = lo_http_client->get_http_request( ).


    SELECT * FROM zfi_tb_mb_kur WHERE notactive EQ '' INTO TABLE @DATA(lt_kur).

    lv_query =  'key=' && lv_tcmb_key && '&type=json&startDate=' && lv_tcmb_date && '&endDate=' && lv_tcmb_date .

    lv_query = lv_query && '&series=' && lt_kur[ 1 ]-mbkey .

    LOOP AT lt_kur INTO DATA(ls_kur) FROM 2.
      lv_query = lv_query && '-' && ls_kur-mbkey .
    ENDLOOP.

    lo_request->set_uri_path( lv_query ).

    TRY.
        DATA(lo_response)      = lo_http_client->execute( i_method = if_web_http_client=>get ).
      CATCH cx_web_http_client_error.
    ENDTRY.

    DATA(lv_json_response) = lo_response->get_text( ).

    DATA(lr_data) = /ui2/cl_json=>generate( json        = lv_json_response
                                            pretty_name = /ui2/cl_json=>pretty_mode-camel_case ).

    ASSIGN lr_data->* TO FIELD-SYMBOL(<fs_response>).
    ASSIGN COMPONENT `items` OF STRUCTURE <fs_response> TO FIELD-SYMBOL(<ft_items>).
    LOOP AT <ft_items>->* ASSIGNING FIELD-SYMBOL(<fs_items>).

      LOOP AT lt_kur INTO ls_kur.
        REPLACE ALL OCCURRENCES OF '.' IN ls_kur-mbkey WITH '_'.
        ASSIGN COMPONENT ls_kur-mbkey OF STRUCTURE <fs_items>->* TO FIELD-SYMBOL(<fs_value>).
        IF sy-subrc EQ 0 AND <fs_value> IS NOT INITIAL.
          CLEAR:ls_exchange_rates.
          ls_exchange_rates-valid_from  = lv_date.
          ls_exchange_rates-exch_rate  =  <fs_value>->*.
          ls_exchange_rates-from_curr  = ls_kur-from_curr.
          ls_exchange_rates-from_factor  = ls_kur-from_factor.
          ls_exchange_rates-from_factor_v  = ls_kur-from_factor.
          ls_exchange_rates-to_currncy  = ls_kur-to_currncy.
          ls_exchange_rates-to_factor  = ls_kur-to_factor.
          ls_exchange_rates-to_factor_v  = ls_kur-to_factor.
          ls_exchange_rates-rate_type  = ls_kur-rate_type.
          APPEND  ls_exchange_rates TO lt_exchange_rates.

        ENDIF.

      ENDLOOP.

    ENDLOOP.

    CHECK lt_exchange_rates IS NOT INITIAL.

    rt_message = cl_exchange_rates=>put( EXPORTING exchange_rates = lt_exchange_rates is_update_allowed = abap_true ).


  ENDMETHOD.