import 'dart:convert';

class Booking {
  final int? id;
  final String siteName;
  final String siteImage;
  final String customerName;
  final String customerEmail;
  final String customerPhone;
  final DateTime travelDate;
  final int numberOfPeople;
  final String? specialRequests;
  final BookingStatus status;
  final DateTime createdAt;
  final String bookingId;

  Booking({
    this.id,
    required this.siteName,
    required this.siteImage,
    required this.customerName,
    required this.customerEmail,
    required this.customerPhone,
    required this.travelDate,
    required this.numberOfPeople,
    this.specialRequests,
    this.status = BookingStatus.pending,
    required this.createdAt,
    required this.bookingId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'siteName': siteName,
      'siteImage': siteImage,
      'customerName': customerName,
      'customerEmail': customerEmail,
      'customerPhone': customerPhone,
      'travelDate': travelDate.millisecondsSinceEpoch,
      'numberOfPeople': numberOfPeople,
      'specialRequests': specialRequests,
      'status': status.name,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'bookingId': bookingId,
    };
  }

  factory Booking.fromMap(Map<String, dynamic> map) {
    return Booking(
      id: map['id']?.toInt(),
      siteName: map['siteName'] ?? '',
      siteImage: map['siteImage'] ?? '',
      customerName: map['customerName'] ?? '',
      customerEmail: map['customerEmail'] ?? '',
      customerPhone: map['customerPhone'] ?? '',
      travelDate: DateTime.fromMillisecondsSinceEpoch(map['travelDate']),
      numberOfPeople: map['numberOfPeople']?.toInt() ?? 1,
      specialRequests: map['specialRequests'],
      status: BookingStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => BookingStatus.pending,
      ),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      bookingId: map['bookingId'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Booking.fromJson(String source) =>
      Booking.fromMap(json.decode(source));

  Booking copyWith({
    int? id,
    String? siteName,
    String? siteImage,
    String? customerName,
    String? customerEmail,
    String? customerPhone,
    DateTime? travelDate,
    int? numberOfPeople,
    String? specialRequests,
    BookingStatus? status,
    DateTime? createdAt,
    String? bookingId,
  }) {
    return Booking(
      id: id ?? this.id,
      siteName: siteName ?? this.siteName,
      siteImage: siteImage ?? this.siteImage,
      customerName: customerName ?? this.customerName,
      customerEmail: customerEmail ?? this.customerEmail,
      customerPhone: customerPhone ?? this.customerPhone,
      travelDate: travelDate ?? this.travelDate,
      numberOfPeople: numberOfPeople ?? this.numberOfPeople,
      specialRequests: specialRequests ?? this.specialRequests,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      bookingId: bookingId ?? this.bookingId,
    );
  }

  @override
  String toString() {
    return 'Booking(id: $id, siteName: $siteName, customerName: $customerName, status: $status, travelDate: $travelDate)';
  }
}

enum BookingStatus { pending, approved, rejected, completed }

extension BookingStatusExtension on BookingStatus {
  String get displayName {
    switch (this) {
      case BookingStatus.pending:
        return 'Pending';
      case BookingStatus.approved:
        return 'Approved';
      case BookingStatus.rejected:
        return 'Rejected';
      case BookingStatus.completed:
        return 'Completed';
    }
  }

  String get description {
    switch (this) {
      case BookingStatus.pending:
        return 'Waiting for site owner approval';
      case BookingStatus.approved:
        return 'Booking approved by site owner';
      case BookingStatus.rejected:
        return 'Booking rejected by site owner';
      case BookingStatus.completed:
        return 'Trip completed';
    }
  }
}
