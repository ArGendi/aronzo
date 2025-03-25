import 'package:encrypt/encrypt.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yofa/models/my_encrpyt.dart';

class Cache{
  static late SharedPreferences sharedPreferences;

  static Future<void> init() async{
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future<void> setUserId(int value) async{
    await sharedPreferences.setInt("userId", value);
  }

  static int? getUserId(){
    return sharedPreferences.getInt("userId");
  }

  static Future<void> setClicks(int value) async{
    await sharedPreferences.setInt("clicks", value);
  }

  static int? getClicks(){
    return sharedPreferences.getInt("clicks");
  }

  static Future<void> setMoney(double value) async{
    await sharedPreferences.setDouble("money", value);
  }

  static double? getMoney(){
    return sharedPreferences.getDouble("money");
  }

  // Save encrypted double to SharedPreferences
  static Future<void> setEncryptedMoney(double value) async {
    final encryptedValue = MyEncrpyt(5.0, 987.65).encrypt(value);
    await sharedPreferences.setString('money', encryptedValue);
    print('Encrypted value saved: $encryptedValue');
  }

  // Retrieve and decrypt double from SharedPreferences
  static double? getDecryptedMoney() {
    final encryptedValue = sharedPreferences.getString('money');
    if (encryptedValue != null) {
      final decryptedValue = MyEncrpyt(5.0, 987.65).decrypt(encryptedValue);
      print('Decrypted value retrieved: $decryptedValue');
      return decryptedValue;
    }
    return null;
  }

  static Future<void> setName(String value) async{
    await sharedPreferences.setString("name", value);
  }

  static String? getName(){
    return sharedPreferences.getString("name");
  }

  static Future<void> setPhone(String value) async{
    await sharedPreferences.setString("phone", value);
  }

  static String? getPhone(){
    return sharedPreferences.getString("phone");
  }

  static void clear(){
    sharedPreferences.clear();
  }

}