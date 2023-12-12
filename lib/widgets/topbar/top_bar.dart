import 'package:cliptopia/config/assets/app_icons.dart';
import 'package:cliptopia/config/themes/app_theme.dart';
import 'package:cliptopia/core/services/injector.dart';
import 'package:cliptopia/core/services/route_service.dart';
import 'package:flutter/material.dart';

class TopBar extends StatefulWidget {
  const TopBar({
    super.key,
    this.enabled = true,
  });

  final bool enabled;

  @override
  State<TopBar> createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  final routeService = Injector.find<RouteService>();

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeIn,
      width: 500,
      height: 80,
      decoration: BoxDecoration(
        color: AppTheme.background,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(100),
          bottomRight: Radius.circular(100),
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.topBarDropShadowColor,
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Wrap(
        spacing: 28,
        alignment: WrapAlignment.center,
        runAlignment: WrapAlignment.center,
        children: [
          RouteButton(
            name: "All Items",
            active: routeService.currentRoute == RouteService.clipboardRoute,
            onPressed: () {
              routeService.gotoRoute(RouteService.clipboardRoute);
            },
            icon: AppIcons.clipboard,
          ),
          RouteButton(
            name: "Emojis",
            active: routeService.currentRoute == RouteService.emojisRoute,
            onPressed: () {
              routeService.gotoRoute(RouteService.emojisRoute);
            },
            icon: AppIcons.emojis,
            enable: widget.enabled,
          ),
          RouteButton(
            name: "Texts",
            active: routeService.currentRoute == RouteService.notesRoute,
            onPressed: () {
              routeService.gotoRoute(RouteService.notesRoute);
            },
            icon: AppIcons.notes,
            enable: widget.enabled,
          ),
          RouteButton(
            name: "Commands",
            active: routeService.currentRoute == RouteService.commandsRoute,
            onPressed: () {
              routeService.gotoRoute(RouteService.commandsRoute);
            },
            icon: AppIcons.command,
            enable: widget.enabled,
          ),
          RouteButton(
            name: "App Settings",
            active: routeService.currentRoute == RouteService.settingsRoute,
            onPressed: () {
              routeService.gotoRoute(RouteService.settingsRoute);
            },
            icon: AppIcons.settings,
          ),
        ],
      ),
    );
  }
}

class RouteButton extends StatefulWidget {
  const RouteButton({
    super.key,
    required this.name,
    required this.active,
    required this.onPressed,
    required this.icon,
    bool? enable,
  }) : enabled = enable ?? !active;

  final String name;
  final bool active;
  final VoidCallback onPressed;
  final String icon;
  final bool enabled;

  @override
  State<RouteButton> createState() => _RouteButtonState();
}

class _RouteButtonState extends State<RouteButton> {
  bool hover = false;

  void onMouseEnter(e) {
    if (widget.enabled) {
      setState(() => hover = true);
    }
  }

  void onMouseExit(e) {
    if (widget.enabled) {
      setState(() => hover = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!widget.active && widget.enabled) {
          widget.onPressed();
        }
      },
      child: Tooltip(
        message: widget.name,
        child: MouseRegion(
          onEnter: onMouseEnter,
          onExit: onMouseExit,
          child: Column(
            children: [
              const SizedBox(height: 14),
              AnimatedScale(
                duration: const Duration(milliseconds: 250),
                scale: !hover ? 0.8 : 1.0,
                curve: Curves.decelerate,
                child: Image.asset(
                  widget.icon,
                  width: 48,
                  height: 48,
                ),
              ),
              if (widget.active)
                Icon(
                  Icons.keyboard_arrow_up_rounded,
                  color: AppTheme.activeRouteColor,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
