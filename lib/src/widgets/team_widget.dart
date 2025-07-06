import 'package:dfc_flutter/src/widgets/drag_scroll_widget.dart';
import 'package:flutter/material.dart';

class Employee {
  const Employee({
    required this.name,
    required this.imagePath,
    required this.biography,
  });
  final String name;
  final String imagePath;
  final String biography;
}

// https://docs.google.com/document/d/1VMcpASB9O4Wxq2AppZ1TS-uR-k_9VMCcWRbmcxPDoB4/edit?tab=t.0

class TeamWidget extends StatefulWidget {
  const TeamWidget({super.key});
  static const List<Employee> employees = [
    Employee(
      name: 'Alexandra',
      imagePath: 'assets/team_images/alexandra.jpeg',
      biography:
          'Head of Operations Alexandra has been with Cocoatech since 2005, wearing many hats over the years before officially taking the reins as Head of Operations. She keeps the wheels turning behind the scenes — from managing payment systems and customer support to making sure things just work (and work well). She\'s passionate about clear communication, good user experience, and bringing structure to chaos. utside of Cocoatech, Alexandra lives in Germany with her husband and two children. When she’s not coordinating teams across time zones, you’ll likely find her lacing up for a figure skating session, switching between the five languages that she speaks, or digging into a new technical system just for fun.',
    ),
    Employee(
      name: 'Arman',
      imagePath: 'assets/team_images/arman.jpeg',
      biography:
          'Community Manager Arman is a tech enthusiast with a passion for innovation, always on top of the latest trends and tools to provide efficient and effective support. Whether you\'re facing technical issues or just need some guidance in Discord, Arman has your back. When not in school earning his college degrees, he enjoys roaming around Armenia, where he calls home.',
    ),
    Employee(
      name: 'Dragan',
      imagePath: 'assets/team_images/dragan.jpeg',
      biography:
          'CTO  Dragan got his first computing experience in 1983 on Sinclair ZX Spectrum and wrote his first code for it in BASIC a year later. He has been a Mac user since 1994, a Mac coder for fun since 2002, and has been doing it professionally since 2009. In his spare time, he loves to ride his bicycle through the Netherlands and makes fighter plane models for fun.',
    ),
    Employee(
      name: 'Naum',
      imagePath: 'assets/team_images/naum.jpeg',
      biography:
          'Customer Support Consultant Naum has a love of for problem-solving and a drive to help others. He thrives in fast-paced environments and is dedicated to delivering quality service and ensuring clients have the best experience possible. Naum is an avid traveler and calls all of Europe home.',
    ),
    Employee(
      name: 'Kim',
      imagePath: 'assets/team_images/kim.jpeg',
      biography:
          'Marketing Manager Kim is a native Californian, but she began traveling three years ago and now calls Mexico home. Raised up in the SF tech scene for over 15 years, she shifted to her marketing work from Tech to Psychedelics and Mental Health, an interest Steve and Kim share! She has been with Cocoatech for over five years alongside her other clients. When not behind her computer, you will find her walking on the beach or hopping in an ice bath under the Mexican sun.',
    ),
    Employee(
      name: 'Steve',
      imagePath: 'assets/team_images/steve.jpeg',
      biography:
          'CEO Steve has been coding since 1986. He has written and designed two popular macOS apps: Final Draft and Path Finder and is working on a third. A Los Angeles Native, he currently lives in San Francisco, where Cocoatech has its headquarters (in his home office!). His wife and two children travel frequently to Japan, where his daughter is a rising music star. When he is not rollerskating in Golden Gate Park or spending quality time with his family, he is working on Deckr, Cocoatech\'s newest app.',
    ),
  ];

  @override
  State<TeamWidget> createState() => _TeamWidgetState();
}

class _TeamWidgetState extends State<TeamWidget> {
  late PageController _pageController;
  int _currentIndex = 0;
  bool _canScrollLeft = false;
  bool _canScrollRight = true;

