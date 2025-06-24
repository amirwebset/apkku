import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class KotaPage extends StatefulWidget {
  @override
  _KotaPageState createState() => _KotaPageState();
}

class _KotaPageState extends State<KotaPage> {
  bool loading = true;
  Map<String, String> jadwal = {};
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchJadwalPamekasan();
  }

  Future<void> fetchJadwalPamekasan() async {
    final url = Uri.parse('http://api.aladhan.com/v1/timingsByCity?city=Pamekasan&country=Indonesia&method=2');
    try {
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
          errorMessage = 'Gagal mengambil data';
          loading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Terjadi kesalahan';
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Jadwal Sholat - Pamekasan')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: loading
            ? Center(child: CircularProgressIndicator())
            : errorMessage.isNotEmpty
                ? Text(errorMessage, style: TextStyle(color: Colors.red))
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Jadwal Sholat di Pamekasan', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      Divider(),
                      ...jadwal.entries.map((e) => ListTile(
                            title: Text(e.key),
                            trailing: Text(e.value),
                          )),
                    ],
                  ),
      ),
    );
  }
}
