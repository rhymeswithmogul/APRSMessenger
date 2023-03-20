---
external help file: APRSMessenger-help.xml
Module Name: APRSMessenger
online version: https://github.com/rhymeswithmogul/APRSMessenger/blob/main/man/en-US/Get-APRSISPasscode.md
schema: 2.0.0
---

# Get-APRSISPasscode

## SYNOPSIS
Generates an APRS-IS passcode for a given callsign.

## SYNTAX

```
Get-APRSISPasscode [-Callsign] <String> [<CommonParameters>]
```

## DESCRIPTION
To send a message to the APRS-IS network, a user must authenticate with a procedurally-generated password.  This cmdlet can create that.

Note that this module's Send-* cmdlets will call this function for you.  This is merely provided as a convenience.

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-APRSISPasscode W1AW
25988
```

If you happen to be working at ARRL headquarters and you need to know your passcode, this is how you could find it out.

## PARAMETERS

### -Callsign
Your callsign, with or without an SSID.  If you specify an SSID, it will be ignored, as it has no bearing on the generated passcode.

```yaml
Type: String
Parameter Sets: (All)
Aliases: Call, InputObject

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String
## OUTPUTS

### System.UInt16
## NOTES
These passcodes are algorithmically generated and cannot be changed. Please do not use this knowledge for evil.

## RELATED LINKS

[APRS Passcode Generator](https://apps.magicbug.co.uk/passcode/)
[about_APRSMessenger]()