import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider with ChangeNotifier {
  Locale _currentLocale = const Locale('pt', 'BR');
  Map<String, String> _localizedStrings = {};
  static const String _languageKey = 'selected_language';

  Locale get currentLocale => _currentLocale;
  Map<String, String> get localizedStrings => _localizedStrings;

  LanguageProvider() {
    _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString(_languageKey) ?? 'pt';
    
    if (languageCode == 'en') {
      _currentLocale = const Locale('en', 'US');
    } else {
      _currentLocale = const Locale('pt', 'BR');
    }
    
    await _loadLocalizedStrings();
    notifyListeners();
  }

  Future<void> changeLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, languageCode);

    if (languageCode == 'en') {
      _currentLocale = const Locale('en', 'US');
    } else {
      _currentLocale = const Locale('pt', 'BR');
    }

    await _loadLocalizedStrings();
    notifyListeners();
  }

  Future<void> _loadLocalizedStrings() async {
    String fileName;
    if (_currentLocale.languageCode == 'en') {
      fileName = 'assets/l10n/en.json';
    } else {
      fileName = 'assets/l10n/pt.json';
    }

    try {
      String jsonString = await rootBundle.loadString(fileName);
      Map<String, dynamic> jsonMap = json.decode(jsonString);
      _localizedStrings = jsonMap.map((key, value) => MapEntry(key, value.toString()));
    } catch (e) {
      // Error loading localized strings, using empty map as fallback
      _localizedStrings = {};
    }
  }

  String translate(String key) {
    return _localizedStrings[key] ?? key;
  }

  String get appTitle => translate('appTitle');
  String get welcome => translate('welcome');
  String get login => translate('login');
  String get logout => translate('logout');
  String get email => translate('email');
  String get password => translate('password');
  String get username => translate('username');
  String get register => translate('register');
  String get createAccount => translate('createAccount');
  String get signUp => translate('signUp');
  String get alreadyHaveAccount => translate('alreadyHaveAccount');
  String get dontHaveAccount => translate('dontHaveAccount');
  String get forgotPassword => translate('forgotPassword');
  String get confirmPassword => translate('confirmPassword');
  String get pleaseFillAllFields => translate('pleaseFillAllFields');
  String get passwordsDoNotMatch => translate('passwordsDoNotMatch');
  String get accountCreatedSuccessfully => translate('accountCreatedSuccessfully');
  String get loginFailed => translate('loginFailed');
  String get signUpFailed => translate('signUpFailed');

  String get dashboard => translate('dashboard');
  String get quickActions => translate('quickActions');
  String get myProfile => translate('myProfile');
  String get settings => translate('settings');
  String get language => translate('language');
  String get portuguese => translate('portuguese');
  String get english => translate('english');

  String get buildings => translate('buildings');
  String get buildingManagement => translate('buildingManagement');
  String get buildingInformation => translate('buildingInformation');
  String get unitManagement => translate('unitManagement');
  String get query => translate('query');
  String get buildingName => translate('buildingName');
  String get buildingType => translate('buildingType');
  String get totalUnits => translate('totalUnits');
  String get address => translate('address');
  String get zipCode => translate('zipCode');
  String get street => translate('street');
  String get number => translate('number');
  String get neighborhood => translate('neighborhood');
  String get city => translate('city');
  String get state => translate('state');
  String get managerInfo => translate('managerInfo');
  String get managerName => translate('managerName');
  String get phone => translate('phone');
  String get saveInformation => translate('saveInformation');

  String get addNewUnit => translate('addNewUnit');
  String get unitNumber => translate('unitNumber');
  String get blockTower => translate('blockTower');
  String get floor => translate('floor');
  String get area => translate('area');
  String get owner => translate('owner');
  String get status => translate('status');
  String get occupied => translate('occupied');
  String get vacant => translate('vacant');
  String get maintenance => translate('maintenance');
  String get addUnit => translate('addUnit');
  String get registeredUnits => translate('registeredUnits');
  String get searchUnit => translate('searchUnit');

  String get consultUnit => translate('consultUnit');
  String get search => translate('search');
  String get clear => translate('clear');
  String get queryResult => translate('queryResult');
  String get noQueryPerformed => translate('noQueryPerformed');
  String get useFieldsAbove => translate('useFieldsAbove');

  String get legalObligations => translate('legalObligations');
  String get legalObligationsDocuments => translate('legalObligationsDocuments');
  String get totalObligations => translate('totalObligations');
  String get pending => translate('pending');
  String get upToDate => translate('upToDate');
  String get duingIn30Days => translate('duingIn30Days');
  String get newObligation => translate('newObligation');
  String get templates => translate('templates');
  String get completed => translate('completed');
  String get overdue => translate('overdue');
  String get all => translate('all');
  String get upcomingDeadlines => translate('upcomingDeadlines');
  String get days => translate('days');

  String get equipmentMaintenance => translate('equipmentMaintenance');
  String get equipment => translate('equipment');
  String get addEquipment => translate('addEquipment');
  String get maintenanceHistory => translate('maintenanceHistory');
  String get equipmentName => translate('equipmentName');
  String get location => translate('location');
  String get installationDate => translate('installationDate');
  String get lastMaintenance => translate('lastMaintenance');
  String get nextMaintenance => translate('nextMaintenance');
  String get operational => translate('operational');
  String get needsMaintenance => translate('needsMaintenance');
  String get outOfOrder => translate('outOfOrder');

  String get financialManagement => translate('financialManagement');
  String get financial => translate('financial');
  String get budgetOverview => translate('budgetOverview');
  String get expenses => translate('expenses');
  String get addExpense => translate('addExpense');
  String get description => translate('description');
  String get amount => translate('amount');
  String get category => translate('category');
  String get date => translate('date');
  String get save => translate('save');
  String get cancel => translate('cancel');

  String get consumptionManagement => translate('consumptionManagement');
  String get consumption => translate('consumption');
  String get dailyConsumption => translate('dailyConsumption');
  String get monthlyBills => translate('monthlyBills');
  String get graphics => translate('graphics');
  String get water => translate('water');
  String get electricity => translate('electricity');
  String get gas => translate('gas');
  String get reading => translate('reading');
  String get registerReading => translate('registerReading');
  String get currentReading => translate('currentReading');
  String get previousReading => translate('previousReading');

  String get fieldManagementSurveys => translate('fieldManagementSurveys');
  String get fieldManagement => translate('fieldManagement');
  String get activeSurveys => translate('activeSurveys');
  String get responses => translate('responses');
  String get responseRate => translate('responseRate');
  String get newSurvey => translate('newSurvey');
  String get surveyTitle => translate('surveyTitle');
  String get surveyDescription => translate('surveyDescription');
  String get endDate => translate('endDate');
  String get surveyType => translate('surveyType');
  String get multipleChoice => translate('multipleChoice');
  String get rating => translate('rating');
  String get freeText => translate('freeText');
  String get yesNo => translate('yesNo');
  String get createSurvey => translate('createSurvey');
  String get completedSurveys => translate('completedSurveys');
  String get participationAnalysis => translate('participationAnalysis');
  String get participatingUnits => translate('participatingUnits');
  String get averageResponseTime => translate('averageResponseTime');
  String get generalSatisfaction => translate('generalSatisfaction');

  String get reports => translate('reports');
  String get reportCategories => translate('reportCategories');
  String get generateReport => translate('generateReport');
  String get scheduled => translate('scheduled');
  String get recentReports => translate('recentReports');
  String get scheduledReports => translate('scheduledReports');
  String get monthly => translate('monthly');
  String get quarterly => translate('quarterly');
  String get annual => translate('annual');
  String get nextRun => translate('nextRun');
  String get lastRun => translate('lastRun');
  String get active => translate('active');
  String get reportType => translate('reportType');
  String get executiveSummary => translate('executiveSummary');
  String get detailed => translate('detailed');
  String get analytical => translate('analytical');
  String get startDate => translate('startDate');
  String get format => translate('format');
  String get generate => translate('generate');

  String get userManagement => translate('userManagement');
  String get users => translate('users');
  String get totalUsers => translate('totalUsers');
  String get administrators => translate('administrators');
  String get activeUsers => translate('activeUsers');
  String get inactiveUsers => translate('inactiveUsers');
  String get newUser => translate('newUser');
  String get permissions => translate('permissions');
  String get userList => translate('userList');
  String get searchUser => translate('searchUser');
  String get sortByName => translate('sortByName');
  String get sortByRole => translate('sortByRole');
  String get filterActive => translate('filterActive');
  String get lastLogin => translate('lastLogin');
  String get administrator => translate('administrator');
  String get caretaker => translate('caretaker');
  String get rolesAndPermissions => translate('rolesAndPermissions');
  String get fullSystemAccess => translate('fullSystemAccess');
  String get limitedAccess => translate('limitedAccess');
  String get viewAllReports => translate('viewAllReports');
  String get manageUsers => translate('manageUsers');
  String get configureSystem => translate('configureSystem');
  String get approveExpenses => translate('approveExpenses');
  String get registerReadings => translate('registerReadings');
  String get reportProblems => translate('reportProblems');
  String get viewSchedule => translate('viewSchedule');
  String get accessSuppliers => translate('accessSuppliers');
  String get addNewUser => translate('addNewUser');
  String get fullName => translate('fullName');
  String get role => translate('role');
  String get building => translate('building');
  String get allBuildings => translate('allBuildings');
  String get temporaryPassword => translate('temporaryPassword');
  String get createUser => translate('createUser');
  String get edit => translate('edit');
  String get activate => translate('activate');
  String get deactivate => translate('deactivate');
  String get delete => translate('delete');

  String get supplierContacts => translate('supplierContacts');
  String get appointmentCalendar => translate('appointmentCalendar');
  String get phoneDirectory => translate('phoneDirectory');
  String get newAppointment => translate('newAppointment');
  String get viewCalendar => translate('viewCalendar');
  String get todaysAppointments => translate('todaysAppointments');
  String get upcomingAppointments => translate('upcomingAppointments');
  String get supplier => translate('supplier');
  String get time => translate('time');
  String get duration => translate('duration');
  String get confirmed => translate('confirmed');
  String get appointmentTitle => translate('appointmentTitle');
  String get estimatedDuration => translate('estimatedDuration');
  String get serviceType => translate('serviceType');
  String get inspection => translate('inspection');
  String get cleaning => translate('cleaning');
  String get repair => translate('repair');
  String get schedule => translate('schedule');
  String get scheduledThisMonth => translate('scheduledThisMonth');
  String get completedThisMonth => translate('completedThisMonth');
  String get pendingThisMonth => translate('pendingThisMonth');
  String get cancelledThisMonth => translate('cancelledThisMonth');
  String get searchSupplier => translate('searchSupplier');
  String get addContact => translate('addContact');
  String get categories => translate('categories');
  String get contactList => translate('contactList');
  String get security => translate('security');
  String get electrical => translate('electrical');
  String get plumbing => translate('plumbing');
  String get landscaping => translate('landscaping');
  String get call => translate('call');
  String get companyName => translate('companyName');
  String get contactName => translate('contactName');
  String get add => translate('add');

  String get error => translate('error');
  String get success => translate('success');
  String get warning => translate('warning');
  String get info => translate('info');
  String get ok => translate('ok');
  String get yes => translate('yes');
  String get no => translate('no');
  String get close => translate('close');
  String get open => translate('open');
  String get view => translate('view');
  String get download => translate('download');
  String get share => translate('share');
  String get update => translate('update');
  String get refresh => translate('refresh');
  String get loading => translate('loading');
  String get pleaseWait => translate('pleaseWait');
  String get noDataAvailable => translate('noDataAvailable');
  String get networkError => translate('networkError');
  String get tryAgain => translate('tryAgain');
}