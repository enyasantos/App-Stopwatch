import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';

void main() {
  runApp(MaterialApp(
    title: 'Stopwatch',
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Timer timer;
  bool stop = false;

  String clock = "00:00:00";

  int sec = 0;
  int min = 0;
  int hou = 0;

  var laps = new List();

  Color _hexToColor(String code) {
    return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  void resetTimer() {
    stop = true;
    setState(() {
      sec = 0;
      min = 0;
      hou = 0;
      clock = "${formatTime(hou)}:${formatTime(min)}:${formatTime(sec)}";
      laps = [];
    });
  }

  String formatTime(int time) {
    String formated = '';
    if (time <= 9) {
      formated = "0${time.toString()}";
      return formated;
    }
    return time.toString();
  }

  void addLaps() {
    setState(() {
      laps.insert(0, clock);
    });
  }

  void startTimer() {
    retomarTimer();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (stop)
        timer.cancel();
      else {
        setState(() {
          sec += 1;
          if (sec >= 60) {
            min += 1;
            sec = 0;
            if (min >= 60) {
              hou += 1;
              min = 0;
            }
          }
          clock = "${formatTime(hou)}:${formatTime(min)}:${formatTime(sec)}";
        });
      }
    });
  }

  void stopTimer() {
    stop = true;
    timer.cancel();
  }

  void retomarTimer() {
    stop = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: _hexToColor('#080509'),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 80.0, horizontal: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Stopwatch",
                  style: GoogleFonts.montserrat(
                    textStyle: TextStyle(
                        color: _hexToColor('#272328'),
                        fontSize: 16.0,
                        fontFamily: 'Montserrat'),
                  )),
              Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Container(
                    width: 220.0,
                    height: 220.0,
                    decoration: BoxDecoration(
                      color: _hexToColor('#0E0910'),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 10,
                          offset: Offset(4, 4), // changes position of shadow
                        ),
                      ],
                    ),
                  ),
                  Text("${clock}",
                      style: GoogleFonts.oswald(
                        textStyle: TextStyle(
                          color: _hexToColor('#858585').withOpacity(0.04),
                          fontSize: 80.0,
                          fontFamily: 'Oswald',
                        ),
                      )),
                  Text("${clock}",
                      style: GoogleFonts.oswald(
                          textStyle: TextStyle(
                        color: _hexToColor('#858585'),
                        fontSize: 36.0,
                        fontFamily: 'Oswald',
                      ))),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FlatButton(
                    onPressed: () {
                      startTimer();
                    },
                    child: Icon(
                      Icons.play_arrow,
                      size: 30.0,
                      color: _hexToColor('#F5FAFE'),
                    ),
                    shape: CircleBorder(
                      side: BorderSide(
                        color: _hexToColor('#3C166C'),
                      ),
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      stopTimer();
                    },
                    child: Icon(
                      Icons.pause,
                      size: 30.0,
                      color: _hexToColor('#F5FAFE'),
                    ),
                    shape: CircleBorder(
                      side: BorderSide(
                        color: _hexToColor('#FA1B6F'),
                      ),
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      addLaps();
                    },
                    child: Icon(
                      Icons.add,
                      size: 30.0,
                      color: _hexToColor('#F5FAFE'),
                    ),
                    shape: CircleBorder(
                      side: BorderSide(
                        color: _hexToColor('#FA1B6F'),
                      ),
                    ),
                  ),
                ],
              ),
              FlatButton(
                onPressed: () {
                  resetTimer();
                },
                child: Icon(
                  Icons.replay,
                  size: 30.0,
                  color: _hexToColor('#F5FAFE'),
                ),
                shape: CircleBorder(
                  side: BorderSide(
                    color: _hexToColor('#FA1B6F'),
                  ),
                ),
              ),
              SizedBox(
                height: 200.0,
                child: ListView.builder(
                  physics: ClampingScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: laps.length,
                  itemBuilder: (BuildContext context, int index) => Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: RichText(
                      text: TextSpan(
                        text: "Lap  ${laps.length - index}\n",
                        style: GoogleFonts.oswald(
                            textStyle: TextStyle(
                                color: _hexToColor('#8F9294'),
                                fontSize: 10.0,
                                fontFamily: 'Montserrat')
                        ),
                        children: <TextSpan>[
                          TextSpan(
                              text: '${laps[index]}',
                              style: GoogleFonts.oswald(
                                  textStyle: TextStyle(
                                    color: _hexToColor("#F5FAFE"),
                                    fontSize: 14.0,
                                    fontFamily: 'Montserrat',
                                  )))
                        ],
                      ),
                    ),
                  )
                ),
              ),
            ],
          ),
        ));
  }
}
