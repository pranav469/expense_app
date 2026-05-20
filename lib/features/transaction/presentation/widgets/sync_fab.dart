import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/category_bloc.dart';
import '../bloc/category_event.dart';
import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_event.dart';
import '../bloc/sync_bloc.dart';
import '../bloc/sync_event.dart';
import '../bloc/sync_state.dart';
import '../bloc/transaction_bloc.dart';
import '../bloc/transaction_event.dart';


class SyncFab extends StatefulWidget {
  const SyncFab({super.key});

  @override
  State<SyncFab> createState() => _SyncFabState();
}

class _SyncFabState extends State<SyncFab>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startSync() {
    context.read<SyncBloc>().add(const TriggerSync());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SyncBloc, SyncState>(
      listener: (context, state) {
        if (state is SyncInProgress) {
          _controller.repeat();
        } else {
          _controller.stop();
          _controller.reset();
        }

        if (state is SyncSuccess) {
          context.read<TransactionBloc>().add( LoadTransactions());
          context.read<CategoryBloc>().add(const LoadCategories());
          context.read<DashboardBloc>().add(const LoadDashboard());
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Sync complete ✓'),
            //  backgroundColor: AppTheme.accent,
              duration: Duration(seconds: 2),
            ),
          );
        }

        if (state is SyncFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Sync failed: ${state.error}'),
            //  backgroundColor: AppTheme.debit,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is SyncInProgress;
        return FloatingActionButton.extended(
          onPressed: isLoading ? null : _startSync,
          backgroundColor: isLoading ? Colors.grey.shade300 : Colors.green,
          elevation: 4,
          icon: RotationTransition(
            turns: _controller,
            child: Icon(
              Icons.sync_rounded,
              color: isLoading ? Colors.grey : Colors.white,
            ),
          ),
          label: Text(
            isLoading ? (state as SyncInProgress).message : 'Sync',
            style: TextStyle(
              color: isLoading ? Colors.grey : Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        );
      },
    );
  }
}