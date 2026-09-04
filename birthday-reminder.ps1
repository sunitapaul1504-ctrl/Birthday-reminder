$CsvPath = "$PSScriptRoot\birthdays.csv"

Import-Module BurntToast

$Today = Get-Date -Format "dd-MMM"

$Birthday = Import-Csv $CsvPath |
    Where-Object { $_.date -eq $Today }

if ($Birthday) {

    foreach ($Person in $Birthday) {

        New-BurntToastNotification `
            -Text "🎂 Birthday Today!", $Person.message `
            -Sound Default
    }

}
else {

    New-BurntToastNotification `
        -Text "Birthday Reminder", "No birthday today."
}