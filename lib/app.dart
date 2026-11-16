import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';

import 'core/router/app_router.dart';
import 'core/router/routes.dart';
import 'core/storage/draft_store.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/data/auth_repository.dart';
import 'features/auth/logic/auth_cubit.dart';
import 'features/documents/data/document_picker.dart';
import 'features/documents/data/document_repository.dart';
import 'features/documents/data/file_preparer.dart';
import 'features/onboarding/data/application_repository.dart';
import 'features/onboarding/logic/wizard_cubit.dart';
import 'l10n/app_localizations.dart';

class App extends StatefulWidget {
  const App({
    super.key,
    required this.draftStore,
    this.initialLocation = Routes.welcome,
    this.documentRepository,
    this.documentPicker,
    this.filePreparer,
    this.applicationRepository,
    this.authRepository,
  });

  final DraftStore draftStore;
  final String initialLocation;

  // Overridable for tests and set by bootstrap. Defaults are the real device
  // picker and preparer, and mock repositories (no API_BASE_URL).
  final DocumentRepository? documentRepository;
  final DocumentPicker? documentPicker;
  final FilePreparer? filePreparer;
  final ApplicationRepository? applicationRepository;

  /// Defaults to always signed in (mock API).
  final AuthRepository? authRepository;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final AuthRepository _authRepository =
      widget.authRepository ?? MockAuthRepository();
  late final AuthCubit _authCubit = AuthCubit(repository: _authRepository);
  StreamSubscription<AuthStatus>? _authChanges;
  late final GoRouter _router = createAppRouter(
    auth: _authCubit,
    initialLocation: widget.initialLocation,
  );
  late final WizardCubit _wizardCubit = WizardCubit(
    draftStore: widget.draftStore,
  )..load();

  // Save straight away when the app is backgrounded, in case it gets killed.
  late final AppLifecycleListener _lifecycle = AppLifecycleListener(
    onPause: _wizardCubit.saveNow,
    onDetach: _wizardCubit.saveNow,
  );

  @override
  void initState() {
    super.initState();
    _lifecycle; // Start listening.
    // Keep the local draft tied to the signed-in application.
    _authChanges = _authCubit.stream
        .map((s) => s.status)
        .distinct()
        .where((status) => status == AuthStatus.signedIn)
        .listen((_) => _bindDraft());
    _authCubit.check();
  }

  Future<void> _bindDraft() async {
    final applicationId = await _authRepository.applicationId();
    if (applicationId != null) {
      await _wizardCubit.bindApplication(applicationId);
    }
  }

  @override
  void dispose() {
    _authChanges?.cancel();
    _lifecycle.dispose();
    _wizardCubit.close();
    _router.dispose();
    _authCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<DocumentRepository>(
          create: (_) => widget.documentRepository ?? MockDocumentRepository(),
        ),
        RepositoryProvider<DocumentPicker>(
          create: (_) => widget.documentPicker ?? DeviceDocumentPicker(),
        ),
        RepositoryProvider<FilePreparer>(
          create: (_) => widget.filePreparer ?? FilePreparer(),
        ),
        RepositoryProvider<ApplicationRepository>(
          create: (_) =>
              widget.applicationRepository ?? MockApplicationRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: _wizardCubit),
          BlocProvider.value(value: _authCubit),
        ],
        child: MaterialApp.router(
          onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          // The brand look is white with blue and navy, so don't follow the
          // phone's dark mode. Remove this line to support dark mode.
          themeMode: ThemeMode.light,
          routerConfig: _router,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      ),
    );
  }
}
