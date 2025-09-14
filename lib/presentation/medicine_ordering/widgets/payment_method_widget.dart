import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PaymentMethodWidget extends StatefulWidget {
  final Function(Map<String, dynamic>) onPaymentMethodSelected;
  final Map<String, dynamic>? selectedMethod;

  const PaymentMethodWidget({
    super.key,
    required this.onPaymentMethodSelected,
    this.selectedMethod,
  });

  @override
  State<PaymentMethodWidget> createState() => _PaymentMethodWidgetState();
}

class _PaymentMethodWidgetState extends State<PaymentMethodWidget> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> paymentMethods = [
    {
      "id": "card_1",
      "type": "credit_card",
      "cardType": "visa",
      "lastFour": "4532",
      "expiryMonth": 12,
      "expiryYear": 2026,
      "holderName": "John Student",
      "isDefault": true,
      "icon": "credit_card",
    },
    {
      "id": "card_2",
      "type": "debit_card",
      "cardType": "mastercard",
      "lastFour": "8901",
      "expiryMonth": 8,
      "expiryYear": 2025,
      "holderName": "John Student",
      "isDefault": false,
      "icon": "credit_card",
    },
    {
      "id": "campus_card",
      "type": "campus_card",
      "cardType": "campus",
      "lastFour": "2345",
      "balance": 127.50,
      "holderName": "John Student",
      "isDefault": false,
      "icon": "school",
    },
    {
      "id": "add_new",
      "type": "add_new",
      "title": "Add New Payment Method",
      "icon": "add_circle_outline",
    },
  ];

  @override
  void initState() {
    super.initState();
    if (widget.selectedMethod != null) {
      _selectedIndex = paymentMethods.indexWhere(
        (method) => method["id"] == widget.selectedMethod!["id"],
      );
      if (_selectedIndex == -1) _selectedIndex = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Payment Method',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              CustomIconWidget(
                iconName: 'security',
                color: AppTheme.successLight,
                size: 20,
              ),
            ],
          ),
        ),
        SizedBox(height: 2.h),

        // Payment methods list
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          itemCount: paymentMethods.length,
          separatorBuilder: (context, index) => SizedBox(height: 1.h),
          itemBuilder: (context, index) {
            final method = paymentMethods[index];
            final isSelected = _selectedIndex == index;

            if (method["type"] == "add_new") {
              return _buildAddNewCard(method, colorScheme, theme);
            }

            return _buildPaymentCard(
              method,
              isSelected,
              index,
              colorScheme,
              theme,
            );
          },
        ),

        SizedBox(height: 2.h),

        // Security notice
        Container(
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.successLight.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppTheme.successLight.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: [
              CustomIconWidget(
                iconName: 'shield',
                color: AppTheme.successLight,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Secure Payment',
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: AppTheme.successLight,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Your payment information is encrypted and secure. We never store your full card details.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.successLight,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentCard(
    Map<String, dynamic> method,
    bool isSelected,
    int index,
    ColorScheme colorScheme,
    ThemeData theme,
  ) {
    final cardType = method["cardType"] as String;
    final lastFour = method["lastFour"] as String;
    final holderName = method["holderName"] as String;
    final isDefault = method["isDefault"] as bool? ?? false;

    return GestureDetector(
      onTap: () => _selectPaymentMethod(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? colorScheme.primary
                : colorScheme.outline.withValues(alpha: 0.2),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: colorScheme.primary.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            // Card icon and type
            Container(
              width: 48,
              height: 32,
              decoration: BoxDecoration(
                color: _getCardColor(cardType).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: method["type"] == "campus_card"
                    ? CustomIconWidget(
                        iconName: 'school',
                        color: _getCardColor(cardType),
                        size: 20,
                      )
                    : _buildCardLogo(cardType),
              ),
            ),

            const SizedBox(width: 16),

            // Card details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        _getCardDisplayName(cardType),
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (isDefault) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.primary,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'DEFAULT',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: colorScheme.onPrimary,
                              fontSize: 8.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '•••• •••• •••• $lastFour',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontFamily: 'monospace',
                    ),
                  ),
                  if (method["type"] == "campus_card") ...[
                    const SizedBox(height: 4),
                    Text(
                      'Balance: \$${(method["balance"] as double).toStringAsFixed(2)}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.successLight,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ] else ...[
                    const SizedBox(height: 4),
                    Text(
                      'Expires ${method["expiryMonth"].toString().padLeft(2, '0')}/${method["expiryYear"]}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Selection indicator
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? colorScheme.primary : Colors.transparent,
                border: Border.all(
                  color: isSelected ? colorScheme.primary : colorScheme.outline,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Icon(
                      Icons.check,
                      color: colorScheme.onPrimary,
                      size: 16,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddNewCard(
    Map<String, dynamic> method,
    ColorScheme colorScheme,
    ThemeData theme,
  ) {
    return GestureDetector(
      onTap: _showAddPaymentMethodDialog,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: colorScheme.outline.withValues(alpha: 0.2),
            style: BorderStyle.solid,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 32,
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: 'add',
                  color: colorScheme.primary,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                method["title"] as String,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            CustomIconWidget(
              iconName: 'arrow_forward_ios',
              color: colorScheme.onSurfaceVariant,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardLogo(String cardType) {
    switch (cardType.toLowerCase()) {
      case 'visa':
        return Container(
          padding: const EdgeInsets.all(4),
          child: Text(
            'VISA',
            style: TextStyle(
              color: Colors.blue[800],
              fontSize: 10.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      case 'mastercard':
        return Container(
          padding: const EdgeInsets.all(4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(left: -4),
                decoration: const BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        );
      default:
        return CustomIconWidget(
          iconName: 'credit_card',
          color: Colors.grey[600]!,
          size: 16,
        );
    }
  }

  Color _getCardColor(String cardType) {
    switch (cardType.toLowerCase()) {
      case 'visa':
        return Colors.blue[800]!;
      case 'mastercard':
        return Colors.red[700]!;
      case 'campus':
        return AppTheme.primaryLight;
      default:
        return Colors.grey[600]!;
    }
  }

  String _getCardDisplayName(String cardType) {
    switch (cardType.toLowerCase()) {
      case 'visa':
        return 'Visa';
      case 'mastercard':
        return 'Mastercard';
      case 'campus':
        return 'Campus Card';
      default:
        return 'Card';
    }
  }

  void _selectPaymentMethod(int index) {
    setState(() {
      _selectedIndex = index;
    });
    widget.onPaymentMethodSelected(paymentMethods[index]);
  }

  void _showAddPaymentMethodDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildAddPaymentMethodSheet(),
    );
  }

  Widget _buildAddPaymentMethodSheet() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      height: 70.h,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Add Payment Method',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: colorScheme.onSurfaceVariant,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),

          // Payment method options
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                _buildPaymentOption(
                  icon: 'credit_card',
                  title: 'Credit/Debit Card',
                  subtitle: 'Add Visa, Mastercard, or other cards',
                  onTap: () {
                    Navigator.pop(context);
                    // Navigate to card form
                  },
                  colorScheme: colorScheme,
                  theme: theme,
                ),
                const SizedBox(height: 16),
                _buildPaymentOption(
                  icon: 'account_balance',
                  title: 'Bank Account',
                  subtitle: 'Link your bank account for direct payments',
                  onTap: () {
                    Navigator.pop(context);
                    // Navigate to bank form
                  },
                  colorScheme: colorScheme,
                  theme: theme,
                ),
                const SizedBox(height: 16),
                _buildPaymentOption(
                  icon: 'school',
                  title: 'Campus Card',
                  subtitle: 'Use your student ID card balance',
                  onTap: () {
                    Navigator.pop(context);
                    // Navigate to campus card form
                  },
                  colorScheme: colorScheme,
                  theme: theme,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption({
    required String icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required ColorScheme colorScheme,
    required ThemeData theme,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: CustomIconWidget(
                iconName: icon,
                color: colorScheme.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            CustomIconWidget(
              iconName: 'arrow_forward_ios',
              color: colorScheme.onSurfaceVariant,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
