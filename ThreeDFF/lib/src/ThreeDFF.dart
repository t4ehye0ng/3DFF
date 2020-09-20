import 'dart:async' show Completer;
// import 'dart:convert' show utf8;
import 'dart:io'
    show File, HttpRequest, HttpServer, HttpStatus, InternetAddress, Platform;
// import 'dart:typed_data' show Uint8List;

import 'package:flutter/material.dart';
// import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_android/android_content.dart' as android_content;
import 'package:webview_flutter/platform_interface.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ThreeDFF extends StatefulWidget {
  ThreeDFF({Key key, @required this.src}) : super(key: key);

  final String src;
  final Color backgroundColor = Colors.white;

  @override
  State<ThreeDFF> createState() => _ThreeDFFState();
}

class _ThreeDFFState extends State<ThreeDFF> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  HttpServer _proxy;

  @override
  Widget build(final BuildContext context) {
    final JavascriptChannel c = new JavascriptChannel(
        name: 'Print',
        onMessageReceived: (JavascriptMessage message) {
          print(message.message);
        });
    return WebView(
      initialUrl: "https://threejs.org/examples/#webgl_animation_cloth",
      javascriptMode: JavascriptMode.unrestricted,
      // javascriptChannels: <JavascriptChannel>[
      //   JavascriptChannel(
      //       name: 'Print',
      //       onMessageReceived: (JavascriptMessage msg) {
      //         print(msg);
      //       }),
      // ].toSet(),
      debuggingEnabled: true,
      initialMediaPlaybackPolicy: AutoMediaPlaybackPolicy.always_allow,
      onWebViewCreated: (final WebViewController webViewController) async {
        _controller.complete(webViewController);
        print('>>>> ModelViewer initializing... '); // DEBUG
        // final url = "https://threejs.org/examples/#webgl_animation_keyframes/";

        // webViewController.evaluateJavascript("""
        //   var scene = new THREE.Scene();
        //   var camera = new THREE.PerspectiveCamera( 75, window.innerWidth / window.innerHeight, 0.1, 1000 );

        //   var renderer = new THREE.WebGLRenderer();
        //   renderer.setSize( window.innerWidth, window.innerHeight );
        //   document.body.appendChild( renderer.domElement );
        // """);
      },
      navigationDelegate: (final NavigationRequest navigation) async {
        //print('>>>> ModelViewer wants to load: <${navigation.url}>'); // DEBUG
        if (!Platform.isAndroid) {
          return NavigationDecision.navigate;
        }
        if (!navigation.url.startsWith("intent://")) {
          return NavigationDecision.navigate;
        }
        try {
          // See: https://developers.google.com/ar/develop/java/scene-viewer
          final intent = android_content.Intent(
            action: "android.intent.action.VIEW", // Intent.ACTION_VIEW
            data: Uri.parse("https://arvr.google.com/scene-viewer/1.0").replace(
              queryParameters: <String, dynamic>{
                'file': widget.src,
                'mode': 'ar_only',
              },
            ),
            package: "com.google.ar.core",
            flags: 0x10000000, // Intent.FLAG_ACTIVITY_NEW_TASK,
          );
          await intent.startActivity();
        } catch (error) {
          print('>>>> ModelViewer failed to launch AR: $error'); // DEBUG
        }
        return NavigationDecision.prevent;
      },
      onPageStarted: (final String url) {
        // onPageStarted: (final String url) {
        // webViewController.evaluateJavascript("console.log('alert!')");
        // webViewController.evaluateJavascript("window.alert('alert!')");
        // webViewController.evaluateJavascript('alert("alert!")');
        // await webViewController.evaluateJavascript(
        //     "window.alert = function (e){Alert.postMessage(e);}");
        // print("done");

        print('>>>> ModelViewer finished loading: <$url>'); // DEBUG
      },
      onWebResourceError: (final WebResourceError error) {
        print(
            '>>>> ModelViewer failed to load: ${error.description} (${error.errorType} ${error.errorCode})'); // DEBUG
      },
    );
  }
}
