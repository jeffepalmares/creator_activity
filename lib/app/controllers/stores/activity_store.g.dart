// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ActivityStore on _ActivityStore, Store {
  final _$isDownloadingAtom = Atom(name: '_ActivityStore.isDownloading');

  @override
  bool get isDownloading {
    _$isDownloadingAtom.reportRead();
    return super.isDownloading;
  }

  @override
  set isDownloading(bool value) {
    _$isDownloadingAtom.reportWrite(value, super.isDownloading, () {
      super.isDownloading = value;
    });
  }

  final _$isDownloadedAtom = Atom(name: '_ActivityStore.isDownloaded');

  @override
  bool get isDownloaded {
    _$isDownloadedAtom.reportRead();
    return super.isDownloaded;
  }

  @override
  set isDownloaded(bool value) {
    _$isDownloadedAtom.reportWrite(value, super.isDownloaded, () {
      super.isDownloaded = value;
    });
  }

  final _$hasScoreAtom = Atom(name: '_ActivityStore.hasScore');

  @override
  bool get hasScore {
    _$hasScoreAtom.reportRead();
    return super.hasScore;
  }

  @override
  set hasScore(bool value) {
    _$hasScoreAtom.reportWrite(value, super.hasScore, () {
      super.hasScore = value;
    });
  }

  final _$downloadingPercentAtom =
      Atom(name: '_ActivityStore.downloadingPercent');

  @override
  String get downloadingPercent {
    _$downloadingPercentAtom.reportRead();
    return super.downloadingPercent;
  }

  @override
  set downloadingPercent(String value) {
    _$downloadingPercentAtom.reportWrite(value, super.downloadingPercent, () {
      super.downloadingPercent = value;
    });
  }

  final _$scoreAtom = Atom(name: '_ActivityStore.score');

  @override
  String get score {
    _$scoreAtom.reportRead();
    return super.score;
  }

  @override
  set score(String value) {
    _$scoreAtom.reportWrite(value, super.score, () {
      super.score = value;
    });
  }

  final _$_ActivityStoreActionController =
      ActionController(name: '_ActivityStore');

  @override
  dynamic setScore() {
    final _$actionInfo = _$_ActivityStoreActionController.startAction(
        name: '_ActivityStore.setScore');
    try {
      return super.setScore();
    } finally {
      _$_ActivityStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isDownloading: ${isDownloading},
isDownloaded: ${isDownloaded},
hasScore: ${hasScore},
downloadingPercent: ${downloadingPercent},
score: ${score}
    ''';
  }
}
