import 'package:flutter/material.dart';

import 'package:flutterchat/auth_service.dart';

void main() => runApp(FlashChat());

class FlashChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: AuthService().handleAuth()
    );
  }
}