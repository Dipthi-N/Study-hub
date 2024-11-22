import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Import url_launcher

class SharePage extends StatelessWidget {
  // Function to launch the social media URLs
  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Post your comments and posts on social media!',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _launchURL('https://www.instagram.com/'), // Instagram URL
            child: Text('Share on Instagram'),
            style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 214, 119, 231)),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () => _launchURL('https://www.facebook.com/'), // Facebook URL
            child: Text('Share on Facebook'),
            style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 166, 209, 245)),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () => _launchURL('https://twitter.com/'), // Twitter URL
            child: Text('Share on Twitter'),
            style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 134, 199, 153)),
          ),
        ],
      ),
    );
  }
}
