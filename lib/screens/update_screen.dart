import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:kelola_duit_youtube/db/database_instance.dart';
import 'package:kelola_duit_youtube/models/transaksi_model.dart';

class UpdateScreen extends StatefulWidget {
  final TransaksiModel transaksiMmodel;
  const UpdateScreen({Key? key, required this.transaksiMmodel})
      : super(key: key);

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  DatabaseInstance databaseInstance = DatabaseInstance();
  TextEditingController nameController = TextEditingController();
  TextEditingController totalController = TextEditingController();
  int _value = 1;

  @override
  void initState() {
    // TODO: implement initState
    databaseInstance.database();
    nameController.text = widget.transaksiMmodel.name!;
    totalController.text = widget.transaksiMmodel.total!.toString();
    _value = widget.transaksiMmodel.type!;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update"),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Nama"),
            TextField(
              controller: nameController,
            ),
            const SizedBox(
              height: 20,
            ),
            const Text("Tipe Transaksi"),
            ListTile(
              title: const Text("Pemasukan"),
              leading: Radio(
                  groupValue: _value,
                  value: 1,
                  onChanged: (value) {
                    setState(() {
                      _value = int.parse(value.toString());
                    });
                  }),
            ),
            ListTile(
              title: const Text("Pengeluaran"),
              leading: Radio(
                  groupValue: _value,
                  value: 2,
                  onChanged: (value) {
                    setState(() {
                      _value = int.parse(value.toString());
                    });
                  }),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text("Total"),
            TextField(
              controller: totalController,
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
                onPressed: () async {
                  await databaseInstance.update(widget.transaksiMmodel.id!, {
                    'name': nameController.text,
                    'type': _value,
                    'total': totalController.text,
                    'updated_at': DateTime.now().toString()
                  });
                  Navigator.pop(context);
                },
                child: const Text("Update")),
          ],
        ),
      )),
    );
  }
}
