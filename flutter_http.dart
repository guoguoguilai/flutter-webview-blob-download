import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:jaguar/jaguar.dart';
import 'package:jaguar_cors/jaguar_cors.dart';
import 'package:jaguar/http/request/request.dart' as jreq;
import 'package:path_provider/path_provider.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var server;
  int _counter = 0;
  final jServer = Jaguar();

  void initJagular() async{
    final options = CorsOptions(
        allowAllOrigins : true,
        allowAllMethods: true,
        allowAllHeaders: true);

    jServer.post('/upload', (ctx) async {
      final Map<String, jreq.FormField> formData = await ctx.bodyAsFormData();
      BinaryFileFormField  pic = formData['webm'];
      var savedPath = await getSavedPath("webm");
      print(savedPath);
      File file = new File(savedPath);
      IOSink sink = file.openWrite();
      await sink.addStream(pic.value);
      await sink.close();
      var newPath = await transferWebm2MP4(savedPath);
      // await Navigator.push(context, MaterialPageRoute(builder: (context) =>
      //     ShowVideo(
      //       videoUrl: newPath
      //     )));
      final result = await ImageGallerySaver.saveFile(newPath);
      print(result);

      return Response.json({"code": 200, "message": "hello, success!"});
    },before: [cors(options)]);

    jServer.post('/', (ctx) async {
      print("???");
      return Response.json({"code": 200, "message": "hello"});
    });

    await jServer.serve(logRequests: true);
  }

  Future<String> getSavedPath(String ext) async {
    Directory dir = Platform.isAndroid
        ? await getTemporaryDirectory()
        : await getApplicationDocumentsDirectory();
    var status = await Permission.photos.request();
    print(status);
    var folder = Directory("${dir.path}/blob/");
    bool exists = await folder.exists();
    if (!exists) {
      await folder.create();
    }
    String fileName = "${folder.path}${DateTime.now().millisecondsSinceEpoch}.${ext}";
    return fileName;
  }
  Future<String> transferWebm2MP4(String webm) async{
    final FlutterFFmpeg _flutterFFmpeg = new FlutterFFmpeg();
    var mp4 = await getSavedPath("mp4");
    print("ffmpeg -i $webm $mp4 ???");
    var rc = await _flutterFFmpeg.execute("-i $webm $mp4");
    print("RC: "+rc.toString());
    return mp4;
  }


  void _incrementCounter() {
    initJagular();
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
class ShowVideo extends StatefulWidget {
  final String videoUrl;

  ShowVideo({
  Key key,
  this.videoUrl}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _VideoAppState();
  }
}


class _VideoAppState extends State<ShowVideo> {
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Demo',
      home: Scaffold(
        body: Center(
          child: _controller.value.isInitialized
              ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          )
              : Container(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              _controller.value.isPlaying
                  ? _controller.pause()
                  : _controller.play();
            });
          },
          child: Icon(
            _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}


