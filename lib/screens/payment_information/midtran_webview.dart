import 'dart:async';
import 'package:hop/app_styles/app_colors.dart';
import 'package:hop/app_styles/app_text_styles.dart';
import 'package:hop/components/custom_dialog.dart';
import 'package:hop/utils/custom_extensions.dart';
import 'package:hop/globals/constants.dart';
import 'package:app_links/app_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hop/routes/app_pages.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../managers/api_manager.dart';

class MidtranWebview extends ConsumerStatefulWidget {
  const MidtranWebview({super.key, required this.url});
  final String url;
  @override
  ConsumerState<MidtranWebview> createState() => _MidtranWebviewState();
}

class _MidtranWebviewState extends ConsumerState<MidtranWebview> {
  late WebViewController controller;

  bool canPop = true;
  bool deepLinkHandled = false;
  bool loadingPopupShown = false;
  late AppLinks _appLinks;


  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    _appLinks = AppLinks();
    initDeepLinks();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onHttpError: (HttpResponseError error) {},
          onWebResourceError: (WebResourceError error) {},
          onUrlChange: (change) async {
            final url = change.url;
            if (url == null) return;
          },
          onNavigationRequest: _handleNavReq,
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
    super.initState();
  }

  FutureOr<NavigationDecision> _handleNavReq(NavigationRequest request) async {
    final url = request.url;
    if (url.startsWith("$kDeepLinkUrl/yoomoney/success")) {
      Navigator.of(context).pop({
        "status" : "success"
      });
      if (request.url
          .contains("$kBaseURL/transaction") &&
          mounted) {
        if (loadingPopupShown) {
          Navigator.of(context).pop();
          loadingPopupShown = false;
        }
        final Map<String, dynamic> params = {};
        request.url.split("?")[1].split("&").forEach((element) {
          final List<String> keyValue = element.split("=");
          params[keyValue[0]] = keyValue[1];
        });
        if (!params.containsKey("status_code") ||
            !params.containsKey("transaction_status")) {
          return NavigationDecision.navigate;
        }
        if (params["status_code"] != "200") {
          ref.read(goRouterProvider).pop(null);
          return NavigationDecision.navigate;
        }
        if (params["status_code"] == "200" &&
            (params["transaction_status"] == "settlement" ||
                params["transaction_status"] == "capture")) {
          ref.read(goRouterProvider).pop(params);
          return NavigationDecision.prevent;
        }
      }
    }
    return NavigationDecision.navigate;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: canPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text("PAYMENT".tr(context)),
        ),
        body: WebViewWidget(
          controller: controller,
        ),
      ),
    );
  }

  Future<void> initDeepLinks() async {
    _appLinks.uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        _handleDeepLink(uri);
      }
    });
  }

  void _handleDeepLink(Uri uri) {
    if ((uri.scheme == "hop")) {
      if (deepLinkHandled) {
        return;
      }
      deepLinkHandled = true;
      canPop = false;
      loadingPopupShown = true;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return PopScope(
            canPop: false,
            child: CustomDialog(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CupertinoActivityIndicator(
                    radius: 20.r,
                    color: AppColors.white,
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    "PAYMENT_PROCESSING".tr(context),
                    style: AppTextStyles.popupHeaderTextStyle,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }
}
