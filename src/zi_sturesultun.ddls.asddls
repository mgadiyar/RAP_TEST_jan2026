@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Student result'
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_STURESULTun
  as select from ztab_resultun
  association        to parent ZI_EMLTEST as _Student on $projection.Id = _Student.Id
  association [1..*] to zi_couseval        as _course  on $projection.Course = _course.Value
  association [1..*] to zi_semval          as _sem     on $projection.Sem = _sem.Value
  association [0..*] to ZI_resultVAL       as _result  on $projection.Results = _result.Value
{
  key id                  as Id,
  key sem                 as Sem,
      course              as Course,
      results             as Results,
      _course.Description as CourseDesc,
      _sem.SemDesc as SemDesc,
      _result.ResDesc as resultDesc,
      lastchgdate,
      locallastchgdate,
      _course,
      _sem,
      _result,
      _Student 
}
