import 'package:expense_manager/core/network/dio_client.dart';
import 'package:expense_manager/core/services/auth_wrapper.dart';
import 'package:expense_manager/features/transaction/data/repositories/transaction_repository_impl.dart';
import 'package:expense_manager/features/transaction/domain/usecases/category_usecase.dart';
import 'package:expense_manager/features/transaction/presentation/bloc/category_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/services/notification_service.dart';
import 'features/auth/data/data_source/auth_remote_datasource.dart';
import 'features/auth/data/repository/auth_repository_impl.dart';
import 'features/auth/domain/usecases/create_account_usecase.dart';
import 'features/auth/domain/usecases/send_otp_usecase.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/transaction/data/repositories/category_repository_impl.dart';
import 'features/onboarding/presentations/pages/onboarding_page.dart';
import 'features/transaction/data/repositories/dashboard_repository_impl.dart';
import 'features/transaction/domain/usecases/get_dashboard_stats.dart';
import 'features/transaction/domain/usecases/sync_usecase.dart';
import 'features/transaction/domain/usecases/transaction_usecase.dart';
import 'features/transaction/presentation/bloc/dashboard_bloc.dart';
import 'features/transaction/presentation/bloc/dashboard_event.dart';
import 'features/transaction/presentation/bloc/sync_bloc.dart';
import 'features/transaction/presentation/bloc/transaction_bloc.dart';
import 'features/transaction/presentation/bloc/transaction_event.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthBloc(
            sendOtpUsecase: SendOtpUsecase(
              AuthRepositoryImpl(AuthRemoteDatasource()),
            ),
            createAccountUsecase: CreateAccountUsecase(
              AuthRepositoryImpl(AuthRemoteDatasource()),
            ),
          ),
        ),
        BlocProvider<DashboardBloc>(
          create: (_) => DashboardBloc(
            GetDashboardStats(
              DashboardRepositoryImpl(
                TransactionRepositoryImpl(DioClient.dio),
              ),
            ),
          )..add(const LoadDashboard()),
        ),

        BlocProvider<TransactionBloc>(
          create: (_) => TransactionBloc(
            addTransaction: AddTransaction(
              TransactionRepositoryImpl(DioClient.dio),
            ),
            getTransactions: GetTransactions(
              TransactionRepositoryImpl(DioClient.dio),
            ),
            softDelete: SoftDeleteTransaction(
              TransactionRepositoryImpl(DioClient.dio),
            ),
            checkBudgetLimit: CheckBudgetLimit(
              TransactionRepositoryImpl(DioClient.dio),
            ),
            notificationService: NotificationService(),
          )..add(LoadTransactions()),
        ),
        BlocProvider<SyncBloc>(
          create: (_) => SyncBloc(
            SyncUsecase(
              TransactionRepositoryImpl(DioClient.dio),
              CategoryRepositoryImpl(DioClient.dio
              ),
            ),
          ),
        ),

        BlocProvider<CategoryBloc>(
          create: (_) => CategoryBloc(
            GetCategories(CategoryRepositoryImpl(DioClient.dio)),
            AddCategory(CategoryRepositoryImpl(DioClient.dio)),
            SoftDeleteCategory(CategoryRepositoryImpl(DioClient.dio)),
          ),
        ),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        routes: {
          //'/': (context) => const OnboardingPage(),
          '/login': (context) => LoginPage(),
        },
        home: AuthWrapper(),
      ),
    );
  }
}
