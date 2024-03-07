import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/api/api_service.dart';
import 'package:story_app/db/auth_repository.dart';
import 'package:story_app/provider/add_story_provider.dart';
import 'package:story_app/provider/auth_provider.dart';
import 'package:story_app/provider/page_map_manager.dart';
import 'package:story_app/provider/story_provider.dart';
import 'package:story_app/routes/router_delegate.dart';

void main() {
  runApp(const StoryApp());
}

class StoryApp extends StatefulWidget {
  const StoryApp({super.key});

  @override
  State<StoryApp> createState() => _StoryAppState();
}

class _StoryAppState extends State<StoryApp> {
  late MyRouterDelegate myRouterDelegate;
  late AuthProvider authProvider;
  late StoryProvider storyProvider;
  late AddStoryProvider addStoryProvider;
  @override
  void initState() {
    super.initState();
    final authRepository = AuthRepository();
    final apiService = ApiService();
    authProvider = AuthProvider(authRepository, apiService);
    storyProvider = StoryProvider(
      authProvider: authProvider,
      authRepository: authRepository,
      apiService: apiService,
    );
    addStoryProvider = AddStoryProvider(
      authRepository: authRepository,
      apiService: apiService,
    );
    myRouterDelegate = MyRouterDelegate(authRepository);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => PageMapManager()),
        ChangeNotifierProvider(create: (context) => authProvider),
        ChangeNotifierProvider(create: (context) => storyProvider),
        ChangeNotifierProvider(create: (context) => addStoryProvider)
      ],
      child: MaterialApp(
        title: 'Story App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: Router(
          routerDelegate: myRouterDelegate,
          backButtonDispatcher: RootBackButtonDispatcher(),
        ),
      ),
    );
  }
}
