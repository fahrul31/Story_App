import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:story_app/db/auth_repository.dart';
import 'package:story_app/provider/add_story_provider.dart';
import 'package:story_app/screen/add_story_screen.dart';
import 'package:story_app/screen/detail_story_screen.dart';
import 'package:story_app/screen/login_screen.dart';
import 'package:story_app/screen/picker_screen.dart';
import 'package:story_app/screen/story_list_screen.dart';
import 'package:story_app/screen/register_screen.dart';
import 'package:story_app/screen/splash_screen.dart';
import 'package:story_app/screen/map_screen.dart';

class MyRouterDelegate extends RouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  final GlobalKey<NavigatorState> _navigatorKey;
  final AuthRepository authRepository;

  MyRouterDelegate(
    this.authRepository,
  ) : _navigatorKey = GlobalKey<NavigatorState>() {
    _init();
  }

  _init() async {
    isLoggedIn = await authRepository.isLoggedIn();
    notifyListeners();
  }

  List<Page> historyStack = [];
  bool? isLoggedIn;
  bool isRegister = false;
  bool isForm = false;
  bool isPickMap = false;
  LatLng? selectedMap;
  String? selectedStory;

  List<Page> get _splashStack => const [
        MaterialPage(
          key: ValueKey("SplashPage"),
          child: SplashScreen(),
        ),
      ];

  List<Page> get _loggedInStack => [
        MaterialPage(
          key: const ValueKey("StoryListScreen"),
          child: StoryListScreen(
            onTapped: (String storyId) {
              selectedStory = storyId;
              notifyListeners();
            },
            toFormScreen: () {
              isForm = true;
              notifyListeners();
            },
            onLogout: () {
              isLoggedIn = false;
              notifyListeners();
            },
          ),
        ),
        if (isForm)
          MaterialPage(
            key: const ValueKey("AddStoryScreen"),
            child: AddStoryScreen(
              onSend: () {
                isForm = false;
                notifyListeners();
              },
              onPickMap: () {
                isPickMap = true;
                notifyListeners();
              },
            ),
          ),
        if (isPickMap)
          MaterialPage(
            key: const ValueKey("AddStoryLocation"),
            child: PickerScreen(
              onPick: () {
                isPickMap = false;
                notifyListeners();
              },
              onBack: () {
                isPickMap = false;
                notifyListeners();
              },
            ),
          ),
        if (selectedStory != null)
          MaterialPage(
            key: ValueKey(selectedStory),
            child: StoryDetailPage(
              onMap: (LatLng storyLocation) {
                selectedMap = storyLocation;
                notifyListeners();
              },
              storyId: selectedStory!,
            ),
          ),
        if (selectedMap != null)
          MaterialPage(
            key: ValueKey(selectedMap),
            child: MapScreen(
              onBack: () {
                selectedMap = null;
                notifyListeners();
              },
              storyLocation: selectedMap!,
            ),
          ),
      ];

  List<Page> get _loggedOutStack => [
        MaterialPage(
          key: const ValueKey("LoginPage"),
          child: LoginScreen(
            onLogin: () {
              isLoggedIn = true;
              notifyListeners();
            },
            onRegister: () {
              isRegister = true;
              notifyListeners();
            },
          ),
        ),
        if (isRegister == true)
          MaterialPage(
            key: const ValueKey("RegisterPage"),
            child: RegisterScreen(
              onRegister: () {
                isRegister = false;
                notifyListeners();
              },
              onLogin: () {
                isRegister = false;
                notifyListeners();
              },
            ),
          ),
      ];

  @override
  Widget build(BuildContext context) {
    if (isLoggedIn == null) {
      historyStack = _splashStack;
    } else if (isLoggedIn == true) {
      historyStack = _loggedInStack;
    } else {
      historyStack = _loggedOutStack;
    }
    return Navigator(
      key: navigatorKey,
      pages: historyStack,
      onPopPage: (route, result) {
        final didPop = route.didPop(result);
        if (!didPop) {
          return false;
        }

        final addStoryRead = context.read<AddStoryProvider>();
        addStoryRead.photoPath = null;
        addStoryRead.photo = null;
        addStoryRead.pickMap = null;

        selectedStory = null;
        selectedMap = null;
        isPickMap = false;
        isRegister = false;
        isForm = false;
        notifyListeners();

        return true;
      },
    );
  }

  @override
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  @override
  Future<void> setNewRoutePath(configuration) async {}
}
