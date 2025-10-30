import 'package:whisperwall/pages/beranda.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:table_calendar/table_calendar.dart';

class CatatanPages extends StatefulWidget {
  final dynamic userData;

  CatatanPages({required this.userData});

  @override
  _CatatanPagesState createState() => _CatatanPagesState();
}

class _CatatanPagesState extends State<CatatanPages> {
  late DateTime _selectedDate;
  late TextEditingController _noteController;
  late SupabaseClient _supabaseClient;
  List<Map<String, dynamic>> _catatanList = [];
  bool _isLoading = false;

  final String supabaseUrl = 'https://gqufqkpovhxfoutlpzeu.supabase.co';
  final String supabaseKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdxdWZxa3Bvdmh4Zm91dGxwemV1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzUzNjk2MDcsImV4cCI6MjA1MDk0NTYwN30.yFvdOB_T1TU6PhI19hmOQZ-u6_CsA2-XTYRHfGD7GiM';

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _noteController = TextEditingController();
    _supabaseClient = SupabaseClient(supabaseUrl, supabaseKey);
    _fetchNoteDetail();
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _saveNote() async {
    if (_noteController.text.isNotEmpty) {
      try {
        final formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate);

        final response = await _supabaseClient.from('catatan').insert([
          {
            'id_user': widget.userData['id'],
            'tanggal': formattedDate,
            'catatan': _noteController.text,
          }
        ]);

        if (response.error != null) {
          throw Exception('Error saving note: ${response.error?.message}');
        }

        setState(() {
          _catatanList.insert(0, {
            'catatan': _noteController.text,
            'tanggal': formattedDate,
          });
        });

        _noteController.clear();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Catatan berhasil disimpan')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan catatan')),
        );
      }
    }
  }

  Future<void> _fetchNoteDetail() async {
    try {
      setState(() {
        _isLoading = true;
        _catatanList.clear();
      });

      final startOfMonth = DateTime(_selectedDate.year, _selectedDate.month, 1);
      final endOfMonth =
          DateTime(_selectedDate.year, _selectedDate.month + 1, 0);

      final response = await _supabaseClient
          .from('catatan')
          .select('catatan, tanggal')
          .eq('id_user', widget.userData['id'])
          .gte('tanggal', DateFormat('yyyy-MM-dd').format(startOfMonth))
          .lte('tanggal', DateFormat('yyyy-MM-dd').format(endOfMonth))
          .order('tanggal', ascending: true);

      if (response.isNotEmpty) {
        setState(() {
          _catatanList = List<Map<String, dynamic>>.from(response.map((note) {
            return {
              'catatan': note['catatan'],
              'tanggal': note['tanggal'],
            };
          }));
        });
      } else {
        setState(() {
          _catatanList = [];
        });
      }
    } catch (e) {
      setState(() {
        _catatanList = [
          {'catatan': 'Terjadi kesalahan: $e', 'tanggal': ''},
        ];
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteNote(Map<String, dynamic> catatan) async {
    try {
      final response = await _supabaseClient
          .from('catatan')
          .delete()
          .eq('id_user', widget.userData['id'])
          .eq('tanggal', catatan['tanggal'])
          .eq('catatan', catatan['catatan']);

      if (response.error != null) {
        throw Exception('Error deleting note: ${response.error?.message}');
      }

      setState(() {
        _catatanList.remove(catatan);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Catatan berhasil dihapus')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              'Catatan',
              style: TextStyle(
                color: Color.fromARGB(255, 1, 4, 96),
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacer(),
            Text(
              'Selamat datang, ${widget.userData['nama']}!',
              style: TextStyle(
                color: Color.fromARGB(255, 1, 4, 96),
                fontSize: 14.0,
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.home,
                color: Color.fromARGB(255, 1, 4, 96),
                size: 30.0,
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Beranda(userData: widget.userData),
                  ),
                );
              },
            ),
          ],
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/bb.jpeg'),
              fit: BoxFit.cover,
              alignment: Alignment.center,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TableCalendar(
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: _selectedDate,
                  selectedDayPredicate: (day) => isSameDay(day, _selectedDate),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDate = selectedDay;
                    });
                    _fetchNoteDetail();
                  },
                  calendarStyle: CalendarStyle(
                    todayTextStyle:
                        TextStyle(color: Color.fromARGB(255, 1, 4, 96)),
                    selectedTextStyle: TextStyle(color: Colors.white),
                    selectedDecoration: BoxDecoration(
                      color: Color.fromARGB(255, 1, 4, 96),
                      shape: BoxShape.circle,
                    ),
                    todayDecoration: BoxDecoration(
                      color: Colors.blue[100],
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Tanggal: ${DateFormat('yyyy-MM-dd').format(_selectedDate)}',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Color.fromARGB(255, 1, 4, 96)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    controller: _noteController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: 'Tuliskan catatan...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saveNote,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 1, 4, 96),
                  ),
                  child: Text(
                    'Simpan Catatan',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(height: 20),
                _isLoading
                    ? CircularProgressIndicator()
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Catatan untuk bulan ${DateFormat('MMMM yyyy').format(_selectedDate)}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          _catatanList.isEmpty
                              ? Text('Tidak ada catatan untuk bulan ini.')
                              : Column(
                                  children: _catatanList.map((catatan) {
                                    DateTime noteDate =
                                        DateTime.parse(catatan['tanggal']);
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 8.0),
                                      child: Container(
                                        width: double.infinity,
                                        padding: EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(
                                            color:
                                                Color.fromARGB(255, 1, 4, 96),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    DateFormat('yyyy-MM-dd')
                                                        .format(noteDate),
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  SizedBox(height: 8),
                                                  Text(
                                                    catatan['catatan'],
                                                    style:
                                                        TextStyle(fontSize: 16),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            IconButton(
                                              icon: Icon(Icons.delete,
                                                  color: Colors.red),
                                              onPressed: () {
                                                _deleteNote(catatan);
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                        ],
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
