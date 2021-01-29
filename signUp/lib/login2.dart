import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:convert' as JSON;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as developer;

class EmailFeildValidator{
  static String validate(String value){
    return value.isEmpty ? 'Email cannot be empty' : null;
  }
}

class PasswordFeildValidator{
  static String validate(String value){
    return value.isEmpty ? 'Password cannot be empty' : null;
  }
}
class Login extends StatefulWidget {

  static String tag = "login";
  @override
  _LoginState createState() => _LoginState();
}

final GlobalKey <ScaffoldState>_scaffoldKey = new GlobalKey<ScaffoldState>();

class _LoginState extends State<Login> {

  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool _isLoggedIn = false;
  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  _loginWithGoogle() async{
    try{
      await _googleSignIn.signIn();
      setState(() {
        _isLoggedIn = true;
      });
    } catch (err){
      print(err);
    }
  }

  _logoutWithGoogle(){
    _googleSignIn.signOut();
    setState(() {
      _isLoggedIn = false;
    });
  }

  Map userProfile;
  final facebookLogin = FacebookLogin();

  _loginWithFB() async{

    final result = await facebookLogin.logInWithReadPermissions(['email']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final token = result.accessToken.token;
        final graphResponse = await http.get('https://graph.facebook.com/v2.12/me?fields=name,picture,email&access_token=${token}');
        final profile = JSON.jsonDecode(graphResponse.body);
        print(profile);
        setState(() {
          userProfile = profile;
          _isLoggedIn = true;
        });
        break;

      case FacebookLoginStatus.cancelledByUser:
        setState(() => _isLoggedIn = false );
        break;
      case FacebookLoginStatus.error:
        setState(() => _isLoggedIn = false );
        break;
    }

  }
  _logout(){
    facebookLogin.logOut();
    setState(() {
      _isLoggedIn = false;
    });
  }


  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  String email_address;
  String password;

  signIn(String email_address,password) async{
    try{
      final data = {
        'email_address': email_address,
        'password': password
      };
      var jsonData = null;
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

      var response = await http.post("http://10.0.2.2:80/viduraSolution/login.php",body: jsonEncode(data));
      if(response.statusCode == 200){
        print(response.statusCode);
        jsonData = json.decode(response.body);
        print(response.body);
        if(jsonData){
          setState(() {
            _isLoading = false;

            // sharedPreferences.setString("token", jsonData('token'));
           // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => Home()),(Route<dynamic> route) => false);
            //Navigator.of(context).push(MaterialPageRoute(builder: (context) => Home()));

          });
        }else{
          print('Invalid email and password');

        }

      }else{
        print(response.body);
     }
    }on Exception catch(exception){
       print(exception.toString());
    }

    // Showing Alert Dialog with Response JSON.
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Login successfully"),
          actions: <Widget>[
            FlatButton(
              child: new Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(15.0, 80.0, 15.0, 10.0),
            child: Column(
              children: [
                Container(
                    child:Column(
                      children: [
                        SizedBox(height:20),
                        Text('Welcome Back',
                          style: TextStyle(
                            fontSize: 25.0,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1287A5),
                          ),
                        ),
                        Text('Sign in to continue',
                          style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1287A5),
                          ),
                        ),
                      ],
                    )
                ),
                SizedBox(height:20),
                Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          cursorColor: Colors.teal,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.email, color: Color(0xFF1287A5),),
                            hintText: 'Email',
                            border: OutlineInputBorder(),
                          ),
                          validator: EmailFeildValidator.validate,
                          onSaved: (value) =>  email_address =  value,
                    
                        ),
                        SizedBox(height:20),
                        TextFormField(
                          controller: passwordController,
                          obscureText: true,
                          cursorColor: Colors.teal,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock, color: Color(0xFF1287A5),),
                            hintText: 'Password',
                            border: OutlineInputBorder(),
                          ),
                          validator: PasswordFeildValidator.validate,
                          onSaved: (value) => password =  value,
                          //onSaved: (value) => password =  value,
                          //validator: (value)=> value.length == 0? "Password cannot be empty" : null,
                        ),
                        SizedBox(height:20),
                        Container(
                            child:InkWell(
                                child: Text('Forget Password ?',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    color:Color(0xFF1287A5),
                                  ),
                                )
                            )
                        ),
                        //SizedBox(height:20),
                        TextFormField(
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Login cannot be empty';
                            }
                            return null;
                          },
                        ),
                        RaisedButton(
                          onPressed: (){

                            //Navigator.of(context).pushNamed(Home.tag);
                            setState(() {
                              _isLoading = true;
                            });
                            signIn(emailController.text,passwordController.text);
                            //_showcontent;
                            // Validate returns true if the form is valid, or false
                            // otherwise.
                            if (_formKey.currentState.validate()) {
                              // If the form is valid, display a Snackbar.
                              Scaffold.of(context)
                                  .showSnackBar(
                                  SnackBar(content: Text('Login successfully')));
                            }
                          },
                          color: Color(0xFF1287A5),
                          textColor: Colors.white,
                          child: Text('LOGIN'),
                        ),
                        SizedBox(height:20),
                        
                        Container(
                            child: _isLoggedIn
                                ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Image.network(userProfile["picture"]["data"]["url"], height: 50.0, width: 50.0,),
                                Text(userProfile["name"]),
                                OutlineButton( child: Text("Logout"), onPressed: (){
                                  _logout();
                                },)
                              ],
                            )
                                : Center(
                              child: OutlineButton(
                                child: Text("Login with Facebook", style: TextStyle(color: Color(0xFF1287A5))),
                                onPressed: () {
                                  _loginWithFB();
                                },
                              ),
                            )),
                        Container(
                            child: _isLoggedIn
                                ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Image.network(_googleSignIn.currentUser.photoUrl, height: 50.0, width: 50.0,),
                                Text(_googleSignIn.currentUser.displayName),
                                OutlineButton( child: Text("Logout"), onPressed: (){
                                  _logoutWithGoogle();
                                },)
                              ],
                            )
                                : Center(
                              child: OutlineButton(
                                child: Text("Login with Google",style: TextStyle(color: Color(0xFF1287A5))),
                                onPressed: () {
                                  _loginWithGoogle();
                                },
                              ),
                            )),
                      ],
                    )
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}