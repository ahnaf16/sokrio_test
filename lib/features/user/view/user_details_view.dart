import 'package:flutter/material.dart';
import 'package:linkify/main.export.dart';
import 'package:linkify/models/user.dart';

class UserDetailsView extends HookConsumerWidget {
  const UserDetailsView({super.key, required this.user});
  final User user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name = '${user.firstName} ${user.lastName}';

    return Scaffold(
      appBar: AppBar(title: const Text('User Profile')),
      body: SingleChildScrollView(
        padding: Pads.lg(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              children: [
                PhotoViewWrapper(
                  image: user.image,
                  child: UImage(user.image, dimension: 128, borderRadius: Corners.circle),
                ),

                const Gap(Insets.lg),
                Text(
                  name,
                  style: context.text.headlineMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.colors.onSurface,
                  ),
                ),
              ],
            ),
            const Gap(Insets.xxl),
            DecoContainer(
              color: context.colors.surfaceContainer,
              shadows: [AppTheme.shadow()],
              borderRadius: Corners.lg,
              child: InkWell(
                onTap: () => URLHelper.mail(user.email),
                borderRadius: Corners.lgBorder,
                child: Padding(
                  padding: Pads.lg(),
                  child: Row(
                    children: [
                      Icon(Icons.mail_outline, color: context.colors.primary, size: 28),
                      const Gap(Insets.lg),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Contact Email', style: context.text.titleSmall!.primary),
                            const Gap(Insets.xs),
                            Text(user.email, style: context.text.titleMedium!.semiBold),
                          ],
                        ),
                      ),
                      Icon(Icons.open_in_new, color: context.colors.onSurfaceVariant),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
