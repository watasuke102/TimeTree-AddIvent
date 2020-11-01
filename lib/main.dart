import 'package:flutter/material.dart';

void main()=>runApp(App());

class App extends StatelessWidget
{
  @override Widget build(BuildContext context)
  {
    return MaterialApp
    (
      title: 'TimeTreeAddIvent',
      theme: ThemeData(primarySwatch: Colors.lightGreen),
      home:  MainPage(),
    );
  }
}

class MainPage extends StatelessWidget
{
  MainPage({Key key}) : super(key: key);
  @override Widget build(BuildContext context)
  {
    return Scaffold
    (
      appBar: AppBar(title: Text("TimeTreeAddIvent"), actions:
      [
        IconButton
        (
          icon: Icon(Icons.settings),
          onPressed: ()=>Navigator.push(context, MaterialPageRoute( builder:(context) => SettingPage() ))
        )
      ]),
      body:Padding(padding: EdgeInsets.all(15), child: Column(children:
      [
      ]))
    );
  }
}

class SettingPage extends StatelessWidget
{
  SettingPage({Key key}) : super(key: key);
  String apiKey, calendarID;
  @override Widget build(BuildContext context)
  {
    return Scaffold
    (
      appBar: AppBar(title: Text("Settings"), actions:
      [
        IconButton
        (
          icon: Icon(Icons.check),
          onPressed: ()=>Navigator.pop(context))
      ]),
      body: Column(children:
      [
        Text("")
      ])
    );
  }
}
