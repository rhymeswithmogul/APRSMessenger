# Change Log for APRSMessenger

## Version 1.1.0 (April 20, 2023)
 -  NEW: All message types now support including position reports.  Use the `-Latitude` and `-Longitude` parameters to specify your location.

## Version 1.0.4 (March 29, 2023)
 -  FIXED: Corrected an issue where PowerShell Gallery would refuse to install the module on Windows platforms that require signed code per execution policy.  (This is also where Version 1.0.3 went.)  Thank you to `weq 🐳` from the PowerShell IRC channel/Discord server for helping me troubleshoot this.
 -  FIXED: Improved Markdown formatting of documentation files.
 -  ENHANCEMENT: Pester now tests the module itself.

## Version 1.0.2 (March 21, 2023)
 -  FIXED: a bug where all packets would be sent to APRS-IS.  The parameter set name was not honored when control passed into `Send-APRSThing`.
 -  FIXED: a bug where message acknowledgements would not be included.
 -  FIXED: a bug where group bulletins would not be sent correctly.
 -  NEW: Added Pester tests.
 -  Updated module manifest data.
 -  Created release generation script.  This is intended to be run by me, when signing a version for the PowerShell Gallery, and is only saved in the Git tree so I don't lose it.

## Version 1.0.1 (March 20, 2023)
 -  FIX: Fixed a bug where APRS packets would be printed to the screen instead of sent to the network.
 -  FIX: Added change log and news to module manifest.
 -  ENHANCEMENT: More debugging output.

## Version 1.0.0 (March 19, 2023)
 -  Initial release.