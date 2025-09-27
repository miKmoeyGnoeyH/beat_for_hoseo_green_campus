import 'package:beat_flutter/components/global/widgets/texts/custom_body_large.dart';
import 'package:beat_flutter/components/global/widgets/texts/custom_body_medium.dart';
import 'package:beat_flutter/components/global/widgets/texts/custom_subtitle_large.dart';
import 'package:beat_flutter/extensions/buildcontext_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../theme/texts/custom_texts.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    this.formKey,
    this.textEditingController,
    this.validator,
    this.labelText,
    this.hintText,
    this.keyboardType,
    this.maxLines = 1,
    this.enabled = true,
    this.actions,
    this.onChanged,
    this.maxLength,
    this.inputFormatters,
    this.obscureText = false,
    this.autovalidateMode,
    this.counterText,
    this.focusNode,
    this.ensureErrorTextSpace = false,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();

  final GlobalKey<FormState>? formKey;
  final TextEditingController? textEditingController;
  final String? Function(String?)? validator;
  final String? labelText;
  final String? hintText;
  final int maxLines;
  final TextInputType? keyboardType;
  final bool enabled;
  final List<Widget>? actions;
  final void Function(String)? onChanged;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final bool obscureText;
  final AutovalidateMode? autovalidateMode;
  final String? counterText;
  final FocusNode? focusNode;
  final bool ensureErrorTextSpace;
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> actions = [];
    if (widget.actions != null) {
      for (int i = 0; i < widget.actions!.length; i++) {
        actions.add(widget.actions![i]);
        if (i < widget.actions!.length - 1) {
          actions.add(SizedBox(width: 5.w)); // Add spacing between actions
        }
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelText != null)
          Row(
            children: [
              CustomSubtitleLarge(
                text: widget.labelText!,
              ),
            ],
          ),
        SizedBox(height: 6.w),
        Row(
          children: [
            Flexible(
              child: Form(
                key: widget.formKey,
                child: TextFormField(
                  textAlignVertical: TextAlignVertical.bottom,
                  focusNode: widget.focusNode,
                  errorBuilder: (_, __) => const SizedBox.shrink(),
                  cursorColor: context.appColors.primary,
                  cursorErrorColor: context.appColors.error,
                  enabled: widget.enabled,
                  maxLines: widget.maxLines,
                  maxLength: widget.maxLength,
                  controller: widget.textEditingController,
                  keyboardType: widget.keyboardType,
                  inputFormatters: widget.inputFormatters,
                  obscureText: widget.obscureText,
                  autovalidateMode: widget.autovalidateMode,
                  style: CustomLargeTexts.hintStyle,
                  validator: (value) {
                    final result = widget.validator?.call(value);
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (_errorText != result) {
                        setState(() => _errorText = result);
                      }
                    });
                    return result != null ? "" : null;
                  },
                  // validator: widget.validator,
                  onChanged: (_) => setState(() {
                    widget.onChanged?.call(_);
                    // _errorText = null;
                  }),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: widget.enabled ? context.appColors.surface
                        : context.appColors.onSurface.withValues(alpha: 0.1),
                    contentPadding: EdgeInsets.symmetric(vertical: 5.w),
                    // isDense: true,
                    focusColor: context.appColors.primary,
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: context.appColors.primary,
                        width: 1,
                      ),
                    ),
                    errorBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: context.appColors.error,
                        width: 1,
                      ),
                    ),
                    focusedErrorBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: context.appColors.error,
                        width: 1,
                      ),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: context.appColors.disabled,
                        width: 1,
                      ),
                    ),
                    hintText: widget.hintText,
                    hintStyle: CustomLargeTexts.hintStyle.copyWith(
                      color: context.appColors.disabled,
                    ),
                    errorStyle: CustomLargeTexts.bodyLarge.copyWith(
                      color: context.appColors.error,
                    ),
                    counterText: '',
                    suffix: widget.maxLength != null
                        ? CustomBodyMedium(
                      text: '${widget.textEditingController?.text.length ?? 0}/${widget.maxLength}',
                      textColor: context.appColors.disabled,
                    )
                        : null,
                  ),
                ),
              ),
            ),
            if (widget.actions != null) SizedBox(width: 5.w),
            ...actions,
          ],
        ),
        if (_errorText != null)
          AnimatedSize(
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeInOut,
            child:
            // _errorText != null
            //     ?
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5.w),
              child: CustomBodyLarge(
                text: _errorText!,
                textColor: context.appColors.error,
              ),
            )
                // : SizedBox(height: 49.w), // 최소 한 줄 공간은 차지
          )
        else
          if (widget.ensureErrorTextSpace)
            SizedBox(height: 58.w),
      ],
    );
  }

  String? _errorText;
}
