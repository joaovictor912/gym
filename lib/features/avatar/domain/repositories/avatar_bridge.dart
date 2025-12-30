/// Bridge to the Unity layer (Unity as a Library).
///
/// Domain depends only on this interface. The concrete implementation lives in
/// the presentation/infrastructure layer (platform channels).
abstract interface class AvatarBridge {
  Future<void> setLevel(int level);
  Future<void> playIdle();
  Future<void> playLevelUp();
}
