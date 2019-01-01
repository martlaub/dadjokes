import 'dart:async';
import 'dart:math';
import 'dart:ui' show lerpDouble;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_attract/tweets.dart';

void main() => runApp(FlutterAttractApp());

class FlutterAttractApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);

    return MaterialApp(
      title: 'Flutter Demo',
      home: HomePage(title: 'Flutter Attract Sequence'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final controller = PageController();

  static const pageTransitionDuration = Duration(milliseconds: 300);

  final commentWidgets = comments
      .map((comment) => CommentWidget(comment))
      .toList(growable: false)
      ..shuffle();

  @override
  initState() {
    super.initState();

    Timer(commentWidgets.first.timeToRead, () => changePage(1));
  }

  void changePage(int page) async {
    await controller.animateToPage(
      page,
      duration: pageTransitionDuration,
      curve: Curves.ease,
    );

    final nextWidget = commentWidgets[page % commentWidgets.length];

    Timer(nextWidget.timeToRead, () => changePage(++page));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        physics: AlwaysScrollableScrollPhysics(),
        controller: controller,
        itemBuilder: (BuildContext context, int index) {
          return commentWidgets[index % commentWidgets.length];
        },
      ),
    );
  }
}

class CommentWidget extends StatelessWidget {
  final Comment comment;

  final Duration timeToRead;

  /// Reading duration per character averages to 60ms across languages
  /// ([1000 characters per minute](https://en.wikipedia.org/wiki/Words_per_minute)).
  /// We're using 65ms here to make this more accessible.
  static const averageTimeToReadCharacter = Duration(milliseconds: 65);

  CommentWidget(
    Comment comment, {
    Key key,
  })  : assert(comment != null),
        comment = comment,
        timeToRead = averageTimeToReadCharacter * comment.comment.length,
        super(key: key);

  static const quoteTheme = const TextStyle(
    fontFamily: "Average Sans",
    fontStyle: FontStyle.normal,
    fontSize: 36.0,
    color: Colors.white,
  );

  static const attributionTheme = const TextStyle(
    fontFamily: "Average Sans",
    fontStyle: FontStyle.normal,
    fontSize: 24.0,
    color: Colors.white,
  );

  static const colors = [Colors.blue, Colors.green, Colors.red, Colors.amber];

  static Color randomColor() {
    final random = Random();

    return colors[random.nextInt(colors.length)];
  }

  @override
  Widget build(BuildContext context) {
    final fontFactor = lerpDouble(1.0, 0.5, comment.comment.length / 500);

    final quote = Text(
      comment.comment,
      style: quoteTheme.apply(fontSizeFactor: fontFactor),
      textAlign: TextAlign.center,
    );

    final attribution = Padding(
      padding: const EdgeInsets.only(top: 30.0, right: 30.0),
      child: Text(
        "— ${comment.source}",
        style: attributionTheme,
        textAlign: TextAlign.end,
      ),
    );

    return Container(
      color: randomColor(),
      child: Padding(
        padding: const EdgeInsets.all(36.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              quote,
              attribution,
            ],
          ),
        ),
      ),
    );
  }
}
