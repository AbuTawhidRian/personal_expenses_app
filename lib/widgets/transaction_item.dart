import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class TransactionItem extends StatelessWidget {
  const TransactionItem({
    Key? key,
    required this.transaction,
    required this.deleteTransaction,
  }) : super(key: key);

  final Transaction transaction;
  final Function deleteTransaction;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: FittedBox(
              child: Text(
                '\$${transaction.amount.toStringAsFixed(2)}',
              ),
            ),
          ),
        ),
        title: Text(
          transaction.title,
          style: Theme.of(context).textTheme.headline6,
        ),
        subtitle: Text(
          DateFormat('dd-MM-yyyy').format(transaction.date),
          style: const TextStyle(
            color: Colors.grey,
          ),
        ),
        trailing: MediaQuery.of(context).size.width > 460
            ? ElevatedButton.icon(
                onPressed: () {
                  deleteTransaction(transaction.id);
                },
                icon: const Icon(
                  Icons.delete,
                  size: 30,
                  color: Colors.white,
                ),
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateColor.resolveWith((states) => Colors.red)),
                label: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.white),
                ),
              )
            : IconButton(
                onPressed: () {
                  deleteTransaction(transaction.id);
                },
                icon: const Icon(
                  Icons.delete,
                  size: 30,
                  color: Colors.red,
                ),
              ),
      ),
    );
  }
}
