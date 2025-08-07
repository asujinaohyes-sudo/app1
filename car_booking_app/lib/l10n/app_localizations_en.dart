import 'app_localizations.dart';

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get login => 'Login';

  @override
  String get signInWithGoogle => 'Sign in with Google';

  @override
  String get carBookingCalendar => 'Car Booking Calendar';

  @override
  String bookACarOn(String date) {
    return 'Book a Car on $date';
  }

  @override
  String get yourName => 'Your Name';

  @override
  String get pleaseEnterYourName => 'Please enter your name';

  @override
  String get selectCarType => 'Select Car Type';

  @override
  String get pleaseSelectACarType => 'Please select a car type';

  @override
  String pickupTime(String time) {
    return 'Pickup Time: $time';
  }

  @override
  String returnTime(String time) {
    return 'Return Time: $time';
  }

  @override
  String get notSet => 'Not set';

  @override
  String get additionalNotes => 'Additional Notes';

  @override
  String get submitBooking => 'Submit Booking';

  @override
  String get pleaseSelectPickupAndReturnTimes => 'Please select pickup and return times.';

  @override
  String get bookingSuccessfullyCreated => 'Booking successfully created!';

  @override
  String failedToCreateBooking(String error) {
    return 'Failed to create booking: $error';
  }
}
