import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class OrderSummaryWidget extends StatelessWidget {
  final List<Map<String, dynamic>> orderItems;
  final Map<String, dynamic>? deliveryOption;
  final Map<String, dynamic>? paymentMethod;
  final Function() onPlaceOrder;
  final bool isLoading;

  const OrderSummaryWidget({
    super.key,
    required this.orderItems,
    this.deliveryOption,
    this.paymentMethod,
    required this.onPlaceOrder,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final subtotal = _calculateSubtotal();
    final deliveryFee = deliveryOption?["cost"] as double? ?? 0.0;
    final tax = subtotal * 0.08; // 8% tax
    final total = subtotal + deliveryFee + tax;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
            padding: EdgeInsets.all(4.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order Summary',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${orderItems.length} item${orderItems.length != 1 ? 's' : ''}',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Order items
          if (orderItems.isNotEmpty) ...[
            Container(
              constraints: BoxConstraints(maxHeight: 25.h),
              child: ListView.separated(
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                itemCount: orderItems.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final item = orderItems[index];
                  return _buildOrderItem(item, colorScheme, theme);
                },
              ),
            ),
            SizedBox(height: 2.h),
          ],

          // Delivery info
          if (deliveryOption != null) ...[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: _buildDeliveryInfo(deliveryOption!, colorScheme, theme),
            ),
            SizedBox(height: 2.h),
          ],

          // Payment method
          if (paymentMethod != null) ...[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: _buildPaymentInfo(paymentMethod!, colorScheme, theme),
            ),
            SizedBox(height: 2.h),
          ],

          // Price breakdown
          Container(
            margin: EdgeInsets.symmetric(horizontal: 4.w),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                _buildPriceRow(
                  'Subtotal',
                  '\$${subtotal.toStringAsFixed(2)}',
                  theme,
                  colorScheme,
                ),
                const SizedBox(height: 8),
                _buildPriceRow(
                  'Delivery Fee',
                  deliveryFee == 0
                      ? 'FREE'
                      : '\$${deliveryFee.toStringAsFixed(2)}',
                  theme,
                  colorScheme,
                  valueColor: deliveryFee == 0 ? AppTheme.successLight : null,
                ),
                const SizedBox(height: 8),
                _buildPriceRow(
                  'Tax',
                  '\$${tax.toStringAsFixed(2)}',
                  theme,
                  colorScheme,
                ),
                const Divider(height: 24),
                _buildPriceRow(
                  'Total',
                  '\$${total.toStringAsFixed(2)}',
                  theme,
                  colorScheme,
                  isTotal: true,
                ),
              ],
            ),
          ),

          SizedBox(height: 2.h),

          // Estimated delivery time
          if (deliveryOption != null) ...[
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.successLight.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.successLight.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'schedule',
                    color: AppTheme.successLight,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Estimated delivery: ${deliveryOption!["estimatedTime"]}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.successLight,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 2.h),
          ],

          // Place order button
          Padding(
            padding: EdgeInsets.fromLTRB(4.w, 0, 4.w, 4.w),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                    isLoading || orderItems.isEmpty ? null : onPlaceOrder,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: isLoading
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            colorScheme.onPrimary,
                          ),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomIconWidget(
                            iconName: 'shopping_cart_checkout',
                            color: colorScheme.onPrimary,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Place Order • \$${total.toStringAsFixed(2)}',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: colorScheme.onPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),

          // Bottom safe area
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  Widget _buildOrderItem(
    Map<String, dynamic> item,
    ColorScheme colorScheme,
    ThemeData theme,
  ) {
    final quantity = item["quantity"] as int? ?? 1;
    final price = item["price"] as double? ?? 0.0;
    final total = quantity * price;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          // Medication image
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
            ),
            child: item["image"] != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CustomImageWidget(
                      imageUrl: item["image"] as String,
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                    ),
                  )
                : Center(
                    child: CustomIconWidget(
                      iconName: 'medication',
                      color: colorScheme.onSurfaceVariant,
                      size: 24,
                    ),
                  ),
          ),

          const SizedBox(width: 12),

          // Item details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item["medicationName"] as String? ?? 'Unknown Medication',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '${item["dosage"] ?? 'Unknown dosage'} • Qty: $quantity',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),

          // Price
          Text(
            '\$${total.toStringAsFixed(2)}',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryInfo(
    Map<String, dynamic> delivery,
    ColorScheme colorScheme,
    ThemeData theme,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: delivery["icon"] as String,
            color: colorScheme.primary,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  delivery["title"] as String,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  delivery["estimatedTime"] as String,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentInfo(
    Map<String, dynamic> payment,
    ColorScheme colorScheme,
    ThemeData theme,
  ) {
    final cardType = payment["cardType"] as String? ?? 'card';
    final lastFour = payment["lastFour"] as String? ?? '0000';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName:
                payment["type"] == "campus_card" ? 'school' : 'credit_card',
            color: colorScheme.primary,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getPaymentDisplayName(cardType),
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '•••• •••• •••• $lastFour',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(
    String label,
    String value,
    ThemeData theme,
    ColorScheme colorScheme, {
    bool isTotal = false,
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isTotal
              ? theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                )
              : theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
        ),
        Text(
          value,
          style: isTotal
              ? theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.primary,
                )
              : theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: valueColor ?? colorScheme.onSurface,
                ),
        ),
      ],
    );
  }

  double _calculateSubtotal() {
    return orderItems.fold(0.0, (sum, item) {
      final quantity = item["quantity"] as int? ?? 1;
      final price = item["price"] as double? ?? 0.0;
      return sum + (quantity * price);
    });
  }

  String _getPaymentDisplayName(String cardType) {
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
}
