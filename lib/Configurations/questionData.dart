import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:quora/Configurations/string.dart';
import 'package:shared_preferences/shared_preferences.dart';

writetoFile(String text) async {
  final prefs = await SharedPreferences.getInstance();
  queId = text;
  await prefs.setString("queId", text);
}

Future<void> readfromFile() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    queId = prefs.getString("queId");
  } catch (e) {
    print("Couldn't read file");
  }
}
