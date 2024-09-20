CLASS lhc_a_kurbilgileri DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR a_kurbilgileri RESULT result.

ENDCLASS.

CLASS lhc_a_kurbilgileri IMPLEMENTATION.

  METHOD get_global_authorizations.
    result-%create = if_abap_behv=>auth-allowed.
    "result-%delete = abap_true.
    result-%update = if_abap_behv=>auth-allowed.
  ENDMETHOD.

ENDCLASS.