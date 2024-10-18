/*
 * Based on https://www.geeksforgeeks.org/flutter-build-a-random-quote-generator-app/
 * See https://pub.dev/packages/flutter_fortune_wheel/example
 * See https://pub.dev/packages/flutter_native_splash
 *    $ dart run flutter_native_splash:create
 * 
 * 
 * Run this is terminal to update splash screen images:
 *  dart run flutter_native_splash:create
 */

// import 'dart:convert';
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

final items = <String>[
  'Excuse',
  'Reason',
  'Excuse',
  'Reason',
  'Excuse',
  'Reason',
  'Excuse',
  // 'Reason',
  // 'Excuse',
  'Who Me?',
];

// Recent excuses
var recent = [-1, -1, -1, -1, -1, -1];

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const RandomExcuseApp());
}

class RandomExcuseApp extends StatelessWidget {
  const RandomExcuseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Random Quote Generator',
      home: RandomQuoteScreen(),
    );
  }
}

class RandomQuoteScreen extends StatefulWidget {
  const RandomQuoteScreen({super.key});

  @override
  State<RandomQuoteScreen> createState() => _RandomQuoteScreenState();
}

class _RandomQuoteScreenState extends State<RandomQuoteScreen> {
  // String _excuse = 'Why were you so slow?';
  StreamController<int> selected = StreamController<int>();

  @override
  void initState() {
    super.initState();
    hideScreen();
  }

  ///hide your splash screen
  Future<void> hideScreen() async {
    Future.delayed(const Duration(milliseconds: 3000), () {
      FlutterNativeSplash.remove();
    });
  }

  Future<void> _startSpinning() async {
    setState(() {
      selected.add(
        Fortune.randomInt(0, items.length),
      );
    });
  }

  // Function to get a random quote from the quotable API
  String _getRandomQuote() {
    var excuses = [
      'I think my tire pressures might be wrong',
      'I didn\'t get enough sleep last night',
      'I think my chain might have stretched',
      'My tires have had too many heat cycles',
      'I thought there might be oil on the track',
      'I ate something bad last night and it upset my stomach',
      'I have been working hard all week',
      'I am worried about my sliders wearing out',
      'I was worried I might scare you if I got too close',
      'I was hanging back watching your lines',
      'I think I got bad gasoline from the gas station',
      'I need new spark plugs',
      'The pollution control sometimes kicks in',
      'My bike overheats sometimes when I push it too hard',
      'My fuel light came on',
      'I almost had a high side on turn three',
      'I don\'t want to push the bike hard until I change the oil',
      'I\'m saving my tires for next week',
      'I was waiting for the guy behind me to catch up',
      'That was just a warm up session',
      'I didn\'t want to scare the beginners',
      'My rearsets need adjusting',
      'I was distracted by the plane flying past',
      'Didn\'t you see that bird?',
      'I need to calibrate my lap timer',
      'My gloves are too tight',
      'I have a stone in my boot',
      'The GPS signal cuts out here sometimes',
      'My traction control keeps cutting the power',
      'The wheelie control keeps cutting the power',
      'I don\'t want to leave too much rubber on the track',
      'I\'m breaking in the new throttle grip',
      'I was on the rain power setting',
      'A giant bug splattered on my helmet visor',
      'I\'m using the wrong sprockets for this track',
      'They installed the brake pads backwards so I need to be careful',
      'I\'m hitting the corners too hard',
      'The altitude affects the power output of my bike',
      'I got a cramp in my arm from being on the gas all the time',
      'That Rossi guy was in my way',
      'I don\'t want to be put in the A Group',
      'I am showing the slow riders the lines',
      'My brakes need bleeding',
      'My visor is dirty',
      'Forgot my ear plugs',
      'Too many squids in my way',
      'I forgot to charge my air bag',
      'The tune is for a different track',
      'Too many beers last night',
      'My tire warmers are too cold',
      'Flux capacitor is not oscillating',
      'Air cleaner is dirty',
      'Brake markers are wrong - I usually brake at the 50',
      'New boots are too stiff',
      'My gloves are too tight',
      'My front discs are warped',
      'My rebound is out',
      'My brakes are overheating because I brake so late',
      'New tires are faulty',
      'I usually run slicks',
      'I got bugs in my mouth first corner',
      'My injectors need to be cleaned',
      'Only doing set up not pushing',
      'Trying to wear out the center of my tires',
      'I\'m only using the practice mapping',
      'Running in new spark plug',
      'Last time I was faster',
      'Taking it easy today because my sprockets wear out too quickly',
      'The lambda sensor is faulty',
      'My secondary air system is affected by too much ram air pressure',
      'My ABS is detecting anomolies in the track surface',
      'I\'m getting excessive lean angle errors in my CPU',
      'The bike cuts power past 70 degrees lean angle',
      'I don\'t want my rapid cornering to trigger the tip over sensor',
      'My tire valves have not been calibrated',
      'We need to reduce noise pollution',
      'I\'m reducing my fuel consumption to keep Greta happy',
    ];
    // var numExcuses = 10;
    var numExcuses = excuses.length;

    var excuseNumber = 0;
    for (;;) {
      excuseNumber = Random().nextInt(numExcuses);

      // See if this excuse has been used recently
      var excuseUsed = false;
      for (var i = 0; i < recent.length; i++) {
        if (recent[i] == excuseNumber) {
          excuseUsed = true;
          break;
        }
      }
      if (!excuseUsed) {
        break;
      }
      continue;
    }

    // Add this excuse number to the recent list
    for (var i = recent.length - 1; i > 0; i--) {
      recent[i] = recent[i - 1];
    }
    recent[0] = excuseNumber;

    // Return the excuse number
    return excuses[excuseNumber];
  }

  @override
  void dispose() {
    selected.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trackday Excuses'),
      ),
      body: GestureDetector(
        onTap: () {
          _startSpinning();
          // setState(() {
          //   selected.add(
          //     Fortune.randomInt(0, items.length),
          //   );
          // });
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 50),
              // const SizedBox(height: 50),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Love motorcycle track days, but your friends say you are slow?\n\nLet us help...',
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: FortuneWheel(
                      selected: selected.stream,
                      animateFirst: false,
                      duration: const Duration(seconds: 5),
                      items: [
                        for (var it in items) FortuneItem(child: Text(it)),
                      ],
                      onAnimationEnd: () {
                        // _centerController.play();
                        showDialog(
                            barrierDismissible: true,
                            context: context,
                            builder: (BuildContext context) {
                              return Center(
                                child: AlertDialog(
                                  scrollable: true,
                                  title: const Text(
                                    'Try this excuse...',
                                    style: TextStyle(
                                      fontSize: 14,
                                      // fontFamily: Fon
                                    ),
                                  ),
                                  content: Column(
                                    children: [
                                      const SizedBox(height: 10),
                                      Text(
                                        _getRandomQuote(),
                                        // selectedIdea,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          // fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      // Image.network(selectedImg),
                                    ],
                                  ),
                                ),
                              );
                            });
                      }),
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                // onPressed: _getRandomQuote,
                onPressed: _startSpinning,

                child: const Text('Get excuse',
                    style: TextStyle(
                      fontSize: 18,
                    )),
              ),
              const SizedBox(height: 80),
              // const SizedBox(height: 50),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Excuses provided by Team OFX and Zero2Podium rider training school, Clark International Speedway.',
                  style: TextStyle(fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
