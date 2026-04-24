import 'package:firebase_remote_config/firebase_remote_config.dart';

// [Properties]
abstract class RemoteConfigService {
  String getString(String key);
}

// [Constructor]
class RemoteConfigServiceImpl implements RemoteConfigService {
  final FirebaseRemoteConfig _rc;

  RemoteConfigServiceImpl(this._rc);

  // [Methods]
  @override
  String getString(String key) => _rc.getString(key);
}
