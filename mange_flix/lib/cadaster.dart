import 'package:flutter/material.dart'; // pacotes do widget
import 'package:http/http.dart'
    as http; // pacote http que permite fazer as requisições http
import 'dart:convert'; // pacote para converter json

class UserRegistration extends StatefulWidget {
  const UserRegistration({super.key});

  @override
  State<UserRegistration> createState() => _UserRegistrationState();
}

class _UserRegistrationState extends State<UserRegistration> {
  TextEditingController emailN = TextEditingController();
  TextEditingController passwordN = TextEditingController();
  bool display = false;
  _userRegistration() async {
    String url = "http://10.109.83.13:3000/users";
    Map<String, dynamic> message = {
      "id": emailN.text,
      "email": emailN.text,
      "password": passwordN.text,
    };

    http.post(Uri.parse(url),
        headers: <String, String>{
          'Content-type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(message));

    emailN.text = "";
    passwordN.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 300,
              width: 300,
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "CADASTRO",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 32,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
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
                      controller: emailN,
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
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              onPressed: () {
                                setState(() {
                                  display = !display;
                                });
                              }),
                          hintText: "Digite sua senha"),
                      obscureText: display,
                      obscuringCharacter: '*',
                      controller: passwordN,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: _userRegistration,
                      style: ButtonStyle(
                        fixedSize: MaterialStateProperty.all<Size>(
                            const Size(300, double.infinity)),
                      ),
                      child: const Text(
                        "CADASTRAR",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
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
