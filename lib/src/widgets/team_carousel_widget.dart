import 'package:dfc_flutter/dfc_flutter_web_lite.dart';
import 'package:flutter/material.dart';

class TeamCarouselWidget extends StatefulWidget {
  const TeamCarouselWidget({this.backgroundColor, super.key});

  final Color? backgroundColor;

  // https://docs.google.com/document/d/1VMcpASB9O4Wxq2AppZ1TS-uR-k_9VMCcWRbmcxPDoB4/edit?tab=t.0
  static const List<_Employee> _employees = [
    _Employee(
      name: 'Alexandra',
      imagePath: 'assets/team_images/alexandra.jpeg',
      position: 'Head of Operations',
      biography:
          'Alexandra has been with Cocoatech since 2005, wearing many hats over the years before officially taking the reins as Head of Operations. She keeps the wheels turning behind the scenes — from managing payment systems and customer support to making sure things just work (and work well). She\'s passionate about clear communication, good user experience, and bringing structure to chaos. Outside of Cocoatech, Alexandra lives in Germany with her husband and two children. When she\'s not coordinating teams across time zones, you\'ll likely find her lacing up for a figure skating session, switching between the five languages that she speaks, or digging into a new technical system just for fun.',
    ),
    _Employee(
      name: 'Kim',
      imagePath: 'assets/team_images/kim.jpeg',
      position: 'Marketing Manager',
      biography:
          'Kim is a native Californian, but she began traveling three years ago and now calls Mexico home. Raised up in the SF tech scene for over 15 years, she shifted to her marketing work from Tech to Psychedelics and Mental Health, an interest Steve and Kim share! She has been with Cocoatech for over five years alongside her other clients. When not behind her computer, you will find her walking on the beach or hopping in an ice bath under the Mexican sun.',
    ),
    _Employee(
      name: 'Arman',
      imagePath: 'assets/team_images/arman.jpeg',
      position: 'Community Manager',
      biography:
          'Arman is a tech enthusiast with a passion for innovation, always on top of the latest trends and tools to provide efficient and effective support. Whether you\'re facing technical issues or just need some guidance in Discord, Arman has your back. When not in school earning his college degrees, he enjoys roaming around Armenia, where he calls home.',
    ),
    _Employee(
      name: 'Dragan',
      imagePath: 'assets/team_images/dragan.jpeg',
      position: 'CTO',
      biography:
          'Dragan got his first computing experience in 1983 on Sinclair ZX Spectrum and wrote his first code for it in BASIC a year later. He has been a Mac user since 1994, a Mac coder for fun since 2002, and has been doing it professionally since 2009. In his spare time, he loves to ride his bicycle through the Netherlands and makes fighter plane models for fun.',
    ),
    _Employee(
      name: 'Naum',
      imagePath: 'assets/team_images/naum.jpeg',
      position: 'Customer Support Consultant',
      biography:
          'Naum has a love of for problem-solving and a drive to help others. He thrives in fast-paced environments and is dedicated to delivering quality service and ensuring clients have the best experience possible. Naum is an avid traveler and calls all of Europe home.',
    ),
    _Employee(
      name: 'Steve',
      imagePath: 'assets/team_images/steve.jpeg',
      position: 'CEO',
      biography:
          'Steve has been coding since 1986. He has written and designed two popular macOS apps: Final Draft and Path Finder and is working on a third. A Los Angeles Native, he currently lives in San Francisco, where Cocoatech has its headquarters (in his home office!). His wife and two children travel frequently to Japan, where his daughter is a rising music star. When he is not rollerskating in Golden Gate Park or spending quality time with his family, he is working on Deckr, Cocoatech\'s newest app.',
    ),
  ];

  @override
  State<TeamCarouselWidget> createState() => _TeamCarouselWidgetState();
}

class _TeamCarouselWidgetState extends State<TeamCarouselWidget> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate responsive item extent based on screen width
        double itemExtent;
        if (constraints.maxWidth > 1400) {
          itemExtent = constraints.maxWidth / 5; // 5 cards visible on very large screens
        } else if (constraints.maxWidth > 1200) {
          itemExtent = constraints.maxWidth / 4; // 4 cards visible on large screens
        } else if (constraints.maxWidth > 900) {
          itemExtent = constraints.maxWidth / 3; // 3 cards visible on medium-large screens
        } else if (constraints.maxWidth > 600) {
          itemExtent = constraints.maxWidth / 2; // 2 cards visible on medium screens
        } else {
          itemExtent = constraints.maxWidth * 0.85; // 1 card (with peek) on small screens
        }

        // Calculate card height based on screen width to maintain aspect ratio
        final cardHeight = constraints.maxWidth > 600.0 ? 400.0 : 350.0;

        return SizedBox(
          height: cardHeight,
          child: CarouselView(
            itemExtent: itemExtent,
            shrinkExtent: itemExtent * 0.8, // Shrink items when not centered
            itemSnapping: true,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: TeamCarouselWidget._employees.map((employee) {
              return Padding(
                // need space for the hover scale effect
                padding: const EdgeInsets.all(8),
                child: _EmployeeCard(
                  employee: employee,
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}

class _EmployeeCard extends StatefulWidget {
  const _EmployeeCard({required this.employee});
  final _Employee employee;

  @override
  State<_EmployeeCard> createState() => _EmployeeCardState();
}

class _EmployeeCardState extends State<_EmployeeCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
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
            child: DFTooltip(
              message:
                  '${widget.employee.name}\n\n${widget.employee.biography}',
              child: GestureDetector(
                onTap: () {
                  _showEmployeeDialog(
                      context: context, employee: widget.employee);
                },
                child: Card(
                  elevation: 8,
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
                                package: 'dfc_flutter',
                                fit: BoxFit.cover,
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
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                widget.employee.position,
                                style: TextStyle(
                                  color: context.lightTextColor,
                                  fontSize: 14,
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

// =======================================================

Future<void> _showEmployeeDialog({
  required BuildContext context,
  required _Employee employee,
}) {
  return showDialog(
    context: context,
    builder: (context) => Dialog(
      elevation: 20,
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(12)),
              child: Image.asset(
                employee.imagePath,
                package: 'dfc_flutter',
                fit: BoxFit.cover,
                height: 400,
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
            const SizedBox(height: 16),
            Text(
              employee.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Text(
              employee.biography,
              style: TextStyle(
                color: context.lightTextColor,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

// =======================================================

class _Employee {
  const _Employee({
    required this.name,
    required this.position,
    required this.imagePath,
    required this.biography,
  });
  final String name;
  final String position;
  final String imagePath;
  final String biography;
}
