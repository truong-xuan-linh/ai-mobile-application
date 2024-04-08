import 'package:flutter/material.dart';
import 'translation.dart';

class TranslationApp extends StatefulWidget {
  const TranslationApp({super.key});

  @override
  State<TranslationApp> createState() => _TranslationAppState();
}

class _TranslationAppState extends State<TranslationApp> {
  String fromLanguage = 'Vietnamese';
  String toLanguage = 'English';
  String translatedContent = "";
  Map<String, String> languageMapper = {
    'Vietnamese': 'vi',
    'English': 'en',
    'Korean': 'ko',
  };

  bool isLoading = true;
  TextEditingController controller =
      TextEditingController();

  Map<String, List> languages = {
    'English': ["Vietnamese"],
    'Vietnamese': ["English"],
    'Korean': ["English"],
  };

  @override
  void initState() {
    super.initState();
    changeTranslator();
  }

  var myTranslator =  MyTranslator().createWithoutAsync('vi', 'en');

  void translationFunction() async {
    
    
    setState(() {
      isLoading = true;
    });
    translatedContent = await myTranslator.translation(controller.text, languageMapper[fromLanguage]!, languageMapper[toLanguage]!);

    setState(() {
      isLoading = false;
    });
  }

  Future <MyTranslator> initTranslator() async {
    myTranslator = await MyTranslator().create(languageMapper[fromLanguage]!, languageMapper[toLanguage]!);
    return myTranslator;
  }
  
  void changeTranslator() async {
    
    
    setState(() {
      isLoading = true;
    });

    myTranslator.dispose();
    myTranslator = await initTranslator();

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            color: Colors.black,
            icon: const Icon(Icons.arrow_back_ios),
            iconSize: 20.0,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Playground ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Text(
                'Translator             ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(150, 133, 255, 1),
                ),
              )
            ],
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            // height: double.infinity,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.symmetric(horizontal: 60),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(150, 133, 255, 1),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5), // Màu của bóng
                        spreadRadius: 3, // Độ mở rộng của bóng
                        blurRadius: 7, // Độ mờ của bóng
                        offset: const Offset(0,
                            3), // Độ dịch chuyển của bóng theo chiều ngang và dọc
                      )
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Text(
                        'From',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                      DropdownButton(
                          value: fromLanguage,
                          items: languages.keys.map((key) {
                            return DropdownMenuItem(
                              value: key,
                              child: Text(
                                key,
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {

                            // setState(() {
                            fromLanguage = value!;
                            toLanguage = languages[fromLanguage]?[0];
                            changeTranslator();
                            // isLoading = false;
                            // });
                        })
                    ],
                  ),
                ),
                Container(
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color: const Color.fromRGBO(254, 249, 239, 1),
                        borderRadius: BorderRadius.circular(10),
                        border:
                            Border.all(color: Colors.black.withOpacity(0.05))),
                    child: TextFormField(
                      controller: controller,
                      maxLines: null,
                      minLines: null,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please Enter Some Text";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                          hintText: 'Enter Some Text',
                          enabledBorder: InputBorder.none,
                          border: InputBorder.none,
                          errorBorder: InputBorder.none,
                          errorStyle: TextStyle(color: Colors.white)),
                      style: const TextStyle(color: Colors.black, fontSize: 16),
                    )),
                Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.symmetric(horizontal: 60),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(162, 210, 255, 1),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5), // Màu của bóng
                        spreadRadius: 3, // Độ mở rộng của bóng
                        blurRadius: 7, // Độ mờ của bóng
                        offset: const Offset(0,
                            3), // Độ dịch chuyển của bóng theo chiều ngang và dọc
                      )
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Text(
                        'To',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                      DropdownButton(
                          value: toLanguage,
                          items: languages[fromLanguage]?.map((lang) {
                            return DropdownMenuItem(
                              value: lang,
                              child: Text(
                                lang,
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {

                            // setState(() {
                            toLanguage = value as String;
                            changeTranslator();
                            // isLoading = false;
                            // });
                              
                          })
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(254, 249, 239, 1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black.withOpacity(0.05)),
                  ),
                  child: Center(
                    child: SelectableText(
                      translatedContent,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: isLoading ? null : translationFunction,
                  style: const ButtonStyle(
                    maximumSize: MaterialStatePropertyAll(Size(300, 45)),
                  ),
                  child: isLoading
                      ? const SizedBox.square(
                          dimension: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          "Translate",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(150, 133, 255, 1),
                          ),
                        ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
