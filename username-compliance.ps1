<# 
    noncompliant-usernames.ps1 generates a report of usernames which do not
    match the firstname.lastname format.
    Copyright (C) 2022  odjacobs

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
#>

$Date = (Get-Date -Format "MM-dd-yyyy").toString()
$FileName = "username-compliance_" + $Date + ".csv"
if (!(Test-Path .\reports)) {
    Write-Host "Creating reports directory"
    mkdir .\reports
}

# Domain name may be supplied as a parameter or entered after running the script
if ($args[0]) {
    $DomainName = $args[0]
}
else {
    $DomainName = Read-Host -Prompt "Domain name"
}

$Users = Get-ADUser -Filter * `
| Select-Object GivenName, Surname, SamAccountName, UserPrincipalName, `
@{Name = 'PreferredUPN'; Expression = {
        if ($_.Surname) {
        ($_.GivenName + '.' + $_.Surname + '@' + $DomainName).ToLower()
        }
        else {
        ($_.GivenName + '@' + $DomainName).ToLower()
        }
    }
} `
| Select-Object *, @{Name = 'Compliant'; Expression = {
        $_.UserPrincipalName.ToString() -eq $_.PreferredUPN.ToString()
    }
}

$Users | Export-Csv -Path .\reports\$FileName -NoTypeInformation