import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:responsive_adaptive/widgets/chart.dart';
import 'package:responsive_adaptive/widgets/new_transaction.dart';
import 'package:responsive_adaptive/widgets/transaction_list.dart';

import 'models/transaction.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ],
  ).then((_) {
    runApp(const MyApp());
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Personal Expenses',
      theme: ThemeData(
          fontFamily: 'Quicksand',
          textTheme: const TextTheme(
            headline3: TextStyle(
              fontFamily: 'OpenSans',
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
            button: TextStyle(color: Colors.white),
          ),
          appBarTheme: const AppBarTheme(
            titleTextStyle: TextStyle(
              fontFamily: 'OpenSans',
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.purple)
              .copyWith(secondary: Colors.amber)),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  // String titleInput;
  // String amountInput;
  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
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

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          const Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _addNewTransaction(
      String txTitle, double txAmount, DateTime chosenDate) {
    final newTx = Transaction(
      title: txTitle,
      amount: txAmount,
      date: chosenDate,
      id: DateTime.now().toString(),
    );

    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          behavior: HitTestBehavior.opaque,
          child: NewTransaction(_addNewTransaction),
        );
      },
    );
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) => tx.id == id);
    });
  }

  bool showChart = false;
  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final mediaSize = MediaQuery.of(context).size;
    final isLandScape = media.orientation == Orientation.landscape;
    final ObstructingPreferredSizeWidget appBar = (!Platform.isIOS
        ? CupertinoNavigationBar(
            middle: const Text(
              'Personal Expenses',
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  child: const Icon(CupertinoIcons.add),
                  onTap: () => _startAddNewTransaction(context),
                ),
              ],
            ),
          )
        : AppBar(
            title: const Text(
              'Personal Expenses',
            ),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => _startAddNewTransaction(context),
              ),
            ],
          )) as ObstructingPreferredSizeWidget;
    var body = SafeArea(
        child: SingleChildScrollView(
      child: isLandScape
          ? Column(
              // mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(
                  height: (mediaSize.height -
                          appBar.preferredSize.height -
                          media.padding.top) *
                      0.1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Show Chart",
                        style: Theme.of(context).textTheme.headline6,
                      ),

                      // Switch.adaptive(
                      //     value: showChart,
                      //     activeColor: Theme.of(context).colorScheme.secondary,
                      //     onChanged: (val) {
                      //       setState(() {
                      //         showChart = val;
                      //       });
                      //     }),

                      CupertinoSwitch(
                        activeColor: Theme.of(context).colorScheme.secondary,
                        value: showChart,
                        onChanged: (val) {
                          setState(() {
                            showChart = val;
                          });
                        },
                      )
                    ],
                  ),
                ),
                showChart
                    ? SizedBox(
                        height: (mediaSize.height -
                                appBar.preferredSize.height -
                                media.padding.top) *
                            0.7,
                        child: Chart(_recentTransactions))
                    : SizedBox(
                        height: (mediaSize.height -
                                appBar.preferredSize.height -
                                media.padding.top) *
                            0.65,
                        child: TransactionList(
                            _userTransactions, _deleteTransaction)),
              ],
            )
          : Column(
              // mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(
                    height: (mediaSize.height -
                            appBar.preferredSize.height -
                            media.padding.top) *
                        0.3,
                    child: Chart(_recentTransactions)),
                SizedBox(
                    height: (mediaSize.height -
                            appBar.preferredSize.height -
                            media.padding.top) *
                        0.7,
                    child:
                        TransactionList(_userTransactions, _deleteTransaction)),
              ],
            ),
    ));
    return !Platform.isIOS
        ? CupertinoPageScaffold(navigationBar: appBar, child: body)
        : Scaffold(
            appBar: appBar,
            body: body,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? null
                : FloatingActionButton(
                    child: const Icon(Icons.add),
                    onPressed: () => _startAddNewTransaction(context),
                  ),
          );
  }
}
