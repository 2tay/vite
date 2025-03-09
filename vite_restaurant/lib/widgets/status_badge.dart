// status_badge.dart
import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';

enum StatusType {
  available,
  occupied,
  preparing,
  ready,
  delivered,
  received,
  cancelled
}

class StatusBadge extends StatelessWidget {
  final StatusType status;
  final bool mini;

  const StatusBadge({
    Key? key,
    required this.status,
    this.mini = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    String text;
    IconData? icon;

    // Define properties based on status
    switch (status) {
      case StatusType.available:
        backgroundColor = AppColors.tableAvailable;
        text = "Available";
        icon = Icons.check_circle;
        break;
      case StatusType.occupied:
        backgroundColor = AppColors.tableOccupied;
        text = "Occupied";
        icon = Icons.people;
        break;
      case StatusType.preparing:
        backgroundColor = AppColors.orderPreparing;
        text = "Preparing";
        icon = Icons.restaurant;
        break;
      case StatusType.ready:
        backgroundColor = AppColors.orderReady;
        text = "Ready";
        icon = Icons.dinner_dining;
        break;
      case StatusType.delivered:
        backgroundColor = AppColors.orderDelivered;
        text = "Delivered";
        icon = Icons.delivery_dining;
        break;
      case StatusType.received:
        backgroundColor = AppColors.orderReceived;
        text = "Received";
        icon = Icons.receipt_long;
        break;
      case StatusType.cancelled:
        backgroundColor = AppColors.error;
        text = "Cancelled";
        icon = Icons.cancel;
        break;
    }

    if (mini) {
      return Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor.withOpacity(0.1),
        border: Border.all(color: backgroundColor),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 16,
              color: backgroundColor,
            ),
            const SizedBox(width: 4),
          ],
          Text(
            text,
            style: AppTypography.labelSmall.copyWith(
              color: backgroundColor,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}