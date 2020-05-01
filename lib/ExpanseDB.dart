import 'dart:io';
import 'package:expenseslog/Expense.dart';
import 'package:path/path.dart' as Path;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class ExpanseDB {
  Database _database;

  Future<Database> get database async {
    if (_database == null) {
      _database = await initialize();
    }
    return _database;
  }

  ExpanseDB() {}

  initialize() async {
    Directory documentDir = await getApplicationDocumentsDirectory();
    var path = Path.join(documentDir.path, "db.db");
    return openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (db, version) async {
      await db.execute(
          "CREATE TABLE Expenses (id INTEGER PRIMARY KEY AUTOINCREMENT, price REAL, date TEXT, name TEXT)");
    });
  }

  Future<List> getAllExpenses() async {
    Database db = await database;
    List<Map> query =
        await db.rawQuery("SELECT * FROM Expenses ORDER BY id DESC");
    var data = List<Expense>();

    var total = 0.0;
    query.forEach((r) {
      data.add(Expense(r["id"], DateTime.parse(r["date"]), r["name"], r["price"]));
      total += double.tryParse(r["price"].toString());
    });

    return [data, total];
  }

  Future<List> getMonthExpenses(
      DateTime firstDate, DateTime lastDate) async {
    Database db = await database;
    List<Map> query = await db.rawQuery(
        "SELECT * FROM Expenses WHERE date >= \"$firstDate\" AND date < \"$lastDate\" ORDER BY id DESC");
    var data = List<Expense>();

    var total = 0.0;
    query.forEach((r) {
          data.add(Expense(r["id"], DateTime.parse(r["date"]), r["name"], r["price"]));
            total += double.tryParse(r["price"].toString());
        });

    return [data, total];
  }

  Future<void> addExpense(String name, double price, DateTime dateTime) async {
    Database db = await database;
    var dateAsString = dateTime.toString();
    await db.rawInsert(
        "INSERT INTO Expenses (name, date, price) VALUES (\"$name\", \"$dateAsString\", $price)");
  }

  Future<void> removeExpense(int id) async {
    Database db = await database;
    await db.rawDelete("DELETE FROM Expenses WHERE id = $id");
  }
}
