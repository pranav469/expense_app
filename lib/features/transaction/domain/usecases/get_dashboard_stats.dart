import '../entities/dashboard_entity.dart';
import '../repositories/dashboard_repository.dart';

class GetDashboardStats {
  final DashboardRepository _repo;
  GetDashboardStats(this._repo);

  //Callable class
  Future<DashboardEntity> call() => _repo.getDashboardStats();
}