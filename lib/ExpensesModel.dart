import 'package:expenseslog/ExpanseDB.dart';
import 'package:expenseslog/Expense.dart';
import 'package:scoped_model/scoped_model.dart';

class ExpensesModel extends Model {

  List<Expense> _items = [
    Expense(1, DateTime.now(), "Car", 1000),
    Expense(2, DateTime.now(), "Food", 645),
    Expense(3, DateTime.now(), "Stuff", 788),
  ];

  double _total = 0.0;
  ExpanseDB _database;

  int get recordsCount => _items.length;

  ExpensesModel() {
    _database = ExpanseDB();
    Load();
  }

  void Load([bool part, DateTime fDate, DateTime lDate]) {
    if (part == true) {
      if (fDate == null || lDate == null) {
        throw new Exception("You don't take date...");
      }
      Future<List> future;
      future = _database.getMonthExpenses(fDate, lDate);
      future.then((list) {
        _items = list[0];
        _total = list[1];
        notifyListeners();
      });
    } else {
      Future<List> future;
      future = _database.getAllExpenses();
      future.then((list) {
        _items = list[0];
        _total = list[1];
        notifyListeners();
      });
    }
  }

  String GetKey(int index) {
    return _items[index].id.toString();
  }

  String GetText(int index) {
    var e = _items[index];
    return e.name + " for " + e.price.toString() + "\n" + e.date.toString();
  }

  String GetTotalCost() {
    return "Total costs: " + _total.toString();
  }

  void RemoveAt(int index, int id) {
    Future<void> future = _database.removeExpense(id);
    future.then((_) {
      _items.removeAt(index);
      notifyListeners();
    });
  }

  Future<void> AddExpense(String name, double price) {
    Future<void> future = _database.addExpense(name, price, DateTime.now());
    future.then((_) {
      Load();
    });
  }
}
