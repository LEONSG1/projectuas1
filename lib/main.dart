import 'package:flutter/material.dart';
import 'package:kelola_duit_youtube/db/database_instance.dart';
import 'package:kelola_duit_youtube/models/transaksi_model.dart';
import 'package:kelola_duit_youtube/screens/create_screen.dart';
import 'package:kelola_duit_youtube/screens/update_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Kelola Duitku",
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DatabaseInstance? databaseInstance;

  Future _refresh() async {
    setState(() {});
  }

  @override
  void initState() {
    databaseInstance = DatabaseInstance();
    initDatabase();
    super.initState();
  }

  Future initDatabase() async {
    await databaseInstance!.database();
    setState(() {});
  }

  showAlertDialog(BuildContext contex, int idTransaksi) {
    Widget okButton = TextButton(
      child: const Text("Yakin"),
      onPressed: () {
        //delete disini
        databaseInstance!.hapus(idTransaksi);
        Navigator.of(contex, rootNavigator: true).pop();
        setState(() {});
      },
    );

    AlertDialog alertDialog = AlertDialog(
      title: const Text("Peringatan !"),
      content: const Text("Anda yakin akan menghapus ?"),
      actions: [okButton],
    );

    showDialog(
        context: contex,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Kelola Duitku"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(
                      builder: (context) => const CreateScreen()))
                  .then((value) {
                setState(() {});
              });
            },
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: SafeArea(
            child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            FutureBuilder(
                future: databaseInstance!.totalPemasukan(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text("-");
                  } else {
                    if (snapshot.hasData) {
                      return Text(
                          "Total pemasukan : Rp. ${snapshot.data.toString()}");
                    } else {
                      return const Text("");
                    }
                  }
                }),
            const SizedBox(
              height: 20,
            ),
            FutureBuilder(
                future: databaseInstance!.totalPengeluaran(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text("-");
                  } else {
                    if (snapshot.hasData) {
                      return Text(
                          "Total pengeluaran : Rp. ${snapshot.data.toString()}");
                    } else {
                      return const Text("");
                    }
                  }
                }),
            FutureBuilder<List<TransaksiModel>>(
                future: databaseInstance!.getAll(),
                builder: (context, snapshot) {
                  print('HASIL : ${snapshot.data}');
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text("Loading");
                  } else {
                    if (snapshot.hasData) {
                      return Expanded(
                        child: ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                  title: Text(snapshot.data![index].name!),
                                  subtitle: Text(
                                      snapshot.data![index].total!.toString()),
                                  leading: snapshot.data![index].type == 1
                                      ? const Icon(
                                          Icons.download,
                                          color: Colors.green,
                                        )
                                      : const Icon(
                                          Icons.upload,
                                          color: Colors.red,
                                        ),
                                  trailing: Wrap(
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            Navigator.of(context)
                                                .push(MaterialPageRoute(
                                                    builder: (context) =>
                                                        UpdateScreen(
                                                          transaksiMmodel:
                                                              snapshot
                                                                  .data![index],
                                                        )))
                                                .then((value) {
                                              setState(() {});
                                            });
                                          },
                                          icon: const Icon(
                                            Icons.edit,
                                            color: Colors.grey,
                                          )),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            showAlertDialog(context,
                                                snapshot.data![index].id!);
                                          },
                                          icon: const Icon(Icons.delete,
                                              color: Colors.red))
                                    ],
                                  ));
                            }),
                      );
                    } else {
                      return const Text("Tidak ada data");
                    }
                  }
                })
          ],
        )),
      ),
    );
  }
}
