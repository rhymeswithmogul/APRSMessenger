#Requires -Module Microsoft.PowerShell.Security

If (-Not $IsWindows) {
	Throw [PlatformNotSupportedException]::new('This script requires Microsoft Windows.')
}

#region Create a build directory.
# We will copy all important files to a temporary folder.  We're using
# New-Temporary file only to create a filename that the runtime guarantees to
# be unique.
$TempFile = New-TemporaryFile
Remove-Item -Path $TempFile
$DestinationPath = (Join-Path -Path $env:Temp -ChildPath $TempFile.Name)

New-Item -Path $DestinationPath -ItemType Directory -ErrorAction Stop
Copy-Item -Path .. -Destination $DestinationPath -Recurse -Exclude @(
	'.git',			# This can be retrieved from GitHub.
	'icon',			# An icon URI is contained in the module manifest.
	'man',			# Get-Help should be used instead.
	'release',		# You don't need this script.  Only I do.
	'INSTALL.md'	# Install-Module handles installation for the user.
)
#endregion

#region Sign all script files.
# This portion of the script signs all files with my code signing certificate.
# Since the command's default parameters are defined in my shell, and my private
# key requires protection, there are no secrets to hide in this script.  This
# will silently fail on all other computers except mine.
Push-Location -Path $DestinationPath

Get-ChildItem -Recurse -Include @('*.ps?1') | ForEach-Object {
	Set-AuthenticodeSignature $_
}

New-FileCatalog -Path . -CatalogFilePath APRSMessenger.cat -CatalogVersion 2.0
#endregion

Pop-Location -Path $DestinationPath