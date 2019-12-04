import 'package:alco_safe/login.dart';
import 'package:flutter/material.dart';
import 'package:alco_safe/home.dart';
import 'package:alco_safe/register.dart';

final routes = {
  '/login':         (BuildContext context) => new LoginPage(),
  '/register':         (BuildContext context) => new Register(),
  '/home':         (BuildContext context) => new Home(),
  '/' :          (BuildContext context) => new LoginPage(),
};