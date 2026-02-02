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
    METHODS validatefields FOR VALIDATE ON SAVE
      IMPORTING keys FOR student~validatefields.
    METHODS coursedur FOR DETERMINE ON MODIFY
      IMPORTING keys FOR student~coursedur.
    METHODS setstud FOR MODIFY
      IMPORTING keys FOR ACTION student~setstud RESULT result.
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
*    zcl_emlclassun=>get_instance( )->lock(
*      EXPORTING
*        keys     = keys
*      CHANGING
*        failed   = failed
*        reported = reported
*    ).

*    TRY.
*        DATA(lock) = cl_abap_lock_object_factory=>get_instance( iv_name = 'EZ_STUDENT' ).
*      CATCH cx_abap_lock_failure INTO DATA(lockfail).
*        RAISE SHORTDUMP lockfail.
*    ENDTRY.
*
*    LOOP AT keys INTO DATA(ls_keys).
*      TRY.
*          lock->enqueue(
*            it_parameter  = VALUE #( ( name = 'Id' value = REF #( ls_keys-Id ) ) )
*
*          ).
*        CATCH cx_abap_foreign_lock INTO DATA(ls_folock).
*          APPEND VALUE #(  id = keys[ 1 ]-Id
*          %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
*          text = 'Record is locked by' && ls_folock->user_name ) ) TO reported-student.
*          APPEND VALUE #( id = keys[ 1 ]-Id ) TO failed-student.
*        CATCH cx_abap_lock_failure.
*          APPEND VALUE #( id = keys[ 1 ]-Id
*          %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
*          text = 'Locking failed' ) ) TO reported-student.
*          APPEND VALUE #( id = keys[ 1 ]-Id ) TO failed-student.
*      ENDTRY.
*    ENDLOOP.

  ENDMETHOD.

  METHOD rba_Result.
  ENDMETHOD.

  METHOD cba_Result.
    zcl_emlclassun=>get_instance( )->cba_result(
      EXPORTING
        entities_cba = entities_cba
      CHANGING
        mapped       = mapped
        failed       = failed
        reported     = reported
    ).
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
    zcl_emlclassun=>get_instance( )->earlynumbering_cba_result(
      EXPORTING
        entities = entities
      CHANGING
        mapped   = mapped
        failed   = failed
        reported = reported
    ).
  ENDMETHOD.

  METHOD Validatefields.
    READ ENTITIES OF Zi_emltest IN LOCAL MODE
    ENTITY Student
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(Student).

    READ TABLE student ASSIGNING FIELD-SYMBOL(<lfs_stu>) INDEX 1.
    IF <lfs_stu> IS ASSIGNED.
      reported-student = VALUE #( ( %tky = <lfs_stu>-%tky %state_area = 'Validate_FNM' )
      ( %tky = <lfs_stu>-%tky %state_area = 'Validate_LNM' )
      ( %tky = <lfs_stu>-%tky %state_area = 'Validate_AGE' )
       ).
      IF <lfs_stu>-Firstname IS INITIAL OR <lfs_stu>-Lastname IS INITIAL OR <lfs_stu>-Age IS INITIAL.
        failed-student = VALUE #( (  %tky = <lfs_stu>-%tky ) ).
        IF <lfs_stu>-Firstname IS INITIAL.

          APPEND VALUE #(  %tky = <lfs_stu>-%tky
                            %element-firstname = if_abap_behv=>mk-on
                            %state_area = 'Validate_FNM'
                            %msg = new_message_with_text(
                                                                  severity = if_abap_behv_message=>severity-error
                                                                  text     = 'Firstname1 is mandatory'
                                                                )
                           ) TO reported-student.
        ENDIF.
        IF <lfs_stu>-Lastname IS INITIAL.
          APPEND VALUE #(  %tky = <lfs_stu>-%tky
                           %element-lastname = if_abap_behv=>mk-on
                            %state_area = 'Validate_LNM'
                             %msg = new_message_with_text(
                                                                  severity = if_abap_behv_message=>severity-error
                                                                  text     = 'Lastname is mandatory'
                                                                )
                           ) TO reported-student.
        ENDIF.
        IF <lfs_stu>-Age IS INITIAL.
          APPEND VALUE #(  %tky = <lfs_stu>-%tky
                            %element-age = if_abap_behv=>mk-on
                            %state_area = 'Validate_AGE'
                            %msg = new_message_with_text(
                                                                  severity = if_abap_behv_message=>severity-error
                                                                  text     = 'Age is mandatory'
                                                                )
                           ) TO reported-student.
        ENDIF.
      ENDIF.
    ENDIF.

  ENDMETHOD.

  METHOD coursedur.
    READ ENTITIES OF Zi_emltest IN LOCAL MODE
    ENTITY Student
    FIELDS ( Course ) WITH CORRESPONDING #( keys )
    RESULT DATA(Student).

    LOOP AT Student ASSIGNING FIELD-SYMBOL(<lfs_stu>).
      IF <lfs_stu>-Course = 'C'.
        MODIFY ENTITIES OF Zi_emltest IN LOCAL MODE
        ENTITY Student
        UPDATE FIELDS ( Courseduration )
        WITH VALUE #( ( %tky = <lfs_stu>-%tky Courseduration = '5' ) ).
      ELSEIF <lfs_stu>-Course = 'E'.
        MODIFY ENTITIES OF Zi_emltest IN LOCAL MODE
        ENTITY Student
        UPDATE FIELDS ( Courseduration )
        WITH VALUE #( ( %tky = <lfs_stu>-%tky Courseduration = '4' ) ).
      ELSEIF <lfs_stu>-Course = 'M'.
        MODIFY ENTITIES OF Zi_emltest IN LOCAL MODE
        ENTITY Student
        UPDATE FIELDS ( Courseduration )
        WITH VALUE #( ( %tky = <lfs_stu>-%tky Courseduration = '6' ) ).
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD SetStud.
    READ ENTITIES OF ZI_EMLTEst IN LOCAL MODE
    ENTITY Student
    FIELDS ( Status Course Courseduration ) WITH CORRESPONDING #( keys )
    RESULT DATA(Student).

    DATA(new_status) = keys[ 1 ]-%param-status.
    DATA(new_course) = keys[ 1 ]-%param-course.
    DATA(new_coursedur) = keys[ 1 ]-%param-coursedur.
    MODIFY ENTITIES OF ZI_EMLTEst IN LOCAL MODE
    ENTITY Student
    UPDATE FIELDS ( Status Course Courseduration )
    WITH VALUE #( ( %tky = Student[ 1 ]-%tky Status = new_status
                     Course = new_course  Courseduration = new_coursedur ) ).

    READ ENTITIES OF ZI_EMLTEst IN LOCAL MODE
    ENTITY Student
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(Studentlatest).

    result = VALUE #( FOR <lfs_stud> IN Studentlatest ( %tky = <lfs_stud>-%tky  %param = <lfs_stud> )  ).
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
    METHODS Validatefields FOR VALIDATE ON SAVE
      IMPORTING keys FOR Result~Validatefields.

