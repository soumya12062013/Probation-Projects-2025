import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 126, 217, 229),
      appBar: AppBar(
        title: const Text(
          "🏆 Leaderboard",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 27, 187, 209),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('quiz_results')
            .orderBy('score', descending: true)
            .limit(10) // top 10 users
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("No results yet. Be the first to play!"),
            );
          }

          final results = snapshot.data!.docs;

          return ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              final data = results[index].data() as Map<String, dynamic>;
              final username = data['username'] ?? 'Anonymous';
              final score = data['score'] ?? 0;
              final total = data['totalQuestions'] ?? 0;
              final date = data['date'] != null
                  ? DateFormat(
                      'dd MMM, hh:mm a',
                    ).format((data['date'] as Timestamp).toDate())
                  : '';

              return Card(
                color: Colors.white,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blueAccent,
                    child: Text(
                      "${index + 1}",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(
                    username,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  subtitle: Text("Score: $score / $total • $date"),
                  trailing: Icon(
                    index == 0
                        ? Icons.emoji_events_rounded
                        : Icons.star_outline_rounded,
                    color: index == 0 ? Colors.amber : Colors.grey,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
