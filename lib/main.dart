import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:crud_sqflite/ui/list_pegawai.dart';

void main() => runApp(
      MaterialApp(
        title: 'Data Pegawai',
        home: ListPegawai(),
        debugShowCheckedModeBanner: false,
      ),
    );
