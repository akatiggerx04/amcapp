import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MorePage extends StatelessWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset(
          "assets/logo.png",
          width: 200,
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/icon.png",
                    height: 72,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(
                    height: 12,
                    width: double.infinity,
                  ),
                  const Text(
                    "African Minifootball Confederation",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text("All rights reserved. Developed by @akatiggerx04"),
                  const SizedBox(
                    height: 12,
                    width: double.infinity,
                  ),
                  const URLButton(
                    redirectUrl:
                        'https://www.africanminifootball.org?source=app',
                    buttonIcon: Icons.link,
                    buttonText: "Our Website",
                  ),
                  const URLButton(
                    redirectUrl:
                        'https://www.africanminifootball.org/privacy-policy-app.html',
                    buttonIcon: Icons.privacy_tip_rounded,
                    buttonText: "Privacy Policy",
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class URLButton extends StatelessWidget {
  final String buttonText;
  final String redirectUrl;
  final IconData buttonIcon;

  const URLButton({
    super.key,
    required this.buttonText,
    required this.redirectUrl,
    required this.buttonIcon,
  });

  Future<void> _openLink(openurl) async {
    if (!await launchUrl(openurl)) {
      throw Exception('Unable to launch $openurl!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: ElevatedButton.icon(
        onPressed: () async {
          await _openLink(
            Uri.parse(redirectUrl),
          );
        },
        icon: Icon(
          buttonIcon,
          size: 24,
        ),
        label: Text(
          buttonText,
        ),
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shadowColor: Colors.transparent,
        ),
      ),
    );
  }
}
