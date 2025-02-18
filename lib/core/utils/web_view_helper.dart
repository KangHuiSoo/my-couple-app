import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class WebViewHelper {
  static final InAppBrowser browser = InAppBrowser();

  static Future<void> openWebView(BuildContext context, String url) async {
    await browser.openUrlRequest(
      urlRequest: URLRequest(url: WebUri(url)),
      settings: InAppBrowserClassSettings(
        browserSettings: InAppBrowserSettings(
          hideUrlBar: true,
          toolbarTopBackgroundColor: Colors.blue,
        ),
        webViewSettings: InAppWebViewSettings(
          javaScriptEnabled: true,
        ),
      ),
    );
  }
}