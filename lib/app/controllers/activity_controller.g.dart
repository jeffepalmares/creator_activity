// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ActivityController on _ActivityControllerBase, Store {
  Computed<bool>? _$isLoadingComputed;

  @override
  bool get isLoading =>
      (_$isLoadingComputed ??= Computed<bool>(() => super.isLoading,
              name: '_ActivityControllerBase.isLoading'))
          .value;
  Computed<int>? _$listSizeComputed;

  @override
  int get listSize =>
      (_$listSizeComputed ??= Computed<int>(() => super.listSize,
              name: '_ActivityControllerBase.listSize'))
          .value;

  final _$stateAtom = Atom(name: '_ActivityControllerBase.state');

  @override
  ActionState get state {
    _$stateAtom.reportRead();
    return super.state;
  }

  @override
  set state(ActionState value) {
    _$stateAtom.reportWrite(value, super.state, () {
      super.state = value;
    });
  }

  final _$activitiesAtom = Atom(name: '_ActivityControllerBase.activities');

  @override
  ObservableList<ActivityStore> get activities {
    _$activitiesAtom.reportRead();
    return super.activities;
  }

  @override
  set activities(ObservableList<ActivityStore> value) {
    _$activitiesAtom.reportWrite(value, super.activities, () {
      super.activities = value;
    });
  }

  final _$deleteDownloadedActivityAsyncAction =
      AsyncAction('_ActivityControllerBase.deleteDownloadedActivity');

  @override
  Future<void> deleteDownloadedActivity(ActivityStore activity) {
    return _$deleteDownloadedActivityAsyncAction
        .run(() => super.deleteDownloadedActivity(activity));
  }

  final _$downloadActivityAsyncAction =
      AsyncAction('_ActivityControllerBase.downloadActivity');

  @override
  Future<void> downloadActivity(ActivityStore activity) {
    return _$downloadActivityAsyncAction
        .run(() => super.downloadActivity(activity));
  }

  final _$checkFileActivityAsyncAction =
      AsyncAction('_ActivityControllerBase.checkFileActivity');

  @override
  Future<void> checkFileActivity(ActivityDto dto) {
    return _$checkFileActivityAsyncAction
        .run(() => super.checkFileActivity(dto));
  }

  final _$removeActivityAsyncAction =
      AsyncAction('_ActivityControllerBase.removeActivity');

  @override
  Future<void> removeActivity(ActivityDto dto) {
    return _$removeActivityAsyncAction.run(() => super.removeActivity(dto));
  }

  final _$_ActivityControllerBaseActionController =
      ActionController(name: '_ActivityControllerBase');

  @override
  void applyViewConfig() {
    final _$actionInfo = _$_ActivityControllerBaseActionController.startAction(
        name: '_ActivityControllerBase.applyViewConfig');
    try {
      return super.applyViewConfig();
    } finally {
      _$_ActivityControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
state: ${state},
activities: ${activities},
isLoading: ${isLoading},
listSize: ${listSize}
    ''';
  }
}
