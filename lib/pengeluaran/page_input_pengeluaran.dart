import 'package:flutter/material.dart';
import 'package:hitung_keuangan/database/DatabaseHelper.dart';
import 'package:hitung_keuangan/model/model_database.dart';
import 'package:intl/intl.dart';

class PageInputPengeluaran extends StatefulWidget {
  final ModelDatabase? modelDatabase;

  PageInputPengeluaran({this.modelDatabase});

  @override
  _PageInputPengeluaranState createState() => _PageInputPengeluaranState();
}

class _PageInputPengeluaranState extends State<PageInputPengeluaran> {
  DatabaseHelper databaseHelper = DatabaseHelper();

  TextEditingController? keterangan;
  TextEditingController? tanggal;
  TextEditingController? jumlah_uang;

  @override
  void initState() {
    keterangan = TextEditingController(
        text: widget.modelDatabase == null
            ? ''
            : widget.modelDatabase!.keterangan);
    tanggal = TextEditingController(
        text:
            widget.modelDatabase == null ? '' : widget.modelDatabase!.tanggal);
    jumlah_uang = TextEditingController(
        text: widget.modelDatabase == null
            ? ''
            : widget.modelDatabase!.jumlah_uang.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Colors.blue,
        title: Text('Form Data Pengeluaran',
            style: const TextStyle(fontSize: 14, color: Colors.white)),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextField(
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.text,
            controller: keterangan,
            decoration: InputDecoration(
                labelText: 'Keterangan',
                labelStyle: const TextStyle(fontSize: 14, color: Colors.black),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                )),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 20,
            ),
            child: TextField(
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.datetime,
              readOnly: true,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                    builder: (BuildContext context, Widget? child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: const ColorScheme.light(
                              onPrimary: Colors.white,
                              onBackground: Colors.white),
                          datePickerTheme: const DatePickerThemeData(
                            headerBackgroundColor: Colors.blue,
                            backgroundColor: Colors.white,
                            headerForegroundColor: Colors.white,
                            surfaceTintColor: Colors.white,
                          ),
                        ),
                        child: child!,
                      );
                    },
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime(9999));
                if (pickedDate != null) {
                  tanggal!.text = DateFormat('dd MMM yyyy').format(pickedDate);
                }
              },
              controller: tanggal,
              decoration: InputDecoration(
                  labelText: 'Tanggal',
                  labelStyle:
                      const TextStyle(fontSize: 14, color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 20,
            ),
            child: TextField(
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.number,
              controller: jumlah_uang,
              decoration: InputDecoration(
                  labelText: 'Jumlah Uang',
                  labelStyle:
                      const TextStyle(fontSize: 14, color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(40),
            child: Material(
              elevation: 3,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: size.width,
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.blue),
                child: Material(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.transparent,
                  child: InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () {
                      if (keterangan!.text.toString() == '' ||
                          tanggal!.text.toString() == '' ||
                          jumlah_uang!.text.toString() == '') {
                        const snackBar = SnackBar(
                            content:
                                Text("Ups, form tidak boleh ada yang kosong!"));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } else {
                        upsertData();
                      }
                    },
                    child: Center(
                      child: (widget.modelDatabase == null)
                          ? Text(
                              'Tambah Data',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.white),
                            )
                          : Text(
                              'Update Data',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.white),
                            ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> upsertData() async {
    if (widget.modelDatabase != null) {
      //update
      await databaseHelper.updateData(ModelDatabase.fromJson({
        'id': widget.modelDatabase!.id,
        'tipe': 'pengeluaran',
        'keterangan': keterangan!.text,
        'jumlah_uang': int.parse(jumlah_uang!.text),
        'tanggal': tanggal!.text
      }));
      Navigator.pop(context, 'update');
    } else {
      //insert
      await databaseHelper.saveData(ModelDatabase(
        tipe: 'pengeluaran',
        keterangan: keterangan!.text,
        jumlah_uang: int.parse(jumlah_uang!.text),
        tanggal: tanggal!.text,
      ));
      Navigator.pop(context, 'save');
    }
  }
}
