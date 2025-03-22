// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'player_provider_list.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$PlayerProviderListState {
  List<NotifierProviderImpl> get list => throw _privateConstructorUsedError;
  bool get loading => throw _privateConstructorUsedError;
  int get selected => throw _privateConstructorUsedError;

  /// Create a copy of PlayerProviderListState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PlayerProviderListStateCopyWith<PlayerProviderListState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlayerProviderListStateCopyWith<$Res> {
  factory $PlayerProviderListStateCopyWith(PlayerProviderListState value,
          $Res Function(PlayerProviderListState) then) =
      _$PlayerProviderListStateCopyWithImpl<$Res, PlayerProviderListState>;
  @useResult
  $Res call({List<NotifierProviderImpl> list, bool loading, int selected});
}

/// @nodoc
class _$PlayerProviderListStateCopyWithImpl<$Res,
        $Val extends PlayerProviderListState>
    implements $PlayerProviderListStateCopyWith<$Res> {
  _$PlayerProviderListStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PlayerProviderListState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? list = null,
    Object? loading = null,
    Object? selected = null,
  }) {
    return _then(_value.copyWith(
      list: null == list
          ? _value.list
          : list // ignore: cast_nullable_to_non_nullable
              as List<NotifierProviderImpl>,
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      selected: null == selected
          ? _value.selected
          : selected // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PlayerProviderListStateImplCopyWith<$Res>
    implements $PlayerProviderListStateCopyWith<$Res> {
  factory _$$PlayerProviderListStateImplCopyWith(
          _$PlayerProviderListStateImpl value,
          $Res Function(_$PlayerProviderListStateImpl) then) =
      __$$PlayerProviderListStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<NotifierProviderImpl> list, bool loading, int selected});
}

/// @nodoc
class __$$PlayerProviderListStateImplCopyWithImpl<$Res>
    extends _$PlayerProviderListStateCopyWithImpl<$Res,
        _$PlayerProviderListStateImpl>
    implements _$$PlayerProviderListStateImplCopyWith<$Res> {
  __$$PlayerProviderListStateImplCopyWithImpl(
      _$PlayerProviderListStateImpl _value,
      $Res Function(_$PlayerProviderListStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of PlayerProviderListState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? list = null,
    Object? loading = null,
    Object? selected = null,
  }) {
    return _then(_$PlayerProviderListStateImpl(
      list: null == list
          ? _value._list
          : list // ignore: cast_nullable_to_non_nullable
              as List<NotifierProviderImpl>,
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      selected: null == selected
          ? _value.selected
          : selected // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$PlayerProviderListStateImpl implements _PlayerProviderListState {
  _$PlayerProviderListStateImpl(
      {required final List<NotifierProviderImpl> list,
      required this.loading,
      required this.selected})
      : _list = list;

  final List<NotifierProviderImpl> _list;
  @override
  List<NotifierProviderImpl> get list {
    if (_list is EqualUnmodifiableListView) return _list;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_list);
  }

  @override
  final bool loading;
  @override
  final int selected;

  @override
  String toString() {
    return 'PlayerProviderListState(list: $list, loading: $loading, selected: $selected)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlayerProviderListStateImpl &&
            const DeepCollectionEquality().equals(other._list, _list) &&
            (identical(other.loading, loading) || other.loading == loading) &&
            (identical(other.selected, selected) ||
                other.selected == selected));
  }

  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_list), loading, selected);

  /// Create a copy of PlayerProviderListState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlayerProviderListStateImplCopyWith<_$PlayerProviderListStateImpl>
      get copyWith => __$$PlayerProviderListStateImplCopyWithImpl<
          _$PlayerProviderListStateImpl>(this, _$identity);
}

abstract class _PlayerProviderListState implements PlayerProviderListState {
  factory _PlayerProviderListState(
      {required final List<NotifierProviderImpl> list,
      required final bool loading,
      required final int selected}) = _$PlayerProviderListStateImpl;

  @override
  List<NotifierProviderImpl> get list;
  @override
  bool get loading;
  @override
  int get selected;

  /// Create a copy of PlayerProviderListState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlayerProviderListStateImplCopyWith<_$PlayerProviderListStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
