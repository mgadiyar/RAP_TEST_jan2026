CLASS zcl_emlclassun DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES: tt_entities    TYPE TABLE FOR CREATE zi_emltest,
           tt_entityupd   TYPE TABLE FOR UPDATE zi_emltest,

           tt_mappedearly TYPE RESPONSE FOR MAPPED EARLY zi_emltest,
           tt_failedearly TYPE RESPONSE FOR FAILED EARLY zi_emltest,
           tt_researly    TYPE RESPONSE FOR REPORTED EARLY zi_emltest,
           tt_reslat      TYPE RESPONSE FOR REPORTED LATE zi_emltest,
           tt_keys        TYPE TABLE FOR READ IMPORT zi_emltest,
           tt_result      TYPE TABLE FOR READ RESULT zi_emltest,
           tt_del         TYPE TABLE FOR DELETE zi_emltest.


    "class constuctor
    CLASS-METHODS: get_instance RETURNING VALUE(ro_intance) TYPE REF TO zcl_emlclassun.
    METHODS: earlynumbering_create
      IMPORTING entities TYPE tt_entities
      CHANGING  mapped   TYPE tt_mappedearly
                failed   TYPE tt_failedearly
                reported TYPE tt_researly,

      newid
        RETURNING VALUE(l_newid) TYPE Ztest_raptestun-id,

      create
        IMPORTING entities TYPE tt_entities
        CHANGING  mapped   TYPE tt_mappedearly
                  failed   TYPE  tt_failedearly
                  reported TYPE tt_researly,

      save
        CHANGING reported TYPE tt_reslat,

      read
        IMPORTING keys     TYPE tt_keys
        CHANGING  result   TYPE tt_result
                  failed   TYPE tt_failedearly
                  reported TYPE tt_researly,

      update
        IMPORTING entities TYPE tt_entityupd
        CHANGING  mapped   TYPE tt_mappedearly
                  failed   TYPE tt_failedearly
                  reported TYPE tt_researly,

      delete
        IMPORTING keys     TYPE tt_del
        CHANGING  mapped   TYPE tt_mappedearly
                  failed   TYPE tt_failedearly
                  reported TYPE tt_researly.

  PROTECTED SECTION.
  PRIVATE SECTION.
    CLASS-DATA: mo_instance TYPE REF TO zcl_emlclassun,
                lt_student  TYPE STANDARD TABLE OF Ztest_raptestun,
                lt_del  TYPE STANDARD TABLE OF Ztest_raptestun,
                lt_result   TYPE STANDARD TABLE OF ztab_result,
                gs_mapped   TYPE tt_mappedearly.


ENDCLASS.



CLASS zcl_emlclassun IMPLEMENTATION.
  METHOD get_instance.
    mo_instance = ro_intance = COND #( WHEN mo_instance IS BOUND
                                       THEN mo_instance
                                       ELSE NEW #(  ) ).
  ENDMETHOD.

  METHOD earlynumbering_create.
    DATA(ls_mapped) = gs_mapped.

    DATA(lv_newid) = newid( ).


    LOOP AT lt_student ASSIGNING FIELD-SYMBOL(<lfs_student>).
      IF <lfs_student> IS ASSIGNED.
        <lfs_student>-id = lv_newid.
      ENDIF.
    ENDLOOP.

    mapped-student = VALUE #( FOR ls_entity IN entities WHERE ( id IS INITIAL )
                      (
                      %cid = ls_entity-%cid
                      %is_draft = ls_entity-%is_draft
                      id = lv_newid ) ).

  ENDMETHOD.

  METHOD newid.
    TRY.
        l_newid = cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ).
      CATCH cx_uuid_error.
        "handle exception
    ENDTRY.
  ENDMETHOD.

  METHOD create.
    lt_student = CORRESPONDING #( entities MAPPING FROM ENTITY ).

    mapped = VALUE #( Student = VALUE #( FOR entity IN entities
    ( %cid = entity-%cid
    %is_draft = entity-%is_draft
    %key = entity-%key
    ) ) ).

  ENDMETHOD.

  METHOD save.
    IF lt_student[] IS NOT INITIAL.
      MODIFY ztest_raptestun FROM TABLE @lt_student.
    ENDIF.
    if lt_del is not initial.
     delete ztest_raptestun FROM TABLE @lt_del.
    endif.

  ENDMETHOD.

  METHOD read.
    SELECT * FROM ztest_raptestun
    FOR ALL ENTRIES IN @keys
    WHERE id = @keys-Id
    INTO TABLE @DATA(lt_read).
    IF sy-subrc IS INITIAL.

      result =  CORRESPONDING #( lt_read MAPPING TO ENTITY ).

    ENDIF.

  ENDMETHOD.

  METHOD update.

    lt_student = CORRESPONDING #( entities MAPPING FROM ENTITY ).


  ENDMETHOD.

  METHOD delete.
  SELECT * FROM ztest_raptestun
    FOR ALL ENTRIES IN @keys
    WHERE id = @keys-Id
    INTO TABLE @lt_del.


  ENDMETHOD.

ENDCLASS.
