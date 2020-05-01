import 'package:expenseslog/ExpensesModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class _EditExpenseState extends State<EditExpense> {
  double _price;
  int _index;
  String _name;
  ExpensesModel _model;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  _EditExpenseState(this._model, this._index);

  @override
  Widget build(BuildContext context) {
    _name = _model.GetName(_index);
    return Scaffold(
      appBar: AppBar(
        title: Text("Изменить покупку"),
      ),
      body: Padding(
        padding: EdgeInsets.all(3.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                autovalidate: true,
                initialValue: _model.GetPrice(_index),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (double.tryParse(value) != null) {
                    return null;
                  } else
                    return "ВВЕДИ НОРМАЛЬНУЮ ЦЕНУ!";
                },
                onSaved: (value) {
                  _price = double.parse(value);
                },
              ),
              TextFormField(
                initialValue: _name,
                onSaved: (value) {
                  _name = value;
                },

              ),
              RaisedButton(
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();

                    _model.EditExpense(int.parse(_model.GetKey(_index)), _name, _price);

                    Navigator.pop(context);
                  }
                },
                child: Text("Сохранить"),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class EditExpense extends StatefulWidget {
  final ExpensesModel _model;
  final int _index;

  EditExpense(this._model, this._index);

  @override
  State<StatefulWidget> createState() => _EditExpenseState(_model, _index);
}
