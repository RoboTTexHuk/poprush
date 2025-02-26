import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter/services.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class WebViewWithLoader extends StatefulWidget {
  @override
  _WebViewWithLoaderState createState() => _WebViewWithLoaderState();
}

class _WebViewWithLoaderState extends State<WebViewWithLoader> {
  InAppWebViewController? webViewController;
  double progress = 0.0; // Процент загрузки
  List<ContentBlocker> contentBlockers = []; // Контент-блокеры

  // Список фильтров для блокировки рекламы
  final List<String> adBlockUrlFilters = [
    ".*.doubleclick.net/.*",
    ".*.ads.pubmatic.com/.*",
    ".*.googlesyndication.com/.*",
    ".*.google-analytics.com/.*",
    ".*.adservice.google.*/.*",
    ".*.adbrite.com/.*",
    ".*.exponential.com/.*",
    ".*.quantserve.com/.*",
    ".*.scorecardresearch.com/.*",
    ".*.zedo.com/.*",
    ".*.adsafeprotected.com/.*",
    ".*.teads.tv/.*",
    ".*.outbrain.com/.*",
  ];

  @override
  void initState() {
    super.initState();

    // Инициализация контент-блокеров
    for (final adFilter in adBlockUrlFilters) {
      contentBlockers.add(ContentBlocker(
        trigger: ContentBlockerTrigger(
          urlFilter: adFilter,
        ),
        action: ContentBlockerAction(
          type: ContentBlockerActionType.BLOCK,
        ),
      ));
    }

    contentBlockers.add(ContentBlocker(
      trigger: ContentBlockerTrigger(urlFilter: ".cookie", resourceType: [
        ContentBlockerTriggerResourceType.RAW,
      ]),
      action: ContentBlockerAction(
        type: ContentBlockerActionType.BLOCK,
        selector: ".notification",
      ),
    ));

    contentBlockers.add(ContentBlocker(
      trigger: ContentBlockerTrigger(urlFilter: ".cookie", resourceType: [
        ContentBlockerTriggerResourceType.RAW,
      ]),
      action: ContentBlockerAction(
        type: ContentBlockerActionType.CSS_DISPLAY_NONE,
        selector: ".privacy-info",
      ),
    ));

    contentBlockers.add(ContentBlocker(
      trigger: ContentBlockerTrigger(
        urlFilter: ".*",
      ),
      action: ContentBlockerAction(
        type: ContentBlockerActionType.CSS_DISPLAY_NONE,
        selector: ".banner, .banners, .ads, .ad, .advert",
      ),
    ));

    // Устанавливаем прозрачный цвет статус-бара
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Column(
        children: [
          // Индикатор загрузки
          if (progress < 1.0)
            LinearPercentIndicator(
              lineHeight: 5.0,
              percent: progress, // Процент загрузки
              backgroundColor: Colors.grey[300]!,
              progressColor: Colors.green,
              animation: true,
            ),
          // WebView
          Expanded(
            child: InAppWebView(
              initialUrlRequest: URLRequest(
                url: WebUri("https://colorapp.colorspheres.click/Zjk34k"), // Замените на нужный URL
              ),
              initialSettings: InAppWebViewSettings(
                contentBlockers: contentBlockers, // Применяем контент-блокеры
              ),
              onWebViewCreated: (controller) {
                webViewController = controller;
              },
              onProgressChanged: (controller, progressValue) {
                setState(() {
                  // Прогресс от 0.0 до 1.0
                  progress = progressValue / 100;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}