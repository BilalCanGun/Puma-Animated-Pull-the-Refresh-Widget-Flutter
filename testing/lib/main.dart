import 'dart:ffi';

import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:gif/gif.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool work = false;
  double Opati = 0.0;
  double Ogif = 0.0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp(
        color: Colors.white,
        home: CustomRefreshIndicator(
          onRefresh: () => Future.delayed(Duration(seconds: 2)),
          autoRebuild: false,
          onStateChanged: (IndicatorStateChange change) {
            if (change.didChange(
                from: IndicatorState.idle, to: IndicatorState.dragging)) {
              setState(() {
                Opati = 1.0;
                work = false;
              });
            } else if (change.didChange(
                from: IndicatorState.dragging, to: IndicatorState.armed)) {
              setState(() {
                work = false;
              });
            } else if (change.didChange(
                from: IndicatorState.armed, to: IndicatorState.settling)) {
              setState(() {
                work = true;
              });
            } else if (change.didChange(
                from: IndicatorState.settling, to: IndicatorState.loading)) {
              setState(() {
                work = true;

                Ogif = 1.0;
              });
            } else if (change.didChange(
                from: IndicatorState.loading, to: IndicatorState.finalizing)) {
              setState(() {
                work = true;
                Ogif = 1.0;
              });
            } else if (change.didChange(
                from: IndicatorState.finalizing, to: IndicatorState.idle)) {
              setState(() {
                work = false;
                Ogif = 0.0;
              });
            }
          },
          builder: (context, child, controller) => AnimatedBuilder(
            animation: controller,
            child: child,
            builder: (context, child) {
              bool shouldAutostart =
                  controller.value == 1 && !controller.isDragging;
              return Stack(
                children: <Widget>[
                  Opacity(
                    opacity: Opati,
                    child: Container(
                      color: Colors.white,
                      width: double.infinity,
                      height: 180 * controller.value,
                      child: SizedBox(
                        width: double.infinity,
                        height: 200 * controller.value,
                        child: Image.asset(
                          'assets/8.png',
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    ),
                  ),
                  Opacity(
                    opacity: Ogif,
                    child: Container(
                      color: Colors.white,
                      width: double.infinity,
                      height: 180 * controller.value,
                      child: SizedBox(
                        width: double.infinity,
                        height: 200 * controller.value,
                        child: Gif(
                          fps: 30,
                          autostart:
                              shouldAutostart ? Autostart.once : Autostart.no,
                          repeat: ImageRepeat.noRepeat,
                          image: const AssetImage('assets/pullk.gif'),
                        ),
                      ),
                    ),
                  ),
                  Transform.translate(
                    offset: Offset(0.0, 200 * controller.value),
                    child: controller.isLoading
                        ? HomePage(isRefreshWork: work)
                        : child,
                  )
                ],
              );
            },
          ),
          child: HomePage(
            isRefreshWork: work,
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  HomePage({required this.isRefreshWork});
  final bool isRefreshWork;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: isRefreshWork
          ? const NeverScrollableScrollPhysics()
          : const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: Colors.blue,
            height: 200,
            child: Center(
              child: Text(
                'Container 1',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
          ),
          Container(
            color: Colors.green,
            height: 200,
            child: Center(
              child: Text(
                'Container 2',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
          ),
          Container(
            color: Colors.red,
            height: 200,
            child: Center(
              child: Text(
                'Container 2',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
          ),
          Container(
            color: Colors.black,
            height: 200,
            child: Center(
              child: Text(
                'Container 3',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
          ),
          Container(
            color: Colors.white,
            height: 200,
            child: Center(
              child: Text(
                'Container 4',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
          ),
          Container(
            color: Colors.grey,
            height: 200,
            child: Center(
              child: Text(
                'Container 5',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
