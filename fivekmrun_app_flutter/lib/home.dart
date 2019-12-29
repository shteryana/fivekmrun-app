import 'package:fivekmrun_flutter/donate/donate_page.dart';
import 'package:fivekmrun_flutter/past_events/event_results_page.dart';
import 'package:fivekmrun_flutter/past_events/past_events_page.dart';
import 'package:fivekmrun_flutter/future_events/future_events_page.dart';
import 'package:fivekmrun_flutter/profile.dart';
import 'package:fivekmrun_flutter/runs/run_details_page.dart';
import 'package:fivekmrun_flutter/runs/user_runs_page.dart';
import 'package:flutter/material.dart';


class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class TabNavigator extends StatelessWidget {
  final Map<String, WidgetBuilder> routes;
  const TabNavigator({Key key, this.routes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
            builder: routes[settings.name], settings: settings);
      },
    );
  }
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static final List<Widget> _widgetOptions = <Widget>[
    ProfileDashboard(),
    TabNavigator(routes: {
      '/': (context) => UserRunsPage(),
      '/run-details': (context) => RunDetailsPage(),
    }),
    TabNavigator(routes: {
      '/': (context) => PastEventsPage(),
      '/event-results': (context) => EventResultsPage(),
    }),
    TabNavigator(routes: {
      '/': (context) => FutureEventsPage(),
    }),
    TabNavigator(routes: {
      '/': (context) => DonatePage(),
    }),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        // child: _widgetOptions.elementAt(_selectedIndex),
        child: IndexedStack(
          index: _selectedIndex,
          children: _widgetOptions,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text('Профил'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_run),
            title: Text('Бягания'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timer),
            title: Text('Резултати'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            title: Text('Събития'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            title: Text('Дарения'),
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
