@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'root view test'
@Metadata.ignorePropagatedAnnotations: true
define root view entity zi_roottest
  as select from ztest_raptest association to zi_genderval
  as _gend on $projection.Gender = _gend.Value
 composition [0..*] of ZI_STURESULT as _result
 composition[1..*] of zi_attachment as _attach 
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
      _result,
      _attach
}
