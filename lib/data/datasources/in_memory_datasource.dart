import '../../core/time/date_only.dart';
import '../models/food_entry_model.dart';
import '../models/user_model.dart';
import '../models/workout_model.dart';

class InMemoryDatasource {
  UserModel? user;

  final Map<DateTime, List<WorkoutModel>> workoutsByDay = {};
  final Map<DateTime, List<FoodEntryModel>> foodsByDay = {};

  InMemoryDatasource({UserModel? seedUser}) {
    user = seedUser;
  }

  List<WorkoutModel> workoutsForDay(DateTime day) {
    final key = dateOnly(day);
    return List.unmodifiable(workoutsByDay[key] ?? const []);
  }

  List<FoodEntryModel> foodsForDay(DateTime day) {
    final key = dateOnly(day);
    return List.unmodifiable(foodsByDay[key] ?? const []);
  }

  void upsertWorkout(WorkoutModel workout) {
    final dayKey = dateOnly(workout.startedAt);
    final current = List<WorkoutModel>.from(workoutsByDay[dayKey] ?? const []);
    final index = current.indexWhere((w) => w.id == workout.id);
    if (index >= 0) {
      current[index] = workout;
    } else {
      current.add(workout);
    }
    workoutsByDay[dayKey] = current;
  }

  void deleteWorkout({required DateTime day, required String workoutId}) {
    final dayKey = dateOnly(day);
    final current = List<WorkoutModel>.from(workoutsByDay[dayKey] ?? const []);
    current.removeWhere((w) => w.id == workoutId);
    workoutsByDay[dayKey] = current;
  }

  void upsertFood(FoodEntryModel entry) {
    final dayKey = dateOnly(entry.eatenAt);
    final current = List<FoodEntryModel>.from(foodsByDay[dayKey] ?? const []);
    final index = current.indexWhere((e) => e.id == entry.id);
    if (index >= 0) {
      current[index] = entry;
    } else {
      current.add(entry);
    }
    foodsByDay[dayKey] = current;
  }

  void deleteFood({required DateTime day, required String entryId}) {
    final dayKey = dateOnly(day);
    final current = List<FoodEntryModel>.from(foodsByDay[dayKey] ?? const []);
    current.removeWhere((e) => e.id == entryId);
    foodsByDay[dayKey] = current;
  }
}
