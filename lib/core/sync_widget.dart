import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:offline_notes/core/providers/network_provider.dart';
import 'package:offline_notes/core/providers/sync_provider.dart';
import '../../features/notes/presentation/providers/providers.dart';

class SyncBootstrap extends ConsumerStatefulWidget {
  final Widget child;

  const SyncBootstrap({
    super.key,
    required this.child,
  });

  @override
  ConsumerState<SyncBootstrap> createState() =>
      _SyncBootstrapState();
}

class _SyncBootstrapState
    extends ConsumerState<SyncBootstrap> {

  StreamSubscription<bool>? _subscription;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      _subscription = ref
          .read(networkInfoProvider)
          .onConnectivityChanged
          .listen((connected) async {

        if (!connected) return;

        await ref
            .read(syncServiceProvider)
            .sync();

        await ref
            .read(noteNotifierProvider.notifier)
            .loadNotes();
      });
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}