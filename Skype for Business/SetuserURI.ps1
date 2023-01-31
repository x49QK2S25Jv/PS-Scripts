#Starting script for SfB Ps Tasks

$skypeuser = Read-Host "Please enter the identity of skype for business person"
$skypeLineURI = Read-Host "Please enter a line URI of skype user eg tel:9853 or tel:+6499659345"


Set-CsUser -Identity $skypeuser -LineUri $skypelineURI
Set-ADuser -Identity $skypeuser -telephoneNumber $skypelineURI