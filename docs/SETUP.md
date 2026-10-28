# Installing CardGuardian on your phone

## Android

### 1. Get the APK

Every push to GitHub builds two APKs. Open the repository on GitHub →
**Actions** → the latest green run → **Artifacts** → `cardguardian-android`,
and unzip it.

| File | Use it when |
| --- | --- |
| `app-personal-release.apk` | Your own phone. Reads SMS from the senders you allow, including old messages. |
| `app-play-release.apk` | The Google Play version. Reads bank alerts from notifications only (no SMS permission). |

Both can be installed side by side (different app IDs).

### 2. Install

Copy the APK to the phone and open it. Android asks to allow installs from
that app (Files, Chrome…); allow it once.

### 3. Allow SMS / notification access

Android 13+ blocks SMS and notification access for apps installed from an
APK file ("Restricted setting"). If the permission button does nothing or
says it's restricted:

1. Settings → Apps → CardGuardian → **⋮** (top right) → **Allow restricted settings**.
2. Go back to CardGuardian → More → Sources and tap **Allow** again.

### 4. Keep your data across updates (important)

Without a signing key of your own, CI signs with a throwaway debug key that
changes between machines. Android refuses to install an update signed with a
different key, and uninstalling deletes the app's data. Set up your own key
once, before you start relying on the app:

```sh
keytool -genkeypair -v -keystore cardguardian.jks -alias cardguardian \
  -keyalg RSA -keysize 4096 -validity 10000
base64 -w0 cardguardian.jks > cardguardian.jks.b64   # macOS: base64 -i cardguardian.jks
```

In GitHub → Settings → Secrets and variables → Actions, add:

| Secret | Value |
| --- | --- |
| `CG_KEYSTORE_BASE64` | contents of `cardguardian.jks.b64` |
| `CG_KEYSTORE_PASSWORD` | the keystore password |
| `CG_KEY_ALIAS` | `cardguardian` |
| `CG_KEY_PASSWORD` | the key password |

Keep `cardguardian.jks` and its passwords somewhere safe and **never commit
it**. The same key is needed later for Google Play.

Also make an encrypted backup from More → Backup before reinstalling.

## iPhone

iOS doesn't let apps read SMS. CardGuardian uses a Shortcuts automation that
hands each bank message to the app; the text stays on the phone.

### Installing

An iPhone app has to be built on a Mac with Xcode:

- **Free Apple ID:** open `ios/Runner.xcworkspace` in Xcode, pick your
  personal team under Signing & Capabilities, plug in the phone and Run. The
  app stops opening after 7 days and must be re-run from Xcode (data is kept).
- **Apple Developer Program ($99/year):** archive and upload to TestFlight;
  builds last 90 days and update over the air. This is also the path to the
  App Store.

CI checks that the iOS app compiles on every push, without signing.

### Automatic import (Shortcuts)

1. Open CardGuardian once and add your bank's sender (e.g. `ABK-Egypt`).
2. Shortcuts → **Automation** → **+** → **Message**.
3. Sender: choose the bank (`ABK-Egypt`). Optionally *Message Contains*
   `Credit Card#` to skip OTPs.
4. Choose **Run Immediately** and turn off *Notify When Run*.
5. Add the action **Add Bank Message** (CardGuardian).
6. Set *Message* to **Shortcut Input → Content** and *Sender* to
   **Shortcut Input → Sender**.

New messages are imported the next time you open the app. The same steps are
shown in the app under More → Sources → Set up automatic import.

### Older messages

Select the messages' text in Messages, copy, and use More → Sources → Paste
messages. You pick exactly which ones to import.
