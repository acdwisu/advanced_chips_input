import 'package:advanced_chips_input/src/text_form_field_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// The [AdvancedChipsInput] widget is a text field that allows the user to input and create chips out of it.
class AdvancedChipsInput extends StatefulWidget {
  /// Creates a [AdvancedChipsInput] widget.
  ///
  const AdvancedChipsInput({
    required this.separatorCharacter,
    super.key,
    this.placeChipsSectionAbove = true,
    this.widgetContainerDecoration = const BoxDecoration(),
    this.marginBetweenChips = const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
    this.paddingInsideChipContainer = const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
    this.paddingInsideWidgetContainer = const EdgeInsets.all(8),
    this.chipContainerDecoration = const BoxDecoration(
      color: Colors.blue,
      borderRadius: BorderRadius.all(Radius.circular(50)),
    ),
    this.textFormFieldStyle = const TextFormFieldStyle(),
    this.chipTextStyle = const TextStyle(color: Colors.white),
    this.focusNode,
    this.autoFocus = false,
    this.controller,
    this.createCharacter = ' ',
    this.deleteIcon,
    this.validateInput = false,
    this.validateInputMethod,
    this.eraseKeyLabel = 'Backspace',
    this.formKey,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.onSaved,
    this.onChipDeleted,
    this.inputFormatters,
  });

  final List<TextInputFormatter>? inputFormatters;

  /// Character to separate the output. For example: ' ' will seperate the output by space.
  final String separatorCharacter;

  /// Whether to place the chips section above or below the text field.
  final bool placeChipsSectionAbove;

  /// Decoration for the main widget container.
  final BoxDecoration widgetContainerDecoration;

  /// Margin between the chips.
  final EdgeInsets marginBetweenChips;

  /// Padding inside the chip container.
  final EdgeInsets paddingInsideChipContainer;

  /// Padding inside the main widget container;
  final EdgeInsets paddingInsideWidgetContainer;

  /// Decoration for the chip container.
  final BoxDecoration chipContainerDecoration;

  /// FocusNode for the text field.
  final FocusNode? focusNode;

  /// Controller for the textfield.
  final TextEditingController? controller;

  /// The input character used for creating a chip.
  final String createCharacter;

  /// Text style for the chip.
  final TextStyle chipTextStyle;

  /// Icon for the delete method.
  final Widget? deleteIcon;

  /// Whether to validate input before adding to a chip.
  final bool validateInput;

  /// Validation method.
  final dynamic Function(String)? validateInputMethod;

  /// The key label used for erasing a chip. Defaults to Backspace.
  final String eraseKeyLabel;

  /// Whether to autofocus the widget.
  final bool autoFocus;

  /// Form key to access or validate the form outside the widget.
  final GlobalKey<FormState>? formKey;

  /// Style for the textfield.
  final TextFormFieldStyle textFormFieldStyle;

  final void Function(String)? onChanged;
  final void Function()? onEditingComplete;
  final void Function(String)? onSubmitted;
  final void Function(String)? onSaved;

  /// Callback when a chip is deleted. Returns the deleted chip content and index.
  final void Function(String, int)? onChipDeleted;

  @override
  State<AdvancedChipsInput> createState() => _AdvancedChipsInputState();
}

class _AdvancedChipsInputState extends State<AdvancedChipsInput> {
  late final TextEditingController _controller;

  // ignore: prefer_typing_uninitialized_variables
  late final GlobalKey<FormState>? _formKey;
  final List<String> _chipsText = [];
  late final FocusNode _textfieldFocusNode;
  late final FocusNode _keyBoardEventFocusNode;

  String _output = '';

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _formKey = widget.formKey ?? GlobalKey<FormState>();
    _textfieldFocusNode = widget.focusNode ?? FocusNode();
    _keyBoardEventFocusNode = FocusNode();
    if (_controller.text.isNotEmpty) {
      final values = _controller.text.split(widget.separatorCharacter);
      for (final value in values) {
        _chipsText.add(value.trim());
      }

      _controller.text = '';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _textfieldFocusNode.dispose();
    _keyBoardEventFocusNode.dispose();
    super.dispose();
  }

