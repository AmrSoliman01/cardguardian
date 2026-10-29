import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'CardGuardian'**
  String get appTitle;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @enable.
  ///
  /// In en, this message translates to:
  /// **'Enable'**
  String get enable;

  /// No description provided for @notNow.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get notNow;

  /// No description provided for @dismiss.
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get dismiss;

  /// No description provided for @allow.
  ///
  /// In en, this message translates to:
  /// **'Allow'**
  String get allow;

  /// No description provided for @manage.
  ///
  /// In en, this message translates to:
  /// **'Manage'**
  String get manage;

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// No description provided for @saved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get saved;

  /// No description provided for @copied.
  ///
  /// In en, this message translates to:
  /// **'Copied'**
  String get copied;

  /// No description provided for @preview.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get preview;

  /// No description provided for @restore.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get restore;

  /// No description provided for @approve.
  ///
  /// In en, this message translates to:
  /// **'Add it'**
  String get approve;

  /// No description provided for @ignore.
  ///
  /// In en, this message translates to:
  /// **'Ignore'**
  String get ignore;

  /// No description provided for @navDashboard.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get navDashboard;

  /// No description provided for @navTransactions.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get navTransactions;

  /// No description provided for @navReview.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get navReview;

  /// No description provided for @navMore.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get navMore;

  /// No description provided for @sectionMoney.
  ///
  /// In en, this message translates to:
  /// **'Money'**
  String get sectionMoney;

  /// No description provided for @sectionSources.
  ///
  /// In en, this message translates to:
  /// **'Messages & import'**
  String get sectionSources;

  /// No description provided for @sectionApp.
  ///
  /// In en, this message translates to:
  /// **'App'**
  String get sectionApp;

  /// No description provided for @lockNow.
  ///
  /// In en, this message translates to:
  /// **'Lock now'**
  String get lockNow;

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Your card data stays on this phone'**
  String get welcomeTitle;

  /// No description provided for @privacyPoint1.
  ///
  /// In en, this message translates to:
  /// **'No servers, no cloud, no ads, no tracking.'**
  String get privacyPoint1;

  /// No description provided for @privacyPoint2.
  ///
  /// In en, this message translates to:
  /// **'You choose exactly which bank messages the app reads.'**
  String get privacyPoint2;

  /// No description provided for @privacyPoint3.
  ///
  /// In en, this message translates to:
  /// **'Everything is encrypted with a key that never leaves the phone.'**
  String get privacyPoint3;

  /// No description provided for @privacyPoint4.
  ///
  /// In en, this message translates to:
  /// **'Your original messages are never changed or deleted.'**
  String get privacyPoint4;

  /// No description provided for @createPin.
  ///
  /// In en, this message translates to:
  /// **'Create a PIN'**
  String get createPin;

  /// No description provided for @confirmPin.
  ///
  /// In en, this message translates to:
  /// **'Enter the PIN again'**
  String get confirmPin;

  /// No description provided for @pinHint.
  ///
  /// In en, this message translates to:
  /// **'4 to 8 digits. It protects the app even if the phone is unlocked.'**
  String get pinHint;

  /// No description provided for @pinMismatch.
  ///
  /// In en, this message translates to:
  /// **'PINs didn\'t match. Try again.'**
  String get pinMismatch;

  /// No description provided for @biometricsTitle.
  ///
  /// In en, this message translates to:
  /// **'Unlock with Face ID or fingerprint?'**
  String get biometricsTitle;

  /// No description provided for @biometricsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'You can still use your PIN anytime.'**
  String get biometricsSubtitle;

  /// No description provided for @enableBiometricsReason.
  ///
  /// In en, this message translates to:
  /// **'Confirm to use biometrics for CardGuardian'**
  String get enableBiometricsReason;

  /// No description provided for @chooseBanksTitle.
  ///
  /// In en, this message translates to:
  /// **'Which bank messages should the app read?'**
  String get chooseBanksTitle;

  /// No description provided for @chooseBanksSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Only these senders are read. Everything else is ignored and never stored.'**
  String get chooseBanksSubtitle;

  /// No description provided for @chooseBanksFootnote.
  ///
  /// In en, this message translates to:
  /// **'You can change senders, add a text filter, or require approval for each message later in Sources.'**
  String get chooseBanksFootnote;

  /// No description provided for @finishSetup.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get finishSetup;

  /// No description provided for @senderLabel.
  ///
  /// In en, this message translates to:
  /// **'Sender: {sender}'**
  String senderLabel(String sender);

  /// No description provided for @editSender.
  ///
  /// In en, this message translates to:
  /// **'Edit sender'**
  String get editSender;

  /// No description provided for @addSender.
  ///
  /// In en, this message translates to:
  /// **'Add sender'**
  String get addSender;

  /// No description provided for @senderHelp.
  ///
  /// In en, this message translates to:
  /// **'Exactly as it appears in Messages, e.g. ABK-Egypt'**
  String get senderHelp;

  /// No description provided for @enterPin.
  ///
  /// In en, this message translates to:
  /// **'Enter your PIN'**
  String get enterPin;

  /// No description provided for @unlockReason.
  ///
  /// In en, this message translates to:
  /// **'Unlock CardGuardian'**
  String get unlockReason;

  /// No description provided for @useBiometrics.
  ///
  /// In en, this message translates to:
  /// **'Use Face ID / fingerprint'**
  String get useBiometrics;

  /// No description provided for @pinWrong.
  ///
  /// In en, this message translates to:
  /// **'Wrong PIN. {attempts} attempts left.'**
  String pinWrong(int attempts);

  /// No description provided for @pinLockedOut.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Try again in {seconds} s.'**
  String pinLockedOut(int seconds);

  /// No description provided for @biometricsUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Biometrics are not available on this device.'**
  String get biometricsUnavailable;

  /// No description provided for @previousMonth.
  ///
  /// In en, this message translates to:
  /// **'Previous month'**
  String get previousMonth;

  /// No description provided for @nextMonth.
  ///
  /// In en, this message translates to:
  /// **'Next month'**
  String get nextMonth;

  /// No description provided for @addTransaction.
  ///
  /// In en, this message translates to:
  /// **'Add transaction'**
  String get addTransaction;

  /// No description provided for @editTransaction.
  ///
  /// In en, this message translates to:
  /// **'Edit transaction'**
  String get editTransaction;

  /// No description provided for @noCardsTitle.
  ///
  /// In en, this message translates to:
  /// **'No cards yet'**
  String get noCardsTitle;

  /// No description provided for @noCardsMessage.
  ///
  /// In en, this message translates to:
  /// **'Cards appear by themselves with the first bank message. Choose your bank senders, or paste some messages to start.'**
  String get noCardsMessage;

  /// No description provided for @spentThisMonth.
  ///
  /// In en, this message translates to:
  /// **'Spent this month'**
  String get spentThisMonth;

  /// No description provided for @transactionsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 transaction} other{{count} transactions}}'**
  String transactionsCount(int count);

  /// No description provided for @refundsAmount.
  ///
  /// In en, this message translates to:
  /// **'Refunds {amount}'**
  String refundsAmount(String amount);

  /// No description provided for @paymentsAmount.
  ///
  /// In en, this message translates to:
  /// **'Paid {amount}'**
  String paymentsAmount(String amount);

  /// No description provided for @cardsTitle.
  ///
  /// In en, this message translates to:
  /// **'Cards'**
  String get cardsTitle;

  /// No description provided for @availableLimit.
  ///
  /// In en, this message translates to:
  /// **'Available limit'**
  String get availableLimit;

  /// No description provided for @upcomingDues.
  ///
  /// In en, this message translates to:
  /// **'Upcoming payments'**
  String get upcomingDues;

  /// No description provided for @overdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get overdue;

  /// No description provided for @estimated.
  ///
  /// In en, this message translates to:
  /// **'estimated'**
  String get estimated;

  /// No description provided for @inDays.
  ///
  /// In en, this message translates to:
  /// **'{days, plural, =0{today} =1{tomorrow} other{in {days} days}}'**
  String inDays(int days);

  /// No description provided for @byCategory.
  ///
  /// In en, this message translates to:
  /// **'By category'**
  String get byCategory;

  /// No description provided for @uncategorized.
  ///
  /// In en, this message translates to:
  /// **'Uncategorized'**
  String get uncategorized;

  /// No description provided for @dailySpending.
  ///
  /// In en, this message translates to:
  /// **'Daily spending'**
  String get dailySpending;

  /// No description provided for @topMerchants.
  ///
  /// In en, this message translates to:
  /// **'Top merchants'**
  String get topMerchants;

  /// No description provided for @noSpendingThisMonth.
  ///
  /// In en, this message translates to:
  /// **'No spending recorded this month'**
  String get noSpendingThisMonth;

  /// No description provided for @searchMerchant.
  ///
  /// In en, this message translates to:
  /// **'Search merchant'**
  String get searchMerchant;

  /// No description provided for @allCards.
  ///
  /// In en, this message translates to:
  /// **'All cards'**
  String get allCards;

  /// No description provided for @allTypes.
  ///
  /// In en, this message translates to:
  /// **'All types'**
  String get allTypes;

  /// No description provided for @allCategories.
  ///
  /// In en, this message translates to:
  /// **'All categories'**
  String get allCategories;

  /// No description provided for @noTransactions.
  ///
  /// In en, this message translates to:
  /// **'No transactions'**
  String get noTransactions;

  /// No description provided for @typePurchase.
  ///
  /// In en, this message translates to:
  /// **'Purchase'**
  String get typePurchase;

  /// No description provided for @typeRefund.
  ///
  /// In en, this message translates to:
  /// **'Refund'**
  String get typeRefund;

  /// No description provided for @typePayment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get typePayment;

  /// No description provided for @typeFee.
  ///
  /// In en, this message translates to:
  /// **'Fee'**
  String get typeFee;

  /// No description provided for @typeInterest.
  ///
  /// In en, this message translates to:
  /// **'Interest'**
  String get typeInterest;

  /// No description provided for @typeCash.
  ///
  /// In en, this message translates to:
  /// **'Cash withdrawal'**
  String get typeCash;

  /// No description provided for @typeInstallment.
  ///
  /// In en, this message translates to:
  /// **'Installment'**
  String get typeInstallment;

  /// No description provided for @typeReversal.
  ///
  /// In en, this message translates to:
  /// **'Reversal'**
  String get typeReversal;

  /// No description provided for @typeDeclined.
  ///
  /// In en, this message translates to:
  /// **'Declined'**
  String get typeDeclined;

  /// No description provided for @card.
  ///
  /// In en, this message translates to:
  /// **'Card'**
  String get card;

  /// No description provided for @otherCard.
  ///
  /// In en, this message translates to:
  /// **'Another card…'**
  String get otherCard;

  /// No description provided for @bank.
  ///
  /// In en, this message translates to:
  /// **'Bank'**
  String get bank;

  /// No description provided for @last4.
  ///
  /// In en, this message translates to:
  /// **'Last 4 digits'**
  String get last4;

  /// No description provided for @last4Invalid.
  ///
  /// In en, this message translates to:
  /// **'Enter 4 digits'**
  String get last4Invalid;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @amountInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid amount'**
  String get amountInvalid;

  /// No description provided for @currency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currency;

  /// No description provided for @currencyInvalid.
  ///
  /// In en, this message translates to:
  /// **'3 letters, e.g. EGP'**
  String get currencyInvalid;

  /// No description provided for @merchant.
  ///
  /// In en, this message translates to:
  /// **'Merchant'**
  String get merchant;

  /// No description provided for @dateTime.
  ///
  /// In en, this message translates to:
  /// **'Date and time'**
  String get dateTime;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @rememberMerchantCategory.
  ///
  /// In en, this message translates to:
  /// **'Always use this category for this merchant'**
  String get rememberMerchantCategory;

  /// No description provided for @note.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get note;

  /// No description provided for @sourceInfo.
  ///
  /// In en, this message translates to:
  /// **'Source: {source} · read by {parser}'**
  String sourceInfo(String source, String parser);

  /// No description provided for @deleteTransactionQ.
  ///
  /// In en, this message translates to:
  /// **'Delete this transaction?'**
  String get deleteTransactionQ;

  /// No description provided for @approveAll.
  ///
  /// In en, this message translates to:
  /// **'Add all'**
  String get approveAll;

  /// No description provided for @approvedCount.
  ///
  /// In en, this message translates to:
  /// **'{count} added'**
  String approvedCount(int count);

  /// No description provided for @reviewEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing to review'**
  String get reviewEmptyTitle;

  /// No description provided for @reviewEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Messages from senders set to \"Ask me first\", and messages the app could not read, show up here.'**
  String get reviewEmptyMessage;

  /// No description provided for @notUnderstood.
  ///
  /// In en, this message translates to:
  /// **'Not understood'**
  String get notUnderstood;

  /// No description provided for @waitingApproval.
  ///
  /// In en, this message translates to:
  /// **'Waiting for you'**
  String get waitingApproval;

  /// No description provided for @enterManually.
  ///
  /// In en, this message translates to:
  /// **'Enter manually'**
  String get enterManually;

  /// No description provided for @sourceName.
  ///
  /// In en, this message translates to:
  /// **'{source, select, sms{SMS} notification{Notification} shortcut{Shortcut} share{Share} paste{Paste} csv{CSV} other{Manual}}'**
  String sourceName(String source);

  /// No description provided for @sourcesTitle.
  ///
  /// In en, this message translates to:
  /// **'Sources'**
  String get sourcesTitle;

  /// No description provided for @sourcesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Which senders and messages the app may read'**
  String get sourcesSubtitle;

  /// No description provided for @sendersExplainer.
  ///
  /// In en, this message translates to:
  /// **'The app reads messages only from the senders below. Turn a sender off to stop reading it. Messages from anyone else are dropped before anything is stored.'**
  String get sendersExplainer;

  /// No description provided for @allowedSenders.
  ///
  /// In en, this message translates to:
  /// **'Allowed senders'**
  String get allowedSenders;

  /// No description provided for @noSenders.
  ///
  /// In en, this message translates to:
  /// **'No senders yet. Nothing will be read automatically.'**
  String get noSenders;

  /// No description provided for @modeAuto.
  ///
  /// In en, this message translates to:
  /// **'Add automatically'**
  String get modeAuto;

  /// No description provided for @modeReview.
  ///
  /// In en, this message translates to:
  /// **'Ask me first'**
  String get modeReview;

  /// No description provided for @modeAutoHelp.
  ///
  /// In en, this message translates to:
  /// **'Transactions are added as soon as the message arrives.'**
  String get modeAutoHelp;

  /// No description provided for @modeReviewHelp.
  ///
  /// In en, this message translates to:
  /// **'Each message waits in Review until you add or ignore it.'**
  String get modeReviewHelp;

  /// No description provided for @filterContains.
  ///
  /// In en, this message translates to:
  /// **'only with \"{text}\"'**
  String filterContains(String text);

  /// No description provided for @senderId.
  ///
  /// In en, this message translates to:
  /// **'Sender name'**
  String get senderId;

  /// No description provided for @mustContainLabel.
  ///
  /// In en, this message translates to:
  /// **'Only messages containing (optional)'**
  String get mustContainLabel;

  /// No description provided for @mustContainHelp.
  ///
  /// In en, this message translates to:
  /// **'e.g. Credit Card# to skip OTP and offers'**
  String get mustContainHelp;

  /// No description provided for @smsSourceTitle.
  ///
  /// In en, this message translates to:
  /// **'SMS on this phone'**
  String get smsSourceTitle;

  /// No description provided for @smsAllowed.
  ///
  /// In en, this message translates to:
  /// **'SMS access is on'**
  String get smsAllowed;

  /// No description provided for @smsNotAllowed.
  ///
  /// In en, this message translates to:
  /// **'SMS access is off'**
  String get smsNotAllowed;

  /// No description provided for @smsExplainer.
  ///
  /// In en, this message translates to:
  /// **'New messages from allowed senders are added as they arrive.'**
  String get smsExplainer;

  /// No description provided for @smsHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Import old messages'**
  String get smsHistoryTitle;

  /// No description provided for @smsHistorySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose senders, then tick the exact messages'**
  String get smsHistorySubtitle;

  /// No description provided for @notificationSourceTitle.
  ///
  /// In en, this message translates to:
  /// **'Bank notifications'**
  String get notificationSourceTitle;

  /// No description provided for @notificationsAllowed.
  ///
  /// In en, this message translates to:
  /// **'Notification access is on'**
  String get notificationsAllowed;

  /// No description provided for @notificationsNotAllowed.
  ///
  /// In en, this message translates to:
  /// **'Notification access is off'**
  String get notificationsNotAllowed;

  /// No description provided for @notificationsExplainer.
  ///
  /// In en, this message translates to:
  /// **'Reads SMS notifications from the apps you tick, and only from allowed senders.'**
  String get notificationsExplainer;

  /// No description provided for @notificationAppsEmpty.
  ///
  /// In en, this message translates to:
  /// **'Apps appear here after they show a notification. Your messages app is listed first.'**
  String get notificationAppsEmpty;

  /// No description provided for @shortcutSourceTitle.
  ///
  /// In en, this message translates to:
  /// **'iPhone Shortcuts'**
  String get shortcutSourceTitle;

  /// No description provided for @shortcutSetupTitle.
  ///
  /// In en, this message translates to:
  /// **'Set up automatic import'**
  String get shortcutSetupTitle;

  /// No description provided for @shortcutSetupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'One-time Shortcuts automation that forwards bank SMS'**
  String get shortcutSetupSubtitle;

  /// No description provided for @manualSourcesTitle.
  ///
  /// In en, this message translates to:
  /// **'Manual'**
  String get manualSourcesTitle;

  /// No description provided for @pasteImportTitle.
  ///
  /// In en, this message translates to:
  /// **'Paste messages'**
  String get pasteImportTitle;

  /// No description provided for @pasteImportSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Copy messages from your inbox and paste them here'**
  String get pasteImportSubtitle;

  /// No description provided for @csvImportTitle.
  ///
  /// In en, this message translates to:
  /// **'Import CSV file'**
  String get csvImportTitle;

  /// No description provided for @iosGuideIntro.
  ///
  /// In en, this message translates to:
  /// **'iPhone does not let apps read SMS. A Shortcuts automation can forward each bank message to CardGuardian instead. It runs on the phone; nothing is sent anywhere.'**
  String get iosGuideIntro;

  /// No description provided for @iosStep1.
  ///
  /// In en, this message translates to:
  /// **'Open the Shortcuts app, go to Automation, and tap +.'**
  String get iosStep1;

  /// No description provided for @iosStep2.
  ///
  /// In en, this message translates to:
  /// **'Choose Message.'**
  String get iosStep2;

  /// No description provided for @iosStep3.
  ///
  /// In en, this message translates to:
  /// **'In \"Message Contains\" type Credit Card# (or the text your bank always uses).'**
  String get iosStep3;

  /// No description provided for @iosStep4.
  ///
  /// In en, this message translates to:
  /// **'Choose \"Run Immediately\", then Next.'**
  String get iosStep4;

  /// No description provided for @iosStep5.
  ///
  /// In en, this message translates to:
  /// **'Tap \"New Blank Automation\", Add Action, search CardGuardian and pick \"Add Bank Message\".'**
  String get iosStep5;

  /// No description provided for @iosStep6.
  ///
  /// In en, this message translates to:
  /// **'Set Message to Shortcut Input → Content, and Sender to Shortcut Input → Sender.'**
  String get iosStep6;

  /// No description provided for @iosStep7.
  ///
  /// In en, this message translates to:
  /// **'Tap Done. New bank messages are queued encrypted and added next time you open the app.'**
  String get iosStep7;

  /// No description provided for @copyFilterText.
  ///
  /// In en, this message translates to:
  /// **'Copy \"{text}\"'**
  String copyFilterText(String text);

  /// No description provided for @iosShareSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'From the Share sheet'**
  String get iosShareSheetTitle;

  /// No description provided for @iosShareSheetBody.
  ///
  /// In en, this message translates to:
  /// **'Make a shortcut with \"Show in Share Sheet\" (input: Text) and the action \"Add Bank Message\". Then select message text, tap Share, and pick that shortcut.'**
  String get iosShareSheetBody;

  /// No description provided for @iosHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Old messages'**
  String get iosHistoryTitle;

  /// No description provided for @iosHistoryBody.
  ///
  /// In en, this message translates to:
  /// **'iPhone has no way to export many messages at once. Copy them and use \"Paste messages\", which can take many messages in one go.'**
  String get iosHistoryBody;

  /// No description provided for @iosPrivacyNote.
  ///
  /// In en, this message translates to:
  /// **'The automation hands the message text only to CardGuardian, on this phone. Messages from other senders are ignored by the app.'**
  String get iosPrivacyNote;

  /// No description provided for @pasteExplainer.
  ///
  /// In en, this message translates to:
  /// **'Paste one or many bank messages. You will see what was understood and choose exactly which to import.'**
  String get pasteExplainer;

  /// No description provided for @detectAutomatically.
  ///
  /// In en, this message translates to:
  /// **'Detect automatically'**
  String get detectAutomatically;

  /// No description provided for @pasteHint.
  ///
  /// In en, this message translates to:
  /// **'Paste messages here'**
  String get pasteHint;

  /// No description provided for @pasteFromClipboard.
  ///
  /// In en, this message translates to:
  /// **'Paste'**
  String get pasteFromClipboard;

  /// No description provided for @previewCounts.
  ///
  /// In en, this message translates to:
  /// **'{total} messages · {parsed} understood · {selected} selected'**
  String previewCounts(int total, int parsed, int selected);

  /// No description provided for @selectAll.
  ///
  /// In en, this message translates to:
  /// **'Select all'**
  String get selectAll;

  /// No description provided for @selectNone.
  ///
  /// In en, this message translates to:
  /// **'Select none'**
  String get selectNone;

  /// No description provided for @alreadyAdded.
  ///
  /// In en, this message translates to:
  /// **'already added'**
  String get alreadyAdded;

  /// No description provided for @notATransaction.
  ///
  /// In en, this message translates to:
  /// **'Not a transaction'**
  String get notATransaction;

  /// No description provided for @notUnderstoodWillReview.
  ///
  /// In en, this message translates to:
  /// **'Not understood: goes to Review if selected'**
  String get notUnderstoodWillReview;

  /// No description provided for @importSelected.
  ///
  /// In en, this message translates to:
  /// **'Import {count}'**
  String importSelected(int count);

  /// No description provided for @importDone.
  ///
  /// In en, this message translates to:
  /// **'Import finished'**
  String get importDone;

  /// No description provided for @importReport.
  ///
  /// In en, this message translates to:
  /// **'Added: {added}\nAlready there: {duplicates}\nNeeds review: {review}\nIgnored: {ignored}'**
  String importReport(int added, int duplicates, int review, int ignored);

  /// No description provided for @autoImportSummary.
  ///
  /// In en, this message translates to:
  /// **'{added} new transactions, {review} to review'**
  String autoImportSummary(int added, int review);

  /// No description provided for @smsPermissionNeeded.
  ///
  /// In en, this message translates to:
  /// **'SMS access is needed to read old messages.'**
  String get smsPermissionNeeded;

  /// No description provided for @smsHistoryExplainer.
  ///
  /// In en, this message translates to:
  /// **'Pick the senders to read. Only their messages are loaded, and you then tick the ones to import.'**
  String get smsHistoryExplainer;

  /// No description provided for @messagesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} messages'**
  String messagesCount(int count);

  /// No description provided for @howFarBack.
  ///
  /// In en, this message translates to:
  /// **'How far back'**
  String get howFarBack;

  /// No description provided for @lastMonths.
  ///
  /// In en, this message translates to:
  /// **'Last {months} months'**
  String lastMonths(int months);

  /// No description provided for @allTime.
  ///
  /// In en, this message translates to:
  /// **'Everything'**
  String get allTime;

  /// No description provided for @showMessages.
  ///
  /// In en, this message translates to:
  /// **'Show messages'**
  String get showMessages;

  /// No description provided for @csvExplainer.
  ///
  /// In en, this message translates to:
  /// **'Use your bank\'s CSV export. Map the columns once and preview before importing.'**
  String get csvExplainer;

  /// No description provided for @chooseFile.
  ///
  /// In en, this message translates to:
  /// **'Choose file'**
  String get chooseFile;

  /// No description provided for @firstRowIsHeader.
  ///
  /// In en, this message translates to:
  /// **'First row is a header'**
  String get firstRowIsHeader;

  /// No description provided for @columnN.
  ///
  /// In en, this message translates to:
  /// **'Column {n}'**
  String columnN(int n);

  /// No description provided for @dateColumn.
  ///
  /// In en, this message translates to:
  /// **'Date column'**
  String get dateColumn;

  /// No description provided for @dateFormat.
  ///
  /// In en, this message translates to:
  /// **'Date format'**
  String get dateFormat;

  /// No description provided for @merchantColumn.
  ///
  /// In en, this message translates to:
  /// **'Description column'**
  String get merchantColumn;

  /// No description provided for @amountColumn.
  ///
  /// In en, this message translates to:
  /// **'Amount column'**
  String get amountColumn;

  /// No description provided for @negativeIsSpend.
  ///
  /// In en, this message translates to:
  /// **'Purchases are negative numbers'**
  String get negativeIsSpend;

  /// No description provided for @currencyColumn.
  ///
  /// In en, this message translates to:
  /// **'Currency column'**
  String get currencyColumn;

  /// No description provided for @noCurrencyColumn.
  ///
  /// In en, this message translates to:
  /// **'None (all {currency})'**
  String noCurrencyColumn(String currency);

  /// No description provided for @csvRowErrors.
  ///
  /// In en, this message translates to:
  /// **'{count} rows could not be read'**
  String csvRowErrors(int count);

  /// No description provided for @importRows.
  ///
  /// In en, this message translates to:
  /// **'Import {count} rows'**
  String importRows(int count);

  /// No description provided for @cardsAutoCreated.
  ///
  /// In en, this message translates to:
  /// **'A card is added automatically the first time a message mentions it.'**
  String get cardsAutoCreated;

  /// No description provided for @deleteCard.
  ///
  /// In en, this message translates to:
  /// **'Delete card'**
  String get deleteCard;

  /// No description provided for @deleteCardQ.
  ///
  /// In en, this message translates to:
  /// **'Delete this card?'**
  String get deleteCardQ;

  /// No description provided for @deleteCardMessage.
  ///
  /// In en, this message translates to:
  /// **'All its transactions, statements and installments are deleted too.'**
  String get deleteCardMessage;

  /// No description provided for @asOf.
  ///
  /// In en, this message translates to:
  /// **'as of {when}'**
  String asOf(String when);

  /// No description provided for @creditLimit.
  ///
  /// In en, this message translates to:
  /// **'Credit limit'**
  String get creditLimit;

  /// No description provided for @statementDay.
  ///
  /// In en, this message translates to:
  /// **'Statement day'**
  String get statementDay;

  /// No description provided for @dueDay.
  ///
  /// In en, this message translates to:
  /// **'Due day'**
  String get dueDay;

  /// No description provided for @viewTransactions.
  ///
  /// In en, this message translates to:
  /// **'View transactions'**
  String get viewTransactions;

  /// No description provided for @statementsTitle.
  ///
  /// In en, this message translates to:
  /// **'Statements & due dates'**
  String get statementsTitle;

  /// No description provided for @noStatements.
  ///
  /// In en, this message translates to:
  /// **'No statements. Add one to get due-date reminders.'**
  String get noStatements;

  /// No description provided for @due.
  ///
  /// In en, this message translates to:
  /// **'Due'**
  String get due;

  /// No description provided for @minimumDue.
  ///
  /// In en, this message translates to:
  /// **'Minimum'**
  String get minimumDue;

  /// No description provided for @markPaid.
  ///
  /// In en, this message translates to:
  /// **'Mark as paid'**
  String get markPaid;

  /// No description provided for @markUnpaid.
  ///
  /// In en, this message translates to:
  /// **'Mark as unpaid'**
  String get markUnpaid;

  /// No description provided for @editCard.
  ///
  /// In en, this message translates to:
  /// **'Edit card'**
  String get editCard;

  /// No description provided for @nickname.
  ///
  /// In en, this message translates to:
  /// **'Nickname'**
  String get nickname;

  /// No description provided for @dayOfMonthHelp.
  ///
  /// In en, this message translates to:
  /// **'Day of month, 1–31'**
  String get dayOfMonthHelp;

  /// No description provided for @addStatement.
  ///
  /// In en, this message translates to:
  /// **'Add statement'**
  String get addStatement;

  /// No description provided for @totalDue.
  ///
  /// In en, this message translates to:
  /// **'Total due'**
  String get totalDue;

  /// No description provided for @dueDate.
  ///
  /// In en, this message translates to:
  /// **'Due date'**
  String get dueDate;

  /// No description provided for @installmentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Installments'**
  String get installmentsTitle;

  /// No description provided for @noInstallments.
  ///
  /// In en, this message translates to:
  /// **'No installments'**
  String get noInstallments;

  /// No description provided for @installmentsHelp.
  ///
  /// In en, this message translates to:
  /// **'Add purchases you pay in installments to see what is left.'**
  String get installmentsHelp;

  /// No description provided for @addInstallment.
  ///
  /// In en, this message translates to:
  /// **'Add installment plan'**
  String get addInstallment;

  /// No description provided for @remainingTotal.
  ///
  /// In en, this message translates to:
  /// **'Remaining on all plans'**
  String get remainingTotal;

  /// No description provided for @perMonth.
  ///
  /// In en, this message translates to:
  /// **'{amount} per month'**
  String perMonth(String amount);

  /// No description provided for @monthsProgress.
  ///
  /// In en, this message translates to:
  /// **'{paid}/{total} months'**
  String monthsProgress(int paid, int total);

  /// No description provided for @remaining.
  ///
  /// In en, this message translates to:
  /// **'Left'**
  String get remaining;

  /// No description provided for @deleteInstallmentQ.
  ///
  /// In en, this message translates to:
  /// **'Delete this installment plan?'**
  String get deleteInstallmentQ;

  /// No description provided for @totalAmount.
  ///
  /// In en, this message translates to:
  /// **'Total amount'**
  String get totalAmount;

  /// No description provided for @months.
  ///
  /// In en, this message translates to:
  /// **'Months'**
  String get months;

  /// No description provided for @firstInstallmentMonth.
  ///
  /// In en, this message translates to:
  /// **'First installment month'**
  String get firstInstallmentMonth;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @security.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get security;

  /// No description provided for @changePin.
  ///
  /// In en, this message translates to:
  /// **'Change PIN'**
  String get changePin;

  /// No description provided for @pinChanged.
  ///
  /// In en, this message translates to:
  /// **'PIN changed'**
  String get pinChanged;

  /// No description provided for @autoLock.
  ///
  /// In en, this message translates to:
  /// **'Auto-lock'**
  String get autoLock;

  /// No description provided for @immediately.
  ///
  /// In en, this message translates to:
  /// **'Immediately'**
  String get immediately;

  /// No description provided for @afterMinutes.
  ///
  /// In en, this message translates to:
  /// **'After {minutes} min'**
  String afterMinutes(int minutes);

  /// No description provided for @blockScreenshots.
  ///
  /// In en, this message translates to:
  /// **'Block screenshots'**
  String get blockScreenshots;

  /// No description provided for @blockScreenshotsHelp.
  ///
  /// In en, this message translates to:
  /// **'Android: blocks screenshots and recording. Both: hides the app in the app switcher.'**
  String get blockScreenshotsHelp;

  /// No description provided for @privacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get privacy;

  /// No description provided for @maxPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Maximum privacy'**
  String get maxPrivacy;

  /// No description provided for @maxPrivacyHelp.
  ///
  /// In en, this message translates to:
  /// **'Delete the app\'s copy of each message right after it becomes a transaction. Otherwise copies are kept 30 days. Your original messages are never touched.'**
  String get maxPrivacyHelp;

  /// No description provided for @dueReminders.
  ///
  /// In en, this message translates to:
  /// **'Due-date reminders'**
  String get dueReminders;

  /// No description provided for @dueRemindersHelp.
  ///
  /// In en, this message translates to:
  /// **'3 days before and on the due date. No amounts are shown.'**
  String get dueRemindersHelp;

  /// No description provided for @privacyPromiseTitle.
  ///
  /// In en, this message translates to:
  /// **'What leaves your phone'**
  String get privacyPromiseTitle;

  /// No description provided for @privacyPromiseBody.
  ///
  /// In en, this message translates to:
  /// **'Nothing. No internet permission in the Android release builds, no analytics, no crash reports. Backups and exports only go where you send them.'**
  String get privacyPromiseBody;

  /// No description provided for @dangerZone.
  ///
  /// In en, this message translates to:
  /// **'Danger zone'**
  String get dangerZone;

  /// No description provided for @deleteAllData.
  ///
  /// In en, this message translates to:
  /// **'Delete all data'**
  String get deleteAllData;

  /// No description provided for @deleteAllDataHelp.
  ///
  /// In en, this message translates to:
  /// **'Cards, transactions, messages and senders. Settings and PIN stay.'**
  String get deleteAllDataHelp;

  /// No description provided for @deleteAllDataQ.
  ///
  /// In en, this message translates to:
  /// **'Delete all data?'**
  String get deleteAllDataQ;

  /// No description provided for @deleteAllDataConfirm.
  ///
  /// In en, this message translates to:
  /// **'This cannot be undone. Make a backup first if you may need it.'**
  String get deleteAllDataConfirm;

  /// No description provided for @allDataDeleted.
  ///
  /// In en, this message translates to:
  /// **'All data deleted'**
  String get allDataDeleted;

  /// No description provided for @categoriesTitle.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categoriesTitle;

  /// No description provided for @categoriesHelp.
  ///
  /// In en, this message translates to:
  /// **'Change a transaction\'s category and tick \"Always use this category\" to teach the app a merchant.'**
  String get categoriesHelp;

  /// No description provided for @addCategory.
  ///
  /// In en, this message translates to:
  /// **'Add category'**
  String get addCategory;

  /// No description provided for @customCategory.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get customCategory;

  /// No description provided for @nameArabic.
  ///
  /// In en, this message translates to:
  /// **'Name in Arabic'**
  String get nameArabic;

  /// No description provided for @nameEnglish.
  ///
  /// In en, this message translates to:
  /// **'Name in English'**
  String get nameEnglish;

  /// No description provided for @backupTitle.
  ///
  /// In en, this message translates to:
  /// **'Backup & export'**
  String get backupTitle;

  /// No description provided for @backupExplainer.
  ///
  /// In en, this message translates to:
  /// **'Backups are encrypted with a passphrase you choose. Keep it safe: without it the backup cannot be opened, by you or anyone.'**
  String get backupExplainer;

  /// No description provided for @createBackup.
  ///
  /// In en, this message translates to:
  /// **'Create encrypted backup'**
  String get createBackup;

  /// No description provided for @createBackupHelp.
  ///
  /// In en, this message translates to:
  /// **'Then save it to Files, Drive or anywhere you like'**
  String get createBackupHelp;

  /// No description provided for @restoreBackup.
  ///
  /// In en, this message translates to:
  /// **'Restore from backup'**
  String get restoreBackup;

  /// No description provided for @restoreBackupHelp.
  ///
  /// In en, this message translates to:
  /// **'Replaces everything in the app'**
  String get restoreBackupHelp;

  /// No description provided for @exportCsv.
  ///
  /// In en, this message translates to:
  /// **'Export transactions (CSV)'**
  String get exportCsv;

  /// No description provided for @exportCsvHelp.
  ///
  /// In en, this message translates to:
  /// **'Not encrypted. Opens in Excel or Sheets.'**
  String get exportCsvHelp;

  /// No description provided for @choosePassphrase.
  ///
  /// In en, this message translates to:
  /// **'Choose a backup passphrase'**
  String get choosePassphrase;

  /// No description provided for @enterPassphrase.
  ///
  /// In en, this message translates to:
  /// **'Backup passphrase'**
  String get enterPassphrase;

  /// No description provided for @passphrase.
  ///
  /// In en, this message translates to:
  /// **'Passphrase'**
  String get passphrase;

  /// No description provided for @confirmPassphrase.
  ///
  /// In en, this message translates to:
  /// **'Confirm passphrase'**
  String get confirmPassphrase;

  /// No description provided for @passphraseWarning.
  ///
  /// In en, this message translates to:
  /// **'At least 8 characters. It cannot be recovered.'**
  String get passphraseWarning;

  /// No description provided for @passphraseTooShort.
  ///
  /// In en, this message translates to:
  /// **'At least 8 characters'**
  String get passphraseTooShort;

  /// No description provided for @passphraseMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passphrases don\'t match'**
  String get passphraseMismatch;

  /// No description provided for @restoreQ.
  ///
  /// In en, this message translates to:
  /// **'Replace all data with this backup?'**
  String get restoreQ;

  /// No description provided for @restoreWarning.
  ///
  /// In en, this message translates to:
  /// **'Everything currently in the app is replaced.'**
  String get restoreWarning;

  /// No description provided for @restoreDone.
  ///
  /// In en, this message translates to:
  /// **'Backup restored'**
  String get restoreDone;

  /// No description provided for @wrongPassphrase.
  ///
  /// In en, this message translates to:
  /// **'Wrong passphrase, or the file was changed.'**
  String get wrongPassphrase;

  /// No description provided for @notABackup.
  ///
  /// In en, this message translates to:
  /// **'This is not a CardGuardian backup.'**
  String get notABackup;

  /// No description provided for @auditTitle.
  ///
  /// In en, this message translates to:
  /// **'Security log'**
  String get auditTitle;

  /// No description provided for @auditHelp.
  ///
  /// In en, this message translates to:
  /// **'Local record of imports, exports, settings changes and failed unlocks. It never contains amounts or message text.'**
  String get auditHelp;

  /// No description provided for @reminderToday.
  ///
  /// In en, this message translates to:
  /// **'{card}: payment due today'**
  String reminderToday(String card);

  /// No description provided for @reminderSoon.
  ///
  /// In en, this message translates to:
  /// **'{card}: payment due in {days} days'**
  String reminderSoon(String card, int days);

  /// No description provided for @reminderBody.
  ///
  /// In en, this message translates to:
  /// **'Open CardGuardian for details.'**
  String get reminderBody;

  /// No description provided for @deviceCompromisedWarning.
  ///
  /// In en, this message translates to:
  /// **'This phone looks rooted or jailbroken. Other apps may be able to read your data.'**
  String get deviceCompromisedWarning;

  /// No description provided for @permissionRestrictedHint.
  ///
  /// In en, this message translates to:
  /// **'Not allowed. If Android says this is a restricted setting: Settings → Apps → CardGuardian → ⋮ → Allow restricted settings, then try again.'**
  String get permissionRestrictedHint;

  /// No description provided for @exportExcel.
  ///
  /// In en, this message translates to:
  /// **'Export Excel (import template)'**
  String get exportExcel;

  /// No description provided for @exportExcelHelp.
  ///
  /// In en, this message translates to:
  /// **'Statements, payments and purchases in the credit-card import template'**
  String get exportExcelHelp;

  /// No description provided for @exportExcelExplainer.
  ///
  /// In en, this message translates to:
  /// **'Card nicknames must match your cards in the other app exactly. Leave one empty to use the suggestion shown.'**
  String get exportExcelExplainer;

  /// No description provided for @paidBy.
  ///
  /// In en, this message translates to:
  /// **'Paid by'**
  String get paidBy;

  /// No description provided for @paidByHelp.
  ///
  /// In en, this message translates to:
  /// **'Written in the Payments sheet, e.g. Amr'**
  String get paidByHelp;

  /// No description provided for @cardNicknameFor.
  ///
  /// In en, this message translates to:
  /// **'Nickname for {card}'**
  String cardNicknameFor(String card);

  /// No description provided for @export.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get export;

  /// No description provided for @exportExcelDone.
  ///
  /// In en, this message translates to:
  /// **'Exported {purchases} purchases, {payments} payments, {statements} statements'**
  String exportExcelDone(int purchases, int payments, int statements);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
