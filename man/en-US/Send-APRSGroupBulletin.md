---
external help file: APRSMessenger-help.xml
Module Name: APRSMessenger
online version: https://github.com/rhymeswithmogul/APRSMessenger/blob/main/man/en-US/Send-APRSGroupBulletin.md
schema: 2.0.0
---

# Send-APRSGroupBulletin

## SYNOPSIS
Sends an APRS bulletin with a specified group name.

## SYNTAX

### ToScreen (Default)
```
Send-APRSGroupBulletin [-From] <String> [-BulletinID] <UInt32> [-GroupName] <String> [-Message] <String>
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

### APRS-IS
```
Send-APRSGroupBulletin [-From] <String> [-BulletinID] <UInt32> [-GroupName] <String> [-Message] <String>
 [-Server <String>] [-Port <UInt16>] [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
This cmdlet will generate and send an APRS bulletin with a given identifying number, to a named group.

Specify an APRS-IS server and/or port in order to send it via APRS-IS;  otherwise, it will be printed to the screen.

## EXAMPLES

### Example 1
```powershell
PS C:\> Send-APRSGropuBulletin -From GR8CLUB -BulletinID 0 -GroupName "NET" -Message "Send CQ [space] msg to GR8CLUB to check into GreatClub's APRS net." -Force
```

Send an APRS bulletin with ID number 0 to group NET and the provided message.

## PARAMETERS

### -BulletinID
Provide a bulletin identifier between zero and nine (inclusive).  The identifier is not defined in the APRS specification, and should be interpreted by the receiver.

```yaml
Type: UInt32
Parameter Sets: (All)
Aliases:
Accepted values: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9

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
Send this bulletin via APRS-IS without confirming.  This will only happen if your $ConfirmPreference is set to "Low".

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

### -GroupName
Provide a group name.  Group names can be up to five alphanumeric characters.

From the APRS specification:  "A receiving station can specify a list of bulletin groups of interest.  The list is defined internally by the user at the receiving station.  If a group is selected from the list, the station will only copy bulletins for that group, plus any general bulletins.  If the list is empty, all bulletins are received and generate alerts."

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Message
The bulletin text.  Bulletin text may be up to 67 characters in length, and can contain any ASCII characters except for pipe ('|') and tilde ('~').

```yaml
Type: String
Parameter Sets: (All)
Aliases: InputObject, MessageText, Text

Required: True
Position: 3
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
General and group bulletins are generally transmitted a few times an hour for a few hours, and typically contain time-sensitive infrmation (such as weather status).  For situations leading up an event, you should use an announcement.

## RELATED LINKS

[Send-APRSBulletin]()
[Send-APRSAnnouncement]()
[Send-APRSMessage]()