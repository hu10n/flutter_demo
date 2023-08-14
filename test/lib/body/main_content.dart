import 'package:flutter/material.dart';

import '../wigets/top_navigation_fadeable.dart';
import '../wigets/scroll_body_content_in_dummydata.dart';


class MainContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        TopNavigation(),
        BodyContent(),
      ],
    );
  }
}
