import 'package:flutter/material.dart';

import '../data/cities.dart';
import '../services/storage_service.dart';
import '../services/alarm_service.dart';
import '../l10n/strings.dart';
import '../theme/app_theme.dart';

/// Manual city picker: choose a country from a dropdown, then a city from the
/// list below (with search). Saves the city's coordinates for offline prayer
/// calculation — no location permission needed.
class CityPickerScreen extends StatefulWidget {
  const CityPickerScreen({super.key});

  @override
  State<CityPickerScreen> createState() => _CityPickerScreenState();
}

class _CityPickerScreenState extends State<CityPickerScreen> {
  final StorageService _storage = StorageService();
  final AlarmService _alarm = AlarmService();
  final TextEditingController _searchCtrl = TextEditingController();

  late CountryEntry _country;
  String _query = '';

  @override
  void initState() {
    super.initState();
    // Default to the country whose city matches the saved name, else first.
    _country = kCountries.firstWhere(
      (c) => c.cities.any((city) => city.ar == _storage.cityName),
      orElse: () => kCountries.first,
    );
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<CityEntry> get _visibleCities {
    if (_query.trim().isEmpty) return _country.cities;
    final q = _query.trim().toLowerCase();
    return _country.cities
        .where((c) =>
            c.ar.contains(_query.trim()) || c.en.toLowerCase().contains(q))
        .toList();
  }

  Future<void> _selectCity(CityEntry city) async {
    await _storage.saveLocation(city.lat, city.lng, city.ar);
    try {
      await _alarm.rescheduleAll();
    } catch (_) {}
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(trp('city_selected', {'city': city.ar}),
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w700)),
          backgroundColor: Colors.green.shade700,
          duration: const Duration(seconds: 2),
        ),
      );
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cities = _visibleCities;
    return Scaffold(
      appBar: AppBar(title: Text(tr('select_city'))),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Align(
                    alignment: Alignment.centerRight,
                    child: Text(tr('country'),
                        style: TextStyle(
                            color: AppTheme.muted, fontSize: 14)),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: AppTheme.navyCard,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                          color: AppTheme.gold.withOpacity(0.4)),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<CountryEntry>(
                        value: _country,
                        isExpanded: true,
                        dropdownColor: AppTheme.navyCard,
                        iconEnabledColor: AppTheme.goldSoft,
                        style: const TextStyle(
                            color: AppTheme.cream, fontSize: 16),
                        items: kCountries
                            .map((c) => DropdownMenuItem(
                                  value: c,
                                  child: Text(c.label),
                                ))
                            .toList(),
                        onChanged: (c) {
                          if (c != null) {
                            setState(() {
                              _country = c;
                              _searchCtrl.clear();
                              _query = '';
                            });
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _searchCtrl,
                    style: const TextStyle(color: AppTheme.cream),
                    onChanged: (v) => setState(() => _query = v),
                    decoration: InputDecoration(
                      hintText: tr('search_city'),
                      hintStyle: const TextStyle(color: AppTheme.muted),
                      prefixIcon:
                          const Icon(Icons.search, color: AppTheme.muted),
                      filled: true,
                      fillColor: AppTheme.navyCard,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
            Expanded(
              child: cities.isEmpty
                  ? const Center(
                      child: Text(tr('no_results'),
                          style: TextStyle(color: AppTheme.muted)),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      itemCount: cities.length,
                      separatorBuilder: (_, __) => const Divider(
                          color: AppTheme.navyLight, height: 1),
                      itemBuilder: (context, i) {
                        final city = cities[i];
                        final isCurrent = city.ar == _storage.cityName;
                        return ListTile(
                          leading: Icon(Icons.location_city,
                              color: isCurrent
                                  ? AppTheme.gold
                                  : AppTheme.muted),
                          title: Text(city.ar,
                              style: const TextStyle(color: AppTheme.cream)),
                          subtitle: Text(city.en,
                              style: const TextStyle(
                                  color: AppTheme.muted, fontSize: 12)),
                          trailing: isCurrent
                              ? const Icon(Icons.check_circle,
                                  color: AppTheme.gold)
                              : null,
                          onTap: () => _selectCity(city),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
