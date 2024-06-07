import 'package:clinic/providers/profile.dart';
import 'package:clinic/widgets/photo_profile.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: PhotoProfile(url: profile?.imageUrl),
      ),
      body: const Center(
        child: Text('Profile page'),
      ),
    );
  }
}
