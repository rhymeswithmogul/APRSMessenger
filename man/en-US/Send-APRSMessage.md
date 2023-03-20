---
external help file: APRSMessenger-help.xml
Module Name: APRSMessenger
online version: https://github.com/rhymeswithmogul/APRSMessenger/blob/main/man/en-US/Send-APRSMessage.md
schema: 2.0.0
---

# Send-APRSMessage

## SYNOPSIS
Sends a message to another user on the APRS network.

## SYNTAX

### ToScreen (Default)
```
Send-APRSMessage [-From] <String> [-To] <String> [-Message] <String> [-Acknowledge <String>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

### APRS-IS
```
Send-APRSMessage [-From] <String> [-To] <String> [-Message] <String> [-Acknowledge <String>] [-Server <String>]
 [-Port <UInt16>] [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
This cmdlet will send a message to another APRS user.  Optionally, when sending via APRS-IS, an acknowledgement can be requested from the recipient.

## EXAMPLES

### Example 1
```powershell
PS C:\> Send-APRSMessage -From Y0URCALL -To FR1END -Message "Hey, how's it going?" -Server noam.aprs2.net
```

Sends an APRS message with the specified text to the holder of the (fictitious) call sign FR1END.

### Example 2: Via the Pipeline
```powershell
PS C:\> $jokes | Get-Random | Send-APRSMessage -From Y0URCALL -To FR1END -Server noam.aprs2.net
```

Sends a random joke from a specified list of jokes to the holder of the (fictitious) call sign FR1END.

### Example 3: Acknowledgements
```powershell
PS C:\> Send-APRSMessage -From Y0URCALL -To FR1END -Message "This is important!" -Acknowledgement 69 -Server noam.aprs2.net
```

Sends a message to the holder of the (fictitious) call sign FR1END, tagging this as message #69.  If the recipient's radio supports this feature, you will receive a reply stating if they acknowledged or rejected it.  Note that this PowerShell module does not listen for replies, so you will need another APRS device (such as a radio) to listen for a response.

## PARAMETERS

### -Acknowledge
If this parameter is specified, the recipient's radio will be asked to confirm or reject the incoming message.  Specify a five-character message identifier.  Your radio should receive a message with the same identifier:  for message E420, you will receive "ackE420" if they received it or "rejE420" if they did not.

While you can request acknowledgements with this cmdlet, you will need additional hardware to receive these responses.  Additionally, the recipient's radio must support acknowledgements.

```yaml
Type: String
Parameter Sets: (All)
Aliases: Acknowledgment, Acknowledgement

Required: False
Position: Named
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
Send this message via APRS-IS without confirming.  This will only happen if your $ConfirmPreference is set to "Low".

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
The message text.  It may be up to 67 characters in length, and can contain any ASCII characters except for pipe ('|'), tilde ('~'), and the opening curly brace ('{').

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

### -To
The recipient's callsign, or any other recipient name recognized by APRS.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
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
Messages are sent to one recipient.  For contacting multiple people at once, consider using a bulletin, group bulletin, or announcement instead.

## RELATED LINKS

[Send-APRSBulletin]()
[Send-APRSGroupBulletin]()
[Send-APRSAnnouncement]()
