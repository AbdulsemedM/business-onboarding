import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

import 'app.dart';
import 'core/storage/draft_store.dart';
import 'core/utils/safe_log.dart';

/// Starts the app: sets up error handling and local storage, then runs [App].
Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Error details can contain user data, so only the type is logged.
  // TODO(crash-reporting): forward to a crash reporter with data scrubbed.
  FlutterError.onError = (details) {
    safeLog('Flutter error: ${details.exception.runtimeType}');
    if (kDebugMode) FlutterError.presentError(details);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    safeLog('Uncaught error: ${error.runtimeType}');
    return true;
  };

  await Hive.initFlutter();
  const secureStorage = FlutterSecureStorage();
  final draftStore = await HiveDraftStore.open(secureStorage);

  runApp(App(draftStore: draftStore));
}
