import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../data/model/booking.dart';
import '../../services/booking_database_service.dart';
import '../../utils/theme.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_loader.dart';
import 'package:easytrip/l10n/app_localizations.dart';

class SiteOwnerDashboardScreen extends StatefulWidget {
  const SiteOwnerDashboardScreen({super.key});

  @override
  State<SiteOwnerDashboardScreen> createState() =>
      _SiteOwnerDashboardScreenState();
}

class _SiteOwnerDashboardScreenState extends State<SiteOwnerDashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final BookingDatabaseService _dbService = BookingDatabaseService();

  List<Booking> _allBookings = [];
  List<Booking> _pendingBookings = [];
  List<Booking> _approvedBookings = [];
  List<Booking> _rejectedBookings = [];

  bool _isLoading = true;
  Map<String, int> _stats = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadBookings();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadBookings() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final allBookings = await _dbService.getAllBookings();
      final stats = await _dbService.getBookingStats();

      setState(() {
        _allBookings = allBookings;
        _pendingBookings = allBookings
            .where((b) => b.status == BookingStatus.pending)
            .toList();
        _approvedBookings = allBookings
            .where((b) => b.status == BookingStatus.approved)
            .toList();
        _rejectedBookings = allBookings
            .where((b) => b.status == BookingStatus.rejected)
            .toList();
        _stats = stats;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorSnackBar('Failed to load bookings: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<UiProvider>(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.siteOwnerDashboard),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadBookings),
          IconButton(icon: const Icon(Icons.logout), onPressed: _handleLogout),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              text: '${l10n.all} (${_allBookings.length})',
              icon: const Icon(Icons.list),
            ),
            Tab(
              text: '${l10n.pending} (${_pendingBookings.length})',
              icon: const Icon(Icons.pending),
            ),
            Tab(
              text: '${l10n.approved} (${_approvedBookings.length})',
              icon: const Icon(Icons.check_circle),
            ),
            Tab(
              text: '${l10n.rejected} (${_rejectedBookings.length})',
              icon: const Icon(Icons.cancel),
            ),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CustomLoader(size: 48))
          : Column(
              children: [
                // Stats Cards
                _buildStatsSection(),

                // Bookings List
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildBookingsList(_allBookings),
                      _buildBookingsList(_pendingBookings),
                      _buildBookingsList(_approvedBookings),
                      _buildBookingsList(_rejectedBookings),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildStatsSection() {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              l10n.totalBookings,
              _allBookings.length.toString(),
              Icons.book_online,
              Colors.blue,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              l10n.pending,
              _pendingBookings.length.toString(),
              Icons.pending_actions,
              Colors.orange,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              l10n.approved,
              _approvedBookings.length.toString(),
              Icons.check_circle,
              Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: TextStyle(fontSize: 12, color: color),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBookingsList(List<Booking> bookings) {
    final l10n = AppLocalizations.of(context)!;
    if (bookings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.inbox, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(l10n.noBookingsFound),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadBookings,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          final booking = bookings[index];
          return _buildBookingCard(booking);
        },
      ),
    );
  }

  Widget _buildBookingCard(Booking booking) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    booking.siteImage,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 60,
                      height: 60,
                      color: Colors.grey[300],
                      child: const Icon(Icons.image_not_supported),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking.siteName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${l10n.bookingId}: ${booking.bookingId}',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                _buildStatusChip(booking.status),
              ],
            ),

            const SizedBox(height: 16),

            // Customer Info
            _buildInfoRow(l10n.customer, booking.customerName, Icons.person),
            _buildInfoRow(l10n.emailAddress, booking.customerEmail, Icons.email),
            _buildInfoRow(l10n.phoneNumber, booking.customerPhone, Icons.phone),
            _buildInfoRow(
              l10n.travelDate,
              _formatDate(booking.travelDate),
              Icons.calendar_today,
            ),
            _buildInfoRow(l10n.people, '${booking.numberOfPeople}', Icons.group),

            if (booking.specialRequests != null &&
                booking.specialRequests!.isNotEmpty) ...[
              const SizedBox(height: 8),
              _buildInfoRow(
                l10n.specialRequests,
                booking.specialRequests!,
                Icons.note,
              ),
            ],

            const SizedBox(height: 16),

            // Action Buttons
            if (booking.status == BookingStatus.pending) ...[
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      onPressed: () =>
                          _updateBookingStatus(booking, BookingStatus.approved),
                      backgroundColor: Colors.green,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.check, color: Colors.white, size: 18),
                          const SizedBox(width: 4),
                          Text(
                            l10n.approve,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomButton(
                      onPressed: () =>
                          _updateBookingStatus(booking, BookingStatus.rejected),
                      backgroundColor: Colors.red,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.close, color: Colors.white, size: 18),
                          const SizedBox(width: 4),
                          Text(l10n.reject, style: const TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],

            // Contact Actions
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    onPressed: () => _contactCustomer(booking),
                    isOutlined: true,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.phone, size: 18),
                        const SizedBox(width: 4),
                        Text(l10n.contact),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomButton(
                    onPressed: () => _copyContactInfo(booking),
                    isOutlined: true,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.copy, size: 18),
                        const SizedBox(width: 4),
                        Text(l10n.copyInfo),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(BookingStatus status) {
    Color color;
    switch (status) {
      case BookingStatus.pending:
        color = Colors.orange;
        break;
      case BookingStatus.approved:
        color = Colors.green;
        break;
      case BookingStatus.rejected:
        color = Colors.red;
        break;
      case BookingStatus.completed:
        color = Colors.blue;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        status.displayName,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.w500)),
          Expanded(
            child: Text(value, style: TextStyle(color: Colors.grey[700])),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Future<void> _updateBookingStatus(
    Booking booking,
    BookingStatus newStatus,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    try {
      final success = await _dbService.updateBookingStatus(
        booking.id!,
        newStatus,
      );
      if (success) {
        _showSuccessSnackBar(
          '${l10n.booking} ${newStatus.displayName.toLowerCase()} ${l10n.successfully}',
        );
        _loadBookings(); // Refresh the list
      } else {
        _showErrorSnackBar(l10n.failedToUpdateBookingStatus);
      }
    } catch (e) {
      _showErrorSnackBar('${l10n.errorUpdatingBooking}: $e');
    }
  }

  void _contactCustomer(Booking booking) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.contactCustomer),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${l10n.customer}: ${booking.customerName}'),
            const SizedBox(height: 8),
            Text('${l10n.emailAddress}: ${booking.customerEmail}'),
            const SizedBox(height: 8),
            Text('${l10n.phoneNumber}: ${booking.customerPhone}'),
            const SizedBox(height: 16),
            Text(
              l10n.contactCustomerDirectly,
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.close),
          ),
        ],
      ),
    );
  }

  void _copyContactInfo(Booking booking) {
    final l10n = AppLocalizations.of(context)!;
    final info =
        '''
${l10n.customer}: ${booking.customerName}
${l10n.emailAddress}: ${booking.customerEmail}
${l10n.phoneNumber}: ${booking.customerPhone}
${l10n.site}: ${booking.siteName}
${l10n.travelDate}: ${_formatDate(booking.travelDate)}
${l10n.people}: ${booking.numberOfPeople}
${l10n.bookingId}: ${booking.bookingId}
''';

    Clipboard.setData(ClipboardData(text: info));
    _showSuccessSnackBar(l10n.contactInfoCopied);
  }

  void _handleLogout() {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.signOut),
        content: Text(l10n.areYouSureLogout),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to login
            },
            child: Text(l10n.signOut),
          ),
        ],
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
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
