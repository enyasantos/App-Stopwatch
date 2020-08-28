import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';

void main() {
  runApp(MaterialApp(
    title: 'Stopwatch',
    debugShowCheckedModeBanner: false,
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  int count = 0; //Saber quantas vezes foram clicados start e play

  Timer timer;
  bool stop = true;

  String clock = "00:00:00";

  int sec = 0;
  int min = 0;
  int hou = 0;

  var laps = new List();

  Color _hexToColor(String code) {
    return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  Paint _outerArc;

  _HomeState() {
    _outerArc = Paint()
      ..color = _hexToColor('#0E0910')
      ..strokeWidth = 8;
  }

  String formatTime(int time) {
    String formated = '';
    if (time <= 9) {
      formated = "0${time.toString()}";
      return formated;
    }
    return time.toString();
  }

  void addLapsOrReset() {
    if (stop && count == 1) {
      resetTimer();
    } else {
      addLaps();
    }
  }

  void addLaps() {
    setState(() {
      laps.insert(0, clock);
    });
  }

  void resetTimer() {
    stop = true;
    setState(() {
      sec = 0;
      min = 0;
      hou = 0;
      count = 0;
      clock = "${formatTime(hou)}:${formatTime(min)}:${formatTime(sec)}";
      laps = [];
    });
  }

  void startOrStopTimer() {
    if (stop) {
      startTimer();
      count = 1;
      setState(() {
        stop = false;
      });
    } else {
      stopTimer();
      setState(() {
        stop = true;
      });
    }
  }

  void startTimer() {
    retomarTimer();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (stop)
        timer.cancel();
      else {
        setState(() {
          sec += 1;
          if (sec == 60) {
            min += 1;
            sec = 0;
            if (min == 60) {
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
          padding: EdgeInsets.only(top: 70.0, bottom: 10.0, left: 10.0, right: 10.0),
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
                    margin: EdgeInsets.symmetric(vertical: 50.0),
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
                      border: Border.all(width: 5.0, color: _hexToColor('#5282F9'))
                    ),
                  ),
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
                      startOrStopTimer();
                    },
                    child: Icon(
                      stop ? Icons.play_arrow : Icons.pause,
                      size: 20.0,
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
                      addLapsOrReset();
                    },
                    child: Icon(
                      stop && count == 1 ? Icons.replay : Icons.add,
                      size: 20.0,
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
              Padding(padding: EdgeInsets.only(top: 26.0),
              child: SizedBox(
                height: 50.0,
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
                                  fontFamily: 'Montserrat')),
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
                    )),
              ),)
            ],
          ),
        ));
  }
}

