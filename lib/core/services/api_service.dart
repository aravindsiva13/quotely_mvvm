// core/services/api_service.dart - Updated MockApiService
import 'dart:math';
import '../constants/app_constants.dart';
import '../../data/models/user.dart';
import '../../data/models/customer.dart';
import '../../data/models/document.dart';
import '../../data/models/item.dart';
import '../../data/models/dashboard_stats.dart';

class MockApiService {
  static final Random _random = Random();
  static String? _currentUserToken;
  static User? _currentUser;
  
  // In-memory storage
  static List<Customer> _customers = [];
  static List<Item> _items = [];
  static List<Document> _documents = [];
  static List<User> _users = [];
  static bool _isInitialized = false;

  // Initialize mock data
  static Future<void> initialize() async {
    if (_isInitialized) return;
    
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    _initializeMockData();
    _isInitialized = true;
  }

  static void _initializeMockData() {
    // Create demo user
    final demoUser = User(
      id: _generateId(),
      email: 'demo@test.com',
      businessName: 'Demo Business Inc',
      settings: UserSettings(
        currency: AppConstants.defaultCurrency,
        currencySymbol: AppConstants.defaultCurrencySymbol,
        defaultTaxRate: AppConstants.defaultTaxRate,
        templateTheme: 'professional',
        businessInfo: BusinessInfo(
          name: 'Demo Business Inc',
          address: '123 Business Street',
          city: 'New York',
          state: 'NY',
          country: 'USA',
          zipCode: '10001',
          phone: '+1 (555) 123-4567',
          email: 'demo@test.com',
          website: 'www.demobusiness.com',
          taxId: 'TX123456789',
          registrationNumber: 'REG987654321',
        ),
      ),
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    );
    _users.add(demoUser);

    // Create sample customers
    _customers = [
      Customer(
        id: _generateId(),
        name: 'Apple Inc.',
        email: 'contact@apple.com',
        phone: '+1 (408) 996-1010',
        address: '1 Apple Park Way',
        city: 'Cupertino',
        state: 'CA',
        country: 'USA',
        zipCode: '95014',
        notes: 'Premium technology client. Always pays on time.',
        createdAt: DateTime.now().subtract(const Duration(days: 45)),
      ),
      Customer(
        id: _generateId(),
        name: 'Microsoft Corporation',
        email: 'vendors@microsoft.com',
        phone: '+1 (425) 882-8080',
        address: '1 Microsoft Way',
        city: 'Redmond',
        state: 'WA',
        country: 'USA',
        zipCode: '98052',
        notes: 'Large enterprise client. Requires detailed invoicing.',
        createdAt: DateTime.now().subtract(const Duration(days: 40)),
      ),
      Customer(
        id: _generateId(),
        name: 'Tesla Motors',
        email: 'accounting@tesla.com',
        phone: '+1 (512) 516-8177',
        address: '1 Tesla Road',
        city: 'Austin',
        state: 'TX',
        country: 'USA',
        zipCode: '78725',
        notes: 'Innovative automotive company. Fast decision making.',
        createdAt: DateTime.now().subtract(const Duration(days: 35)),
      ),
    ];

    // Create sample items
    _items = [
      Item(
        id: _generateId(),
        name: 'Web Development',
        description: 'Custom website development with modern technologies',
        price: 5000.00,
        taxRate: 18.0,
        unit: 'project',
        category: 'Development',
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
      ),
      Item(
        id: _generateId(),
        name: 'Mobile App Development',
        description: 'Native iOS and Android app development',
        price: 8000.00,
        taxRate: 18.0,
        unit: 'project',
        category: 'Development',
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
      ),
      Item(
        id: _generateId(),
        name: 'UI/UX Design',
        description: 'User interface and experience design services',
        price: 150.00,
        taxRate: 18.0,
        unit: 'hour',
        category: 'Design',
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
      ),
    ];

    // Create sample documents
    _documents = [
      Document(
        id: _generateId(),
        type: 'Quote',
        number: 'QUO-001',
        customerId: _customers[0].id,
        date: DateTime.now().subtract(const Duration(days: 5)),
        dueDate: DateTime.now().add(const Duration(days: 30)),
        status: 'Draft',
        currency: 'USD',
        currencySymbol: '\$',
        items: [
          DocumentItem(
            id: _generateId(),
            documentId: '',
            itemId: _items[0].id,
            name: _items[0].name,
            description: _items[0].description,
            quantity: 1,
            unitPrice: _items[0].price,
            total: _items[0].price,
          ),
        ],
        subtotal: 5000.00,
        taxAmount: 900.00,
        total: 5900.00,
        notes: 'Please review and confirm the requirements.',
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
    ];
  }

  // Auth methods
  static Future<AuthResponse> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    
    if (email == 'demo@test.com' && password == 'demo123') {
      _currentUser = _users.first;
      _currentUserToken = _generateToken();
      return AuthResponse(
        success: true,
        user: _currentUser,
        token: _currentUserToken,
        message: 'Login successful',
      );
    }
    
    return AuthResponse(
      success: false,
      error: 'Invalid email or password',
    );
  }

  static Future<AuthResponse> register(UserRegistration registration) async {
    await Future.delayed(const Duration(seconds: 1));
    
    // Check if user already exists
    if (_users.any((user) => user.email == registration.email)) {
      return AuthResponse(
        success: false,
        error: 'User with this email already exists',
      );
    }
    
    // Create new user
    final newUser = User(
      id: _generateId(),
      email: registration.email,
      businessName: registration.businessName,
      settings: UserSettings(
        currency: AppConstants.defaultCurrency,
        currencySymbol: AppConstants.defaultCurrencySymbol,
        defaultTaxRate: AppConstants.defaultTaxRate,
        templateTheme: 'professional',
        businessInfo: BusinessInfo(
          name: registration.businessName,
          email: registration.email,
          phone: registration.phone,
          country: registration.country,
        ),
      ),
      createdAt: DateTime.now(),
    );
    
    _users.add(newUser);
    _currentUser = newUser;
    _currentUserToken = _generateToken();
    
    return AuthResponse(
      success: true,
      user: _currentUser,
      token: _currentUserToken,
      message: 'Registration successful',
    );
  }

