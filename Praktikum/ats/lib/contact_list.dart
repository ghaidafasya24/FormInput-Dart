import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
// import 'package:intl/intl.dart';
import 'dart:typed_data';
import 'package:open_file/open_file.dart';

class MyInputForm extends StatefulWidget {
  const MyInputForm({super.key});

  @override
  State<MyInputForm> createState() => _MyInputFormState();
}

class _MyInputFormState extends State<MyInputForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final List<Map<String, dynamic>> _myDataList = [];
  final TextEditingController _controllerNama = TextEditingController();
  final TextEditingController _controllerPhone = TextEditingController();
  final TextEditingController _controllerDate = TextEditingController();

  Color _currentColor = Colors.blue; // Default color
  Map<String, dynamic>? editedData;
  File? _imageFile; // Untuk menyimpan file gambar
  String? _dataFile; // Untuk menyimpan nama file
  Uint8List? _imageBytes; // Untuk menyimpan byte dari gambar

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Form Input', //Navbar title
          style: TextStyle(
            color: Colors.white, // Ubah warna teks menjadi putih
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF075E54), // Hijau khas WhatsApp
                Color(0xFF128C7E), // Hijau lebih cerah
                // Color(0xFFA8DADC), // Hijau pastel
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              // Column untuk menampung semua widget
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // INPUT NAME
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _controllerNama, // Hubungkan controller
                    validator: _validateNama, // Panggil method validasi
                    decoration: const InputDecoration(
                      hintText: 'Write your name here...',
                      labelText: 'Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      fillColor: Color.fromARGB(255, 222, 254, 255),
                      filled: true,
                    ),
                  ),
                ),

                // INPUT PHONE NUMBER
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _controllerPhone,
                    keyboardType: TextInputType.phone,
                    validator: _validatePhone, // Panggil method validasi
                    decoration: const InputDecoration(
                      hintText: 'Enter your phone number...',
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      fillColor: Color.fromARGB(255, 255, 240, 220),
                      filled: true,
                    ),
                  ),
                ),

                // INPUT DATE
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _controllerDate,
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1990),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        String formattedDate =
                            "${pickedDate.toLocal()}".split(' ')[0];
                        setState(() {
                          _controllerDate.text =
                              formattedDate; // Set value date
                        });
                      }
                    },
                    validator: _validateDate,
                    decoration: const InputDecoration(
                      hintText: 'Select your date...',
                      labelText: 'Date',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      fillColor: Color.fromARGB(255, 240, 255, 220),
                      filled: true,
                      suffixIcon:
                          Icon(Icons.calendar_today, color: Colors.grey),
                    ),
                  ),
                ),

                // Color Picker
                buildColorPicker(context),

                // File Picker
                buildFilePicker(context),

                // Submit Button
                Align(
                  alignment: Alignment.topCenter,
                  child: ElevatedButton(
                    child: Text(editedData != null ? "Update" : "Submit"),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _addData();
                      }
                    },
                  ),
                ),
                // SizedBox(height: 8), // Menambahkan jarak antara tombol dan teks
                // Text(
                //   "Tes",
                //   style: TextStyle(
                //       fontSize: 14,
                //       color: Colors.black54), // Gaya teks opsional
                // ),

                const SizedBox(height: 20),

                // Centered List Contact Title
                const Center(
                  child: Text(
                    'List Contact',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // Display List Data
                SizedBox(
                  height: 200, // Tentukan ukuran maksimum list
                  child: ListView.builder(
                    itemCount: _myDataList.length,
                    itemBuilder: (context, index) {
                      final data = _myDataList[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: data['imageBytes'] != null
                                ? MemoryImage(data['imageBytes'])
                                    as ImageProvider
                                : const AssetImage('images/ghaida.jpg'),
                          ),
                          title: Text(
                            data['name'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Phone: ${data['phone']}'),
                              Text('Date: ${data['date']}'),
                              const SizedBox(height: 4),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: LinearProgressIndicator(
                                  value: 1.0,
                                  color: data['color'],
                                  backgroundColor:
                                      data['color'].withOpacity(0.3),
                                  minHeight: 8,
                                ),
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon:
                                    const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () {
                                  _editData(data);
                                },
                              ),
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  _deleteData(data);
                                },
                              ),
                            ],
                          ),
                        ),
                      );

                      // SizedBox(height: 8), // Menambahkan jarak antara tombol dan teks
                      // Text(
                      //   "Tes",
                      //   style: TextStyle(
                      //       fontSize: 14,
                      //       color: Colors.black54), // Gaya teks opsional
                      // ),
                    },
                  ),
                  
                ),
                   SizedBox(height: 8), // Menambahkan jarak antara tombol dan teks
                      Text(
                        "Ghaida Fasya",
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.black54), // Gaya teks opsional
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Color Picker Widget
  Widget buildColorPicker(BuildContext context) {
    return Column(
      // Column untuk menampung widget color picker
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Color'),
        const SizedBox(height: 10),
        Container(
          height: 100,
          width: double.infinity,
          color: _currentColor,
        ),
        const SizedBox(height: 10),
        Center(
            child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: _currentColor,
          ),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Pick your color'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ColorPicker(
                        pickerColor: _currentColor,
                        onColorChanged: (color) {
                          setState(() {
                            _currentColor = color;
                          });
                        },
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Save'),
                    ),
                  ],
                );
              },
            );
          },
          child: const Text(
            'Pick Color',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ))
      ],
    );
  }

  // File Picker Widget
  Widget buildFilePicker(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text('Pick File'),
        const SizedBox(height: 10),
        Center(
          child: ElevatedButton(
            onPressed: () {
              _pickFile();
            },
            child: const Text(
              'Pick and Open File',
            ),
          ),
        ),
        if (_dataFile != null) Text('File: $_dataFile'),
        const SizedBox(height: 10),
        if (_imageFile != null)
          Image.memory(
            _imageBytes!,
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
      ],
    );
  }

  // Validation Methods
  String? _validateNama(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nama harus diisi';
    }

    // Cek apakah terdiri dari minimal 2 kata
    List<String> words = value.trim().split(' ');
    if (words.length < 2) {
      // Jika kata kurang dari 2
      return 'Nama harus terdiri dari minimal 2 kata';
    }

    // Cek apakah setiap kata dimulai dengan huruf kapital dan tidak mengandung angka/karakter khusus
    for (String word in words) {
      if (!RegExp(r'^[A-Z][a-zA-Z]*$').hasMatch(word)) {
        return 'Setiap kata harus dimulai dengan huruf kapital dan tidak mengandung angka atau karakter khusus';
      }
    }

    return null;
  }

