/// Shared, framework-independent application logic.
library;

export 'src/dependency_injection/get_it.dart';
export 'src/presentation/mvvm_extensions.dart';

/// Basic metadata available to every Mindoo client.
class MindooAppInfo {
  const MindooAppInfo._();

  static const name = 'Mindoo';
}
