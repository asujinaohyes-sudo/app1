import 'app_localizations.dart';

/// The translations for Thai (`th`).
class AppLocalizationsTh extends AppLocalizations {
  AppLocalizationsTh([String locale = 'th']) : super(locale);

  @override
  String get login => 'เข้าสู่ระบบ';

  @override
  String get signInWithGoogle => 'ลงชื่อเข้าใช้ด้วย Google';

  @override
  String get carBookingCalendar => 'ปฏิทินการจองรถ';

  @override
  String bookACarOn(String date) {
    return 'จองรถสำหรับวันที่ $date';
  }

  @override
  String get yourName => 'ชื่อของคุณ';

  @override
  String get pleaseEnterYourName => 'กรุณากรอกชื่อของคุณ';

  @override
  String get selectCarType => 'เลือกประเภทรถ';

  @override
  String get pleaseSelectACarType => 'กรุณาเลือกประเภทรถ';

  @override
  String pickupTime(String time) {
    return 'เวลารับรถ: $time';
  }

  @override
  String returnTime(String time) {
    return 'เวลาคืนรถ: $time';
  }

  @override
  String get notSet => 'ยังไม่ได้ตั้งค่า';

  @override
  String get additionalNotes => 'หมายเหตุเพิ่มเติม';

  @override
  String get submitBooking => 'ยืนยันการจอง';

  @override
  String get pleaseSelectPickupAndReturnTimes => 'กรุณาเลือกเวลารับและคืนรถ';

  @override
  String get bookingSuccessfullyCreated => 'สร้างการจองสำเร็จ!';

  @override
  String failedToCreateBooking(String error) {
    return 'ไม่สามารถสร้างการจองได้: $error';
  }
}
