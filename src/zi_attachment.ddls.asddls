@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Attachment for Student'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity zi_attachment as select from ztab_attachment
association to parent zi_roottest as _Student on $projection.Id = _Student.Id
{
    key attach_id as AttachId,
    id as Id,
    @EndUserText.label: 'Comments'
    comments as Comments,
    @EndUserText.label: 'Attachments' //attach
    attachments as Attachments,
    @EndUserText.label: 'Mimetype'
    mimetype as Mimetype,
    @EndUserText.label: 'Filetype'
    filetype as Filetype,
    _Student // Make association public
}
