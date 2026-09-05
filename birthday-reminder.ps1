```powershell
$ErrorActionPreference = "Stop"

# ==============================
# NTFY SETTINGS
# ==============================
$NtfyTopic = "tpGme3XOxG2iZ6Dd"
$NtfyUrl = "https://ntfy.sh/$NtfyTopic"

# ==============================
# CSV FILE
# ==============================
$CsvPath = Join-Path $PSScriptRoot "Birthday.csv"

if (-not (Test-Path $CsvPath)) {
    Write-Host "ERROR: CSV file not found:"
    Write-Host $CsvPath
    exit 1
}

$Birthdays = Import-Csv $CsvPath

# ==============================
# TODAY & TOMORROW
# ==============================
$Today = Get-Date
$Tomorrow = $Today.AddDays(1)

$TodayKey = $Today.ToString("dd-MMM")
$TomorrowKey = $Tomorrow.ToString("dd-MMM")

Write-Host ""
Write-Host "======================================"
Write-Host "       BIRTHDAY REMINDER"
Write-Host "======================================"
Write-Host "Today    : $TodayKey"
Write-Host "Tomorrow : $TomorrowKey"
Write-Host "======================================"

# ==============================
# FIND TODAY'S BIRTHDAYS
# ==============================
$TodayBirthdays = @()

foreach ($Person in $Birthdays) {

    if (-not [string]::IsNullOrWhiteSpace($Person.date)) {

        $BirthdayKey = $Person.date.Trim()

        if ($BirthdayKey -eq $TodayKey) {

            if (-not [string]::IsNullOrWhiteSpace($Person.name)) {
                $TodayBirthdays += $Person.name
            }
        }
    }
}

# ==============================
# FIND TOMORROW'S BIRTHDAYS
# ==============================
$TomorrowBirthdays = @()

foreach ($Person in $Birthdays) {

    if (-not [string]::IsNullOrWhiteSpace($Person.date)) {

        $BirthdayKey = $Person.date.Trim()

        if ($BirthdayKey -eq $TomorrowKey) {

            if (-not [string]::IsNullOrWhiteSpace($Person.name)) {
                $TomorrowBirthdays += $Person.name
            }
        }
    }
}

# ==============================
# DISPLAY TODAY
# ==============================

Write-Host ""
Write-Host "TODAY'S BIRTHDAY:"

if ($TodayBirthdays.Count -gt 0) {

    foreach ($Name in $TodayBirthdays) {
        Write-Host "🎂 $Name"
    }

}
else {
    Write-Host "No birthday today."
}

# ==============================
# DISPLAY TOMORROW
# ==============================

Write-Host ""
Write-Host "TOMORROW'S BIRTHDAY:"

if ($TomorrowBirthdays.Count -gt 0) {

    foreach ($Name in $TomorrowBirthdays) {
        Write-Host "🎁 $Name"
    }

}
else {
    Write-Host "No birthday tomorrow."
}

# ==============================
# CREATE NTFY MESSAGE
# ==============================

$Message = "BIRTHDAY REMINDER`n`n"

$Message += "TODAY - $TodayKey`n"

if ($TodayBirthdays.Count -gt 0) {

    foreach ($Name in $TodayBirthdays) {
        $Message += "🎂 $Name's Birthday Today!`n"
    }

}
else {
    $Message += "No birthday today.`n"
}

$Message += "`nTOMORROW - $TomorrowKey`n"

if ($TomorrowBirthdays.Count -gt 0) {

    foreach ($Name in $TomorrowBirthdays) {
        $Message += "🎁 $Name's Birthday Tomorrow!`n"
    }

}
else {
    $Message += "No birthday tomorrow.`n"
}

# ==============================
# SEND NTFY NOTIFICATION
# ==============================

Write-Host ""
Write-Host "Sending notification to ntfy..."

Invoke-RestMethod `
    -Uri $NtfyUrl `
    -Method Post `
    -Headers @{
        Title = "Birthday Reminder"
    } `
    -Body $Message

Write-Host ""
Write-Host "======================================"
Write-Host "ntfy notification sent successfully."
Write-Host "======================================"
```
