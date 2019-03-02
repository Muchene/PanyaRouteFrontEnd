import 'package:flutter_native_web/flutter_native_web.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/foundation.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class MapFactory{
  WebController _webController;
  final Completer<WebViewController> _controller = Completer<WebViewController>();
 

  // FlutterNativeWeb createMap() {
  //    FlutterNativeWeb flutterWebView = new FlutterNativeWeb(
  //     onWebCreated: onWebCreated,
  //     gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
  //       Factory<OneSequenceGestureRecognizer>(
  //       () => TapGestureRecognizer(),
  //       ),
  //     ].toSet(),
  //   );
  //   return flutterWebView; 
  // }
  // void onWebCreated(webController) {
  //   this._webController = webController;
  //   this._webController.loadUrl("https://openlayers.org/en/latest/examples/mobile-full-screen.html");
  //   this._webController.onPageStarted.listen((url) =>
  //       print("Loading $url")
  //   );
    
  //   this._webController.onPageFinished.listen((url) =>
  //       print("Finished loading $url")
  //   );
  // }

  WebView createMap() {
    return WebView(
          initialUrl: "https://openlayers.org/en/latest/examples/mobile-full-screen.html",
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
          },
          javascriptChannels: <JavascriptChannel>[
            _mapJavascriptChannel(),
          ].toSet(),
    );
  }

  JavascriptChannel _mapJavascriptChannel() {
    return JavascriptChannel(
        name: 'MapChannel',
        onMessageReceived: (JavascriptMessage message) {
          print("MESSAGE $message");
        });
  }

}