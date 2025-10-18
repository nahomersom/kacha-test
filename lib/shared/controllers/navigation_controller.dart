import 'package:flutter_riverpod/flutter_riverpod.dart';

class NavigationController extends StateNotifier<int> {
  NavigationController() : super(0);

  void changeTab(int index) {
    state = index;
  }
}

final navigationControllerProvider = StateNotifierProvider<NavigationController, int>((ref) {
  return NavigationController();
});
