import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

final int CATEGORY_SUBMISSION = 1;
final int CATEGORY_EXAM       = 2;
final int CATEGORY_IVENT      = 3;

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
  int    category=CATEGORY_SUBMISSION;
  String date="", time="", title="", memo="";
  String debgJson="-json here-";

  Future addIvent() async
  {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String apiKey     = pref.getString("apiKey");
    String calendarID = pref.getString("calendarID");
    if(apiKey     == "" || calendarID == "")
    {
      showDialog(context: context, builder:(context) =>
      AlertDialog(title: Text("Error"), content: Text("Please set API key or calendar ID")));
      return;
    }
    if(date == "" || title == "" || (allDay && time==""))
    {
      showDialog(context: context, builder:(context) =>
      AlertDialog(title: Text("Error"), content: Text("Please fill in the required items")));
      return;
    }
    String json='{"data": {"attributes": {"category": "schedule","title": "${title}","description": "${memo}","all_day": false,"start_at": "${date}T${time}:00.000Z","start_timezone": "Asia/Tokyo","end_at": "${date}T${time}:00.000Z","end_timezone": "Asia/Tokyo"},"relationships": {"label": {"data": {"id": "hoeKBuwq36Ad,1","type": "label"}}}}}';
    setState(() => debgJson=json);
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
        TextField(onChanged:(value) => date = value, decoration: InputDecoration(hintText: "Date ex. 2000-01-01*")),
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
            decoration: InputDecoration(hintText: "Time ex. 23:05")
          ))
        ]),
        // タイトル
        TextField(onChanged:(value) => title = value, decoration: InputDecoration(hintText: "Title*")),
        // メモ
        TextField(onChanged:(value) => memo = value,  decoration: InputDecoration(hintText: "Memo"), maxLines: null),
        Container(height: 20),
        // 追加ボタン
        RaisedButton(onPressed: () => addIvent(), child: Text("Add")),
        Text(debgJson)
      ]))
    );
  }
}

class SettingPage extends StatelessWidget
{
  SettingPage({Key key}) : super(key: key);
  String apiKey, calendarID;

  Future applySetting(BuildContext context) async
  {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString("apiKey"    , apiKey);
    await pref.setString("calendarID", calendarID);
    Navigator.pop(context);
  }

  @override Widget build(BuildContext context)
  {
    return Scaffold
    (
      appBar: AppBar(title: Text("Settings"), actions:
      [
        IconButton
        (
          icon: Icon(Icons.check),
          onPressed: ()=>applySetting(context)
        )
      ]),
      body: Padding(padding: EdgeInsets.all(15), child:Column(children:
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
      ]))
    );
  }
}
