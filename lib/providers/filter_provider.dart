import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Enum for Date Filtering Options
enum DateFilterOption {
  all,
  currentMonth,
  lastMonth,
  thisYear,
  customRange,
}

/// Filter State Model for Expense History & Analytics
class FilterState {
  final String searchQuery;
  final String selectedCategory; // 'All' or specific category name/id
  final DateFilterOption dateFilter;
  final DateTime? customStartDate;
  final DateTime? customEndDate;
  final DateTime selectedMonth; // For month-by-month summary dashboard

  FilterState({
    this.searchQuery = '',
    this.selectedCategory = 'All',
    this.dateFilter = DateFilterOption.all,
    this.customStartDate,
    this.customEndDate,
    DateTime? selectedMonth,
  }) : selectedMonth = selectedMonth ?? DateTime.now();

  FilterState copyWith({
    String? searchQuery,
    String? selectedCategory,
    DateFilterOption? dateFilter,
    DateTime? customStartDate,
    DateTime? customEndDate,
    DateTime? selectedMonth,
  }) {
    return FilterState(
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      dateFilter: dateFilter ?? this.dateFilter,
      customStartDate: customStartDate ?? this.customStartDate,
      customEndDate: customEndDate ?? this.customEndDate,
      selectedMonth: selectedMonth ?? this.selectedMonth,
    );
  }
}

/// Notifier handling application filter state
class FilterNotifier extends Notifier<FilterState> {
  @override
  FilterState build() => FilterState();

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void setCategory(String category) {
    state = state.copyWith(selectedCategory: category);
  }

  void setDateFilter(DateFilterOption option) {
    state = state.copyWith(dateFilter: option);
  }

  void setCustomDateRange(DateTime start, DateTime end) {
    state = state.copyWith(
      dateFilter: DateFilterOption.customRange,
      customStartDate: start,
      customEndDate: end,
    );
  }

  void setSelectedMonth(DateTime month) {
    state = state.copyWith(selectedMonth: month);
  }

  void resetFilters() {
    state = FilterState(selectedMonth: state.selectedMonth);
  }
}

final filterProvider = NotifierProvider<FilterNotifier, FilterState>(FilterNotifier.new);
