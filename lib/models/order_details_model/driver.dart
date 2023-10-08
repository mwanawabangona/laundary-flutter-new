class Driver {
  final int? driverId;
  final String? driverName;
  Driver({
    required this.driverId,
    required this.driverName,
  });

  Driver copyWith({
    int? driverId,
    String? driverName,
  }) {
    return Driver(
      driverId: driverId ?? this.driverId,
      driverName: driverName ?? this.driverName,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'user_id': driverId,
      'name': driverName,
    };
  }

  factory Driver.fromMap(Map<String, dynamic> map) {
    return Driver(
      driverId: map['user_id'] as int?,
      driverName: map['name'] as String?,
    );
  }
}
