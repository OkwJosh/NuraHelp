import 'package:get/get.dart';
import 'package:nurahelp/app/data/services/network_manager.dart';

class GeneralBindings extends Bindings{

  @override
  void dependencies() {
    Get.put(AppNetworkManager(),permanent: true);
  }

}