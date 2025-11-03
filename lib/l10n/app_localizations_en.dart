// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'easytrip';

  @override
  String get loginTitle => 'Login';

  @override
  String get emailHint => 'Email';

  @override
  String get passwordHint => 'Password';

  @override
  String get loginButton => 'Login';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get noAccount => 'Don\'t have an account?';

  @override
  String get signUp => 'Sign Up';

  @override
  String get settings => 'Settings';

  @override
  String get changePassword => 'Change Password';

  @override
  String get changeLanguage => 'Change Language';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get contactUs => 'Contact Us';

  @override
  String get deleteAccount => 'Delete Account';

  @override
  String get deleteAccountConfirmation => 'Are you sure you want to delete your account? This action cannot be undone.';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get darkTheme => 'Dark Theme';

  @override
  String get save => 'Save';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get privacyPolicyTitle => 'Privacy Policy';

  @override
  String get privacyPolicyForRideShare => 'Privacy Policy for easytrip';

  @override
  String get privacyPolicyIntro => 'At easytrip, accessible from google play store, one of our main priorities is the privacy of our visitors. This Privacy Policy document contains types of information that is collected and recorded by easytrip and how we use it.';

  @override
  String get additionalQuestionsText => 'If you have additional questions or require more information about our Privacy Policy, do not hesitate to contact us.';

  @override
  String get policyScope => 'This Privacy Policy applies only to our online activities and is valid for visitors to our website with regards to the information that they shared and/or collect in easytrip. This policy is not applicable to any information collected offline or via channels other than this website.';

  @override
  String get policyCreationNote => 'Our Privacy Policy was created with the help of the Free Privacy Policy Generator.';

  // Navigation and Main App
  @override
  String get home => 'Home';
  @override
  String get explore => 'Explore';
  @override
  String get trips => 'Trips';
  @override
  String get profile => 'Profile';
  @override
  String get aiRecommendations => 'AI Recommendations';
  @override
  String get discoverCameroon => 'Discover Cameroon';
  @override
  String get planYourTrip => 'Plan your next trip';
  @override
  String get popularNow => 'Popular Now';
  @override
  String get popularDestinations => 'Popular Destinations';
  @override
  String get exploreByCity => 'Explore by city';
  @override
  String get seeAll => 'See all';
  @override
  String get exploreButton => 'Explore';
  
  // Trip Planning
  @override
  String get createNewTrip => 'Create a new trip';
  @override
  String get buildTripWithAI => 'Build a trip with AI';
  @override
  String get tripName => 'Trip Name';
  @override
  String get destination => 'Destination';
  @override
  String get budget => 'Budget';
  @override
  String get crew => 'Crew';
  @override
  String get startDate => 'Start Date';
  @override
  String get endDate => 'End Date';
  @override
  String get notes => 'Notes';
  @override
  String get tripPhoto => 'Trip Photo';
  @override
  String get planTrip => 'Plan Trip';
  @override
  String get tripPlannedSuccessfully => 'Trip planned successfully!';
  @override
  String get pleaseFillAllFields => 'Please fill all required fields.';
  
  // Trip Details
  @override
  String get saveTab => 'Save';
  @override
  String get itinerary => 'Itinerary';
  @override
  String get forYou => 'For You';
  @override
  String get wallet => 'Wallet';
  @override
  String get recommendationsFor => 'Recommendations for';
  @override
  String get placesFound => 'places found';
  @override
  String get budgetPerPerson => 'Budget per person';
  @override
  String get noRecommendationsFound => 'No recommendations found';
  @override
  String get noPlacesFoundFor => 'No places found for';
  @override
  String get trySelectingDifferentCity => 'Try selecting a different city or check back later.';
  @override
  String get withinBudget => 'Within Budget';
  @override
  String get aboveBudget => 'Above Budget';
  @override
  String get price => 'Price';
  
  // Booking and Cards
  @override
  String get book => 'Book';
  @override
  String get bookNow => 'Book Now';
  @override
  String get saveToTrip => 'Save to Trip';
  @override
  String get addToItinerary => 'Add to Itinerary';
  @override
  String get deleteFromSaved => 'Delete from Saved';
  @override
  String get similarPlaces => 'Similar Places';
  @override
  String get aboutThisPlace => 'About this place';
  @override
  String get features => 'Features';
  @override
  String get hashtags => 'Hashtags';
  @override
  String get reviews => 'Reviews';
  @override
  String get writeReview => 'Write a review';
  @override
  String get addComment => 'Add a comment';
  @override
  String get like => 'Like';
  @override
  String get comment => 'Comment';
  @override
  String get share => 'Share';
  
  // Forms and Validation
  @override
  String get emailAddress => 'Email Address';
  @override
  String get password => 'Password';
  @override
  String get confirmPassword => 'Confirm Password';
  @override
  String get fullName => 'Full Name';
  @override
  String get phoneNumber => 'Phone Number';
  @override
  String get signIn => 'Sign In';
  @override
  String get signUpButton => 'Sign Up';
  @override
  String get signOut => 'Sign Out';
  @override
  String get login => 'Login';
  @override
  String get register => 'Register';
  @override
  String get forgotPasswordLink => 'Forgot Password?';
  @override
  String get dontHaveAccount => 'Don\'t have an account?';
  @override
  String get alreadyHaveAccount => 'Already have an account?';
  @override
  String get rememberMe => 'Remember me';
  
  // Validation Messages
  @override
  String get pleaseEnterEmail => 'Please enter your email';
  @override
  String get pleaseEnterValidEmail => 'Please enter a valid email';
  @override
  String get pleaseEnterPassword => 'Please enter your password';
  @override
  String get passwordTooShort => 'Password must be at least 6 characters';
  @override
  String get passwordsDoNotMatch => 'Passwords do not match';
  @override
  String get pleaseEnterName => 'Please enter your name';
  @override
  String get pleaseEnterPhone => 'Please enter your phone number';
  @override
  String get pleaseFillAllRequiredFields => 'Please fill all required fields';
  
  // Success and Error Messages
  @override
  String get loginSuccessful => 'Login successful';
  @override
  String get registrationSuccessful => 'Registration successful';
  @override
  String get loginFailed => 'Login failed';
  @override
  String get registrationFailed => 'Registration failed';
  @override
  String get invalidCredentials => 'Invalid email or password';
  @override
  String get networkError => 'Network error. Please try again.';
  @override
  String get somethingWentWrong => 'Something went wrong. Please try again.';
  @override
  String get savedSuccessfully => 'Saved successfully';
  @override
  String get deletedSuccessfully => 'Deleted successfully';
  @override
  String get addedToItinerary => 'Added to itinerary!';
  @override
  String get savedToTrip => 'saved to your trip';
  @override
  String get bookingSuccessful => 'Booking successful';
  @override
  String get bookingFailed => 'Booking failed';
  
  // Loading and States
  @override
  String get loading => 'Loading...';
  @override
  String get loadingRecommendations => 'Loading recommendations...';
  @override
  String get noDataAvailable => 'No data available';
  @override
  String get noDataAvailableYet => 'No data available yet';
  @override
  String get comingSoon => 'Coming Soon';
  @override
  String get tryAgain => 'Try Again';
  @override
  String get refresh => 'Refresh';
  
  // Site Owner
  @override
  String get siteOwnerLogin => 'Site Owner Login';
  @override
  String get manageBookings => 'Manage your touristic site bookings';
  @override
  String get welcomeBack => 'Welcome Back';
  @override
  String get dashboard => 'Dashboard';
  @override
  String get bookings => 'Bookings';
  @override
  String get analytics => 'Analytics';
  @override
  String get settingsTab => 'Settings';
  
  // Common Actions
  @override
  String get yes => 'Yes';
  @override
  String get no => 'No';
  @override
  String get ok => 'OK';
  @override
  String get done => 'Done';
  @override
  String get next => 'Next';
  @override
  String get previous => 'Previous';
  @override
  String get skip => 'Skip';
  @override
  String get finish => 'Finish';
  @override
  String get continueAction => 'Continue';
  @override
  String get back => 'Back';
  @override
  String get close => 'Close';
  @override
  String get edit => 'Edit';
  @override
  String get update => 'Update';
  @override
  String get create => 'Create';
  @override
  String get add => 'Add';
  @override
  String get remove => 'Remove';
  @override
  String get search => 'Search';
  @override
  String get filter => 'Filter';
  @override
  String get sort => 'Sort';
  @override
  String get view => 'View';
  @override
  String get details => 'Details';
  @override
  String get more => 'More';
  @override
  String get less => 'Less';
  
  // Time and Date
  @override
  String get today => 'Today';
  @override
  String get tomorrow => 'Tomorrow';
  @override
  String get yesterday => 'Yesterday';
  @override
  String get thisWeek => 'This Week';
  @override
  String get thisMonth => 'This Month';
  @override
  String get thisYear => 'This Year';
  @override
  String get selectDate => 'Select Date';
  @override
  String get selectTime => 'Select Time';
  
  // Categories
  @override
  String get placesToStay => 'Places to Stay';
  @override
  String get foodAndDrinks => 'Food & Drinks';
  @override
  String get thingsToDo => 'Things to Do';
  @override
  String get touristicSites => 'Touristic Sites';
  @override
  String get activities => 'Activities';
  @override
  String get restaurants => 'Restaurants';
  @override
  String get hotels => 'Hotels';
  
  // Cities
  @override
  String get douala => 'Douala';
  @override
  String get yaounde => 'Yaounde';
  @override
  String get kribi => 'Kribi';
  @override
  String get buea => 'Buea';
  
  // AI and Recommendations
  @override
  String get aiTripRecommendations => 'AI Trip Recommendations';
  @override
  String get getPersonalizedRecommendations => 'Get personalized recommendations for your trip';
  @override
  String get selectCity => 'Select City';
  @override
  String get selectActivity => 'Select Activity';
  @override
  String get numberOfPeople => 'Number of People';
  @override
  String get generateRecommendations => 'Generate Recommendations';
  @override
  String get aiAssistant => 'AI Assistant';
  @override
  String get howCanIHelp => 'How can I help you plan your trip?';
  @override
  String get sendMessage => 'Send Message';
  @override
  String get typeMessage => 'Type a message...';
  
  // Onboarding
  @override
  String get welcomeToEasyTrip => 'Welcome to EasyTrip';
  @override
  String get discoverCameroonBeauty => 'Discover the beauty of Cameroon';
  @override
  String get planPerfectTrip => 'Plan your perfect trip';
  @override
  String get getStarted => 'Get Started';
  @override
  String get skipOnboarding => 'Skip';
  
  // Additional strings
  @override
  String get optional => 'Optional';
  @override
  String get processing => 'Processing...';
  @override
  String get confirmBooking => 'Confirm Booking';
  @override
  String get bookingConfirmed => 'Booking Confirmed!';
  @override
  String get bookingPendingApproval => 'Your booking is pending approval from the site owner. You will be contacted directly once approved.';
  @override
  String get selectTravelDate => 'Please select a travel date';
  @override
  String get failedToProcessBooking => 'Failed to process booking';
  
  // Registration and Profile
  @override
  String get createAccount => 'Create Account';
  @override
  String get pleaseConfirmPassword => 'Please confirm your password';
  @override
  String get address => 'Address';
  @override
  String get pleaseEnterAddress => 'Please enter your address';
  
  // Complain page
  @override
  String get complain => 'Complain';
  @override
  String get submitComplain => 'Submit a Complain';
  @override
  String get yourComplain => 'Your complain';
  @override
  String get pleaseEnterComplain => 'Please enter your complain.';
  @override
  String get submitting => 'Submitting...';
  @override
  String get submit => 'Submit';
  
  // About Us page
  @override
  String get aboutUs => 'About Us';
  @override
  String get leaveApp => 'Leave the App?';
  @override
  String get aboutToOpenRepository => 'You are about to open the EasyTrip GitHub repository in your browser. This will leave the app. Continue?';
  @override
  String get couldNotOpenRepository => 'Could not open the repository.';
  @override
  String get aboutUsDescription => 'EasyTrip is an open-source travel planning app. You can view the source code, contribute, or report issues on our GitHub repository.';
  @override
  String get viewGitHubRepository => 'View GitHub Repository';
  
  // Trip Wallet and Site Owner Dashboard
  @override
  String get addMoney => 'Add Money';
  @override
  String get withdrawMoney => 'Withdraw Money';
  @override
  String get added => 'Added';
  @override
  String get withdrew => 'Withdrew';
  @override
  String get insufficientBalance => 'Insufficient balance';
  @override
  String get amount => 'Amount';
  @override
  String get balance => 'Balance';
  @override
  String get transactionHistory => 'Transaction History';
  @override
  String get noTransactionsYet => 'No transactions yet.';
  @override
  String get clearHistory => 'Clear History';
  @override
  String get yourTrips => 'Your Trips';
  @override
  String get noTripsFound => 'No trips found.';
  @override
  String get siteOwnerDashboard => 'Site Owner Dashboard';
  @override
  String get all => 'All';
  @override
  String get pending => 'Pending';
  @override
  String get approved => 'Approved';
  @override
  String get rejected => 'Rejected';
  @override
  String get totalBookings => 'Total Bookings';
  @override
  String get noBookingsFound => 'No bookings found';
  @override
  String get bookingId => 'Booking ID';
  @override
  String get customer => 'Customer';
  @override
  String get travelDate => 'Travel Date';
  @override
  String get people => 'People';
  @override
  String get specialRequests => 'Special Requests';
  @override
  String get approve => 'Approve';
  @override
  String get reject => 'Reject';
  @override
  String get contact => 'Contact';
  @override
  String get copyInfo => 'Copy Info';
  @override
  String get booking => 'Booking';
  @override
  String get successfully => 'successfully';
  @override
  String get failedToUpdateBookingStatus => 'Failed to update booking status';
  @override
  String get errorUpdatingBooking => 'Error updating booking';
  @override
  String get contactCustomer => 'Contact Customer';
  @override
  String get contactCustomerDirectly => 'Contact the customer directly using their email or phone number to discuss booking details.';
  @override
  String get site => 'Site';
  @override
  String get contactInfoCopied => 'Contact information copied to clipboard';
  @override
  String get areYouSureLogout => 'Are you sure you want to logout?';
  
  // Sidebar Menu
  @override
  String get history => 'History';
  @override
  String get referral => 'Referral';
  @override
  String get helpAndSupport => 'Help and Support';

  // Profile and Referral
  @override
  String get editProfile => 'Edit Profile';
  @override
  String get profileUpdated => 'Profile updated!';
  @override
  String get myTrips => 'My Trips';
  @override
  String get name => 'Name';
  @override
  String get inviteFriends => 'Invite your friends to EasyTrip!';
  @override
  String get referralDescription => 'Share your referral link below and earn rewards when your friends join and plan their trips with EasyTrip.';
  @override
  String get shareReferralLink => 'Share Referral Link';
  @override
  String get referralLink => 'Referral Link';
  @override
  String get shareWithFriends => 'Share this link with your friends';

  // Password Management
  @override
  String get oldPassword => 'Old Password';
  @override
  String get newPassword => 'New Password';
  @override
  String get pleaseEnterOldPassword => 'Please enter your old password';
  @override
  String get pleaseEnterNewPassword => 'Please enter a new password';
  @override
  String get passwordMustBeAtLeast8Characters => 'Password must be at least 8 characters';
  @override
  String get newPasswordCannotBeSameAsOld => 'New password cannot be the same as old password';
  @override
  String get pleaseConfirmNewPassword => 'Please confirm your new password';
  @override
  String get passwordUpdatedSuccessfully => 'Password updated successfully';

  // Notifications
  @override
  String get notifications => 'Notifications';
  @override
  String get markAllRead => 'Mark all read';
  @override
  String get noNotificationsYet => 'No notifications yet';
  @override
  String get day => 'day';
  @override
  String get days => 'days';
  @override
  String get hour => 'hour';
  @override
  String get hours => 'hours';
  @override
  String get minute => 'minute';
  @override
  String get minutes => 'minutes';
  @override
  String get ago => 'ago';
  @override
  String get justNow => 'Just now';

  // Popular and Cities
  @override
  String get mostPopular => 'Most Popular';
  @override
  String get allCities => 'All Cities';

  // Onboarding
  @override
  String get planYourTripsEasily => 'Plan Your Trips Easily';
  @override
  String get organizeYourJourneys => 'Organize your journeys with just a few taps. Create personalized travel plans that fit your budget and preferences.';
  @override
  String get discoverNewPlaces => 'Discover New Places';
  @override
  String get getRecommendations => 'Get recommendations for hotels, restaurants, and activities tailored to your destination and group size.';
  @override
  String get stayOnSchedule => 'Stay on Schedule';
  @override
  String get manageYourItinerary => 'Manage your itinerary with our calendar-based planner. Adjust activities anytime and enjoy a stress-free trip.';

  // Login
  @override
  String get logInToContinue => 'Log in to continue';
  @override
  String get pleaseActivateAccount => 'Please activate your account. Check your email for the activation code.';

  // Trip Management
  @override
  String get deleteTrip => 'Delete Trip';
  @override
  String get areYouSureDeleteTrip => 'Are you sure you want to delete';
  @override
  String get thisActionCannotBeUndone => 'This action cannot be undone.';
  @override
  String get deleted => 'deleted';
  @override
  String get tripDeleted => 'Trip deleted';
  @override
  String get untitledTrip => 'Untitled Trip';
  @override
  String get start => 'Start';
  @override
  String get savedPlaces => 'saved places';
  @override
  String get modify => 'Modify';
  @override
  String get myTripsAndBookings => 'My Trips & Bookings';
  @override
  String get loadingYourTrips => 'Loading your trips...';
  @override
  String get noTripsYet => 'No trips yet';
  @override
  String get startPlanningAdventure => 'Start planning your next adventure!\nCreate a trip or save recommendations to see them here.';
  @override
  String get createYourFirstTrip => 'Create Your First Trip';
  @override
  String get currentTrips => 'Current Trips';
  @override
  String get upcomingTrips => 'Upcoming Trips';
  @override
  String get pastTrips => 'Past Trips';
}
