import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTx;

  const TransactionList(this.transactions, this.deleteTx, {super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          child: transactions.isEmpty
              ? Column(
                  children: <Widget>[
                    Text(
                      'No transactions added yet!',
                      style: Theme.of(context).textTheme.headline3,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                        height: constraints.maxHeight * 0.6,
                        child: Image.asset(
                          'assets/images/waiting.png',
                          fit: BoxFit.cover,
                        )),
                  ],
                )
              : ListView.builder(
                  itemBuilder: (ctx, index) {
                    return Card(
                      elevation: 5,
                      margin: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 5,
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 30,
                          child: Padding(
                            padding: const EdgeInsets.all(6),
                            child: FittedBox(
                              child: Text('\$${transactions[index].amount}'),
                            ),
                          ),
                        ),
                        title: Text(
                          transactions[index].title,
                          style: Theme.of(context).textTheme.headline3,
                        ),
                        subtitle: Text(
                          DateFormat.yMMMd().format(transactions[index].date),
                        ),
                        trailing: MediaQuery.of(context).size.width > 360
                            ? TextButton.icon(
                                style: ButtonStyle(
                                    textStyle: MaterialStateProperty.all(
                                        const TextStyle(color: Colors.red)),
                                    foregroundColor:
                                        MaterialStateProperty.all(Colors.red)),
                                onPressed: () {
                                  deleteTx(transactions[index].id);
                                },
                                icon: const Icon(Icons.delete),
                                label: const Text("delete"))
                            : IconButton(
                                icon: const Icon(Icons.delete),
                                color: Theme.of(context).errorColor,
                                onPressed: () =>
                                    deleteTx(transactions[index].id),
                              ),
                      ),
                    );
                  },
                  itemCount: transactions.length,
                ),
        );
      },
    );
  }
}
