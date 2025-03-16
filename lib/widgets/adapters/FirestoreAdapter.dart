import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/model/expense.dart';

class FirestoreAdapter {
  Future<List<Expense>> getExpensesFromFirestore() async {
    try {
      final querySnapshot =
          await FirebaseFirestore.instance.collection('expenses').get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();

        return Expense(
          id: data['id'],
          title: data['title'] as String,
          amount: (data['amount'] as num).toDouble(),
          date: (data['date'] as Timestamp).toDate(),
          // Zamieniam string z Firestore np. "FOOD" na Twój enum Category.
          category: Category.values.firstWhere(
            (c) => c.name == data['category'],
            orElse: () => Category.LEISURE, // fallback, jeśli nic nie pasuje
          ),
        );
      }).toList();
    } catch (error) {
      print('Błąd pobierania wydatków: $error');
      return [];
    }
  }

  Future<void> removeExpenseFromFirestore(Expense expense) async {
    print('removing expense with id ${expense.id}');
    try {
      // Możesz nazwać kolekcję jak chcesz, tutaj "expenses":
      await FirebaseFirestore.instance
          .collection('expenses')
          .doc(expense.id) // używam Twojego `expense.id` z Uuid
          .delete();
    } catch (error) {
      // obsługa błędu (log, pokazanie komunikatu, itp.)
      print('Błąd zapisu do Firestore: $error');
    }
  }

   Future<void> addExpenseToFirestore(Expense expense) async {
    try {
      // Możesz nazwać kolekcję jak chcesz, tutaj "expenses":
      await FirebaseFirestore.instance
          .collection('expenses')
          .doc(expense.id) // używam Twojego `expense.id` z Uuid
          .set({
        'id': expense.id,
        'title': expense.title,
        'amount': expense.amount,
        'date': expense.date, // Firestore samo zamieni DateTime na Timestamp
        'category': expense.category.name, // przechowuj np. jako string
      });
    } catch (error) {
      // obsługa błędu (log, pokazanie komunikatu, itp.)
      print('Błąd zapisu do Firestore: $error');
    }
  }

}