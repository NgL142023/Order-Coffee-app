import 'package:flutter/material.dart';
import 'package:flutterapp1/models/app_user.dart';
import 'package:flutterapp1/services/database.dart';

import 'package:flutterapp1/shared/loading.dart';

import 'package:flutterapp1/utils/app_styles.dart';
import 'package:provider/provider.dart';

class ShowSettings extends StatefulWidget {
  const ShowSettings({super.key});

  @override
  State<ShowSettings> createState() => _ShowSettingsState();
}

class _ShowSettingsState extends State<ShowSettings> {
  final _formKey = GlobalKey<FormState>();
  String? _currentName;
  int? _currentStrength;
  String? _currentSugar;
  List<String> sugars = ['0', '1', '2', '3', '4', '5'];
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser>(context);
    return StreamBuilder<AppUserData>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Form(
              key: _formKey,
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Tên:"),
                    const SizedBox(
                      height: 4,
                    ),
                    TextFormField(
                      initialValue: snapshot.data!.name,
                      validator: (value) =>
                          value!.isEmpty ? "Nhập tên của bạn" : null,
                      onChanged: (value) => setState(
                        () {
                          _currentName = value;
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const Text("Số lượng đường:"),
                    const SizedBox(
                      height: 4,
                    ),
                    DropdownButtonFormField(
                      value: snapshot.data!.sugar,
                      items: sugars.map((sugar) {
                        return DropdownMenuItem(
                          value: sugar,
                          child: Text("$sugar viên"),
                        );
                      }).toList(),
                      onChanged: (value) => setState(() {
                        _currentSugar = value as String;
                      }),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const Text("Độ mạnh:"),
                    const SizedBox(
                      height: 4,
                    ),
                    Slider(
                        min: 100,
                        max: 900,
                        divisions: 8,
                        activeColor: Colors
                            .blue[_currentStrength ?? snapshot.data!.strength],
                        inactiveColor: Colors
                            .blue[_currentStrength ?? snapshot.data!.strength],
                        label: "Độ mạnh",
                        value: _currentStrength?.toDouble() ??
                            snapshot.data!.strength.toDouble(),
                        onChanged: (value) {
                          setState(() {
                            _currentStrength = value.round();
                          });
                        }),
                    const SizedBox(
                      height: 30,
                    ),
                    Center(
                      child: Container(
                        height: 50,
                        width: 150,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              await DatabaseService(uid: user.uid)
                                  .updateUserData(
                                      _currentSugar ?? snapshot.data!.sugar,
                                      _currentName ?? snapshot.data!.name,
                                      _currentStrength ??
                                          snapshot.data!.strength);
                              // ignore: use_build_context_synchronously
                              Navigator.pop(context);
                            }
                          },
                          child: Center(
                            child: Text(
                              "Cập nhật",
                              style: Styles.textStyle2,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          } else {
            return const Loading();
          }
        });
  }
}
