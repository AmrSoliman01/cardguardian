// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'كارد جارديان';

  @override
  String get ok => 'تمام';

  @override
  String get cancel => 'إلغاء';

  @override
  String get save => 'حفظ';

  @override
  String get delete => 'حذف';

  @override
  String get edit => 'تعديل';

  @override
  String get add => 'إضافة';

  @override
  String get next => 'التالي';

  @override
  String get enable => 'تفعيل';

  @override
  String get notNow => 'مش دلوقتي';

  @override
  String get dismiss => 'إخفاء';

  @override
  String get allow => 'سماح';

  @override
  String get manage => 'إدارة';

  @override
  String get required => 'مطلوب';

  @override
  String get saved => 'اتحفظ';

  @override
  String get copied => 'اتنسخ';

  @override
  String get preview => 'معاينة';

  @override
  String get restore => 'استرجاع';

  @override
  String get approve => 'أضفها';

  @override
  String get ignore => 'تجاهل';

  @override
  String get navDashboard => 'الملخص';

  @override
  String get navTransactions => 'المعاملات';

  @override
  String get navReview => 'مراجعة';

  @override
  String get navMore => 'المزيد';

  @override
  String get sectionMoney => 'الفلوس';

  @override
  String get sectionSources => 'الرسايل والاستيراد';

  @override
  String get sectionApp => 'التطبيق';

  @override
  String get lockNow => 'اقفل دلوقتي';

  @override
  String get welcomeTitle => 'بيانات كروتك بتفضل على موبايلك بس';

  @override
  String get privacyPoint1 => 'مفيش سيرفرات ولا سحابة ولا إعلانات ولا تتبع.';

  @override
  String get privacyPoint2 =>
      'انت اللي بتختار بالظبط أنهي رسايل بنك التطبيق يقراها.';

  @override
  String get privacyPoint3 =>
      'كل حاجة متشفرة بمفتاح عمره ما بيخرج من الموبايل.';

  @override
  String get privacyPoint4 => 'رسايلك الأصلية عمرها ما بتتعدل ولا تتمسح.';

  @override
  String get createPin => 'اعمل رقم سري';

  @override
  String get confirmPin => 'اكتب الرقم السري تاني';

  @override
  String get pinHint => 'من 4 لـ 8 أرقام. بيحمي التطبيق حتى لو الموبايل مفتوح.';

  @override
  String get pinMismatch => 'الرقمين مش زي بعض. جرب تاني.';

  @override
  String get biometricsTitle => 'تفتح ببصمة الوش أو الصباع؟';

  @override
  String get biometricsSubtitle => 'الرقم السري هيفضل شغال برضه.';

  @override
  String get enableBiometricsReason => 'أكد عشان تستخدم البصمة مع كارد جارديان';

  @override
  String get chooseBanksTitle => 'التطبيق يقرا رسايل أنهي بنوك؟';

  @override
  String get chooseBanksSubtitle =>
      'هيقرا من الأسماء دي بس. أي رسالة تانية بتتجاهل ومش بتتخزن.';

  @override
  String get chooseBanksFootnote =>
      'تقدر بعدين من \"المصادر\" تغير الأسماء، أو تحط كلمة لازم تكون في الرسالة، أو تخلي كل رسالة تستنى موافقتك.';

  @override
  String get finishSetup => 'ابدأ';

  @override
  String senderLabel(String sender) {
    return 'اسم المرسل: $sender';
  }

  @override
  String get editSender => 'تعديل المرسل';

  @override
  String get addSender => 'إضافة مرسل';

  @override
  String get senderHelp => 'زي ما بيظهر في الرسايل بالظبط، مثلا ABK-Egypt';

  @override
  String get enterPin => 'اكتب الرقم السري';

  @override
  String get unlockReason => 'افتح كارد جارديان';

  @override
  String get useBiometrics => 'استخدم البصمة';

  @override
  String pinWrong(int attempts) {
    return 'رقم غلط. فاضل $attempts محاولات.';
  }

  @override
  String pinLockedOut(int seconds) {
    return 'محاولات كتير. جرب تاني بعد $seconds ثانية.';
  }

  @override
  String get biometricsUnavailable => 'البصمة مش متاحة على الجهاز ده.';

  @override
  String get previousMonth => 'الشهر اللي فات';

  @override
  String get nextMonth => 'الشهر الجاي';

  @override
  String get addTransaction => 'إضافة معاملة';

  @override
  String get editTransaction => 'تعديل المعاملة';

  @override
  String get noCardsTitle => 'مفيش كروت لسه';

  @override
  String get noCardsMessage =>
      'الكروت بتظهر لوحدها مع أول رسالة من البنك. اختار أسماء البنوك، أو الصق كام رسالة عشان تبدأ.';

  @override
  String get spentThisMonth => 'صرفت الشهر ده';

  @override
  String transactionsCount(int count) {
    return '$count معاملة';
  }

  @override
  String refundsAmount(String amount) {
    return 'مرتجعات $amount';
  }

  @override
  String paymentsAmount(String amount) {
    return 'سداد $amount';
  }

  @override
  String get cardsTitle => 'الكروت';

  @override
  String get availableLimit => 'الحد المتاح';

  @override
  String get upcomingDues => 'مواعيد السداد الجاية';

  @override
  String get overdue => 'متأخر';

  @override
  String get estimated => 'تقديري';

  @override
  String inDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'بعد $days يوم',
      one: 'بكره',
      zero: 'النهارده',
    );
    return '$_temp0';
  }

  @override
  String get byCategory => 'حسب التصنيف';

  @override
  String get uncategorized => 'من غير تصنيف';

  @override
  String get dailySpending => 'الصرف اليومي';

  @override
  String get topMerchants => 'أكتر أماكن صرفت فيها';

  @override
  String get noSpendingThisMonth => 'مفيش صرف متسجل الشهر ده';

  @override
  String get searchMerchant => 'دور على مكان الشراء';

  @override
  String get allCards => 'كل الكروت';

  @override
  String get allTypes => 'كل الأنواع';

  @override
  String get allCategories => 'كل التصنيفات';

  @override
  String get noTransactions => 'مفيش معاملات';

  @override
  String get typePurchase => 'شراء';

  @override
  String get typeRefund => 'استرداد';

  @override
  String get typePayment => 'سداد';

  @override
  String get typeFee => 'رسوم';

  @override
  String get typeInterest => 'فوايد';

  @override
  String get typeCash => 'سحب كاش';

  @override
  String get typeInstallment => 'قسط';

  @override
  String get typeReversal => 'إلغاء عملية';

  @override
  String get typeDeclined => 'مرفوضة';

  @override
  String get card => 'الكارت';

  @override
  String get otherCard => 'كارت تاني…';

  @override
  String get bank => 'البنك';

  @override
  String get last4 => 'آخر 4 أرقام';

  @override
  String get last4Invalid => 'اكتب 4 أرقام';

  @override
  String get type => 'النوع';

  @override
  String get amount => 'المبلغ';

  @override
  String get amountInvalid => 'اكتب مبلغ صحيح';

  @override
  String get currency => 'العملة';

  @override
  String get currencyInvalid => '3 حروف، مثلا EGP';

  @override
  String get merchant => 'مكان الشراء';

  @override
  String get dateTime => 'التاريخ والوقت';

  @override
  String get category => 'التصنيف';

  @override
  String get rememberMerchantCategory => 'استخدم التصنيف ده دايما للمكان ده';

  @override
  String get note => 'ملاحظة';

  @override
  String sourceInfo(String source, String parser) {
    return 'المصدر: $source · اتقرا بـ $parser';
  }

  @override
  String get deleteTransactionQ => 'تمسح المعاملة دي؟';

  @override
  String get approveAll => 'أضف الكل';

  @override
  String approvedCount(int count) {
    return 'اتضاف $count';
  }

  @override
  String get reviewEmptyTitle => 'مفيش حاجة تحتاج مراجعة';

  @override
  String get reviewEmptyMessage =>
      'هنا بتظهر رسايل البنوك اللي مختار لها \"اسألني الأول\"، والرسايل اللي التطبيق مقدرش يفهمها.';

  @override
  String get notUnderstood => 'مش مفهومة';

  @override
  String get waitingApproval => 'مستنية موافقتك';

  @override
  String get enterManually => 'دخلها بإيدك';

  @override
  String sourceName(String source) {
    String _temp0 = intl.Intl.selectLogic(source, {
      'sms': 'رسالة SMS',
      'notification': 'إشعار',
      'shortcut': 'اختصار',
      'share': 'مشاركة',
      'paste': 'لصق',
      'csv': 'CSV',
      'other': 'يدوي',
    });
    return '$_temp0';
  }

  @override
  String get sourcesTitle => 'المصادر';

  @override
  String get sourcesSubtitle => 'أنهي مرسلين ورسايل التطبيق يقراها';

  @override
  String get sendersExplainer =>
      'التطبيق بيقرا الرسايل من المرسلين اللي تحت دول بس. اقفل أي واحد عشان يبطل يقرا منه. أي رسالة من حد تاني بتتشال قبل ما يتخزن منها أي حاجة.';

  @override
  String get allowedSenders => 'المرسلين المسموح بيهم';

  @override
  String get noSenders => 'مفيش مرسلين لسه. مفيش حاجة هتتقرا تلقائي.';

  @override
  String get modeAuto => 'يضيف تلقائي';

  @override
  String get modeReview => 'اسألني الأول';

  @override
  String get modeAutoHelp => 'المعاملة بتتضاف أول ما الرسالة توصل.';

  @override
  String get modeReviewHelp =>
      'كل رسالة بتستنى في \"مراجعة\" لحد ما تضيفها أو تتجاهلها.';

  @override
  String filterContains(String text) {
    return 'بس اللي فيها \"$text\"';
  }

  @override
  String get senderId => 'اسم المرسل';

  @override
  String get mustContainLabel => 'بس الرسايل اللي فيها (اختياري)';

  @override
  String get mustContainHelp =>
      'مثلا Credit Card# عشان يتجاهل رسايل الـ OTP والعروض';

  @override
  String get smsSourceTitle => 'رسايل SMS على الموبايل ده';

  @override
  String get smsAllowed => 'قراءة الرسايل شغالة';

  @override
  String get smsNotAllowed => 'قراءة الرسايل مقفولة';

  @override
  String get smsExplainer =>
      'الرسايل الجديدة من المرسلين المسموح بيهم بتتضاف أول ما توصل.';

  @override
  String get smsHistoryTitle => 'استيراد الرسايل القديمة';

  @override
  String get smsHistorySubtitle =>
      'اختار المرسلين، وبعدين علّم على الرسايل اللي عايزها بالظبط';

  @override
  String get notificationSourceTitle => 'إشعارات البنك';

  @override
  String get notificationsAllowed => 'قراءة الإشعارات شغالة';

  @override
  String get notificationsNotAllowed => 'قراءة الإشعارات مقفولة';

  @override
  String get notificationsExplainer =>
      'بيقرا إشعارات الرسايل من التطبيقات اللي تعلّم عليها، ومن المرسلين المسموح بيهم بس.';

  @override
  String get notificationAppsEmpty =>
      'التطبيقات بتظهر هنا بعد ما يجي منها إشعار. تطبيق الرسايل بيظهر الأول.';

  @override
  String get shortcutSourceTitle => 'اختصارات الآيفون';

  @override
  String get shortcutSetupTitle => 'إعداد الاستيراد التلقائي';

  @override
  String get shortcutSetupSubtitle =>
      'أوتوميشن في Shortcuts بتتعمل مرة واحدة وبتبعت رسايل البنك';

  @override
  String get manualSourcesTitle => 'يدوي';

  @override
  String get pasteImportTitle => 'لصق رسايل';

  @override
  String get pasteImportSubtitle => 'انسخ الرسايل من الصندوق والصقها هنا';

  @override
  String get csvImportTitle => 'استيراد ملف CSV';

  @override
  String get iosGuideIntro =>
      'الآيفون مش بيسمح لأي تطبيق يقرا الـ SMS. بدل كده أوتوميشن في Shortcuts بتبعت كل رسالة بنك لكارد جارديان. بتشتغل على الموبايل بس ومش بتبعت حاجة لأي مكان.';

  @override
  String get iosStep1 => 'افتح تطبيق Shortcuts، روح على Automation، ودوس +.';

  @override
  String get iosStep2 => 'اختار Message.';

  @override
  String get iosStep3 =>
      'في \"Message Contains\" اكتب Credit Card# (أو الكلمة اللي بنكك بيستخدمها دايما).';

  @override
  String get iosStep4 => 'اختار \"Run Immediately\"، وبعدين Next.';

  @override
  String get iosStep5 =>
      'دوس \"New Blank Automation\"، وبعدين Add Action، دور على CardGuardian واختار \"Add Bank Message\".';

  @override
  String get iosStep6 =>
      'خلي Message = Shortcut Input → Content، و Sender = Shortcut Input → Sender.';

  @override
  String get iosStep7 =>
      'دوس Done. رسايل البنك الجديدة بتتحفظ متشفرة وبتتضاف أول ما تفتح التطبيق.';

  @override
  String copyFilterText(String text) {
    return 'انسخ \"$text\"';
  }

  @override
  String get iosShareSheetTitle => 'من قائمة المشاركة';

  @override
  String get iosShareSheetBody =>
      'اعمل shortcut مفعل فيه \"Show in Share Sheet\" (المدخل: Text) وفيه أكشن \"Add Bank Message\". بعدها حدد نص الرسالة، دوس Share، واختار الـ shortcut ده.';

  @override
  String get iosHistoryTitle => 'الرسايل القديمة';

  @override
  String get iosHistoryBody =>
      'الآيفون مفيهوش طريقة تصدّر رسايل كتير مرة واحدة. انسخها واستخدم \"لصق رسايل\"، وده بياخد رسايل كتير مرة واحدة.';

  @override
  String get iosPrivacyNote =>
      'الأوتوميشن بتدي نص الرسالة لكارد جارديان بس، على الموبايل ده. والتطبيق بيتجاهل الرسايل من أي مرسل تاني.';

  @override
  String get pasteExplainer =>
      'الصق رسالة أو رسايل كتير من البنك. هتشوف التطبيق فهم إيه وتختار بالظبط أنهي تتضاف.';

  @override
  String get detectAutomatically => 'اكتشاف تلقائي';

  @override
  String get pasteHint => 'الصق الرسايل هنا';

  @override
  String get pasteFromClipboard => 'لصق';

  @override
  String previewCounts(int total, int parsed, int selected) {
    return '$total رسالة · اتفهم $parsed · متعلم على $selected';
  }

  @override
  String get selectAll => 'تحديد الكل';

  @override
  String get selectNone => 'إلغاء التحديد';

  @override
  String get alreadyAdded => 'موجودة قبل كده';

  @override
  String get notATransaction => 'مش معاملة';

  @override
  String get notUnderstoodWillReview => 'مش مفهومة: هتروح للمراجعة لو اخترتها';

  @override
  String importSelected(int count) {
    return 'استيراد $count';
  }

  @override
  String get importDone => 'الاستيراد خلص';

  @override
  String importReport(int added, int duplicates, int review, int ignored) {
    return 'اتضاف: $added\nموجود قبل كده: $duplicates\nمحتاج مراجعة: $review\nاتجاهل: $ignored';
  }

  @override
  String autoImportSummary(int added, int review) {
    return '$added معاملة جديدة، و$review محتاجين مراجعة';
  }

  @override
  String get smsPermissionNeeded =>
      'محتاج صلاحية قراءة الرسايل عشان يقرا القديم.';

  @override
  String get smsHistoryExplainer =>
      'اختار المرسلين. هيتقرا رسايلهم بس، وبعدين تعلّم على اللي عايز تضيفه.';

  @override
  String messagesCount(int count) {
    return '$count رسالة';
  }

  @override
  String get howFarBack => 'لحد إمتى';

  @override
  String lastMonths(int months) {
    return 'آخر $months شهور';
  }

  @override
  String get allTime => 'كل حاجة';

  @override
  String get showMessages => 'اعرض الرسايل';

  @override
  String get csvExplainer =>
      'استخدم ملف CSV من البنك. حدد الأعمدة وشوف معاينة قبل الاستيراد.';

  @override
  String get chooseFile => 'اختار ملف';

  @override
  String get firstRowIsHeader => 'أول صف عناوين';

  @override
  String columnN(int n) {
    return 'عمود $n';
  }

  @override
  String get dateColumn => 'عمود التاريخ';

  @override
  String get dateFormat => 'شكل التاريخ';

  @override
  String get merchantColumn => 'عمود الوصف';

  @override
  String get amountColumn => 'عمود المبلغ';

  @override
  String get negativeIsSpend => 'المشتريات بالسالب';

  @override
  String get currencyColumn => 'عمود العملة';

  @override
  String noCurrencyColumn(String currency) {
    return 'مفيش (كله $currency)';
  }

  @override
  String csvRowErrors(int count) {
    return '$count صف مقدرش يتقرا';
  }

  @override
  String importRows(int count) {
    return 'استيراد $count صف';
  }

  @override
  String get cardsAutoCreated => 'الكارت بيتضاف لوحده أول مرة رسالة تذكره.';

  @override
  String get deleteCard => 'مسح الكارت';

  @override
  String get deleteCardQ => 'تمسح الكارت ده؟';

  @override
  String get deleteCardMessage => 'كل معاملاته وكشوفاته وأقساطه هتتمسح كمان.';

  @override
  String asOf(String when) {
    return 'لحد $when';
  }

  @override
  String get creditLimit => 'الحد الائتماني';

  @override
  String get statementDay => 'يوم الكشف';

  @override
  String get dueDay => 'يوم السداد';

  @override
  String get viewTransactions => 'عرض المعاملات';

  @override
  String get statementsTitle => 'الكشوفات ومواعيد السداد';

  @override
  String get noStatements => 'مفيش كشوفات. ضيف واحد عشان يفكرك بميعاد السداد.';

  @override
  String get due => 'الاستحقاق';

  @override
  String get minimumDue => 'الحد الأدنى';

  @override
  String get markPaid => 'اتدفع';

  @override
  String get markUnpaid => 'لسه مدفعش';

  @override
  String get editCard => 'تعديل الكارت';

  @override
  String get nickname => 'اسم مميز';

  @override
  String get dayOfMonthHelp => 'يوم في الشهر من 1 لـ 31';

  @override
  String get addStatement => 'إضافة كشف';

  @override
  String get totalDue => 'المطلوب سداده';

  @override
  String get dueDate => 'ميعاد السداد';

  @override
  String get installmentsTitle => 'التقسيط';

  @override
  String get noInstallments => 'مفيش أقساط';

  @override
  String get installmentsHelp =>
      'ضيف المشتريات اللي بتقسطها عشان تشوف فاضل كام.';

  @override
  String get addInstallment => 'إضافة تقسيط';

  @override
  String get remainingTotal => 'الباقي في كل الأقساط';

  @override
  String perMonth(String amount) {
    return '$amount في الشهر';
  }

  @override
  String monthsProgress(int paid, int total) {
    return '$paid/$total شهور';
  }

  @override
  String get remaining => 'فاضل';

  @override
  String get deleteInstallmentQ => 'تمسح التقسيط ده؟';

  @override
  String get totalAmount => 'المبلغ الكلي';

  @override
  String get months => 'عدد الشهور';

  @override
  String get firstInstallmentMonth => 'شهر أول قسط';

  @override
  String get settingsTitle => 'الإعدادات';

  @override
  String get appearance => 'الشكل';

  @override
  String get language => 'اللغة';

  @override
  String get theme => 'الثيم';

  @override
  String get themeSystem => 'زي الموبايل';

  @override
  String get themeLight => 'فاتح';

  @override
  String get themeDark => 'غامق';

  @override
  String get security => 'الأمان';

  @override
  String get changePin => 'تغيير الرقم السري';

  @override
  String get pinChanged => 'الرقم السري اتغير';

  @override
  String get autoLock => 'قفل تلقائي';

  @override
  String get immediately => 'على طول';

  @override
  String afterMinutes(int minutes) {
    return 'بعد $minutes دقيقة';
  }

  @override
  String get blockScreenshots => 'منع لقطات الشاشة';

  @override
  String get blockScreenshotsHelp =>
      'أندرويد: بيمنع لقطات الشاشة والتسجيل. الاتنين: بيخفي التطبيق في قائمة التطبيقات المفتوحة.';

  @override
  String get privacy => 'الخصوصية';

  @override
  String get maxPrivacy => 'أقصى خصوصية';

  @override
  String get maxPrivacyHelp =>
      'امسح نسخة التطبيق من كل رسالة أول ما تتحول لمعاملة. غير كده النسخ بتفضل 30 يوم. رسايلك الأصلية عمرها ما بتتلمس.';

  @override
  String get dueReminders => 'تذكير بميعاد السداد';

  @override
  String get dueRemindersHelp =>
      'قبلها بـ 3 أيام وفي يومها. من غير ما يظهر أي مبلغ.';

  @override
  String get privacyPromiseTitle => 'إيه اللي بيخرج من موبايلك';

  @override
  String get privacyPromiseBody =>
      'ولا حاجة. نسخ أندرويد النهائية مفيهاش صلاحية إنترنت، ومفيش تحليلات ولا تقارير أعطال. الـ backup والتصدير بيروحوا بس للمكان اللي انت تبعتهم له.';

  @override
  String get dangerZone => 'منطقة خطر';

  @override
  String get deleteAllData => 'امسح كل البيانات';

  @override
  String get deleteAllDataHelp =>
      'الكروت والمعاملات والرسايل والمرسلين. الإعدادات والرقم السري بيفضلوا.';

  @override
  String get deleteAllDataQ => 'تمسح كل البيانات؟';

  @override
  String get deleteAllDataConfirm =>
      'مفيش رجوع في الخطوة دي. اعمل backup الأول لو ممكن تحتاجها.';

  @override
  String get allDataDeleted => 'كل البيانات اتمسحت';

  @override
  String get categoriesTitle => 'التصنيفات';

  @override
  String get categoriesHelp =>
      'غير تصنيف أي معاملة وعلّم على \"استخدم التصنيف ده دايما\" عشان التطبيق يتعلم المكان.';

  @override
  String get addCategory => 'إضافة تصنيف';

  @override
  String get customCategory => 'مخصص';

  @override
  String get nameArabic => 'الاسم بالعربي';

  @override
  String get nameEnglish => 'الاسم بالإنجليزي';

  @override
  String get backupTitle => 'الـ Backup والتصدير';

  @override
  String get backupExplainer =>
      'الـ backup بيتشفر بكلمة سر انت بتختارها. احفظها كويس: من غيرها الـ backup مش هيتفتح، لا ليك ولا لحد.';

  @override
  String get createBackup => 'اعمل backup مشفر';

  @override
  String get createBackupHelp => 'وبعدين احفظه في Files أو Drive أو أي مكان';

  @override
  String get restoreBackup => 'استرجاع من backup';

  @override
  String get restoreBackupHelp => 'بيستبدل كل حاجة في التطبيق';

  @override
  String get exportCsv => 'تصدير المعاملات (CSV)';

  @override
  String get exportCsvHelp => 'مش متشفر. بيتفتح في Excel أو Sheets.';

  @override
  String get choosePassphrase => 'اختار كلمة سر للـ backup';

  @override
  String get enterPassphrase => 'كلمة سر الـ backup';

  @override
  String get passphrase => 'كلمة السر';

  @override
  String get confirmPassphrase => 'أكد كلمة السر';

  @override
  String get passphraseWarning =>
      '8 حروف على الأقل. مش هينفع تسترجعها لو نسيتها.';

  @override
  String get passphraseTooShort => '8 حروف على الأقل';

  @override
  String get passphraseMismatch => 'الكلمتين مش زي بعض';

  @override
  String get restoreQ => 'تستبدل كل البيانات بالـ backup ده؟';

  @override
  String get restoreWarning => 'كل اللي في التطبيق دلوقتي هيتشال.';

  @override
  String get restoreDone => 'الـ backup اترجع';

  @override
  String get wrongPassphrase => 'كلمة السر غلط، أو الملف اتغير.';

  @override
  String get notABackup => 'ده مش backup بتاع كارد جارديان.';

  @override
  String get auditTitle => 'سجل الأمان';

  @override
  String get auditHelp =>
      'سجل محلي للاستيراد والتصدير وتغيير الإعدادات ومحاولات الفتح الغلط. عمره ما بيكون فيه مبالغ أو نص رسايل.';

  @override
  String reminderToday(String card) {
    return '$card: ميعاد السداد النهارده';
  }

  @override
  String reminderSoon(String card, int days) {
    return '$card: ميعاد السداد بعد $days أيام';
  }

  @override
  String get reminderBody => 'افتح كارد جارديان للتفاصيل.';

  @override
  String get deviceCompromisedWarning =>
      'الموبايل ده شكله متعمله root أو jailbreak. ممكن تطبيقات تانية تقدر تقرا بياناتك.';

  @override
  String get permissionRestrictedHint =>
      'لم يتم السماح. لو أندرويد قال إنه إعداد مقيّد: الإعدادات ← التطبيقات ← CardGuardian ← ⋮ ← السماح بالإعدادات المقيّدة، وبعدين جرّب تاني.';

  @override
  String get exportExcel => 'تصدير Excel (نموذج الاستيراد)';

  @override
  String get exportExcelHelp =>
      'الكشوف والدفعات والمشتريات بنفس نموذج استيراد البطاقات';

  @override
  String get exportExcelExplainer =>
      'الاسم المميز لكل بطاقة لازم يكون نفس اسمها بالظبط في البرنامج التاني. سيبه فاضي عشان يستخدم الاقتراح الظاهر.';

  @override
  String get paidBy => 'الدافع';

  @override
  String get paidByHelp => 'بيتكتب في شيت الدفعات، مثلاً Amr';

  @override
  String cardNicknameFor(String card) {
    return 'الاسم المميز لـ $card';
  }

  @override
  String get export => 'تصدير';

  @override
  String exportExcelDone(int purchases, int payments, int statements) {
    return 'تم تصدير $purchases مشتريات و$payments دفعات و$statements كشوف';
  }
}
