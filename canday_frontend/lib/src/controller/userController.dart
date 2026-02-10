import 'package:canday_frontend/src/connect/userConnect.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

final GetStorage _storage = GetStorage();

// 회원 동작에 관련된 클래스
class UserController extends GetxController {
  // UserConnect 객체 생성
  final userConnect = Get.put(UserConnect());

  // 회원가입을 시도하는 함수
  Future<bool> register(String userEmailAdress, String userPassword,
      String userNickname, String userBirth) async {
    try {
      String token = await userConnect.sendRegister(
          userEmailAdress, userPassword, userNickname, userBirth);

      await _storage.write('token', token);
      return true;
    } catch (e) {
      print('error: $e');
      return false;
    }
  }

  // 로그인을 시도하는 함수
  Future<bool> login(String userEmailAdress, String userPassword) async {
    try {
      String token = await userConnect.sendLogin(userEmailAdress, userPassword);

      await _storage.write('token', token);
      return true;
    } catch (e) {
      print('error: $e');
      return false;
    }
  }
}