//validation phone
  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nomor telepon harus diisi';
    }

    // Cek apakah hanya terdiri dari angka
    if (!RegExp(r'^\d+$').hasMatch(value)) {
      return 'Nomor telepon harus terdiri dari angka saja';
    }

    // Cek panjang nomor telepon
    if (value.length < 8 || value.length > 13) {
      return 'Nomor telepon harus memiliki panjang antara 8 hingga 13 digit';
    }

    // Cek apakah dimulai dengan "62"
    if (!value.startsWith('62')) {
      return 'Nomor telepon harus dimulai dengan angka 62';
    }

    return null;
  }

  // Validation Method for Date
  String? _validateDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Tanggal harus diisi';
    }
    return null;
  }

  // Pick File Method
  void _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image, // Hanya pilih file gambar
    );

    if (result != null) {
      final file = result.files.first;

      setState(() {
        _imageBytes = file.bytes; // Simpan byte gambar
        _dataFile = file.name; // Simpan nama file
      });
    }
  }

  // Open File Method
  void _openFile(PlatformFile file) {
    OpenFile.open(file.path);
  }

  void _addData() {
    final data = {
      'name': _controllerNama.text,
      'phone': _controllerPhone.text,
      'date': _controllerDate.text,
      'color': _currentColor,
      'file': _dataFile,
      'imageBytes': _imageBytes, // Tambahkan byte gambar
    };

    setState(() {
      if (editedData != null) {
        editedData!['name'] = data['name'];
        editedData!['phone'] = data['phone'];
        editedData!['date'] = data['date'];
        editedData!['color'] = data['color'];
        editedData!['file'] = data['file'];
        editedData!['imageBytes'] = data['imageBytes'];
        editedData = null;
      } else {
        _myDataList.add(data);
      }
    });

    _clearForm();
  }

  // Clear Form
  void _clearForm() {
    _controllerNama.clear();
    _controllerPhone.clear();
    _controllerDate.clear();
    _currentColor = Colors.blue;
    _imageFile = null;
    _dataFile = null;
  }

  // EDIT DATA
  void _editData(Map<String, dynamic> data) {
    setState(() {
      editedData = data;
      _controllerNama.text = data['name'];
      _controllerPhone.text = data['phone'];
      _controllerDate.text = data['date'];
      _currentColor = Color(
          int.parse(data['color'].split('(0x')[1].split(')')[0], radix: 16));
      _dataFile = data['file'];
    });
  }

  // DELETE DATA
  void _deleteData(Map<String, dynamic> data) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Data'),
          content: const Text('Apakah Anda yakin ingin menghapus data ini?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Batal'), // Jika tidak jadi hapus
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _myDataList.remove(data);
                });
                Navigator.of(context).pop();
              },
              child: const Text('Hapus'), // Jika jadi hapus
            ),
          ],
        );
      },
    );
  }
}
