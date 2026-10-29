import Flutter
import Foundation

/// The `cardguardian/native` channel. Mirrors lib/services/platform_bridge.dart.
/// SMS and notification methods are Android-only and answer "not implemented".
final class NativeChannel: NSObject, FlutterPlugin {
  private(set) static var current: FlutterMethodChannel?

  static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "cardguardian/native", binaryMessenger: registrar.messenger())
    registrar.addMethodCallDelegate(NativeChannel(), channel: channel)
    current = channel
  }

  /// Tells Dart that the Shortcut queued a message while the app is running.
  static func notifyPending() {
    DispatchQueue.main.async { current?.invokeMethod("pendingAvailable", arguments: nil) }
  }

  func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "capabilities":
      result(["sms": false, "notificationListener": false, "shortcuts": true, "flavor": "ios"])
    case "drainPending":
      DispatchQueue.global(qos: .userInitiated).async {
        let items = PendingInbox.drain()
        DispatchQueue.main.async { result(items) }
      }
    case "setAllowedSenders":
      PendingInbox.setAllowedSenders(call.arguments as? [String] ?? [])
      result(nil)
    case "setNotificationPackages", "setSecureScreen":
      // Not applicable on iOS. The app-switcher snapshot is covered by Dart.
      result(nil)
    case "deviceLooksCompromised":
      result(DeviceIntegrity.looksCompromised())
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}

/// Best-effort jailbreak detection. Used for a warning only, never to block.
enum DeviceIntegrity {
  static func looksCompromised() -> Bool {
    #if targetEnvironment(simulator)
      return false
    #else
      let paths = [
        "/Applications/Cydia.app",
        "/Applications/Sileo.app",
        "/Library/MobileSubstrate/MobileSubstrate.dylib",
        "/usr/sbin/sshd",
        "/etc/apt",
        "/private/var/lib/apt/",
        "/var/jb",
      ]
      if paths.contains(where: { FileManager.default.fileExists(atPath: $0) }) { return true }
      let probe = "/private/cg_probe_\(UUID().uuidString)"
      if (try? "x".write(toFile: probe, atomically: true, encoding: .utf8)) != nil {
        try? FileManager.default.removeItem(atPath: probe)
        return true
      }
      return false
    #endif
  }
}
