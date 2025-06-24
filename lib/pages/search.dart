import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  bool loading = false;
  Map<String, String> jadwal = {};
  String errorMessage = '';
  String? cityName;

  Future<void> fetchJadwal(String city) async {
    setState(() {
      loading = true;
      jadwal = {};
      errorMessage = '';
    });

    try {
      final url = Uri.parse('http://api.aladhan.com/v1/timingsByCity?city=$city&country=Indonesia&method=2');
      final res = await http.get(url);
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final waktu = data['data']['timings'];
        setState(() {
          cityName = city;
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

  void handleSearch() {
    final city = _controller.text.trim();
    if (city.isNotEmpty) {
      fetchJadwal(city);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cari Jadwal Sholat')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              onSubmitted: (_) => handleSearch(),
              decoration: InputDecoration(
                hintText: 'Masukkan nama kota',
                suffixIcon: IconButton(icon: Icon(Icons.search), onPressed: handleSearch),
              ),
            ),
            SizedBox(height: 20),
            if (loading)
              CircularProgressIndicator()
            else if (errorMessage.isNotEmpty)
              Text(errorMessage, style: TextStyle(color: Colors.red))
            else if (jadwal.isNotEmpty)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Jadwal Sholat di ${cityName ?? "-"}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    Divider(),
                    ...jadwal.entries.map((e) => ListTile(title: Text(e.key), trailing: Text(e.value))),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}