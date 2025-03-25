import 'dart:convert';

class MyEncrpyt{

  final double _primaryKey;
  final double _secondaryKey;

  MyEncrpyt(this._primaryKey, this._secondaryKey);

  String encrypt(double value) {
    double transformedValue = value * _primaryKey * 100;
    transformedValue += _secondaryKey;
    int intValue = transformedValue.toInt();
    intValue = intValue ^ 123456; // XOR operation
    transformedValue = intValue.toDouble();
    final bytes = utf8.encode(transformedValue.toString());
    final base64Value = base64.encode(bytes);

    return base64Value;
  }

  double decrypt(String encryptedValue) {
    final bytes = base64.decode(encryptedValue);
    final decodedValue = utf8.decode(bytes);
    double transformedValue = double.parse(decodedValue);
    int intValue = transformedValue.toInt();
    intValue = intValue ^ 123456; // XOR operation (reverses the previous XOR)
    transformedValue = intValue.toDouble();
    transformedValue -= _secondaryKey;
    double originalValue = transformedValue / _primaryKey;
    return originalValue / 100;
  }
}