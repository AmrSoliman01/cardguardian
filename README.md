# CardGuardian

Privacy-first credit card tracker for Android and iPhone. It reads the bank
SMS alerts **you choose**, turns them into transactions, and shows spending,
available limit, due dates and installments. Nothing leaves the phone.

- No servers, no cloud AI, no analytics, no ads, no crash reporting.
- The database is encrypted with SQLCipher (AES-256). The key lives in the
  iOS Keychain / Android Keystore.
- You decide exactly which senders (e.g. `ABK-Egypt`) and which messages the
  app reads. Everything else is dropped before it is stored.

See [PRIVACY.md](PRIVACY.md) for the full privacy model and
[docs/SETUP.md](docs/SETUP.md) for installing on your phone.

## Layout

| Path | What |
| --- | --- |
| `packages/cg_core` | Pure Dart: money, bank parsers, sender rules, CSV import. Fully unit-tested. |
| `lib/` | Flutter app (Riverpod, go_router, Drift on SQLCipher). |
| `android/app/src/personal` | SMS reading, only in the sideloaded `personal` build. |
| `android/app/src/main/kotlin` | Notification listener, encrypted pending queue, device checks. |
| `ios/Runner/*.swift` | Shortcuts action (`AddBankMessageIntent`), encrypted inbox, native channel. |

## Build

```sh
flutter pub get
dart run build_runner build   # only after changing Drift tables
flutter test && (cd packages/cg_core && dart test)

flutter build apk --release --flavor personal   # reads SMS, for your own phone
flutter build apk --release --flavor play       # Google Play-safe, reads notifications
flutter build ios --release                     # needs macOS + Xcode
```

CI builds both APKs on every push; download them from the run's
*Artifacts* section.
