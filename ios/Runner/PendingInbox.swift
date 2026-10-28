import CryptoKit
import Foundation
import Security

/// Messages handed over by the Shortcut, waiting for Dart to import them.
/// Each one is a file sealed with AES-GCM under a key kept in the Keychain
/// (this device only), stored outside iCloud/iTunes backups.
enum PendingInbox {
  private static let lock = NSLock()
  private static let keychainService = "com.amrsoliman.cardguardian.inbox"
  private static let allowedSendersKey = "cg_allowed_senders"

  struct InboxError: Error {}

  // MARK: Allowed senders

  /// Same as normalizeSender() in cg_core.
  static func normalize(_ sender: String) -> String {
    var out = String.UnicodeScalarView()
    for s in sender.lowercased().unicodeScalars {
      let v = s.value
      if (97...122).contains(v) || (48...57).contains(v) || v == 43 || (0x0600...0x06FF).contains(v) {
        out.append(s)
      }
    }
    return String(out)
  }

  static func setAllowedSenders(_ senders: [String]) {
    let normalized = senders.map(normalize).filter { !$0.isEmpty }
    UserDefaults.standard.set(normalized, forKey: allowedSendersKey)
  }

  /// A Shortcut that names its sender must name an allowed one. Without a
  /// sender (share sheet) the app decides after asking the user.
  static func accepts(sender: String?) -> Bool {
    guard let sender = sender, !sender.trimmingCharacters(in: .whitespaces).isEmpty else { return true }
    let allowed = UserDefaults.standard.stringArray(forKey: allowedSendersKey) ?? []
    return allowed.isEmpty || allowed.contains(normalize(sender))
  }

  // MARK: Queue

  static func enqueue(source: String, sender: String?, body: String, receivedAt: Date) throws {
    guard !body.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
    let payload: [String: Any] = [
      "source": source,
      "sender": sender ?? NSNull(),
      "body": body,
      "receivedAt": Int64(receivedAt.timeIntervalSince1970 * 1000),
    ]
    let json = try JSONSerialization.data(withJSONObject: payload)
    lock.lock()
    defer { lock.unlock() }
    guard let sealed = try AES.GCM.seal(json, using: key()).combined else { throw InboxError() }
    let name = String(format: "%013lld-%@.msg", Int64(Date().timeIntervalSince1970 * 1000), UUID().uuidString)
    try sealed.write(
      to: directory().appendingPathComponent(name),
      options: [.atomic, .completeFileProtectionUntilFirstUserAuthentication])
  }

  /// Returns every queued message and removes it from the queue.
  static func drain() -> [[String: Any]] {
    lock.lock()
    defer { lock.unlock() }
    guard let dir = try? directory(),
      let files = try? FileManager.default.contentsOfDirectory(at: dir, includingPropertiesForKeys: nil),
      let key = try? key()
    else { return [] }
    var out: [[String: Any]] = []
    for file in files.sorted(by: { $0.lastPathComponent < $1.lastPathComponent }) {
      defer { try? FileManager.default.removeItem(at: file) }
      guard file.pathExtension == "msg",
        let data = try? Data(contentsOf: file),
        let box = try? AES.GCM.SealedBox(combined: data),
        let plain = try? AES.GCM.open(box, using: key),
        let obj = try? JSONSerialization.jsonObject(with: plain) as? [String: Any]
      else { continue }
      out.append(obj)
    }
    return out
  }

  private static func directory() throws -> URL {
    let base = try FileManager.default.url(
      for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    var dir = base.appendingPathComponent("inbox", isDirectory: true)
    if !FileManager.default.fileExists(atPath: dir.path) {
      try FileManager.default.createDirectory(
        at: dir, withIntermediateDirectories: true,
        attributes: [.protectionKey: FileProtectionType.completeUntilFirstUserAuthentication])
      var values = URLResourceValues()
      values.isExcludedFromBackup = true
      try dir.setResourceValues(values)
    }
    return dir
  }

  private static func key() throws -> SymmetricKey {
    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrService as String: keychainService,
      kSecAttrAccount as String: "inbox",
      kSecReturnData as String: true,
    ]
    var item: CFTypeRef?
    if SecItemCopyMatching(query as CFDictionary, &item) == errSecSuccess, let data = item as? Data {
      return SymmetricKey(data: data)
    }
    let key = SymmetricKey(size: .bits256)
    let add: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrService as String: keychainService,
      kSecAttrAccount as String: "inbox",
      kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly,
      kSecValueData as String: key.withUnsafeBytes { Data($0) },
    ]
    guard SecItemAdd(add as CFDictionary, nil) == errSecSuccess else { throw InboxError() }
    return key
  }
}
