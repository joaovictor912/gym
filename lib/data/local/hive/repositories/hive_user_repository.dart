import 'package:hive/hive.dart';

import '../../../../core/errors/local_storage_exception.dart';
import '../../../local/hive/hive_boxes.dart';
import '../../../../domain/entities/user.dart';
import '../../../../domain/repositories/user_repository.dart';
import '../models/hive_user_profile_model.dart';

class HiveUserRepository implements UserRepository {
  static const _currentUserIdKey = 'current_user_id';

  final Box _meta;
  final Box<HiveUserProfileModel> _users;

  HiveUserRepository({
    required Box metaBox,
    required Box<HiveUserProfileModel> userBox,
  })  : _meta = metaBox,
        _users = userBox;

  factory HiveUserRepository.open() {
    return HiveUserRepository(
      metaBox: Hive.box(HiveBoxes.meta),
      userBox: Hive.box<HiveUserProfileModel>(HiveBoxes.userProfile),
    );
  }

  @override
  Future<User?> getUser() async {
    try {
      final currentId = _meta.get(_currentUserIdKey) as String?;
      if (currentId == null) return null;
      final model = _users.get(currentId);
      return model?.toDomain();
    } catch (e, st) {
      throw LocalStorageException('Failed to read user', cause: e, stackTrace: st);
    }
  }

  @override
  Future<void> saveUser(User user) async {
    try {
      final model = HiveUserProfileModel.fromDomain(user);
      await _users.put(model.id, model);
      await _meta.put(_currentUserIdKey, model.id);
    } catch (e, st) {
      throw LocalStorageException('Failed to save user', cause: e, stackTrace: st);
    }
  }
}
