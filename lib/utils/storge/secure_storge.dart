import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorge {
  IOSOptions getIOSOptions() => const IOSOptions(
        accountName: null,
      );

  AndroidOptions getAndroidOptions() => const AndroidOptions();
}
