@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Composition for attachment'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZC_attachment_std as projection on zi_attachment
{
    key AttachId,
    Id,
    Comments,
     @Semantics.largeObject:{mimeType: 'Mimetype',fileName: 'Filetype',
    contentDispositionPreference: #ATTACHMENT,acceptableMimeTypes: [ 'application/pdf' ] }
    Attachments,
    Mimetype,
    Filetype,
    /* Associations */
    _Student:redirected to parent zc_roottest
}
