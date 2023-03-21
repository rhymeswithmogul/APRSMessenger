# This file is part of APRSMessenger.
#
# APRSMessenger is free software: you can redistribute it and/or modify it under
# the terms of the GNU Affero General Public License as published by the Free
# Software Foundation, either version 3 of the License, or (at your option) any
# later version.
#
# APRSMessenger is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more
# details.
#
# You should have received a copy of the GNU Affero General Public License
# along with APRSMessenger. If not, see <https://www.gnu.org/licenses/>. 

#Requires -Module Microsoft.PowerShell.Security
#Requires -Module Pester

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
	'.git*',		# This can be retrieved from GitHub.
	'coverage.xml'	# junk
	'icon',			# An icon URI is contained in the module manifest.
	'man',			# Get-Help should be used instead.
	'release',		# You don't need this script.  Only I do.
	'INSTALL.md'	# Install-Module handles installation for the user.
)
Push-Location -Path $DestinationPath
#endregion

#region Sign all script files.
# This portion of the script signs all files with my code signing certificate.
# Since the command's default parameters are defined in my shell, and my private
# key requires protection, there are no secrets to hide in this script.  This
# will silently fail on all other computers except mine.

Get-ChildItem -Recurse -Include @('*.ps.?1') | ForEach-Object {
	Set-AuthenticodeSignature $_
}

New-FileCatalog -Path . -CatalogFilePath APRSMessenger.cat -CatalogVersion 2.0
#endregion

#region Invoke PSScriptAnalyzer.
$analysis = Invoke-ScriptAnalyzer -Path . -Recurse -Settings PSGallery
If ($null -ne $analysis)
{
	Throw 'Please correct PSScriptAnalyzer errors and try again.'
}
#endregion

#region Run Pester tests.
Invoke-Pester -Path APRSMessenger.Tests.ps1 -CodeCoverage (Join-Path -Path 'src' -ChildPath 'APRSMessenger.psm1')
#endregion

Pop-Location -Path $DestinationPath