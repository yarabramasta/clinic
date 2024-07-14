import 'package:clinic/ui/container/network_observer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rearch/flutter_rearch.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:toastification/toastification.dart';

import 'pages/pages.dart';
import 'services/kv.dart';
import 'services/theme.dart';
import 'ui/notification/notification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await EasyLocalization.ensureInitialized();
  await KV.ensureInitialized();

  runApp(
    EasyLocalization(
      path: 'i18n',
      supportedLocales: const [
        Locale('id'),
        Locale('en'),
      ],
      fallbackLocale: const Locale('id'),
      useOnlyLangCode: true,
      child: const RearchBootstrapper(
        child: ClinicAI(),
      ),
    ),
  );
}

class ClinicAI extends RearchConsumer {
  const ClinicAI({super.key});

  @override
  Widget build(BuildContext context, WidgetHandle use) {
    final light = MaterialTheme(Theme.of(context).textTheme).light();
    final dark = MaterialTheme(Theme.of(context).textTheme).dark();

    return SkeletonizerConfig(
      data: SkeletonizerConfigData(
        effect: ShimmerEffect(
          baseColor: light.colorScheme.outlineVariant,
        ),
      ),
      child: ToastificationWrapper(
        child: ValueListenableBuilder(
            valueListenable: KV.isDarkMode.listenable(keys: ['dark_mode']),
            builder: (context, box, _) {
              final isDarkMode = box.get('dark_mode') ?? false;

              return MaterialApp.router(
                routerConfig: use(router),
                title: 'Clinic AI',
                debugShowCheckedModeBanner: false,
                theme: light,
                darkTheme: dark,
                themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
                localizationsDelegates: context.localizationDelegates,
                supportedLocales: context.supportedLocales,
                locale: context.locale,
                scaffoldMessengerKey: notif,
                builder: (context, child) {
                  return ToastificationConfigProvider(
                    config: const ToastificationConfig(
                      alignment: Alignment.bottomCenter,
                      animationDuration: Duration(milliseconds: 500),
                    ),
                    child: NetworkObserver(child: child!),
                  );
                },
              );
            }),
      ),
    );
  }
}
