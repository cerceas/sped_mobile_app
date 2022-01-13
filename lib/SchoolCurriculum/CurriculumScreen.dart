import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
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
    fromAsset('assets/pdf/RequiredPDF.pdf', 'corrupted.pdf').then((f) {
      setState(() {
        corruptedPathPDF = f.path;
      });
    });
    fromAsset('assets/pdf/RequiredPDF.pdf', 'demo.pdf').then((f) {
      setState(() {
        pathPDF = f.path;
      });
    });
    fromAsset('assets/pdf/RequiredPDF.pdf', 'landscape.pdf').then((f) {
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
                        globals.userName = "";
                        globals.userid = "";
                        globals.section = "";
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()),
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
  final Completer<PDFViewController> _controller =
      Completer<PDFViewController>();
  int? pages = 0;
  int? currentPage = 0;
  bool isReady = false;
  String errorMessage = '';
  String dropdownValue = "One";

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
              globals.userName = "";
              globals.userid = "";
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
              });
            },
          ),
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
      bottomSheet: LinearProgressIndicator(
        backgroundColor: Colors.black,
        value: (currentPage! / 238),
        color: Colors.green,
        minHeight: 15.00,
      ),
      floatingActionButton: FutureBuilder<PDFViewController>(
        future: _controller.future,
        builder: (context, AsyncSnapshot<PDFViewController> snapshot) {
          if (snapshot.hasData) {
            // return FloatingActionButton.extended(
            //   label: Text("Go to Last page ${pages!-1}!"),
            //   onPressed: () async {
            //     await snapshot.data!.setPage(pages!);
            //   },
            // );
            return DropdownButton<String>(
              value: (currentPage!+1).toString(),
              icon: const Icon(Icons.arrow_downward),
              elevation: 16,
              style: const TextStyle(color: Colors.green),
              underline: Container(
                height: 2,
                color: Colors.white,
              ),
              onChanged: (String? newValue) async {
                dropdownValue = newValue!;
                await snapshot.data!.setPage(int.parse(newValue)-1);
              },
              items: <String>[
                "1",
                "2",
                "3",
                "4",
                "5",
                "6",
                "7",
                "8",
                "9",
                "10",
                "11",
                "12",
                "13",
                "14",
                "15",
                "16",
                "17",
                "18",
                "19",
                "20",
                "21",
                "22",
                "23",
                "24",
                "25",
                "26",
                "27",
                "28",
                "29",
                "30",
                "31",
                "32",
                "33",
                "34",
                "35",
                "36",
                "37",
                "38",
                "39",
                "40",
                "41",
                "42",
                "43",
                "44",
                "45",
                "46",
                "47",
                "48",
                "49",
                "50",
                "51",
                "52",
                "53",
                "54",
                "55",
                "56",
                "57",
                "58",
                "59",
                "60",
                "61",
                "62",
                "63",
                "64",
                "65",
                "66",
                "67",
                "68",
                "69",
                "70",
                "71",
                "72",
                "73",
                "74",
                "75",
                "76",
                "77",
                "78",
                "79",
                "80",
                "81",
                "82",
                "83",
                "84",
                "85",
                "86",
                "87",
                "88",
                "89",
                "90",
                "91",
                "92",
                "93",
                "94",
                "95",
                "96",
                "97",
                "98",
                "99",
                "100",
                "101",
                "102",
                "103",
                "104",
                "105",
                "106",
                "107",
                "108",
                "109",
                "110",
                "111",
                "112",
                "113",
                "114",
                "115",
                "116",
                "117",
                "118",
                "119",
                "120",
                "121",
                "122",
                "123",
                "124",
                "125",
                "126",
                "127",
                "128",
                "129",
                "130",
                "131",
                "132",
                "133",
                "134",
                "135",
                "136",
                "137",
                "138",
                "139",
                "140",
                "141",
                "142",
                "143",
                "144",
                "145",
                "146",
                "147",
                "148",
                "149",
                "150",
                "151",
                "152",
                "153",
                "154",
                "155",
                "156",
                "157",
                "158",
                "159",
                "160",
                "161",
                "162",
                "163",
                "164",
                "165",
                "166",
                "167",
                "168",
                "169",
                "170",
                "171",
                "172",
                "173",
                "174",
                "175",
                "176",
                "177",
                "178",
                "179",
                "180",
                "181",
                "182",
                "183",
                "184",
                "185",
                "186",
                "187",
                "188",
                "189",
                "190",
                "191",
                "192",
                "193",
                "194",
                "195",
                "196",
                "197",
                "198",
                "199",
                "200",
                "201",
                "202",
                "203",
                "204",
                "205",
                "206",
                "207",
                "208",
                "209",
                "210",
                "211",
                "212",
                "213",
                "214",
                "215",
                "216",
                "217",
                "218",
                "219",
                "220",
                "221",
                "222",
                "223",
                "224",
                "225",
                "226",
                "227",
                "228",
                "229",
                "230",
                "231",
                "232",
                "233",
                "234",
                "235",
                "236",
                "237",
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            );
          }

          return Container();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
