// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'player_instance.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$PlayerState {
  String get title => throw _privateConstructorUsedError;
  String get artist => throw _privateConstructorUsedError;
  String get album => throw _privateConstructorUsedError;
  String get imageUrl => throw _privateConstructorUsedError;
  Duration get duration => throw _privateConstructorUsedError;
  Duration get position => throw _privateConstructorUsedError;
  String get friendlyName => throw _privateConstructorUsedError;
  PlaybackState get playbackState => throw _privateConstructorUsedError;
  ConnectionState get connectionState => throw _privateConstructorUsedError;

  /// Create a copy of PlayerState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PlayerStateCopyWith<PlayerState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlayerStateCopyWith<$Res> {
  factory $PlayerStateCopyWith(
          PlayerState value, $Res Function(PlayerState) then) =
      _$PlayerStateCopyWithImpl<$Res, PlayerState>;
  @useResult
  $Res call(
      {String title,
      String artist,
      String album,
      String imageUrl,
      Duration duration,
      Duration position,
      String friendlyName,
      PlaybackState playbackState,
      ConnectionState connectionState});
}

/// @nodoc
class _$PlayerStateCopyWithImpl<$Res, $Val extends PlayerState>
    implements $PlayerStateCopyWith<$Res> {
  _$PlayerStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PlayerState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? artist = null,
    Object? album = null,
    Object? imageUrl = null,
    Object? duration = null,
    Object? position = null,
    Object? friendlyName = null,
    Object? playbackState = null,
    Object? connectionState = null,
  }) {
    return _then(_value.copyWith(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      artist: null == artist
          ? _value.artist
          : artist // ignore: cast_nullable_to_non_nullable
              as String,
      album: null == album
          ? _value.album
          : album // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: null == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as Duration,
      position: null == position
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as Duration,
      friendlyName: null == friendlyName
          ? _value.friendlyName
          : friendlyName // ignore: cast_nullable_to_non_nullable
              as String,
      playbackState: null == playbackState
          ? _value.playbackState
          : playbackState // ignore: cast_nullable_to_non_nullable
              as PlaybackState,
      connectionState: null == connectionState
          ? _value.connectionState
          : connectionState // ignore: cast_nullable_to_non_nullable
              as ConnectionState,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PlayerStateImplCopyWith<$Res>
    implements $PlayerStateCopyWith<$Res> {
  factory _$$PlayerStateImplCopyWith(
          _$PlayerStateImpl value, $Res Function(_$PlayerStateImpl) then) =
      __$$PlayerStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String title,
      String artist,
      String album,
      String imageUrl,
      Duration duration,
      Duration position,
      String friendlyName,
      PlaybackState playbackState,
      ConnectionState connectionState});
}

/// @nodoc
class __$$PlayerStateImplCopyWithImpl<$Res>
    extends _$PlayerStateCopyWithImpl<$Res, _$PlayerStateImpl>
    implements _$$PlayerStateImplCopyWith<$Res> {
  __$$PlayerStateImplCopyWithImpl(
      _$PlayerStateImpl _value, $Res Function(_$PlayerStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of PlayerState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? artist = null,
    Object? album = null,
    Object? imageUrl = null,
    Object? duration = null,
    Object? position = null,
    Object? friendlyName = null,
    Object? playbackState = null,
    Object? connectionState = null,
  }) {
    return _then(_$PlayerStateImpl(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      artist: null == artist
          ? _value.artist
          : artist // ignore: cast_nullable_to_non_nullable
              as String,
      album: null == album
          ? _value.album
          : album // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: null == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as Duration,
      position: null == position
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as Duration,
      friendlyName: null == friendlyName
          ? _value.friendlyName
          : friendlyName // ignore: cast_nullable_to_non_nullable
              as String,
      playbackState: null == playbackState
          ? _value.playbackState
          : playbackState // ignore: cast_nullable_to_non_nullable
              as PlaybackState,
      connectionState: null == connectionState
          ? _value.connectionState
          : connectionState // ignore: cast_nullable_to_non_nullable
              as ConnectionState,
    ));
  }
}

/// @nodoc

class _$PlayerStateImpl extends _PlayerState {
  const _$PlayerStateImpl(
      {required this.title,
      required this.artist,
      required this.album,
      required this.imageUrl,
      required this.duration,
      required this.position,
      required this.friendlyName,
      required this.playbackState,
      required this.connectionState})
      : super._();

  @override
  final String title;
  @override
  final String artist;
  @override
  final String album;
  @override
  final String imageUrl;
  @override
  final Duration duration;
  @override
  final Duration position;
  @override
  final String friendlyName;
  @override
  final PlaybackState playbackState;
  @override
  final ConnectionState connectionState;

  @override
  String toString() {
    return 'PlayerState(title: $title, artist: $artist, album: $album, imageUrl: $imageUrl, duration: $duration, position: $position, friendlyName: $friendlyName, playbackState: $playbackState, connectionState: $connectionState)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlayerStateImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.artist, artist) || other.artist == artist) &&
            (identical(other.album, album) || other.album == album) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.position, position) ||
                other.position == position) &&
            (identical(other.friendlyName, friendlyName) ||
                other.friendlyName == friendlyName) &&
            (identical(other.playbackState, playbackState) ||
                other.playbackState == playbackState) &&
            (identical(other.connectionState, connectionState) ||
                other.connectionState == connectionState));
  }

  @override
  int get hashCode => Object.hash(runtimeType, title, artist, album, imageUrl,
      duration, position, friendlyName, playbackState, connectionState);

  /// Create a copy of PlayerState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlayerStateImplCopyWith<_$PlayerStateImpl> get copyWith =>
      __$$PlayerStateImplCopyWithImpl<_$PlayerStateImpl>(this, _$identity);
}

abstract class _PlayerState extends PlayerState {
  const factory _PlayerState(
      {required final String title,
      required final String artist,
      required final String album,
      required final String imageUrl,
      required final Duration duration,
      required final Duration position,
      required final String friendlyName,
      required final PlaybackState playbackState,
      required final ConnectionState connectionState}) = _$PlayerStateImpl;
  const _PlayerState._() : super._();

  @override
  String get title;
  @override
  String get artist;
  @override
  String get album;
  @override
  String get imageUrl;
  @override
  Duration get duration;
  @override
  Duration get position;
  @override
  String get friendlyName;
  @override
  PlaybackState get playbackState;
  @override
  ConnectionState get connectionState;

  /// Create a copy of PlayerState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlayerStateImplCopyWith<_$PlayerStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
