import 'package:flutter/foundation.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import '../models/task.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';

class TasksController extends ChangeNotifier {
  final AuthService auth;
  late final ApiService api = ApiService(auth);
  bool busy = false;
  bool _disposed = false;
  String? error;
  String? notice;
  List<Task> tasks = [];
  Map<String, dynamic>? profile;
  TasksController(this.auth);
  bool get signedIn => auth.hasSession;

  Future<void> _perform(Future<void> Function() action) async {
    if (busy) return;
    busy = true; error = null; notice = null;
    notifyListeners();
    try { await action(); }
    on FlutterAppAuthUserCancelledException { notice = 'Inicio de sesión cancelado.'; }
    on ApiException catch (exception) {
      error = exception.message;
      if (exception.status == 401) await auth.clear();
    } on SessionException catch (exception) { error = exception.message; }
    catch (_) { error = 'No se completó la operación. Comprueba Keycloak y la conexión.'; }
    finally {
      if (!signedIn) { tasks = []; profile = null; }
      busy = false;
      if (!_disposed) notifyListeners();
    }
  }

  Future<void> initialize() => _perform(() async {
    await auth.restore();
    if (signedIn) await _load();
  });
  Future<void> login() => _perform(() async { await auth.login(); await _load(); });

  Future<void> _load() async {
    profile = Map<String, dynamic>.from(await api.request('GET', '/me') as Map);
    final values = await api.request('GET', '/tasks') as List;
    tasks = values.map((value) => Task.fromJson(Map<String, dynamic>.from(value as Map))).toList();
  }
  Future<void> refresh() => _perform(_load);

  Future<void> save(String title, {Task? task, bool? completed}) => _perform(() async {
    final body = task?.toInput(title: title, completed: completed) ??
        {'title': title, 'completed': false, 'category_id': null};
    final result = await api.request(task == null ? 'POST' : 'PUT',
        task == null ? '/tasks' : '/tasks/${task.id}', body: body) as Map;
    if (result['audit_recorded'] == false) notice = 'Tarea guardada; el registro de actividad no se completó.';
    await _load();
  });

  Future<void> delete(Task task) => _perform(() async {
    final result = await api.request('DELETE', '/tasks/${task.id}') as Map;
    if (result['audit_recorded'] == false) notice = 'Tarea eliminada; el registro de actividad no se completó.';
    await _load();
  });

  Future<void> logout() => _perform(() async {
    try { await auth.logout(); }
    catch (_) { notice = 'Sesión local cerrada. No se pudo cerrar la sesión del navegador.'; }
    tasks = []; profile = null;
  });

  @override
  void dispose() { _disposed = true; api.close(); super.dispose(); }
}
