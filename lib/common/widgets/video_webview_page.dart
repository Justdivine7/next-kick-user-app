import 'package:flutter/material.dart';
import 'package:next_kick/common/colors/app_colors.dart';
import 'package:next_kick/common/widgets/app_toast/app_toast.dart';
import 'package:next_kick/features/team/tournament/view/payment_cancelled_view.dart';
import 'package:next_kick/features/team/tournament/view/payment_success_view.dart';
import 'package:next_kick/utilities/constants/enums/toast_enum.dart';
import 'package:next_kick/utilities/extensions/app_extensions.dart';
import 'package:webview_flutter/webview_flutter.dart';

class VideoWebViewPage extends StatefulWidget {
  final String url;
  final String title;
  const VideoWebViewPage({super.key, required this.url, required this.title});

  @override
  State<VideoWebViewPage> createState() => _VideoWebViewPageState();
}

class _VideoWebViewPageState extends State<VideoWebViewPage> {
  late final WebViewController _controller;
  double _progress = 0;

  @override
  void initState() {
    super.initState();

    _controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onProgress: (int progress) {
                setState(() {
                  _progress = progress / 100;
                });
              },
              onPageStarted: (String url) {
                setState(() {
                  _progress = 0;
                });
              },
              onPageFinished: (String url) {
                setState(() {
                  _progress = 1.0;
                });
              },
              onNavigationRequest: (request) {
                debugPrint("WebView wants to load: ${request.url}");

                if (request.url.contains("/payment/confirm")) {
                  debugPrint("Payment success intercepted!");

                  Navigator.pop(context);

                  // Navigate to tournaments list
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    AppToast.show(
                      context,
                      message: 'Payment successful',
                      style: ToastStyle.success,
                    );

                    Navigator.pushNamed(context, PaymentSuccessView.routeName);
                  });

                  //Completely block loading the success webpage
                  return NavigationDecision.prevent;
                }
                if (request.url.contains("/payment/cancel")) {
                  debugPrint("Payment cancelled intercepted!");

                  // Close WebView immediately
                  Navigator.pushNamed(context, PaymentCancelledView.routeName);

                  // Show cancelled toast
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    AppToast.show(
                      context,
                      message: 'Payment cancelled',
                      style: ToastStyle.error,
                    );
                  });

                  //Completely block loading the cancelled webpage
                  return NavigationDecision.prevent;
                }

                return NavigationDecision.navigate;
              },
            ),
          )
          ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    final showProgress = _progress < 1.0;

    return WillPopScope(
      onWillPop: () async {
        // Allow manual back button to work normally
        return true;
      },
      child: Scaffold(
        backgroundColor: AppColors.boldTextColor,
        appBar: AppBar(
          iconTheme: IconThemeData(color: AppColors.appBGColor),
          forceMaterialTransparency: true,
          leading: IconButton(
            icon: Icon(Icons.keyboard_arrow_left, color: AppColors.appBGColor),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text(
            widget.title,
            style: context.textTheme.bodyLarge?.copyWith(
              color: AppColors.appBGColor,
            ),
          ),
        ),
        body: Stack(
          children: [
            Positioned.fill(child: WebViewWidget(controller: _controller)),
            if (showProgress)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: LinearProgressIndicator(
                  value: _progress,
                  minHeight: 3,
                  color: AppColors.lightBackgroundGradient,
                  backgroundColor: Colors.black12,
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    debugPrint("🗑️ VideoWebViewPage disposed");
    super.dispose();
  }
}
