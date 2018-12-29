$currentDirectory = split-path $MyInvocation.MyCommand.Definition

# See if we have the ClientSecret available
if([string]::IsNullOrEmpty($env:SignClientSecret)){
	Write-Host "Client Secret not found, not signing packages"
	return;
}

# Setup Variables we need to pass into the sign client tool
dotnet tool install --tool-path . SignClient

$appSettings = "$currentDirectory\appsettings.json"

$nupgks = ls $Env:ArtifactDirectory\*.nupkg | Select -ExpandProperty FullName

foreach ($nupkg in $nupgks){
	Write-Host "Submitting $nupkg for signing"

	.\SignClient 'sign' -c $appSettings -i $nupkg -r $env:SignClientUser -s $env:SignClientSecret -n 'Zeroconf' -d 'Zeroconf' -u 'https://github.com/onovotny/zeroconf' 

	Write-Host "Finished signing $nupkg"
}

Write-Host "Sign-package complete"