import AppIntents
import Foundation

/// Shortcuts action "Add Bank Message". A personal automation ("When I get a
/// message from ABK-Egypt") passes the message text and sender here. The text
/// is sealed into the app's local inbox; nothing leaves the phone.
struct AddBankMessageIntent: AppIntent {
  static let title: LocalizedStringResource = "Add Bank Message"
  static let description = IntentDescription(
    "Sends a bank message to CardGuardian on this iPhone. Only senders you allowed in the app are kept.")
  static let openAppWhenRun: Bool = false

  @Parameter(title: "Message")
  var message: String

  @Parameter(title: "Sender")
  var sender: String?

  func perform() async throws -> some IntentResult {
    guard PendingInbox.accepts(sender: sender) else { return .result() }
    try PendingInbox.enqueue(source: "shortcut", sender: sender, body: message, receivedAt: Date())
    NativeChannel.notifyPending()
    return .result()
  }
}
