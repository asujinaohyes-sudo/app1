import 'package:flutter_test/flutter_test.dart';
import 'package:car_booking_app/main.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('App starts and renders AuthWrapper', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that AuthWrapper is present.
    // The AuthWrapper will initially show a CircularProgressIndicator while waiting for the auth state.
    expect(find.byType(AuthWrapper), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
