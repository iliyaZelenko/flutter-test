import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../main.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  final dateInputController = TextEditingController();
  var checkbox = false;

  /*
    Поля ввода для:
    Текстового поля (только буквы).
    Пароля.
    Даты.
    Цифрового поля.
    Загрузка изображения.
    Кнопка для подтверждения введенных данных.
    Для каждого поля ввода необходима валидация с предупреждением в случае ошибки.
   */
  @override
  Widget build(BuildContext context) {
    return Form(
      child: Layout(
        children: [
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: const InputDecoration(
              labelText: 'Текстовое поле (только буквы)',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Пожалуйста, введите текст';
              }
              return RegExp(r"^[a-zA-Z]+$").hasMatch(value)
                  ? null
                  : 'Пожалуйста, введите только буквы';
            },
          ),
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Пароль',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Пожалуйста, введите пароль';
              }
              return null;
            },
          ),
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: dateInputController,
            decoration: const InputDecoration(
              icon: Icon(Icons.calendar_today),
              labelText: 'Дата',
            ),
            readOnly: true,
            onTap: _onTapDate,
          ),
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: const InputDecoration(
              labelText: 'Цифровое поле',
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              const msg = 'Пожалуйста, введите цифры';

              if (value == null || value.isEmpty) {
                return msg;
              }
              return RegExp(r"^[0-9]+$").hasMatch(value) ? null : msg;
            },
          ),
          const SizedBox(height: 20),
          const FilePickerWidget(),
          const SizedBox(height: 20),
          CheckboxListTile(
            title: const Text('Подтверждение введенных данных'),
            value: checkbox,
            onChanged: (value) {
              setState(() {
                checkbox = value ?? false;
              });
            },
            controlAffinity: ListTileControlAffinity.leading,
          ),
        ],
      ),
    );
  }

  void _onTapDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);

      setState(() {
        dateInputController.text = formattedDate;
      });
    }
  }
}

class FilePickerWidget extends StatefulWidget {
  const FilePickerWidget({super.key});

  @override
  State<FilePickerWidget> createState() => _FilePickerExampleState();
}

class _FilePickerExampleState extends State<FilePickerWidget> {
  PlatformFile? _imageFile;

  Future<void> _pickImage() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );

      if (result == null) return;

      setState(() {
        _imageFile = result.files.first;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (_imageFile != null)
          Image.memory(
            Uint8List.fromList(_imageFile!.bytes!),
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _pickImage,
          child: const Text('Выбрать изображение'),
        ),
      ],
    );
  }
}
