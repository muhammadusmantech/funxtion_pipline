import 'package:flutter/material.dart';
import 'package:funxtion_app/error_handling.dart';
import 'package:ui_tool_kit/ui_tool_kit.dart';

void main() {
  runApp(const ErrorHandlerWidget(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Funxtion App',
      home: Home(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  final String bearerToken =
      "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJpYXQiOjE2OTg5MzAxNjAsImV4cCI6MTczMDQ2NjE2MCwianRpIjoiMDE4YjkwMjAtZjNkMi03MWI3LTlhMTQtMmEwM2I2OTMyYzhjIiwiZW1haWwiOiIwMThiOTAyMC1mM2QyLTcxYjctOWExNC0yYTAzYjY5MzJjOGMuYXBpX2NsaWVudEBmdW54dGlvbi5jb20iLCJzY29wZSI6ImFwaS1jbGllbnQiLCJvcmdJZCI6MTksImNvZGUiOiJldm9sdmVyc3RlY2gifQ.kZZUBTeyT6e1QyACbHFH3UNE23WHpKY7EPhJVLndWaUrIZTpF2CNcnf-VxlvEwWKDe9jvWXPd3mfpeMdqheEFCILAf8SjWwOKied44KKWb6VkjxaSZmtYREU3p_RyBSWFOwdnEHz8oqDw9gfKSvZh773dJUKK8-3q1S5Xe3jkayuJpgBUNumUVvuIbRJLINhwfA5M9yc3c-Zbv3nHTOvQkIJaCdywHXRe30urM-qz7KT3l_iqrw0e7VUZurHQFfEyH2V7pDqqTkoFTG5YlIpbL1TFh1SIH4Yl1ewG1E1LLTSkGfbX8oOmFICzxoQyxC1HeATtYZ3RnF6_j85A_s2_qyBNy5X7XrKaoCzkmO3Zj25nXiV1lNqSTz-X8_sTsFNiCW4CFNYppCrvLaKjwZfBZnbxEp1MKlj54OGy34vxR5_1XSa08Uxei_CwfdX9dto5RoXruDf7VP808pgdAwTdl6GKeiU5tpJ1xfTHmcyzvPgDXNV-t4ZhTE_Uqt84YQEZJOspIFF1mxNONjVJUAfM0axv_9LDXEeKlGx8MIrnlQHGYA19UfG2fzWa26YuFIMSt9NOb-SOpU8jN6V8AxZmpquKWdaDc5FNujQvdF4Jc5tj5KJP2BTkyaosbvmo75b7jOVUAFSK7vpgd9ZWWc99yiT8109kQnTgI7j-Eeuuz8";

  @override
  Widget build(BuildContext context) {
    return UiToolKitSDK(
        categoryName: CategoryName.dashBoard, token: bearerToken);
  }
}
