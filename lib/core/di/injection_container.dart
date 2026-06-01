// core/di/injection_container.dart
import 'package:get_it/get_it.dart';


import '../../features/transaction/data/datasources/transaction_local_datasource.dart';
import '../../features/transaction/domain/repositories/transaction_repository.dart';
import '../../features/transaction/domain/usecases/sync_usecase.dart';
import '../../features/transaction/domain/usecases/transaction_usecase.dart';
import '../../features/transaction/presentation/bloc/category_bloc.dart';
import '../../features/transaction/presentation/bloc/dashboard_bloc.dart';
import '../../features/transaction/presentation/bloc/sync_bloc.dart';
import '../../features/transaction/presentation/bloc/transaction_bloc.dart';
import '../database/local_db_helper.dart';
import '../services/notification_service.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Core
  sl.registerLazySingleton(() => LocalDbHelper());
  sl.registerLazySingleton(() => NotificationService());
 // sl.registerLazySingleton(() => Dio()..interceptors.add(AuthInterceptor()));

  // Datasources
  sl.registerLazySingleton(() => TransactionLocalDatasource(sl()));
  //sl.registerLazySingleton(() => TransactionRemoteDatasource(sl()));
 // sl.registerLazySingleton(() => CategoryLocalDatasource());
 // sl.registerLazySingleton(() => CategoryRemoteDatasource(sl()));

  // Repositories
  sl.registerLazySingleton<TransactionRepository>(sl());
  // sl.registerLazySingleton<CategoryRepository>(
  //   () => CategoryRepositoryImpl(sl()),
  // );

  // Use cases
  sl.registerLazySingleton(() => AddTransaction(sl()));
  sl.registerLazySingleton(() => GetTransactions(sl()));
  sl.registerLazySingleton(() => SoftDeleteTransaction(sl()));
  sl.registerLazySingleton(() => SyncUsecase(sl(), sl()));
  sl.registerLazySingleton(() => CheckBudgetLimit(sl()));

  // BLoCs (factory — new instance per page)
  sl.registerFactory(
    () => TransactionBloc(
      addTransaction: sl(),
      getTransactions: sl(),
      softDelete: sl(),
      notificationService: sl(),
      checkBudgetLimit: sl(),
    ),
  );
  sl.registerFactory(() => CategoryBloc(sl(), sl(), sl()));
  sl.registerFactory(() => SyncBloc(sl()));
  sl.registerFactory(() => DashboardBloc(sl()));
}
