CLASS zcl_feecalc DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
  INTERFACES if_sadl_exit_calc_element_read.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_feecalc IMPLEMENTATION.
  METHOD if_sadl_exit_calc_element_read~calculate.
    data: lt_feedata type table of Zc_STURESULT WITH DEFAULT KEY.
    lt_feedata = CORRESPONDING #( it_original_data ).
    loop at lt_feedata ASSIGNING FIELD-SYMBOL(<lfs_fee>).
    if <lfs_fee>-Sem is not initial.
        <lfs_fee>-fees = <lfs_fee>-Sem * 5000.
    endif.
    endloop.
    UNASSIGN <lfs_fee>.
    ct_calculated_data = CORRESPONDING #( lt_feedata ).
  ENDMETHOD.

  METHOD if_sadl_exit_calc_element_read~get_calculation_info.

  ENDMETHOD.

ENDCLASS.
