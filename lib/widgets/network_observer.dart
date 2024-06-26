import 'package:clinic/constants/sizes.dart';
import 'package:clinic/services/toast.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class NetworkObserver extends HookWidget {
  const NetworkObserver({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final conn = useMemoized(
      () => Connectivity().onConnectivityChanged,
    );

    final network = useStream(conn);
    if (network.hasData) {
      if (network.data == ConnectivityResult.none) {
        toast(context.tr('offline'));
      }
    }

    return network.data == ConnectivityResult.none
        ? const _OfflineScreen()
        : child;
  }
}

class _OfflineScreen extends StatelessWidget {
  const _OfflineScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(Sizes.p24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PhosphorIcon(
              PhosphorIconsDuotone.wifiSlash,
              color: Theme.of(context).colorScheme.primary,
              size: 32,
            ),
            gapH16,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Sizes.p24),
              child: Text(
                context.tr('offline'),
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: Theme.of(context).disabledColor),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
