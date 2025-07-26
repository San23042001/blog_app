import 'dart:async';
import 'dart:ui';

class Debounce {
  final Duration delay;
  VoidCallback? action;
  Timer? _timer;

  Debounce({required this.delay});

  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }

  void dispose() {
    _timer?.cancel();
  }
}


// final Debouncer _debouncer = Debouncer(delay: const Duration(milliseconds: 500));

// void _onSearchChanged() {
//   _debouncer.run(() {
//     setState(() {
//       _searchQuery = _searchController.text;
//     });
//     _pagingController.refresh();
//   });
// }

// @override
// void dispose() {
//   _debouncer.dispose();
//   _searchController.removeListener(_onSearchChanged);
//   _searchController.dispose();
//   _pagingController.dispose();
//   super.dispose();
// }