  static Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _currentUser = null;
    _currentUserToken = null;
  }

  static Future<User?> getCurrentUser() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _currentUser;
  }

  static Future<User> updateUser(User user) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    final index = _users.indexWhere((u) => u.id == user.id);
    if (index != -1) {
      _users[index] = user;
      if (_currentUser?.id == user.id) {
        _currentUser = user;
      }
    }
    
    return user;
  }

  // Customer methods
  static Future<List<Customer>> getCustomers() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_customers);
  }

  static Future<Customer> createCustomer(Customer customer) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final newCustomer = customer.copyWith(
      id: _generateId(),
      createdAt: DateTime.now(),
    );
    _customers.insert(0, newCustomer);
    return newCustomer;
  }

  static Future<Customer> updateCustomer(Customer customer) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _customers.indexWhere((c) => c.id == customer.id);
    if (index != -1) {
      _customers[index] = customer;
    }
    return customer;
  }

  static Future<void> deleteCustomer(String customerId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _customers.removeWhere((c) => c.id == customerId);
  }

  // Item methods
  static Future<List<Item>> getItems() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_items);
  }

  static Future<Item> createItem(Item item) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final newItem = item.copyWith(
      id: _generateId(),
      createdAt: DateTime.now(),
    );
    _items.insert(0, newItem);
    return newItem;
  }

  static Future<Item> updateItem(Item item) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _items.indexWhere((i) => i.id == item.id);
    if (index != -1) {
      _items[index] = item;
    }
    return item;
  }

  static Future<void> deleteItem(String itemId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _items.removeWhere((i) => i.id == itemId);
  }

  // Document methods
  static Future<List<Document>> getDocuments() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_documents);
  }

  static Future<Document> createDocument(Document document) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final newDocument = document.copyWith(
      id: _generateId(),
      createdAt: DateTime.now(),
    );
    _documents.insert(0, newDocument);
    return newDocument;
  }

  static Future<Document> updateDocument(Document document) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _documents.indexWhere((d) => d.id == document.id);
    if (index != -1) {
      _documents[index] = document;
    }
    return document;
  }

  static Future<void> deleteDocument(String documentId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _documents.removeWhere((d) => d.id == documentId);
  }

  static Future<void> updateDocumentStatus(String documentId, String status) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _documents.indexWhere((d) => d.id == documentId);
    if (index != -1) {
      _documents[index] = _documents[index].copyWith(status: status);
    }
  }

  // Dashboard methods
  static Future<DashboardStats> getDashboardStats(DateTime period) async {
    await Future.delayed(const Duration(milliseconds: 800));
    
    // Calculate stats from existing data
    final totalRevenue = _documents.fold<double>(0, (sum, doc) => sum + doc.total);
    final pendingAmount = _documents
        .where((doc) => doc.status == 'Pending' || doc.status == 'Sent')
        .fold<double>(0, (sum, doc) => sum + doc.total);
    
    // Generate mock revenue chart data
    final revenueChart = List.generate(7, (index) {
      return RevenueData(
        date: DateTime.now().subtract(Duration(days: 6 - index)),
        amount: 1000 + _random.nextDouble() * 5000,
        period: 'Day ${index + 1}',
      );
    });

    // Generate document type chart data
    final documentTypes = <String, int>{};
    for (final doc in _documents) {
      documentTypes[doc.type] = (documentTypes[doc.type] ?? 0) + 1;
    }
    
    final documentTypeChart = documentTypes.entries.map((entry) {
      final percentage = (entry.value / _documents.length) * 100;
      return DocumentTypeData(
        type: entry.key,
        count: entry.value,
        percentage: percentage,
      );
    }).toList();

    return DashboardStats(
      totalRevenue: totalRevenue,
      pendingAmount: pendingAmount,
      totalCustomers: _customers.length,
      totalDocuments: _documents.length,
      overdueInvoices: 2, // Mock value
      monthlyRevenue: totalRevenue * 0.3, // Mock calculation
      yearlyRevenue: totalRevenue * 12, // Mock calculation
      revenueChart: revenueChart,
      documentTypeChart: documentTypeChart,
      statusChart: [], // Can be implemented later
    );
  }

  // Helper methods
  static String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString() + 
           _random.nextInt(1000).toString();
  }

  static String _generateToken() {
    return 'token_${DateTime.now().millisecondsSinceEpoch}_${_random.nextInt(10000)}';
  }
}

// core/constants/app_constants.dart
class AppConstants {
  static const String appName = 'Quotation Maker';
  static const String appVersion = '1.0.0';
  static const String defaultCurrency = 'USD';
  static const String defaultCurrencySymbol = '\$';
  static const double defaultTaxRate = 18.0;
  
  // Document types
  static const List<String> documentTypes = ['Quote', 'Invoice', 'Receipt'];
  
  // Document statuses
  static const List<String> documentStatuses = [
    'Draft',
    'Sent',
    'Viewed',
    'Accepted',
    'Rejected',
    'Paid',
    'Overdue',
  ];
  
  // Item units
  static const List<String> itemUnits = [
    'pcs',
    'hours',
    'days',
    'months',
    'project',
    'kg',
    'lbs',
    'meters',
    'feet',
  ];
  
  // Template themes
  static const List<String> templateThemes = [
    'professional',
    'modern',
    'classic',
    'minimal',
  ];
}