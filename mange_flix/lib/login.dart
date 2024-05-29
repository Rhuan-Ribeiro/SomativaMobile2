import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mangeflix/cadaster.dart';
import 'package:mangeflix/movies.dart';
import 'package:flutter/gestures.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  bool display = false;
  bool showError = false;

  _verificaLogin() async {
    bool encuser = false;
    String url = "http://192.168.1.4:3000/users";
    http.Response response = await http.get(Uri.parse(url));
    List customers = <Users>[];
    customers = json.decode(response.body) as List;
    for (int i = 0; i < customers.length; i++) {
      if (email.text == customers[i]["email"] &&
          password.text == customers[i]["password"]) {
        encuser = true;
        break;
      }
    }
    if (encuser == true) {
      encuser = false;
      if (!mounted) return;
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const Films()));
      email.text = "";
      password.text = "";
    } else {
      // Mostrar o erro e redefinir após alguns segundos
      setState(() {
        showError = true;
      });
      Future.delayed(const Duration(seconds: 3), () {
        setState(() {
          showError = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var textColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.black;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "LOGIN",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 300,
              width: 300,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)),
                          prefixIcon: const Icon(
                            Icons.email_outlined,
                          ),
                          hintText: "Digite seu email"),
                      controller: email,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)),
                          prefixIcon: const Icon(
                            Icons.key_outlined,
                          ),
                          suffixIcon: IconButton(
                              icon: Icon(display
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                              onPressed: () {
                                setState(() {
                                  display = !display;
                                });
                              }),
                          hintText: "Digite sua senha"),
                      obscureText: display,
                      obscuringCharacter: '*',
                      controller: password,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: AnimatedOpacity(
                        opacity: showError ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 500),
                        child: const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Credenciais incorretas!",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Colors.red, fontWeight: FontWeight.bold),
                          ),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RichText(
                      text: TextSpan(
                        text: 'Não tem conta? ',
                        style: TextStyle(fontSize: 18, color: textColor),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Cadastre-se!',
                            style: const TextStyle(
                                fontSize: 18,
                                color: Colors.blue,
                                fontWeight: FontWeight.bold
                                // decoration: TextDecoration.underline,
                                ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const UserRegistration()),
                                );
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: _verificaLogin,
                      style: ButtonStyle(
                        fixedSize: WidgetStateProperty.all<Size>(
                            const Size(300, double.infinity)),
                      ),
                      child: const Text(
                        "ENTRAR",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Users {
  String id;
  String email;
  String password;
  Users(this.id, this.email, this.password);
  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(json["id"], json["email"], json["password"]);
  }
}
