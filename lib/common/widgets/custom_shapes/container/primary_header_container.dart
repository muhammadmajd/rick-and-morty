import 'package:flutter/cupertino.dart';
import 'package:rickmorty/core/constents/colors.dart' show TColors;

import '../curved_edges/curved_edges_widget.dart';
import 'circular_container.dart';

class TPrimaryHeaderContainer extends StatelessWidget {
  const TPrimaryHeaderContainer({
    super.key, required this.child,   this.color= TColors.primary,
  });
  final Widget child;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return TCurvedEdgeWidget(
      child: Container(
        //color: TColors.primary,
         //color: TColors.darkerGrey,
        color: color,
        padding: const EdgeInsets.all(0),
        /// -- If (size.isfinite': is not true.in Stack] error occurred
        child: Stack(
            children:[
              /// - - Background Custom Shapes
              Positioned(top: -150,right: - 250,child: TCircularContainer(backgroundColor: TColors.textWhite.withOpacity(0.1))),
              Positioned(top: 100,right: - 300,child: TCircularContainer(backgroundColor: TColors.textWhite.withOpacity(0.1))),
              child,

              //TCircularContainer(backgroundColor: TColors.textWhite.withOpacity(0.1)),
            ] ),
      ),
    );
  }
}

