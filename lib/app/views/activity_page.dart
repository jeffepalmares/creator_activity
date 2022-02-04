import 'package:flutter/material.dart';

class ActivityPage extends StatefulWidget {
  final String title;
  const ActivityPage({Key? key, this.title = 'ActivityPage'}) : super(key: key);
  @override
  ActivityPageState createState() => ActivityPageState();
}
class ActivityPageState extends State<ActivityPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: <Widget>[],
      ),
    );
  }
}