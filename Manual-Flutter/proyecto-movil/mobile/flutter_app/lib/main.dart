import 'package:flutter/material.dart';
import 'controllers/tasks_controller.dart';
import 'models/task.dart';
import 'services/auth_service.dart';

void main() => runApp(const TasksApp());

class TasksApp extends StatelessWidget {
  const TasksApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Mis tareas',
    theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
    home: const TasksScreen(),
  );
}

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});
  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  late final TasksController controller;
  @override
  void initState() {
    super.initState();
    controller = TasksController(AuthService());
    controller.initialize();
  }
  @override
  void dispose() { controller.dispose(); super.dispose(); }

  Future<void> edit([Task? task]) async {
    final title = await showDialog<String>(context: context,
      builder: (context) => TaskEditor(initial: task?.title));
    if (!mounted || title == null) return;
    await controller.save(title, task: task);
  }

  Future<void> confirmDelete(Task task) async {
    final confirmed = await showDialog<bool>(context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar tarea'), content: Text('¿Eliminar "${task.title}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Eliminar')),
        ],
      ));
    if (mounted && confirmed == true) await controller.delete(task);
  }

  void showProfile() {
    final profile = controller.profile;
    showDialog<void>(context: context, builder: (context) => AlertDialog(
      title: const Text('Perfil'),
      content: Text('Usuario: ${profile?['username'] ?? ''}\nRoles: ${(profile?['roles'] as List? ?? []).join(', ')}'),
      actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cerrar'))],
    ));
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: controller,
    builder: (context, child) => Scaffold(
      appBar: AppBar(title: const Text('Mis tareas'), actions: [
        if (controller.signedIn) ...[
          IconButton(tooltip: 'Actualizar', onPressed: controller.busy ? null : controller.refresh, icon: const Icon(Icons.refresh)),
          IconButton(tooltip: 'Perfil', onPressed: showProfile, icon: const Icon(Icons.person)),
          IconButton(tooltip: 'Cerrar sesión', onPressed: controller.busy ? null : controller.logout, icon: const Icon(Icons.logout)),
        ],
      ]),
      body: Column(children: [
        if (controller.busy) const LinearProgressIndicator(),
        if (controller.error != null) _Message(controller.error!, error: true),
        if (controller.notice != null) _Message(controller.notice!),
        Expanded(child: !controller.signedIn
          ? Center(child: FilledButton.icon(
              onPressed: controller.busy ? null : controller.login,
              icon: const Icon(Icons.login), label: const Text('Iniciar sesión'),
            ))
          : controller.tasks.isEmpty
            ? const Center(child: Text('No hay tareas. Crea la primera con +.'))
            : ListView.builder(itemCount: controller.tasks.length,
                itemBuilder: (context, index) {
                  final task = controller.tasks[index];
                  return ListTile(
                    leading: Checkbox(value: task.completed,
                      onChanged: controller.busy ? null : (value) => controller.save(task.title, task: task, completed: value)),
                    title: Text(task.title, style: TextStyle(decoration: task.completed ? TextDecoration.lineThrough : null)),
                    onTap: controller.busy ? null : () => edit(task),
                    trailing: IconButton(tooltip: 'Eliminar',
                      onPressed: controller.busy ? null : () => confirmDelete(task), icon: const Icon(Icons.delete_outline)),
                  );
                },
              )),
      ]),
      floatingActionButton: controller.signedIn ? FloatingActionButton(
        onPressed: controller.busy ? null : () => edit(),
        tooltip: 'Crear tarea', child: const Icon(Icons.add),
      ) : null,
    ),
  );
}

class _Message extends StatelessWidget {
  final String text;
  final bool error;
  const _Message(this.text, {this.error = false});
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity, padding: const EdgeInsets.all(12),
    color: error ? Theme.of(context).colorScheme.errorContainer : Theme.of(context).colorScheme.secondaryContainer,
    child: Text(text),
  );
}

class TaskEditor extends StatefulWidget {
  final String? initial;
  const TaskEditor({super.key, this.initial});
  @override
  State<TaskEditor> createState() => _TaskEditorState();
}

class _TaskEditorState extends State<TaskEditor> {
  final form = GlobalKey<FormState>();
  late final TextEditingController text = TextEditingController(text: widget.initial);
  @override
  void dispose() { text.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(widget.initial == null ? 'Nueva tarea' : 'Editar tarea'),
    content: Form(key: form, child: TextFormField(
      controller: text, autofocus: true, maxLength: 200,
      decoration: const InputDecoration(labelText: 'Título'),
      validator: (value) => value == null || value.trim().isEmpty ? 'Escribe un título.' : null,
    )),
    actions: [
      TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
      FilledButton(onPressed: () {
        if (form.currentState!.validate()) Navigator.pop(context, text.text.trim());
      }, child: const Text('Guardar')),
    ],
  );
}
