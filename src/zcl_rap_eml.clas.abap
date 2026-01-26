CLASS zcl_rap_eml DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_rap_eml IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    DATA: lt_emltest    TYPE TABLE FOR CREATE zi_roottest,
          lt_attach     TYPE TABLE FOR CREATE zi_roottest\_result,
          ls_attach     LIKE LINE OF lt_attach,
          lt_operations TYPE  abp_behv_changes_tab,
          lt_create     TYPE TABLE FOR CREATE zi_roottest,
          lt_change     TYPE TABLE FOR UPDATE zi_roottest,
          lt_delete     TYPE TABLE FOR DELETE Zi_roottest,

          lt_target     LIKE ls_attach-%target.
    IF 1 = 2.

      lt_emltest = VALUE #( ( %cid = 'Stuhead' Age = 26 Course = 'M' Courseduration = 5
      Firstname = 'eml' Lastname = 'test' Status = ''
      %control =  VALUE #( Age = if_abap_behv=>mk-on Course = if_abap_behv=>mk-on
      Courseduration = if_abap_behv=>mk-on Firstname = if_abap_behv=>mk-on
      Lastname = if_abap_behv=>mk-on Status = if_abap_behv=>mk-on ) ) ).

      lt_target = VALUE #( ( %cid = 'Studatt' Results = 'Pass' Sem = '5' Course = 'ABC'
      %control =  VALUE #( Results = if_abap_behv=>mk-on  Sem = if_abap_behv=>mk-on
      Course = if_abap_behv=>mk-on ) ) ).

      lt_attach = VALUE #( ( %cid_ref = 'Stuhead' %target = lt_target ) ).

      MODIFY ENTITIES OF zi_roottest IN LOCAL MODE
      ENTITY Student
      CREATE FROM lt_emltest
      CREATE BY \_result FROM lt_attach
      MAPPED DATA(lt_mapped)
      FAILED DATA(lt_failed)
      REPORTED DATA(lt_reported).

      IF lt_failed IS INITIAL.
        out->write(
          EXPORTING
            data   = lt_failed
            name   = 'Failed'
*        RECEIVING
*          output =
        ).
      ELSE.
        COMMIT ENTITIES.
      ENDIF.
    ELSE.
      IF 3 = 4.
*   read entity zi_roottest
*   FROM value #( ( %tky-Id = '722A53DF2F5F1FE0BCF2FE27B00C94AE'
*   %control = value #( Course = if_abap_behv=>mk-on Courseduration = if_abap_behv=>mk-on ) ) )
*   RESULT data(lt_result)
*   FAILED lt_failed
*   REPORTED lt_reported.

        READ ENTITIES OF zi_roottest
        ENTITY Student
        ALL FIELDS WITH VALUE #( ( %tky-Id = 'FEE7E67524AE1FD0BC8A0F608D6999' ) )
        RESULT DATA(lt_result)

        ENTITY Student
        BY \_result
        ALL FIELDS WITH VALUE #( ( %tky-Id = 'FEE7E67524AE1FD0BC8A0F608D6999' ) )
        RESULT DATA(lt_stresult)
        FAILED lt_failed
        REPORTED lt_reported.


        IF sy-subrc IS INITIAL.
          out->write(
            EXPORTING
              data   = lt_result
*       name   =
*     RECEIVING
*       output =
          ).
          out->write(
            EXPORTING
              data   = lt_stresult
*       name   =
*     RECEIVING
*       output =
          ).
        ELSE.
          out->write(
         EXPORTING
           data   = lt_failed
*       name   =
*     RECEIVING
*       output =
       ).
          out->write(
         EXPORTING
           data   = lt_reported
*       name   =
*     RECEIVING
*       output =
       ).

        ENDIF.
      ELSE.

        lt_create = VALUE #( ( %cid = 'Studhead' Firstname = 'MG' Lastname = 'Hjmd'
        Course = 'C' Age = '28' Gender = 'M'
         %control = VALUE #( Firstname = if_abap_behv=>mk-on Lastname = if_abap_behv=>mk-on
         Course = if_abap_behv=>mk-on Age = if_abap_behv=>mk-on  Gender = if_abap_behv=>mk-on   ) ) ).

        lt_change = VALUE #( (  %cid_ref = 'Studhead' Status = 'X' %control-Status = if_abap_behv=>mk-on ) ).
        lt_delete = VALUE #( ( %tky-Id = '722A53DF2F5F1FE0BCF2FE27B00C94AE' ) ).

        lt_operations = VALUE #(
        ( op = if_abap_behv=>op-m-create entity_name = 'ZI_ROOTTEST' instances = REF #( lt_create ) )
        ( op = if_abap_behv=>op-m-update entity_name = 'ZI_ROOTTEST' instances = REF #( lt_change ) )
        ( op = if_abap_behv=>op-m-delete entity_name = 'ZI_ROOTTEST' instances = REF #( lt_delete ) )
        ).

        MODIFY ENTITIES Operations lt_operations
        failed data(lt_failedop)
        REPORTED data(lt_reportedop)
        mapped data(lt_mapop).

        commit ENTITIES.


      ENDIF.

    ENDIF.


  ENDMETHOD.

ENDCLASS.
