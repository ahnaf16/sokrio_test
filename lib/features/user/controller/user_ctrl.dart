import 'package:linkify/features/user/repository/user_repo.dart';
import 'package:linkify/main.export.dart';
import 'package:linkify/models/paged_item.dart';
import 'package:linkify/models/user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_ctrl.g.dart';

@Riverpod(keepAlive: true)
class UserCtrl extends _$UserCtrl {
  final _repo = locate<UserRepo>();
  PagedItem<User>? _cached;
  @override
  FutureOr<PagedItem<User>> build() async {
    final res = await _repo.getUsers(1);
    return res.fold((l) => Toaster.showError(l).andReturn(PagedItem.empty()), (r) {
      _cached = r;
      return r;
    });
  }

  Future<void> search(String query) async {
    final current = await future;
    final list = current.data;
    final q = query.trim().toLowerCase();

    if (q.isEmpty) {
      state = AsyncValue.data(_cached ?? current);
      return;
    }

    final filtered = list
        .where((e) => e.firstName.low.contains(q) || e.lastName.low.contains(q) || e.email.low.contains(q))
        .toList();
    state = AsyncValue.data(current.copyWith(data: filtered));
  }

  Future<void> refresh() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async => build());
  }

  /// returns true if has more data
  Future<bool> loadNext() async {
    final current = await future;

    final res = await _repo.getUsers(current.page + 1);
    return res.fold((l) => Toaster.showError(l).andReturn(false), (r) {
      final joinWithNew = current.joinWithNew(r);
      _cached = joinWithNew;
      state = AsyncValue.data(joinWithNew);

      return r.page < r.totalPages;
    });
  }
}
