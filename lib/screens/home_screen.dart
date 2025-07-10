import 'dart:async';

import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int totalSeconds = 900; // 15분으로 표시되도록 900초 설정
  bool isRunning = false;
  Timer? timer;
  int selectedMinutes = 15;
  bool isRestMode = false; // 휴식 모드 여부
  int restSeconds = 300; // 5분
  int completedCycles = 0; // 완료된 사이클 수
  int currentCycle = 0; // 현재 사이클 (0부터 시작)
  int currentRound = 0; // 현재 라운드 (0부터 시작)
  bool isTestMode = true; // 테스트 모드 (true: 1초당 60초, false: 1초당 1초)

  void onTick(Timer timer) {
    setState(() {
      int decrementAmount = isTestMode ? 60 : 1; // 테스트 모드면 60초씩, 정상 모드면 1초씩

      if (isRestMode) {
        restSeconds = restSeconds - decrementAmount;
        if (restSeconds <= 0) {
          // 휴식 시간 종료 - 한 사이클 완료
          timer.cancel();
          completedCycles++; // 사이클 완료 카운트 증가

          // 사이클과 라운드 업데이트
          currentCycle = (completedCycles % 4); // 0, 1, 2, 3 반복
          currentRound = (completedCycles ~/ 4); // 4사이클마다 라운드 증가

          // 12사이클이 완료되면 멈춤, 아니면 다음 사이클 자동 시작
          if (completedCycles >= 12) {
            // 12사이클 완료 - 그 상태로 멈춤
            isRestMode = false;
            isRunning = false;
            restSeconds = 300;
          } else {
            // 다음 사이클 자동 시작
            isRestMode = false;
            isRunning = true;
            totalSeconds = selectedMinutes * 60;
            restSeconds = 300;
            // 다음 FOCUS 타이머 시작
            timer = Timer.periodic(
              const Duration(seconds: 1),
              onTick,
            );
          }
        }
      } else {
        totalSeconds = totalSeconds - decrementAmount;
        if (totalSeconds <= 0) {
          // FOCUS 시간 종료, REST 모드로 전환
          timer.cancel();
          isRestMode = true;
          isRunning = true;
          restSeconds = 300; // 5분 휴식시간 설정
          // REST 타이머 시작
          timer = Timer.periodic(
            const Duration(seconds: 1),
            onTick,
          );
        }
      }
    });
  }

  void onStartPressed() {
    if (isRunning) return; // 이미 실행 중이면 무시

    timer = Timer.periodic(
      const Duration(seconds: 1),
      onTick,
    );
    setState(() {
      isRunning = true;
    });
  }

  void onPausePressed() {
    if (!isRunning) return; // 이미 정지 중이면 무시

    timer?.cancel();
    setState(() {
      isRunning = false;
    });
  }

  void resetTimer() {
    if (timer != null) {
      timer?.cancel();
    }
    setState(() {
      isRunning = false;
      isRestMode = false;
      totalSeconds = selectedMinutes * 60; // 분 단위로 표시
      restSeconds = 300; // 5분
    });
  }

  void resetCycles() {
    setState(() {
      completedCycles = 0;
      currentCycle = 0;
      currentRound = 0;
    });
  }

  void setTime(int minutes) {
    timer?.cancel();
    setState(() {
      selectedMinutes = minutes;
      totalSeconds = minutes * 60; // 분 단위로 표시
      isRunning = false;
      isRestMode = false;
      restSeconds = 300; // 5분
    });
  }

  String formatTime(int seconds) {
    // 테스트용: 실제로는 초 단위지만 분:초 형태로 표시
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  String getCurrentTime() {
    return isRestMode ? formatTime(restSeconds) : formatTime(totalSeconds);
  }

  String getCurrentTitle() {
    return isRestMode ? "REST" : "FOCUS";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    radius: 24,
                  ),
                  Icon(Icons.add, color: Colors.white, size: 32),
                ],
              ),
              const SizedBox(height: 32),
              const Text(
                'MONDAY 16',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              const Row(
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
              const SizedBox(height: 28),
              // 첫 번째 카드: 현재 타이머 시간
              TimerCard(
                start: "00:00",
                end: "00:00",
                color: const Color(0xFFFF6B6B),
                title: getCurrentTitle(),
                members: const ["25:00"],
                isTimer: true,
                currentTime: getCurrentTime(),
                isRunning: isRunning,
                onStartPressed: onStartPressed,
                onPausePressed: onPausePressed,
                onResetPressed: resetTimer,
              ),
              const SizedBox(height: 16),
              // 두 번째 카드: 시간 설정
              TimeSettingCard(
                start: "SET",
                end: "TIME",
                color: const Color(0xFF4ECDC4),
                title: "TIME",
                members: const ["15", "20", "25", "30", "35", "45"],
                selectedMinutes: selectedMinutes,
                onTimeSelected: setTime,
              ),
              const SizedBox(height: 16),
              // 세 번째 카드: 응원 메시지
              MotivationCard(
                start: "YOU",
                end: "CAN",
                color: const Color(0xFFFFE66D),
                title: completedCycles >= 12
                    ? "WOW\nAMAZING!"
                    : (isRestMode ? "TAKE\nBREAK!" : "KEEP\nGOING!"),
                members: [
                  "CYCLE",
                  "$currentCycle/4",
                  "ROUND",
                  "$currentRound/3"
                ],
                motivationText: completedCycles >= 12
                    ? "You completed all cycles!"
                    : (isRestMode
                        ? "Drink coffee and relax!"
                        : "You're doing great!"),
                onResetCycles: resetCycles,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TimerCard extends StatelessWidget {
  final String start;
  final String end;
  final Color color;
  final String title;
  final List<String> members;
  final bool isTimer;
  final String currentTime;
  final bool isRunning;
  final VoidCallback? onStartPressed;
  final VoidCallback? onPausePressed;
  final VoidCallback? onResetPressed;

  const TimerCard({
    Key? key,
    required this.start,
    required this.end,
    required this.color,
    required this.title,
    required this.members,
    required this.isTimer,
    required this.currentTime,
    required this.isRunning,
    this.onStartPressed,
    this.onPausePressed,
    this.onResetPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 36,
              color: Colors.black,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.0,
              height: 1.0,
            ),
          ),
          const SizedBox(height: 28),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                currentTime,
                style: const TextStyle(
                  fontSize: 48,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    iconSize: 48,
                    color: Colors.black,
                    onPressed: isRunning ? onPausePressed : onStartPressed,
                    icon: Icon(isRunning
                        ? Icons.pause_circle_outlined
                        : Icons.play_circle_outline),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    iconSize: 32,
                    color: Colors.black,
                    onPressed: onResetPressed,
                    icon: const Icon(Icons.refresh),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}

class TimeSettingCard extends StatelessWidget {
  final String start;
  final String end;
  final Color color;
  final String title;
  final List<String> members;
  final int selectedMinutes;
  final Function(int)? onTimeSelected;

  const TimeSettingCard({
    Key? key,
    required this.start,
    required this.end,
    required this.color,
    required this.title,
    required this.members,
    required this.selectedMinutes,
    this.onTimeSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // 전체 너비 사용
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 36,
              color: Colors.black,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.0,
              height: 1.0,
            ),
          ),
          const SizedBox(height: 28),
          Wrap(
            spacing: 16,
            runSpacing: 12,
            children: members
                .map(
                  (m) => GestureDetector(
                    onTap: () => onTimeSelected?.call(int.parse(m)),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: selectedMinutes == int.parse(m)
                            ? Colors.black
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.black,
                          width: 2,
                        ),
                      ),
                      child: Text(
                        '${m}min',
                        style: TextStyle(
                          color: selectedMinutes == int.parse(m)
                              ? Colors.white
                              : Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          )
        ],
      ),
    );
  }
}

class MotivationCard extends StatelessWidget {
  final String start;
  final String end;
  final Color color;
  final String title;
  final List<String> members;
  final String motivationText;
  final VoidCallback? onResetCycles;

  const MotivationCard({
    Key? key,
    required this.start,
    required this.end,
    required this.color,
    required this.title,
    required this.members,
    required this.motivationText,
    this.onResetCycles,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 36,
              color: Colors.black,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.0,
              height: 1.0,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            motivationText,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.black,
              fontWeight: FontWeight.w500,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: members
                    .map(
                      (m) => Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: Text(
                          m,
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.6),
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
              if (onResetCycles != null)
                IconButton(
                  iconSize: 32,
                  color: Colors.black,
                  onPressed: onResetCycles,
                  icon: const Icon(Icons.refresh),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
