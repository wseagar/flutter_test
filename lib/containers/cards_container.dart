import 'dart:collection';

import 'package:dating/models/app_state.dart';
import 'package:dating/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:dating/services/profile_service.dart';
import 'package:flutter/animation.dart';
import 'package:dating/actions/card_actions.dart';

import 'dart:math';

import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/src/store.dart';

import '../models/profile.dart';

class CardsContainer extends StatefulWidget {
  @override
  _CardsContainerState createState() => new _CardsContainerState();
}

class _CardsContainerState extends State<CardsContainer> with TickerProviderStateMixin {
  List<int> cardsNums = new List();
  int cardsCounter = 0;

  final Alignment backCardAlign = new Alignment(0.0, 0.0);
  final Alignment middleCardAlign = new Alignment(0.0, 0.0);
  final Alignment defaultFrontCardAlign = new Alignment(0.0, 0.0);
  Alignment frontCardAlign = new Alignment(0.0, 0.0);
  Alignment heartsAlign = new Alignment(0.0, 0.0);

  double frontCardRot = 0.0;

  double onPanEndAliignX = 0.0;
  double onPanEndAliignY = 0.0;

  double secondCardWidth = secondCardWidthStart;
  double secondCardHeight = secondCardHeightStart;

  double heartOpacity = 0.0;
  double crossOpacity = 0.0;

  bool swiping = false;

  static final double secondCardWidthStart = 0.85;
  static final double secondCardHeightStart = 0.78;

  static final double secondCardWidthEnd = 0.90;
  static final double secondCardHeightEnd = 0.80;

  Animation<double> resetAnimation;
  Animation<double> swipeAnimation;
  AnimationController resetController;
  AnimationController swipeController;

  bool swipeRight = false;
  static final finalPos = 30.0;

  final Queue<Profile> _profiles = new Queue<Profile>();

