import 'package:flutter/material.dart';

class HomeQuickAction {
	const HomeQuickAction({
		required this.title,
		required this.icon,
		required this.route,
	});

	final String title;
	final IconData icon;
	final String route;
}

class HomeModel {
	const HomeModel({
		required this.greeting,
		required this.quickActions,
	});

	final String greeting;
	final List<HomeQuickAction> quickActions;
}

