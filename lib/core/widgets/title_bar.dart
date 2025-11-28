import 'package:flutter/material.dart';

class TitleBar extends StatelessWidget {
  const TitleBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            'assets/images/logo_fake_store.png',
            width: 85,
            height: 85,
          ),
          SizedBox(width: 25),
          Flexible(
            child: Center(
              child: Text(
                'Demo Store',
                maxLines: 1,
                style: TextStyle(color: Colors.grey[700], fontSize: 30),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
