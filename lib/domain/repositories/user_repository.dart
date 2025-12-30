import '../entities/user.dart';

abstract interface class UserRepository {
  Future<User?> getUser();
  Future<void> saveUser(User user);
}
