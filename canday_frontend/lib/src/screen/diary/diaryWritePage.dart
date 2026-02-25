import 'package:flutter/material.dart';

class Diarywritepage extends StatefulWidget {
  const Diarywritepage({super.key});

  @override
  State<Diarywritepage> createState() => _DiarywritepageState();
}

class _DiarywritepageState extends State<Diarywritepage> {
  late List<bool> isSelected;

  @override
  void initState() {
    isSelected = [true, false, false, false, false, false, false, false];
    super.initState();
  }

  void onPressed(int index) {
    print('inde: $index');
    setState(() {
      for (int i = 0; i < isSelected.length; i++) {
        isSelected[i] = i == index;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(bottom: 15),
            height: 350,
            margin: EdgeInsets.fromLTRB(17, 10, 10, 10),
            decoration: BoxDecoration(
                border: Border(
                    bottom:
                        BorderSide(color: Color.fromRGBO(122, 207, 76, 1)))),
            child: ListView(
              children: [
                TextFormField(
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: "일기를 작성해주세요.",
                    hintStyle: TextStyle(
                      fontFamily: "handWritten2",
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                ToggleButtons(
                  isSelected: isSelected,
                  onPressed: onPressed,
                  borderColor: Colors.transparent,
                  selectedBorderColor: Colors.transparent,
                  borderWidth: 0,
                  fillColor: Colors.transparent,
                  selectedColor: Colors.transparent,
                  color: Colors.transparent,
                  constraints: const BoxConstraints(
                    minWidth: 30,
                    minHeight: 30,
                  ),
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  children: List.generate(8, (index) {
                    final candies = [
                      'excitement',
                      'happy',
                      'calm',
                      'anxious',
                      'lonely',
                      'sad',
                      'annoying',
                      'anggro',
                    ];

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Image.asset(
                        'assets/${candies[index]}.png',
                        height: 28,
                        width: 28,
                        opacity: AlwaysStoppedAnimation(
                          isSelected[index] ? 1.0 : 0.4,
                        ),
                      ),
                    );
                  }),
                ),
                const Spacer(),
                Row(
                  children: [
                    IconButton(onPressed: () {}, icon: Icon(Icons.camera_alt)),
                    IconButton(onPressed: () {}, icon: Icon(Icons.insert_photo))
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget candyButton(String candy, int index) {
    return GestureDetector(
      onTap: () => onPressed(index),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        margin: EdgeInsets.symmetric(horizontal: 6),
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Image.asset(
            'assets/$candy.png',
            height: 28,
            width: 28,
            opacity: AlwaysStoppedAnimation(
              isSelected[index] ? 1.0 : 0.4,
            ),
          ),
        ),
      ),
    );
  }
}
