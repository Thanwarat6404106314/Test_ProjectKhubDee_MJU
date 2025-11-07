# Run Flutter App on LDPlayer 9
# This script connects to LDPlayer and runs your Flutter app

Write-Host "Connecting to LDPlayer 9..." -ForegroundColor Cyan

# Path to ADB
$adbPath = "C:\Users\ASUS\AppData\Local\Android\Sdk\platform-tools\adb.exe"

# Connect to LDPlayer (default port 5555)
& $adbPath connect 127.0.0.1:5555

# Wait for connection
Start-Sleep -Seconds 2

# Show connected devices
Write-Host "`nConnected Devices:" -ForegroundColor Green
& $adbPath devices

Write-Host "`nFlutter Devices:" -ForegroundColor Green
flutter devices

# Ask user if they want to run the app
Write-Host "`n"
$response = Read-Host "Run Flutter app on LDPlayer? (Y/N)"

if ($response -eq "Y" -or $response -eq "y") {
    Write-Host "`nLaunching app on LDPlayer..." -ForegroundColor Cyan
    flutter run -d 127.0.0.1:5555
} else {
    Write-Host "Skipped. You can manually run: flutter run -d 127.0.0.1:5555" -ForegroundColor Yellow
}
