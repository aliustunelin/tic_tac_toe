import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool ohTurn = true; //ilk oyuncu 0 ile başlar

  var myTextStyle = TextStyle(color: Colors.white, fontSize: 27);
  int ohScore = 0;
  int exScore = 0;
  int filledBoxes = 0; //iki takımda birbirini yenemezse yeniden başlatma
  List<String> displayEx0h = ['', '', '', '', '', '', '', '', ''];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.grey[600],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "0 oyuncusu",
                          style: myTextStyle,
                        ),
                        Text(
                          ohScore.toString(),
                          style: myTextStyle,
                        ),
                      ],
                    ),
                  ),
                  VerticalDivider(
                    width: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "x oyuncusu",
                          style: myTextStyle,
                        ),
                        Text(
                          exScore.toString(),
                          style: myTextStyle,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: GridView.builder(
                itemCount: 9,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      _tapped(index);
                    },
                    child: Container(
                      decoration: //ara çizgileri çekti
                          BoxDecoration(
                              border: Border.all(color: Colors.grey[700])),
                      child: Center(
                        child: Text(
                          displayEx0h[index],
                          //index.toString(),
                          style: TextStyle(color: Colors.white, fontSize: 39),
                        ),
                      ),
                    ),
                  );
                }),
          ),
          Expanded(
            child: Container(color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }

  void _tapped(int index) {
    setState(() {
      if (ohTurn && displayEx0h[index] == '') {
        displayEx0h[index] = '0';
        filledBoxes += 1;
      } else if (!ohTurn && displayEx0h[index] == '') {
        displayEx0h[index] = 'x';
        filledBoxes += 1;
      }
      ohTurn = !ohTurn;
      _checkWinner();
    });
  }

  void _checkWinner() {
    //burada durumları uzun uzun yazacağız, daha algoritmik yöntem tabikide bulunabilir
    //1'nci satır kontrolü
    if (displayEx0h[0] == displayEx0h[1] &&
        displayEx0h[0] == displayEx0h[2] &&
        displayEx0h[0] != '') {
      _showWinDialog(displayEx0h[0]);
    }

    //2'nci satır kontrolü
    if (displayEx0h[3] == displayEx0h[4] &&
        displayEx0h[3] == displayEx0h[5] &&
        displayEx0h[3] != '') {
      _showWinDialog(displayEx0h[3]);
    }

    //3'nci satır kontrolü
    if (displayEx0h[6] == displayEx0h[7] &&
        displayEx0h[6] == displayEx0h[8] &&
        displayEx0h[6] != '') {
      _showWinDialog(displayEx0h[6]);
    }

    //1'nci sütun kontrolü
    if (displayEx0h[0] == displayEx0h[3] &&
        displayEx0h[0] == displayEx0h[6] &&
        displayEx0h[0] != '') {
      _showWinDialog(displayEx0h[0]);
    }

    //2'nci sütun kontrolü
    if (displayEx0h[1] == displayEx0h[4] &&
        displayEx0h[1] == displayEx0h[7] &&
        displayEx0h[1] != '') {
      _showWinDialog(displayEx0h[1]);
    }

    //3'nci sütun kontrolü
    if (displayEx0h[2] == displayEx0h[5] &&
        displayEx0h[2] == displayEx0h[8] &&
        displayEx0h[2] != '') {
      _showWinDialog(displayEx0h[2]);
    }

    //köşegen kontrolü
    if (displayEx0h[6] == displayEx0h[4] &&
        displayEx0h[6] == displayEx0h[2] &&
        displayEx0h[6] != '') {
      _showWinDialog(displayEx0h[6]);
    }

    //ters köşegen kontrolü
    if (displayEx0h[0] == displayEx0h[4] &&
        displayEx0h[0] == displayEx0h[8] &&
        displayEx0h[0] != '') {
      _showWinDialog(displayEx0h[0]);
    } else if (filledBoxes == 9) {
      _showDrawDialog();
    }
  }

  void _showDrawDialog() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(" Çizcem İkinizide!"),
            actions: [
              FlatButton(
                  onPressed: () {
                    _clearBoard();
                    Navigator.of(context)
                        .pop(); //action olduğunda son olayı geri alır
                  },
                  child: Text("Tekrar Oyna!"))
            ],
          );
        });
  }

  void _showWinDialog(String winner) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(winner + " Kazandın!"),
            actions: [
              FlatButton(
                  onPressed: () {
                    _clearBoard();
                    Navigator.of(context)
                        .pop(); //action olduğunda son olayı geri alır
                  },
                  child: Text("Tekrar Oyna!"))
            ],
          );
        });

    if (winner == '0') {
      ohScore += 1;
    } else if (winner == 'x') {
      exScore += 1;
    }
    _clearBoard();
  }

  void _clearBoard() {
    setState(() {
      for (int i = 0; i < 9; i++) {
        displayEx0h[i] = '';
      }
    });
    filledBoxes = 0;
  }
}
