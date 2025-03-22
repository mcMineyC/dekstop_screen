import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'theme.g.dart';
part 'theme.freezed.dart';

@freezed
class ThemeModel with _$ThemeModel {
  const ThemeModel._();
  factory ThemeModel({
    required bool dark,
    required Color color
  }) = _ThemeModel;
  factory ThemeModel.standard() => ThemeModel(dark: true, color: Colors.blue[500]!);
  ThemeData getTheme() => ThemeData(
    fontFamily: "JetBrainsNerdMono",
    colorScheme: ColorScheme.fromSeed(
      brightness: dark ? Brightness.dark : Brightness.light,
      seedColor: color
    ),
  );
}

@Riverpod(keepAlive: true)
class ThemeHandler extends _$ThemeHandler {
  @override
  ThemeModel build() => ThemeModel.standard();
  bool get dark => state.dark;
  Color get color => state.color;
  set dark(bool value) {
    state = state.copyWith(dark: value);
  }
  set color(Color value) {
    state = state.copyWith(color: value);
  }
}

