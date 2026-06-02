import 'package:todo_app/app/app.dart';
import 'package:todo_app/bootstrap.dart';

Future<void> main() async {
  await bootstrap(() => const App());
}