  List<Widget> _buildChipsSection() {
    final chips = <Widget>[];
    for (var i = 0; i < _chipsText.length; i++) {
      chips.add(
        Container(
          padding: widget.paddingInsideChipContainer,
          margin: widget.marginBetweenChips,
          decoration: widget.chipContainerDecoration,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  _chipsText[i],
                  style: widget.chipTextStyle,
                ),
              ),
              if (widget.deleteIcon != null)
                GestureDetector(
                  onTap: () {
                    widget.onChipDeleted?.call(_chipsText[i], i);

                    setState(() {
                      _chipsText.removeAt(i);
                    });
                    final value = _chipsText.join(widget.separatorCharacter);
                    widget.onSubmitted?.call(value);
                  },
                  child: widget.deleteIcon,
                ),
            ],
          ),
        ),
      );
    }
    return chips;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        padding: widget.paddingInsideWidgetContainer,
        decoration: widget.widgetContainerDecoration,
        child: SingleChildScrollView(
          child: Wrap(
            children: [
              if (widget.placeChipsSectionAbove) ...[
                ..._buildChipsSection(),
              ],
              KeyboardListener(
                focusNode: _keyBoardEventFocusNode,
                onKeyEvent: (event) {
                  if (event.logicalKey.keyLabel == widget.eraseKeyLabel) {
                    if (_controller.text.isEmpty && _chipsText.isNotEmpty) {
                      setState(_chipsText.removeLast);
                    }
                  }
                },
                child: TextFormField(
                  autofocus: widget.autoFocus,
                  focusNode: _textfieldFocusNode,
                  controller: _controller,
                  keyboardType: widget.textFormFieldStyle.keyboardType,
                  maxLines: widget.textFormFieldStyle.maxLines,
                  minLines: widget.textFormFieldStyle.minLines,
                  enableSuggestions: widget.textFormFieldStyle.enableSuggestions,
                  showCursor: widget.textFormFieldStyle.showCursor,
                  cursorWidth: widget.textFormFieldStyle.cursorWidth,
                  cursorColor: widget.textFormFieldStyle.cursorColor,
                  cursorRadius: widget.textFormFieldStyle.cursorRadius,
                  cursorHeight: widget.textFormFieldStyle.cursorHeight,
                  inputFormatters: widget.inputFormatters,
                  onChanged: (value) {
                    if (value.endsWith(widget.createCharacter)) {
                      _controller
                        ..text = _controller.text.substring(0, _controller.text.length - 1)
                        ..selection = TextSelection.fromPosition(
                          TextPosition(offset: _controller.text.length),
                        );
                      if (_formKey!.currentState!.validate()) {
                        setState(() {
                          _chipsText.add(_controller.text);
                          _controller.clear();
                        });
                      }
                    }
                    widget.onChanged?.call(value);
                  },
                  decoration: widget.textFormFieldStyle.decoration,
                  validator: (value) {
                    if (widget.validateInput && widget.validateInputMethod != null) {
                      return widget.validateInputMethod!(value!) as String?;
                    }
                    return null;
                  },
                  onEditingComplete: () {
                    widget.onEditingComplete?.call();
                  },
                  onFieldSubmitted: (value) {
                    _output = '';
                    for (final text in _chipsText) {
                      // ignore: use_string_buffers
                      _output += text + widget.separatorCharacter;
                    }
                    if (value.isNotEmpty) {
                      if (_formKey!.currentState!.validate()) {
                        setState(() {
                          _chipsText.add(_controller.text);
                          _output += _controller.text + widget.separatorCharacter;
                          _controller.clear();
                        });
                      }
                    }
                    widget.onSubmitted?.call(_output);
                  },
                  onSaved: (value) {
                    _output = '';
                    for (final text in _chipsText) {
                      // ignore: use_string_buffers
                      _output += text + widget.separatorCharacter;
                    }
                    if (value!.isNotEmpty) {
                      if (_formKey!.currentState!.validate()) {
                        setState(() {
                          _chipsText.add(_controller.text);
                          _output += _controller.text + widget.separatorCharacter;
                          _controller.clear();
                        });
                      }
                    }
                    widget.onSaved?.call(_output);
                  },
                ),
              ),
              if (!widget.placeChipsSectionAbove) ...[
                ..._buildChipsSection(),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
