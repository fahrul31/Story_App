import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/provider/auth_provider.dart';
import 'package:story_app/provider/story_provider.dart';
import 'package:story_app/widget/card_custom.dart';

class StoryListScreen extends StatefulWidget {
  final Function(String) onTapped;
  final Function() toFormScreen;
  final Function() onLogout;

  const StoryListScreen({
    Key? key,
    required this.onTapped,
    required this.onLogout,
    required this.toFormScreen,
  }) : super(key: key);

  @override
  State<StoryListScreen> createState() => _StoryListScreenState();
}

class _StoryListScreenState extends State<StoryListScreen>
    with SingleTickerProviderStateMixin {
  final ScrollController scrollController = ScrollController();
  late StoryProvider storyRead;
  late Tween<double> animation;

  @override
  void initState() {
    super.initState();

    animation = Tween<double>(begin: 0.0, end: 15);

    final storyRead = context.read<StoryProvider>();
    scrollController.addListener(
      () {
        if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent) {
          if (storyRead.page != null) {
            storyRead.fetchStories();
          }
        }
      },
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authWatch = context.watch<AuthProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Story App"),
        actions: [
          IconButton(
            onPressed: () async {
              widget.toFormScreen();
            },
            icon: const Icon(Icons.quiz),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final authRead = context.read<AuthProvider>();
          final result = await authRead.logout();
          if (result) widget.onLogout();
        },
        tooltip: "Logout",
        child: authWatch.isLoadingLogout
            ? const CircularProgressIndicator(
                color: Colors.white,
              )
            : const Icon(Icons.logout),
      ),
      body: SingleChildScrollView(
        controller: scrollController,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Story",
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              Text(
                "Recommendation story for you!",
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 16),
              Consumer<StoryProvider>(
                builder: (context, state, _) {
                  if (state.state == ResultState.loading) {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            TweenAnimationBuilder<double>(
                              tween: animation,
                              duration: const Duration(seconds: 3),
                              builder: (context, double value, child) {
                                return Transform.rotate(
                                  angle: value,
                                  child: Image.asset(
                                    "assets/loading.png",
                                    height: 50,
                                    width: 50,
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 20),
                            Text(
                              "Loading Story...",
                              style: Theme.of(context).textTheme.displaySmall,
                            ),
                          ],
                        ),
                      ),
                    );
                  } else if (state.state == ResultState.hasData) {
                    final listStory = state.storyResult;
                    return ListView.builder(
                      physics: const ClampingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount:
                          listStory.length + (state.page != null ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == listStory.length) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                        var story = listStory[index];
                        return InkWell(
                          onTap: () => widget.onTapped(story.id),
                          child: CardCostum(story: story),
                        );
                      },
                    );
                  } else if (state.state == ResultState.noData) {
                    return SizedBox(
                      height: MediaQuery.of(context).size.width - 50,
                      width: MediaQuery.of(context).size.width,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 10),
                            Text(
                              "No Data",
                              style: Theme.of(context).textTheme.displaySmall,
                            ),
                          ],
                        ),
                      ),
                    );
                  } else if (state.state == ResultState.error) {
                    final errorMessage =
                        context.read<AuthProvider>().errorMessage;
                    return SizedBox(
                      height: MediaQuery.of(context).size.width - 50,
                      width: MediaQuery.of(context).size.width - 50,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 10),
                            Text(
                              errorMessage,
                              style: Theme.of(context).textTheme.displaySmall,
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return const Center(
                      child: Material(
                        child: Text(''),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
