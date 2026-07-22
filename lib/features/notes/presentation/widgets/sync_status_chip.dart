import 'package:flutter/material.dart';

import '../../domain/entities/note.dart';

class SyncStatusChip extends StatelessWidget {
  final SyncStatus status;

  const SyncStatusChip({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    late final Color backgroundColor;
    late final Color textColor;
    late final IconData icon;
    late final String label;

    switch (status) {
      case SyncStatus.synced:
        backgroundColor = Colors.green.shade100;
        textColor = Colors.green.shade800;
        icon = Icons.cloud_done;
        label = "Synced";
        break;

      case SyncStatus.pending:
        backgroundColor = Colors.orange.shade100;
        textColor = Colors.orange.shade800;
        icon = Icons.sync;
        label = "Pending";
        break;

      case SyncStatus.conflict:
        backgroundColor = Colors.red.shade100;
        textColor = Colors.red.shade800;
        icon = Icons.warning_amber_rounded;
        label = "Conflict";
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: textColor,
            size: 16,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}