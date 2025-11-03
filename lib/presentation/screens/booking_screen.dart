import 'package:easytrip/data/model/booking.dart';
import 'package:easytrip/presentation/widgets/custom_text_field.dart';
import 'package:easytrip/services/booking_database_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:easytrip/l10n/app_localizations.dart';

import '../../data/model/touristic_site.dart';

class BookingScreen extends StatefulWidget {
  final Recommendation recommendation;

  const BookingScreen({super.key, required this.recommendation});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime? _selectedDate;
  int _numberOfPeople = 1;
  bool _isProcessing = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.bookNow)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRecommendationSummary(),
            const SizedBox(height: 24),
            _buildBookingForm(),
            const SizedBox(height: 24),
            _buildBookingButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationSummary() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    widget.recommendation.image,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 80,
                      height: 80,
                      color: Colors.grey[300],
                      child: const Icon(Icons.image_not_supported),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.recommendation.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.recommendation.reason,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              widget.recommendation.description,
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingForm() {
    final l10n = AppLocalizations.of(context)!;
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.details,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // Name field
          CustomTextField(
            controller: _nameController,
            labelText: '${l10n.fullName} *',
            prefixIcon: Icons.person,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return l10n.pleaseEnterName;
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Email field
          CustomTextField(
            controller: _emailController,
            labelText: '${l10n.emailAddress} *',
            prefixIcon: Icons.email,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return l10n.pleaseEnterEmail;
              }
              if (!RegExp(
                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
              ).hasMatch(value)) {
                return l10n.pleaseEnterValidEmail;
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Phone field
          TextFormField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: '${l10n.phoneNumber} *',
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.phone),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return l10n.pleaseEnterPhone;
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Date picker
          InkWell(
            onTap: _selectDate,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today),
                  const SizedBox(width: 12),
                  Text(
                    _selectedDate == null
                        ? '${l10n.selectDate} *'
                        : '${l10n.selectDate}: ${_formatDate(_selectedDate!)}',
                    style: TextStyle(
                      fontSize: 16,
                      color: _selectedDate == null ? Colors.grey[600] : null,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Number of people
          Row(
            children: [
              Text('${l10n.numberOfPeople}: ', style: const TextStyle(fontSize: 16)),
              const SizedBox(width: 16),
              IconButton(
                onPressed: _numberOfPeople > 1
                    ? () => setState(() => _numberOfPeople--)
                    : null,
                icon: const Icon(Icons.remove_circle_outline),
              ),
              Text(
                '$_numberOfPeople',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: () => setState(() => _numberOfPeople++),
                icon: const Icon(Icons.add_circle_outline),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Notes field
          TextFormField(
            controller: _notesController,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: '${l10n.notes} (${l10n.optional})',
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.note),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingButton() {
    final l10n = AppLocalizations.of(context)!;
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isProcessing ? null : _processBooking,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: _isProcessing
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  SizedBox(width: 12),
                  Text(l10n.processing),
                ],
              )
            : Text(
                l10n.confirmBooking,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Future<void> _processBooking() async {
    final l10n = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedDate == null) {
      _showErrorSnackBar(l10n.selectTravelDate);
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    try {
      // Create booking object
      final booking = Booking(
        siteName: widget.recommendation.title,
        siteImage: widget.recommendation.image,
        customerName: _nameController.text.trim(),
        customerEmail: _emailController.text.trim(),
        customerPhone: _phoneController.text.trim(),
        travelDate: _selectedDate!,
        numberOfPeople: _numberOfPeople,
        specialRequests: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
        status: BookingStatus.pending,
        createdAt: DateTime.now(),
        bookingId: 'ET${DateTime.now().millisecondsSinceEpoch}',
      );

      // Save to database
      final dbService = BookingDatabaseService();
      await dbService.createBooking(booking);

      if (!mounted) return;

      setState(() {
        _isProcessing = false;
      });

      // Show success dialog
      _showBookingConfirmation(booking.bookingId);
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isProcessing = false;
      });

      _showErrorSnackBar('${l10n.failedToProcessBooking}: $e');
    }
  }

  void _showBookingConfirmation(String bookingId) {
    final l10n = AppLocalizations.of(context)!;
    HapticFeedback.mediumImpact();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.check_circle, color: Colors.green, size: 64),
        title: Text(l10n.bookingConfirmed),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Your booking for "${widget.recommendation.title}" has been confirmed.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  _buildConfirmationRow('Name', _nameController.text),
                  _buildConfirmationRow('Date', _formatDate(_selectedDate!)),
                  _buildConfirmationRow('People', '$_numberOfPeople'),
                  _buildConfirmationRow('Booking ID', bookingId),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.bookingPendingApproval,
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(); // Go back to recommendations
            },
            child: Text(l10n.done),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmationRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(value),
        ],
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
