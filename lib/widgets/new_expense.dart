import 'package:expense_tracker/main.dart';
import 'package:expense_tracker/model/expense.dart';
import 'package:flutter/material.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddexpense});

  final void Function(Expense expense) onAddexpense;

  @override
  State<StatefulWidget> createState() {
    return _NewExpenseState();
  }
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountContoller = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.leisure;

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: now,
    );
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _submitExpenseData() {
    final enteredAmount = double.tryParse(_amountContoller.text);
    final amountIsInvaild = enteredAmount == null || enteredAmount <= 0;
    if (_titleController.text.trim().isEmpty ||
        amountIsInvaild ||
        _selectedDate == null) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: Colors.red,
          title: const Text("Invaild Input"),
          content: const Text(
            "Please make sure a vaild title, amount, date and category was entered",
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text("OK"),
            ),
          ],
          icon: const Icon(
            Icons.cancel_outlined,
            color: Colors.black,
          ),
        ),
      );
      return;
    }
    widget.onAddexpense(
      Expense(
        title: _titleController.text,
        amount: enteredAmount,
        date: _selectedDate!,
        category: _selectedCategory,
      ),
    );
    Navigator.pop(context);
    //  else {
    //   showDialog(
    //     context: context,
    //     builder: (ctx) => AlertDialog(
    //       backgroundColor: Colors.green,
    //       title: const Text("Data Saved"),
    //       content: const Text(
    //         "Your Expense Data Has Been Saved",
    //       ),
    //       actions: [
    //         ElevatedButton(
    //           onPressed: () {
    //             Navigator.pop(ctx);
    //           },
    //           child: const Text("Thanks"),
    //         ),
    //       ],
    //       icon: const Icon(
    //         Icons.check_box,
    //         color: Colors.black,
    //       ),
    //     ),
    //   );

    // }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountContoller.dispose();
    super.dispose();
  }
  // var _enteredTitle;

  // void _saveTitleInput(String inputValue) {
  //   _enteredTitle = inputValue;
  // }

  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    final keyboardspace = MediaQuery.of(context).viewInsets.bottom;

    return LayoutBuilder(builder: (ctx, constraints) {
      final width = constraints.maxWidth;
      return //Column(
          //   children: [
          // SizedBox(
          // height: 69,
          // child: AppBar(
          //   title: Padding(
          //     padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
          //     child: Center(
          //       child: Text(
          //         "Add New Expense",
          //         style: TextStyle(color: kColorScheme.secondaryContainer),
          //       ),
          //     ),
          //   ),
          //   automaticallyImplyLeading: false,
          //   backgroundColor: kColorScheme.secondary,
          //   iconTheme: IconThemeData(color: kColorScheme.onSecondary),
          // ),
          // ),
          SizedBox(
        height: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 25, 16, keyboardspace + 16),
            child: Column(
              children: [
                if (width >= 600)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextField(
                          style: TextStyle(
                            color: isDarkMode
                                ? kDarkColorScheme.onBackground
                                : kColorScheme.onBackground,
                          ),
                          controller: _titleController,
                          decoration: const InputDecoration(
                            label: Text("Pleaase enter title for your Expense"),
                          ),
                          maxLength: 50,
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: TextField(
                          style: TextStyle(
                            color: isDarkMode
                                ? kDarkColorScheme.onBackground
                                : kColorScheme.onBackground,
                          ),
                          controller: _amountContoller,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            prefixText: "₹",
                            label: Text("Expense Amount"),
                          ),
                          maxLength: 100,
                        ),
                      ),
                    ],
                  )
                else
                  TextField(
                    style: TextStyle(
                      color: isDarkMode
                          ? kDarkColorScheme.onBackground
                          : kColorScheme.onBackground,
                    ),
                    controller: _titleController,
                    decoration: const InputDecoration(
                      label: Text("Pleaase enter title for your Expense"),
                    ),
                    maxLength: 50,
                  ),
                if (width >= 600)
                  Row(
                    children: [
                      DropdownButton(
                        style: TextStyle(
                          color: isDarkMode
                              ? kDarkColorScheme.onBackground
                              : kColorScheme.onBackground,
                        ),
                        value: _selectedCategory,
                        items: Category.values
                            .map(
                              (category) => DropdownMenuItem(
                                value: category,
                                child: Text(
                                  category.name.toUpperCase(),
                                  style: TextStyle(
                                      color: kDarkColorScheme.secondary),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value == null) {
                            return;
                          }
                          setState(
                            () {
                              _selectedCategory = value;
                            },
                          );
                        },
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              _selectedDate == null
                                  ? "No date Selected"
                                  : formatter.format(_selectedDate!),
                              style: TextStyle(
                                color: isDarkMode
                                    ? kDarkColorScheme.onBackground
                                    : kColorScheme.onBackground,
                              ),
                            ),
                            IconButton(
                              onPressed: _presentDatePicker,
                              icon: const Icon(Icons.calendar_month),
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                else
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          style: TextStyle(
                            color: isDarkMode
                                ? kDarkColorScheme.onBackground
                                : kColorScheme.onBackground,
                          ),
                          controller: _amountContoller,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            prefixText: "₹",
                            label: Text("Expense Amount"),
                          ),
                          maxLength: 100,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              style: TextStyle(
                                color: isDarkMode
                                    ? kDarkColorScheme.onBackground
                                    : kColorScheme.onBackground,
                              ),
                              _selectedDate == null
                                  ? "No date Selected"
                                  : formatter.format(_selectedDate!),
                            ),
                            IconButton(
                              onPressed: _presentDatePicker,
                              icon: const Icon(Icons.calendar_month),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                const SizedBox(height: 16),
                if (width >= 600)
                  Row(
                    children: [
                      const Spacer(),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Cancel")),
                      ElevatedButton(
                        onPressed: _submitExpenseData,
                        child: const Text("Save Expense"),
                      )
                    ],
                  )
                else
                  Row(
                    children: [
                      DropdownButton(
                        style: TextStyle(
                          color: isDarkMode
                              ? kDarkColorScheme.onBackground
                              : kColorScheme.onBackground,
                        ),
                        value: _selectedCategory,
                        items: Category.values
                            .map(
                              (category) => DropdownMenuItem(
                                value: category,
                                child: Text(
                                  category.name.toUpperCase(),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value == null) {
                            return;
                          }
                          setState(
                            () {
                              _selectedCategory = value;
                            },
                          );
                        },
                      ),
                      const Spacer(),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Cancel")),
                      ElevatedButton(
                        onPressed: _submitExpenseData,
                        child: const Text("Save Expense"),
                      )
                    ],
                  ),

                // const SizedBox(height: 10),
                // Row(
                //   children: [
                //     ElevatedButton(
                //       onPressed: () {
                //         Navigator.pop(context);
                //       },
                //       child: const Text("Cancel"),
                //     ),
                //     const SizedBox(width: 10),
                //     ElevatedButton(
                //       onPressed: _submitExpenseData,
                //       child: const Text("Save Expense"),
                //     )
                //   ],
                // )
              ],
            ),
          ),
        ),
      );
    });

    //   ],
    // );
  }
}
