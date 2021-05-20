import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:ipecstudentsapp/screens/about/about.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../data/repo/auth.dart';
import '../../theme/colors.dart';
import '../../theme/style.dart';
import '../../util/SizeConfig.dart';
import '../../widgets/background.dart';
import '../notices/notices_screen.dart';
import '../splash/splash_screen.dart';
import 'attendance/attendance_page.dart';

class DashboardScreen extends StatefulWidget {
  static const String ROUTE = '/Dashboard';
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      new GlobalKey<ScaffoldMessengerState>();
  final appLink = Platform.isIOS
      ? "https://apps.apple.com/us/app/ipec-students-app/id1568495067"
      : "https://play.google.com/store/apps/details?id=com.uttu.ipecstudentsapp&hl=en_IN&gl=US";
  _launchURL(String url) async {
    print(url);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    super.initState();
    FirebaseAuth auth = FirebaseAuth.instance;
    auth.signInAnonymously();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Auth>(
      builder: (context, auth, child) {
        return ScaffoldMessenger(
          key: _scaffoldKey,
          child: Scaffold(
            body: Background(
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CircleAvatar(
                            radius: SizeConfig.widthMultiplier * 7,
                            backgroundImage: MemoryImage(
                              base64Decode(
                                  auth.user.img.toString().split(',')[1]),
                            ),
                          ),
                          PopupMenuButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0))),
                              icon: ImageIcon(AssetImage(
                                'assets/icons/menu.png',
                              )),
                              onSelected: (value) {
                                switch (value) {
                                  case 1:
                                    _launchURL(appLink);

                                    break;
                                  case 2:
                                    FlutterShare.share(
                                        title: 'IPEC Student\'s App',
                                        text:
                                            'Best app for checking attendance and notices.',
                                        linkUrl: appLink,
                                        chooserTitle: 'IPEC');
                                    break;
                                  case 3:
                                    auth.logout().then((value) =>
                                        Navigator.pushReplacementNamed(
                                          context,
                                          SplashScreen.ROUTE,
                                        ));

                                    break;
                                }
                              },
                              itemBuilder: _popOptions),
                        ],
                      ),
                      kHighPadding,
                      Text(
                        'Hello,',
                        style: Theme.of(context)
                            .textTheme
                            .headline5
                            .copyWith(color: Colors.black),
                      ),
                      Text(
                        auth.user.name,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.headline5.copyWith(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              kHighPadding,
                              kHighPadding,
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  optionIcon(
                                      'assets/icons/Bag.png',
                                      'Attendance',
                                      () => Navigator.pushNamed(
                                          context, AttendancePage.ROUTE)),
                                  optionIcon(
                                    'assets/icons/Atom.png',
                                    'Notices',
                                    () => Navigator.pushNamed(
                                        context, NoticesScreen.ROUTE),
                                  ),
                                ],
                              ),
                              kMedPadding,
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  optionIcon('assets/icons/Boy-Student.png',
                                      'Learning', () {
                                    _showSnackBar(
                                        "This is not developed yet!👷‍♂️ Soon be available");
                                  }),
                                  optionIcon(
                                      'assets/icons/Compass.png', 'About', () {
                                    Navigator.pushNamed(
                                        context, AboutScreen.ROUTE);
                                  }),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  List<PopupMenuEntry<int>> _popOptions(context) => [
        PopupMenuItem(
            value: 1,
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(2, 2, 8, 2),
                  child: Icon(Icons.star),
                ),
                Text('Rate')
              ],
            )),
        PopupMenuItem(
            value: 2,
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(2, 2, 8, 2),
                  child: Icon(Icons.share),
                ),
                Text('Share')
              ],
            )),
        PopupMenuItem(
            value: 3,
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(2, 2, 8, 2),
                  child: Icon(Icons.logout),
                ),
                Text('Logout')
              ],
            )),
      ];

  Widget optionIcon(String img, String title, Function onPress) {
    return Flexible(
      child: InkWell(
        onTap: onPress,
        borderRadius: BorderRadius.circular(30),
        highlightColor: kPrimaryLightColor,
        child: Ink(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                img,
                width: SizeConfig.widthMultiplier * 15,
              ),
              kLowPadding,
              Text(
                title,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSnackBar(String s) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(s)));
  }
}
