import 'package:flutter/material.dart';

class CarouselProducts extends StatefulWidget {
  final String image1;
  final String image2;
  const CarouselProducts({
    Key key,
    @required this.image1,
    @required this.image2,
  }) : super(key: key);
  @override
  _CarouselProductsState createState() => _CarouselProductsState();
}

class _CarouselProductsState extends State<CarouselProducts> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    List<String> images = [widget.image1, widget.image2];
    return Container(
      height: 250,
      child: Column(
        children: <Widget>[
          Expanded(
            child: PageView.builder(
              controller: PageController(viewportFraction: .75),
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemCount: images.length,
              itemBuilder: (ctx, id) {
                return Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      color: Colors.white),
                  margin: _currentIndex != id
                      ? const EdgeInsets.symmetric(
                          horizontal: 9.0,
                          vertical: 15,
                        )
                      : const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 0,
                        ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: Image.network(
                      "${images[id]}",
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 9),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              images.length,
              (i) {
                return Container(
                  width: 9,
                  height: 9,
                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: i == _currentIndex ? Colors.black : Colors.grey,
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
