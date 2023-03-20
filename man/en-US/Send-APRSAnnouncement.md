---
external help file: APRSMessenger-help.xml
Module Name: APRSMessenger
online version: https://github.com/rhymeswithmogul/APRSMessenger/blob/main/man/en-US/Send-APRSAnnouncement.md
schema: 2.0.0
---

# Send-APRSAnnouncement

## SYNOPSIS
Sends an APRS announcement to the APRS-IS network.

## SYNTAX

### ToScreen (Default)
```
Send-APRSAnnouncement [-From] <String> [-AnnouncementID] <Char> [-Message] <String> [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### APRS-IS
```
Send-APRSAnnouncement [-From] <String> [-AnnouncementID] <Char> [-Message] <String> [-Server <String>]
 [-Port <UInt16>] [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
This cmdlet will create and send an APRS announcement to the APRS-IS network.  If you do not specify a server and/or port name, the packet will be printed to the screen instead.

## EXAMPLES

### Example 1
```powershell
PS C:\> Send-APRSAnnouncement -From "GR8CLUB" -AnnouncementID "S" -Message "There will be a SKYWARN net on GreatClub's repeater Sunday at 8:00 PM." -Server noam.aprs2.net
```

Send an announcement to the APRS-IS network, advertising GreatClub's weekly SKYWARN net.

## PARAMETERS

### -AnnouncementID
You must specify an announcement identifier.  This is a single uppercase letter.

```yaml
Type: Char
Parameter Sets: (All)
Aliases:
Accepted values: A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V, W, X, Y, Z

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Force
Send this announcement via APRS-IS without confirming.  This will only happen if your $ConfirmPreference is set to "Low".

```yaml
Type: SwitchParameter
Parameter Sets: APRS-IS
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -From
The sender's callsign, with or without an SSID.  This will almost always be yours or your club's callsign.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Message
The announcement text.  It may be up to 67 characters in length, and can contain any ASCII characters except for pipe ('|') and tilde ('~').

```yaml
Type: String
Parameter Sets: (All)
Aliases: InputObject, MessageText, Text

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -Port
The TCP port used to connect to the APRS-IS server.  By default, this is port 14580.

```yaml
Type: UInt16
Parameter Sets: APRS-IS
Aliases:

Required: False
Position: Named
Default value: 14580
Accept pipeline input: False
Accept wildcard characters: False
```

### -Server
The fully-qualified domain name of the APRS-IS server.  By default, rotate.aprs2.net is used, but it is best practice to provide your regional server's name.

```yaml
Type: String
Parameter Sets: APRS-IS
Aliases:
Accepted values: asia.aprs2.net, aunz.aprs2.net, euro.aprs2.net, noam.aprs2.net, rotate.aprs2.net, soam.aprs2.net

Required: False
Position: Named
Default value: rotate.aprs2.net
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run, and no data is sent to APRS-IS.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String
This cmdlet can accept message data through the pipeline.

## OUTPUTS

### System.Void
If you specify APRS-IS server information, the group bulletin will be sent to the APRS-IS network.  No data is returned to the pipeline.

### System.String
If you do not specify APRS-IS server information, the message packet will be returned.  You will have to send it via some other manner.

## NOTES
Announcements are typically made for situations leading up to an event, in contrast to bulletins which are typically used within the event.

## RELATED LINKS

[Send-APRSBulletin]()
[Send-APRSGroupBulletin]()
[Send-APRSMessage]()