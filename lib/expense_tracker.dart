import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'expense_model.dart';
import 'package:intl/intl.dart';

class expenseTracker extends StatefulWidget {
  const expenseTracker({super.key});

  @override
  State<expenseTracker> createState() => _expenseTrackerState();
}

class _expenseTrackerState extends State<expenseTracker> {
  final List<String> categories = [
    "Food",
    "Transport",
    "Fees",
    "Bills",
    "Others"
  ];
  final List<Expense> _expense = [];

  double total = 0.0;
  double budget = 0.0;

  void _showForm(BuildContext context) {
    String selectedCategory = categories.first;
    TextEditingController textController = TextEditingController();
    TextEditingController amountController = TextEditingController();
    DateTime expenseDate = DateTime.now();

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: textController,
                decoration: InputDecoration(labelText: "Title"),
              ),
              SizedBox(height: 10),
              TextField(
                controller: amountController,
                keyboardType:
                TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(labelText: "Amount"),
              ),
              SizedBox(height: 10),
              DropdownButtonFormField(
                hint: Text("Select any category.."),
                items: categories
                    .map((category) => DropdownMenuItem(
                  value: category,
                  child: Text(category),
                ))
                    .toList(),
                onChanged: (value) => selectedCategory = value!,
              ),
              SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (textController.text.isNotEmpty &&
                        amountController.text.isNotEmpty &&
                        selectedCategory.isNotEmpty) {
                      _adExpense(textController.text,
                          double.parse(amountController.text), expenseDate, selectedCategory);
                    }
                  },
                  child: Text("Add Expense"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  void _showBudgetForm(BuildContext context) {
    TextEditingController textController = TextEditingController();
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: textController,
                keyboardType:
                TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(labelText: "Budget Amount"),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      budget = double.tryParse(textController.text) ?? 0.0;
                    });
                    Navigator.pop(context);
                  },
                  child: Text("Add Budget"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  void _adExpense(String title, double amount, DateTime date, String category) {
    setState(() {
      _expense.add(
          Expense(title: title, amount: amount, date: date, category: category));
      total += amount;
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    double remaining = budget - total;
    double progress = budget > 0 ? (total / budget).clamp(0.0, 1.0) : 0.0;
    return Scaffold(
      appBar: AppBar(
        title: Text("Expense Tracker"),
        backgroundColor: Colors.blueAccent,
        centerTitle: false,
        actions: [
          IconButton(onPressed: () => _showBudgetForm(context), icon: Icon(Icons.wallet))
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: 150,
                        width: 150,
                        child: CircularProgressIndicator(
                          value: 1,
                          backgroundColor: Colors.grey.shade300,
                          color: Colors.green,
                          strokeWidth: 10,
                        ),
                      ),
                      Container(
                        height: 150,
                        width: 150,
                        child: CircularProgressIndicator(
                          value: progress,
                          backgroundColor: Colors.transparent,
                          color: Colors.red,
                          strokeWidth: 10,
                        ),
                      ),
                      Center(
                        child: Text(
                          "Remaining:\n৳ ${remaining.toStringAsFixed(2)}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Card(
                        elevation: 5,
                        color: Colors.green.shade400,
                        shadowColor: Colors.grey,
                        margin: EdgeInsets.all(10),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            "Budget: ৳${budget.toStringAsFixed(2)}",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Card(
                        elevation: 5,
                        color: Colors.red.shade300,
                        shadowColor: Colors.grey,
                        margin: EdgeInsets.all(10),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            "Expenses: ৳${total.toStringAsFixed(2)}",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _expense.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.red,
                        child: Icon(
                          Icons.remove,
                          color: Colors.white,
                        ),
                      ),
                      title: Text(_expense[index].title),
                      subtitle: Text(DateFormat.yMMMd().format(_expense[index].date)),
                      trailing: Text(
                        "৳${_expense[index].amount.toStringAsFixed(2)}",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(context),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
      ),
    );
  }
}