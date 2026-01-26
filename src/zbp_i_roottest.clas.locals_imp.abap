CLASS lhc_Student DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR Student RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Student RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR Student RESULT result.
    METHODS setAdmitted FOR MODIFY
      IMPORTING keys FOR ACTION Student~setAdmitted RESULT result.
    METHODS ValidateAge FOR VALIDATE ON SAVE
      IMPORTING keys FOR Student~ValidateAge.
    METHODS SetCourseDur FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Student~SetCourseDur.
    METHODS precheck_update FOR PRECHECK
      IMPORTING entities FOR UPDATE Student.
    METHODS CopyStudent FOR MODIFY
      IMPORTING keys FOR ACTION Student~CopyStudent.
    METHODS is_update_allowed RETURNING VALUE(update_allowed) TYPE abap_boolean.

ENDCLASS.

CLASS lhc_Student IMPLEMENTATION.

  METHOD get_instance_features.
    READ ENTITIES OF zi_roottest
    ENTITY Student
    FIELDS ( Status )
    WITH CORRESPONDING #( keys )
    RESULT DATA(studentdata).

    result = VALUE #( FOR stud IN studentdata
    LET statval = COND #( WHEN stud-Status = abap_true THEN if_abap_behv=>fc-o-disabled
                               ELSE if_abap_behv=>fc-o-enabled )
                  IN ( %tky = stud-%tky %action-setAdmitted = statval ) ).

  ENDMETHOD.

  METHOD get_instance_authorizations.

    DATA: update_req TYPE abap_bool.

    READ ENTITIES OF zi_roottest IN LOCAL MODE
    ENTITY Student
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(student).

    IF student IS NOT INITIAL.
      update_req = COND #( WHEN requested_authorizations-%action-Edit = if_abap_behv=>mk-on
      OR requested_authorizations-%update = if_abap_behv=>mk-on  THEN abap_true ELSE abap_false ).

      LOOP AT student ASSIGNING FIELD-SYMBOL(<lfs_student>).

        IF update_req EQ abap_true AND <lfs_student>-Status = abap_false.
          IF is_update_allowed( ) EQ abap_false.
            APPEND VALUE #( %tky = <lfs_student>-%tky  ) TO failed-student.
            APPEND VALUE #(  %tky = <lfs_student>-%tky
            %msg = new_message_with_text( severity =  if_abap_behv_message=>severity-error
            text = 'no auth' ) ) TO reported-student.

          ENDIF.

        ENDIF.
      ENDLOOP.
    ENDIF.

  ENDMETHOD.

  METHOD get_global_authorizations.
    IF requested_authorizations-%update = if_abap_behv=>mk-on
    AND requested_authorizations-%action-Edit = if_abap_behv=>mk-on.
      IF is_update_allowed( ) EQ abap_true.
        result-%action-Edit = if_abap_behv=>auth-allowed.
        result-%update = if_abap_behv=>auth-allowed.
      ELSE.
        result-%action-Edit = if_abap_behv=>auth-unauthorized.
        result-%update = if_abap_behv=>auth-unauthorized.
      ENDIF.
    ENDIF.
  ENDMETHOD.

  METHOD setAdmitted.
