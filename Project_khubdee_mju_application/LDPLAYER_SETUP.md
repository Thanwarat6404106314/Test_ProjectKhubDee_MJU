# Running Flutter App on LDPlayer 9

## Step 1: Enable ADB in LDPlayer 9

1. **Open LDPlayer 9**
2. Click the **Settings** icon (⚙️) on the right sidebar
3. Go to **Other settings**
4. Enable **ADB debugging** (turn it ON)
5. Note the **ADB port number** (usually `5555` or `5037`)
6. **Restart LDPlayer** for changes to take effect

## Step 2: Connect ADB to LDPlayer

### Find LDPlayer's ADB Port:
1. Start LDPlayer 9
2. In LDPlayer, open **Settings** > **Other settings**
3. Check the ADB port (default is usually `5555`)

### Connect via Command Line:

Open PowerShell and run:

```powershell
# Navigate to Android SDK platform-tools
cd "C:\Users\ASUS\AppData\Local\Android\Sdk\platform-tools"

# Connect to LDPlayer (replace 5555 with your actual port if different)
.\adb connect 127.0.0.1:5555
```

You should see:
```
connected to 127.0.0.1:5555
```

## Step 3: Verify Connection

```powershell
.\adb devices
```

You should see something like:
```
List of devices attached
127.0.0.1:5555    device
emulator-5554     device  (if you still have Android Studio emulator running)
```

## Step 4: Run Flutter App on LDPlayer

### Option A: From Command Line

```powershell
# Navigate to your Flutter project
cd "C:\Users\ASUS\workspaces\itsci\student-projects\Test_ProjectKhubDee_MJU\Project_khubdee_mju_application"

# Check available devices
flutter devices

# Run on LDPlayer (it will show up as 127.0.0.1:5555)
flutter run -d 127.0.0.1:5555
```

### Option B: From VSCode

1. Press `F5` or click **Run > Start Debugging**
2. Select **127.0.0.1:5555** from the device list
3. The app will build and launch on LDPlayer

## Step 5: Hot Reload

While the app is running:
- Press `r` for hot reload
- Press `R` for hot restart
- Press `q` to quit

## Troubleshooting

### Issue 1: LDPlayer not showing in `flutter devices`

**Solution:**
```powershell
# Kill ADB server and restart
cd "C:\Users\ASUS\AppData\Local\Android\Sdk\platform-tools"
.\adb kill-server
.\adb start-server
.\adb connect 127.0.0.1:5555
flutter devices
```

### Issue 2: "Connection refused"

**Solutions:**
1. Make sure **ADB debugging is enabled** in LDPlayer settings
2. **Restart LDPlayer** after enabling ADB
3. Check if another emulator is using the same port
4. Try different ports: `5555`, `5556`, `5037`

### Issue 3: "Multiple devices attached"

If you have both LDPlayer and Android Studio emulator running:

```powershell
# Specify the exact device
flutter run -d 127.0.0.1:5555  # For LDPlayer
# OR
flutter run -d emulator-5554   # For Android Studio emulator
```

### Issue 4: LDPlayer uses different port

Find the correct port:
1. In LDPlayer, go to **Settings** > **Other settings**
2. Look for **ADB debugging** section
3. Note the port number
4. Use that port: `adb connect 127.0.0.1:PORT`

## Quick Start Script

Save this as `run-ldplayer.ps1` in your project folder:

```powershell
# Connect to LDPlayer
& "C:\Users\ASUS\AppData\Local\Android\Sdk\platform-tools\adb.exe" connect 127.0.0.1:5555

# Wait a moment
Start-Sleep -Seconds 2

# Show devices
flutter devices

# Run app
flutter run -d 127.0.0.1:5555
```

Run it with:
```powershell
.\run-ldplayer.ps1
```

## Performance Tips for LDPlayer

1. **Increase RAM**: Settings > Performance > RAM (set to at least 4GB)
2. **Enable Virtualization**: Enable VT (Intel) or AMD-V in BIOS
3. **Graphics Mode**: Settings > Graphics > OpenGL or DirectX
4. **Close other apps**: Close Android Studio emulator if running

## Advantages of LDPlayer vs Android Studio Emulator

✅ Faster startup time
✅ Better gaming performance
✅ Lower RAM usage
✅ Better for testing on lower-end PCs
✅ Supports more Android versions

## Common LDPlayer Settings for Development

1. **Android Version**: Use Android 7 or higher
2. **Resolution**: 1080x1920 (Portrait) or 1920x1080 (Landscape)
3. **CPU**: 4 cores
4. **RAM**: 4GB+
5. **Root Access**: Enable if needed for testing

## Disconnecting LDPlayer

When done:
```powershell
cd "C:\Users\ASUS\AppData\Local\Android\Sdk\platform-tools"
.\adb disconnect 127.0.0.1:5555
```
