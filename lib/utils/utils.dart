import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void showInfoDialogue(BuildContext context) {
  showAboutDialog(
    context: context,
    applicationName: "Flappy dash",
    applicationVersion: "1.0.0",
    applicationIcon: Image.asset(
      "assets/images/auto_run_instruction.png",
      height: 54,
      width: 54,
    ),
    children: [
      const Text(
          "Flappy Dash, developed in Flutter Flame, offers the classic flappy bird gameplay experience. Navigate through obstacles with precise taps, enjoying smooth animations and addictive challenges."),
      const SizedBox(
        height: 20.0,
      ),
      const Text("Artwork Credits :"),
      const SizedBox(
        height: 8.0,
      ),
      GestureDetector(
        child: Text(
          "• https://github.com/flutter/super_dash",
          style: TextStyle(
            color: Colors.blue[700],
          ),
        ),
        onTap: () async {
          await launchUrl(Uri.parse("https://github.com/flutter/super_dash"));
        },
      ),
      const SizedBox(
        height: 4.0,
      ),
      GestureDetector(
        child: Text(
          "• https://github.com/samuelcust/flappy-bird-assets",
          style: TextStyle(
            color: Colors.blue[700],
          ),
        ),
        onTap: () async {
          await launchUrl(
              Uri.parse("https://github.com/samuelcust/flappy-bird-assets"));
        },
      ),
      const SizedBox(
        height: 20.0,
      ),
      const Text("Other Links :"),
      const SizedBox(
        height: 8.0,
      ),
      GestureDetector(
        child: Text(
          "Privacy Policy",
          style: TextStyle(
            color: Colors.blue[700],
          ),
        ),
        onTap: () async {
          await launchUrl(Uri.parse(
              "https://www.freeprivacypolicy.com/live/876205b6-31cf-4d71-8e94-aa3f6f9fd232"));
        },
      ),
      const SizedBox(
        height: 4.0,
      ),
      GestureDetector(
        child: Text(
          "Terms of Service",
          style: TextStyle(
            color: Colors.blue[700],
          ),
        ),
        onTap: () async {
          await launchUrl(Uri.parse(
              "https://www.freeprivacypolicy.com/live/bfb2f7b7-136c-4393-b29e-3db719a9827b"));
        },
      ),
    ],
  );
}
