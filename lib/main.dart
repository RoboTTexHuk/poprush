import 'package:flutter/material.dart';
import 'dart:async';

import 'package:popbolonsrush/mainwebview.dart';

class PopBolonsRushScreen extends StatefulWidget {
  @override
  _PopBolonsRushScreenState createState() => _PopBolonsRushScreenState();
}

class _PopBolonsRushScreenState extends State<PopBolonsRushScreen> {
  bool _isVisible = true; // Отвечает за видимость текста

  @override
  void initState() {
    super.initState();
    // Запускаем таймер для смены видимости текста каждые 2 секунды
    Timer.periodic(Duration(seconds: 2), (timer) {
      setState(() {
        _isVisible = !_isVisible; // Переключаем видимость
      });
    });

    Future.delayed(Duration(seconds: 2), () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => WebViewWithLoader()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.purple, // Фиолетовый фон
        child: Center(
          child: AnimatedOpacity(
            opacity: _isVisible ? 1.0 : 0.0, // Видимость текста
            duration: Duration(seconds: 1), // Длительность анимации
            child: Text(
              'Pop Bolons Rush', // Текст
              style: TextStyle(
                color: Colors.green, // Зеленый цвет текста
                fontSize: 24, // Размер шрифта
                fontWeight: FontWeight.bold, // Жирный шрифт
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: PopBolonsRushScreen(),
  ));
}