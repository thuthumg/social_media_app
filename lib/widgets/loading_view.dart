import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black12,
      child: const Center(
        child: SizedBox(
          width: 48,
          height: 48,
          child: LoadingIndicator(
              indicatorType: Indicator.audioEqualizer, /// Required, The loading type of the widget
              colors: [Colors.white],       /// Optional, The color collections
              strokeWidth: 2,                     /// Optional, The stroke of the line, only applicable to widget which contains line
              backgroundColor: Colors.transparent,      /// Optional, Background of the widget
              pathBackgroundColor: Colors.black   /// Optional, the stroke backgroundColor
          ),
        ),
      ),
    );
  }
}