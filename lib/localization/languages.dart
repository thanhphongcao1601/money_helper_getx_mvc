import 'package:get/get.dart';

class Languages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          'appName': 'Money Helper',
        },
        'vi_VN': {
          'appName': 'Quản lý chi tiêu',
        },
      };
}