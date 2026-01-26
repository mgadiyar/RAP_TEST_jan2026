@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'consumption result'
@Metadata.allowExtensions: true
define view entity Zc_STURESULT
  as projection on ZI_STURESULT
{
  key     Id,
          Course,
          Sem,
          Results,
          CourseDesc,
          SemDesc,
          resultDesc,
          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_FEECALC'
          @EndUserText.label: 'Fees'
  virtual Fees : abap.int4,
          lastchgdate,
          locallastchgdate,
          /* Associations */
          _course,
          _result,
          _sem,
          _Student : redirected to parent zc_roottest
}
