@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'root view test'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_EMLTEST
  as select from ztest_raptestun association to zi_genderval
  as _gend on $projection.Gender = _gend.Value
  composition [0..*] of ZI_STURESULTun as _result
{
  key id        as Id,
      fname     as Firstname,
      lname     as Lastname,
      age       as Age,
      course    as Course,
      coursedur as Courseduration,
      status    as Status,
      gender    as Gender,
      dob       as Dob,
      lastchngdate as Lastchgdate,
      locallastchgdate as Locallastchgdate,
      _gend,
      _gend.Descr as Description,
      _result
      
}
