  METHOD if_apj_rt_exec_object~execute.

    DATA lt TYPE cl_exchange_rates=>ty_messages..
    DATA lv_date TYPE dats.
    TRY.
        DATA(lo_log) = cl_bali_log=>create_with_header( cl_bali_header_setter=>create( object = 'ZFI' subobject = 'ZFI_EXCHANGE_RATE' ) ).
      CATCH cx_bali_runtime INTO DATA(lc_runtime).
        RETURN.
    ENDTRY.

    DATA: p_date TYPE datn,
          p_fixd TYPE abap_boolean,
          p_dynd TYPE abap_boolean.

    LOOP AT it_parameters INTO DATA(ls_parameter).
      CASE ls_parameter-selname.
        WHEN 'P_DATE'.
          p_date = ls_parameter-low.
        WHEN 'P_FIXD'.
          p_fixd = ls_parameter-low.
        WHEN 'P_DYND'.
          p_dynd = ls_parameter-low.
      ENDCASE.
    ENDLOOP.

    lv_date = cl_abap_context_info=>get_system_date( ).

    IF p_fixd EQ 'X'.
      READ TABLE it_parameters INTO DATA(ls_para) WITH  KEY selname = 'P_DATE'.
      IF  sy-subrc EQ 0 .
        lv_date = ls_para-low.
      ENDIF.
    ENDIF.


    DATA(lt_return) =  zcl_fi_exchange_rate_util=>update_exchange_rates( lv_date ).

    LOOP AT lt_return INTO DATA(ls_return).
      TRY.
          lo_log->add_item( item = cl_bali_message_setter=>create_from_bapiret2( message_data = ls_return ) ).
        CATCH cx_bali_runtime INTO DATA(lc_e1).
          RETURN.
      ENDTRY.
    ENDLOOP.
    TRY.
        cl_bali_log_db=>get_instance( )->save_log( log = lo_log assign_to_current_appl_job = abap_true ).
      CATCH cx_bali_runtime INTO DATA(lc_e2).
        RETURN.
    ENDTRY.
    COMMIT WORK AND WAIT.

  ENDMETHOD.