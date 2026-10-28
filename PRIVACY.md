# Privacy model

1. **Nothing leaves the device.** The release Android builds do not request
   the INTERNET permission (CI fails if they do). The app contains no
   networking code (CI greps for it) and no tracking, analytics, ads or crash
   reporting packages (CI checks `pubspec.lock`).
2. **You choose what is read.** Automatic sources (SMS, notifications, the
   iOS Shortcut) only accept messages from senders you added, optionally
   filtered by a phrase such as `Credit Card#`. Messages from any other sender
   are dropped in memory and never stored. When importing history you tick the
   exact messages to import.
3. **Encrypted at rest.** All data is in one SQLCipher database (AES-256,
   `secure_delete` on). Its 256-bit random key is stored in the Keychain /
   Keystore and never leaves the device. Messages waiting to be imported are
   encrypted with a separate device-bound key.
4. **Your originals are never touched.** The app never deletes or edits your
   SMS, notifications or files. "Maximum privacy" deletes only the app's own
   copies of message text right after parsing.
5. **App lock.** PIN (stored as an Argon2id hash) plus Face ID / fingerprint,
   auto-lock in the background, and content hidden in the app switcher.
6. **Backups are yours.** Exports and encrypted backups (AES-256-GCM, key
   from your passphrase via Argon2id) are only written where you choose.
