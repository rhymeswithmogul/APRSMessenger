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

[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', 'ExampleAnnouncement',	Justification='Variable is used in another scope.')]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', 'ExampleBulletin',		Justification='Variable is used in another scope.')]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', 'ExampleGroupBulletin',	Justification='Variable is used in another scope.')]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', 'ExampleEmail',			Justification='Variable is used in another scope.')]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', 'ModuleHelpFile',		Justification='Variable is used in another scope.')]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', 'psm1File',				Justification='Variable is used in another scope.')]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', 'ThisIsATest',			Justification='Variable is used in another scope.')]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', 'WeatherReport',			Justification='Variable is used in another scope.')]
Param()

BeforeAll {
	Import-Module -Name (Join-Path -Path '.' -ChildPath 'APRSMessenger.psd1')

	$ThisIsATest          = 'This is a test.'
	$ExampleAnnouncement  = 'My St Helen digi will be QRT this weekend'
	$ExampleBulletin      = 'Snow expected in Tampa RSN'
	$ExampleGroupBulletin = 'Stand by your snowplows'
	$ExampleEmail         = 'msproul@ap.org Test email'
	$WeatherReport        = 'This is a weather report.'
}

Context 'Validate the module files' {
	BeforeAll {
		$psm1File       = Join-Path -Path 'src'   -ChildPath 'APRSMessenger.psm1'
		$ModuleHelpFile = Join-Path -Path 'en-US' -ChildPath 'APRSMessenger-help.xml'
	}
	It 'has a module manifest' {
		'APRSMessenger.psd1' | Should -Exist
	}
	It 'has a root module' {
		$psm1File | Should -Exist
	}
	It 'has a valid root module' {
		$code = Get-Content -Path $psm1File -ErrorAction Stop
		$errors = $null
		$null = [Management.Automation.PSParser]::Tokenize($code, [ref]$errors)
		$errors.Count | Should -Be 0
	}
	It 'has a conceptual help file' {
		Join-Path -Path 'en-US' -ChildPath 'about_APRSMessenger.help.txt' | Should -Exist
	}
	It 'has a module help file' {
		$ModuleHelpFile | Should -Exist
	}
	It 'has a valid module help file' {
		$code = [Xml](Get-Content -Path $ModuleHelpFile -ErrorAction Stop)
		$code.Count | Should -Be 1
	}
}

Describe 'Get-APRSISPasscode' {
	It "Returns <expected> for callsign <name>" -TestCases @(
		@{Name='N0CALL';	Expected=13023},
		@{Name='N0CALL-13';	Expected=13023},
		@{Name='W1APR';		Expected=14211},
		@{Name='W1APR-3';	Expected=14211}
	) {
		Get-APRSISPasscode $name | Should -Be $expected
	}
}

Describe 'Send-APRSMessage' {
	It "Generates a valid message from N0CALL to FR1END with content `"$ThisIsATest`"" {
		Send-APRSMessage -From 'N0CALL' -To 'FR1END' -Message $ThisIsATest `
			| Should -Be "N0CALL>FR1END,TCPIP*::FR1END   :$ThisIsATest"
	}
	It 'Generates the first example message from page 71 of the APRS 1.01 specification document.' {
		Send-APRSMessage -From 'N0CALL' -To 'WU2Z' -Message 'Testing' `
			| Should -Be 'N0CALL>WU2Z,TCPIP*::WU2Z     :Testing'
	}
	It 'Generates the second example message from page 71 of the APRS 1.01 specification document.' {
		Send-APRSMessage -From 'N0CALL' -To 'WU2Z' -Message 'Testing' -Acknowledge 003 `
			| Should -Be 'N0CALL>WU2Z,TCPIP*::WU2Z     :Testing{003'
	}
	It 'Generates the third example message from page 71 of the APRS 1.01 specification document.' {
		Send-APRSMessage -From 'N0CALL' -To 'EMAIL' -Message $ExampleEmail `
			| Should -Be "N0CALL>EMAIL,TCPIP*::EMAIL    :$ExampleEmail"
	}
}

Describe 'Send-APRSAnnouncement' {
	It "Generates a valid announcement from N0CALL with identifier T saying `"$ThisIsATest`"." {
		Send-APRSAnnouncement -From 'N0CALL' -AnnouncementID 'T' -Message $ThisIsATest `
			| Should -Be "N0CALL>BLNT,TCPIP*::BLNT     :$ThisIsATest"
	}
	It "Generates a valid announcement from N0CALL-13 with identifier W saying `"$WeatherReport`"" {
		Send-APRSAnnouncement -From 'N0CALL-13' -AnnouncementID 'W' -Message $WeatherReport `
			| Should -Be "N0CALL-13>BLNW,TCPIP*::BLNW     :$WeatherReport"
	}
	It 'Generates the example announcement from page 73 of the APRS 1.01 specification.' {
		Send-APRSAnnouncement -From 'N0CALL' -AnnouncementID 'Q' -Message $ExampleAnnouncement `
			| Should -Be "N0CALL>BLNQ,TCPIP*::BLNQ     :$ExampleAnnouncement"
	}
}

Describe 'Send-APRSBulletin' {
	It "Generates a valid bulletin from N0CALL with identifier 1 saying `"$ThisIsATest`"." {
		Send-APRSBulletin -From 'N0CALL' -BulletinID '1' -Message $ThisIsATest `
			| Should -Be "N0CALL>BLN1,TCPIP*::BLN1     :$ThisIsATest"
	}
	It 'Generates the example general bulletin from page 73 of the APRS 1.01 specification document.' {
		Send-APRSBulletin -From 'N0CALL' -BulletinID 3 -Message $ExampleBulletin `
			| Should -Be "N0CALL>BLN3,TCPIP*::BLN3     :$ExampleBulletin"
	}
}

Describe 'Send-APRSGroupBulletin' {
	It "Generates a valid bulletin from N0CALL with identifier 1 to group PESTR saying `"$ThisIsATest`"." {
		Send-APRSGroupBulletin -From 'N0CALL' -BulletinID '1' -GroupName 'PESTR' -Message $ThisIsATest `
			| Should -Be "N0CALL>BLN1,TCPIP*::BLN1PESTR:$ThisIsATest"
	}
	It 'Generates the example group bulletin from page 74 of the APRS 1.01 specification.' {
		Send-APRSGroupBulletin -From 'N0CALL' -BulletinID '4' -GroupName 'WX' -Message $ExampleGroupBulletin `
			| Should -Be "N0CALL>BLN4,TCPIP*::BLN4WX   :$ExampleGroupBulletin"
	}
}

AfterAll {
	Remove-Module -Name 'APRSMessenger'
}
