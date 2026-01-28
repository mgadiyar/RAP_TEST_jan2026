@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'consumption result'
@Metadata.allowExtensions: true
define view entity ZC_STURESULTun
  as projection on ZI_STURESULTun
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
          _Student : redirected to parent zc_emltest
}
