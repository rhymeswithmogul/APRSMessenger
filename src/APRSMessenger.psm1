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

Function Send-APRSThing
{
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact='Low')]
	[OutputType([Void],   ParameterSetName='APRS-IS')]
	[OutputType([String], ParameterSetName='ToScreen')]
	Param(
		[Parameter(Mandatory, Position=0)]
		[ValidateNotNullOrEmpty()]
		[ValidatePattern('^[A-Z0-9]{3,}(?:\-(?:[0-9]|1[0-5]))?$')]
		[String] $From,

		[Parameter(Mandatory, Position=1)]
		[ValidateNotNullOrEmpty()]
		[ValidatePattern('^[A-Z0-9]{3,}(?:\-(?:[0-9]|1[0-5]))?$')]
		[String] $To,

		[Parameter(Mandatory, Position=2)]
		[String] $Message,

		[ValidateRange(-90,90)]
		[Float] $Latitude,

		[ValidateRange(-180,180)]
		[Float] $Longitude,

		[Parameter(ParameterSetName="APRS-IS")]
		[ValidateSet(
			'asia.aprs2.net', 'aunz.aprs2.net', 'euro.aprs2.net',
			'noam.aprs2.net', 'rotate.aprs2.net', 'soam.aprs2.net'
		)]
		[String] $Server = 'rotate.aprs2.net',

		[Parameter(ParameterSetName="APRS-IS")]
		[ValidateNotNullOrEmpty()]
		[ValidateRange(1,65535)]
		[UInt16] $Port = 14580,

		[Parameter(ParameterSetName="APRS-IS")]
		[Switch] $Force
	)

	#region Handle group bulletins correctly
	# Group bulletins need to be sent to BLNn, with the
	# group name included just before the message itself.
	$MsgTo = $To
	If ($To -Match "^BLN[0-9]")
	{
		$To = "BLN" + $To[3]
	}
	#endregion

	#region Location processing
	# If the latitude and longitude are both zero, a position report will not
	# be included.  0,0 is directly over water, so I'd like to hope that someone
	# won't be messaging from there.  If you can think of a better way, let me
	# know.
	#
	# The two helper functions listed here are at the bottom of this file.
	$Location = ':'
	If ($Latitude -ne 0 -or $Longitude -ne 0)
	{
		$Location = "={0}/{1}`"" -f `
						(Convert-LatitudeToAPRSFormat $Latitude),
						(Convert-LongitudeToAPRSFormat $Longitude)
	}
	#endregion

	$ToSend = "$From>$To,TCPIP*:$Location$($MsgTo.PadRight(9)):$Message"

	If ($PSCmdlet.ParameterSetName -ne 'APRS-IS')
	{
		Return $ToSend
	}
	Else
	{
		#region Create user agent and prepare to sign onto the server
		$ThisModuleName    = $MyInvocation.MyCommand.Module.Name
		$ThisModuleVersion = $MyInvocation.MyCommand.Module.Version
		$Greeting = "user $From pass $(Get-APRSISPasscode $From) vers $ThisModuleName $ThisModuleVersion"
		#endregion

		If ($null -ne $Location) {
			$Location = " with coordinates $Latitude,$Longitude"
		}
		If ($Force -or $PSCmdlet.ShouldProcess("Send a message to $To via APRS-IS$Location", $To, 'Send a message'))
		{
			Try
			{
				$socket = [Net.Sockets.TcpClient]::new($Server, $Port)
				$stream = $socket.GetStream()

				Write-Debug "Sending a greeting to APRS:  $Greeting"
				$writer = [IO.StreamWriter]::new($stream)
				$writer.WriteLine("$Greeting`n")
				$writer.Flush()

				Write-Debug 'Waiting for a response'
				$bufsize = 256
				$buffer = New-Object -TypeName Byte[] -ArgumentList $bufsize
				$null = $stream.Read($buffer, 0, $bufsize)

				Write-Debug "Sending packet: $ToSend"
				$writer.WriteLine("$ToSend`n")
				$writer.Flush()
			}
			Catch [IO.IOException] {
				Write-Error "Could not connect to ${Server}:$Port"
			}
			Finally {
				If ($null -ne $writer) {
					$writer.Close()
				}
				If ($null -ne $stream) {
					$stream.close()
				}
			}
		}
	}
}