  @override
  void initState() {
    super.initState();
    // Initial controller - will be updated in build method
    _pageController = PageController(viewportFraction: 0.85);
    _updateScrollButtons();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  double _getViewportFraction(double screenWidth) {
    // Calculate responsive viewport fraction based on screen width
    if (screenWidth > 1400) {
      return 0.2; // 5 cards visible on very large screens
    } else if (screenWidth > 1200) {
      return 0.25; // 4 cards visible on large screens
    } else if (screenWidth > 900) {
      return 0.33; // 3 cards visible on medium-large screens
    } else if (screenWidth > 600) {
      return 0.5; // 2 cards visible on medium screens
    } else {
      return 0.85; // 1 card (with peek) on small screens
    }
  }

  void _updateScrollButtons() {
    setState(() {
      _canScrollLeft = _currentIndex > 0;
      _canScrollRight = _currentIndex < TeamWidget.employees.length - 1;
    });
  }

  void _scrollLeft() {
    if (_canScrollLeft) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _scrollRight() {
    if (_canScrollRight) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Calculate responsive viewport fraction
          final viewportFraction = _getViewportFraction(constraints.maxWidth);

          // Recreate PageController if viewport fraction changed significantly
          if ((_pageController.viewportFraction - viewportFraction).abs() >
              0.01) {
            final currentPage = _currentIndex;
            _pageController.dispose();
            _pageController = PageController(
              viewportFraction: viewportFraction,
              initialPage: currentPage,
            );
          }

          // Calculate card height based on screen width to maintain aspect ratio
          final cardHeight = constraints.maxWidth > 600.0 ? 400.0 : 350.0;

          return SizedBox(
            height: cardHeight,
            child: Stack(
              children: [
                DragScrollWidget(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      _currentIndex = index;
                      _updateScrollButtons();
                    },
                    itemCount: TeamWidget.employees.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: EmployeeCard(
                          employee: TeamWidget.employees[index],
                        ),
                      );
                    },
                  ),
                ),
                // Left scroll button
                if (_canScrollLeft)
                  Positioned(
                    left: 8,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: DecoratedBox(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: IconButton(
                          onPressed: _scrollLeft,
                          icon: const Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.black87,
                          ),
                          tooltip: 'Previous employee',
                        ),
                      ),
                    ),
                  ),
                // Right scroll button
                if (_canScrollRight)
                  Positioned(
                    right: 8,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: DecoratedBox(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: IconButton(
                          onPressed: _scrollRight,
                          icon: const Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.black87,
                          ),
                          tooltip: 'Next employee',
                        ),
                      ),
                    ),
                  ),
                // Page indicator dots
                Positioned(
                  bottom: 16,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      TeamWidget.employees.length,
                      (index) => Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentIndex == index
                              ? Theme.of(context).primaryColor
                              : Colors.grey.withValues(alpha: 0.4),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class EmployeeCard extends StatefulWidget {
  const EmployeeCard({required this.employee, super.key});
  final Employee employee;

  @override
  State<EmployeeCard> createState() => _EmployeeCardState();
}

class _EmployeeCardState extends State<EmployeeCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1, end: 1.05).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _animationController.forward(),
      onExit: (_) => _animationController.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Tooltip(
              waitDuration: const Duration(milliseconds: 1300),
              message:
                  '${widget.employee.name}\n\n${widget.employee.biography}',
              preferBelow: false,
              textStyle: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                height: 1.3,
              ),
              decoration: const BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.all(Radius.circular(8)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(12),
              child: Card(
                elevation: 8,
                shadowColor: Colors.black26,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(16)),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.white, Colors.grey.shade50],
                    ),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Container(
                          margin: const EdgeInsets.all(16),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12)),
                            child: AspectRatio(
                              aspectRatio: 1, // Square aspect ratio
                              child: Image.asset(
                                widget.employee.imagePath,
                                fit: BoxFit.cover,
                                bundle: DefaultAssetBundle.of(context),
                                errorBuilder: (context, error, stackTrace) {
                                  return ColoredBox(
                                    color: Colors.grey.shade200,
                                    child: const Icon(
                                      Icons.person,
                                      size: 48,
                                      color: Colors.grey,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                widget.employee.name,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey.shade800,
                                    ),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Container(
                                height: 2,
                                width: 30,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Theme.of(context).primaryColor,
                                      Theme.of(
                                        context,
                                      ).primaryColor.withValues(alpha: 0.5),
                                    ],
                                  ),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(1)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
