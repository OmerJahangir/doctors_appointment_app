import 'package:flutter/material.dart';

import '../../data/doctors.dart';
import '../../model/doctor.dart';
import '../../res/app_theme.dart';
import '../common_widget/doctor_card.dart';
import '../common_widget/fade_slide_in.dart';
import '../doctors/doctors_screen.dart';
import 'widget/category_tile.dart';
import 'widget/live_banner.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();
  Specialty? _specialty;
  bool _showBanner = true;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleSpecialty(Specialty? specialty) =>
      setState(() => _specialty = _specialty == specialty ? null : specialty);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final results = searchDoctors(
      doctors,
      query: _searchController.text,
      specialty: _specialty,
    );

    return SafeArea(
      bottom: false,
      child: CustomScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
            sliver: SliverList.list(
              children: [
                FadeSlideIn(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hello',
                              style: textTheme.titleMedium?.copyWith(
                                color: AppColors.textMuted,
                                letterSpacing: 2,
                              ),
                            ),
                            Text(
                              'Giovanny',
                              style: textTheme.headlineSmall?.copyWith(
                                letterSpacing: 2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const CircleAvatar(
                        radius: 24,
                        backgroundColor: AppColors.surface,
                        child: Icon(
                          Icons.waving_hand_rounded,
                          color: AppColors.star,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                FadeSlideIn(
                  delay: staggered(1),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (_) => setState(() {}),
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      hintText: 'Search doctors or specialties',
                      prefixIcon: const Icon(Icons.search_rounded),
                      suffixIcon: _searchController.text.isEmpty
                          ? null
                          : IconButton(
                              tooltip: 'Clear search',
                              icon: const Icon(Icons.close_rounded),
                              onPressed: () =>
                                  setState(_searchController.clear),
                            ),
                    ),
                  ),
                ),
                if (_showBanner) ...[
                  const SizedBox(height: 20),
                  FadeSlideIn(
                    delay: staggered(2),
                    child: LiveBanner(
                      onClose: () => setState(() => _showBanner = false),
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                FadeSlideIn(
                  delay: staggered(3),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      for (final specialty in Specialty.values)
                        CategoryTile(
                          label: specialty.label,
                          iconAsset: specialty.iconAsset,
                          selected: _specialty == specialty,
                          onTap: () => _toggleSpecialty(specialty),
                        ),
                      CategoryTile(
                        label: 'All',
                        iconAsset: 'assets/images/app.png',
                        selected: _specialty == null,
                        onTap: () => setState(() => _specialty = null),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                FadeSlideIn(
                  delay: staggered(4),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Our Doctors',
                          style: textTheme.headlineSmall,
                        ),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => const DoctorsScreen(),
                          ),
                        ),
                        child: const Text('See all'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
          if (results.isEmpty)
            const SliverToBoxAdapter(child: _NoResults())
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              sliver: SliverList.separated(
                itemCount: results.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, i) => FadeSlideIn(
                  key: ValueKey(results[i].id),
                  delay: staggered(i + 4),
                  child: DoctorCard(doctor: results[i]),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _NoResults extends StatelessWidget {
  const _NoResults();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Column(
        children: [
          const Icon(
            Icons.search_off_rounded,
            size: 48,
            color: AppColors.textMuted,
          ),
          const SizedBox(height: 12),
          Text(
            'No doctors match your search',
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          const Text(
            'Try another name or specialty, or pick "All".',
            style: TextStyle(color: AppColors.textMuted),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
