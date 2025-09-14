import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/delivery_options_widget.dart';
import './widgets/order_summary_widget.dart';
import './widgets/payment_method_widget.dart';
import './widgets/prescription_history_widget.dart';
import './widgets/prescription_upload_widget.dart';

class MedicineOrdering extends StatefulWidget {
  const MedicineOrdering({super.key});

  @override
  State<MedicineOrdering> createState() => _MedicineOrderingState();
}

class _MedicineOrderingState extends State<MedicineOrdering>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Order state
  List<Map<String, dynamic>> _orderItems = [];
  Map<String, dynamic>? _selectedDeliveryOption;
  Map<String, dynamic>? _selectedPaymentMethod;
  Map<String, String>? _extractedPrescriptionDetails;
  XFile? _capturedPrescription;
  bool _isLoading = false;
  bool _showOrderSummary = false;

  // Mock medication data
  final List<Map<String, dynamic>> _availableMedications = [
    {
      "id": "med_001",
      "name": "Amoxicillin",
      "genericName": "Amoxicillin Trihydrate",
      "dosage": "500mg",
      "form": "Capsules",
      "price": 15.99,
      "inStock": true,
      "requiresPrescription": true,
      "description": "Antibiotic used to treat bacterial infections",
      "image":
          "https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=400&h=300&fit=crop",
      "manufacturer": "Generic Pharma",
      "category": "Antibiotics",
    },
    {
      "id": "med_002",
      "name": "Ibuprofen",
      "genericName": "Ibuprofen",
      "dosage": "200mg",
      "form": "Tablets",
      "price": 8.99,
      "inStock": true,
      "requiresPrescription": false,
      "description": "Pain reliever and anti-inflammatory",
      "image":
          "https://images.unsplash.com/photo-1559757148-5c350d0d3c56?w=400&h=300&fit=crop",
      "manufacturer": "OTC Meds",
      "category": "Pain Relief",
    },
    {
      "id": "med_003",
      "name": "Vitamin D3",
      "genericName": "Cholecalciferol",
      "dosage": "1000 IU",
      "form": "Softgels",
      "price": 12.49,
      "inStock": true,
      "requiresPrescription": false,
      "description": "Essential vitamin for bone health",
      "image":
          "https://images.unsplash.com/photo-1550572017-edd951aa8f72?w=400&h=300&fit=crop",
      "manufacturer": "Wellness Co",
      "category": "Vitamins",
    },
    {
      "id": "med_004",
      "name": "Lisinopril",
      "genericName": "Lisinopril",
      "dosage": "10mg",
      "form": "Tablets",
      "price": 22.99,
      "inStock": false,
      "requiresPrescription": true,
      "description": "ACE inhibitor for blood pressure",
      "image":
          "https://images.unsplash.com/photo-1471864190281-a93a3070b6de?w=400&h=300&fit=crop",
      "manufacturer": "CardioMed",
      "category": "Cardiovascular",
    },
  ];

  List<Map<String, dynamic>> _filteredMedications = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _filteredMedications = List.from(_availableMedications);
    _searchController.addListener(_filterMedications);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _filterMedications() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredMedications = _availableMedications.where((med) {
        final name = (med["name"] as String).toLowerCase();
        final genericName = (med["genericName"] as String).toLowerCase();
        final category = (med["category"] as String).toLowerCase();
        return name.contains(query) ||
            genericName.contains(query) ||
            category.contains(query);
      }).toList();
    });
  }

  void _onPrescriptionImageCaptured(XFile? image) {
    setState(() {
      _capturedPrescription = image;
    });
  }

  void _onPrescriptionDetailsExtracted(Map<String, String> details) {
    setState(() {
      _extractedPrescriptionDetails = details;
    });

    // Auto-add to order if medication found
    final medicationName = details['medicationName'];
    if (medicationName != null) {
      final medication = _availableMedications.firstWhere(
        (med) => (med["name"] as String)
            .toLowerCase()
            .contains(medicationName.toLowerCase()),
        orElse: () => {},
      );

      if (medication.isNotEmpty) {
        _addToOrder(medication,
            quantity: int.tryParse(
                    details['quantity']?.replaceAll(RegExp(r'[^0-9]'), '') ??
                        '1') ??
                1);
      }
    }
  }

  void _onReorderPrescription(Map<String, dynamic> prescription) {
    final medication = _availableMedications.firstWhere(
      (med) =>
          (med["name"] as String) == (prescription["medicationName"] as String),
      orElse: () => {},
    );

    if (medication.isNotEmpty) {
      _addToOrder(medication, quantity: prescription["quantity"] as int? ?? 30);
      _showSuccessMessage('${prescription["medicationName"]} added to order');
    }
  }

  void _onDeliveryOptionSelected(Map<String, dynamic> option) {
    setState(() {
      _selectedDeliveryOption = option;
    });
  }

  void _onPaymentMethodSelected(Map<String, dynamic> method) {
    setState(() {
      _selectedPaymentMethod = method;
    });
  }

  void _addToOrder(Map<String, dynamic> medication, {int quantity = 1}) {
    setState(() {
      final existingIndex = _orderItems.indexWhere(
        (item) => item["id"] == medication["id"],
      );

      if (existingIndex != -1) {
        _orderItems[existingIndex]["quantity"] =
            (_orderItems[existingIndex]["quantity"] as int) + quantity;
      } else {
        _orderItems.add({
          ...medication,
          "quantity": quantity,
        });
      }
    });

    HapticFeedback.lightImpact();
    _showSuccessMessage('${medication["name"]} added to order');
  }

  void _removeFromOrder(String medicationId) {
    setState(() {
      _orderItems.removeWhere((item) => item["id"] == medicationId);
    });
  }

  void _updateQuantity(String medicationId, int newQuantity) {
    if (newQuantity <= 0) {
      _removeFromOrder(medicationId);
      return;
    }

    setState(() {
      final index =
          _orderItems.indexWhere((item) => item["id"] == medicationId);
      if (index != -1) {
        _orderItems[index]["quantity"] = newQuantity;
      }
    });
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CustomIconWidget(
              iconName: 'check_circle',
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(message),
          ],
        ),
        backgroundColor: AppTheme.successLight,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void _placeOrder() async {
    if (_orderItems.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    // Simulate order processing
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
      _orderItems.clear();
      _showOrderSummary = false;
    });

    _showOrderConfirmation();
  }

  void _showOrderConfirmation() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _buildOrderConfirmationDialog(),
    );
  }

  void _scanBarcode() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _buildBarcodeScanner(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: CustomAppBar(
        title: 'Medicine Ordering',
        showEmergencyButton: true,
        actions: [
          // Cart icon with badge
          Stack(
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    _showOrderSummary = !_showOrderSummary;
                  });
                },
                icon: CustomIconWidget(
                  iconName: 'shopping_cart',
                  color: colorScheme.onSurface,
                  size: 24,
                ),
              ),
              if (_orderItems.isNotEmpty)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: colorScheme.error,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      _orderItems.length > 99
                          ? '99+'
                          : _orderItems.length.toString(),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.onError,
                        fontSize: 8.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Search bar with barcode scanner
              Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.shadow.withValues(alpha: 0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search medications...',
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(12),
                            child: CustomIconWidget(
                              iconName: 'search',
                              color: colorScheme.onSurfaceVariant,
                              size: 20,
                            ),
                          ),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  onPressed: () {
                                    _searchController.clear();
                                    _filterMedications();
                                  },
                                  icon: CustomIconWidget(
                                    iconName: 'clear',
                                    color: colorScheme.onSurfaceVariant,
                                    size: 20,
                                  ),
                                )
                              : null,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: colorScheme.surfaceContainerHighest,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Barcode scanner button
                    Container(
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        onPressed: _scanBarcode,
                        icon: CustomIconWidget(
                          iconName: 'qr_code_scanner',
                          color: colorScheme.onPrimary,
                          size: 24,
                        ),
                        tooltip: 'Scan Barcode',
                      ),
                    ),
                  ],
                ),
              ),

              // Tab bar
              Container(
                color: colorScheme.surface,
                child: TabBar(
                  controller: _tabController,
                  tabs: const [
                    Tab(text: 'Browse', icon: Icon(Icons.medication)),
                    Tab(text: 'Upload', icon: Icon(Icons.camera_alt)),
                    Tab(text: 'History', icon: Icon(Icons.history)),
                  ],
                ),
              ),

              // Tab content
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildBrowseTab(colorScheme, theme),
                    _buildUploadTab(colorScheme, theme),
                    _buildHistoryTab(colorScheme, theme),
                  ],
                ),
              ),
            ],
          ),

          // Order summary overlay
          if (_showOrderSummary)
            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _showOrderSummary = false;
                  });
                },
                child: Container(
                  color: Colors.black.withValues(alpha: 0.5),
                ),
              ),
            ),

          if (_showOrderSummary)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: OrderSummaryWidget(
                orderItems: _orderItems,
                deliveryOption: _selectedDeliveryOption,
                paymentMethod: _selectedPaymentMethod,
                onPlaceOrder: _placeOrder,
                isLoading: _isLoading,
              ),
            ),
        ],
      ),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: 2, // Medicine ordering index
        onTap: (index) {
          // Handle navigation
        },
      ),
    );
  }

  Widget _buildBrowseTab(ColorScheme colorScheme, ThemeData theme) {
    return SingleChildScrollView(
      controller: _scrollController,
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Categories filter
          SizedBox(
            height: 6.h,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildCategoryChip('All', true, colorScheme, theme),
                const SizedBox(width: 8),
                _buildCategoryChip('Antibiotics', false, colorScheme, theme),
                const SizedBox(width: 8),
                _buildCategoryChip('Pain Relief', false, colorScheme, theme),
                const SizedBox(width: 8),
                _buildCategoryChip('Vitamins', false, colorScheme, theme),
                const SizedBox(width: 8),
                _buildCategoryChip('Cardiovascular', false, colorScheme, theme),
              ],
            ),
          ),

          SizedBox(height: 2.h),

          // Medications grid
          _filteredMedications.isEmpty
              ? _buildEmptyState(colorScheme, theme)
              : GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 3.w,
                    mainAxisSpacing: 2.h,
                  ),
                  itemCount: _filteredMedications.length,
                  itemBuilder: (context, index) {
                    final medication = _filteredMedications[index];
                    return _buildMedicationCard(medication, colorScheme, theme);
                  },
                ),
        ],
      ),
    );
  }

  Widget _buildUploadTab(ColorScheme colorScheme, ThemeData theme) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Upload Prescription',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Take a photo of your prescription or upload from gallery',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 3.h),

          // Prescription upload widget
          PrescriptionUploadWidget(
            onImageCaptured: _onPrescriptionImageCaptured,
            onPrescriptionDetailsExtracted: _onPrescriptionDetailsExtracted,
          ),

          SizedBox(height: 3.h),

          // Extracted details (if available)
          if (_extractedPrescriptionDetails != null) ...[
            Text(
              'Extracted Information',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 1.h),
            _buildExtractedDetailsCard(colorScheme, theme),
            SizedBox(height: 2.h),
          ],

          // Delivery and payment options
          DeliveryOptionsWidget(
            onDeliveryOptionSelected: _onDeliveryOptionSelected,
            selectedOption: _selectedDeliveryOption,
          ),

          SizedBox(height: 3.h),

          PaymentMethodWidget(
            onPaymentMethodSelected: _onPaymentMethodSelected,
            selectedMethod: _selectedPaymentMethod,
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryTab(ColorScheme colorScheme, ThemeData theme) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: PrescriptionHistoryWidget(
        onReorder: _onReorderPrescription,
      ),
    );
  }

  Widget _buildCategoryChip(
    String label,
    bool isSelected,
    ColorScheme colorScheme,
    ThemeData theme,
  ) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        // Handle category filter
      },
      backgroundColor: colorScheme.surfaceContainerHighest,
      selectedColor: colorScheme.primary.withValues(alpha: 0.2),
      checkmarkColor: colorScheme.primary,
      labelStyle: theme.textTheme.labelMedium?.copyWith(
        color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected
              ? colorScheme.primary
              : colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
    );
  }

  Widget _buildMedicationCard(
    Map<String, dynamic> medication,
    ColorScheme colorScheme,
    ThemeData theme,
  ) {
    final inStock = medication["inStock"] as bool;
    final requiresPrescription = medication["requiresPrescription"] as bool;
    final price = medication["price"] as double;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Medication image
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    color: colorScheme.surfaceContainerHighest,
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    child: CustomImageWidget(
                      imageUrl: medication["image"] as String,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                // Stock status
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color:
                          inStock ? AppTheme.successLight : AppTheme.errorLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      inStock ? 'In Stock' : 'Out of Stock',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: Colors.white,
                        fontSize: 8.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                // Prescription required badge
                if (requiresPrescription)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.warningLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomIconWidget(
                            iconName: 'medical_services',
                            color: Colors.white,
                            size: 10,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            'Rx',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: Colors.white,
                              fontSize: 8.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Medication details
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    medication["name"] as String,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${medication["dosage"]} • ${medication["form"]}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${price.toStringAsFixed(2)}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        width: 32,
                        height: 32,
                        child: IconButton(
                          onPressed:
                              inStock ? () => _addToOrder(medication) : null,
                          icon: CustomIconWidget(
                            iconName: 'add_shopping_cart',
                            color: inStock
                                ? colorScheme.primary
                                : colorScheme.onSurfaceVariant,
                            size: 18,
                          ),
                          style: IconButton.styleFrom(
                            backgroundColor: inStock
                                ? colorScheme.primary.withValues(alpha: 0.1)
                                : colorScheme.surfaceContainerHighest,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ColorScheme colorScheme, ThemeData theme) {
    return Container(
      height: 40.h,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'search_off',
            color: colorScheme.onSurfaceVariant,
            size: 48,
          ),
          SizedBox(height: 2.h),
          Text(
            'No medications found',
            style: theme.textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search terms',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExtractedDetailsCard(ColorScheme colorScheme, ThemeData theme) {
    final details = _extractedPrescriptionDetails!;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.successLight.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'check_circle',
                color: AppTheme.successLight,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Prescription Details',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: AppTheme.successLight,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...details.entries.map((entry) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 25.w,
                      child: Text(
                        '${entry.key.replaceAll(RegExp(r'([A-Z])'), ' \$1').trim()}:',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        entry.value,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildBarcodeScanner() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan Barcode'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: MobileScanner(
        onDetect: (capture) {
          final List<Barcode> barcodes = capture.barcodes;
          for (final barcode in barcodes) {
            final String? code = barcode.rawValue;
            if (code != null) {
              Navigator.pop(context);
              _searchController.text = code;
              _filterMedications();
              break;
            }
          }
        },
      ),
    );
  }

  Widget _buildOrderConfirmationDialog() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppTheme.successLight,
                shape: BoxShape.circle,
              ),
              child: CustomIconWidget(
                iconName: 'check',
                color: Colors.white,
                size: 32,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Order Placed Successfully!',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Your order #MED${DateTime.now().millisecondsSinceEpoch.toString().substring(8)} has been confirmed.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Continue Shopping'),
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // Navigate to order tracking
              },
              child: Text('Track Order'),
            ),
          ],
        ),
      ),
    );
  }
}