ENDCLASS.

CLASS lhc_ZI_STURESULTun IMPLEMENTATION.

  METHOD update.
    zcl_emlclassun=>get_instance( )->resupdate(
      EXPORTING
        entities = entities
      CHANGING
        mapped   = mapped
        failed   = failed
        reported = reported
    ).
  ENDMETHOD.

  METHOD delete.
    zcl_emlclassun=>get_instance( )->delete_res(
      EXPORTING
        keys     = keys
      CHANGING
        mapped   = mapped
        failed   = failed
        reported = reported
    ).
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD rba_Student.
  ENDMETHOD.

  METHOD Validatefields.

    READ ENTITIES OF Zi_emltest IN LOCAL MODE
     ENTITY Result
     ALL FIELDS WITH CORRESPONDING #( keys )
     RESULT DATA(result).


    READ ENTITIES OF Zi_emltest IN LOCAL MODE
    ENTITY Result
   BY \_Student
   FROM  CORRESPONDING #( result )
    LINK DATA(linkstudent).

    READ TABLE result ASSIGNING FIELD-SYMBOL(<lfs_res>) INDEX 1.

    IF <lfs_res> IS ASSIGNED.
      reported-result =  VALUE #( (   %tky = <lfs_res>-%tky %state_area = 'Validate_G' ) ) .
      IF <lfs_res>-Course = 'G'.
        failed-result = VALUE #( (  %tky = <lfs_res>-%tky ) ).
        APPEND VALUE #(  %tky = <lfs_res>-%tky
                                %element-course = if_abap_behv=>mk-on
                                %state_area = 'Validate_G'
                                %msg = new_message_with_text(
                                severity = if_abap_behv_message=>severity-error
                                text     = 'Course cannot be G' )
                               %path = VALUE #( Student-%tky = linkstudent[ KEY id source-%tky = <lfs_res>-%tky ]-target-%tky )
                               ) TO reported-result.
      ENDIF.
    ENDIF.
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
    DATA: lt_student TYPE STANDARD TABLE OF Ztest_raptestun,
          lt_result  TYPE STANDARD TABLE OF ztab_resultun.
    lt_student = zcl_emlclassun=>get_instance( )->lt_student.
    READ TABLE  lt_student ASSIGNING FIELD-SYMBOL(<lfs_std>) INDEX 1.
    IF <lfs_std> IS ASSIGNED.
      IF <lfs_std>-age < 21.
        APPEND VALUE #( id = <lfs_std>-id ) TO failed-student.
        APPEND VALUE #( id = <lfs_std>-id  %msg = new_message_with_text(
                                                   severity = if_abap_behv_message=>severity-error
                                                   text     = 'Age is less than 21'
                                                 ) ) TO reported-student.
      ENDIF.
      IF <lfs_std>-status = abap_false.
        APPEND VALUE #( id = <lfs_std>-id ) TO failed-student.
        APPEND VALUE #( id = <lfs_std>-id %msg = new_message_with_text(
                                                   severity = if_abap_behv_message=>severity-error
                                                   text     = 'Status is not set'
                                                 ) ) TO reported-student.
      ENDIF.
    ENDIF.
    lt_result = zcl_emlclassun=>get_instance( )->lt_result.
    READ TABLE  lt_result ASSIGNING FIELD-SYMBOL(<lfs_res>) INDEX 1.
    IF <lfs_res> IS ASSIGNED.
      IF <lfs_res>-course = 'K'.
        APPEND VALUE #( id = <lfs_res>-id  sem = <lfs_res>-sem ) TO failed-result.
        APPEND VALUE #( id = <lfs_res>-id sem = <lfs_res>-sem %msg = new_message_with_text(
                                                   severity = if_abap_behv_message=>severity-error
                                                   text     = 'Course cannot be K'
                                                 ) ) TO reported-result.
      ENDIF.
    ENDIF.
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
