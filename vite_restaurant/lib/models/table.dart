enum TableStatus { available, occupied, reserved }

extension TableStatusExtension on TableStatus {
  String get name {
    switch (this) {
      case TableStatus.available:
        return 'Available';
      case TableStatus.occupied:
        return 'Occupied';
      case TableStatus.reserved:
        return 'Reserved';
    }
  }
}

class RestaurantTable {
  final int id;
  final int number;
  final int capacity;
  TableStatus status;
  final String? qrCode;

  RestaurantTable({
    required this.id,
    required this.number,
    required this.capacity,
    this.status = TableStatus.available,
    this.qrCode,
  });

  // Create a copy with updated values
  RestaurantTable copyWith({
    int? id,
    int? number,
    int? capacity,
    TableStatus? status,
    String? qrCode,
  }) {
    return RestaurantTable(
      id: id ?? this.id,
      number: number ?? this.number,
      capacity: capacity ?? this.capacity,
      status: status ?? this.status,
      qrCode: qrCode ?? this.qrCode,
    );
  }

  // Convert Table to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'number': number,
      'capacity': capacity,
      'status': status.index,
      'qrCode': qrCode,
    };
  }

  // Create Table from a Map
  factory RestaurantTable.fromMap(Map<String, dynamic> map) {
    return RestaurantTable(
      id: map['id'],
      number: map['number'],
      capacity: map['capacity'],
      status: TableStatus.values[map['status']],
      qrCode: map['qrCode'],
    );
  }
}
