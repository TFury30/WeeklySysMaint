# PowerShell Script for Weekly System Maintenance

# --- 1. Advanced Logging System (with log rotation) ---
$logFile = "C:\path\to\maintenance_log.txt"
if ((Get-Item $logFile).Length -gt 50MB) {
    # Archive or delete the old log
    Rename-Item $logFile "$($logFile)_$(Get-Date -Format 'yyyyMMdd_HHmmss').bak"
}

# Function to Log Events
function Log-Event {
    param (
        [string]$message,
        [string]$logfile = "C:\path\to\maintenance_log.txt"
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "$timestamp - $message"
    Add-Content -Path $logfile -Value $logMessage
}

# --- 2. User Notification and Confirmation Prompts ---
function Prompt-Restart {
    $timeToRestart = 60  # 60 seconds
    $confirmation = Read-Host "The system requires a restart in $timeToRestart seconds. Do you want to postpone? (y/n)"
    if ($confirmation -eq 'y') {
        Write-Host "Postponing restart."
    } else {
        Write-Host "Restarting system..."
        Restart-Computer -Force
    }
}

# --- 3. Low Disk Space Check ---
function Check-LowDiskSpace {
    $threshold = 10GB
    $freeSpace = (Get-PSDrive C).Free
    if ($freeSpace -lt $threshold) {
        Write-Host "Warning: Low disk space! Only $($freeSpace/1GB) GB remaining."
        Log-Event -message "Low disk space detected: $($freeSpace/1GB) GB remaining."
    }
}

# --- 4. Incremental Backup --- 
# (For simplicity, still copying all files, consider using specialized tools for real incremental backups)
function Backup-Files {
    Write-Host "Backing up important files..."
    $sourcePath = "C:\Users\YourUsername\Documents\*"
    $backupPath = "E:\Backup\Documents\"
    xcopy $sourcePath $backupPath /E /H /C /I
    Write-Host "Backup completed successfully."
    Log-Event -message "Backup completed successfully."
}

# --- 5. Multithreading for Parallel Execution ---
$tasks = @(
    { Check-WindowsUpdates },
    { Run-MalwareBytes },
    { Backup-Files }
)

$tasks | ForEach-Object -Parallel {
    & $_
}

# --- 7. Email and SMS Alerts ---
function Send-EmailAlert {
    param (
        [string]$subject,
        [string]$body
    )
    $smtpServer = "smtp.yourmailserver.com"
    $smtpFrom = "youremail@example.com"
    $smtpTo = "recipient@example.com"
    $smtpUser = "smtpusername"
    $smtpPass = "smtppassword"
    $message = New-Object System.Net.Mail.MailMessage
    $message.From = $smtpFrom
    $message.To.Add($smtpTo)
    $message.Subject = $subject
    $message.Body = $body
    $smtp = New-Object Net.Mail.SmtpClient($smtpServer)
    $smtp.Credentials = New-Object System.Net.NetworkCredential($smtpUser, $smtpPass)
    $smtp.Send($message)

    # SMS via Email-to-SMS Gateway (Example)
    $smsGateway = "1234567890@sms.gateway.com"
    $smsMessage = New-Object System.Net.Mail.MailMessage
    $smsMessage.From = $smtpFrom
    $smsMessage.To.Add($smsGateway)
    $smsMessage.Subject = $subject
    $smsMessage.Body = $body
    $smtp.Send($smsMessage)
}

# --- 8. Scheduled Task Integration ---
function Schedule-MaintenanceTask {
    $Action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "C:\path\to\script.ps1"
    $Trigger = New-ScheduledTaskTrigger -Weekly -DaysOfWeek Monday -At 2AM
    Register-ScheduledTask -Action $Action -Trigger $Trigger -TaskName "Weekly Maintenance"
}

# --- 9. System Resource Monitoring ---
function Monitor-SystemResources {
    $cpuUsage = (Get-WmiObject Win32_Processor).LoadPercentage
    $memoryUsage = (Get-WmiObject Win32_OperatingSystem).FreePhysicalMemory / 1MB
    $totalMemory = (Get-WmiObject Win32_OperatingSystem).TotalVisibleMemorySize / 1MB
    $memoryUsagePercentage = (($totalMemory - $memoryUsage) / $totalMemory) * 100

    Write-Host "CPU Usage: $cpuUsage%"
    Write-Host "Memory Usage: $memoryUsagePercentage%"

    if ($cpuUsage -gt 90) {
        Write-Host "Warning: High CPU usage detected ($cpuUsage%)"
        Log-Event -message "High CPU usage detected: $cpuUsage%"
    }

    if ($memoryUsagePercentage -gt 90) {
        Write-Host "Warning: High memory usage detected ($memoryUsagePercentage%)"
        Log-Event -message "High memory usage detected: $memoryUsagePercentage%"
    }
}

# --- 10. Improved Security Considerations (file deletion safeguard) ---
function Clean-DownloadsFolder {
    $downloadsPath = "C:\Users\YourUsername\Downloads"
    $files = Get-ChildItem -Path $downloadsPath -Recurse | Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-14) }

    foreach ($file in $files) {
        $confirmation = Read-Host "Do you want to delete $($file.Name)? (y/n)"
        if ($confirmation -eq 'y') {
            Write-Host "Deleting file: $($file.FullName) (older than 14 days)"
            Remove-Item $file.FullName -Force
            Log-Event -message "Deleted file: $($file.FullName)"
        }
    }
}

# --- Main Script Execution ---
Write-Host "Starting Weekly System Maintenance..."

# Step 1: Check Low Disk Space before proceeding
Check-LowDiskSpace

# Step 2: Create a System Restore Point before updating
Create-RestorePoint

# Step 3: Run Maintenance Tasks in Parallel
$tasks | ForEach-Object -Parallel {
    & $_
}

# Step 4: Check Windows Services Health
Check-ServiceHealth

# Step 5: Run Malwarebytes Scan
Run-MalwareBytes

# Step 6: Defragment Hard Drives (if needed)
Defrag-Drive

# Step 7: Update Software via Winget
Update-Software

# Step 8: Check for System Errors in Event Logs
Check-SystemErrors

# Step 9: Backup Important Files
Backup-Files

# Step 10: Clean Downloads Folder (delete files older than 14 days)
Clean-DownloadsFolder

# Step 11: Delete .torrent Files Across the System
Delete-TorrentFiles

# Step 12: Perform Full Windows Defender Scan
Full-WindowsDefenderScan

Write-Host "Weekly System Maintenance completed successfully."
Log-Event -message "Weekly system maintenance completed successfully."
