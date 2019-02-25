import 'package:flutter_native_web/flutter_native_web.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/foundation.dart';


class MapFactory{
  WebController _webController;
 

  FlutterNativeWeb createMap() {
     FlutterNativeWeb flutterWebView = new FlutterNativeWeb(
      onWebCreated: onWebCreated,
      gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
        Factory<OneSequenceGestureRecognizer>(
        () => TapGestureRecognizer(),
        ),
      ].toSet(),
    );
    return flutterWebView; 
  }
  void onWebCreated(webController) {
    this._webController = webController;
    this._webController.loadUrl("https://openlayers.org/en/latest/examples/mobile-full-screen.html");
    this._webController.onPageStarted.listen((url) =>
        print("Loading $url")
    );
    
    this._webController.onPageFinished.listen((url) =>
        print("Finished loading $url")
    );
  }

}