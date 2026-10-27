import 'package:flutter/material.dart';

class CardsScreen extends StatelessWidget {
  static const String name = 'cards_screen';
  const CardsScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Cards Screen')),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text('Cards con imágenes', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            const _ImageCard(title: 'Espacio de trabajo', subtitle: 'Laptop y Material 3'),
            const SizedBox(height: 12),
            const _ImageCard(title: 'Diseño moderno', subtitle: 'Componentes reutilizables'),
            const SizedBox(height: 28),
            Text('Elevaciones', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            ...List.generate(6, (index) => Card(
              elevation: index.toDouble(),
              margin: const EdgeInsets.only(bottom: 14),
              child: ListTile(leading: CircleAvatar(child: Text('$index')), title: Text('Elevation $index'), subtitle: const Text('Card de ejemplo')),
            )),
          ],
        ),
      );
}

class _ImageCard extends StatelessWidget {
  final String title;
  final String subtitle;
  const _ImageCard({required this.title, required this.subtitle});
  @override
  Widget build(BuildContext context) => Card(
        clipBehavior: Clip.antiAlias,
        child: Column(children: [
          Image.asset('assets/images/laptop-card.png', height: 180, width: double.infinity, fit: BoxFit.cover),
          ListTile(leading: const Icon(Icons.laptop_mac_outlined), title: Text(title), subtitle: Text(subtitle)),
        ]),
      );
}
