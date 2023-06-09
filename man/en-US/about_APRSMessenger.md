# APRSMessenger
## about_APRSMessenger

# SHORT DESCRIPTION
Sends messages via APRS.

# LONG DESCRIPTION
The **APRSMessenger** module can send messages, bulletins, group bulletins, and announcements to APRS users, by using the APRS-IS network.

## APRS Limitations
Any type of APRS message is limited to 67 characters in length.  If you attempt to use anything longer, this cmdlet will fail.  In addition, no type of message may include the pipe character (`|`) or the tilde (`~`), while messages also cannot include an opening curly brace (`{`).  This is due to limitations of [the APRS specification](http://www.aprs.org/doc/APRS101.PDF) itself.

## Connecting to APRS-IS
All of the `Send-*` cmdlets require an APRS-IS server name to be specified.  This is one of the [APRS Tier 2 Network](https://www.aprs2.net) servers.  The default server is `rotate.aprs2.net`, which is any one of their servers;  however, best practice is to use the server that's closest to you.  Select one from the following list:

| Server name      | Location                            |
| ---------------- | ----------------------------------- |
| rotate.aprs2.net | Anywhere                            |
| noam.aprs2.net   | North America                       |
| soam.aprs2.net   | South America                       |
| euro.aprs2.net   | Europe and Africa                   |
| asia.aprs2.net   | Asia                                |
| aunz.aprs2.net   | Australia, New Zealand, and Oceania |

Port 14580 is used by default.  This can be overriden with the `-Port` parameter.

This module handles authentication internally, though the cmdlet `Get-APRSISPasscode` is provided for your convenience.

If you do not specify a server or port, the APRS packet will be printed to the screen.  This might be useful if you want to transmit it via some other means, such as through a locally-attached radio (TNC) or an app like Direwolf.

The following examples do not include a `-Server` or `-Port` parameter for clarity.  Pretend that they're there.  If you'd like to do this in practice, you can use the `$PSDefaultParameterValues` automatic variable.
```powershell
$PSDefaultParameterValues.Add('Send-APRSAnnouncement:Server', 'euro.aprs2.net')
$PSDefaultParameterValues.Add('Send-APRSBulletin:Server', 'euro.aprs2.net')
$PSDefaultParameterValues.Add('Send-APRSGroupBulletin:Server', 'euro.aprs2.net')
$PSDefaultParameterValues.Add('Send-APRSMessage:Server', 'euro.aprs2.net')
```

However, note that doing so will send *all* cmdlet output to APRS-IS.  If this bothers you, use `-WhatIf`.

## Message Types
The types of messages you can send are as follows:

### Messages
Short messages can be sent to other APRS users by using the `Send-APRSMessage` cmdlet.  For example, if your friend's call sign were FR1END, and you were in North America, you would use the following cmdlet:

```powershell
PS> Send-APRSMessage -From N0CALL -To FR1END -Message "Hey, how's it going?"
```
#### Acknowledgements and Rejections
Optionally, APRS messages may request acknowledgement from the recipient.  While **APRSMessenger** cannot receive acknowledgements (or any data, really), it can ask the recipient to respond.  This assumes that the recipient's radio supports and is configured to send acknowledgements or rejection notices, and it assumes that your own radio (not PowerShell) can listen for them.

You will need to make up a message identifier for this to work.  It can be any five characters supported by APRS.  You should stick to numbers and letters.

```powershell
PS> Send-APRSMessage -From N0CALL -To FR1END -Message "Are you there? It's important." -Acknowledgement 420
```

Check your radio, and if all works as intended, you will receive a message `ack420` if the message was acknowledged, or `rej420` if not.  For more information, consult the APRS specification.


### Announcements
APRS announcements are messages sent to any radio that can pick them up.  They are tagged with an identifier that receiving radios may (or may not) use to filter them.  To send an APRS announcement to anyone who might be listening for one:
```powershell
PS> Send-APRSAnnouncement -From GR8CLUB -AnnouncementID 'R' -Message "We will be providing communications for the road race on Sunday."
```

### General Bulletins
General bulletins are generally transmitted a few times an hour for a few hours, and typically contain time sensitive information (such as weather status).  To send an APRS bulletin to anyone who might be listening for one:
```powershell
PS> Send-APRSBulletin -From GR8CLUB -BulletinID 2 -Message "Road race volunteers, listen to bulletins with group name RACE."
```

Or,
```powershell
PS> Send-APRSBulletin -From GR8CLUB-13 -BulletinID 1 -Message "Rain in the forecast later. Should not affect road race."
```

### Group Bulletins
Group bulletins are targered toward a specific group.  Receiving radios may choose to filter some or all.  To send an APRS bulletin to a certain group who might be listening for one:
```powershell
PS> Send-APRSGroupBulletin -From GR8CLUB -BulletinID 2 -GroupName "RACE" -Message "Road race traffic net on 146.55 MHz simplex. W1DNS handling emcomm."
```
```powershell
PS> Send-APRSGroupBulletin -From GR8CLUB-13 -BulletinID 1 -GroupName "WX" -Message "There will be a SKYWARN net on the repeater tonight at 8:00 PM."
```

### When to Use Announcements or Bulletins
As you've seen, there are multiple ways to broadcast data to multiple APRS users, and differentiating them can be difficult.  In addition, how bulletins and announcements are handled by recipients' radios can never be guaranteed.  In an attempt to clarify things, [the APRS specification](http://www.aprs.org/doc/APRS101.PDF) says this about general bulletins:

> General bulletins are generally transmitted a few times an hour for a few hours, and typically contain time sensitive information (such as weather status).

About announcements:

> Announcements are similar to general bulletins[…].  Announcements are transmitted much less frequently than bulletins (but perhaps for several days), and although possibly timely in nature they are usually not time-critical.
>
> Announcements are typically made for situations leading up to an event, in contrast to bulletins which are typically used within the event.
>
> Users should be alerted on arrival of a new bulletin or announcement.

And, about group bulletins:

> A receiving station can specify a list of bulletin groups of interest. The list is defined internally by the user at the receiving station. If a group is selected from the list, the station will only copy bulletins for that group, plus any general bulletins. If the list is empty, all bulletins are received and generate alerts.

If you're still not sure after reading all that, you should try sending bulletins, group bulletins, or announcements over your local area, and see how your radio and other peoples' radios handle them.


## Position Reports
To include a latitude and longitude with one of your messages, bulletins, announcements, or group announcements, specify the `-Latitude` and `-Longitude` parameters, along with your location in decimal format.

For example, if I went to ARRL headquarters, I might tell my friend something like this:

```powershell
Send-APRSMessage -From 'W1DNS' -To 'FR1END' -Latitude 41.71479 -Longitude -72.72721 -Message "You'll never guess where I am!"
```

If you omit either `-Latitude` or `-Longitude`, that location will be zero.

Due to limitations of the app, you cannot send a position report from exactly 0°,0°.


## Example: Putting It All Together
Here is an example where you could use APRS messaging to manage a club's weather station.  Let's assume that a hypothetical `Get-WeatherStationData` cmdlet returns all of your collected weather data at any given moment, and the following script runs once per minute.  For brevity, I am omitting APRS-IS connection data.

```powershell
#Requires -Module MyCoolWeatherStationModule
$wxdata = (Get-MyCoolWeatherStation).Data
$now    = (Get-Date)

# Send W1DNS an alert if the battery needs to be replaced.
If ($wxdata.BatteryVoltage -lt 11  -and  $now.Minute -eq 0) {
	Send-APRSMessage -From "GR8CLUB-13" -To "W1DNS" `
		-Message "Please replace the battery in the weather station $($wxdata.Name)."
}

# Report if there's been a lightning strike detected.
If ($wxdata.LightningStrikes -gt 0) {
	Send-APRSGroupBulletin -From "GR8CLUB-13" -AnnouncementID "L" `
		-Message "A lightning strike was detected.  Information: $($wxdata.LightningStrikes[0])"
	Clear-RecordedLightningStrikes
}

# Broadcast a weather report at thirty past the hour.
If ($now.Minute -eq 30)
{
	$temp = $wxdata.Temperature
	$cond = $wxdata.Conditions
	$rain = $wxdata.RainfallPastHour
	$wspd = $wxdata.WindSpeed
	$wdir = $wxdata.WindDirection
	Send-APRSGroupBulletin -From "GR8CLUB-13" -AnnouncementID "W" -Message `
		"Weather report: $temp° and $cond, $rain`" rainfall, wind $wspd MPH from $wdir."
}

# At midnight and noon, broadcast announcements for a club's weekly SKYWARN net.
# On Sundays, send out a bulletin announcing tonight's net.
If ($now.Hour % 12 -eq 0  -and  $now.Minute -eq 0) {
	If ($now.DayOfWeek -ne "Sunday") {
		Send-APRSAnnouncement -From "GR8CLUB-13" -AnnouncementID "S" `
			-Message "There will be a SKYWARN net on GR8CLUB's repeater Sunday at 8:00 PM."
	} Else {
		Send-APRSBulletin -From "GR8CLUB-13" -BulletinID 1 `
			-Message "There is a SKYWARN net on GR8CLUB's repeater tonight at 8:00 PM."
	}
}
```
# NOTE
You must be a licensed amateur radio operator ("ham") in order to use this app.  If you would like to get licensed, check out [HamStudy.org](https://hamstudy.org).  They were a huge help for me!  You can use other resources provided by the [American Radio Relay League](https://arrl.org), or your country's amateur radio organization.

Misuse of the APRS Tier 2 Network server may lead to you being rate-limited or banned from using this service.  In that case, you'll need to figure out how to send your packets via <abbr title="Radio Frequency">RF</abbr>.  So, please don't abuse the network and make me regret writing this.

# SEE ALSO
This project was created by Colin Cogle, W1DNS.  However, if reporting APRS weather data is more your thing, check out my other project, [aprs-weather-submit](https://github.com/rhymeswithmogul/aprs-weather-submit).

# KEYWORDS
 -  APRS
 -  APRS-IS
 -  ham radio
 -  amateur radio
 -  emergency communications (emcomm)