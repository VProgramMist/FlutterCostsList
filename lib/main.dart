import 'package:expenseslog/AddExpanse.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRangePicker;
import 'package:expenseslog/ExpensesModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return ScopedModel<ExpensesModel>(
      model: ExpensesModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: ScopedModelDescendant<ExpensesModel>(
          builder: (context, child, model) => ListView.separated(
              itemBuilder: (context, index) {
                if (index == 0) {
                  return ListTile(
                    title: Text(model.GetTotalCost()),
                    trailing: PopupMenuButton(
                      itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                        const PopupMenuItem(
                          value: 0,
                          child: Text('Costs for the period'),
                        ),
                        const PopupMenuItem(
                          value: 1,
                          child: Text('Reset selection'),
                        ),
                      ],
                      onSelected: (res) async {
                        if (res == 0) {
                          var nowDate = new DateTime.now();
                          final List<DateTime> picked =
                          await DateRangePicker.showDatePicker(
                              context: context,
                              initialFirstDate: new DateTime(
                                  nowDate.year, nowDate.month, nowDate.day),
                              initialLastDate: new DateTime(
                                  nowDate.year, nowDate.month + 1, 1)
                                  .subtract(new Duration(days: 1)),
                              firstDate: new DateTime(2019),
                              lastDate: new DateTime(2030));
                          if (picked != null) {
                            if (picked.length == 2)
                              model.Load(
                                  true,
                                  new DateTime(picked[0].year, picked[0].month,
                                      picked[0].day),
                                  new DateTime(picked[1].year, picked[1].month,
                                      picked[1].day)
                                      .add(Duration(days: 1)));
                            else
                              model.Load(
                                  true,
                                  new DateTime(picked[0].year, picked[0].month,
                                      picked[0].day),
                                  new DateTime(picked[0].year, picked[0].month,
                                      picked[0].day)
                                      .add(Duration(days: 1)));
                          }
                        } else {
                          model.Load();
                        }
                      },
                    ),
                  );
                } else {
                  index -= 1;
                  return Dismissible(
                    key: Key(model.GetKey(index)),
                    confirmDismiss: (DismissDirection direction) async {
                      return await showDialog(
                        context: context,
                        builder: (BuildContext dismissContext) {
                          return AlertDialog(
                            title: const Text("Confirm"),
                            content: const Text(
                                "Are you sure you wish to delete this item?"),
                            actions: <Widget>[
                              FlatButton(
                                onPressed: () =>
                                    Navigator.of(dismissContext).pop(false),
                                child: const Text("CANCEL"),
                              ),
                              FlatButton(
                                  onPressed: () {
                                    model.RemoveAt(
                                        index, int.parse(model.GetKey(index)));
                                    Navigator.of(dismissContext).pop();
                                    Scaffold.of(context).showSnackBar(SnackBar(
                                      content: Text("Deleted record $index"),
                                    ));
                                  },
                                  child: const Text("DELETE")),
                            ],
                          );
                        },
                      );
                    },
                    child: ListTile(
                      title: Text(model.GetText(index)),
                      leading: Icon(Icons.attach_money),
                      trailing: Icon(Icons.delete),
                    ),
                  );
                }
              },
              separatorBuilder: (context, index) => Divider(),
              itemCount: model.recordsCount + 1),
        ),
        floatingActionButton: ScopedModelDescendant<ExpensesModel>(
          builder: (context, child, model) => FloatingActionButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return AddExpense(model);
              }));
            },
            child: Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}