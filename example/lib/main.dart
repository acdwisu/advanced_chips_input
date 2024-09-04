import 'package:advanced_chips_input/advanced_chips_input.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Advanced Chips Input Example'),
        ),
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: AdvancedChipsInput(
                separatorCharacter: ' ',
                placeChipsSectionAbove: true,
                widgetContainerDecoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                ),
                chipContainerDecoration: const BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                ),
                chipTextStyle: const TextStyle(color: Colors.white),
                validateInput: true,
                validateInputMethod: (value) {
                  if (value.length < 3) {
                    return 'Input should be at least 3 characters long';
                  }
                  return null;
                },
                onChipDeleted: (chipText, index) {
                  print('Deleted chip: $chipText at index $index');
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: AdvancedChipsInput(
                separatorCharacter: ' ',
                placeChipsSectionAbove: true,
                widgetContainerDecoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                ),
                chipContainerDecoration: const BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                ),
                chipTextStyle: const TextStyle(color: Colors.white),
                validateInput: true,
                validateInputMethod: (value) {
                  if (value.length < 3) {
                    return 'Input should be at least 3 characters long';
                  }
                  return null;
                },
                onChipDeleted: (chipText, index) {
                  print('Deleted chip: $chipText at index $index');
                },
                textFormFieldStyle: TextFormFieldStyle(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  margin: EdgeInsets.only(
                    top: 12
                  )
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
