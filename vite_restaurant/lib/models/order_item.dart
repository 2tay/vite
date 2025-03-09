class OrderItem {
  final int id;
  final int orderId;
  final int menuItemId;
  final int quantity;
  final double unitPrice;
  final String? menuItemName;
  final String? notes;

  OrderItem({
    required this.id,
    required this.orderId,
    required this.menuItemId,
    required this.quantity,
    required this.unitPrice,
    this.menuItemName,
    this.notes,
  });

  // Create a copy with updated values
  OrderItem copyWith({
    int? id,
    int? orderId,
    int? menuItemId,
    int? quantity,
    double? unitPrice,
    String? menuItemName,
    String? notes,
  }) {
    return OrderItem(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      menuItemId: menuItemId ?? this.menuItemId,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      menuItemName: menuItemName ?? this.menuItemName,
      notes: notes ?? this.notes,
    );
  }

  // Convert OrderItem to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'orderId': orderId,
      'menuItemId': menuItemId,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'menuItemName': menuItemName,
      'notes': notes,
    };
  }

  // Create OrderItem from a Map
  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      id: map['id'],
      orderId: map['orderId'],
      menuItemId: map['menuItemId'],
      quantity: map['quantity'],
      unitPrice: map['unitPrice'],
      menuItemName: map['menuItemName'],
      notes: map['notes'],
    );
  }

  // Calculate total price for this item
  double get totalPrice => quantity * unitPrice;
}
