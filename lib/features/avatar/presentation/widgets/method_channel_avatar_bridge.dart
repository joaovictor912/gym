import 'package:flutter/services.dart';

import '../../domain/repositories/avatar_bridge.dart';

class MethodChannelAvatarBridge implements AvatarBridge {
  static const MethodChannel _channel = MethodChannel('ht/avatar');

  const MethodChannelAvatarBridge();

  @override
  Future<void> playIdle() => _channel.invokeMethod<void>('playIdle');

  @override
  Future<void> playLevelUp() => _channel.invokeMethod<void>('playLevelUp');

  @override
  Future<void> setLevel(int level) => _channel.invokeMethod<void>('setLevel', {'level': level});
}
