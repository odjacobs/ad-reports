<# 
    inactive-users.ps1 generates a report of users who have not logged in for 30 days or more.
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

$FileDate = (Get-Date -Format "MM-dd-yyyy").toString()
$FileName = "inactive-users_$FileDate.csv"

if (!(Test-Path .\reports)) {
    Write-Host "Creating reports directory"
    mkdir .\reports
}

$Date = (Get-Date).AddDays(-30).ToString("MM/dd/yyyy")
# Get active directory users who have not logged in since $Date
$Users = Get-ADUser -Filter * -Properties LastLogonDate | Where-Object { $_.LastLogonDate -lt $Date -And $_.Enabled -eq $True }
$Users | Select-Object GivenName,Surname,LastLogonDate,UserPrincipalName | Export-Csv -Path .\reports\$FileName -NoTypeInformation
