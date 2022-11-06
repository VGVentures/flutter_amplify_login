import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

/// {@template app_button}
/// Button with text displayed in the application.
/// {@endtemplate}
class AppButton extends StatelessWidget {
  /// {@macro app_button}
  const AppButton({
    super.key,
    required this.child,
    this.onPressed,
    Color? foregroundColor,
    Color? disabledForegroundColor,
    BorderSide? borderSide,
    Size? maximumSize,
    Size? minimumSize,
    EdgeInsets? padding,
  })  : _borderSide = borderSide,
        _foregroundColor = foregroundColor ?? AppColors.black,
        _disabledForegroundColor =
            disabledForegroundColor ?? AppColors.disabledForeground,
        _maximumSize = maximumSize ?? _defaultMaximumSize,
        _minimumSize = minimumSize ?? _defaultMinimumSize,
        _padding = padding ?? _defaultPadding;

  /// The maximum size of the button.
  static const _defaultMaximumSize = Size(double.infinity, 56);

  /// The minimum size of the button.
  static const _defaultMinimumSize = Size(double.infinity, 56);

  /// The padding of the the button.
  static const _defaultPadding = EdgeInsets.fromLTRB(
    AppSpacing.xlg,
    AppSpacing.sm + AppSpacing.xxxs,
    AppSpacing.xlg,
    AppSpacing.md,
  );

  /// [VoidCallback] called when button is pressed.
  /// Button is disabled when null.
  final VoidCallback? onPressed;

  /// Color of the text, icons etc.
  ///
  /// Defaults to [AppColors.black].
  final Color _foregroundColor;

  /// Color of the disabled text, icons etc.
  ///
  /// Defaults to [AppColors.disabledForeground].
  final Color _disabledForegroundColor;

  /// A border of the button.
  final BorderSide? _borderSide;

  /// The maximum size of the button.
  ///
  /// Defaults to [_defaultMaximumSize].
  final Size _maximumSize;

  /// The minimum size of the button.
  ///
  /// Defaults to [_defaultMinimumSize].
  final Size _minimumSize;

  /// The padding of the button.
  ///
  /// Defaults to [EdgeInsets.zero].
  final EdgeInsets _padding;

  /// [Widget] displayed on the button.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.button;

    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        maximumSize: MaterialStateProperty.all(_maximumSize),
        padding: MaterialStateProperty.all(_padding),
        minimumSize: MaterialStateProperty.all(_minimumSize),
        textStyle: MaterialStateProperty.all(textStyle),
        foregroundColor: onPressed == null
            ? MaterialStateProperty.all(_disabledForegroundColor)
            : MaterialStateProperty.all(_foregroundColor),
        side: MaterialStateProperty.all(_borderSide),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      child: child,
    );
  }
}
