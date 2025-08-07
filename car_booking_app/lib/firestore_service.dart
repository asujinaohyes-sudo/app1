import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addBooking(Map<String, dynamic> bookingData) {
    try {
      return _db.collection('bookings').add(bookingData);
    } catch (e) {
      print('Error adding booking to Firestore: $e');
      rethrow;
    }
  }

  Stream<QuerySnapshot> getBookingsForDate(DateTime date) {
    Timestamp startOfDay = Timestamp.fromDate(DateTime(date.year, date.month, date.day));
    Timestamp endOfDay = Timestamp.fromDate(DateTime(date.year, date.month, date.day, 23, 59, 59));

    return _db
        .collection('bookings')
        .where('date', isGreaterThanOrEqualTo: startOfDay)
        .where('date', isLessThanOrEqualTo: endOfDay)
        .snapshots();
  }

  Stream<QuerySnapshot> getAllBookings() {
    return _db.collection('bookings').orderBy('date').snapshots();
  }
}
