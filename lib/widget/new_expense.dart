import 'package:flutter/material.dart';
import 'package:expense_tracker/models/expense.dart';


class NewExpense extends StatefulWidget {
  const NewExpense({super.key,required this.onAddExpense});

  final void Function(Expense expense) onAddExpense;

  @override
  State<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {

    var _titleController=TextEditingController();
    var _amountController=TextEditingController();
    DateTime? _selectedDate;
    Category _selectedCategory=Category.liesur;
    @override
  void dispose() {
     _titleController.dispose();
     _amountController.dispose();
    super.dispose();
  }

   void _presentDatePicker() async{
      final now=DateTime.now();
      final firstDate=DateTime(now.year-1,now.month,now.day);
      // final lastDate=DateTime.now();
      final pickedDate=await showDatePicker(
          context: context,
          initialDate: now,
          firstDate: firstDate,
          lastDate: now
      );
      setState(() {
        _selectedDate=pickedDate;
      });
   }
   void _submitExpenseData(){
      final enteredAmount=double.tryParse(_amountController.text);
      final amountIsInvalid= enteredAmount==null || enteredAmount<=0;
      if(_titleController.text.trim().isEmpty || amountIsInvalid || _selectedDate==null){
          showDialog(
              context: context,
              builder: (ctx)=>AlertDialog(
                title: Text('Invalid Input'),
                content: Text('Please make sure valid title,amount,value,date and category is entered!'),
                actions: [
                  TextButton(
                      onPressed: (){
                        Navigator.pop(ctx);
                      },
                      child: Text('Okey'),
                  ),
                ],
              )
          );
          return;
      }
      widget.onAddExpense(
        Expense(
            title: _titleController.text,
            amount: enteredAmount,
            date: _selectedDate!,
            category: _selectedCategory)
      );
      Navigator.pop(context);
   }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.fromLTRB(16, 48, 16, 16),
      child: Column(
        children: [
          TextField(
            controller: _titleController,
            maxLength: 50,
            decoration: InputDecoration(
              label: Text('Title'),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    prefixText: '\$ ',
                    label: Text('Amount'),
                  ),
                ),
              ),
              SizedBox(width: 16,),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(_selectedDate==null ? 'No Date Selected': formatter.format(_selectedDate!)),
                    IconButton(
                        onPressed:_presentDatePicker,
                        icon: Icon(Icons.calendar_month),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16,),
          Row(
            children: [
              DropdownButton(
                value: _selectedCategory,
                  items: Category.values
                      .map(
                          (category) =>DropdownMenuItem(
                              value: category,
                              child: Text(
                                category.name.toUpperCase(),
                              )
                          ),
                  ).toList(),
                  onChanged: (value){
                    if(value==null){
                      return;
                    }

                    setState(() {
                      _selectedCategory=value;
                    });
                  },
              ),
              const Spacer(),
              TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: _submitExpenseData,
                child: Text('Save Expense'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
