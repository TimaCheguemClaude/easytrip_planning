import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../data/model/booking.dart';
import '../../services/booking_database_service.dart';
import '../../utils/theme.dart';

class UserBookingsScreen extends StatefulWidget {
  const UserBookingsScreen({super.key});

  @override
  State<UserBookingsScreen> createState() => _UserBookingsScreenState();
}

class _UserBookingsScreenState extends State<UserBookingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final BookingDatabaseService _dbService = BookingDatabaseService();

  List<Booking> _allBookings = [];
  List<Booking> _pendingBookings = [];
  List<Booking> _approvedBookings = [];
  List<Booking> _rejectedBookings = [];

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      setState(() {}); // Rebuild when tab changes to update colors
    });
    _loadUserBookings();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadUserBookings() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // For now, we'll show all bookings since we don't have user authentication
      // In a real app, you'd filter by current user ID
      final allBookings = await _dbService.getAllBookings();

      setState(() {
        _allBookings = allBookings;
        _pendingBookings = allBookings.where((b) => b.status == BookingStatus.pending).toList();
        _approvedBookings = allBookings.where((b) => b.status == BookingStatus.approved).toList();
        _rejectedBookings = allBookings.where((b) => b.status == BookingStatus.rejected).toList();
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
    final theme = Theme.of(context);
    Provider.of<UiProvider>(context); // ensure rebuild on theme change

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.book_online,
              color: theme.colorScheme.onPrimary,
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              'My Bookings',
              style: TextStyle(
                color: theme.colorScheme.onPrimary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        backgroundColor: theme.primaryColor,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: theme.colorScheme.onPrimary,
            ),
            onPressed: _loadUserBookings,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: theme.primaryColor.withOpacity(0.1),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: theme.primaryColor,
              unselectedLabelColor: theme.colorScheme.onSurface.withOpacity(0.6),
              labelStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
              tabs: [
                _buildTab('All', Icons.list, _allBookings.length, 0, theme),
                _buildTab('Pending', Icons.pending, _pendingBookings.length, 1, theme),
                _buildTab('Approved', Icons.check_circle, _approvedBookings.length, 2, theme),
                _buildTab('Rejected', Icons.cancel, _rejectedBookings.length, 3, theme),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: _isLoading
            ? _buildLoadingState(theme)
            : TabBarView(
                controller: _tabController,
                children: [
                  _buildBookingsList(_allBookings),
                  _buildBookingsList(_pendingBookings),
                  _buildBookingsList(_approvedBookings),
                  _buildBookingsList(_rejectedBookings),
                ],
              ),
      ),
    );
  }

  Widget _buildTab(String label, IconData icon, int count, int index, ThemeData theme) {
    final isActive = _tabController.index == index;
    return Tab(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isActive 
                  ? theme.primaryColor 
                  : theme.colorScheme.onSurface.withOpacity(0.6),
            ),
            const SizedBox(width: 6),
            Text(
              '$label ($count)',
              style: TextStyle(
                color: isActive 
                    ? theme.primaryColor 
                    : theme.colorScheme.onSurface.withOpacity(0.6),
                fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: theme.primaryColor,
          ),
          const SizedBox(height: 16),
          Text(
            'Loading your bookings...',
            style: TextStyle(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingsList(List<Booking> bookings) {
    final theme = Theme.of(context);
    
    if (bookings.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.book_online,
                  size: 48,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'No bookings found',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Book a trip through AI recommendations\nto see your bookings here',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadUserBookings,
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
    final theme = Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Add tap functionality if needed
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with image and basic info
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        booking.siteImage,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.image_not_supported,
                            color: theme.colorScheme.onSurface.withOpacity(0.4),
                            size: 32,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            booking.siteName,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onSurface,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'ID: ${booking.bookingId}',
                              style: TextStyle(
                                fontSize: 11,
                                color: theme.colorScheme.onSurface.withOpacity(0.7),
                                fontFamily: 'monospace',
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          _buildStatusChip(booking.status, theme),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Booking details
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: theme.colorScheme.outline.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      _buildDetailRow('Travel Date', _formatDate(booking.travelDate), Icons.calendar_today, theme),
                      _buildDetailRow('People', '${booking.numberOfPeople}', Icons.group, theme),
                      _buildDetailRow('Booked On', _formatDate(booking.createdAt), Icons.access_time, theme),
                      if (booking.specialRequests != null && booking.specialRequests!.isNotEmpty)
                        _buildDetailRow('Special Requests', booking.specialRequests!, Icons.note, theme),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Status description and actions
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _getStatusColor(booking.status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _getStatusColor(booking.status).withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            _getStatusIcon(booking.status),
                            color: _getStatusColor(booking.status),
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              booking.status.description,
                              style: TextStyle(
                                color: _getStatusColor(booking.status),
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),

                      if (booking.status == BookingStatus.approved) ...[
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () => _copyContactInfo(booking),
                            icon: const Icon(Icons.copy, size: 18),
                            label: const Text('Copy Booking Info'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _getStatusColor(booking.status),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(BookingStatus status, ThemeData theme) {
    final color = _getStatusColor(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getStatusIcon(status),
            size: 14,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            status.displayName,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: color,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(
            icon, 
            size: 16, 
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 12),
          Text(
            '$label: ',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
              fontSize: 13,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: theme.colorScheme.onSurface.withOpacity(0.8),
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(BookingStatus status) {
    switch (status) {
      case BookingStatus.pending:
        return Colors.orange;
      case BookingStatus.approved:
        return Colors.green;
      case BookingStatus.rejected:
        return Colors.red;
      case BookingStatus.completed:
        return Colors.blue;
    }
  }

  IconData _getStatusIcon(BookingStatus status) {
    switch (status) {
      case BookingStatus.pending:
        return Icons.pending;
      case BookingStatus.approved:
        return Icons.check_circle;
      case BookingStatus.rejected:
        return Icons.cancel;
      case BookingStatus.completed:
        return Icons.flag;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _copyContactInfo(Booking booking) {
    final info = '''
Booking Approved! ✅

Site: ${booking.siteName}
Booking ID: ${booking.bookingId}
Travel Date: ${_formatDate(booking.travelDate)}
People: ${booking.numberOfPeople}
Customer: ${booking.customerName}
Email: ${booking.customerEmail}
Phone: ${booking.customerPhone}

The site owner will contact you soon to finalize the details.
''';

    Clipboard.setData(ClipboardData(text: info));
    _showSuccessSnackBar('Booking information copied to clipboard');
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