Function Send-APRSMessage
{
	[CmdletBinding(SupportsShouldProcess, DefaultParameterSetName='ToScreen', ConfirmImpact='Low')]
	[OutputType([Void],   ParameterSetName='APRS-IS')]
	[OutputType([String], ParameterSetName='ToScreen')]
	Param(
		[Parameter(Mandatory, Position=0)]
		[ValidateNotNullOrEmpty()]
		[ValidatePattern('^[A-Z0-9]{3,}(?:\-(?:[0-9]|1[0-5]))?$')]
		[String] $From,

		[Parameter(Mandatory, Position=1)]
		[ValidateNotNullOrEmpty()]
		[ValidatePattern('^[A-Z0-9]{3,}(?:\-(?:[0-9]|1[0-5]))?$')]
		[String] $To,

		[Parameter(Mandatory, Position=2, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[Alias('InputObject', 'MessageText', 'Text')]
		[ValidateLength(0,67)]
		[ValidatePattern("[^~\|\{]*")]
		[String] $Message,

		[ValidateRange(-90,90)]
		[Float] $Latitude,

		[ValidateRange(-180,180)]
		[Float] $Longitude,

		[Alias('Acknowledgment', 'Acknowledgement')]
		[ValidateLength(1,5)]
		[String] $Acknowledge,

		[Parameter(ParameterSetName='APRS-IS')]
		[ValidateSet(
			'asia.aprs2.net', 'aunz.aprs2.net', 'euro.aprs2.net',
			'noam.aprs2.net', 'rotate.aprs2.net', 'soam.aprs2.net'
		)]
		[String] $Server = 'rotate.aprs2.net',

		[Parameter(ParameterSetName='APRS-IS')]
		[ValidateNotNullOrEmpty()]
		[ValidateRange(1,65535)]
		[UInt16] $Port = 14580,

		[Parameter(ParameterSetName='APRS-IS')]
		[Switch] $Force
	)

	$ToSend = $Message
	If ($Acknowledge)
	{
		$ToSend += "{$Acknowledge"
	}

	$Arguments = @{
		'From' = $From
		'To' = $To
		'Message' = $ToSend
		'WhatIf' = $WhatIfPreference
		'Verbose' = $VerbosePreference
		'Debug' = $DebugPreference
	}
	If ($Latitude -ne 0 -or $Longitude -ne 0)
	{
		$Arguments.Latitude = $Latitude
		$Arguments.Longitude = $Longitude
		$Location = " ($Latitude,$Longitude)"
	}
	If ($PSCmdlet.ParameterSetName -eq 'APRS-IS')
	{
		$Arguments.Server = $Server
		$Arguments.Port = $Port
		$Arguments.Force = $Force
		Write-Debug "From:$From$Location To:$To Msg:$ToSend - sending to ${Server}:$Port (Force:$Force)"
	}
	Else {
		Write-Debug "From:$From$Location To:$To Msg:$ToSend - printing to screen"
	}
	Return (Send-APRSThing @Arguments)
}

Function Send-APRSBulletin
{
	[CmdletBinding(SupportsShouldProcess, DefaultParameterSetName='ToScreen', ConfirmImpact='Low')]
	[Alias('Send-APRSGeneralBulletin')]
	[OutputType([Void],   ParameterSetName='APRS-IS')]
	[OutputType([String], ParameterSetName='ToScreen')]
	Param(
		[Parameter(Mandatory, Position=0)]
		[ValidateNotNullOrEmpty()]
		[ValidatePattern('^[A-Z0-9]{3,}(?:\-(?:[0-9]|1[0-5]))?$')]
		[String] $From,

		[Parameter(Mandatory, Position=1)]
		[ValidateRange(0,9)]
		[UInt] $BulletinID,

		[Parameter(Mandatory, Position=2, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[Alias('InputObject', 'MessageText', 'Text')]
		[ValidateLength(0,67)]
		[ValidatePattern("[^~\|]*")]
		[String] $Message,

		[ValidateRange(-90,90)]
		[Float] $Latitude,

		[ValidateRange(-180,180)]
		[Float] $Longitude,

		[Parameter(ParameterSetName='APRS-IS')]
		[ValidateSet(
			'asia.aprs2.net', 'aunz.aprs2.net', 'euro.aprs2.net',
			'noam.aprs2.net', 'rotate.aprs2.net', 'soam.aprs2.net'
		)]
		[String] $Server = 'rotate.aprs2.net',

		[Parameter(ParameterSetName='APRS-IS')]
		[ValidateNotNullOrEmpty()]
		[ValidateRange(1,65535)]
		[UInt16] $Port = 14580,

		[Parameter(ParameterSetName='APRS-IS')]
		[Switch] $Force
	)

	$To = "BLN$BulletinID"

	$Arguments = @{
		'From' = $From
		'To' = $To
		'Message' = $Message
		'WhatIf' = $WhatIfPreference
		'Verbose' = $VerbosePreference
		'Debug' = $DebugPreference
	}
	If ($Latitude -ne 0 -or $Longitude -ne 0)
	{
		$Arguments.Latitude = $Latitude
		$Arguments.Longitude = $Longitude
		$Location = " ($Latitude,$Longitude)"
	}
	If ($PSCmdlet.ParameterSetName -eq 'APRS-IS') {
		$Arguments.Server = $Server
		$Arguments.Port = $Port
		$Arguments.Force = $Force
		Write-Debug "From:$From$Location To:$To Msg:$Message - sending to ${Server}:$Port (Force:$Force)"
	}
	Else {
		Write-Debug "From:$From$Location To:$To Msg:$Message - printing to screen"
	}
	Return (Send-APRSThing @Arguments)
}

Function Send-APRSGroupBulletin
{
	[CmdletBinding(SupportsShouldProcess, DefaultParameterSetName='ToScreen', ConfirmImpact='Low')]
	[Alias('Send-APRSGeneralBulletin')]
	[OutputType([Void],   ParameterSetName='APRS-IS')]
	[OutputType([String], ParameterSetName='ToScreen')]
	Param(
		[Parameter(Mandatory, Position=0)]
		[ValidateNotNullOrEmpty()]
		[ValidatePattern('^[A-Z0-9]{3,}(?:\-(?:[0-9]|1[0-5]))?$')]
		[String] $From,

		[Parameter(Mandatory, Position=1)]
		[ValidateRange(0,9)]
		[UInt] $BulletinID,

		[Parameter(Mandatory, Position=2)]
		[ValidateLength(0,5)]
		[String] $GroupName,

		[Parameter(Mandatory, Position=3, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[Alias('InputObject', 'MessageText', 'Text')]
		[ValidateLength(0,67)]
		[ValidatePattern("[^~\|]*")]
		[String] $Message,

		[ValidateRange(-90,90)]
		[Float] $Latitude,

		[ValidateRange(-180,180)]
		[Float] $Longitude,

		[Parameter(ParameterSetName='APRS-IS')]
		[ValidateSet(
			'asia.aprs2.net', 'aunz.aprs2.net', 'euro.aprs2.net',
			'noam.aprs2.net', 'rotate.aprs2.net', 'soam.aprs2.net'
		)]
		[String] $Server = 'rotate.aprs2.net',

		[Parameter(ParameterSetName='APRS-IS')]
		[ValidateNotNullOrEmpty()]
		[ValidateRange(1,65535)]
		[UInt16] $Port = 14580,

		[Parameter(ParameterSetName='APRS-IS')]
		[Switch] $Force
	)

	$To = "BLN$BulletinID$GroupName"

	$Arguments = @{
		'From' = $From
		'To' = $To
		'Message' = $Message
		'WhatIf' = $WhatIfPreference
		'Verbose' = $VerbosePreference
		'Debug' = $DebugPreference
	}
	If ($Latitude -ne 0 -or $Longitude -ne 0)
	{
		$Arguments.Latitude = $Latitude
		$Arguments.Longitude = $Longitude
		$Location = " ($Latitude,$Longitude)"
	}
	If ($PSCmdlet.ParameterSetName -eq 'APRS-IS') {
		$Arguments.Server = $Server
		$Arguments.Port = $Port
		$Arguments.Force = $Force
		Write-Debug "From:$From$Location To:$To Msg:$Message - sending to ${Server}:$Port (Force:$Force)"
	}
	Else {
		Write-Debug "From:$From$Location To:$To Msg:$Message - printing to screen"
	}
	Return (Send-APRSThing @Arguments)
}

Function Send-APRSAnnouncement
{
	[CmdletBinding(SupportsShouldProcess, DefaultParameterSetName='ToScreen', ConfirmImpact='Low')]
	[OutputType([Void],   ParameterSetName='APRS-IS')]
	[OutputType([String], ParameterSetName='ToScreen')]
	Param(
		[Parameter(Mandatory, Position=0)]
		[ValidateNotNullOrEmpty()]
		[ValidatePattern('^[A-Z0-9]{3,}(?:\-(?:[0-9]|1[0-5]))?$')]
		[String] $From,

		[Parameter(Mandatory, Position=1)]
		[ValidatePattern('[A-Z]')]
		[Char] $AnnouncementID,

		[Parameter(Mandatory, Position=2, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[Alias('InputObject', 'MessageText', 'Text')]
		[ValidateLength(0,67)]
		[ValidatePattern("[^~\|]*")]
		[String] $Message,

		[ValidateRange(-90,90)]
		[Float] $Latitude,

		[ValidateRange(-180,180)]
		[Float] $Longitude,

		[Parameter(ParameterSetName='APRS-IS')]
		[ValidateSet(
			'asia.aprs2.net', 'aunz.aprs2.net', 'euro.aprs2.net',
			'noam.aprs2.net', 'rotate.aprs2.net', 'soam.aprs2.net'
		)]
		[String] $Server = 'rotate.aprs2.net',

		[Parameter(ParameterSetName='APRS-IS')]
		[ValidateNotNullOrEmpty()]
		[ValidateRange(1,65535)]
		[UInt16] $Port = 14580,

		[Parameter(ParameterSetName='APRS-IS')]
		[Switch] $Force
	)

	$To = "BLN$AnnouncementID"

	$Arguments = @{
		'From' = $From
		'To' = $To
		'Message' = $Message
		'WhatIf' = $WhatIfPreference
		'Verbose' = $VerbosePreference
		'Debug' = $DebugPreference
	}
	If ($Latitude -ne 0 -or $Longitude -ne 0)
	{
		$Arguments.Latitude = $Latitude
		$Arguments.Longitude = $Longitude
		$Location = " ($Latitude,$Longitude)"
	}
	If ($PSCmdlet.ParameterSetName -eq 'APRS-IS') {
		$Arguments.Server = $Server
		$Arguments.Port = $Port
		$Arguments.Force = $Force
		Write-Debug "From:$From$Location To:$To Msg:$Message - sending to ${Server}:$Port (Force:$Force)"
	}
	Else {
		Write-Debug "From:$From$Location To:$To Msg:$Message - printing to screen"
	}
	Return (Send-APRSThing @Arguments)
}

Function Get-APRSISPasscode
{
	[CmdletBinding()]
	[Alias('Get-APRSISPassword')]
	[OutputType([UInt16])]
	Param(
		[Parameter(Mandatory, Position=0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[Alias('Call', 'InputObject')]
		[ValidatePattern('^[A-Z0-9]{3,}(?:\-(?:[0-9]|1[0-5]))?$')]
		[String] $Callsign
	)

	#region Remove SSID from callsign
	$pos = $Callsign.IndexOf('-')
	If ($pos -ne -1) {
		$Callsign = $Callsign.Substring(0, $pos)
	}
	#endregion

	#region Calculate APRS-IS passcode
	# This function was adapted from PHP code by Peter Goodhall, 2M0SQL.
	# His project is not licensed, so I am using this code in good faith,
	# under the assumption that it was released into the public domain.
	# You can find it at https://github.com/magicbug/PHP-APRS-Passcode
	$Hash = [UInt16]0x73E2
	For ($i = 0; $i -lt $Callsign.Length; $i += 2)
	{
		If ($i -lt $Callsign.Length - 1)
		{
			$Upper,$Lower = [Text.Encoding]::ASCII.GetBytes($Callsign.Substring($i,2))
		}
		Else
		{
			$Upper = [Text.Encoding]::ASCII.GetBytes($Callsign[$i])[0]
			$Lower = 0
		}

		[UInt16]$ToHash = $Upper
		$ToHash = $ToHash -shl 8
		$ToHash = $ToHash -bor $Lower

		Write-Debug "Hash = $(Format-AsHex $Hash) -bxor $(Format-AsHex $ToHash)"
		$Hash = $Hash -bxor $ToHash
	}
	Write-Debug "Hash = $(Format-AsHex $Hash) -band 0x7FFF"
	$Hash = $Hash -band 0x7FFF
	Write-Debug "Hash is $(Format-AsHex $Hash) = $Hash"
	#endregion

	Write-Verbose "Your APRS-IS username is $Callsign, and your password is $Hash."
	Return $Hash
}

# This is a helper function used to generate debugging output inside the
# previous function.
Function Format-AsHex
{
	[OutputType([String])]
	Param(
		[Parameter(Mandatory, Position=0)]
		[UInt16] $Number
	)

	Return "0x$('{0:X}' -f $Number)"
}

Function Convert-LongitudeToAPRSFormat
{
	[CmdletBinding()]
	[OutputType([String])]
	Param(
		[Parameter(Mandatory, Position=0)]
		[ValidateRange(-180,180)]
		[Float] $Location
	)

	$ReturnValue = ""
	$WasNegative = ($Location -lt 0)
	$Location = [Math]::abs($Location)

	# Process latitude degrees
	$ReturnValue = [Math]::floor($Location).ToString().PadLeft(2,'0')
	Write-Verbose "RetVal = `"$ReturnValue`""
		
	# Process latitude minutes
	$DecimalPart = ($Location - [Math]::floor($Location)) * 60
	$ReturnValue += [Math]::floor($DecimalPart).ToString().PadLeft(2,'0')
	Write-Verbose "RetVal = `"$ReturnValue`""

	# Process latitude seconds
	$ReturnValue += '.'
	$DecimalPart = ($DecimalPart - [Math]::floor($DecimalPart)) * 60
	$ReturnValue += [Math]::round($DecimalPart).ToString().PadLeft(2,'0')
	Write-Verbose "RetVal = `"$ReturnValue`""
	
	# Determine direction
	If ($WasNegative) {
		$ReturnValue += 'W'
	}
	Else {
		$ReturnValue += 'E'
	}

	Return $ReturnValue.PadLeft(9,'0')
}

Function Convert-LatitudeToAPRSFormat
{
	[CmdletBinding()]
	[OutputType([String])]
	Param(
		[Parameter(Mandatory, Position=0)]
		[ValidateRange(-90,90)]
		[Float] $Location
	)

	# Take .Substring(1) to chop off the leading zero.
	$Result = Convert-LongitudeToAPRSFormat $Location -Verbose:$VerbosePreference
	Return $Result.Substring(1) -Replace 'W','S' -Replace 'E','N'
}