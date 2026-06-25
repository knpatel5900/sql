#Requires -Version 5.1
# Test-MSSQLConnectivity.ps1
# Tests TCP, login, and query connectivity for a SQL Server test user

param(
    [string]$Server = "localhost",
    [int]   $Port = 1433,
    [string]$Database = "master",
    [string]$Username = "testuser",
    [string]$Password = "P@ssword1"
)

function Write-Result($label, $ok, $detail = "") {
    $icon = if ($ok) { "[PASS]" } else { "[FAIL]" }
    $color = if ($ok) { "Green" } else { "Red" }
    Write-Host "  $icon $label" -ForegroundColor $color
    if ($detail) { Write-Host "       $detail" -ForegroundColor DarkGray }
}

Write-Host "`n=== MSSQL Connectivity Test ===" -ForegroundColor Cyan
Write-Host "  Server   : $Server,$Port"
Write-Host "  Database : $Database"
Write-Host "  Username : $Username`n"

# ── 1. TCP port reachability ──────────────────────────────────────────────────
Write-Host "[1] TCP port test ($Server`:$Port)"
try {
    $tcp = New-Object System.Net.Sockets.TcpClient
    $tcp.Connect($Server, $Port)
    $tcp.Close()
    Write-Result "Port $Port is open" $true
} 
catch {
    Write-Result "Port $Port unreachable" $false $_.Exception.Message
    Write-Host "  !! Aborting — SQL Server not reachable.`n" -ForegroundColor Yellow
    exit 1
}

# ── 2. SQL login + database open ─────────────────────────────────────────────
Write-Host "`n[2] SQL login test"
$connStr = "Server=$Server,$Port;Database=$Database;User Id=$Username;Password=$Password;Connect Timeout=10;Encrypt=False;"
$conn = New-Object System.Data.SqlClient.SqlConnection($connStr)
try {
    $conn.Open()
    Write-Result "Login succeeded (db=$($conn.Database))" $true
}
catch {
    Write-Result "Login failed" $false $_.Exception.Message
    exit 1
}

# ── 3. Simple query ───────────────────────────────────────────────────────────
Write-Host "`n[3] Query test (SELECT @@VERSION)"
try {
    $cmd = $conn.CreateCommand()
    $cmd.CommandText = "SELECT @@VERSION, SYSTEM_USER, DB_NAME(), GETDATE()"
    $rdr = $cmd.ExecuteReader()
    if ($rdr.Read()) {
        Write-Result "Query returned data" $true
        Write-Host "       SQL Version : $($rdr[0] -replace 's+',' ')" -ForegroundColor DarkGray
        Write-Host "       Logged in as : $($rdr[1])" -ForegroundColor DarkGray
        Write-Host "       Current DB   : $($rdr[2])" -ForegroundColor DarkGray
        Write-Host "       Server time  : $($rdr[3])" -ForegroundColor DarkGray
    }
    $rdr.Close()
}
catch {
    Write-Result "Query failed" $false $_.Exception.Message
}

# ── 4. Permission smoke-test ──────────────────────────────────────────────────
Write-Host "`n[4] Permission check (HAS_PERMS_BY_NAME)"
try {
    $cmd = $conn.CreateCommand()
    $cmd.CommandText = @"
SELECT
  HAS_PERMS_BY_NAME(DB_NAME(), 'DATABASE', 'SELECT') AS can_select,
  HAS_PERMS_BY_NAME(DB_NAME(), 'DATABASE', 'INSERT') AS can_insert,
  HAS_PERMS_BY_NAME(DB_NAME(), 'DATABASE', 'EXECUTE') AS can_exec,
  IS_SRVROLEMEMBER('sysadmin')                         AS is_sysadmin
"@
    $rdr = $cmd.ExecuteReader()
    if ($rdr.Read()) {
        Write-Result "SELECT  : $($rdr['can_select']  -eq 1)" ($rdr['can_select'] -eq 1)
        Write-Result "INSERT  : $($rdr['can_insert']  -eq 1)" ($rdr['can_insert'] -eq 1)
        Write-Result "EXECUTE : $($rdr['can_exec']    -eq 1)" ($rdr['can_exec'] -eq 1)
        Write-Result "sysadmin: $($rdr['is_sysadmin'] -eq 1)" ($rdr['is_sysadmin'] -eq 1)
    }
    $rdr.Close()
}
catch {
    Write-Result "Permission check failed" $false $_.Exception.Message
}
finally {
    $conn.Dispose()
}

Write-Host "`n=== Done ===`n" -ForegroundColor Cyan


## Defaults (localhost:1433, master db, testuser)
#.\Test-MSSQLConnectivity.ps1

# Override any param
#.\Test-MSSQLConnectivity.ps1 -Server "savdevqadb02.cblpfdsm1mbl.us-east-1.rds.amazonaws.com" -Port 1433 -Database "ngage_mvb_dev" -Username "eidmadm_mvb_dev" -Password "skMoV%2BNtK5hHpe%2FOG%2BLI1A=="