@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'EML test consumption'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZC_EMLTEST
  provider contract transactional_query as projection on ZI_EMLTEST
{
    key Id,
    Firstname,
    Lastname,
    Age,
    Course,
    Courseduration,
    Status,
    Gender,
    Dob,
    Lastchgdate,
    Locallastchgdate,
    Description,
    /* Associations */
    _gend,
    _result: redirected to composition child ZC_STURESULTun
}
