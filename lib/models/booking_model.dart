class BookingModel {
  final String id;
  final String userId;
  final String sessionType;
  final DateTime bookedAt;
  final bool attended;
  final String qrCode;

  BookingModel({
    required this.id,
    required this.userId,
    required this.sessionType,
    required this.bookedAt,
    this.attended = false,
    required this.qrCode,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'user_id': userId,
        'session_type': sessionType,
        'booked_at': bookedAt.toIso8601String(),
        'attended': attended,
        'qr_code': qrCode,
      };

  factory BookingModel.fromMap(Map<String, dynamic> map) => BookingModel(
        id: map['id'] ?? '',
        userId: map['user_id'] ?? '',
        sessionType: map['session_type'] ?? '',
        bookedAt: DateTime.parse(map['booked_at']),
        attended: map['attended'] ?? false,
        qrCode: map['qr_code'] ?? '',
      );
}
