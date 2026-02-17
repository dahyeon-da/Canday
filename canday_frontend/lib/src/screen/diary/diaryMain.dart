import 'package:canday_frontend/src/controller/diaryController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Diarymain extends StatefulWidget {
  final int userNum;

  const Diarymain({super.key, required this.userNum});

  @override
  State<Diarymain> createState() => _DiarymainState();
}

class _DiarymainState extends State<Diarymain> {
  bool isLoading = true;
  late Map<String, dynamic> results = {};

  DateTime _focusedMonth = DateTime.now();
  DateTime? _selectedDate;

  // 일기 작성한 날짜 표시
  final Map<DateTime, Color> eventDates = {
    DateTime(2026, 2, 11): Colors.green,
    DateTime(2026, 4, 17): Colors.green,
    DateTime(2026, 4, 19): Colors.yellow,
    DateTime(2026, 4, 20): Colors.yellow,
  };

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });

    final diaryController = Get.put(DiaryController());
    results = await diaryController.diaryShow(widget.userNum);
    print(results);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(122, 207, 76, 1),
        actions: [
          Icon(
            Icons.person,
            color: Colors.white,
          )
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: ListView(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(20, 40, 20, 20),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 12)
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHeader(),
                const SizedBox(height: 20),
                _buildWeekDays(),
                const SizedBox(height: 10),
                _buildCalendar(),
              ],
            ),
          ),
          _todayDiary(),
        ],
      ),
    );
  }

  /// 월 이동 헤더
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.green),
          onPressed: () {
            setState(() {
              _focusedMonth =
                  DateTime(_focusedMonth.year, _focusedMonth.month - 1);
            });
          },
        ),
        Text(
          DateFormat('MMMM yyyy').format(_focusedMonth),
          style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.green,
              fontFamily: 'normalFont1'),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right, color: Colors.green),
          onPressed: () {
            setState(() {
              _focusedMonth =
                  DateTime(_focusedMonth.year, _focusedMonth.month + 1);
            });
          },
        ),
      ],
    );
  }

  /// 요일
  Widget _buildWeekDays() {
    const days = ["S", "M", "T", "W", "T", "F", "S"];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(days.length, (index) {
        Color color = Colors.black;
        if (index == 0) color = Colors.red;
        if (index == 6) color = const Color.fromARGB(255, 49, 69, 219);

        return Text(
          days[index],
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
              fontFamily: 'normalFont1'),
        );
      }),
    );
  }

  /// 달력 본문
  Widget _buildCalendar() {
    final firstDayOfMonth =
        DateTime(_focusedMonth.year, _focusedMonth.month, 1);

    final lastDayOfMonth =
        DateTime(_focusedMonth.year, _focusedMonth.month + 1, 0);

    final daysInMonth = lastDayOfMonth.day;
    final startingWeekday = firstDayOfMonth.weekday % 7;

    List<Widget> dayWidgets = [];

    // 빈칸
    for (int i = 0; i < startingWeekday; i++) {
      dayWidgets.add(const SizedBox());
    }

    // 날짜
    for (int day = 1; day <= daysInMonth; day++) {
      final currentDate =
          DateTime(_focusedMonth.year, _focusedMonth.month, day);

      dayWidgets.add(_buildDay(currentDate));
    }

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 7,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      children: dayWidgets,
    );
  }

  Widget _buildDay(DateTime date) {
    final isToday = _isSameDate(date, DateTime.now());
    final isSelected = _isSameDate(date, _selectedDate);

    final eventColor = eventDates.keys.any((d) => _isSameDate(d, date))
        ? eventDates[eventDates.keys.firstWhere((d) => _isSameDate(d, date))]
        : null;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedDate = date;
        });
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (eventColor != null)
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: eventColor.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
            ),
          if (isSelected)
            Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                border: Border.fromBorderSide(
                  BorderSide(color: Colors.green, width: 2),
                ),
              ),
            ),
          Text(
            "${date.day}",
            style: TextStyle(
              fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
              color: isToday ? Colors.green : Colors.black,
              fontFamily: 'normalFont1',
            ),
          ),
        ],
      ),
    );
  }

  bool _isSameDate(DateTime? a, DateTime? b) {
    if (a == null || b == null) return false;
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Widget _todayDiary() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Color.fromRGBO(122, 207, 76, 1),
        ),
      ),
      margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text("오늘의 ",
                        style: TextStyle(
                            color: Color.fromRGBO(93, 93, 93, 1),
                            fontSize: 20,
                            fontFamily: 'handWritten2',
                            fontWeight: FontWeight.bold)),
                    Text(
                      "기쁨",
                      style: TextStyle(
                          color: Color.fromRGBO(122, 207, 76, 1),
                          fontSize: 20,
                          fontFamily: 'handWritten2',
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "사탕",
                      style: TextStyle(
                          color: Color.fromRGBO(93, 93, 93, 1),
                          fontSize: 20,
                          fontFamily: 'handWritten2',
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                IconButton(
                  onPressed: () {},
                  icon: Image.asset('assets/edit-tools.png',
                      width: 22, height: 22),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
                border: Border.all(color: Color.fromRGBO(122, 207, 76, 1))),
          ),
          Container(
            margin: EdgeInsets.all(13),
            child: Text(
              "오늘은 이천에 일을 갔다~ 일이 엄청 힘들었다~ 이렇게 저렇게 이렇게 저렇게 이렇게 저렇게 이렇게 저렇게 이렇게 저렇게 이렇게 저렇게 이렇게 저렇게 이렇게 저렇게이렇게 저렇게이렇게 저렇게이렇게 저렇게이렇게 저렇게",
              style: TextStyle(
                  color: Color.fromRGBO(93, 93, 93, 1),
                  fontSize: 17,
                  fontFamily: 'handWritten2',
                  fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
}
