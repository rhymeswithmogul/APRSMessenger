# Installing APRSMessenger
You can install this module one of three ways.

## Via PowerShell Gallery
Most people will want to install this from the PowerShell Gallery.  It's quick and easy.

```powershell
Install-Module APRSMessenger
```


## Via a file copy
Copy all of these files to your `$env:PSModulePath`.  For example, to do this on Windows, you might use something like this:

```powershell
Copy-Item -Recurse ~\Downloads\APRSMessenger ~\Documents\PowerShell\Modules
```


## Directly from GitHub
If you have Git installed on your computer, simply create a folder in your `$env:PSModulePath` and pull the tree.

```powershell
Set-Location -Path "~\Documents\PowerShell\Modules"
git clone https://github.com/rhymeswithmogul/APRSMessenger

```