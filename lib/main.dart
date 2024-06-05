import 'package:clinic/generated/codegen_loader.g.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fl_query/fl_query.dart';
import 'package:fl_query_connectivity_plus_adapter/fl_query_connectivity_plus_adapter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'constants/theme.dart';
import 'router.dart';
import 'services/kv.dart';
import 'services/toast.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await KV.initialize();

  await QueryClient.initialize(
    cachePrefix: 'clinic_app',
    connectivity: FlQueryConnectivityPlusAdapter(
      pollingDuration: const Duration(seconds: 10),
    ),
  );

  runApp(
    ProviderScope(
      child: EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('id')],
        path: 'assets/translations',
        fallbackLocale: const Locale('en'),
        assetLoader: const CodegenLoader(),
        child: QueryClientProvider(
          child: const Clinic(),
        ),
      ),
    ),
  );
}

class Clinic extends ConsumerWidget {
  const Clinic({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ValueListenableBuilder(
      valueListenable: KV.isDarkMode.listenable(),
      builder: (context, box, _) {
        var darkMode = box.get('dark_mode', defaultValue: false)!;
        var router = ref.watch(routerProvider);

        return MaterialApp.router(
          title: 'Clinic',
          debugShowCheckedModeBanner: false,
          routerConfig: router,
          theme: MaterialTheme(Theme.of(context).textTheme).light(),
          darkTheme: MaterialTheme(Theme.of(context).textTheme).dark(),
          themeMode: darkMode ? ThemeMode.dark : ThemeMode.light,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          builder: (context, child) {
            final conn = useMemoized(
              () => Connectivity().onConnectivityChanged,
            );
            final network = useStream(conn);
            if (network.hasData) {
              if (network.requireData == ConnectivityResult.none) {
                toast(context.tr('offline'));
              }
            }
            return child!;
          },
        );
      },
    );
  }
}
