// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'CardGuardian';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get add => 'Add';

  @override
  String get next => 'Next';

  @override
  String get enable => 'Enable';

  @override
  String get notNow => 'Not now';

  @override
  String get dismiss => 'Dismiss';

  @override
  String get allow => 'Allow';

  @override
  String get manage => 'Manage';

  @override
  String get required => 'Required';

  @override
  String get saved => 'Saved';

  @override
  String get copied => 'Copied';

  @override
  String get preview => 'Preview';

  @override
  String get restore => 'Restore';

  @override
  String get approve => 'Add it';

  @override
  String get ignore => 'Ignore';

  @override
  String get navDashboard => 'Overview';

  @override
  String get navTransactions => 'Transactions';

  @override
  String get navReview => 'Review';

  @override
  String get navMore => 'More';

  @override
  String get sectionMoney => 'Money';

  @override
  String get sectionSources => 'Messages & import';

  @override
  String get sectionApp => 'App';

  @override
  String get lockNow => 'Lock now';

  @override
  String get welcomeTitle => 'Your card data stays on this phone';

  @override
  String get privacyPoint1 => 'No servers, no cloud, no ads, no tracking.';

  @override
  String get privacyPoint2 =>
      'You choose exactly which bank messages the app reads.';

  @override
  String get privacyPoint3 =>
      'Everything is encrypted with a key that never leaves the phone.';

  @override
  String get privacyPoint4 =>
      'Your original messages are never changed or deleted.';

  @override
  String get createPin => 'Create a PIN';

  @override
  String get confirmPin => 'Enter the PIN again';

  @override
  String get pinHint =>
      '4 to 8 digits. It protects the app even if the phone is unlocked.';

  @override
  String get pinMismatch => 'PINs didn\'t match. Try again.';

  @override
  String get biometricsTitle => 'Unlock with Face ID or fingerprint?';

  @override
  String get biometricsSubtitle => 'You can still use your PIN anytime.';

  @override
  String get enableBiometricsReason =>
      'Confirm to use biometrics for CardGuardian';

  @override
  String get chooseBanksTitle => 'Which bank messages should the app read?';

  @override
  String get chooseBanksSubtitle =>
      'Only these senders are read. Everything else is ignored and never stored.';

  @override
  String get chooseBanksFootnote =>
      'You can change senders, add a text filter, or require approval for each message later in Sources.';

  @override
  String get finishSetup => 'Start';

  @override
  String senderLabel(String sender) {
    return 'Sender: $sender';
  }

  @override
  String get editSender => 'Edit sender';

  @override
  String get addSender => 'Add sender';

  @override
  String get senderHelp => 'Exactly as it appears in Messages, e.g. ABK-Egypt';

  @override
  String get enterPin => 'Enter your PIN';

  @override
  String get unlockReason => 'Unlock CardGuardian';

  @override
  String get useBiometrics => 'Use Face ID / fingerprint';

  @override
  String pinWrong(int attempts) {
    return 'Wrong PIN. $attempts attempts left.';
  }

  @override
  String pinLockedOut(int seconds) {
    return 'Too many attempts. Try again in $seconds s.';
  }

  @override
  String get biometricsUnavailable =>
      'Biometrics are not available on this device.';

  @override
  String get previousMonth => 'Previous month';

  @override
  String get nextMonth => 'Next month';

  @override
  String get addTransaction => 'Add transaction';

  @override
  String get editTransaction => 'Edit transaction';

  @override
  String get noCardsTitle => 'No cards yet';

  @override
  String get noCardsMessage =>
      'Cards appear by themselves with the first bank message. Choose your bank senders, or paste some messages to start.';

  @override
  String get spentThisMonth => 'Spent this month';

  @override
  String transactionsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count transactions',
      one: '1 transaction',
    );
    return '$_temp0';
  }

  @override
  String refundsAmount(String amount) {
    return 'Refunds $amount';
  }

  @override
  String paymentsAmount(String amount) {
    return 'Paid $amount';
  }

  @override
  String get cardsTitle => 'Cards';

  @override
  String get availableLimit => 'Available limit';

  @override
  String get upcomingDues => 'Upcoming payments';

  @override
  String get overdue => 'Overdue';

  @override
  String get estimated => 'estimated';

  @override
  String inDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'in $days days',
      one: 'tomorrow',
      zero: 'today',
    );
    return '$_temp0';
  }

  @override
  String get byCategory => 'By category';

  @override
  String get uncategorized => 'Uncategorized';

  @override
  String get dailySpending => 'Daily spending';

  @override
  String get topMerchants => 'Top merchants';

  @override
  String get noSpendingThisMonth => 'No spending recorded this month';

  @override
  String get searchMerchant => 'Search merchant';

  @override
  String get allCards => 'All cards';

  @override
  String get allTypes => 'All types';

  @override
  String get allCategories => 'All categories';

  @override
  String get noTransactions => 'No transactions';

  @override
  String get typePurchase => 'Purchase';

  @override
  String get typeRefund => 'Refund';

  @override
  String get typePayment => 'Payment';

  @override
  String get typeFee => 'Fee';

  @override
  String get typeInterest => 'Interest';

  @override
  String get typeCash => 'Cash withdrawal';

  @override
  String get typeInstallment => 'Installment';

  @override
  String get typeReversal => 'Reversal';

  @override
  String get typeDeclined => 'Declined';

  @override
  String get card => 'Card';

  @override
  String get otherCard => 'Another card…';

  @override
  String get bank => 'Bank';

  @override
  String get last4 => 'Last 4 digits';

  @override
  String get last4Invalid => 'Enter 4 digits';

  @override
  String get type => 'Type';

  @override
  String get amount => 'Amount';

  @override
  String get amountInvalid => 'Enter a valid amount';

  @override
  String get currency => 'Currency';

  @override
  String get currencyInvalid => '3 letters, e.g. EGP';

  @override
  String get merchant => 'Merchant';

  @override
  String get dateTime => 'Date and time';

  @override
  String get category => 'Category';

  @override
  String get rememberMerchantCategory =>
      'Always use this category for this merchant';

  @override
  String get note => 'Note';

  @override
  String sourceInfo(String source, String parser) {
    return 'Source: $source · read by $parser';
  }

  @override
  String get deleteTransactionQ => 'Delete this transaction?';

  @override
  String get approveAll => 'Add all';

  @override
  String approvedCount(int count) {
    return '$count added';
  }

  @override
  String get reviewEmptyTitle => 'Nothing to review';

  @override
  String get reviewEmptyMessage =>
      'Messages from senders set to \"Ask me first\", and messages the app could not read, show up here.';

  @override
  String get notUnderstood => 'Not understood';

  @override
  String get waitingApproval => 'Waiting for you';

  @override
  String get enterManually => 'Enter manually';

  @override
  String sourceName(String source) {
    String _temp0 = intl.Intl.selectLogic(source, {
      'sms': 'SMS',
      'notification': 'Notification',
      'shortcut': 'Shortcut',
      'share': 'Share',
      'paste': 'Paste',
      'csv': 'CSV',
      'other': 'Manual',
    });
    return '$_temp0';
  }

  @override
  String get sourcesTitle => 'Sources';

  @override
  String get sourcesSubtitle => 'Which senders and messages the app may read';

  @override
  String get sendersExplainer =>
      'The app reads messages only from the senders below. Turn a sender off to stop reading it. Messages from anyone else are dropped before anything is stored.';

  @override
  String get allowedSenders => 'Allowed senders';

  @override
  String get noSenders => 'No senders yet. Nothing will be read automatically.';

  @override
  String get modeAuto => 'Add automatically';

  @override
  String get modeReview => 'Ask me first';

  @override
  String get modeAutoHelp =>
      'Transactions are added as soon as the message arrives.';

  @override
  String get modeReviewHelp =>
      'Each message waits in Review until you add or ignore it.';

  @override
  String filterContains(String text) {
    return 'only with \"$text\"';
  }

  @override
  String get senderId => 'Sender name';

  @override
  String get mustContainLabel => 'Only messages containing (optional)';

  @override
  String get mustContainHelp => 'e.g. Credit Card# to skip OTP and offers';

  @override
  String get smsSourceTitle => 'SMS on this phone';

  @override
  String get smsAllowed => 'SMS access is on';

  @override
  String get smsNotAllowed => 'SMS access is off';

  @override
  String get smsExplainer =>
      'New messages from allowed senders are added as they arrive.';

  @override
  String get smsHistoryTitle => 'Import old messages';

  @override
  String get smsHistorySubtitle =>
      'Choose senders, then tick the exact messages';

  @override
  String get notificationSourceTitle => 'Bank notifications';

  @override
  String get notificationsAllowed => 'Notification access is on';

  @override
  String get notificationsNotAllowed => 'Notification access is off';

  @override
  String get notificationsExplainer =>
      'Reads SMS notifications from the apps you tick, and only from allowed senders.';

  @override
  String get notificationAppsEmpty =>
      'Apps appear here after they show a notification. Your messages app is listed first.';

  @override
  String get shortcutSourceTitle => 'iPhone Shortcuts';

  @override
  String get shortcutSetupTitle => 'Set up automatic import';

  @override
  String get shortcutSetupSubtitle =>
      'One-time Shortcuts automation that forwards bank SMS';

  @override
  String get manualSourcesTitle => 'Manual';

  @override
  String get pasteImportTitle => 'Paste messages';

  @override
  String get pasteImportSubtitle =>
      'Copy messages from your inbox and paste them here';

  @override
  String get csvImportTitle => 'Import CSV file';

  @override
  String get iosGuideIntro =>
      'iPhone does not let apps read SMS. A Shortcuts automation can forward each bank message to CardGuardian instead. It runs on the phone; nothing is sent anywhere.';

  @override
  String get iosStep1 => 'Open the Shortcuts app, go to Automation, and tap +.';

  @override
  String get iosStep2 => 'Choose Message.';

  @override
  String get iosStep3 =>
      'In \"Message Contains\" type Credit Card# (or the text your bank always uses).';

  @override
  String get iosStep4 => 'Choose \"Run Immediately\", then Next.';

  @override
  String get iosStep5 =>
      'Tap \"New Blank Automation\", Add Action, search CardGuardian and pick \"Add Bank Message\".';

  @override
  String get iosStep6 =>
      'Set Message to Shortcut Input → Content, and Sender to Shortcut Input → Sender.';

  @override
  String get iosStep7 =>
      'Tap Done. New bank messages are queued encrypted and added next time you open the app.';

  @override
  String copyFilterText(String text) {
    return 'Copy \"$text\"';
  }

  @override
  String get iosShareSheetTitle => 'From the Share sheet';

  @override
  String get iosShareSheetBody =>
      'Make a shortcut with \"Show in Share Sheet\" (input: Text) and the action \"Add Bank Message\". Then select message text, tap Share, and pick that shortcut.';

  @override
  String get iosHistoryTitle => 'Old messages';

  @override
  String get iosHistoryBody =>
      'iPhone has no way to export many messages at once. Copy them and use \"Paste messages\", which can take many messages in one go.';

  @override
  String get iosPrivacyNote =>
      'The automation hands the message text only to CardGuardian, on this phone. Messages from other senders are ignored by the app.';

  @override
  String get pasteExplainer =>
      'Paste one or many bank messages. You will see what was understood and choose exactly which to import.';

  @override
  String get detectAutomatically => 'Detect automatically';

  @override
  String get pasteHint => 'Paste messages here';

  @override
  String get pasteFromClipboard => 'Paste';

  @override
  String previewCounts(int total, int parsed, int selected) {
    return '$total messages · $parsed understood · $selected selected';
  }

  @override
  String get selectAll => 'Select all';

  @override
  String get selectNone => 'Select none';

  @override
  String get alreadyAdded => 'already added';

  @override
  String get notATransaction => 'Not a transaction';

  @override
  String get notUnderstoodWillReview =>
      'Not understood: goes to Review if selected';

  @override
  String importSelected(int count) {
    return 'Import $count';
  }

  @override
  String get importDone => 'Import finished';

  @override
  String importReport(int added, int duplicates, int review, int ignored) {
    return 'Added: $added\nAlready there: $duplicates\nNeeds review: $review\nIgnored: $ignored';
  }

  @override
  String autoImportSummary(int added, int review) {
    return '$added new transactions, $review to review';
  }

  @override
  String get smsPermissionNeeded =>
      'SMS access is needed to read old messages.';

  @override
  String get smsHistoryExplainer =>
      'Pick the senders to read. Only their messages are loaded, and you then tick the ones to import.';

  @override
  String messagesCount(int count) {
    return '$count messages';
  }

  @override
  String get howFarBack => 'How far back';

  @override
  String lastMonths(int months) {
    return 'Last $months months';
  }

  @override
  String get allTime => 'Everything';

  @override
  String get showMessages => 'Show messages';

  @override
  String get csvExplainer =>
      'Use your bank\'s CSV export. Map the columns once and preview before importing.';

  @override
  String get chooseFile => 'Choose file';

  @override
  String get firstRowIsHeader => 'First row is a header';

  @override
  String columnN(int n) {
    return 'Column $n';
  }

  @override
  String get dateColumn => 'Date column';

  @override
  String get dateFormat => 'Date format';

  @override
  String get merchantColumn => 'Description column';

  @override
  String get amountColumn => 'Amount column';

  @override
  String get negativeIsSpend => 'Purchases are negative numbers';

  @override
  String get currencyColumn => 'Currency column';

  @override
  String noCurrencyColumn(String currency) {
    return 'None (all $currency)';
  }

  @override
  String csvRowErrors(int count) {
    return '$count rows could not be read';
  }

  @override
  String importRows(int count) {
    return 'Import $count rows';
  }

  @override
  String get cardsAutoCreated =>
      'A card is added automatically the first time a message mentions it.';

  @override
  String get deleteCard => 'Delete card';

  @override
  String get deleteCardQ => 'Delete this card?';

  @override
  String get deleteCardMessage =>
      'All its transactions, statements and installments are deleted too.';

  @override
  String asOf(String when) {
    return 'as of $when';
  }

  @override
  String get creditLimit => 'Credit limit';

  @override
  String get statementDay => 'Statement day';

  @override
  String get dueDay => 'Due day';

  @override
  String get viewTransactions => 'View transactions';

  @override
  String get statementsTitle => 'Statements & due dates';

  @override
  String get noStatements =>
      'No statements. Add one to get due-date reminders.';

  @override
  String get due => 'Due';

  @override
  String get minimumDue => 'Minimum';

  @override
  String get markPaid => 'Mark as paid';

  @override
  String get markUnpaid => 'Mark as unpaid';

  @override
  String get editCard => 'Edit card';

  @override
  String get nickname => 'Nickname';

  @override
  String get dayOfMonthHelp => 'Day of month, 1–31';

  @override
  String get addStatement => 'Add statement';

  @override
  String get totalDue => 'Total due';

  @override
  String get dueDate => 'Due date';

  @override
  String get installmentsTitle => 'Installments';

  @override
  String get noInstallments => 'No installments';

  @override
  String get installmentsHelp =>
      'Add purchases you pay in installments to see what is left.';

  @override
  String get addInstallment => 'Add installment plan';

  @override
  String get remainingTotal => 'Remaining on all plans';

  @override
  String perMonth(String amount) {
    return '$amount per month';
  }

  @override
  String monthsProgress(int paid, int total) {
    return '$paid/$total months';
  }

  @override
  String get remaining => 'Left';

  @override
  String get deleteInstallmentQ => 'Delete this installment plan?';

  @override
  String get totalAmount => 'Total amount';

  @override
  String get months => 'Months';

  @override
  String get firstInstallmentMonth => 'First installment month';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get appearance => 'Appearance';

  @override
  String get language => 'Language';

  @override
  String get theme => 'Theme';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get security => 'Security';

  @override
  String get changePin => 'Change PIN';

  @override
  String get pinChanged => 'PIN changed';

  @override
  String get autoLock => 'Auto-lock';

  @override
  String get immediately => 'Immediately';

  @override
  String afterMinutes(int minutes) {
    return 'After $minutes min';
  }

  @override
  String get blockScreenshots => 'Block screenshots';

  @override
  String get blockScreenshotsHelp =>
      'Android: blocks screenshots and recording. Both: hides the app in the app switcher.';

  @override
  String get privacy => 'Privacy';

  @override
  String get maxPrivacy => 'Maximum privacy';

  @override
  String get maxPrivacyHelp =>
      'Delete the app\'s copy of each message right after it becomes a transaction. Otherwise copies are kept 30 days. Your original messages are never touched.';

  @override
  String get dueReminders => 'Due-date reminders';

  @override
  String get dueRemindersHelp =>
      '3 days before and on the due date. No amounts are shown.';

  @override
  String get privacyPromiseTitle => 'What leaves your phone';

  @override
  String get privacyPromiseBody =>
      'Nothing. No internet permission in the Android release builds, no analytics, no crash reports. Backups and exports only go where you send them.';

  @override
  String get dangerZone => 'Danger zone';

  @override
  String get deleteAllData => 'Delete all data';

  @override
  String get deleteAllDataHelp =>
      'Cards, transactions, messages and senders. Settings and PIN stay.';

  @override
  String get deleteAllDataQ => 'Delete all data?';

  @override
  String get deleteAllDataConfirm =>
      'This cannot be undone. Make a backup first if you may need it.';

  @override
  String get allDataDeleted => 'All data deleted';

  @override
  String get categoriesTitle => 'Categories';

  @override
  String get categoriesHelp =>
      'Change a transaction\'s category and tick \"Always use this category\" to teach the app a merchant.';

  @override
  String get addCategory => 'Add category';

  @override
  String get customCategory => 'Custom';

  @override
  String get nameArabic => 'Name in Arabic';

  @override
  String get nameEnglish => 'Name in English';

  @override
  String get backupTitle => 'Backup & export';

  @override
  String get backupExplainer =>
      'Backups are encrypted with a passphrase you choose. Keep it safe: without it the backup cannot be opened, by you or anyone.';

  @override
  String get createBackup => 'Create encrypted backup';

  @override
  String get createBackupHelp =>
      'Then save it to Files, Drive or anywhere you like';

  @override
  String get restoreBackup => 'Restore from backup';

  @override
  String get restoreBackupHelp => 'Replaces everything in the app';

  @override
  String get exportCsv => 'Export transactions (CSV)';

  @override
  String get exportCsvHelp => 'Not encrypted. Opens in Excel or Sheets.';

  @override
  String get choosePassphrase => 'Choose a backup passphrase';

  @override
  String get enterPassphrase => 'Backup passphrase';

  @override
  String get passphrase => 'Passphrase';

  @override
  String get confirmPassphrase => 'Confirm passphrase';

  @override
  String get passphraseWarning =>
      'At least 8 characters. It cannot be recovered.';

  @override
  String get passphraseTooShort => 'At least 8 characters';

  @override
  String get passphraseMismatch => 'Passphrases don\'t match';

  @override
  String get restoreQ => 'Replace all data with this backup?';

  @override
  String get restoreWarning => 'Everything currently in the app is replaced.';

  @override
  String get restoreDone => 'Backup restored';

  @override
  String get wrongPassphrase => 'Wrong passphrase, or the file was changed.';

  @override
  String get notABackup => 'This is not a CardGuardian backup.';

  @override
  String get auditTitle => 'Security log';

  @override
  String get auditHelp =>
      'Local record of imports, exports, settings changes and failed unlocks. It never contains amounts or message text.';

  @override
  String reminderToday(String card) {
    return '$card: payment due today';
  }

  @override
  String reminderSoon(String card, int days) {
    return '$card: payment due in $days days';
  }

  @override
  String get reminderBody => 'Open CardGuardian for details.';

  @override
  String get deviceCompromisedWarning =>
      'This phone looks rooted or jailbroken. Other apps may be able to read your data.';
}
