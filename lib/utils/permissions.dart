
import 'package:flutter/services.dart';
import 'dart:async';

enum PermissionState{
  GRANTED,
  DENIED,
  SHOW_RATIONALE,
}

enum PermissionType {
  LOCATION,
}

class PermissionRequest{

  static const _methodChannel = const MethodChannel('runtimepermission/location');
  static const _permMethods = <String>['getContactPermission'];
  @override
  Future<PermissionState> getPermission(PermissionType type) async {
    print("Calling get permission");
    try {
      String method =_permMethods[type.index];
      print("INVOKING $method");
      final int result = await _methodChannel.invokeMethod(_permMethods[type.index]);
      return new Future.value(PermissionState.values.elementAt(result));
    } on PlatformException catch (e) {
      print('Exception ' + e.toString());
    }
    return new Future.value(PermissionState.DENIED);
  }
}
