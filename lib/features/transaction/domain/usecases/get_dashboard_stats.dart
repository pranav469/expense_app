import '../entities/dashboard_entity.dart';
import '../repositories/dashboard_repository.dart';

class GetDashboardStats {
  final DashboardRepository _repo;
  GetDashboardStats(this._repo);
  Future<DashboardEntity> call() => _repo.getDashboardStats();
}