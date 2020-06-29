import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {

  const ChatPage({Key key, this.channel}) : super(key: key);

  final String channel;

  @override
  _ChatPageState createState() => _ChatPageState();

}

class _ChatPageState extends State<ChatPage> {

  TextEditingController _newTextMessageController = TextEditingController();
  ScrollController _scrollController = new ScrollController();
  var actualMessageTimeStamp;
  List users = ['NelsonJr', 'Ricardo', 'Gustavo', 'Erik'];
  List<Map<String, dynamic>> messages = [];
  Map<String, dynamic> message1 = {
    "timeStamp": DateTime.now().millisecondsSinceEpoch,
    "userName": "NelsonJr",
    "message": "Ola Pessoal, alguma souluçao para o hack20?"
  };
  Map<String, dynamic> message2 = {
    "timeStamp": DateTime.now().millisecondsSinceEpoch,
    "userName": "Ricardo",
    "message": "Acho que podiamos desenvolver uma soluçao de entrega de lanches"
  };
  Map<String, dynamic> message3 = {
    "timeStamp": DateTime.now().millisecondsSinceEpoch,
    "userName": "Gustavo",
    "message": "Pessoa, podemos fazer um aplicativo para conversas entre pessoas isoladas poderem fazer ligaçoes por video nesse momento de quarentena."
  };
  Map<String, dynamic> message4 = {
    "timeStamp": DateTime.now().millisecondsSinceEpoch,
    "userName": "Erik",
    "message": "Vamos Fazer algo da decada de 90 para o futuro"
  };

  @override
  void initState() {
    messages.add(message1);
    messages.add(message2);
    messages.add(message3);
    messages.add(message4);
    super.initState();
  }
  @override
  void dispose() {
    _newTextMessageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      endDrawer: Drawer(
          child: DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.white70,
            ),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  color: Colors.blue,
                  child: Text("Usuarios", style: TextStyle(color: Colors.white, fontSize: 26, fontFamily: 'Courrier Prime' ), textAlign: TextAlign.center,),
                ),
                Divider(),
                Expanded(
                  child: ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context, index){
                        return Text("@${users[index]}",style: TextStyle(fontSize: 20, fontFamily: 'Courrier Prime', fontWeight: FontWeight.bold),);
                      }
                  ),
                )
              ],
            ),
          )
      ),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
        ),
        title: Text("${this.widget.channel}", style: TextStyle(color: Colors.black),),
      ),
      body: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: ListView.builder(
                    itemCount: messages.length,
                    controller: _scrollController,
                    itemBuilder: (context, index){
                      var messageDay = DateTime.fromMillisecondsSinceEpoch(messages[index]['timeStamp']).day;
                      var messageMonth = DateTime.fromMillisecondsSinceEpoch(messages[index]['timeStamp']).month;
                      var messageYear = DateTime.fromMillisecondsSinceEpoch(messages[index]['timeStamp']).year;
                      var messageHour = DateTime.fromMillisecondsSinceEpoch(messages[index]['timeStamp']).hour;
                      var messageMinutes = DateTime.fromMillisecondsSinceEpoch(messages[index]['timeStamp']).minute;
                      var messageSeconds = DateTime.fromMillisecondsSinceEpoch(messages[index]['timeStamp']).second;
                      return Container(
                          padding: EdgeInsets.all(5),
                          child: Text("$messageDay/$messageMonth/$messageYear:$messageHour:$messageMinutes:$messageSeconds - ${messages[index]['userName']} : ${messages[index]['message']}",
                            style: TextStyle(fontFamily: 'Courrier Prime', fontSize: 16, fontWeight: FontWeight.bold),));
                    }
                ),
              ),
              TextField(
                controller: _newTextMessageController,
                onSubmitted: (newMessageFromKeyboard){
                  int timeStamp = DateTime.now().millisecondsSinceEpoch;
                  if(newMessageFromKeyboard == '/help' || newMessageFromKeyboard == '-h'){
                    //CHAMA O HELPER COM OS POSSIVEIS COMANDOS QUE PODEM SER UTILIZADOS
                    _helper(timeStamp);
                  }else {
                    //AQUI SALVA AS MENSGENS NO FIREBASE
                    Map<String, dynamic> newMessage = {
                      "timeStamp": timeStamp,
                      "userName": "Gustavo",
                      "message": newMessageFromKeyboard
                    };
                    setState(() {
                      messages.add(newMessage);
                    });
                    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
                  }
                  _newTextMessageController.clear();
                },
                autofocus: false,
                style: TextStyle(fontFamily: 'Courrier Prime', fontSize: 16, fontWeight: FontWeight.bold),
                cursorColor: Colors.black,
                decoration: InputDecoration(
                    focusColor: Colors.black,
                    filled: true,
                    fillColor: Colors.black12,
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.circular(20)
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    )
                ),
              )
            ],
          )
      ),
    );
  }

  void _helper(int timeStamp){
    List<String> messageHelpers = ['\n/join - Entrar em um canal', '\n/list - Lista os usuarios neste canal','\n/quit - sai deste canal'];
    Map<String, dynamic> newMessage = {
      "timeStamp": timeStamp,
      "userName": "System",
      "message": messageHelpers.toString().replaceAll("[", "").replaceAll("]", "").replaceAll(",","")
    };
    setState(() {
      messages.add(newMessage);
    });
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }
}