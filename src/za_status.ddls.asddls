@EndUserText.label: 'Abstract entity for Student Status upd'
@Metadata.allowExtensions: true
define abstract entity ZA_STATUS
  //  with parameters parameter_name : parameter_type
{
  @UI.defaultValue: #( 'ELEMENT_OF_REFERENCED_ENTITY : Status' )
  @EndUserText.label: 'E Status'
  status    : abap_boolean;
  @EndUserText.label: 'E Course'
  @UI.defaultValue: #( 'ELEMENT_OF_REFERENCED_ENTITY : Course' )
  course    : abap.char(40);
  @EndUserText.label: 'E CourseDur'
  @UI.defaultValue: #( 'ELEMENT_OF_REFERENCED_ENTITY : Courseduration' )
  coursedur : abap.numc(1);
}
