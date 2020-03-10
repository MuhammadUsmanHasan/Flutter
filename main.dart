

import 'package:flutter/material.dart';
import 'package:http/http.dart';

void main(){
  runApp(new MyApp());
}




class MyApp extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SystemX Login',
      theme:  ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new LoginPage()
    );
   
  }
}

class LoginPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => new _LoginPageState();

}
  
class _LoginPageState extends State<LoginPage> {
  
  var formKey = new GlobalKey<FormState>();
  
  String _env ;
  String _email;
  String _password;
  String _response = "default";
  void validateAndSave(){
    var form = formKey.currentState;
    print("----------------------------------------------------------------------");
   
    form.save();
    if (form.validate()){
      _Login(_env,_email,_password);
      
     

    } else{
      String msg = "Not valid";
      String code = "404";
      showDialogs(msg,code);
    }
    
  }

  void showDialogs(msg ,code){
    showDialog(
      context: context,
      builder: (BuildContext content){
        return AlertDialog(
          title: new Text(msg),
          content: new Text("status code $code"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Okay"),
              onPressed: (){
                Navigator.of(context).pop();
              },
            )
          ],

        );
      },
    
    );
  }

  _Login(_env, _email, _password) async{
    
    String url = 'https://${_env.trim()}.systemx.net/workers/auth';
    print(url);
    Map<String,String> header = {"Content-type": "application/x-www-form-urlencoded "};
   
    var map =  new Map<String, String>();
    map['email'] = _email.trim();
    map['password'] = _password.trim();

    Response response = await post(url, headers:header , body:map);
    int statusCode = response.statusCode;
    print(statusCode);
    if (statusCode==200){
      
        
      String msg = "Login Successful";
      showDialogs(msg,statusCode);
      _response =  "$msg + $statusCode ";
      print(_response);
        
    } else {
      String msg = "Login Failed";
      showDialogs(msg, statusCode);
      _response = "$msg + $statusCode "; 
      print(_response);
    }
  }

  @override
  Widget build(BuildContext content){
    
    return Scaffold(
      appBar: new AppBar( 
        title: new Text('Login')
      ),
      body: new  Container(
        padding: EdgeInsets.all(32.0) ,
        child: new Form(
          key: formKey,
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              new TextFormField(
                decoration: new InputDecoration(labelText: "environment"),
                validator: (value)=> value.isEmpty ? 'Environment can\'t be empty' : null,
                onSaved: (value)=> _env = value,
              ),
              new TextFormField(
                decoration: new InputDecoration(labelText: "email"),
                validator: (value)=> value.isEmpty ? 'Email can\'t be empty' : null,
                onSaved: (value)=> _email = value,
              ),
              new TextFormField(
                decoration: new InputDecoration(labelText: "password"),
                obscureText: true,
                validator: (value) => value.isEmpty ? 'password can\'t be empty': null,
                onSaved: (value)=> _password = value,
              ),
              new RaisedButton(
                onPressed: validateAndSave,
               
                child: new Text("Login")
                
              ),
              

            ],
            ),

          ),
          

        
        )
        
        );
      
  }

 
}

