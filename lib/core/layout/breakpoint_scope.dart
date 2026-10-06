import 'package:catbreeds/core/constants/app_layout.dart';
import 'package:flutter/widgets.dart';

enum Breakpoint { compact, expanded }

class BreakpointScope extends InheritedWidget {
  const BreakpointScope({
    required this.breakpoint,
    required super.child,
    super.key,
  });

  final Breakpoint breakpoint;

  static Breakpoint of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<BreakpointScope>();
    return scope?.breakpoint ?? Breakpoint.compact;
  }

  static Breakpoint fromWidth(double width) {
    return width >= AppMeasure.expanded
        ? Breakpoint.expanded
        : Breakpoint.compact;
  }

  @override
  bool updateShouldNotify(BreakpointScope oldWidget) {
    return breakpoint != oldWidget.breakpoint;
  }
}
