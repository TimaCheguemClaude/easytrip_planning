import 'dart:developer';

import 'package:easytrip/services/notification_service.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../data/model/booking.dart';

class BookingDatabaseService {
  static Database? _database;
  static const String _tableName = 'bookings';

  // Singleton pattern
  static final BookingDatabaseService _instance =
      BookingDatabaseService._internal();
  factory BookingDatabaseService() => _instance;
  BookingDatabaseService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    log('Initializing booking database', name: 'BookingDatabaseService');

    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'easytrip_bookings.db');

    return await openDatabase(path, version: 1, onCreate: _createDatabase);
  }

  Future<void> _createDatabase(Database db, int version) async {
    log('Creating booking database tables', name: 'BookingDatabaseService');

    await db.execute('''
      CREATE TABLE $_tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        siteName TEXT NOT NULL,
        siteImage TEXT NOT NULL,
        customerName TEXT NOT NULL,
        customerEmail TEXT NOT NULL,
        customerPhone TEXT NOT NULL,
        travelDate INTEGER NOT NULL,
        numberOfPeople INTEGER NOT NULL,
        specialRequests TEXT,
        status TEXT NOT NULL DEFAULT 'pending',
        createdAt INTEGER NOT NULL,
        bookingId TEXT NOT NULL UNIQUE
      )
    ''');

    log(
      'Booking database tables created successfully',
      name: 'BookingDatabaseService',
    );
  }

  // Create a new booking
  Future<int> createBooking(Booking booking) async {
    try {
      log(
        'Creating new booking: ${booking.bookingId}',
        name: 'BookingDatabaseService',
      );

      final db = await database;
      final id = await db.insert(_tableName, booking.toMap());

      log(
        'Booking created successfully with ID: $id',
        name: 'BookingDatabaseService',
      );
      return id;
    } catch (e) {
      log('Error creating booking: $e', name: 'BookingDatabaseService');
      rethrow;
    }
  }

  // Get all bookings
  Future<List<Booking>> getAllBookings() async {
    try {
      log('Fetching all bookings', name: 'BookingDatabaseService');

      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        _tableName,
        orderBy: 'createdAt DESC',
      );

      final bookings = List.generate(
        maps.length,
        (i) => Booking.fromMap(maps[i]),
      );

      log(
        'Fetched ${bookings.length} bookings',
        name: 'BookingDatabaseService',
      );
      return bookings;
    } catch (e) {
      log('Error fetching bookings: $e', name: 'BookingDatabaseService');
      return [];
    }
  }

  // Get bookings by status
  Future<List<Booking>> getBookingsByStatus(BookingStatus status) async {
    try {
      log(
        'Fetching bookings with status: ${status.name}',
        name: 'BookingDatabaseService',
      );

      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        _tableName,
        where: 'status = ?',
        whereArgs: [status.name],
        orderBy: 'createdAt DESC',
      );

      final bookings = List.generate(
        maps.length,
        (i) => Booking.fromMap(maps[i]),
      );

      log(
        'Fetched ${bookings.length} bookings with status ${status.name}',
        name: 'BookingDatabaseService',
      );
      return bookings;
    } catch (e) {
      log(
        'Error fetching bookings by status: $e',
        name: 'BookingDatabaseService',
      );
      return [];
    }
  }

  // Get booking by ID
  Future<Booking?> getBookingById(int id) async {
    try {
      log('Fetching booking with ID: $id', name: 'BookingDatabaseService');

      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        _tableName,
        where: 'id = ?',
        whereArgs: [id],
      );

      if (maps.isNotEmpty) {
        final booking = Booking.fromMap(maps.first);
        log(
          'Found booking: ${booking.bookingId}',
          name: 'BookingDatabaseService',
        );
        return booking;
      }

      log('No booking found with ID: $id', name: 'BookingDatabaseService');
      return null;
    } catch (e) {
      log('Error fetching booking by ID: $e', name: 'BookingDatabaseService');
      return null;
    }
  }

  // Update booking status
  Future<bool> updateBookingStatus(int id, BookingStatus status) async {
    try {
      log(
        'Updating booking $id status to: ${status.name}',
        name: 'BookingDatabaseService',
      );

      // Get the booking before updating to send notification
      final booking = await getBookingById(id);
      if (booking == null) {
        log('Booking not found for ID: $id', name: 'BookingDatabaseService');
        return false;
      }

      final db = await database;
      final result = await db.update(
        _tableName,
        {'status': status.name},
        where: 'id = ?',
        whereArgs: [id],
      );

      final success = result > 0;

      if (success) {
        // Send notification for status change
        final updatedBooking = booking.copyWith(status: status);
        await NotificationService.showBookingStatusNotification(updatedBooking);
        log('Notification sent for booking status change', name: 'BookingDatabaseService');
      }

      log(
        'Booking status update ${success ? 'successful' : 'failed'}',
        name: 'BookingDatabaseService',
      );
      return success;
    } catch (e) {
      log('Error updating booking status: $e', name: 'BookingDatabaseService');
      return false;
    }
  }

  // Delete booking
  Future<bool> deleteBooking(int id) async {
    try {
      log('Deleting booking with ID: $id', name: 'BookingDatabaseService');

      final db = await database;
      final result = await db.delete(
        _tableName,
        where: 'id = ?',
        whereArgs: [id],
      );

      final success = result > 0;
      log(
        'Booking deletion ${success ? 'successful' : 'failed'}',
        name: 'BookingDatabaseService',
      );
      return success;
    } catch (e) {
      log('Error deleting booking: $e', name: 'BookingDatabaseService');
      return false;
    }
  }

  // Get booking statistics
  Future<Map<String, int>> getBookingStats() async {
    try {
      log('Fetching booking statistics', name: 'BookingDatabaseService');

      final db = await database;
      final List<Map<String, dynamic>> result = await db.rawQuery('''
        SELECT status, COUNT(*) as count
        FROM $_tableName
        GROUP BY status
      ''');

      final stats = <String, int>{};
      for (final row in result) {
        stats[row['status']] = row['count'];
      }

      log('Booking stats: $stats', name: 'BookingDatabaseService');
      return stats;
    } catch (e) {
      log('Error fetching booking stats: $e', name: 'BookingDatabaseService');
      return {};
    }
  }

  // Search bookings
  Future<List<Booking>> searchBookings(String query) async {
    try {
      log(
        'Searching bookings with query: $query',
        name: 'BookingDatabaseService',
      );

      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        _tableName,
        where: '''
          customerName LIKE ? OR
          customerEmail LIKE ? OR
          siteName LIKE ? OR
          bookingId LIKE ?
        ''',
        whereArgs: ['%$query%', '%$query%', '%$query%', '%$query%'],
        orderBy: 'createdAt DESC',
      );

      final bookings = List.generate(
        maps.length,
        (i) => Booking.fromMap(maps[i]),
      );

      log(
        'Found ${bookings.length} bookings matching query',
        name: 'BookingDatabaseService',
      );
      return bookings;
    } catch (e) {
      log('Error searching bookings: $e', name: 'BookingDatabaseService');
      return [];
    }
  }

  // Close database
  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
      log('Database closed', name: 'BookingDatabaseService');
    }
  }
}
