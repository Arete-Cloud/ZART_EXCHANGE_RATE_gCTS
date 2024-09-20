  METHOD get_exchange_rate.

    DATA lv_datum TYPE sydate.

    CREATE DATA et_response TYPE TABLE OF zdd_fi_exchange_rate.

    ASSIGN et_response->* TO FIELD-SYMBOL(<ft_business_data>).

    IF mt_request_range[] IS INITIAL .

      SELECT * FROM i_exchangeraterawdata WHERE validitystartdate EQ @sy-datum INTO TABLE @DATA(lt_data).

    ELSEIF lines( mt_request_range ) EQ 4.

      LOOP AT mt_request_range INTO DATA(ls_range).
        CASE ls_range-name.
          WHEN 'EXCHANGERATETYPE'.
            DATA(lv_exchangeratetype) = ls_range-range[ 1 ]-low.
          WHEN 'SOURCECURRENCY'.
            DATA(lv_sourcecurrency) = ls_range-range[ 1 ]-low.
          WHEN 'TARGETCURRENCY'.
            DATA(lv_targetcurrency) = ls_range-range[ 1 ]-low.
          WHEN 'VALIDITYSTARTDATE'.
            DATA(lv_validitystartdate) = ls_range-range[ 1 ]-low.
        ENDCASE.
      ENDLOOP.


      IF  lv_exchangeratetype IS NOT INITIAL
        AND lv_sourcecurrency IS NOT INITIAL
        AND lv_targetcurrency IS NOT INITIAL
        AND lv_validitystartdate IS NOT INITIAL.

        TRY.
            cl_exchange_rates=>convert_to_foreign_currency(
              EXPORTING
                date             = CONV #( lv_validitystartdate )
                foreign_currency = CONV #( lv_sourcecurrency )
                local_amount     = 1
                local_currency   = CONV #( lv_targetcurrency )
                rate_type        = CONV #( lv_exchangeratetype )
              IMPORTING
                exchange_rate    = DATA(lv_rate)
            ).
          CATCH cx_exchange_rates.
            lv_rate = -1.
        ENDTRY.

        IF lv_rate IS NOT INITIAL.

          APPEND VALUE #(  exchangeratetype = lv_exchangeratetype
                              sourcecurrency = lv_sourcecurrency
                              targetcurrency = lv_targetcurrency
                              validitystartdate = lv_validitystartdate
                              exchangerate = CONV #( lv_rate )
                              numberofsourcecurrencyunits = 1
                              numberoftargetcurrencyunits = 1
                           ) TO lt_data.
        ENDIF.
        CLEAR lv_rate.

      ENDIF.
    ENDIF.

    MOVE-CORRESPONDING lt_data TO <ft_business_data> .


  ENDMETHOD.