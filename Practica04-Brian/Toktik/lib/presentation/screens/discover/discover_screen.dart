import 'package:flutter/material.dart';
import 'package:practica04_brian/presentation/providers/discover_provider.dart';
import 'package:practica04_brian/presentation/widgets/shared/video_scrollable_view.dart';
import 'package:provider/provider.dart';

/// Pantalla principal: feed vertical de videos con scroll infinito.
class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  @override
  void initState() {
    super.initState();
    // Se pide la primera pagina despues del primer frame para no modificar
    // al provider durante el build.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<DiscoverProvider>().loadNextPage();
    });
  }

  @override
  Widget build(BuildContext context) {
    final DiscoverProvider discoverProvider = context.watch<DiscoverProvider>();

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: _buildBody(context, discoverProvider),
      ),
    );
  }

  Widget _buildBody(BuildContext context, DiscoverProvider provider) {
    if (provider.initialLoading) {
      return const Center(child: CircularProgressIndicator(strokeWidth: 2));
    }

    if (provider.videos.isEmpty) {
      return _ErrorView(
        message: provider.errorMessage ?? 'No hay videos para mostrar.',
        onRetry: () => context.read<DiscoverProvider>().reload(),
      );
    }

    return VideoScrollableView(
      videos: provider.videos,
      isLoadingMore: provider.isLoading,
      hasReachedEnd: provider.hasReachedEnd,
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }
}