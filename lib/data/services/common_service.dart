import 'package:get_it/get_it.dart';
import 'package:superfrog/data/services/auth_service.dart';
import 'package:superfrog/data/services/storage_service.dart';

class CommonService {
  CommonService._();

  static void register() {
    GetIt.I.registerSingleton<AuthService>(AuthService());
    GetIt.I.registerSingleton<StorageService>(StorageService());
  }
}
