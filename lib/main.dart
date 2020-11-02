import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';


class _data
{
  String apiKey="", calendarID="";
  int category_submission=1, category_exam=2, category_ivent=3;

  Future init() async
  {
    SharedPreferences pref = await SharedPreferences.getInstance();
    apiKey              = pref.getString("apiKey");
    calendarID          = pref.getString("calendarID");
    category_submission = pref.getInt("category_submission");
    category_exam       = pref.getInt("category_exam");
    category_ivent      = pref.getInt("category_ivent");
  }
}
_data data=_data();

void main()=>runApp(App());

class App extends StatelessWidget
{
  @override Widget build(BuildContext context)
  {
    return MaterialApp
    (
      title: 'TimeTreeAddIvent',
      theme: ThemeData(primarySwatch: Colors.green, fontFamily: "mplus"),
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
  int    category=data.category_submission;
  String date="", time="", title="", memo="";
  String debug="json here";

  Future addIvent() async
  {
    if(data.apiKey == "" || data.calendarID == "")
    {
      showDialog(context: context, builder:(context) =>
        AlertDialog(title: Text("Error"), content: Text("APIキーもしくはカレンダーIDガセットされていません")));
      return;
    }
    if(date == "" || title == "" || (!allDay && time==""))
    {
      showDialog(context: context, builder:(context) =>
        AlertDialog(title: Text("Error"), content: Text("必須項目を入力してください")));
      return;
    }
    if(allDay) time="00:00";
    String json='{"data":{"attributes":{"category":"schedule","title":"${title}","description":"${memo.replaceAll("\n", "\\n")}","all_day":${allDay},"start_at":"${date}T${time}:00.000+0900","start_timezone":"Asia/Tokyo","end_at":"${date}T${time}:00.000+0900","end_timezone":"Asia/Tokyo"},"relationships":{"label":{"data":{"id":"${data.calendarID},${category}","type":"label"}}}}}';
    if(allDay) time="";
    setState(()=>debug=json);
    Map<String,String> headers=
    {
      "Content-Type"  : "application/json",
      "Accept"        : "application/vnd.timetree.v1+json",
      "Authorization" : "Bearer ${data.apiKey}"
    };
    Response resp = await post
    (
      "https://timetreeapis.com/calendars/${data.calendarID}/events",
      headers: headers,
      body: json
    );
    int stat=resp.statusCode;
    if(stat != 200 && stat != 201)
    {
      print(resp.body.toString());
      Map<String, dynamic> json = jsonDecode(resp.body);
      String errors=json["errors"].toString();
      errors = errors.replaceAll("{", "");
      errors = errors.replaceAll("}", "");
      errors = errors.replaceAll(",", "\n");
      showDialog(context: context, builder:(context) =>
        AlertDialog(title: Text("Error"), content: Text("イベントの作成に失敗しました: ${stat}\n\n${errors}")));
      return;
    }
    showDialog(context: context, builder:(context) =>
      AlertDialog(title: Text("Completed!"), content: Text("イベントを作成しました: ${stat}")));
  }

  @override void initState()
  {
    super.initState();
    Future f=data.init();
    f.then((value) => setState(()=>category=data.category_submission));
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
          onPressed: () async
          {
            await Navigator.push(context, MaterialPageRoute( builder:(context) => SettingPage() ));
            setState(()=>null);
          }
        )
      ]),
      body:SingleChildScrollView(child:Padding(padding: EdgeInsets.all(15), child: Column(children:
      [
        Row(children:
        [
          // 提出物
          Flexible(child:RadioListTile
          (
            title: Text("提出物"),
            groupValue: category,
            value: data.category_submission,
            onChanged: (value) => setState(()=>category=value)
          )),
          // 試験
          Flexible(child:RadioListTile
          (
            title: Text("試験"),
            groupValue: category,
            value: data.category_exam,
            onChanged: (value) => setState(()=>category=value)
          )),
          // イベント
          Flexible(child:RadioListTile
          (
            title: Text("イベント"),
            groupValue: category,
            value: data.category_ivent,
            onChanged: (value) => setState(()=>category=value)
          )),
        ]),
        // 日付
        TextField(onChanged:(value) => date = value, decoration: InputDecoration(labelText: "*日付（例→ 2000-01-01）")),
        Row(children:
        [
          // 終日かどうか
          Flexible(child:CheckboxListTile
          (
            title: Text("終日"),
            value: allDay,
            onChanged:(value)=>setState(()=>allDay=value)
          )),

          Container(width: 10),

          // 時間
          Flexible(child:TextField
          (
            onChanged:(value) => time = value,
            decoration: InputDecoration(labelText: "*時刻（例→ 23:05）")
          ))
        ]),
        // タイトル
        TextField(onChanged:(value) => title = value, decoration: InputDecoration(labelText: "*タイトル")),
        // メモ
        TextField(onChanged:(value) => memo = value,  decoration: InputDecoration(labelText: "メモ"), maxLines: null),
        Container(height: 20),
        // 追加ボタン
        RaisedButton(onPressed: () => addIvent(), child: Text("予定を作成する",style: Theme.of(context).textTheme.headline4)),
        Text(debug)
      ]))
    ));
  }
}

class SettingPage extends StatelessWidget
{
  SettingPage({Key key}) : super(key: key);
  String apiKey=data.apiKey, calendarID=data.calendarID;
  int submissionID = data.category_submission;
  int examID       = data.category_exam;
  int iventID      = data.category_ivent;

  Future applySetting(BuildContext context) async
  {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString("apiKey"    , apiKey);
    await pref.setString("calendarID", calendarID);
    await pref.setInt("category_submission", submissionID);
    await pref.setInt("category_exam", examID);
    await pref.setInt("category_ivent", iventID);
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
      body:SingleChildScrollView(child:Padding(padding: EdgeInsets.all(15), child:Column(children:
      [
        // API Key
        TextField
        (
          controller: TextEditingController(text: data.apiKey),
          decoration: InputDecoration(labelText: "TimeTree API Key"),
          onChanged:(value) => apiKey = value
        ),
        // Calendar ID
        TextField
        (
          controller: TextEditingController(text: data.calendarID),
          decoration: InputDecoration(labelText: "TimeTree Calendar ID"),
          onChanged:(value) => calendarID = value
        ),
        // Submission label ID
        TextField
        (
          controller: TextEditingController(text: data.category_submission.toString()),
          decoration: InputDecoration(labelText: "提出物ラベルのID"),
          onChanged:(value) => submissionID = int.parse(value)
        ),
        // Exam label ID
        TextField
        (
          controller: TextEditingController(text: data.category_exam.toString()),
          decoration: InputDecoration(labelText: "試験ラベルのID"),
          onChanged:(value) => examID = int.parse(value)
        ),
        // Ivent label ID
        TextField
        (
          controller: TextEditingController(text: data.category_ivent.toString()),
          decoration: InputDecoration(labelText: "イベントラベルのID"),
          onChanged:(value) => iventID = int.parse(value)
        )
      ]))
    ));
  }
}
