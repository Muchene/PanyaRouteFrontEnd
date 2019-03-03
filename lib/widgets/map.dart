import 'package:flutter_native_web/flutter_native_web.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/foundation.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class MapFactory{
  WebController _webController;
  final Completer<WebViewController> _controller = Completer<WebViewController>();
 
  WebView createMap() {
    return WebView(
          initialUrl: "https://panyaroute.net",
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