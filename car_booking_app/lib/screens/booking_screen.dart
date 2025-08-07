import 'package:car_booking_app/l10n/app_localizations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:car_booking_app/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class BookingScreen extends StatefulWidget {
  final DateTime selectedDate;

  const BookingScreen({super.key, required this.selectedDate});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _notesController = TextEditingController();
  final _firestoreService = FirestoreService();

  String? _selectedCarType;
  TimeOfDay? _pickupTime;
  TimeOfDay? _returnTime;

  final List<String> _carTypes = ['Sedan', 'SUV', 'Hatchback', 'Truck'];

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && user.displayName != null) {
      _nameController.text = user.displayName!;
    }
  }

  Future<void> _selectTime(BuildContext context, bool isPickup) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _pickupTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        if (isPickup) {
          _pickupTime = picked;
        } else {
          _returnTime = picked;
        }
      });
    }
  }

  void _submitForm() async {
    final l10n = AppLocalizations.of(context)!;
    if (_formKey.currentState!.validate()) {
      if (_pickupTime == null || _returnTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.pleaseSelectPickupAndReturnTimes)),
        );
        return;
      }

      final bookingDetails = {
        'date': Timestamp.fromDate(widget.selectedDate),
        'userId': FirebaseAuth.instance.currentUser?.uid,
        'userName': _nameController.text,
        'carType': _selectedCarType,
        'pickupTime': _pickupTime!.format(context),
        'returnTime': _returnTime!.format(context),
        'notes': _notesController.text,
        'createdAt': FieldValue.serverTimestamp(),
      };

      try {
        await _firestoreService.addBooking(bookingDetails);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.bookingSuccessfullyCreated)),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.failedToCreateBooking(e.toString()))),
        );
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final formattedDate = DateFormat.yMMMd(locale).format(widget.selectedDate);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.bookACarOn(formattedDate)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: l10n.yourName),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return l10n.pleaseEnterYourName;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCarType,
                hint: Text(l10n.selectCarType),
                items: _carTypes.map((String carType) {
                  return DropdownMenuItem<String>(
                    value: carType,
                    child: Text(carType),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedCarType = newValue;
                  });
                },
                validator: (value) => value == null ? l10n.pleaseSelectACarType : null,
              ),
              const SizedBox(height: 16),
              ListTile(
                title: Text(l10n.pickupTime(_pickupTime?.format(context) ?? l10n.notSet)),
                trailing: const Icon(Icons.access_time),
                onTap: () => _selectTime(context, true),
              ),
              ListTile(
                title: Text(l10n.returnTime(_returnTime?.format(context) ?? l10n.notSet)),
                trailing: const Icon(Icons.access_time),
                onTap: () => _selectTime(context, false),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _notesController,
                decoration: InputDecoration(labelText: l10n.additionalNotes),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text(l10n.submitBooking),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
