@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption for Roottest'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity zc_roottest
  as projection on zi_roottest as Student
{
      @EndUserText.label: 'StudentID'
  key Id,
      @EndUserText.label: 'Firstname'
      Firstname,
      @EndUserText.label: 'lastname'
      Lastname,
      @EndUserText.label: 'Age'
      Age,
      @EndUserText.label: 'Course'
      Course,
      @EndUserText.label: 'CourseDuration'
      Courseduration,
      Status,
      Gender,
      Description,
      Dob,
      Locallastchgdate,
      Lastchgdate,
//    /* composition child */
  
/* Redirect composition child */
  _result: redirected to composition child  Zc_STURESULT,
  _attach: redirected to composition child  zc_attachment_std

}
