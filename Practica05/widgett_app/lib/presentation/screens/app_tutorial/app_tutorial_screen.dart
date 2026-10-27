import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


class SlideInfo {
  final String title;
  final String caption;
  final IconData icon;
  final String? imageAsset;

  const SlideInfo(this.title, this.caption, this.icon, {this.imageAsset});
}

const slides = <SlideInfo>[
  SlideInfo(
    'Explora los widgets',
    'Descubre componentes de Material 3 y practica con ejemplos interactivos.',
    Icons.widgets_outlined,
    imageAsset: 'assets/images/widgets-learning-hero.png',
  ),
  SlideInfo('Entrega rápida', 'Ullamco ullamco duis labore quis occaecat culpa laborum id incididunt.', Icons.delivery_dining_outlined),
  SlideInfo('Disfruta la comida', 'Ea officia exercitation voluptate nostrud amet esse ut exercitation deserunt est enim est.', Icons.sentiment_satisfied_alt_outlined),
];




class AppTutorialScreen extends StatefulWidget {

  static const name = 'tutorial_screen';

  const AppTutorialScreen({super.key});

  @override
  State<AppTutorialScreen> createState() => _AppTutorialScreenState();
}

class _AppTutorialScreenState extends State<AppTutorialScreen> {

  final PageController pageviewController = PageController();
  bool endReached = false;

  @override
  void initState() {
    super.initState();

    pageviewController.addListener(() {

      final page = pageviewController.page ?? 0;
      if ( !endReached && page >= (slides.length - 1.5) ) {
        setState(() {
          endReached = true;
        });
      }

    });

  }

  @override
  void dispose() {
    pageviewController.dispose();

    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [

          PageView(
            controller: pageviewController,
            physics: const BouncingScrollPhysics(),
            children: slides.map(
              (slideData) => _Slide(
                title: slideData.title, 
                caption: slideData.caption, 
                icon: slideData.icon,
                imageAsset: slideData.imageAsset,
              )
            ).toList(),
          ),

          Positioned(
            right: 20,
            top: 50,
            child: TextButton(
              child: const Text('Salir'),
              onPressed: () => context.pop(),
            )
          ),

          endReached ? 
            Positioned(
              bottom: 30,
              right: 30,
              child: FadeInRight(
                from: 15,
                delay: const Duration(seconds: 1),
                child: FilledButton(
                  onPressed: () => context.pop(),
                  child: const Text('Comenzar'),
                ),
              )
            ): const SizedBox(),

        ],
      ),

    );
  }
}


class _Slide extends StatelessWidget {

  final String title;
  final String caption;
  final IconData icon;
  final String? imageAsset;

  const _Slide({
    required this.title, 
    required this.caption, 
    required this.icon,
    this.imageAsset,
  });

  @override
  Widget build(BuildContext context) {

    final titleStyle = Theme.of(context).textTheme.titleLarge;
    final captionStyle = Theme.of(context).textTheme.bodySmall;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: imageAsset == null
                  ? Icon(
                      icon,
                      size: 180,
                      color: Theme.of(context).colorScheme.primary,
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Image.asset(
                        imageAsset!,
                        height: 220,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
            ),
            const SizedBox(height: 20 ),
            Text( title, style: titleStyle, ),
            const SizedBox(height: 10 ),
            Text( caption, style: captionStyle, ),

          ],
        ),
      ),
    );
  }
}
