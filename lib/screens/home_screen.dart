import 'package:flutter/material.dart';
import 'detail_screen.dart';
import '../services/storage_service.dart';
import '../services/api_service.dart';
import 'settings_screen.dart';
import '../services/notification_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = true;

  String quote = "";
  bool isQuoteLoading = true;

  List<String> habits = [];

  bool notificationTriggered = false; // 🔥 NEW

  TextEditingController habitController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadHabits();
    loadQuote();
  }

  void loadHabits() async {
    try {
      List<String> loadedHabits = await StorageService.loadHabits();

      setState(() {
        habits = loadedHabits;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void loadQuote() async {
    try {
      String fetchedQuote = await ApiService.fetchQuote();

      setState(() {
        quote = fetchedQuote.isNotEmpty
            ? fetchedQuote
            : "No quote available";
        isQuoteLoading = false;
      });
    } catch (e) {
      setState(() {
        quote = "Failed to load quote";
        isQuoteLoading = false;
      });
    }
  }

  void addHabit() async {
    String habit = habitController.text.trim();

    if (habit.isEmpty) return;

    setState(() {
      habits.add(habit);
    });

    await StorageService.saveHabits(habits);

    habitController.clear();
    Navigator.pop(context);
  }

  void showAddDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Add Habit"),
        content: TextField(
          controller: habitController,
          decoration: InputDecoration(hintText: "Enter habit"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: addHabit,
            child: Text("Add"),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    habitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.track_changes),
            SizedBox(width: 10),
            Text("Habit Tracker"),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == "settings") {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => SettingsScreen()),
                );
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: "settings",
                child: Text("Settings"),
              ),
            ],
          )
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: showAddDialog,
        child: Icon(Icons.add),
      ),

      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [

          // 🔥 API QUOTE
          Container(
            padding: EdgeInsets.all(10),
            child: isQuoteLoading
                ? CircularProgressIndicator()
                : Text(
              "Quote: $quote",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ),

          SizedBox(height: 10),

          // 🔔 NOTIFICATION BUTTON
          ElevatedButton(
            onPressed: () {
              NotificationService.showNotification();

              // 🔥 UI workaround trigger
              setState(() {
                notificationTriggered = true;
              });
            },
            child: Text("Test Notification"),
          ),

          SizedBox(height: 10),

          // 🔥 FAKE NOTIFICATION DISPLAY (FOR SCREENSHOT)
          if (notificationTriggered)
            Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Text(
                    "Habit Reminder",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 5),
                  Text("Time to complete your habits!"),
                ],
              ),
            ),

          // 📋 HABIT LIST
          Expanded(
            child: habits.isEmpty
                ? Center(child: Text("No habits added"))
                : ListView.builder(
              itemCount: habits.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(habits[index]),
                  trailing: Icon(Icons.arrow_forward),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            DetailScreen(habit: habits[index]),
                      ),
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}