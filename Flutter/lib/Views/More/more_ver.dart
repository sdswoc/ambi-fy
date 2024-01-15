import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/Views/Common/bottom_navigation_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class MoreVer extends StatefulWidget {
  const MoreVer({super.key});

  @override
  State<MoreVer> createState() => _MoreVerState();
}

class _MoreVerState extends State<MoreVer> {
  bool isExpanded = false;
  final String about_url = dotenv.env['ABOUT_URL']!;
  static const String version = 'xx.xx.xx.xx';

  Future<void> _launchUrl() async {
    if (!await launchUrl(Uri.parse(about_url))) {
      throw Exception('Could not launch $about_url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 65,
          backgroundColor: Colors.black,
          title: const Text("More",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Roboto',
                  wordSpacing: -2,
                  letterSpacing: -0.8)),
        ),
        body: ListView(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(8, 70, 8, 80),
              child: Center(
                child: CircleAvatar(
                  radius: 90,
                ),
              ),
            ),
            InkWell(
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Container(
                      height: 100,
                      width: 300,
                      color: Colors.grey.shade800,
                      child: const Padding(
                        padding: EdgeInsets.fromLTRB(20, 14, 8, 20),
                        child: Text(
                          'Settings',
                          style: TextStyle(
                              fontSize: 26,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.bold),
                        ),
                      )),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text(
                    'Version: $version',
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                  duration: Duration(seconds: 2),
                  backgroundColor: Color.fromARGB(255, 48, 47, 47),
                ));
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Container(
                      height: 100,
                      width: 300,
                      color: Colors.grey.shade800,
                      child: const Padding(
                        padding: EdgeInsets.fromLTRB(20, 14, 8, 20),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 200,
                              child: Text(
                                'About',
                                style: TextStyle(
                                    fontSize: 26,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      )),
                ),
              ),
            ),
            InkWell(
              onTap: () => _launchUrl(),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Container(
                      height: 100,
                      width: 300,
                      color: Colors.grey.shade800,
                      child: const Padding(
                        padding: EdgeInsets.fromLTRB(20, 14, 8, 20),
                        child: Text(
                          'Help',
                          style: TextStyle(
                              fontSize: 26,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.bold),
                        ),
                      )),
                ),
              ),
            )
          ],
        ),
        bottomNavigationBar: const BottomNav(selectedIndex: 3));
  }
}
