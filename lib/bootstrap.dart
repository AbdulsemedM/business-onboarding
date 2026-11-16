import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

import 'app.dart';
import 'core/api/api_client.dart';
import 'core/config/app_config.dart';
import 'core/storage/session_store.dart';
import 'features/auth/data/auth_repository.dart';
import 'features/documents/data/document_repository.dart';
import 'features/onboarding/data/application_repository.dart';
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

  const config = AppConfig.current;
  if (!config.usesRealApi) {
    // No API_BASE_URL: mock repositories, always signed in.
    runApp(App(draftStore: draftStore));
    return;
  }

  final session = SecureSessionStore(secureStorage);
  final expired = StreamController<void>.broadcast();
  final api = createApiClient(
    config: config,
    sessionStore: session,
    onSessionExpired: () => expired.add(null),
  );
  runApp(
    App(
      draftStore: draftStore,
      authRepository: ApiAuthRepository(
        dio: api,
        sessionStore: session,
        sessionExpired: expired.stream,
      ),
      applicationRepository: ApiApplicationRepository(
        dio: api,
        sessionStore: session,
      ),
      documentRepository: ApiDocumentRepository(
        api: api,
        uploadClient: createUploadClient(),
        sessionStore: session,
      ),
    ),
  );
}
