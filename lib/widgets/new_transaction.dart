import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addTx;
  NewTransaction({Key? key, required this.addTx}) : super(key: key);

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleInputController = TextEditingController();
  final _amountInputController = TextEditingController();
  DateTime? _selectedDate;
  void _addTransaction() {
    if (_amountInputController.text.isEmpty) {
      return;
    }
    final enteredTitle = _titleInputController.text;
    final enteredAmount = double.parse(_amountInputController.text);
    if (enteredTitle.isEmpty || enteredAmount <= 0 || _selectedDate == null) {
      return;
    }
    widget.addTx(enteredTitle, enteredAmount, _selectedDate);
    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final curScaleFactor = MediaQuery.of(context).textScaleFactor;
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
            top: 10,
            right: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
            left: 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Title',
                ),
                controller: _titleInputController,
                onSubmitted: (_) => _addTransaction(),
              ),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Amount',
                ),
                controller: _amountInputController,
                onSubmitted: (_) => _addTransaction(),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _selectedDate == null
                        ? 'No Data Chosen!'
                        : 'Picked Date ${DateFormat.yMd().format(_selectedDate!)}',
                    style: TextStyle(fontSize: 16 * curScaleFactor),
                  ),
                  TextButton(
                    onPressed: _presentDatePicker,
                    child: Text(
                      'Choose Date',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16 * curScaleFactor),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: _addTransaction,
                child: const Text('Add Transaction'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
