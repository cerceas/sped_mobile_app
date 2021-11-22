import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:sped_mobile_app/LogAndReg/LoginScreen.dart';
import 'package:sped_mobile_app/SideDrawer.dart';
import 'package:sped_mobile_app/tool.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:sped_mobile_app/Globals/globals.dart' as globals;
class SchoolCurriculum extends StatefulWidget {
  @override
  _SchoolCurriculumState createState() => _SchoolCurriculumState();
}

class _SchoolCurriculumState extends State<SchoolCurriculum> {
  String? pathPDF;
  String landscapePathPdf = "";
  String remotePDFpath = "";
  String corruptedPathPDF = "";

  @override
  void initState() {
    super.initState();
    fromAsset('assets/pdf/1800500004-lesson15.pdf', 'corrupted.pdf').then((f) {
      setState(() {
        corruptedPathPDF = f.path;
      });
    });
    fromAsset('assets/pdf/1800500004-lesson15.pdf', 'demo.pdf').then((f) {
      setState(() {
        pathPDF = f.path;
      });
    });
    fromAsset('assets/pdf/1800500004-lesson15.pdf', 'landscape.pdf').then((f) {
      setState(() {
        landscapePathPdf = f.path;
      });
    });
  }

  Future<File> fromAsset(String asset, String filename) async {
    // To open from assets, you can copy them to the app storage folder, and the access them "locally"
    Completer<File> completer = Completer();

    try {
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/$filename");
      var data = await rootBundle.load(asset);
      var bytes = data.buffer.asUint8List();
      await file.writeAsBytes(bytes, flush: true);
      completer.complete(file);
    } catch (e) {
      throw Exception('Error parsing asset file!');
    }

    return completer.future;
  }

  Future<bool> fetchData() => Future.delayed(Duration(seconds: 1), () {
        return true;
      });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            debugPrint('Step 3, build widget: ${snapshot.data}');
            // Build the widget with data.
            return PDFScreen(
              path: pathPDF,
            );
          } else {
            // We can show the loading view until the data comes back.
            debugPrint('Step 1, build loading widget');
            return Scaffold(
                drawer: SideDrawer(state: "School Curriculum"),
                appBar: AppBar(
                  actions: [
                    IconButton(
                      icon: Icon(
                        Icons.logout,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        globals.userName="";
                        globals.userid="";
                        globals.section="";
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) => LoginScreen()),
                                (Route<dynamic> route) => false);
                      },
                    )
                  ],
                  iconTheme: IconThemeData(color: Colors.white),
                  title: Text("School Curriculum"),
                  // automaticallyImplyLeading: false,
                  elevation: 3,
                  backgroundColor: hexToColor("#2c3136"),
                ),
                backgroundColor: Colors.white,
                body: Center(child: CircularProgressIndicator()));
          }
        },
      ),
    );
  }
}

class PDFScreen extends StatefulWidget {
  String? path;

  PDFScreen({Key? key, this.path}) : super(key: key);

  _PDFScreenState createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> with WidgetsBindingObserver {
  final _currentPageNotifier = ValueNotifier<int>(0);

  final Completer<PDFViewController> _controller =
      Completer<PDFViewController>();
  int? pages = 0;
  int? currentPage = 0;
  bool isReady = false;
  String errorMessage = '';

  _buildCircleIndicator2(items) {
    return CirclePageIndicator(
      size: 16.0,
      selectedSize: 18.0,
      itemCount: items,
      currentPageNotifier: _currentPageNotifier,
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideDrawer(state: "School Curriculum"),
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(
              Icons.logout,
              color: Colors.white,
            ),
            onPressed: () {
              globals.userName="";
              globals.userid="";
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                      (Route<dynamic> route) => false);
            },
          )
        ],
        iconTheme: IconThemeData(color: Colors.white),
        title: Text("School Curriculum"),
        // automaticallyImplyLeading: false,
        elevation: 3,
        backgroundColor: hexToColor("#2c3136"),
      ),
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          PDFView(
            filePath: widget.path,
            enableSwipe: true,
            swipeHorizontal: true,
            autoSpacing: false,
            pageFling: true,
            pageSnap: true,
            defaultPage: currentPage!,
            fitPolicy: FitPolicy.BOTH,
            preventLinkNavigation: false,
            // if set to true the link is handled in flutter
            onRender: (_pages) {
              setState(() {
                pages = _pages;
                isReady = true;
              });
            },
            onError: (error) {
              setState(() {
                errorMessage = error.toString();
              });
              print(error.toString());
            },
            onPageError: (page, error) {
              setState(() {
                errorMessage = '$page: ${error.toString()}';
              });
              print('$page: ${error.toString()}');
            },
            onViewCreated: (PDFViewController pdfViewController) {
              _controller.complete(pdfViewController);
            },
            onLinkHandler: (String? uri) {
              print('goto uri: $uri');
            },
            onPageChanged: (int? page, int? total) {
              print('page change: $page/$total');
              setState(() {
                currentPage = page;
                _currentPageNotifier.value = page!;
              });
            },
          ),
          Align(child: _buildCircleIndicator2(5),
            alignment: Alignment.bottomCenter,heightFactor:35,),
          errorMessage.isEmpty
              ? !isReady
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Container()
              : Center(
                  child: Text(errorMessage),
                )
        ],
      ),
      floatingActionButton: FutureBuilder<PDFViewController>(
        future: _controller.future,
        builder: (context, AsyncSnapshot<PDFViewController> snapshot) {
          if (snapshot.hasData) {
            return FloatingActionButton.extended(
              label: Text("Go to ${pages! ~/ 2}"),
              onPressed: () async {
                await snapshot.data!.setPage(pages! ~/ 2);
              },
            );
          }

          return Container();
        },
      ),
    );
  }
}
