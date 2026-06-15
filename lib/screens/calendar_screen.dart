import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:hijri/hijri_calendar.dart';

import '../services/prayer_service.dart';
import '../services/storage_service.dart';
import '../models/personal_event.dart';
import '../widgets/prayer_list.dart';
import '../theme/app_theme.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final PrayerService _prayer = PrayerService();
  final StorageService _storage = StorageService();

  DateTime _focused = DateTime.now();
  DateTime _selected = DateTime.now();
  List<PersonalEvent> _events = [];

  @override
  void initState() {
    super.initState();
    _events = _storage.getEvents();
  }

  List<PersonalEvent> _eventsFor(DateTime day) => _events
      .where((e) =>
          e.date.year == day.year &&
          e.date.month == day.month &&
          e.date.day == day.day)
      .toList();

  @override
  Widget build(BuildContext context) {
    final prayers = _prayer.prayersForDate(_selected);
    final hijri = HijriCalendar.fromDate(_selected);
    final hijriStr =
        '${hijri.hDay} ${_hijriMonthAr(hijri.hMonth)} ${hijri.hYear} هـ';
    final dayEvents = _eventsFor(_selected);

    return Scaffold(
      appBar: AppBar(title: const Text('التقويم')),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.gold,
        foregroundColor: AppTheme.navy,
        onPressed: _addEventDialog,
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: TableCalendar(
                  locale: 'ar',
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2035, 12, 31),
                  focusedDay: _focused,
                  selectedDayPredicate: (d) => isSameDay(d, _selected),
                  startingDayOfWeek: StartingDayOfWeek.sunday,
                  eventLoader: _eventsFor,
                  onDaySelected: (sel, foc) {
                    setState(() {
                      _selected = sel;
                      _focused = foc;
                    });
                  },
                  calendarStyle: CalendarStyle(
                    defaultTextStyle: const TextStyle(color: AppTheme.cream),
                    weekendTextStyle:
                        const TextStyle(color: AppTheme.muted),
                    todayDecoration: BoxDecoration(
                      color: AppTheme.gold.withOpacity(0.25),
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: const BoxDecoration(
                      color: AppTheme.gold,
                      shape: BoxShape.circle,
                    ),
                    selectedTextStyle: const TextStyle(
                        color: AppTheme.navy, fontWeight: FontWeight.bold),
                    markerDecoration: const BoxDecoration(
                      color: AppTheme.goldSoft,
                      shape: BoxShape.circle,
                    ),
                  ),
                  headerStyle: const HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    titleTextStyle: TextStyle(
                        color: AppTheme.goldSoft,
                        fontSize: 17,
                        fontWeight: FontWeight.w700),
                    leftChevronIcon:
                        Icon(Icons.chevron_left, color: AppTheme.goldSoft),
                    rightChevronIcon:
                        Icon(Icons.chevron_right, color: AppTheme.goldSoft),
                  ),
                  daysOfWeekStyle: const DaysOfWeekStyle(
                    weekdayStyle: TextStyle(color: AppTheme.muted),
                    weekendStyle: TextStyle(color: AppTheme.muted),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),

            Center(
              child: Text(hijriStr,
                  style: const TextStyle(
                      color: AppTheme.goldSoft,
                      fontSize: 15,
                      fontWeight: FontWeight.w700)),
            ),
            const SizedBox(height: 12),

            Align(
              alignment: Alignment.centerRight,
              child: Text('أوقات الصلاة',
                  style: TextStyle(
                      color: AppTheme.muted,
                      fontSize: 15,
                      fontWeight: FontWeight.w600)),
            ),
            const SizedBox(height: 8),
            PrayerList(prayers: prayers),

            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: Text('المناسبات',
                  style: TextStyle(
                      color: AppTheme.muted,
                      fontSize: 15,
                      fontWeight: FontWeight.w600)),
            ),
            const SizedBox(height: 8),
            if (dayEvents.isEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Center(
                    child: Text('لا توجد مناسبات في هذا اليوم',
                        style:
                            TextStyle(color: AppTheme.muted, fontSize: 14)),
                  ),
                ),
              )
            else
              ...dayEvents.map((e) => Card(
                    child: ListTile(
                      leading: const Icon(Icons.event, color: AppTheme.gold),
                      title: Text(e.title,
                          style: const TextStyle(color: AppTheme.cream)),
                      subtitle: e.note != null && e.note!.isNotEmpty
                          ? Text(e.note!,
                              style:
                                  const TextStyle(color: AppTheme.muted))
                          : null,
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline,
                            color: AppTheme.muted),
                        onPressed: () => _deleteEvent(e),
                      ),
                    ),
                  )),
          ],
        ),
      ),
    );
  }

  Future<void> _addEventDialog() async {
    final titleCtrl = TextEditingController();
    final noteCtrl = TextEditingController();

    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.navyCard,
        title: const Text('إضافة مناسبة',
            style: TextStyle(color: AppTheme.goldSoft)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleCtrl,
              style: const TextStyle(color: AppTheme.cream),
              decoration: const InputDecoration(
                labelText: 'العنوان',
                labelStyle: TextStyle(color: AppTheme.muted),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: noteCtrl,
              style: const TextStyle(color: AppTheme.cream),
              decoration: const InputDecoration(
                labelText: 'ملاحظة (اختياري)',
                labelStyle: TextStyle(color: AppTheme.muted),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء',
                style: TextStyle(color: AppTheme.muted)),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleCtrl.text.trim().isEmpty) return;
              final event = PersonalEvent(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                date: _selected,
                title: titleCtrl.text.trim(),
                note: noteCtrl.text.trim(),
              );
              setState(() => _events.add(event));
              _storage.saveEvents(_events);
              Navigator.pop(ctx);
            },
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
  }

  void _deleteEvent(PersonalEvent e) {
    setState(() => _events.removeWhere((x) => x.id == e.id));
    _storage.saveEvents(_events);
  }

  String _hijriMonthAr(int m) {
    const months = [
      'محرم',
      'صفر',
      'ربيع الأول',
      'ربيع الآخر',
      'جمادى الأولى',
      'جمادى الآخرة',
      'رجب',
      'شعبان',
      'رمضان',
      'شوال',
      'ذو القعدة',
      'ذو الحجة',
    ];
    return months[(m - 1) % 12];
  }
}
