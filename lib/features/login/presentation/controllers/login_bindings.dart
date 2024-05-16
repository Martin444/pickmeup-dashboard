import 'package:get/get.dart';
import 'package:pickmeup_dashboard/features/login/presentation/controllers/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoginController());
  }
}
