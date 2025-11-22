import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:linkify/features/user/controller/user_ctrl.dart';
import 'package:linkify/main.export.dart';
import 'package:linkify/models/user.dart';
import 'package:screwdriver/screwdriver.dart';

class UserView extends HookConsumerWidget {
  const UserView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final debouncer = useMemoized(() => DeBouncer(600.ms));
    final usersData = ref.watch(userCtrlProvider);
    final userCtrl = useMemoized(() => ref.read(userCtrlProvider.notifier));
    final searchCtrl = useTextEditingController();
    return Scaffold(
      appBar: AppBar(title: const Text('Users')),
      body: AsyncBuilder(
        asyncValue: usersData,
        emptyText: 'No users found',
        emptyIcon: const Icon(Icons.person_rounded),
        emptyWhen: (d) => d.data.isEmpty,
        builder: (users) {
          return Padding(
            padding: Pads.lg(),
            child: Column(
              spacing: Insets.med,
              children: [
                KTextField(
                  hintText: 'Search by name or email',
                  controller: searchCtrl,
                  onChanged: (q) => debouncer(() => userCtrl.search(q)),
                  prefixIcon: Icon(Icons.search_rounded, color: context.colors.outlineVariant),
                  suffixIcon: const Icon(Icons.close_rounded).clickable(onTap: () => searchCtrl.clear()),
                ),
                Expanded(
                  child:AsyncBuilder(
        asyncValue: usersData,
        emptyText: 'No users found',
        emptyIcon: const Icon(Icons.person_rounded),
        emptyWhen: (d) => d.data.isEmpty,
        builder: (users) { return Refresher(
                    onLoadMore: () => userCtrl.loadNext(),
                    onRefresh: () => userCtrl.refresh(),
                    child: ListView.separated(
                      physics: kScrollPhysics,
                      itemCount: users.data.length,
                      separatorBuilder: (_, _) => const Gap(Insets.med),
                      itemBuilder: (context, index) {
                        final user = users.data[index];

                        return UserCard(user: user);
                      },
                    ),
                  ),},
                ),),
              ],
            ),
          );
        },
      ),
    );
  }
}

class UserCard extends StatelessWidget {
  const UserCard({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => RPaths.userDetails(user.id.toString()).push(context, extra: user),
      child: DecoContainer(
        color: context.colors.surfaceContainer,
        shadows: [AppTheme.shadow()],
        borderRadius: Corners.lg,
        padding: Pads.lg(),
        child: Row(
          spacing: Insets.lg,
          children: [
            KHero(
              tag: user.image,
              child: UImage(
                user.image.isNotEmpty ? user.image : Icons.person,
                borderRadius: Corners.circle,
                fit: BoxFit.contain,
                height: 50,
                width: 50,
              ),
            ),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${user.firstName} ${user.lastName}', style: context.text.titleMedium!.bold),
                  Text(user.email, style: context.text.bodyMedium?.grey),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
