import 'package:arp_scanner/arp_scanner.dart';
import 'package:flutter/material.dart';
import 'package:miracle_sliver_app_bar/miracle_sliver_app_bar.dart';
import 'package:public_ip_address/public_ip_address.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  int _counter = 0;

  void _incrementCounter() async {
    var reusult = await IpAddress.getAllDataFor("192.168.1.3");
    await ArpScanner.scan();
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
    // return  Scaffold(
    //   body: CustomScrollView(
    //     slivers: [
    //       SliverAppBar(
    //         expandedHeight: 350.0,
    //         floating: false,
    //         pinned: true,
    //         flexibleSpace: FlexibleSpaceBar(
    //           background: Container(
    //             color: Colors.yellow,
    //             child: const Center(child: Text('My Parallax Image!')),
    //           ),
    //         ),
    //       ),
    //       SliverToBoxAdapter(
    //         child: Container(
    //           height: 100,
    //           color: Colors.blueAccent,
    //           child: Stack(
    //             children: [
    //               Align(
    //                 alignment: const Alignment(0.0, -2.0),
    //                 child: Container(
    //                   width: 50,
    //                   height: 50,
    //                   decoration: const BoxDecoration(
    //                     shape: BoxShape.circle,
    //                     color: Colors.red,
    //                   ),
    //                   child: const Center(child: Text('Red')),
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //       ),
    //       SliverList(
    //         delegate: SliverChildBuilderDelegate(
    //               (BuildContext context, int index) {
    //             return Container(
    //               height: 50,
    //               color: Colors.teal[100 * ((index % 8) + 1)],
    //               child: Center(child: Text('Item #$index')),
    //             );
    //           },
    //           childCount: 20,
    //         ),
    //       ),
    //     ],
    //   ),
    // );

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverPersistentHeader(
              pinned: true,
              floating: true,
              delegate: MiracleSliverHeaderDelegate(
                vsync: this,
                extentMaxHeight: 200,
                extentMinHeight: MediaQuery.of(context).padding.top + 56,
                actions: [const Icon(Icons.add)],
                titleScale: 16 / 24,
                child:(value)=> Align(
                  alignment: Alignment.bottomCenter,
                  child: Transform.translate(
                    offset: const Offset(0,25),
                    child: UnconstrainedBox(
                      child: Container(
                        decoration: BoxDecoration(color: Colors.greenAccent, borderRadius: BorderRadius.circular(100)),
                        height: 50,
                        width: 50,
                        child: Center(child: Text(value.toStringAsPrecision(2).toString())),
                      ),
                    ),
                  ),
                ),
                backgroundColor: Colors.red,
                title: '',
                // titleWidget: const Text('This is title'),
              ),
            ),
          ];
        },
        body: ListView.builder(
            itemCount: 20,
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
              return Container(
                height: 100,
                color: (index % 2 == 0) ? Colors.red : Colors.yellow,
                child: Center(child: Text('$index')),
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
