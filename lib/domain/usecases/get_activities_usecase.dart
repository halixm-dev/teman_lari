import '../entities/activity.dart';
import '../repositories/activity_repository.dart';

class GetActivitiesUseCase {
  final ActivityRepository repository;

  GetActivitiesUseCase(this.repository);

  Future<List<Activity>> execute({int monthsBack = 12}) {
    return repository.getAllActivities(monthsBack: monthsBack);
  }
}
