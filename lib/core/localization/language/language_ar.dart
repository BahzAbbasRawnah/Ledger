import 'languages.dart';

class LanguageAr extends Languages {
  // General
  @override
  String get appName => 'دفتر الحسابات';
  @override
  String get ok => 'موافق';
  @override
  String get cancel => 'إلغاء';
  @override
  String get save => 'حفظ';
  @override
  String get delete => 'حذف';
  @override
  String get edit => 'تعديل';
  @override
  String get search => 'بحث';
  @override
  String get loading => 'جاري التحميل...';
  @override
  String get error => 'خطأ';
  @override
  String get success => 'نجاح';
  @override
  String get warning => 'تحذير';
  @override
  String get info => 'معلومات';
  @override
  String get retry => 'إعادة المحاولة';
  @override
  String get next => 'التالي';
  @override
  String get back => 'رجوع';
  @override
  String get done => 'تم';
  @override
  String get confirm => 'تأكيد';
  @override
  String get yes => 'نعم';
  @override
  String get no => 'لا';
  @override
  String get welcome => 'مرحباً';
  @override
  String get user => 'مستخدم';
  @override
  String get quickActions => 'إجراءات سريعة';
  @override
  String get recentClients => 'العملاء الأخيرون';
  @override
  String get recentTransactions => 'المعاملات الأخيرة';
  @override
  String get notProvided => 'غير متوفر';
  @override
  String get notSet => 'غير محدد';
  @override
  String get createdAt => 'تاريخ الإنشاء';
  @override
  String get updatedAt => 'تاريخ التحديث';
  @override
  String get calculating => 'جاري الحساب...';
  @override
  String get optional => 'اختياري';
  @override
  String get dashboard => 'لوحة التحكم';
  @override
  String get dateRange => 'نطاق التاريخ';
  @override
  String get clearFilters => 'مسح الفلاتر';
  @override
  String get filterTransactions => 'تصفية المعاملات';
  @override
  String get apply => 'تطبيق';
  @override
  String get viewFullSize => 'عرض بالحجم الكامل';
  @override
  String get clientNotFound => 'العميل غير موجود';
  @override
  String get transactionNotFound => 'المعاملة غير موجودة';
  @override
  String get generateReportToSeeResults => 'قم بإنشاء تقرير لرؤية النتائج';
  @override
  String get ceiling => 'السقف';
  @override
  String get selectClientFirst => 'الرجاء اختيار عميل أولاً';
  @override
  String get amountRequired => 'المبلغ مطلوب';
  @override
  String get invalidAmount => 'مبلغ غير صالح';
  @override
  String get businessNameRequired => 'اسم العمل مطلوب';
  @override
  String get businessPhoneRequired => 'هاتف العمل مطلوب';
  @override
  String get businessInfoUpdated => 'تم تحديث معلومات العمل بنجاح';
  @override
  String get changePhoto => 'تغيير الصورة';
  @override
  String get deleteClient => 'حذف العميل';
  @override
  String get deleteTransaction => 'حذف المعاملة';
  @override
  String get notNow => 'ليس الآن';
  @override
  String get subscribe => 'اشتراك';
  @override
  String get subscriptionPrice => 'الاشتراك الشهري: \$9.99';
  @override
  String get syncAcrossDevices => 'المزامنة بين الأجهزة المتعددة';
  @override
  String get clientAccess => 'وصول العملاء إلى كشوفاتهم';
  @override
  String get automaticBackup => 'نسخ احتياطي تلقائي على السحابة';
  @override
  String get prioritySupport => 'دعم عملاء ذو أولوية';
  @override
  String get premiumVersion => 'النسخة المميزة';
  @override
  String get thanksForYourSupport => 'شكراً لدعمك!';
  @override
  String get restoreConfirmation =>
      'هل أنت متأكد من استعادة البيانات؟ سيؤدي ذلك إلى استبدال بياناتك الحالية.';
  @override
  String get logoutConfirmation => 'هل أنت متأكد من تسجيل الخروج؟';

  // Auth
  @override
  String get login => 'تسجيل الدخول';
  @override
  String get register => 'إنشاء حساب';
  @override
  String get phoneNumber => 'رقم الهاتف';
  @override
  String get password => 'كلمة المرور';
  @override
  String get confirmPassword => 'تأكيد كلمة المرور';
  @override
  String get forgotPassword => 'نسيت كلمة المرور؟';
  @override
  String get dontHaveAccount => 'ليس لديك حساب؟ إنشاء حساب';
  @override
  String get alreadyHaveAccount => 'لديك حساب بالفعل؟ تسجيل الدخول';
  @override
  String get verifyPhone => 'تأكيد رقم الهاتف';
  @override
  String get verificationCode => 'رمز التحقق';
  @override
  String get resendCode => 'إعادة إرسال الرمز';
  @override
  String get invalidPhoneNumber => 'رقم هاتف غير صالح';
  @override
  String get invalidPassword => 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
  @override
  String get passwordsDontMatch => 'كلمات المرور غير متطابقة';
  @override
  String get invalidVerificationCode => 'رمز تحقق غير صالح';
  @override
  String get verificationCodeSent => 'تم إرسال رمز التحقق إلى هاتفك';
  @override
  String get loginSuccess => 'تم تسجيل الدخول بنجاح';
  @override
  String get registerSuccess => 'تم إنشاء الحساب بنجاح';
  @override
  String get logoutSuccess => 'تم تسجيل الخروج بنجاح';
  @override
  String get logout => 'تسجيل الخروج';

