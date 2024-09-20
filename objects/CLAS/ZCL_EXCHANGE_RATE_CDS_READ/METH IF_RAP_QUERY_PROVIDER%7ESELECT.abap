  METHOD if_rap_query_provider~select.

    me->initialization(
      io_request  = io_request
      io_response = io_response
    ).

    IF  mv_entity_name EQ  'A_KurBilgileri'.
      DATA(lt_response) =  me->get_exchange_rate(  ).
    ENDIF.

    IF lines( lt_response->* ) > 0.
      io_response->set_data( it_data = lt_response->* ).
      io_response->set_total_number_of_records( iv_total_number_of_records = lines( lt_response->* ) ).
    ELSE.
      io_response->set_total_number_of_records( 0 ).
      io_response->set_data( it_data = lt_response->* ).
    ENDIF.


  ENDMETHOD.