import 'package:finmed/dbhelper/DBHelper.dart';
import 'package:finmed/screen/grid_Screen.dart';
import 'package:finmed/widgets/adddoc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import './widgets/new_transaction.dart';
import './widgets/transaction_list.dart';
import './widgets/chart.dart';
import './models/transaction.dart';
import 'package:android_alarm_manager/android_alarm_manager.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var initializationSettingsAndroid =
      AndroidInitializationSettings('codex_logo');
  var initializationsSettings =
      InitializationSettings(initializationSettingsAndroid, null);

  await flutterLocalNotificationsPlugin.initialize(
    initializationsSettings,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Med-Notifier',
      theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.amber,
          // errorColor: Colors.red,
          fontFamily: 'Quicksand',
          textTheme: ThemeData.light().textTheme.copyWith(
                title: TextStyle(
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                button: TextStyle(color: Colors.white),
              ),
          appBarTheme: AppBarTheme(
            textTheme: ThemeData.light().textTheme.copyWith(
                  title: TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
          )),
      home: MyHomePage(),
      routes: {'/gridscreen': (ctx) => GridDoc()},
    );
  }
}

class MyHomePage extends StatefulWidget {
  // String titleInput;
  // String amountInput;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var currentMin = TimeOfDay.now().hour * 60 + TimeOfDay.now().minute;

  final List<Transaction> _userTransactions = [
    // Transaction(
    //   id: 't1',
    //   title: 'New Shoes',
    //   amount: 69.99,
    //   date: DateTime.now(),
    // ),
    // Transaction(
    //   id: 't2',
    //   title: 'Weekly Groceries',
    //   amount: 16.53,
    //   date: DateTime.now(),
    // ),
  ];
  final List _timeSlots = [];
  static int globalIndex = -1;

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  void scheduleAlarm() async {
    // var scheduledNotificationDateTime = DateTime.now().add(
    //   Duration(seconds: 5),
    // );

    var scheduledNotificationDateTime = DateTime.now().add(Duration(
        seconds: (_userTransactions[0].time.hour * 3600 +
            _userTransactions[0].time.minute * 60 -
            (TimeOfDay.now().hour * 3600 + TimeOfDay.now().minute * 60))));
    setState(() {
      if (globalIndex == _userTransactions.length) globalIndex = 0;
    });
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'alarm_notif', 'alarm_notif', 'Channel for Alarm notification',
        icon: 'medi',
        sound: RawResourceAndroidNotificationSound('bia'),
        largeIcon: DrawableResourceAndroidBitmap('medi'),
        playSound: true);
    var platformChannelSpecifics =
        NotificationDetails(androidPlatformChannelSpecifics, null);
    await flutterLocalNotificationsPlugin
        .schedule(0, 'medicine', 'Time for medicine ',
            scheduledNotificationDateTime, platformChannelSpecifics)
        .then((value) => setState(() {}));
  }

  void _addNewTransaction(String txTitle, double txAmount, DateTime chosenDate,
      TimeOfDay chosenTime) {
    final newTx = Transaction(
        title: txTitle,
        amount: txAmount,
        date: chosenDate,
        id: DateTime.now().toString(),
        time: chosenTime);

    // await DBhelper.insert(DateTime.now().toString(), txTitle, 'time');
    // await DBhelper.query();

    setState(() {
      if ((newTx.time.hour * 60 + newTx.time.minute) >
          (TimeOfDay.now().hour * 60 + TimeOfDay.now().minute)) globalIndex = 0;
      _userTransactions.add(newTx);
      if (_userTransactions.length > 1)
        _userTransactions.sort((a, b) => (a.time.hour * 60 + a.time.minute)
            .compareTo(b.time.hour * 60 + b.time.hour));

      print(_userTransactions[0].time.hour * 60 +
          _userTransactions[0].time.minute);
      var ele = _userTransactions.where((element) =>
          element.time.hour.round() > TimeOfDay.now().hour.round());
      ele.map((e) {
        _timeSlots.add(e);
      });
    });
    _timeSlots.forEach((element) {
      print(element.title);
    });
    if ((newTx.time.hour * 60 + newTx.time.minute) >
        (TimeOfDay.now().hour * 60 + TimeOfDay.now().minute)) scheduleAlarm();
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: NewTransaction(_addNewTransaction),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  void _deleteTransaction(String id) async {
    await DBhelper.delete(id).then((value) async => await DBhelper.query());

    setState(() {
      _userTransactions.removeWhere((tx) => tx.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.purple[100],
                backgroundBlendMode: BlendMode.hue,
              ),
              child: Center(
                child: CircleAvatar(
                  backgroundColor: Colors.deepPurple,
                  backgroundImage: AssetImage(
                    'assets/images/medi.png',
                  ),
                  maxRadius: 100,
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            ListTile(
              leading: Icon(Icons.share),
              title: Text('Share To Local Retailer'),
              onTap: () {
                Navigator.of(context)
                    .pushNamed('/gridscreen', arguments: {'l': 'yy'});
              },
            ),
            SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text(
          'Share to retailer',
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _startAddNewTransaction(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Chart(_recentTransactions),
            TransactionList(_userTransactions, _deleteTransaction),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _startAddNewTransaction(context),
      ),
    );
  }
}
