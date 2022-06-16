<# 
    rep-part-meta.ps1 gets the partner replication metadata from all domain controllers in the domain.
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

$DomainControllers = Get-ADDomainController -Filter *
# Get the current date and time
$Date = (Get-Date -Format "MM-dd-yyyy").toString()
$FileName = "rep-part-meta_$Date.csv"

if (!(Test-Path .\reports)) {
    mkdir .\reports
}

Get-ADReplicationPartnerMetadata -Target $DomainControllers `
| Export-Csv -Path ".\reports\$FileName" -NoTypeInformation