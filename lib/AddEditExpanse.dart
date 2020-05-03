import 'package:expenseslog/ExpensesModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class _AddEditExpenseState extends State<AddEditExpense> {
  double _price;
  int _index;
  bool _editMode;
  String _name;
  ExpensesModel _model;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  _AddEditExpenseState(this._model, this._index, this._editMode);

  @override
  Widget build(BuildContext context) {
    if (_editMode) {
      _name = _model.GetName(_index);
      _price = double.parse(_model.GetPrice(_index));
    } else {
      _name = '';
      _price = 0.0;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Добавить покупку"),
      ),
      body: Padding(
        padding: EdgeInsets.all(3.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                autovalidate: true,
                initialValue: _price.toString(),
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

                    if (_editMode) _model.EditExpense(int.parse(_model.GetKey(_index)), _name, _price);
                    else _model.AddExpense(_name, _price);

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

class AddEditExpense extends StatefulWidget {
  final ExpensesModel _model;
  final int _index;
  final bool _editMode;

  AddEditExpense(this._model, this._index, this._editMode);

  @override
  State<StatefulWidget> createState() => _AddEditExpenseState(_model, _index, _editMode);
}
