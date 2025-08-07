import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:car_booking_app/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
    // Pre-fill the name with the current user's display name
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
    if (_formKey.currentState!.validate()) {
      if (_pickupTime == null || _returnTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select pickup and return times.')),
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
          const SnackBar(content: Text('Booking successfully created!')),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create booking: $e')),
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Book a Car on ${widget.selectedDate.toLocal()}'.split(' ')[0]),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Your Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCarType,
                hint: const Text('Select Car Type'),
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
                validator: (value) => value == null ? 'Please select a car type' : null,
              ),
              const SizedBox(height: 16),
              ListTile(
                title: Text('Pickup Time: ${_pickupTime?.format(context) ?? 'Not set'}'),
                trailing: const Icon(Icons.access_time),
                onTap: () => _selectTime(context, true),
              ),
              ListTile(
                title: Text('Return Time: ${_returnTime?.format(context) ?? 'Not set'}'),
                trailing: const Icon(Icons.access_time),
                onTap: () => _selectTime(context, false),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(labelText: 'Additional Notes'),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Submit Booking'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
