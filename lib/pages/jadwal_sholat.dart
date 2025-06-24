import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class JadwalSholatPage extends StatefulWidget {
  final String city;

  const JadwalSholatPage({Key? key, required this.city}) : super(key: key);

  @override
  _JadwalSholatPageState createState() => _JadwalSholatPageState();
}

class _JadwalSholatPageState extends State<JadwalSholatPage> {
  Map<String, String> jadwal = {};
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchJadwal(widget.city);
  }

  Future<void> fetchJadwal(String city) async {
    final url = Uri.parse('http://api.aladhan.com/v1/timingsByCity?city=$city&country=Indonesia&method=2');
    final res = await http.get(url);

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      final waktu = data['data']['timings'];

      setState(() {
        jadwal = {
          'Subuh': waktu['Fajr'],
          'Dzuhur': waktu['Dhuhr'],
          'Ashar': waktu['Asr'],
          'Maghrib': waktu['Maghrib'],
          'Isya': waktu['Isha'],
        };
        loading = false;
      });
    } else {
      setState(() {
        jadwal = {};
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Jadwal Sholat - ${widget.city}')),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    'Jadwal Sholat Hari Ini',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Divider(),
                  ...jadwal.entries.map((entry) => ListTile(
                        title: Text(entry.key),
                        trailing: Text(entry.value),
                      )),
                ],
              ),
            ),
    );
  }
}
