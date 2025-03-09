import 'package:flutter/foundation.dart';
import '../models/table.dart';

class TableProvider with ChangeNotifier {
  List<RestaurantTable> _tables = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<RestaurantTable> get tables => _tables;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Constructor with initial sample data
  TableProvider() {
    _initSampleData();
  }

  // Initialize with sample data
  void _initSampleData() {
    _tables = [
      RestaurantTable(
        id: 1,
        number: 1,
        capacity: 4,
        status: TableStatus.available,
        qrCode: 'https://example.com/qr/table1',
      ),
      RestaurantTable(
        id: 2,
        number: 2,
        capacity: 2,
        status: TableStatus.occupied,
        qrCode: 'https://example.com/qr/table2',
      ),
      RestaurantTable(
        id: 3,
        number: 3,
        capacity: 6,
        status: TableStatus.reserved,
        qrCode: 'https://example.com/qr/table3',
      ),
      RestaurantTable(
        id: 4,
        number: 4,
        capacity: 4,
        status: TableStatus.available,
        qrCode: 'https://example.com/qr/table4',
      ),
      RestaurantTable(
        id: 5,
        number: 5,
        capacity: 8,
        status: TableStatus.available,
        qrCode: 'https://example.com/qr/table5',
      ),
    ];
  }

  // Refresh tables (simulate fetch)
  void refreshTables() {
    _isLoading = true;
    notifyListeners();
    
    // Simulate delay
    Future.delayed(const Duration(milliseconds: 500), () {
      _initSampleData();
      _isLoading = false;
      notifyListeners();
    });
  }

  // Get a table by ID
  RestaurantTable? getTableById(int id) {
    try {
      return _tables.firstWhere((table) => table.id == id);
    } catch (e) {
      return null;
    }
  }

  // Add a new table
  void addTable(RestaurantTable table) {
    _isLoading = true;
    notifyListeners();
    
    // Simulate delay
    Future.delayed(const Duration(milliseconds: 300), () {
      // Generate a new ID (max id + 1)
      final newId = _tables.isNotEmpty 
          ? _tables.map((t) => t.id).reduce((a, b) => a > b ? a : b) + 1 
          : 1;
      
      final newTable = RestaurantTable(
        id: newId,
        number: table.number,
        capacity: table.capacity,
        status: table.status,
        qrCode: 'https://example.com/qr/table${table.number}',
      );
      
      _tables.add(newTable);
      _isLoading = false;
      notifyListeners();
    });
  }

  // Update a table
  void updateTable(RestaurantTable updatedTable) {
    _isLoading = true;
    notifyListeners();
    
    // Simulate delay
    Future.delayed(const Duration(milliseconds: 300), () {
      final index = _tables.indexWhere((table) => table.id == updatedTable.id);
      if (index != -1) {
        _tables[index] = updatedTable;
      }
      _isLoading = false;
      notifyListeners();
    });
  }

  // Update table status
  void updateTableStatus(int tableId, TableStatus newStatus) {
    final table = getTableById(tableId);
    if (table != null) {
      final updatedTable = table.copyWith(status: newStatus);
      updateTable(updatedTable);
    }
  }

  // Delete a table
  void deleteTable(int id) {
    _isLoading = true;
    notifyListeners();
    
    // Simulate delay
    Future.delayed(const Duration(milliseconds: 300), () {
      _tables.removeWhere((table) => table.id == id);
      _isLoading = false;
      notifyListeners();
    });
  }

  // Generate QR code for a table
  void generateQRCode(int tableId) {
    final table = getTableById(tableId);
    if (table != null) {
      // Simulate QR code generation
      _isLoading = true;
      notifyListeners();
      
      Future.delayed(const Duration(milliseconds: 500), () {
        final qrCodeUrl = 'https://example.com/qr/table$tableId?t=${DateTime.now().millisecondsSinceEpoch}';
        final updatedTable = table.copyWith(qrCode: qrCodeUrl);
        final index = _tables.indexWhere((t) => t.id == tableId);
        if (index != -1) {
          _tables[index] = updatedTable;
        }
        _isLoading = false;
        notifyListeners();
      });
    }
  }

  // Get tables by status
  List<RestaurantTable> getTablesByStatus(TableStatus status) {
    return _tables.where((table) => table.status == status).toList();
  }

  // Get available tables count
  int get availableTablesCount {
    return _tables.where((table) => table.status == TableStatus.available).length;
  }

  // Get occupied tables count
  int get occupiedTablesCount {
    return _tables.where((table) => table.status == TableStatus.occupied).length;
  }

  // Get reserved tables count
  int get reservedTablesCount {
    return _tables.where((table) => table.status == TableStatus.reserved).length;
  }
}