import '../entities/run_activity.dart';
import '../repositories/activity_repository.dart';

class GetActivitiesUseCase {
  final ActivityRepository repository;

  GetActivitiesUseCase(this.repository);

  Future<List<RunActivity>> execute({int monthsBack = 12}) {
    return repository.getAllRunningActivities(monthsBack: monthsBack);
  }
}
