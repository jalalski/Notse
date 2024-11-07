import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:notse/components/sps.dart';
import 'package:notse/components/textfont.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  CollectionReference gatagores =
      FirebaseFirestore.instance.collection("gatagores");
  bool isdatacame = true;
  List data = [];
  Future getData() async {
    QuerySnapshot datageter = await FirebaseFirestore.instance
        .collection("gatagores")
        .where("id", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    data.addAll(datageter.docs);
    isdatacame = false;
    setState(() {});
  }

  GoogleSignIn googleSignIn = GoogleSignIn();
  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushNamed("AddPage");
          },
          backgroundColor: Colors.deepPurple,
          child: const Textfont(
            text: "Add",
            color: Colors.white,
            size: 15,
            bold: true,
          ),
        ),
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          actions: [
            IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                googleSignIn.disconnect();
                Navigator.of(context).pushReplacementNamed("LoginPage");
              },
              icon: const Icon(Icons.exit_to_app),
              color: Colors.white,
            ),
          ],
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 33,
                width: 33,
                child: Image.asset("images/file.png"),
              ),
              const SizedBox(width: 8),
              const Textfont(
                text: "Notes",
                color: Colors.white,
                size: 25,
                bold: true,
              ),
            ],
          ),
          centerTitle: true,
        ),
        body: isdatacame
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.deepPurple,
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(12.0),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 3 / 2,
                  ),
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 6,
                        color: Colors.deepPurple.shade50,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset("images/file.png", height: 50),
                              const Sps(height: 8),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Textfont(
                                        text: data[index]["Section name"],
                                        color: Colors.deepPurple,
                                        size: 16,
                                        bold: true,
                                      ),
                                    ),
                                    PopupMenuButton(
                                      onSelected: (value) {
                                        if (value == "valdelete") {
                                          Alert(
                                            context: context,
                                            type: AlertType.warning,
                                            title: "Delete Confirmation",
                                            desc:
                                                "Are you sure you want to delete this note?",
                                            buttons: [
                                              DialogButton(
                                                onPressed: () {
                                                  gatagores
                                                      .doc(data[index].id)
                                                      .delete();
                                                  if (mounted) {
                                                    Navigator.of(context)
                                                        .pushReplacementNamed(
                                                            "HomePage");
                                                  }
                                                },
                                                color: Colors.deepPurple,
                                                width: 120,
                                                child: const Text(
                                                  "Delete",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ).show();
                                        } else if (value == "valrename") {
                                          // كود إعادة التسمية هنا
                                          // يمكنك إضافة نافذة مشابهة أو استخدام حوار (dialog) لتلقي الاسم الجديد
                                        }
                                      },
                                      itemBuilder: (context) {
                                        return [
                                          const PopupMenuItem(
                                            value: "valdelete",
                                            child: Row(
                                              children: [
                                                Icon(Icons.delete,
                                                    color: Colors
                                                        .red), // أيقونة الحذف
                                                SizedBox(
                                                    width:
                                                        8), // مساحة بين الأيقونة والنص
                                                Textfont(
                                                  text: "Delete",
                                                  color: Colors.black,
                                                  size: 12,
                                                  bold: false,
                                                ),
                                              ],
                                            ),
                                          ),
                                          const PopupMenuItem(
                                            value: "valrename",
                                            child: Row(
                                              children: [
                                                Icon(Icons.edit,
                                                    color: Colors
                                                        .blue), // أيقونة إعادة التسمية
                                                SizedBox(
                                                    width:
                                                        8), // مساحة بين الأيقونة والنص
                                                Textfont(
                                                  text: "Rename",
                                                  color: Colors.black,
                                                  size: 12,
                                                  bold: false,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ];
                                      },
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }
}
