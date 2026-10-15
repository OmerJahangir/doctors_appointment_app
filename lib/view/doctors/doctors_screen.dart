import 'package:flutter/material.dart';

import '../../data/doctors.dart';
import '../../res/app_theme.dart';
import '../common_widget/doctor_card.dart';
import '../common_widget/fade_slide_in.dart';

/// Every doctor, nearest first, under the "Find doctors" map card.
class DoctorsScreen extends StatefulWidget {
  const DoctorsScreen({super.key});

  @override
  State<DoctorsScreen> createState() => _DoctorsScreenState();
}

class _DoctorsScreenState extends State<DoctorsScreen> {
  final _searchController = TextEditingController();
  bool _searching = false;
  bool _showMap = true;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleSearch() => setState(() {
    _searching = !_searching;
    if (!_searching) _searchController.clear();
  });

  @override
  Widget build(BuildContext context) {
    final results = searchDoctors(doctors, query: _searchController.text)
      ..sort((a, b) => a.distanceKm.compareTo(b.distanceKm));

    return Scaffold(
      appBar: AppBar(
        title: _searching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                onChanged: (_) => setState(() {}),
                decoration: const InputDecoration(
                  hintText: 'Search doctors',
                  isDense: true,
                ),
              )
            : const Text('Our Doctors'),
        actions: [
          IconButton(
            tooltip: _searching ? 'Close search' : 'Search',
            icon: Icon(_searching ? Icons.close_rounded : Icons.search_rounded),
            onPressed: _toggleSearch,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        children: [
          if (_showMap && !_searching) ...[
            FadeSlideIn(
              child: _FindDoctorsCard(
                onClose: () => setState(() => _showMap = false),
              ),
            ),
            const SizedBox(height: 24),
          ],
          Text(
            _searching ? '${results.length} found' : 'Nearby Doctors',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          if (results.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: Text(
                'No doctors match your search.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textMuted),
              ),
            ),
          for (final (i, doctor) in results.indexed)
            Padding(
              key: ValueKey(doctor.id),
              padding: const EdgeInsets.only(bottom: 12),
              child: FadeSlideIn(
                delay: staggered(i + 1),
                child: DoctorCard(doctor: doctor),
              ),
            ),
        ],
      ),
    );
  }
}

class _FindDoctorsCard extends StatelessWidget {
  const _FindDoctorsCard({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 8, 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.primaryLight, AppColors.primary],
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 26,
                backgroundColor: Colors.white,
                backgroundImage: AssetImage('assets/images/live_host.png'),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Find Doctors!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Doctors closest to you are listed first',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Hide map',
                onPressed: onClose,
                icon: const Icon(
                  Icons.close_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: const AspectRatio(
                aspectRatio: 381 / 226,
                child: Image(
                  image: AssetImage('assets/images/map.png'),
                  fit: BoxFit.cover,
                  semanticLabel: 'Map of nearby clinics',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
