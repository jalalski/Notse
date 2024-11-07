import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notse/components/customtextformfildadd.dart';
import 'package:notse/components/sps.dart';
import 'package:notse/components/textfont.dart';

class CatagoresAddSection extends StatefulWidget {
  const CatagoresAddSection({super.key});

  @override
  State<CatagoresAddSection> createState() => _CatagoresAddSectionState();
}

class _CatagoresAddSectionState extends State<CatagoresAddSection> {
  GlobalKey<FormState> formstatekey = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  CollectionReference gatagores =
      FirebaseFirestore.instance.collection("gatagores");
  addGatagores() async {
    if (formstatekey.currentState!.validate()) {
      return gatagores.add({
        "Section name": name.text,
        "id": FirebaseAuth.instance.currentUser!.uid,
      }).then((value) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.green,
            content: Textfont(
                text: "The section was create Successfully",
                color: Colors.white,
                size: 15,
                bold: false)));

        Navigator.of(context).pushReplacementNamed("HomePage");
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Textfont(
                text: error.toString(),
                color: Colors.white,
                size: 15,
                bold: false)));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Textfont(
          text: "Add Your Category",
          color: Colors.white,
          size: 20,
          bold: true,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: formstatekey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomTextFormFildAdd(
                validator: (value) {
                  if (value!.isEmpty) {
                    return "The fild is empty";
                  }
                  return null;
                },
                hint: "Enter the name",
                controller: name,
                prefixIcon: const Icon(Icons.email, color: Colors.deepPurple),
              ),
              const Sps(height: 25),
              TextButton(
                onPressed: () {
                  // وظيفة اختيار الصورة هنا
                },
                child: const Textfont(
                  text: "Add a Photo",
                  color: Colors.deepPurple,
                  size: 16,
                  bold: true,
                ),
              ),
              const Sps(height: 20),
              MaterialButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                color: Colors.deepPurple,
                height: 55,
                elevation: 5,
                onPressed: () {
                  addGatagores();
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, color: Colors.white),
                    SizedBox(width: 10),
                    Textfont(
                      text: "Add Section",
                      color: Colors.white,
                      size: 16,
                      bold: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
