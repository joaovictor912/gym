import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/in_memory_datasource.dart';
import '../models/user_model.dart';

class InMemoryUserRepository implements UserRepository {
  final InMemoryDatasource _datasource;

  const InMemoryUserRepository(this._datasource);

  @override
  Future<User?> getUser() async {
    final model = _datasource.user;
    return model?.toEntity();
  }

  @override
  Future<void> saveUser(User user) async {
    _datasource.user = UserModel.fromEntity(user);
  }
}
