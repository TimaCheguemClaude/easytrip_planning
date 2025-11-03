import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr')
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'easytrip'**
  String get appTitle;

  /// Login screen title
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginTitle;

  /// Hint text for email field
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailHint;

  /// Hint text for password field
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordHint;

  /// Text for login button
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginButton;

  /// Text for forgot password link
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// Text for no account message
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get noAccount;

  /// Text for sign up link
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// Settings screen title
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Change password option
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// Change language option
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get changeLanguage;

  /// Privacy policy option
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// Contact us option
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contactUs;

  /// Delete account option
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// Delete account confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your account? This action cannot be undone.'**
  String get deleteAccountConfirmation;

  /// Cancel button text
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Delete button text
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Dark theme toggle label
  ///
  /// In en, this message translates to:
  /// **'Dark Theme'**
  String get darkTheme;

  /// Save button text
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Instruction to select language
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @privacyPolicyTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicyTitle;

  /// No description provided for @privacyPolicyForRideShare.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy for easytrip'**
  String get privacyPolicyForRideShare;

  /// No description provided for @privacyPolicyIntro.
  ///
  /// In en, this message translates to:
  /// **'At easytrip, accessible from google play store, one of our main priorities is the privacy of our visitors. This Privacy Policy document contains types of information that is collected and recorded by easytrip and how we use it.'**
  String get privacyPolicyIntro;

  /// No description provided for @additionalQuestionsText.
  ///
  /// In en, this message translates to:
  /// **'If you have additional questions or require more information about our Privacy Policy, do not hesitate to contact us.'**
  String get additionalQuestionsText;

  /// No description provided for @policyScope.
  ///
  /// In en, this message translates to:
  /// **'This Privacy Policy applies only to our online activities and is valid for visitors to our website with regards to the information that they shared and/or collect in easytrip. This policy is not applicable to any information collected offline or via channels other than this website.'**
  String get policyScope;

  /// No description provided for @policyCreationNote.
  ///
  /// In en, this message translates to:
  /// **'Our Privacy Policy was created with the help of the Free Privacy Policy Generator.'**
  String get policyCreationNote;

  // Navigation and Main App
  String get home => 'Home';
  String get explore => 'Explore';
  String get trips => 'Trips';
  String get profile => 'Profile';
  String get aiRecommendations => 'AI Recommendations';
  String get discoverCameroon => 'Discover Cameroon';
  String get planYourTrip => 'Plan your next trip';
  String get popularNow => 'Popular Now';
  String get popularDestinations => 'Popular Destinations';
  String get exploreByCity => 'Explore by city';
  String get seeAll => 'See all';
  String get exploreButton => 'Explore';
  
  // Trip Planning
  String get createNewTrip => 'Create a new trip';
  String get buildTripWithAI => 'Build a trip with AI';
  String get tripName => 'Trip Name';
  String get destination => 'Destination';
  String get budget => 'Budget';
  String get crew => 'Crew';
  String get startDate => 'Start Date';
  String get endDate => 'End Date';
  String get notes => 'Notes';
  String get tripPhoto => 'Trip Photo';
  String get planTrip => 'Plan Trip';
  String get tripPlannedSuccessfully => 'Trip planned successfully!';
  String get pleaseFillAllFields => 'Please fill all required fields.';
  
  // Trip Details
  String get saveTab => 'Save';
  String get itinerary => 'Itinerary';
  String get forYou => 'For You';
  String get wallet => 'Wallet';
  String get recommendationsFor => 'Recommendations for';
  String get placesFound => 'places found';
  String get budgetPerPerson => 'Budget per person';
  String get noRecommendationsFound => 'No recommendations found';
  String get noPlacesFoundFor => 'No places found for';
  String get trySelectingDifferentCity => 'Try selecting a different city or check back later.';
  String get withinBudget => 'Within Budget';
  String get aboveBudget => 'Above Budget';
  String get price => 'Price';
  
  // Booking and Cards
  String get book => 'Book';
  String get bookNow => 'Book Now';
  String get saveToTrip => 'Save to Trip';
  String get addToItinerary => 'Add to Itinerary';
  String get deleteFromSaved => 'Delete from Saved';
  String get similarPlaces => 'Similar Places';
  String get aboutThisPlace => 'About this place';
  String get features => 'Features';
  String get hashtags => 'Hashtags';
  String get reviews => 'Reviews';
  String get writeReview => 'Write a review';
  String get addComment => 'Add a comment';
  String get like => 'Like';
  String get comment => 'Comment';
  String get share => 'Share';
  
  // Forms and Validation
  String get emailAddress => 'Email Address';
  String get password => 'Password';
  String get confirmPassword => 'Confirm Password';
  String get fullName => 'Full Name';
  String get phoneNumber => 'Phone Number';
  String get signIn => 'Sign In';
  String get signUpButton => 'Sign Up';
  String get signOut => 'Sign Out';
  String get login => 'Login';
  String get register => 'Register';
  String get forgotPasswordLink => 'Forgot Password?';
  String get dontHaveAccount => 'Don\'t have an account?';
  String get alreadyHaveAccount => 'Already have an account?';
  String get rememberMe => 'Remember me';
  
  // Validation Messages
  String get pleaseEnterEmail => 'Please enter your email';
  String get pleaseEnterValidEmail => 'Please enter a valid email';
  String get pleaseEnterPassword => 'Please enter your password';
  String get passwordTooShort => 'Password must be at least 6 characters';
  String get passwordsDoNotMatch => 'Passwords do not match';
  String get pleaseEnterName => 'Please enter your name';
  String get pleaseEnterPhone => 'Please enter your phone number';
  String get pleaseFillAllRequiredFields => 'Please fill all required fields';
  
  // Success and Error Messages
  String get loginSuccessful => 'Login successful';
  String get registrationSuccessful => 'Registration successful';
  String get loginFailed => 'Login failed';
  String get registrationFailed => 'Registration failed';
  String get invalidCredentials => 'Invalid email or password';
  String get networkError => 'Network error. Please try again.';
  String get somethingWentWrong => 'Something went wrong. Please try again.';
  String get savedSuccessfully => 'Saved successfully';
  String get deletedSuccessfully => 'Deleted successfully';
  String get addedToItinerary => 'Added to itinerary!';
  String get savedToTrip => 'saved to your trip';
  String get bookingSuccessful => 'Booking successful';
  String get bookingFailed => 'Booking failed';
  
  // Loading and States
  String get loading => 'Loading...';
  String get loadingRecommendations => 'Loading recommendations...';
  String get noDataAvailable => 'No data available';
  String get noDataAvailableYet => 'No data available yet';
  String get comingSoon => 'Coming Soon';
  String get tryAgain => 'Try Again';
  String get refresh => 'Refresh';
  
  // Site Owner
  String get siteOwnerLogin => 'Site Owner Login';
  String get manageBookings => 'Manage your touristic site bookings';
  String get welcomeBack => 'Welcome Back';
  String get dashboard => 'Dashboard';
  String get bookings => 'Bookings';
  String get analytics => 'Analytics';
  String get settingsTab => 'Settings';
  
  // Common Actions
  String get yes => 'Yes';
  String get no => 'No';
  String get ok => 'OK';
  String get done => 'Done';
  String get next => 'Next';
  String get previous => 'Previous';
  String get skip => 'Skip';
  String get finish => 'Finish';
  String get continueAction => 'Continue';
  String get back => 'Back';
  String get close => 'Close';
  String get edit => 'Edit';
  String get update => 'Update';
  String get create => 'Create';
  String get add => 'Add';
  String get remove => 'Remove';
  String get search => 'Search';
  String get filter => 'Filter';
  String get sort => 'Sort';
  String get view => 'View';
  String get details => 'Details';
  String get more => 'More';
  String get less => 'Less';
  
  // Time and Date
  String get today => 'Today';
  String get tomorrow => 'Tomorrow';
  String get yesterday => 'Yesterday';
  String get thisWeek => 'This Week';
  String get thisMonth => 'This Month';
  String get thisYear => 'This Year';
  String get selectDate => 'Select Date';
  String get selectTime => 'Select Time';
  
  // Categories
  String get placesToStay => 'Places to Stay';
  String get foodAndDrinks => 'Food & Drinks';
  String get thingsToDo => 'Things to Do';
  String get touristicSites => 'Touristic Sites';
  String get activities => 'Activities';
  String get restaurants => 'Restaurants';
  String get hotels => 'Hotels';
  
  // Cities
  String get douala => 'Douala';
  String get yaounde => 'Yaounde';
  String get kribi => 'Kribi';
  String get buea => 'Buea';
  
  // AI and Recommendations
  String get aiTripRecommendations => 'AI Trip Recommendations';
  String get getPersonalizedRecommendations => 'Get personalized recommendations for your trip';
  String get selectCity => 'Select City';
  String get selectActivity => 'Select Activity';
  String get numberOfPeople => 'Number of People';
  String get generateRecommendations => 'Generate Recommendations';
  String get aiAssistant => 'AI Assistant';
  String get howCanIHelp => 'How can I help you plan your trip?';
  String get sendMessage => 'Send Message';
  String get typeMessage => 'Type a message...';
  
  // Onboarding
  String get welcomeToEasyTrip => 'Welcome to EasyTrip';
  String get discoverCameroonBeauty => 'Discover the beauty of Cameroon';
  String get planPerfectTrip => 'Plan your perfect trip';
  String get getStarted => 'Get Started';
  String get skipOnboarding => 'Skip';
  
  // Additional strings
  String get optional => 'Optional';
  String get processing => 'Processing...';
  String get confirmBooking => 'Confirm Booking';
  String get bookingConfirmed => 'Booking Confirmed!';
  String get bookingPendingApproval => 'Your booking is pending approval from the site owner. You will be contacted directly once approved.';
  String get selectTravelDate => 'Please select a travel date';
  String get failedToProcessBooking => 'Failed to process booking';
  
  // Registration and Profile
  String get createAccount => 'Create Account';
  String get pleaseConfirmPassword => 'Please confirm your password';
  String get address => 'Address';
  String get pleaseEnterAddress => 'Please enter your address';
  
  // Complain page
  String get complain => 'Complain';
  String get submitComplain => 'Submit a Complain';
  String get yourComplain => 'Your complain';
  String get pleaseEnterComplain => 'Please enter your complain.';
  String get submitting => 'Submitting...';
  String get submit => 'Submit';
  
  // About Us page
  String get aboutUs => 'About Us';
  String get leaveApp => 'Leave the App?';
  String get aboutToOpenRepository => 'You are about to open the EasyTrip GitHub repository in your browser. This will leave the app. Continue?';
  String get couldNotOpenRepository => 'Could not open the repository.';
  String get aboutUsDescription => 'EasyTrip is an open-source travel planning app. You can view the source code, contribute, or report issues on our GitHub repository.';
  String get viewGitHubRepository => 'View GitHub Repository';
  
  // Trip Wallet and Site Owner Dashboard
  String get addMoney => 'Add Money';
  String get withdrawMoney => 'Withdraw Money';
  String get added => 'Added';
  String get withdrew => 'Withdrew';
  String get insufficientBalance => 'Insufficient balance';
  String get amount => 'Amount';
  String get balance => 'Balance';
  String get transactionHistory => 'Transaction History';
  String get noTransactionsYet => 'No transactions yet.';
  String get clearHistory => 'Clear History';
  String get yourTrips => 'Your Trips';
  String get noTripsFound => 'No trips found.';
  String get siteOwnerDashboard => 'Site Owner Dashboard';
  String get all => 'All';
  String get pending => 'Pending';
  String get approved => 'Approved';
  String get rejected => 'Rejected';
  String get totalBookings => 'Total Bookings';
  String get noBookingsFound => 'No bookings found';
  String get bookingId => 'Booking ID';
  String get customer => 'Customer';
  String get travelDate => 'Travel Date';
  String get people => 'People';
  String get specialRequests => 'Special Requests';
  String get approve => 'Approve';
  String get reject => 'Reject';
  String get contact => 'Contact';
  String get copyInfo => 'Copy Info';
  String get booking => 'Booking';
  String get successfully => 'successfully';
  String get failedToUpdateBookingStatus => 'Failed to update booking status';
  String get errorUpdatingBooking => 'Error updating booking';
  String get contactCustomer => 'Contact Customer';
  String get contactCustomerDirectly => 'Contact the customer directly using their email or phone number to discuss booking details.';
  String get site => 'Site';
  String get contactInfoCopied => 'Contact information copied to clipboard';
  String get areYouSureLogout => 'Are you sure you want to logout?';
  
  // Sidebar Menu
  String get history => 'History';
  String get referral => 'Referral';
  String get helpAndSupport => 'Help and Support';

  // Profile and Referral
  String get editProfile => 'Edit Profile';
  String get profileUpdated => 'Profile updated!';
  String get myTrips => 'My Trips';
  String get name => 'Name';
  String get inviteFriends => 'Invite your friends to EasyTrip!';
  String get referralDescription => 'Share your referral link below and earn rewards when your friends join and plan their trips with EasyTrip.';
  String get shareReferralLink => 'Share Referral Link';
  String get referralLink => 'Referral Link';
  String get shareWithFriends => 'Share this link with your friends';

  // Password Management
  String get oldPassword => 'Old Password';
  String get newPassword => 'New Password';
  String get pleaseEnterOldPassword => 'Please enter your old password';
  String get pleaseEnterNewPassword => 'Please enter a new password';
  String get passwordMustBeAtLeast8Characters => 'Password must be at least 8 characters';
  String get newPasswordCannotBeSameAsOld => 'New password cannot be the same as old password';
  String get pleaseConfirmNewPassword => 'Please confirm your new password';
  String get passwordUpdatedSuccessfully => 'Password updated successfully';

  // Notifications
  String get notifications => 'Notifications';
  String get markAllRead => 'Mark all read';
  String get noNotificationsYet => 'No notifications yet';
  String get day => 'day';
  String get days => 'days';
  String get hour => 'hour';
  String get hours => 'hours';
  String get minute => 'minute';
  String get minutes => 'minutes';
  String get ago => 'ago';
  String get justNow => 'Just now';

  // Popular and Cities
  String get mostPopular => 'Most Popular';
  String get allCities => 'All Cities';

  // Onboarding
  String get planYourTripsEasily => 'Plan Your Trips Easily';
  String get organizeYourJourneys => 'Organize your journeys with just a few taps. Create personalized travel plans that fit your budget and preferences.';
  String get discoverNewPlaces => 'Discover New Places';
  String get getRecommendations => 'Get recommendations for hotels, restaurants, and activities tailored to your destination and group size.';
  String get stayOnSchedule => 'Stay on Schedule';
  String get manageYourItinerary => 'Manage your itinerary with our calendar-based planner. Adjust activities anytime and enjoy a stress-free trip.';

  // Login
  String get logInToContinue => 'Log in to continue';
  String get pleaseActivateAccount => 'Please activate your account. Check your email for the activation code.';

  // Trip Management
  String get deleteTrip => 'Delete Trip';
  String get areYouSureDeleteTrip => 'Are you sure you want to delete';
  String get thisActionCannotBeUndone => 'This action cannot be undone.';
  String get deleted => 'deleted';
  String get tripDeleted => 'Trip deleted';
  String get untitledTrip => 'Untitled Trip';
  String get start => 'Start';
  String get savedPlaces => 'saved places';
  String get modify => 'Modify';
  String get myTripsAndBookings => 'My Trips & Bookings';
  String get loadingYourTrips => 'Loading your trips...';
  String get noTripsYet => 'No trips yet';
  String get startPlanningAdventure => 'Start planning your next adventure!\nCreate a trip or save recommendations to see them here.';
  String get createYourFirstTrip => 'Create Your First Trip';
  String get currentTrips => 'Current Trips';
  String get upcomingTrips => 'Upcoming Trips';
  String get pastTrips => 'Past Trips';
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'fr': return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
