  METHOD initialization.

    IF mv_entity_cds IS INITIAL.
      mv_entity_cds = io_request->get_entity_id( ).
    ENDIF.


    IF io_request IS NOT INITIAL.

      mc_request_aggregation = io_request->get_aggregation(  ).
      mc_request_filter = io_request->get_filter( ).

      TRY.
          mt_request_range = mc_request_filter->get_as_ranges(  ).
        CATCH cx_rap_query_filter_no_range.
          CLEAR mt_request_range.
      ENDTRY.

      mc_request_paging = io_request->get_paging( ).

      mv_request_page_size = mc_request_paging->get_page_size( ).
      mv_request_offset = mc_request_paging->get_offset( ).

      DATA(lv_search) = io_request->get_search_expression(  ).

      DATA(lt_parameters) = io_request->get_parameters( ).
      DATA(lt_elements) = io_request->get_requested_elements( ).
      DATA(lv_search_expression) = io_request->get_search_expression( ).
      DATA(lt_sort) = io_request->get_sort_elements( ).

    ENDIF.

    IF  mv_request_page_size EQ '1-'. mv_request_page_size = 100. ENDIF.


  ENDMETHOD.