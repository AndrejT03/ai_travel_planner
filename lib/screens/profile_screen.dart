import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/day_plan.dart';
import '../providers/auth_provider.dart';
import '../providers/library_provider.dart';
import '../providers/user_profile_provider.dart';
import '../widgets/favorite_card.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  static const _profileImageKey = 'profile_image_path';

  final _picker = ImagePicker();
  File? _profileImage;

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
  }

  Future<void> _loadProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    final path = prefs.getString(_profileImageKey);

    if (!mounted) return;
    if (path == null || path.isEmpty) return;

    final file = File(path);
    if (!file.existsSync()) return;

    setState(() => _profileImage = file);
  }

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (picked == null) return;

    final file = File(picked.path);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_profileImageKey, file.path);

    if (!mounted) return;
    setState(() => _profileImage = file);
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    final profileAsync = ref.watch(userProfileStreamProvider);
    final favoritesAsync = ref.watch(userFavoritesStreamProvider);

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 6),

          Center(
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 54,
                  backgroundColor: Colors.blueGrey.withOpacity(0.25),
                  backgroundImage:
                  _profileImage != null ? FileImage(_profileImage!) : null,
                  child: _profileImage == null
                      ? const Icon(Icons.person,
                      size: 54, color: Colors.white70)
                      : null,
                ),
                Positioned(
                  right: 2,
                  bottom: 2,
                  child: InkWell(
                    onTap: _pickImage,
                    borderRadius: BorderRadius.circular(22),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 10,
                            offset: Offset(0, 4),
                            color: Colors.black26,
                          ),
                        ],
                      ),
                      child:
                      const Icon(Icons.edit, size: 18, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          switch (profileAsync) {
            AsyncData(:final value) => _ProfileHeader(
              fullName: (value?.fullName.isNotEmpty ?? false)
                  ? value!.fullName
                  : (auth.user?.displayName ?? 'User'),
              email: (value?.email.isNotEmpty ?? false)
                  ? value!.email
                  : (auth.user?.email ?? ''),
            ),
            AsyncError(:final error) => Center(
              child: Text(
                'Error: $error',
                style: const TextStyle(color: Colors.redAccent),
                textAlign: TextAlign.center,
              ),
            ),
            _ => const Center(child: CircularProgressIndicator()),
          },

          const SizedBox(height: 24),

          Row(
            children: [
              const Text(
                'Favorites',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),

          const SizedBox(height: 10),

      AnimatedSize(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        child: switch (favoritesAsync) {
            AsyncData(:final value) => value.isEmpty
                ? _emptyFavorites()
                : SizedBox(
              height: 170,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: value.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) => FavoritePlanCard(plan: value[index]),
              ),
            ),

            AsyncError(:final error) => Center(
              child: Text(
                'Error: $error',
                style: const TextStyle(color: Colors.redAccent),
                textAlign: TextAlign.center,
              ),
            ),

            _ => const SizedBox(
              height: 110,
              child: Center(child: CircularProgressIndicator()),
            ),
          },
      ),
          const SizedBox(height: 24),

          Card(
            elevation: 0,
            color: Colors.transparent,
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Colors.white.withOpacity(0.10)),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.center,
                  end: Alignment.center,
                  colors: [
                    const Color(0xFF66B7FF).withOpacity(0.12),
                    Colors.black.withOpacity(0.55),
                    Colors.black.withOpacity(0.85),
                  ],
                  stops: const [0.0, 0.55, 1.0],
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: const Icon(Icons.draw_outlined, color: Colors.white70),
                    title: const Text('My Info', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white54),
                    onTap: () => context.push('/settings'),
                  ),
                  Divider(height: 1, color: Colors.white.withOpacity(0.10)),
                  ListTile(
                    leading: const Icon(Icons.map_outlined, color: Colors.white70),
                    title: const Text('My plans', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.white54),
                    onTap: () => context.push('/my-plans'),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () async {
                await ref.read(authProvider).logout();

                final prefs = await SharedPreferences.getInstance();
                await prefs.remove(_profileImageKey);

                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Logged out')),
                );
                context.go('/login');
              },
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),

          const SizedBox(height: 200),
        ],
      ),
    );
  }

  Widget _emptyFavorites() {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.grey.withOpacity(0.08),
        border: Border.all(color: Colors.grey.withOpacity(0.18)),
      ),
      child: const Center(
        child: Text(
          'You have no favorites yet.',
          style: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }

  Widget _favoriteCard(BuildContext context, DayPlan plan) {
    return SizedBox(
      width: 180,
      child: Material(
        color: Colors.grey.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => context.push('/plan-details', extra: plan),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.favorite,
                        size: 16, color: Colors.redAccent),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        plan.destination,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  '${plan.duration} • ${plan.budget}€',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 6),
                Text(
                  plan.season,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.grey),
                ),
                const Spacer(),
                const Align(
                  alignment: Alignment.bottomRight,
                  child: Icon(Icons.chevron_right),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final String fullName;
  final String email;

  const _ProfileHeader({
    required this.fullName,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Text(
            fullName,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 4),
        Center(
          child: Text(
            email,
            style: const TextStyle(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}