# Definieren der Server und Printserver
$servers = @(
    "Server1", "Server2"
)
$printServers = @("DruckerServer1", "DruckerServer2")
$eventID = 4098
$cutOffDate = Get-Date "2024-02-29"

# Initialisieren der Hashtable für die gesammelten Events
$eventsByGPO = @{}

# Durchlaufen der Serverliste, um EventLogs zu sammeln
foreach ($server in $servers) {
    $eventLogs = Get-WinEvent -ComputerName $server -FilterHashtable @{LogName='Application'; ID=$eventID} -ErrorAction Stop |
                 Where-Object { $_.TimeCreated -gt $cutOffDate -and $_.Message -match "The user '(.+?)' preference item in the '(.+?) {(.+?)}' Group Policy Object did not apply because it failed with error code '.+? (.+?)\.' This error was suppressed." -and $matches[4] -eq "No printers were found" }
                 
    foreach ($eventLog in $eventLogs) {
        $printerName = $matches[1]
        $gpoName = $matches[2]

        # Prüfen, ob dieser Drucker schon registriert ist
        if (-not $eventsByGPO.ContainsKey($printerName)) {
            $eventsByGPO[$printerName] = $gpoName
        }
    }
}

# Überprüfung der Drucker auf allen Printservern mittels effizienterer WMI-Abfragen
$printerStatus = @()
foreach ($printServer in $printServers) {
    $printersOnServer = Get-WmiObject Win32_Printer -ComputerName $printServer -ErrorAction SilentlyContinue | Where-Object { $eventsByGPO.ContainsKey($_.Name) }
    foreach ($printer in $printersOnServer) {
        $gpoName = $eventsByGPO[$printer.Name]
        $printerStatus += [PSCustomObject]@{
            GPOName = $gpoName
            PrinterName = $printer.Name
            Server = $printServer
            Status = "Found"
        }
    }
}

# Ergänzen der Drucker, die nicht gefunden wurden
$eventsByGPO.Keys | ForEach-Object {
    $printerName = $_
    if (-not ($printerStatus.PrinterName -contains $printerName)) {
        $printerStatus += [PSCustomObject]@{
            GPOName = $eventsByGPO[$printerName]
            PrinterName = $printerName
            Server = "Nicht gefunden"
            Status = "Not Found"
        }
    }
}

# Sortierte und gruppierte Ausgabe
$printerStatus | Sort-Object GPOName, PrinterName | Format-Table -AutoSize