  // Clients
  @override
  String get clients => 'العملاء';
  @override
  String get client => 'عميل';
  @override
  String get addClient => 'إضافة عميل';
  @override
  String get editClient => 'تعديل عميل';
  @override
  String get clientDetails => 'تفاصيل العميل';
  @override
  String get clientName => 'اسم العميل';
  @override
  String get clientPhone => 'هاتف العميل';
  @override
  String get clientPassword => 'كلمة مرور العميل';
  @override
  String get financialCeiling => 'السقف المالي';
  @override
  String get noClients => 'لا يوجد عملاء';
  @override
  String get clientAddedSuccess => 'تم إضافة العميل بنجاح';
  @override
  String get clientUpdatedSuccess => 'تم تحديث العميل بنجاح';
  @override
  String get clientDeletedSuccess => 'تم حذف العميل بنجاح';
  @override
  String get confirmDeleteClient => 'هل أنت متأكد من حذف هذا العميل؟';

  // Transactions
  @override
  String get transactions => 'المعاملات';
  @override
  String get transaction => 'معاملة';
  @override
  String get addTransaction => 'إضافة معاملة';
  @override
  String get editTransaction => 'تعديل معاملة';
  @override
  String get transactionDetails => 'تفاصيل المعاملة';
  @override
  String get transactionType => 'نوع المعاملة';
  @override
  String get incoming => 'وارد';
  @override
  String get outgoing => 'صادر';
  @override
  String get amount => 'المبلغ';
  @override
  String get date => 'التاريخ';
  @override
  String get notes => 'ملاحظات';
  @override
  String get receipt => 'إيصال';
  @override
  String get addReceipt => 'إضافة إيصال';
  @override
  String get viewReceipt => 'عرض الإيصال';
  @override
  String get noTransactions => 'لا توجد معاملات';
  @override
  String get transactionAddedSuccess => 'تم إضافة المعاملة بنجاح';
  @override
  String get transactionUpdatedSuccess => 'تم تحديث المعاملة بنجاح';
  @override
  String get transactionDeletedSuccess => 'تم حذف المعاملة بنجاح';
  @override
  String get confirmDeleteTransaction => 'هل أنت متأكد من حذف هذه المعاملة؟';
  @override
  String get ceilingWarning => 'تحذير: العميل يقترب من السقف المالي';

  // Reports
  @override
  String get reports => 'التقارير';
  @override
  String get report => 'تقرير';
  @override
  String get generateReport => 'إنشاء تقرير';
  @override
  String get reportType => 'نوع التقرير';
  @override
  String get monthly => 'شهري';
  @override
  String get custom => 'مخصص';
  @override
  String get detailed => 'مفصل';
  @override
  String get startDate => 'تاريخ البداية';
  @override
  String get endDate => 'تاريخ النهاية';
  @override
  String get selectClient => 'اختر العميل';
  @override
  String get allClients => 'جميع العملاء';
  @override
  String get exportAsPdf => 'تصدير كملف PDF';
  @override
  String get exportAsExcel => 'تصدير كملف Excel';
  @override
  String get totalIncoming => 'إجمالي الوارد';
  @override
  String get totalOutgoing => 'إجمالي الصادر';
  @override
  String get balance => 'الرصيد';
  @override
  String get noReportData => 'لا توجد بيانات للفترة المحددة';

  // Settings
  @override
  String get settings => 'الإعدادات';
  @override
  String get language => 'اللغة';
  @override
  String get theme => 'المظهر';
  @override
  String get lightTheme => 'فاتح';
  @override
  String get darkTheme => 'داكن';
  @override
  String get systemTheme => 'النظام';
  @override
  String get businessInfo => 'معلومات العمل';
  @override
  String get businessName => 'اسم العمل';
  @override
  String get businessPhone => 'هاتف العمل';
  @override
  String get businessLogo => 'شعار العمل';
  @override
  String get currency => 'العملة';
  @override
  String get subscription => 'الاشتراك';
  @override
  String get backupRestore => 'النسخ الاحتياطي والاستعادة';
  @override
  String get backup => 'نسخ احتياطي';
  @override
  String get restore => 'استعادة';
  @override
  String get backupSuccess => 'تم إنشاء نسخة احتياطية بنجاح';
  @override
  String get restoreSuccess => 'تم استعادة البيانات بنجاح';
  @override
  String get trialVersion => 'النسخة التجريبية';
  @override
  String get trialDaysLeft => 'الأيام المتبقية في النسخة التجريبية: ';
  @override
  String get upgradeToPremium => 'الترقية إلى النسخة المميزة';
  @override
  String get premiumFeatures => 'ميزات النسخة المميزة';
}
