// lib/utils/formatter_utils.dart
import 'package:intl/intl.dart';

class FormatterUtils {
  // Format tanggal ke format Indonesia
  static String formatDate(String? startDate, [String? endDate]) {
    if (startDate == null || startDate.isEmpty) return '-';
    
    try {
      final DateTime start = DateTime.parse(startDate);
      
      // Jika tidak ada tanggal akhir, return format single date
      if (endDate == null || endDate.isEmpty) {
        return DateFormat('d MMMM y', 'id').format(start);
      }

      final DateTime end = DateTime.parse(endDate);

      // Jika tanggal mulai dan selesai sama
      if (start.year == end.year && start.month == end.month && start.day == end.day) {
        return DateFormat('d MMMM y', 'id').format(start);
      }
      
      // Jika tahun berbeda
      if (start.year != end.year) {
        return '${DateFormat('d MMMM y', 'id').format(start)} - ${DateFormat('d MMMM y', 'id').format(end)}';
      }
      
      // Jika bulan berbeda
      if (start.month != end.month) {
        return '${DateFormat('d MMMM', 'id').format(start)} - ${DateFormat('d MMMM y', 'id').format(end)}';
      }
      
      // Jika hanya tanggal yang berbeda
      return '${DateFormat('d', 'id').format(start)} - ${DateFormat('d MMMM y', 'id').format(end)}';
    } catch (e) {
      return startDate;
    }
  }

  // Format waktu ke format "HH:mm WIB - Selesai"
  static String formatTime(String? time) {
    if (time == null || time.isEmpty) return '-';

    try {
      final DateTime dateTime = DateTime.parse(time);
      return '${DateFormat('HH:mm').format(dateTime)} WIB - Selesai';
    } catch (e) {
      if (time.contains('WIB') || time.contains('Selesai')) {
        return time;
      }
      if (time.contains(' - ')) {
        final startTime = time.split(' - ')[0];
        return '$startTime WIB - Selesai';
      }
      return time;
    }
  }
}