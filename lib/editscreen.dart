import 'dart:io';

import 'package:app/EmpProvider.dart';
import 'package:app/model/employee.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class Editscreen extends StatefulWidget {
  Editscreen({Key? key, required this.emp}) : super(key: key);
  Emp emp;

  @override
  State<Editscreen> createState() => _EditscreenState();
}

class _EditscreenState extends State<Editscreen> {
  TextEditingController _nameController = TextEditingController();

  TextEditingController _departController = TextEditingController();

  // TextEditingController _nameController = TextEditingController();
  XFile? imgXfile;

  @override
  Widget build(BuildContext context) {
    _nameController.value = TextEditingValue(text: widget.emp.name);
    _departController.value = TextEditingValue(text: widget.emp.department);

    return Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            Text("Edit Data"),
            SizedBox(
              height: 30,
            ),
            Stack(
              children: [
                imgXfile != null
                    ? Image.file(
                        File(imgXfile!.path),
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                    : Image.network(
                        widget.emp.img,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, object, stackTrace) =>
                            const Icon(Icons.error),
                      ),
                Positioned(
                    top: 8,
                    right: 8,
                    child: IconButton(
                      onPressed: () async {
                        // pick img
                        imgXfile = await ImagePicker()
                            .pickImage(source: ImageSource.gallery);
                        imgXfile != null ? setState(() {}) : null;
                      },
                      icon: const Icon(Icons.edit),
                      color: Colors.white,
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all<Color>(
                            Colors.black.withOpacity(0.5)),
                      ),
                    ))
              ],
            ),
            SizedBox(
              height: 30,
            ),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                  label: Text("Name"),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
            ),
            SizedBox(
              height: 30,
            ),
            TextField(
              controller: _departController,
              decoration: InputDecoration(
                  label: Text("Department"),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
            ),
            TextButton(
                onPressed: () {
                  // pass emp object with data and also pass img file
                  // for loader u can pass context
                  Provider.of<EmpProvider>(context, listen: false).updateData(
                      Emp(widget.emp.id, _nameController.text,
                          _departController.text, widget.emp.img));
                  Navigator.pop(context);
                },
                child: Text("Update Data"))
          ],
        ));
  }
}
