import 'package:flutter/material.dart';

class Status extends StatefulWidget {
  const Status({
    Key? key,
  }) : super(key: key);

  @override
  State<Status> createState() => _StatusState();
}

class _StatusState extends State<Status> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text('picture'),
            SizedBox(
              width: 20,
            ),
            Text('name'),
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/Ble');
                },
                icon: Icon(Icons.bluetooth_outlined)),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '권장 산책 시간',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                SizedBox(
                  height: 3,
                ),
                Text(
                  '1시간',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '목표 산책 달성량',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                SizedBox(
                  height: 3,
                ),
                Text(
                  '80%',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ],
            )
          ],
        ),
      ],
    );
  }
}
