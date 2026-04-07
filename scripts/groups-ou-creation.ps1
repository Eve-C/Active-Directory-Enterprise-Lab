     
#Active Directory Structure Setup

#Load AD module, this gives powershell access to AD commands
Import-Module ActiveDirectory

#define the parent container called Cybersecurity-Programs (OU)
#this is where the Groups OU will be created
#reference the existing Cybersecurity-Programs that was created manually 

$CyberOUPath= "OU=Cybersecurity-Programs ,DC=corp,DC=womenincyber,DC=org"

#note this variable stores the location of the groups OU
$GroupsOUPath= "OU=Groups,$CyberOUPath"

#logging setup
$LabFolder= "C:\Users\user\VirtualBox VMs\Active-Directory"
$LogFile= "$LabFolder\AD_Structure_Setup.log"

#ensure the labfolder exists
if(-not (Test-Path $LabFolder)) {
  New-Item -ItemType Directory -Path $LabFolder
}

#define logging function
function Write-Log{
  param ([string]$Message)
  Write-Host $Message
  Add-Content -Path $Logfile  -Value "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - $Message"
}

#now create the Groups OU if doesnt exist 
try{
  if(-not(Get-ADOrganizationalUnit -Filter "DistinguishedName -eq '$GroupsOUPath'")){
    New-ADOrganizationalUnit -Name "Groups" -Path $CyberOUPath
    Write-Log "Groups OU created successfully"
  }else{
    Write-Log("Groups OU already exists")
  }
}catch{
  Write-Log "ERROR: failed to create or check Groups OU. $_"
}
     
# now define different security groups for each individual cybersecurity tracks
#GRC/Red-Team/Blue-Team Track

$TrackGroups = @( "GG-Blue-Team", "GG-Red-Team", "GG-GRC")

#loop through each track roup and create if missing 
foreach($group in $TrackGroups){
  try{
     if(-not(Get-ADGroup -Filter "Name -eq '$group'")){
       New-ADGroup -Name $group`
                   -GroupScope Global`
                   -GroupCategory Security`
                   -Path $GroupsOUPath
       Write-Log "$group created successfully"
    }else{
       Write-Log "Group already exists"
    }
}catch{
   Write-Log "ERROR: failed to create $group. $_"
}
}

#complete AD structure automation 
Write-Log " Active-Directory Structure Setup script completed successfully"
