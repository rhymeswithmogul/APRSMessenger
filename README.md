![APRSMessenger logo](https://raw.githubusercontent.com/rhymeswithmogul/APRSMessenger/main/icon/APRSMessenger.png)

# APRSMessenger

[![PowerShell Gallery Version](https://img.shields.io/powershellgallery/v/APRSMessenger)
 ![PowerShell Gallery](https://img.shields.io/powershellgallery/p/APRSMessenger)
 ![Download from PowerShell Gallery](https://img.shields.io/powershellgallery/dt/APRSMessenger)
](https://www.powershellgallery.com/packages/APRSMessenger/)
[![License: AGPL v3](https://img.shields.io/badge/License-AGPL_v3-blue.svg)](https://www.gnu.org/licenses/agpl-3.0)

A PowerShell module to send messages, bulletins, and announcements through the APRS-IS network.

## Messaging
You can use this module to create APRS messages.  You will need to specify a server name in order to send to APRS-IS.  By default, the username and password are derived from your callsign, and the default port (TCP 14580) is used.

```powershell
PS> Send-APRSMessage -From N0CALL -To FR1END -Message "Hey, how's it going?" -Server noam.aprs2.net
```

Another example:  to check into the [APRS Thursday net](https://aprsph.net/aprsthursday/), you can do something like this.  Replace `AB12cd` with your location and/or grid square.

```powershell
PS> Send-APRSMessage -From N0CALL -To ANSRVR -Message "CQ HOTG Happy #APRSThursday from AB12cd" -Server rotate.aprs2.net
```

If you do not specify a server or port, the APRS packet will be printed to the screen.  This might be useful if you want to transmit it via some other means, such as through a locally-attached radio.

```powershell
PS> Send-APRSMessage -From N0CALL -To RFL1NK -Message "Hello!"
```
```
N0CALL>RFL1NK,TCPIP*::RFL1NK   :Hello!
```

### Message Acknowledgements
To request a message acknowledgement from the recipient, specify a message identifer with the `-Acknowledge` parameter.

```powershell
PS> Send-APRSMessage -From N0CALL -To FR1END -Message "Let me know if you receive this." -Acknowledgement 69
```
```
N0CALL>FR1END,TCPIP*::FR1END   :Let me know if you receive this.{69
```

Note that APRS, PowerShell, nor this module can acknowledge messages; this must be supported by the receiving hardware (usually a ham radio or something).  That is, this module can only send messages;  you will need some other hardware to listen for the acknowledgement or rejection.


## Announcements
To send an APRS announcement to anyone who might be listening for one:
```powershell
PS> Send-APRSAnnouncement -From GR8CLUB -AnnouncementID 'R' -Message "We will be providing communications for the road race on Sunday."
```

## Bulletins
To send an APRS bulletin to anyone who might be listening for one:
```powershell
PS> Send-APRSBulletin -From GR8CLUB -BulletinID 2 -Message "Road race volunteers, listen to bulletins with group name RACE."
```
```powershell
PS> Send-APRSBulletin -From GR8CLUB-13 -BulletinID 1 -Message "Rain in the forecast later. Should not affect road race."
```

## Group Bulletins
To send an APRS bulletin to a certain group who might be listening for one:
```powershell
PS> Send-APRSGroupBulletin -From GR8CLUB -BulletinID 2 -GroupName "RACE" -Message "Road race traffic net on 146.55 MHz simplex. W1DNS handling emcomm."
```
```powershell
PS> Send-APRSGroupBulletin -From GR8CLUB-13 -BulletinID 1 -GroupName "WX" -Message "There will be a SKYWARN net on the repeater tonight at 8:00 PM."
```

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

***

## Supplemental Reading

### What Is APRS?
You don't know?  From [the official site](http://aprs.org):
> The Automatic Packet Reporting System was designed to support rapid, reliable exchange of information for local, tactical real-time information, events or nets.

and

> APRS is digital communications information channel for Ham radio. As a single national channel[…], it gives the mobile ham a place to monitor for 10 to 30 minutes in any area, at any time to capture what is happening in ham radio in the surrounding area. Announcements, Bulletins, Messages, Alerts, Weather, and of course a map of all this activity including objects, frequencies, satellites, nets, meetings, Hamfests, etc. The APRS network has grown to most countries with strong Amateur Radio populations. 


### Legal Warning
To use this app, you must be a licensed amateur radio operator.  [Getting your license is easy.](https://hamstudy.org/)

Like it says in this app's license: this app is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the [GNU Affero General Public License 3.0](https://www.gnu.org/licenses/agpl-3.0.html) (or any later version0 for more details. As such, you and you alone are solely responsible for using this app. Please do not use this app for evil. Don't make me regret writing this app.

This project is not affiliated with nor endorsed by the APRS Tier 2 Network, the APRS Working Group, aprs.org, the family of Bob Bruninga -- or anyone, for that matter.

73, W1DNS