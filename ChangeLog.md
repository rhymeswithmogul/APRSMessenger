# Change Log for APRSMessenger

## Version 1.0.2 (March 21, 2023)
 - Fixed a bug where all packets would be sent to APRS-IS.  The parameter set name was not honored when control passed into `Send-APRSThing`.
 - Fixed a bug where group bulletins would not be sent correctly.
 - Added Pester tests.
 - Updated module manifest data.
 - Created release generation script.  This is intended to be run by me, when signing a version for the PowerShell Gallery, and is only saved in the Git tree so I don't lose it.

## Version 1.0.1 (March 20, 2023)
 - FIX: Fixed a bug where APRS packets would be printed to the screen instead of sent to the network.
 - FIX: Added change log and news to module manifest.
 - ENHANCEMENT: More debugging output.

## Version 1.0.0 (March 19, 2023)
 - Initial release.