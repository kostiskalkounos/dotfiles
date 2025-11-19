## Setup
### Add kanata in the input monitoring list:
  ```sh
  Setting -> Privacy & Security -> Input Monitoring
  ```

### Copy the kanata plist in the LaunchDaemons directory:
  ```sh
  sudo cp ~/.config/kanata/com.kanata.plist /Library/LaunchDaemons
  ```

### Bootstrap the service:
  ```sh
  sudo launchctl bootstrap system /Library/LaunchDaemons/com.kanata.plist
  ```

### Enable the service:
  ```sh
  sudo launchctl enable system/com.kanata.plist
  ```
