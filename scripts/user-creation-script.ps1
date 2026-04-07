#Load Active Directory cmdlets
Import-Module ActiveDirectory
#create a log file
$LabFolder = "Z:\"
$LogFile= "$LabFolder\User-Creation.log"
#make sure the lab folder exists
if(-not(Test-Path $LabFolder)){
    New-Item -ItemType Directory -Path $LabFolder
}

#write messages to both the console and the log file
function Write-Log{
    param([string]$Message)
    #output to console 
    Write-Host $Message
    #append to log file with timestamp
    Add-Content -Path $LogFile -Value "$(Get-Date  -Format 'yyyy-MM-dd HH:mm:ss') - $Message"
}
#import/read the csv file

$CSVPath = "$LabFolder\corp_students_100.csv"

try{
    $Users =Import-Csv $CSVPath -Delimiter ';'
    Write-Log "CSV file imported successfully :$CSVPath"
}catch{
    Write-Log "ERROR: Could not import CSV file. $($_.Exception.Message)"
    exit
}

#loop through each user in the csv file
#extract user information
foreach ($user in $Users){
    $Fname = $user.FirstName
    $Lname = $user.LastName
    $SamAcc = $user.Username
    $UPN = $user.UPN
    $OU = $user.OU
    $CohortGroup = $user.Group
    $sID = $user.StudentID
    #$GroupTrack = $user.ProgramTrack

    # clean excel dat
    $GroupTrack   = $user.ProgramTrack -replace 'GG-RedTeam', 'GG-Red-Team' `
                                       -replace 'GG-BlueTeam', 'GG-Blue-Team'


#Place each user in the correct cohort OU (2026/2027)

$UserOUPath = "OU=$OU,OU=Students,OU=CyberWomen-Users,DC=corp,DC=womenincyber,DC=org"

#check if the cohort group exists

if(-not(Get-ADOrganizationalUnit -Filter "Name -eq '$OU'")){
    try{
    #New-ADOrganizationalUnit`
    $OUParameters= @{
        Name = $OU
        Path = "OU=Students,OU=CyberWomen-Users,DC=corp,DC=womenincyber,DC=org"
    }

    New-ADOrganizationalUnit @OUParameters -ErrorAction Stop
    Write-Log "Cohort OU '$OU' created successfully"
    }catch{
        Write-Log "ERROR: Failed to create Cohort OU '$OU'. $($_.Exception.Message)"
        continue
    }
}

#Define user temporary passwords
#password to be changed at first logon
#ConvertTo-SecureString converts plain text password into a secure AD format
$Password= ConvertTo-SecureString "Temp@ss2026" -AsPlainText -Force

#Create user account only the user does not exist

try{
    if(-not(Get-ADUser -Filter "SamAccountName -eq '$SamAcc'")){

#create a splat hashtable
#create a new account
            $UserParameters = @{
                Name = "$Fname $Lname ($sID)"
                GivenName = $Fname
                Surname = $Lname
                SamAccountName = $SamAcc
                UserPrincipalName = $UPN
                Path = $UserOUPath
                AccountPassword = $Password
                Enabled = $true
                ChangePasswordAtLogon =$true
                Description = "StudentID: $sID"
                ErrorAction = "stop" #ensure the catch block works
            }
        New-ADUser @UserParameters

        Write-Log "User '$SamAcc' created successfully in the '$OU'"
    }else{
        Write-Log "User '$SamAcc' already exists"
    }
}catch{
    Write-Log "ERROR: Failed to create user '$SamAcc'. $($_.Exception.Message)"
    continue
}

# 1. Check if the variable is NOT empty first
if ($CohortGroup) {
    # 2. Only then ask AD if the group exists
    if (Get-ADGroup -Filter "Name -eq '$CohortGroup'") {
        try {
            Add-ADGroupMember -Identity $CohortGroup -Members $SamAcc -ErrorAction Stop
            Write-Log "User '$SamAcc' added successfully to '$CohortGroup'"
        }
        catch {
            Write-Log "ERROR: Failed to add user '$SamAcc' to Group '$CohortGroup'. $($_.Exception.Message)"
        }
    }
    else {
        Write-Log "ERROR: Cohort Group '$CohortGroup' not found in AD"
    }
}
else {
    Write-Log "SKIP: No Cohort Group data found in CSV for user '$SamAcc'"
}




#add usesr into  cybersecurity track groups
if(Get-ADGroup -Filter "Name -eq '$GroupTrack'") {
    try{
        Add-ADGroupMember -Identity $GroupTrack -Members $SamAcc
        Write-Log "User '$SamAcc' added successfully to '$GroupTrack'"
    }catch{
        Write-Log "ERROR: User '$SamAcc' was not added to '$GroupTrack'. $($_.Exception.Message)"
    }
    }else{
    Write-Log "ERROR: Program Group '$GroupTrack' not found"
   }
    

}
Write-Log "User Creation & Group Assignment Script completed Successfully"$
