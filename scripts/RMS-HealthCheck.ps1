# Define config
$timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$logDir = "$PSScriptRoot\logs"
$logFile = "$logDir\RMS-HealthCheck-$timestamp.log"

# Create log directory
if (-not (Test-Path $logDir)) { New-Item -Path $logDir -ItemType Directory }

# Logging helper
function Log {
    param([string]$msg)
    $logEntry = "$(Get-Date -Format "yyyy-MM-dd HH:mm:ss") | $msg"
    $logEntry | Out-File -FilePath $logFile -Append
    Write-Host $logEntry
}

# Step 1: Discover SCP
Log "🔍 Checking AD RMS SCP..."
try {
    $scp = Get-ADObject -Filter 'ObjectClass -eq "serviceConnectionPoint" -and Name -like "*MSRM*"' `
        -SearchBase "CN=Configuration,DC=$(($env:USERDNSDOMAIN -replace '\.', ',DC='))" `
        -Properties serviceBindingInformation | Select-Object -First 1

    if (!$scp) {
        Log "❌ No RMS SCP found."
        throw "RMS SCP not registered."
    }

    $rmsUrl = $scp.serviceBindingInformation
    Log "✅ RMS SCP found: $rmsUrl"
} catch {
    Log "❌ Error locating SCP: $_"
    exit 1
}

# Step 2: Check endpoints
function Test-RmsUrl {
    param ([string]$url)
    try {
        $resp = Invoke-WebRequest -Uri $url -UseBasicParsing -TimeoutSec 10
        Log "✅ $url reachable. Status: $($resp.StatusCode)"
    } catch {
        Log "⚠️ Cannot reach $url: $($_.Exception.Message)"
        $script:hasError = $true
    }
}

Log "🌐 Checking endpoint availability..."
Test-RmsUrl "$rmsUrl/_wmcs/certification"
Test-RmsUrl "$rmsUrl/_wmcs/licensing"

# Step 3: SSL Certificate check
Log "🔐 Checking SSL cert for: $rmsUrl"
try {
    $hostName = $rmsUrl.Replace('https://', '')
    $tcp = New-Object Net.Sockets.TcpClient($hostName, 443)
    $ssl = New-Object Net.Security.SslStream($tcp.GetStream(), $false, ({ $true }))
    $ssl.AuthenticateAsClient($hostName)
    $cert = $ssl.RemoteCertificate

    Log "✅ Cert Subject: $($cert.Subject)"
    Log "   Issuer: $($cert.Issuer)"
    Log "   Expires: $($cert.GetExpirationDateString())"
} catch {
    Log "❌ SSL certificate check failed: $_"
    $script:hasError = $true
}
finally {
    if ($tcp) { $tcp.Close() }
}

# Step 4: Optional email alert
if ($script:hasError) {
    $subject = "❌ AD RMS Health Check FAILED - $env:COMPUTERNAME"
    $body = Get-Content $logFile | Out-String

    # Update these with your SMTP values
    $smtpServer = "smtp.office365.com"
    $smtpPort = 587
    $from = "rms-monitor@yourdomain.com"
    $to = "admin@yourdomain.com"
    $username = "rms-monitor@yourdomain.com"
    $password = "YOUR_SECURE_APP_PASSWORD"  # Ideally, store this securely

    try {
        Send-MailMessage -From $from -To $to -Subject $subject -Body $body `
            -SmtpServer $smtpServer -Port $smtpPort -UseSsl `
            -Credential (New-Object System.Management.Automation.PSCredential($username,(ConvertTo-SecureString $password -
