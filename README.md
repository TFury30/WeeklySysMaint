
---

# WeeklySysMaint PowerShell Script

This PowerShell script, **WeeklySysMaint**, is designed to automate comprehensive weekly system maintenance routines on Windows systems. It ensures your system stays up-to-date, secure, and optimized by performing various tasks such as:

* Checking for and installing Windows updates
* Running system scans (Malwarebytes and Windows Defender)
* Defragmenting hard drives
* Backing up important files
* Cleaning up old files in the Downloads folder
* Deleting unwanted `.torrent` files
* Logging important actions and system health
* Sending email and SMS alerts for critical events

---

## Features

### 1. **Windows Update Management**

* Checks for available Windows updates and installs them.
* Restarts the system if required after updates.

### 2. **Malware Protection**

* Runs a Malwarebytes scan to detect and remove malware.
* Performs a full system scan with Windows Defender.

### 3. **System Optimization**

* Defragments hard drives to improve system performance.
* Deletes files older than 14 days from the Downloads folder.
* Deletes `.torrent` files scattered across the system.

### 4. **Backup System**

* Performs a full backup of user files (e.g., Documents) to a specified backup drive.
* (Note: The script currently performs a simple full backup, but this can be modified for incremental backups as needed.)

### 5. **System Monitoring**

* Checks for low disk space (under 10 GB).
* Monitors CPU and memory usage to prevent performance bottlenecks.

### 6. **Error Detection and Notification**

* Checks the Windows Event Logs for critical system errors and warnings.
* Logs errors and sends email alerts with error details.

### 7. **Scheduled Execution**

* Can be scheduled via Task Scheduler for automatic weekly execution.
* Supports parallel execution for certain maintenance tasks to speed up the process.

### 8. **Logging and Auditing**

* Logs maintenance activities to a log file, including backup and file deletion actions.
* Rotates log files automatically when they reach a size of 50 MB.

### 9. **Email and SMS Alerts**

* Sends email notifications for errors or important events.
* (Includes a mockup for sending SMS alerts using an email-to-SMS gateway.)

---

## Requirements

* **Windows Operating System**: This script is designed for Windows-based systems.
* **PowerShell 5.1 or later**: Ensure that PowerShell is available and properly configured.
* **Malwarebytes Anti-Malware**: Installed on the system to run security scans.
* **Winget (Windows Package Manager)**: For updating software via `winget`.
* **Admin Privileges**: Some commands (e.g., system updates, service management) require elevated privileges.
* **SMTP Server**: You'll need an SMTP server for sending email alerts (can be configured in the script).
* **Backup Location**: Modify the script to point to your desired backup folder.

---

## Setup and Configuration

1. **Clone the Repository**

   * Clone this repository to your local machine using Git:

   ```bash
   git clone https://github.com/TFury30/WeeklySysMaint.git
   ```

2. **Modify the Script**

   * Open the script in a PowerShell editor and update the following variables to suit your system:

     * Backup paths (`$sourcePath`, `$backupPath`)
     * Email server details (`$smtpServer`, `$smtpFrom`, `$smtpTo`, etc.)
     * Paths to tools like Malwarebytes and Windows Defender (if needed).

3. **Schedule the Script**

   * You can schedule this script to run automatically using Windows Task Scheduler:

     * Open **Task Scheduler**.
     * Click **Create Task** and set the trigger to run weekly.
     * Set the action to execute `powershell.exe` and pass the script path as an argument.

4. **Run the Script**

   * Run the script manually in PowerShell to ensure it works as expected:

   ```bash
   powershell.exe -ExecutionPolicy Bypass -File "C:\path\to\script.ps1"
   ```

---

## Usage

1. **Start Weekly Maintenance**:

   * The script can be run manually or scheduled using Task Scheduler.
   * It will log activities, install updates, perform system checks, clean old files, run scans, and more.

2. **Logs**:

   * All activities are logged to a specified log file (`maintenance_log.txt`), which can be reviewed for audit purposes.

3. **Error Handling**:

   * If an error occurs during the update process, the script will prompt you to restore the system using a previously created restore point.
   * You will also be notified by email and SMS if critical errors are detected.

---

## Example Task Scheduler Setup

If you'd like to schedule this script to run every Monday at 2 AM, you can use the following command in PowerShell to create a scheduled task:

```powershell
$Action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "C:\path\to\script.ps1"
$Trigger = New-ScheduledTaskTrigger -Weekly -DaysOfWeek Monday -At 2AM
Register-ScheduledTask -Action $Action -Trigger $Trigger -TaskName "Weekly System Maintenance"
```

---

## Customization

### Backup

The script currently performs a full backup of your Documents folder. You can customize the backup location and add more folders as necessary.

### Email/SMS Alerts

To receive email and SMS alerts, configure the `$smtpServer`, `$smtpFrom`, and `$smtpTo` variables in the script. You may also need to modify the email-to-SMS gateway for SMS alerts.

### Disk Space and CPU Monitoring

The script checks for low disk space (less than 10 GB) and monitors CPU and memory usage. You can adjust the thresholds as needed for your environment.

---

## Contributing

Feel free to submit issues and pull requests. If you find bugs or have suggestions for new features, don’t hesitate to contribute!

1. Fork the repository.
2. Create a new branch (`git checkout -b feature-name`).
3. Commit your changes (`git commit -am 'Add new feature'`).
4. Push to the branch (`git push origin feature-name`).
5. Create a new Pull Request.

---

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---


