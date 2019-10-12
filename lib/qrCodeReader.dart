import 'dart:async';
import 'package:flutter/services.dart';

class QRCodeReader {
  static const MethodChannel _channel = const MethodChannel('qrCodeReader');

  int _autoFocusIntervalInMs = 5000;
  bool _forceAutoFocus = false;
  bool _torchEnabled = false;
  bool _handlePermissions = true;
  bool _executeAfterPermissionGranted = true;
  bool _frontCamera = false;

  QRCodeReader setAutoFocusIntervalInMs(int autoFocusIntervalInMs) {
    _autoFocusIntervalInMs = autoFocusIntervalInMs;
    return this;
  }

  QRCodeReader setForceAutoFocus(bool forceAutoFocus) {
    _forceAutoFocus = forceAutoFocus;
    return this;
  }

  QRCodeReader setTorchEnabled(bool torchEnabled) {
    _torchEnabled = torchEnabled;
    return this;
  }

  QRCodeReader setHandlePermissions(bool handlePermissions) {
    _handlePermissions = handlePermissions;
    return this;
  }

  QRCodeReader setExecuteAfterPermissionGranted(bool executeAfterPermissionGranted) {
    _executeAfterPermissionGranted = executeAfterPermissionGranted;
    return this;
  }

  QRCodeReader setFrontCamera(bool setFrontCamera) {
    _frontCamera = setFrontCamera;
    return this;
  }

  Future<String> scan() async {
    Map params = <String, dynamic>{
      "autoFocusIntervalInMs": _autoFocusIntervalInMs,
      "forceAutoFocus": _forceAutoFocus,
      "torchEnabled": _torchEnabled,
      "handlePermissions": _handlePermissions,
      "executeAfterPermissionGranted": _executeAfterPermissionGranted,
      "frontCamera": _frontCamera,
    };
    return await _channel.invokeMethod('readQRCode', params);
  }
}