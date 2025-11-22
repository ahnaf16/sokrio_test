// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_ctrl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(UserCtrl)
const userCtrlProvider = UserCtrlProvider._();

final class UserCtrlProvider
    extends $AsyncNotifierProvider<UserCtrl, PagedItem<User>> {
  const UserCtrlProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userCtrlProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userCtrlHash();

  @$internal
  @override
  UserCtrl create() => UserCtrl();
}

String _$userCtrlHash() => r'70918296c7dfe9533c80fbf3e743ad22e0a758c0';

abstract class _$UserCtrl extends $AsyncNotifier<PagedItem<User>> {
  FutureOr<PagedItem<User>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<PagedItem<User>>, PagedItem<User>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<PagedItem<User>>, PagedItem<User>>,
              AsyncValue<PagedItem<User>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
