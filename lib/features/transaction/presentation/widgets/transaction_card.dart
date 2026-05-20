import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/services/currency_formatter.dart';
import '../../../../core/themes/app_theme.dart';
import '../../domain/entities/transaction_entity.dart';
import '../bloc/transaction_bloc.dart';
import '../bloc/transaction_event.dart';

class TransactionCard extends StatelessWidget {
  final TransactionEntity txn;
  final bool showDeleteButton;

  const TransactionCard({
    super.key,
    required this.txn,
    this.showDeleteButton = false,
  });

  @override
  Widget build(BuildContext context) {
    final isCredit = txn.type == 'credit';
    return Dismissible(
      key: Key(txn.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppTheme.debit.withOpacity(0.15),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_outline, color: AppTheme.debit),
      ),
      confirmDismiss: (_) async {
        return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Delete Transaction'),
            content:
            const Text('This will remove the transaction from your list.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Delete',
                    style: TextStyle(color: AppTheme.debit)),
              ),
            ],
          ),
        );
      },
      onDismissed: (_) {
        context
            .read<TransactionBloc>()
            .add(DeleteTransactionEvent(txn.id));
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.black12,
          border: Border.all(color: Colors.white70),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Category icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color:
                (isCredit ? AppTheme.credit : AppTheme.debit)
                    .withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                isCredit
                    ? Icons.arrow_downward_rounded
                    : Icons.arrow_upward_rounded,
                color: isCredit ? AppTheme.credit : AppTheme.debit,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            // Note + category
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    txn.note,
                    style: const TextStyle(
                      color: AppTheme.surface,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppTheme.primary.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          txn.categoryName.isEmpty
                              ? 'Uncategorized'
                              : txn.categoryName,
                          style: const TextStyle(
                            color: AppTheme.shimmerBase,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Amount + sync status
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  DateFormat('dd MMM, hh:mm a').format(txn.timestamp),
                  style: const TextStyle(
                    color: AppTheme.background,
                    fontSize: 11,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  '${isCredit ? '+' : '-'}${CurrencyFormatter.format(txn.amount)}',
                  style: TextStyle(
                    color: isCredit ? AppTheme.credit : AppTheme.debit,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),

              ],
            ),
            const SizedBox(height: 8),

            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: () async {
                final shouldDelete = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    backgroundColor: Colors.black,
                    title: const Text(
                      'Delete Transaction',
                      style: TextStyle(color: Colors.white),
                    ),
                    content: const Text(
                      'Are you sure you want to delete this transaction?',
                      style: TextStyle(color: Colors.white70),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        child: const Text(
                          'Delete',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                );

                if (shouldDelete == true) {
                  context
                      .read<TransactionBloc>()
                      .add(DeleteTransactionEvent(txn.id));
                }
              },
              icon: const Icon(
                Icons.delete_outline,
                color: Colors.red,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}