import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldBorder extends StatelessWidget {
  const TextFieldBorder({
    super.key,
    this.controller,
    this.hint,
    this.textType,
    this.maxline,
    this.validator,
    this.maxLength,
    this.borderRadius,
    this.readOnly = false,
    this.inputFormatters,
    this.onChanged,
    this.icon,
    this.textInputAction = TextInputAction.done,
  });

  final String? hint;
  final TextInputType? textType;
  final int? maxline;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final int? maxLength;
  final bool readOnly;
  final double? borderRadius;
  final Widget? icon;
  final void Function(String)? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius ?? 5.0),
      ),
      color: readOnly ? Colors.grey.shade300 : Colors.white,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: 8,
          left: 16,
          right: icon == null ? 16 : 12,
          top: 8,
        ),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                onChanged: onChanged,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                readOnly: readOnly,
                validator: validator,
                controller: controller,
                keyboardType: textType,
                maxLines: maxline,
                maxLength: maxLength,
                textInputAction: textInputAction,
                style: Theme.of(context).textTheme.subtitle1,
                inputFormatters: inputFormatters,
                decoration: InputDecoration(
                  counterText: '',
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  hintText: hint,
                  errorStyle: Theme.of(context).textTheme.subtitle1?.copyWith(
                        color: Theme.of(context).errorColor,
                        //height: .3,
                      ),
                  hintStyle: Theme.of(context).textTheme.subtitle1,
                ),
              ),
            ),
            icon ?? const SizedBox.shrink()
          ],
        ),
      ),
    );
  }
}
