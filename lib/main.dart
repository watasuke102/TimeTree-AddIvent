import 'package:flutter/material.dart';

final int CATEGORY_SUBMISSION = 0;
final int CATEGORY_EXAM = 1;
final int CATEGORY_IVENT = 2;

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

class MainPage extends StatefulWidget
{
  MainPage({Key key}) : super(key: key);


  @override MPState createState() => MPState();
}
class MPState extends State<MainPage>
{
  bool   allDay=false;
  int    category=0;
  String date, time, title, memo;

  void addIvent()
  {

  }

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
        Row(children:
        [
          // 提出物
          Flexible(child:RadioListTile
          (
            title: Text("Submission"),
            groupValue: category,
            value: CATEGORY_SUBMISSION,
            onChanged: (value) => setState(()=>category=value)
          )),
          // 試験
          Flexible(child:RadioListTile
          (
            title: Text("Exam"),
            groupValue: category,
            value: CATEGORY_EXAM,
            onChanged: (value) => setState(()=>category=value)
          )),
          // イベント
          Flexible(child:RadioListTile
          (
            title: Text("Ivent"),
            groupValue: category,
            value: CATEGORY_IVENT,
            onChanged: (value) => setState(()=>category=value)
          )),
        ]),
        // 日付
        TextField(onChanged:(value) => date = value, decoration: InputDecoration(hintText: "Date ex.2000-01-01")),
        Row(children:
        [
          // 終日かどうか
          Flexible(child:CheckboxListTile
          (
            title: Text("AllDay"),
            value: allDay,
            onChanged:(value)=>setState(()=>allDay=value)
          )),

          Container(width: 100),

          // 時間
          Flexible(child:TextField
          (
            onChanged:(value) => time = value,
            decoration: InputDecoration(hintText: "Time ex.2000-01-01")
          ))
        ]),
        // タイトル
        TextField(onChanged:(value) => title = value, decoration: InputDecoration(hintText: "Title")),
        // メモ
        TextField(onChanged:(value) => memo = value,  decoration: InputDecoration(hintText: "Memo"), maxLines: null),
        Container(height: 20),
        // 追加ボタン
        RaisedButton(onPressed: () => addIvent(), child: Text("Add"))
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
          onPressed: ()=>Navigator.pop(context)
        )
      ]),
      body: Column(children:
      [
        TextField
        (
          onChanged:(value) => apiKey = value,
          decoration: InputDecoration(hintText: "TimeTree API Key")
        ),
        TextField
        (
          onChanged:(value) => calendarID = value,
          decoration: InputDecoration(hintText: "TimeTree Calendar ID")
        )
      ])
    );
  }
}
