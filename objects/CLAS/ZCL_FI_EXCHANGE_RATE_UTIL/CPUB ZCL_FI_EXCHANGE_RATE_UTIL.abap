CLASS zcl_fi_exchange_rate_util DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    CLASS-METHODS update_exchange_rates IMPORTING VALUE(iv_date)    TYPE abp_creation_date
                                        RETURNING VALUE(rt_message) TYPE cl_exchange_rates=>ty_messages.