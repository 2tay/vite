import 'order_item.dart';

enum OrderStatus {
  received,
  preparing,
  ready,
  delivered,
  cancelled
}

extension OrderStatusExtension on OrderStatus {
  String get name {
    switch (this) {
      case OrderStatus.received:
        return 'Received';
      case OrderStatus.preparing:
        return 'Preparing';
      case OrderStatus.ready:
        return 'Ready';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }
}

class Order {
  final int id;
  final int tableId;
  OrderStatus status;
  final DateTime createdAt;
  final List<OrderItem> items;
  final String? specialInstructions;
  final int? createdBy;

  Order({
    required this.id,
    required this.tableId,
    this.status = OrderStatus.received,
    required this.createdAt,
    required this.items,
    this.specialInstructions,
    this.createdBy,
  });

  // Total amount calculation
  double get totalAmount {
    return items.fold(0, (sum, item) => sum + (item.unitPrice * item.quantity));
  }

  // Create a copy of the order with updated values
  Order copyWith({
    int? id,
    int? tableId,
    OrderStatus? status,
    DateTime? createdAt,
    List<OrderItem>? items,
    String? specialInstructions,
    int? createdBy,
  }) {
    return Order(
      id: id ?? this.id,
      tableId: tableId ?? this.tableId,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      items: items ?? this.items,
      specialInstructions: specialInstructions ?? this.specialInstructions,
      createdBy: createdBy ?? this.createdBy,
    );
  }

  // Convert Order to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tableId': tableId,
      'status': status.index,
      'createdAt': createdAt.toIso8601String(),
      'items': items.map((item) => item.toMap()).toList(),
      'specialInstructions': specialInstructions,
      'createdBy': createdBy,
    };
  }

  // Create Order from a Map
  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'],
      tableId: map['tableId'],
      status: OrderStatus.values[map['status']],
      createdAt: DateTime.parse(map['createdAt']),
      items: List<OrderItem>.from(
        map['items']?.map((x) => OrderItem.fromMap(x)) ?? [],
      ),
      specialInstructions: map['specialInstructions'],
      createdBy: map['createdBy'],
    );
  }
}