import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/session_provider.dart';

class ActivityObserver extends ProviderObserver {
  @override
  void didUpdateProvider(
    ProviderBase provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    if (provider != sessionProvider) {
      container.read(sessionProvider).updateLastActive();
    }
  }
}
