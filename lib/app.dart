import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';

import 'core/router/app_router.dart';
import 'core/router/routes.dart';
import 'core/storage/draft_store.dart';
import 'core/theme/app_theme.dart';
import 'features/documents/data/document_picker.dart';
import 'features/documents/data/document_repository.dart';
import 'features/documents/data/file_preparer.dart';
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
  });

  final DraftStore draftStore;
  final String initialLocation;

  // Overridable for tests. Defaults are the real device picker and preparer,
  // and the mock repository until the upload API is wired.
  final DocumentRepository? documentRepository;
  final DocumentPicker? documentPicker;
  final FilePreparer? filePreparer;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final GoRouter _router = createAppRouter(
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
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    _wizardCubit.close();
    _router.dispose();
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
      ],
      child: BlocProvider.value(
        value: _wizardCubit,
        child: MaterialApp.router(
          onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
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