*    MODIFY ENTITIES OF zi_roottest
*    ENTITY Student UPDATE
*    FIELDS ( Status )
*    WITH VALUE #( FOR key IN keys ( %tky = key-%tky Status = abap_true ) )
*    FAILED failed
*    REPORTED reported.

    READ ENTITIES OF zi_roottest IN LOCAL MODE
    ENTITY Student
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(Studentdata).
    LOOP AT Studentdata ASSIGNING FIELD-SYMBOL(<lfs_student>).
      IF <lfs_student>-Age < 25.
        <lfs_student>-Status = abap_true.
      ELSE.
        APPEND VALUE #( %tky = <lfs_student>-%tky  ) TO failed-Student.
        APPEND VALUE #( %tky = <lfs_student>-%tky %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
        text = <lfs_student>-Firstname && 'has age greater than 25,cant be admitted.' ) ) TO reported-student.
      ENDIF.
    ENDLOOP.

    IF failed-student IS INITIAL.
      SORT studentdata BY Status DESCENDING.
      MODIFY ENTITIES OF zi_roottest IN LOCAL MODE
      ENTITY Student
      UPDATE FIELDS ( Status )
      WITH CORRESPONDING #( studentdata ).
      RESUlt = VALUE #( FOR studentrec IN Studentdata
      ( %tky = studentrec-%tky %param = studentrec ) ).
    ENDIF.

  ENDMETHOD.

  METHOD ValidateAge.
    READ ENTITIES OF zi_roottest IN LOCAL MODE
    ENTITY Student
    FIELDS ( Age ) WITH CORRESPONDING #( keys )
    RESULT DATA(Studentdata).

    LOOP AT studentdata INTO DATA(Studentrec).
      IF studentrec-Age LT 21.
        APPEND VALUE #( %tky = Studentrec-%tky  ) TO failed-student.
        APPEND VALUE #( %tky = studentrec-%tky
                        %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                         text = 'Age must be greater than eq to 21' ) ) TO reported-student.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD SetCourseDur.
    READ ENTITIES OF zi_roottest IN LOCAL MODE
    ENTITY Student
    FIELDS ( Course )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_course).

    LOOP AT lt_course INTO DATA(ls_course).
      IF ls_course-Course = 'C'.
        MODIFY ENTITIES OF  zi_roottest IN LOCAL MODE
        ENTITY Student
        UPDATE FIELDS ( Courseduration )
        WITH VALUE #( ( %tky = ls_course-%tky Courseduration = '5'  ) ) .
      ELSEIF ls_course-Course = 'E'.
        MODIFY ENTITIES OF  zi_roottest IN LOCAL MODE
        ENTITY Student
        UPDATE FIELDS ( Courseduration )
        WITH VALUE #( ( %tky = ls_course-%tky    Courseduration = '4' ) ) .
      ELSEIF ls_course-Course  = 'M'.
        MODIFY ENTITIES OF  zi_roottest IN LOCAL MODE
        ENTITY Student
        UPDATE FIELDS ( Courseduration )
        WITH VALUE #( ( %tky = ls_course-%tky    Courseduration = '3' ) ).
      ENDIF.
    ENDLOOP.
  ENDMETHOD.


  METHOD precheck_update.
    LOOP AT entities ASSIGNING FIELD-SYMBOL(<lfs_entity>).
      IF <lfs_entity>-%control-Course = '01' OR <lfs_entity>-%control-Courseduration = '01'.
        READ ENTITIES OF zi_roottest IN LOCAL MODE
        ENTITY Student
        FIELDS ( Course Courseduration )
        WITH VALUE #( ( %key = <lfs_entity>-%key ) )
        RESULT DATA(lt_course).
        IF sy-subrc IS INITIAL.
          READ TABLE lt_course ASSIGNING FIELD-SYMBOL(<lfs_db_course>) INDEX 1.
          IF sy-subrc IS INITIAL.
            <lfs_db_course>-Course = COND #( WHEN <lfs_entity>-%control-Course = '01' THEN
                                                   <lfs_entity>-Course ELSE <lfs_db_course>-Course ).
            <lfs_db_course>-Courseduration = COND #( WHEN <lfs_entity>-%control-Courseduration = '01' THEN
            <lfs_entity>-Courseduration ELSE <lfs_db_course>-Courseduration ).
          ENDIF.
        ENDIF.
        IF <lfs_db_course> IS ASSIGNED.
          IF <lfs_db_course>-Courseduration LT 5 AND <lfs_db_course>-Course EQ 'C'.
            APPEND VALUE #( %tky = <lfs_entity>-%tky ) TO failed-student.
            APPEND VALUE #( %tky = <lfs_entity>-%tky
            %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
            text = 'For computer, duration cannot be less than 5 years' ) ) TO reported-student.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD is_update_allowed.
    update_allowed = abap_true.
  ENDMETHOD.

  METHOD CopyStudent.
*    DATA: lt_student TYPE TABLE FOR CREATE zi_roottest.
*    READ ENTITIES OF zi_roottest IN LOCAL MODE
*    ENTITY Student
*    ALL FIELDS WITH CORRESPONDING #( keys )
*    RESULT DATA(Studentdta).
*
*    LOOP AT studentdta ASSIGNING FIELD-SYMBOL(<lfs_std>).
*      APPEND VALUE #( %cid = keys[ KEY entity %key = <lfs_std>-%key ]-%cid
*                      %is_draft = keys[ KEY entity %key = <lfs_std>-%key ]-%param-%is_draft
*                      %data = CORRESPONDING #( <lfs_std> EXCEPT id ) ) TO lt_student ASSIGNING
*                      FIELD-SYMBOL(<lfs_newstud>).
*    ENDLOOP.
*
*    MODIFY ENTITIES OF zi_roottest IN LOCAL MODE
*      ENTITY Student
*      CREATE FIELDS ( Age Course Courseduration Description Dob Firstname Gender Status Lastname )
*      WITH lt_student MAPPED DATA(mapped_stu).
*
*    mapped = mapped_stu.
    MODIFY ENTITIES OF zi_roottest IN LOCAL MODE
          ENTITY Student
          CREATE FROM VALUE #(  FOR <instance> IN keys ( %cid = <instance>-%cid  age = 22
          Courseduration = 5 Course = 'C' Firstname = 'MG' Lastname = 'gad' Dob = sy-datum
          %control = VALUE #(  age = if_abap_behv=>mk-on  course = if_abap_behv=>mk-on Courseduration = if_abap_behv=>mk-on
         Firstname = if_abap_behv=>mk-on Lastname =  if_abap_behv=>mk-on Dob =  if_abap_behv=>mk-on ) ) )  MAPPED mapped
         REPORTED reported
         FAILED failed.
  ENDMETHOD.

ENDCLASS.
