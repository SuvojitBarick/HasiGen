import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ShowTags extends StatefulWidget {
  final List tags;
  final Function refresh;
  final bool imageSearching;
  final File image;
  const ShowTags(
      {Key key, this.tags, this.refresh, this.imageSearching, this.image})
      : super(key: key);
  @override
  _ShowTagsState createState() => _ShowTagsState();
}

class _ShowTagsState extends State<ShowTags> {
  @override
  Widget build(BuildContext context) {
    return widget.tags != null
        ? Column(
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 20),
                alignment: Alignment.topLeft,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: copyText,
                        child: Text(
                          "Copy",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: "gilroy",
                              fontSize: 20),
                        ),
                      ),
                      InkWell(
                        onTap: widget.refresh,
                        child: Container(
                          child: Row(children: [
                            Text(
                              "Popular",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "gilroy",
                                  fontSize: 20),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Icon(
                              Icons.refresh,
                              color: Colors.white,
                            )
                          ]),
                        ),
                      ),
                    ]),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      widget.imageSearching
                          ? showImage(widget.image)
                          : Container(),
                      SizedBox(
                        height: 5,
                      ),
                      Wrap(
                        children: widget.tags.map((element) {
                          return element.length != 1
                              ? Chip(
                                  deleteButtonTooltipMessage: "Tag deleted",
                                  label: Text(
                                    element,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: "gilroy",
                                        fontSize: 14),
                                  ),
                                  backgroundColor:
                                      Colors.white.withOpacity(0.5),
                                  onDeleted: () {
                                    setState(() {
                                      widget.tags.remove(element);
                                    });
                                  },
                                  deleteIcon: Icon(
                                    Icons.clear,
                                    color: Colors.grey,
                                    size: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                )
                              : Container();
                        }).toList(),
                        alignment: WrapAlignment.start,
                        direction: Axis.horizontal,
                        spacing: 5,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
        : Text("Error");
  }

  void copyText() async {
    String copiedText = "";
    widget.tags.forEach((element) {
      if (element.length != 0) copiedText += element;
    });
    ClipboardData data = ClipboardData(text: copiedText);
    await Clipboard.setData(data);
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text("Hashtags copied to clipboard"),
    ));
  }

  Widget showImage(File image) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      width: MediaQuery.of(context).size.height * 0.4,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.file(
          image,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
