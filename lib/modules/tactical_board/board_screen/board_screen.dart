import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:football_platform/models/items/items.dart';
import 'package:football_platform/modules/tactical_board/board_screen/draggable_icon.dart';
import 'package:football_platform/modules/tactical_board/board_screen/painter.dart';

class Board extends StatefulWidget {
  const Board({super.key});

  @override
  State<Board> createState() => _BoardState();
}

class _BoardState extends State<Board> {
  late bool canPaint;

   int count=0;

  @override
  void initState() {
    super.initState();
    canPaint = false;
  }

  void reset() {
    setState(() {
      count=0;
    });
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const Board(),
      ),
    );
  }
  List<MenuItem> shapes =
  [
    ftt,
    fft,
    tft,
    offside,
    freeKick,
    cornerKick,
  ];
  static const ftt = MenuItem(text: '4-3-3', );
  static const cornerKick =MenuItem(text: 'Corner Kick',);
  static const offside =MenuItem(text: 'Off Side', );
  static const freeKick =MenuItem(text: 'Free Kick', );
  static const fft =MenuItem(text: '4-4-2', );
  static const tft =MenuItem(text: '3-5-2', );



  List<Image> shape=
  [
    Image.asset('assets/images/field.jpg'),
    Image.asset('assets/images/shape/4-3-3.jpg'),
    Image.asset('assets/images/shape/4-4-2.jpg'),
    Image.asset('assets/images/shape/3-5-2.jpg'),
    Image.asset('assets/images/shape/offside.jpg'),
    Image.asset('assets/images/shape/freeKick.jpg'),
    Image.asset('assets/images/shape/cornerKick.jpg'),

  ];
  List<String>title=
  [
    'Choose',
    '4-3-3',
    '4-4-2',
    '3-5-2',
    'Off Side',
    'Free Kick',
    'Corner Kick',
  ];
  void onChange(BuildContext context, MenuItem item){
    switch(item) {
      case ftt:
        setState(() {
          count=1;
        });
      case fft:
        setState(() {
          count=2;
        });
      case tft:
        setState(() {
          count=3;
        });
      case offside:
        setState(() {
          count=4;
        });
      case freeKick:
        setState(() {
          count=5;
        });
      case cornerKick:
        setState(() {
          count=6;
        });

    }

  }
  @override
  Widget build(BuildContext context) {
    List<Image> iconsRed = [
      Image.asset(scale: 8.0, 'assets/images/red1.png'),
      Image.asset(scale: 8.0, 'assets/images/red2.png'),
      Image.asset(scale: 8.0, 'assets/images/red3.png'),
      Image.asset(scale: 8.0, 'assets/images/red4.png'),
      Image.asset(scale: 8.0, 'assets/images/red5.png'),
      Image.asset(scale: 8.0, 'assets/images/red6.png'),
      Image.asset(scale: 8.0, 'assets/images/red7.png'),
      Image.asset(scale: 8.0, 'assets/images/red8.png'),
      Image.asset(scale: 8.0, 'assets/images/red9.png'),
      Image.asset(scale: 8.0, 'assets/images/red10.png'),
      Image.asset(scale: 8.0, 'assets/images/red11.png'),
    ];
    List<Image> iconsBlue = [
      Image.asset(scale: 8.0, 'assets/images/blue1.png'),
      Image.asset(scale: 8.0, 'assets/images/blue2.png'),
      Image.asset(scale: 8.0, 'assets/images/blue3.png'),
      Image.asset(scale: 8.0, 'assets/images/blue4.png'),
      Image.asset(scale: 8.0, 'assets/images/blue5.png'),
      Image.asset(scale: 8.0, 'assets/images/blue6.png'),
      Image.asset(scale: 8.0, 'assets/images/blue7.png'),
      Image.asset(scale: 8.0, 'assets/images/blue8.png'),
      Image.asset(scale: 8.0, 'assets/images/blue9.png'),
      Image.asset(scale: 8.0, 'assets/images/blue10.png'),
      Image.asset(scale: 8.0, 'assets/images/blue11.png')
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor:Color.fromARGB(255, 152, 241, 143),
        elevation: 0 ,
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: DropdownButtonHideUnderline(
              child: DropdownButton2(
                isExpanded: true,
                hint:  Row(
                  children: [
                    if(count==0)
                    Text(
                      '${title[0]} ',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: Colors
                                  .purpleAccent.shade100, // Change to the desired purple color
                              offset: Offset(1,
                                  1), // Adjust the offset based on your preference
                              blurRadius:
                              1, // Adjust the blur radius based on your preference
                            ),
                          ]
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    if(count==1)
                      Text(
                        '${title[1]} ',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                color: Colors
                                    .purpleAccent.shade100, // Change to the desired purple color
                                offset: Offset(1,
                                    1), // Adjust the offset based on your preference
                                blurRadius:
                                1, // Adjust the blur radius based on your preference
                              ),
                            ]
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    if(count==2)
                      Text(
                        '${title[2]} ',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                color: Colors
                                    .purpleAccent.shade100, // Change to the desired purple color
                                offset: Offset(1,
                                    1), // Adjust the offset based on your preference
                                blurRadius:
                                1, // Adjust the blur radius based on your preference
                              ),
                            ]
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    if(count==3)
                      Text(
                        '${title[3]} ',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                color: Colors
                                    .purpleAccent.shade100, // Change to the desired purple color
                                offset: Offset(1,
                                    1), // Adjust the offset based on your preference
                                blurRadius:
                                1, // Adjust the blur radius based on your preference
                              ),
                            ]
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    if(count==4)
                      Text(
                        '${title[4]} ',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                color: Colors
                                    .purpleAccent.shade100, // Change to the desired purple color
                                offset: Offset(1,
                                    1), // Adjust the offset based on your preference
                                blurRadius:
                                1, // Adjust the blur radius based on your preference
                              ),
                            ]
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    if(count==5)
                      Text(
                        '${title[5]} ',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                color: Colors
                                    .purpleAccent.shade100, // Change to the desired purple color
                                offset: Offset(1,
                                    1), // Adjust the offset based on your preference
                                blurRadius:
                                1, // Adjust the blur radius based on your preference
                              ),
                            ]
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    if(count==6)
                      Text(
                        '${title[6]} ',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                color: Colors
                                    .purpleAccent.shade100, // Change to the desired purple color
                                offset: Offset(1,
                                    1), // Adjust the offset based on your preference
                                blurRadius:
                                1, // Adjust the blur radius based on your preference
                              ),
                            ]
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
                items: [
                  ...shapes.map(
                        (item) => DropdownMenuItem<MenuItem>(
                      value: item,
                      child: buildItem(item),
                    ),
                  ),

                ],
                onChanged: (value) {
                  onChange(context, value! as MenuItem);
                },
                buttonStyleData: ButtonStyleData(
                  height: 50,
                  width: 200,
                  padding: const EdgeInsets.only(left: 14, right: 14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Colors.black26,
                    ),
                    color: Color.fromARGB(255, 50, 6, 56),
                    gradient: const LinearGradient(
                        colors: [Color(0xFF42275a), Color(0xFF734b6d)]),
                  ),
                  elevation: 2,
                ),
                dropdownStyleData: DropdownStyleData(
                  maxHeight: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: Color.fromARGB(255, 50, 6, 56),
                    gradient: const LinearGradient(
                        colors: [Color(0xFF42275a), Color(0xFF734b6d)]),
                  ),
                  offset: const Offset(-20, 0),
                  scrollbarTheme: ScrollbarThemeData(
                    radius: const Radius.circular(40),
                    thickness: MaterialStateProperty.all<double>(6),
                    thumbVisibility: MaterialStateProperty.all<bool>(true),
                  ),
                ),
                menuItemStyleData: const MenuItemStyleData(
                  height: 40,
                  padding: EdgeInsets.only(left: 14, right: 14),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromARGB(255, 152, 241, 143),
                      Color.fromARGB(255, 4, 110, 9),
                    ])),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                    decoration: BoxDecoration(boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        blurRadius: 10.0,
                        spreadRadius: 5.0,
                      )
                    ]),
                    child: Stack(
                      children: [
                        if(count==0)
                        shape[0],
                        if(count==1)
                          shape[1],
                        if(count==2)
                          shape[2],
                        if(count==3)
                          shape[3],
                        if(count==4)
                          shape[4],
                        if(count==5)
                          shape[5],
                        if(count==6)
                          shape[6],
                        SizedBox(
                          height:
                          MediaQuery.of(context).size.width * (1637 / 1251),
                          width: MediaQuery.of(context).size.width,
                          child: IgnorePointer(
                            ignoring: !canPaint,
                            child: const Signature(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                        onPressed: () {
                          setState(() {
                            reset();
                          });
                        },
                        icon: const Icon(Icons.delete,
                            color: Colors.black, size: 35.0)),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          canPaint = !canPaint;
                        });
                      },
                      icon: Icon(
                        Icons.draw_sharp,
                        color: canPaint ? Colors.white : Colors.black,
                        size: 35.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if(count==0)
          Padding(
            padding: const EdgeInsets.all(25),
            child: Stack(
              children: [for (var icon in iconsRed) DraggableIcon(child: icon)],
            ),
          ),
          if(count==0)
            Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 70, 25),
            child: Stack(
              children: [
                for (var icon in iconsBlue) DraggableIcon(child: icon)
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 120, 25),
            child: DraggableIcon(
              child: Image.asset(
                'assets/images/ball.png',
                scale: 15.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
Widget buildItem(MenuItem item) {
  return Directionality(
    textDirection: TextDirection.rtl,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              item.text,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
        SizedBox(height: 5,),
        Container(
          width: 180,
          height: 1,
          color: Colors.white.withOpacity(0.6),
        )
      ],
    ),
  );
}

