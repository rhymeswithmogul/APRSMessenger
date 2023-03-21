BeforeAll {
	Import-Module -Name (Join-Path -Path '.' -ChildPath 'APRSMessenger.psd1')
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
	It 'Generates a valid message from N0CALL to FR1END with content "Hello World!"' {
		Send-APRSMessage -From 'N0CALL' -To 'FR1END' -Message 'Hello, World!' `
			| Should -Be 'N0CALL>FR1END,TCPIP*::FR1END   :Hello, World!'
	}
}

Describe 'Send-APRSAnnouncement' {
	It 'Generates a valid announcement from N0CALL with identifier T saying "This is a test."' {
		Send-APRSAnnouncement -From 'N0CALL' -AnnouncementID 'T' -Message 'This is a test.' `
			| Should -Be 'N0CALL>BLNT,TCPIP*::BLNT     :This is a test.'
	}
}

Describe 'Send-APRSBulletin' {
	It 'Generates a valid bulletin from N0CALL with identifier 1 saying "This is a test."' {
		Send-APRSBulletin -From 'N0CALL' -BulletinID '1' -Message 'This is a test.' `
			| Should -Be 'N0CALL>BLN1,TCPIP*::BLN1     :This is a test.'
	}
}

Describe 'Send-APRSGroupBulletin' {
	It 'Generates a valid bulletin from N0CALL with identifier 1 to group PESTR saying "This is a test."' {
		Send-APRSGroupBulletin -From 'N0CALL' -BulletinID '1' -Message 'This is a test.' `
			| Should -Be 'N0CALL>BLN1,TCPIP*::BLN1PESTR:This is a test.'
	}
}

AfterAll {
	Remove-Module -Name APRSMessenger
}