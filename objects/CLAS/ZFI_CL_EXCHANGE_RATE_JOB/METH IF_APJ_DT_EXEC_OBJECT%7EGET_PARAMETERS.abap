  METHOD if_apj_dt_exec_object~get_parameters.

    DATA(lv_tarih_txt) = 'Tarih' ##NO_TEXT.

    et_parameter_def = VALUE
    #( ( selname = 'P_FIXD'  kind = if_apj_dt_exec_object=>parameter     datatype = 'C'    length = 1   param_text = 'SabitTarih'   radio_group_ind = abap_true radio_group_id = 'date' changeable_ind = abap_true )
       ( selname = 'P_DYND'  kind = if_apj_dt_exec_object=>parameter     datatype = 'C'    length = 1   param_text = 'DinamikTarih' radio_group_ind = abap_true radio_group_id = 'date' changeable_ind = abap_true )
       ( selname = 'P_DATE'  kind = if_apj_dt_exec_object=>parameter     datatype = 'DATS' param_text = lv_tarih_txt  changeable_ind = abap_true )
     ).

    et_parameter_val = VALUE
    #( ( selname = 'P_DATE'  kind = if_apj_dt_exec_object=>parameter    sign = 'I' option = 'EQ' low = cl_abap_context_info=>get_system_date( ) )
       ( selname = 'P_FIXD'  kind = if_apj_dt_exec_object=>parameter    sign = 'I' option = 'EQ' low = abap_false )
       ( selname = 'P_DYND'  kind = if_apj_dt_exec_object=>parameter    sign = 'I' option = 'EQ' low = abap_true )
     ).

  ENDMETHOD.