  @override
  void initState() {
    super.initState();
    resetController = new AnimationController(duration: new Duration(milliseconds: 300), vsync: this);

    resetAnimation = new Tween(begin: 0.0, end: 1.0).animate(resetController);

    resetAnimation.addListener(() {
      setState(() {
        var val = resetAnimation.value;

        var newX = (1 - val) * onPanEndAliignX;
        var newY = (1 - val) * onPanEndAliignY;

        frontCardAlign = new Alignment(newX, newY);
        frontCardRot = frontCardAlign.x;

        if (frontCardAlign.x > 0) {
          heartOpacity = 1 - ((6.0 - frontCardAlign.x) / 6.0);
        } else {
          crossOpacity = 1 - ((6.0 - frontCardAlign.x.abs()) / 6.0);
        }

        if (frontCardAlign.x == 0) {
          heartOpacity = 0.0;
          crossOpacity = 0.0;
        }
      });
    });

    swipeController = new AnimationController(duration: new Duration(milliseconds: 300), vsync: this);

    swipeAnimation = new Tween(begin: 0.0, end: 1.0).animate(swipeController);

    swipeAnimation.addListener(() {
      setState(() {
        swiping = true;
        var l_finalPos = 0.0;
        if (!swipeRight)
          l_finalPos = finalPos * -1;
        else
          l_finalPos = finalPos;

        var val = swipeAnimation.value;

        var newX = ((l_finalPos - onPanEndAliignX) * val) + onPanEndAliignX;
        var newY = (1 - val) * onPanEndAliignY;

        frontCardAlign = new Alignment(newX, newY);
        frontCardRot = frontCardAlign.x;
      });
    });

    swipeController.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        swiping = false;
        changeCardsOrder();
        frontCardAlign = new Alignment(0.0, 0.0);
        frontCardRot = 0.0;
      }
    });

    _getMoreProfiles();
  }

  void _getMoreProfiles() {
    getProfiles().then((profiles) => setState(() => profiles.forEach((p) => _profiles.addLast(p))));
  }

  dispose() {
    resetController.dispose();
    swipeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (frontCardAlign.x > 0) {
      heartOpacity = min(1 - ((6.0 - frontCardAlign.x) / 6.0), 1.0);
    } else {
      crossOpacity = min(1 - ((6.0 - frontCardAlign.x.abs()) / 6.0), 1.0);
    }

    if (frontCardAlign.x < 6.0 && frontCardAlign.x > -6.0) {
      var percentageDone = (1 - (6.0 - frontCardAlign.x.abs()) / 6.0);

      var x = (secondCardHeightEnd - secondCardHeightStart) * percentageDone;
      secondCardHeight = x + secondCardHeightStart;

      var y = (secondCardWidthEnd - secondCardWidthStart) * percentageDone;
      secondCardWidth = y + secondCardWidthStart;
    } else {
      secondCardHeight = secondCardHeightEnd;
      secondCardWidth = secondCardWidthEnd;
    }

    if (_profiles.length <= 3) {
      return new Center(
        child: new CircularProgressIndicator(backgroundColor: colorStyles['gray'], strokeWidth: 2.0),
      );
    }

    return new Stack(
        children: <Widget>[
          // Middle card
          new Align(
            alignment: middleCardAlign,
            child: new IgnorePointer(
              child: new SizedBox.fromSize(
                size: new Size(MediaQuery.of(context).size.width * secondCardWidth,
                    MediaQuery.of(context).size.height * secondCardHeight),
                child: new ProfileCard(_profiles.elementAt(1) ?? null),
              ),
            ),
          ),
          // Front card
          new Align(
            alignment: frontCardAlign,
            child: new SizedBox.fromSize(
              size: new Size(MediaQuery.of(context).size.width * 0.9, MediaQuery.of(context).size.height * 0.8),
              child: new Transform.rotate(
                angle: (pi / 180.0) * frontCardRot,
                child: new ProfileCard(_profiles.first, likeButtonClick),
              ),
            ),
          ),
          new Align(
            alignment: frontCardAlign,
            child: new SizedBox.fromSize(
              size: new Size(MediaQuery.of(context).size.width * 0.9, MediaQuery.of(context).size.height * 0.8),
              child: new Transform.rotate(
                angle: (pi / 180.0) * frontCardRot,
                child: new Container(
                  alignment: Alignment(0.0, -0.8),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      new Opacity(
                        opacity: heartOpacity,
                        child: new Transform.rotate(
                          angle: (pi / 180) * -25,
                          child: new Icon(Icons.favorite_border,
                              color: Colors.green, size: MediaQuery.of(context).size.height * 0.15),
                        ),
                      ),
                      new Opacity(
                        opacity: crossOpacity,
                        child: new Transform.rotate(
                          angle: (pi / 180) * 25,
                          child:
                              new Icon(Icons.close, color: Colors.red, size: MediaQuery.of(context).size.height * 0.15),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          new SizedBox.expand(
            child: new GestureDetector(
              // While dragging the first card
              onPanUpdate: (DragUpdateDetails details) {
                // Add what the user swiped in the last frame to the alignment of the card
                setState(() {
                  updateOnPan(details, context);
                });
              },
              // When releasing the first card
              onPanEnd: (DragEndDetails details) {
                onPanEndAliignX = frontCardAlign.x;
                onPanEndAliignY = frontCardAlign.y;

                if (details.velocity.pixelsPerSecond.dx > 2000.0 || details.velocity.pixelsPerSecond.dx < -2000.0) {
                  doSwipe();
                  return;
                }
                onPanEnd();
              },
            ),
          )
        ],
      );
  }

  void onPanEnd() {
    if (frontCardAlign.x > 6.0 || frontCardAlign.x < -6.0) {
      doSwipe();
    } else {
      resetController.reset();
      resetController.forward();
    }
  }

  void doSwipe() {
    if (frontCardAlign.x >= 0) {
      like();
    } else {
      dislike();
    }
  }

  void likeButtonClick() {
    if (swiping) return;
    onPanEndAliignX = 0.0;
    onPanEndAliignY = 0.0;
    like();
  }

  void like() {
    swipeRight = true;
    swipeController.reset();
    swipeController.forward();
  }

  void dislike() {
    swipeRight = false;
    swipeController.reset();
    swipeController.forward();
  }

  void updateOnPan(DragUpdateDetails details, BuildContext context) {
    frontCardAlign = new Alignment(frontCardAlign.x + 20 * details.delta.dx / MediaQuery.of(context).size.width,
        frontCardAlign.y + 20 * details.delta.dy / MediaQuery.of(context).size.height);

    frontCardRot = frontCardAlign.x /* * rotation speed */;
  }

  void changeCardsOrder() {
    setState(() {
      _profiles.removeFirst();
      if (_profiles.length < 10) {
        _getMoreProfiles();
      }

      if (_profiles.length < 2) {

      }

      heartOpacity = 0.0;
      crossOpacity = 0.0;
    });
  }
}

class ProfileCard extends StatelessWidget {
  final Profile _profile;
  final Function like;

  ProfileCard(this._profile, [this.like = null]);

  BuildContext _context;

  @override
  Widget build(BuildContext context) {
    _context = context;
    return new Semantics(
      container: true,
      child: new Container(
        margin: new EdgeInsets.all(0.0),
        child: new Material(
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
          type: MaterialType.card,
          elevation: 2.0,
          child: new Stack(
            children: <Widget>[
              new Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[buildTopCard(), buildBottomCard()],
              ),
              new Align(
                  alignment: new Alignment(0.8, 0.8),
                  child: new FloatingActionButton(
                    child: new Icon(Icons.check),
                    onPressed: () => like(),
                    backgroundColor: colorStyles['primary'],
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildBottomCard() {
    return new Container(
      padding: new EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Text(
            _profile.name + ', ' + _profile.age.toString(),
            style: new TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700),
          ),
          new Padding(padding: new EdgeInsets.only(bottom: 8.0)),
          new Text('A short description.', textAlign: TextAlign.start),
        ],
      ),
    );
  }

  Widget buildTopCard() {
    return new Expanded(
      child: Container(
        decoration: new BoxDecoration(
          image: new DecorationImage(
            fit: BoxFit.fill,
            image: new AssetImage(_profile.imgPath),
          ),
        ),
      ),
    );
  }
}
