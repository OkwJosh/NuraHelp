import 'package:get/get.dart';
import 'package:nurahelp/app/data/services/app_service.dart';

class GeneralBinding extends Bindings{

  @override
  void dependencies(){
    Get.put(AppService(),permanent: true);
  }
}