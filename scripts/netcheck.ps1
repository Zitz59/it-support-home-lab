<#
.SYNOPSIS
  Quick first-line network diagnostics for a Windows client.

.DESCRIPTION
  Runs the standard isolation sequence in one shot:
    1. Adapter / IP configuration (flags APIPA 169.254.x.x addresses)
    2. Default gateway reachability
    3. External IP reachability (connectivity vs DNS split)
    4. Name resolution test
  Output is designed to be pasted straight into a ticket.

.EXAMPLE
  .\netcheck.ps1
#>

$ErrorActionPreference = "SilentlyContinue"

Write-Host "=== NETCHECK $(Get-Date -Format 'yyyy-MM-dd HH:mm') ===" -ForegroundColor Cyan

# 1. IP configuration
Write-Host "`n[1] Adapter configuration" -ForegroundColor Yellow
$adapters = Get-NetIPConfiguration | Where-Object { $_.NetAdapter.Status -eq "Up" }
foreach ($a in $adapters) {
    $ip = $a.IPv4Address.IPAddress
    Write-Host ("  {0}: IP={1} GW={2} DNS={3}" -f $a.InterfaceAlias, $ip, $a.IPv4DefaultGateway.NextHop, ($a.DNSServer.ServerAddresses -join ", "))
    if ($ip -like "169.254.*") {
        Write-Host "  [!] APIPA address detected - DHCP lease was not obtained" -ForegroundColor Red
    }
}

# 2. Gateway reachability
Write-Host "`n[2] Default gateway" -ForegroundColor Yellow
$gw = ($adapters | Select-Object -First 1).IPv4DefaultGateway.NextHop
if ($gw) {
    $ok = Test-Connection $gw -Count 2 -Quiet
    Write-Host ("  Ping {0}: {1}" -f $gw, $(if ($ok) { "OK" } else { "FAILED" })) -ForegroundColor $(if ($ok) { "Green" } else { "Red" })
} else {
    Write-Host "  [!] No default gateway configured" -ForegroundColor Red
}

# 3. External connectivity by IP (bypasses DNS)
Write-Host "`n[3] External connectivity (8.8.8.8)" -ForegroundColor Yellow
$ok = Test-Connection 8.8.8.8 -Count 2 -Quiet
Write-Host ("  Ping 8.8.8.8: {0}" -f $(if ($ok) { "OK" } else { "FAILED" })) -ForegroundColor $(if ($ok) { "Green" } else { "Red" })

# 4. Name resolution
Write-Host "`n[4] DNS resolution (google.com)" -ForegroundColor Yellow
$dns = Resolve-DnsName google.com -ErrorAction SilentlyContinue
if ($dns) {
    Write-Host ("  Resolved: {0}" -f ($dns | Where-Object Type -eq "A" | Select-Object -First 1 -ExpandProperty IPAddress)) -ForegroundColor Green
} else {
    Write-Host "  Resolution FAILED - connectivity OK + DNS failing points to resolver config" -ForegroundColor Red
}

Write-Host "`n=== END ===" -ForegroundColor Cyan
