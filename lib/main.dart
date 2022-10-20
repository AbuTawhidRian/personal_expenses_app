import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:personal_expenses_app/widgets/chart.dart';
import 'package:personal_expenses_app/widgets/new_transaction.dart';
import 'package:personal_expenses_app/widgets/transaction_list.dart';
import 'models/transaction.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
    ],
  ).then((_) {
    runApp(new MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
        fontFamily: 'Quicksand',
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.white,
              fontFamily: 'OpenSans'),
        ),
      ),
      title: 'Personal Expenses App',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransactions = [];

  List<Transaction> get _recentTransactions {
    return _userTransactions
        .where((tx) => tx.date.isAfter(
              DateTime.now().subtract(
                Duration(days: 7),
              ),
            ))
        .toList();
  }

  bool _showChart = false;

  void _addNewTransaction(
      String txTitle, double txAmount, DateTime pickedDate) {
    final newTx = Transaction(
      id: DateTime.now().toString(),
      title: txTitle,
      amount: txAmount,
      date: pickedDate,
    );
    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        isDismissible: true,
        useRootNavigator: true,
        enableDrag: true,
        isScrollControlled: true,
        context: ctx,
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            behavior: HitTestBehavior.opaque,
            child: NewTransaction(addTx: _addNewTransaction),
          );
        });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) => tx.id == id);
    });
  }

  List<Widget> _buildLandscapeContent(MediaQueryData mediaQuery,
      PreferredSizeWidget appBar, Widget txListWidget) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Show Chart'),
          Switch.adaptive(
            value: _showChart,
            onChanged: (value) {
              setState(() {
                _showChart = value;
              });
            },
          ),
        ],
      ),
      _showChart
          ? Container(
              height: (mediaQuery.size.height -
                      appBar.preferredSize.height -
                      mediaQuery.padding.top) *
                  .7,
              child: Chart(_recentTransactions))
          : txListWidget,
    ];
  }

  List<Widget> _buildPortraitContent(MediaQueryData mediaQuery,
      PreferredSizeWidget appBar, Widget txListWidget) {
    return [
      Container(
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            .3,
        child: Chart(_recentTransactions),
      ),
      txListWidget,
    ];
  }

  PreferredSizeWidget _buildAppBar(String txt) {
    return AppBar(
      actions: [
        IconButton(
          onPressed: () => _startAddNewTransaction(context),
          icon: const Icon(
            Icons.add,
            size: 30,
          ),
        )
      ],
      title: Text(txt),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    final PreferredSizeWidget appBar = _buildAppBar('Personal Expenses App');
    final txListWidget = Container(
      height: (mediaQuery.size.height - appBar.preferredSize.height) * .7,
      child: TransactionList(_userTransactions, _deleteTransaction),
    );
    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (isLandscape)
              ..._buildLandscapeContent(
                mediaQuery,
                appBar,
                txListWidget,
              ),
            if (!isLandscape)
              ..._buildPortraitContent(
                mediaQuery,
                appBar,
                txListWidget,
              ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: !isLandscape
          ? FloatingActionButton(
              onPressed: () => _startAddNewTransaction(context),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
