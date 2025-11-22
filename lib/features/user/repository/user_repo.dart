import 'package:linkify/main.export.dart';
import 'package:linkify/models/paged_item.dart';
import 'package:linkify/models/user.dart';

class UserRepo with ApiHandler {
  FutureReport<PagedItem<User>> getUsers(int page) async {
    return handler(
      call: () => dio.get(EndPoints.users.queryParams({'per_page': '10', 'page': '$page'})),
      mapper: (m) => PagedItem.fromMap(m, User.fromMap),
    );
  }
}
