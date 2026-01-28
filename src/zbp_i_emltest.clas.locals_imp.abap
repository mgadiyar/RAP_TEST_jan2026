CLASS lhc_ZI_EMLTEST DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Student RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR Student RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE Student.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE Student.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE Student.

    METHODS read FOR READ
      IMPORTING keys FOR READ Student RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK Student.

    METHODS rba_Result FOR READ
      IMPORTING keys_rba FOR READ Student\_Result FULL result_requested RESULT result LINK association_links.

    METHODS cba_Result FOR MODIFY
      IMPORTING entities_cba FOR CREATE Student\_Result.
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR Student RESULT result.
    METHODS earlynumbering_cba_result FOR NUMBERING
      IMPORTING entities FOR CREATE student\_result.
    METHODS earlynumbering_create FOR NUMBERING
      IMPORTING entities FOR CREATE student.

ENDCLASS.

CLASS lhc_ZI_EMLTEST IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD create.
    zcl_emlclassun=>get_instance( )->create(
      EXPORTING
        entities =  entities
      CHANGING
        mapped   =  mapped
        failed   =  failed
        reported =  reported
    ).
  ENDMETHOD.

  METHOD update.
   zcl_emlclassun=>get_instance( )->update(
     EXPORTING
       entities = entities
     CHANGING
       mapped   = mapped
       failed   = failed
       reported = reported
   ).

  ENDMETHOD.

  METHOD delete.
  zcl_emlclassun=>get_instance( )->delete(
    EXPORTING
      keys     = keys
    CHANGING
      mapped   = mapped
      failed   = failed
      reported = reported
  ).
  ENDMETHOD.

  METHOD read.
  zcl_emlclassun=>get_instance( )->read(
    EXPORTING
      keys     = keys
    CHANGING
      result   = result
      failed   = failed
      reported = reported
  ).
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

  METHOD rba_Result.
  ENDMETHOD.

  METHOD cba_Result.
  ENDMETHOD.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD earlynumbering_create.
    zcl_emlclassun=>get_instance( )->earlynumbering_create(
      EXPORTING
        entities =  entities
      CHANGING
        mapped   = mapped
        failed   = failed
        reported = reported
    ).
  ENDMETHOD.

  METHOD earlynumbering_cba_Result.
  ENDMETHOD.

ENDCLASS.

CLASS lhc_ZI_STURESULTun DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE Result.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE Result.

    METHODS read FOR READ
      IMPORTING keys FOR READ Result RESULT result.

    METHODS rba_Student FOR READ
      IMPORTING keys_rba FOR READ Result\_Student FULL result_requested RESULT result LINK association_links.

ENDCLASS.

CLASS lhc_ZI_STURESULTun IMPLEMENTATION.

  METHOD update.
  ENDMETHOD.

  METHOD delete.
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD rba_Student.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_ZI_EMLTEST DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZI_EMLTEST IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD save.
    zcl_emlclassun=>get_instance( )->save(
    CHANGING
      reported = reported
  ).
  ENDMETHOD.

  METHOD cleanup.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
