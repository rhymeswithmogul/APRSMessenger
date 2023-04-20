# News for APRSMessenger

## Version 1.1.0 (April 20, 2023)
We've added the ability to include position reports in your messages, bulletins, and announcements.  Simply use the `-Latitude` and `-Longitude` parameters to include them.  Then, they will show up on sites like [APRS.fi](https://APRS.fi).

## Version 1.0.4 (March 29, 2023)
In this version, we've signed the PowerShell Gallery version of this code so that it can load on platforms that require code signing in the execution policy.  Some Pester tests were also added to ensure the module is well-formed.

## Version 1.0.2 (March 21, 2023)
In this version, we've fixed bugs related to group bulletins not being received correctly, message acknowledgements not working, and printing packets to the output stream.

We've also included Pester testing to ensure that this app works as intended.

Finally, this version contains a catalog file to verify its authenticity, and to help it run when execution policies require signed code. 

## Version 1.0.1 (March 20, 2023)
Fixed a very embarrassing bug where APRS messages wouldn't be sent to the APRS-IS network.  Oops.

## Version 1.0.0 (March 19, 2023)
Initial release.