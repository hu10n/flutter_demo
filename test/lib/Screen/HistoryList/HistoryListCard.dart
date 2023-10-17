import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'ModalForDetailInHistory.dart';

class HistoryListCard extends StatelessWidget {
  final machine;
  final Function onScrollDown;
  final Function onScrollUp;

  const HistoryListCard({
    required this.machine,
    required this.onScrollDown,
    required this.onScrollUp
  });

  @override
  Widget build(BuildContext context) {
    //print(machine);
    double screenWidth = MediaQuery.of(context).size.width;

    final project = machine["project"];

    final product_name = project["product_name"];
    final product_num = project["product_num"];
    final client_name = project["client_name"];
    final finished_at = project["updated_at"];

    return Card(
      
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () {
          onScrollDown(100);
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            enableDrag: false,
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(20))),
            builder: (context) => ModalContentForDetail_History(
              onScrollUp: onScrollUp,
              machine: machine,
              project: project,
            ),
          ).whenComplete(() {
            
            onScrollUp(100);
          });
        },
        child: SizedBox(
          width: screenWidth,
          //height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: [
                        Text(
                          "商品：",
                          style: TextStyle(
                            color: Theme.of(context).disabledColor, fontWeight: FontWeight.bold, fontSize: 12,
                          ),
                        ),
                        SizedBox(width: 10,),
                        Text(
                          "$product_name ($product_num)",
                          style: TextStyle(

                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Text(
                          "客先名：",
                          style: TextStyle(
                            color: Theme.of(context).disabledColor, fontWeight: FontWeight.bold, fontSize: 12,
                          ),
                        ),
                        SizedBox(width: 10,),
                        Text("$client_name")
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Text(
                          "納品日：",
                          style: TextStyle(
                            color: Theme.of(context).disabledColor, fontWeight: FontWeight.bold, fontSize: 12,
                          ),
                        ),
                        SizedBox(width: 10,),
                        Text("$finished_at")
                      ],
                    ),             
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Icon(Icons.chevron_right),
              )
              
            ],
          ),
        ),
      ),
    );
  }

  Widget _createStepStatusIcon(BuildContext context, int status) {
    Color iconColor;
    IconData iconData;
    switch (status) {
      // Disabled
      case 0:
        iconColor = Theme.of(context).disabledColor;
        iconData = Icons.pending;
        break;
      // On Going
      case -1:
        iconColor = Theme.of(context).colorScheme.tertiary;
        iconData = Icons.play_circle_fill;
        break;
      // Completed
      case 1:
        iconColor = Theme.of(context).colorScheme.secondary;
        iconData = Icons.check_circle_rounded;
        break;
      default:
        iconColor = Theme.of(context).disabledColor;
        iconData = Icons.check_circle_rounded;
    }

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Icon(
        iconData,
        color: iconColor,
        size: 25.0,
      ),
    );
  }

  Widget _createStepTitleLabel(String stepTitle) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
      child: Text(
        stepTitle,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _createStepListSubtitle(
      String worker, String updatedAt, String productionVolume) {
    return Row(
      children: [
        Flexible(
          flex: 5,
          child: _createSubtitleWithIcon(Icons.person, worker),
        ),
        Flexible(
          flex: 4,
          child: _createSubtitleWithIcon(
              Icons.inventory, productionVolume.toString()),
        ),
        Flexible(
          flex: 5,
          child: _createSubtitleWithIcon(Icons.update, updatedAt),
        ),
      ],
    );
  }

  Widget _createSubtitleWithIcon(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 13,
          color: Colors.grey,
        ),
        Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
