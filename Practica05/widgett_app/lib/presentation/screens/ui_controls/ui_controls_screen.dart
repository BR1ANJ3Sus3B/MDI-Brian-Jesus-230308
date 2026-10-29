import 'package:flutter/material.dart';

class UiControlsScreen extends StatelessWidget {
  static const name = 'ui_controls_screen';

  const UiControlsScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('UI Controls')),
        body: const _UiControlsView(),
      );
}

class _UiControlsView extends StatefulWidget {
  const _UiControlsView();

  @override
  State<_UiControlsView> createState() => _UiControlsViewState();
}

enum Transportation { car, plane, boat, submarine }

class _UiControlsViewState extends State<_UiControlsView> {
  bool isDeveloper = true;
  Transportation selectedTransportation = Transportation.car;
  bool wantsBreakfast = false;
  bool wantsLunch = false;
  bool wantsDinner = false;

  @override
  Widget build(BuildContext context) => ListView(
        physics: const ClampingScrollPhysics(),
        children: [
          SwitchListTile(
            title: const Text('Developer Mode'),
            subtitle: const Text('Controles adicionales'),
            value: isDeveloper,
            onChanged: (value) => setState(() => isDeveloper = value),
          ),
          RadioGroup<Transportation>(
            groupValue: selectedTransportation,
            onChanged: (value) {
              if (value != null) {
                setState(() => selectedTransportation = value);
              }
            },
            child: ExpansionTile(
              title: const Text('Veh\\u00edculo de transporte'),
              subtitle: Text(selectedTransportation.name),
              children: const [
                RadioListTile<Transportation>(
                  title: Text('By Car'),
                  subtitle: Text('Viajar por carro'),
                  value: Transportation.car,
                ),
                RadioListTile<Transportation>(
                  title: Text('By Boat'),
                  subtitle: Text('Viajar por barco'),
                  value: Transportation.boat,
                ),
                RadioListTile<Transportation>(
                  title: Text('By Plane'),
                  subtitle: Text('Viajar por avi\\u00f3n'),
                  value: Transportation.plane,
                ),
                RadioListTile<Transportation>(
                  title: Text('By Submarine'),
                  subtitle: Text('Viajar por submarino'),
                  value: Transportation.submarine,
                ),
              ],
            ),
          ),
          CheckboxListTile(
            title: const Text('\\u00bfDesayuno?'),
            value: wantsBreakfast,
            onChanged: (value) => setState(() => wantsBreakfast = value ?? false),
          ),
          CheckboxListTile(
            title: const Text('Almuerzo?'),
            value: wantsLunch,
            onChanged: (value) => setState(() => wantsLunch = value ?? false),
          ),
          CheckboxListTile(
            title: const Text('Cena?'),
            value: wantsDinner,
            onChanged: (value) => setState(() => wantsDinner = value ?? false),
          ),
        ],
      );
}
