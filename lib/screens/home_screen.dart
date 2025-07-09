import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    radius: 24,
                  ),
                  Icon(Icons.add, color: Colors.white, size: 32),
                ],
              ),
              SizedBox(height: 32),
              Text(
                'MONDAY 16',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    'TODAY',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.circle, color: Colors.pinkAccent, size: 8),
                  SizedBox(width: 8),
                  Text('17',
                      style: TextStyle(color: Colors.white54, fontSize: 24)),
                  SizedBox(width: 8),
                  Text('18',
                      style: TextStyle(color: Colors.white54, fontSize: 24)),
                  SizedBox(width: 8),
                  Text('19',
                      style: TextStyle(color: Colors.white54, fontSize: 24)),
                  SizedBox(width: 8),
                  Text('20',
                      style: TextStyle(color: Colors.white54, fontSize: 24)),
                  SizedBox(width: 8),
                  Text('21',
                      style: TextStyle(color: Colors.white54, fontSize: 24)),
                ],
              ),
              SizedBox(height: 28),
              ScheduleCard(
                start: "11:30",
                end: "12:20",
                color: Color(0xFFFFFF57),
                title: "DESIGN\nMEETING",
                members: ["ALEX", "HELENA", "NANA"],
              ),
              SizedBox(height: 16),
              ScheduleCard(
                start: "12:35",
                end: "14:10",
                color: Color(0xFFB983FF),
                title: "DAILY\nPROJECT",
                members: ["ME", "RICHARD", "CIRY", "+4"],
              ),
              SizedBox(height: 16),
              ScheduleCard(
                start: "15:00",
                end: "16:30",
                color: Color(0xFFB5FF57),
                title: "WEEKLY\nPLANNING",
                members: ["DEN", "NANA", "MARK"],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ScheduleCard extends StatelessWidget {
  final String start;
  final String end;
  final Color color;
  final String title;
  final List<String> members;

  const ScheduleCard({
    Key? key,
    required this.start,
    required this.end,
    required this.color,
    required this.title,
    required this.members,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 시작 시간
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    start.split(':')[0],
                    style: const TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    start.split(':')[1],
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Container(
                width: 20,
                height: 32,
                alignment: Alignment.center,
                child: Container(
                  width: 2,
                  height: 24,
                  color: Colors.black38,
                ),
              ),
              // 종료 시간
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    end.split(':')[0],
                    style: const TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    end.split(':')[1],
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 48,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.0,
                    height: 1.0,
                  ),
                ),
                const SizedBox(height: 28),
                Row(
                  children: members
                      .map(
                        (m) => Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: Text(
                            m,
                            style: TextStyle(
                              color: Colors.black.withOpacity(0.45),
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
