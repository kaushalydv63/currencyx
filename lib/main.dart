import 'dart:convert';
import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import "package:dropdown_search/dropdown_search.dart";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CurrencyConverterScreen(),
    );
  }
}

class CurrencyConverterScreen extends StatefulWidget {
  const CurrencyConverterScreen({super.key});

  @override
  State<CurrencyConverterScreen> createState() =>
      _CurrencyConverterScreenState();
}

class _CurrencyConverterScreenState extends State<CurrencyConverterScreen> {
  final TextEditingController amountController = TextEditingController(text: "1");

  final Map<String, String> countryCodes = {
    "AFN": "AF", "ALL": "AL", "AOA": "AO", "XCD": "AG",
    "ARS": "AR", "AMD": "AM", "AUD": "AU", "AZN": "AZ", "BSD": "BS", "BHD": "BH",
    "BDT": "BD", "BBB": "BB", "BYN": "BY", "BZD": "BZ", "XOF": "BJ", "BTN": "BT",
    "BOB": "BO", "BAM": "BA", "BWP": "BW", "BRL": "BR", "BND": "BN", "BGN": "BG",
    "BIF": "BI", "KHR": "KH", "XAF": "CM", "CAD": "CA", "CVE": "CV", "CLP": "CL",
    "CNY": "CN", "COP": "CO", "KMF": "KM", "CRC": "CR", "CUP": "CU", "CZK": "CZ",
    "DKK": "DK", "DJF": "DJ", "DOP": "DO", "USD": "US", "EGP": "EG", "FJD": "FJ",
    "GMD": "GM", "GEL": "GE", "GHS": "GH", "GTQ": "GT", "GNF": "GN", "GYD": "GY",
    "HTG": "HT", "HNL": "HN", "HUF": "HU", "ISK": "IS", "INR": "IN", "IDR": "ID",
    "IRR": "IR", "IQD": "IQ", "ILS": "IL", "JMD": "JM", "JPY": "JP", "JOD": "JO",
    "KZT": "KZ", "KES": "KE", "KWD": "KW", "KGS": "KG", "LAK": "LA", "LBP": "LB",
    "LSL": "LS", "LRD": "LR", "LYD": "LY", "CHF": "CH", "MGA": "MG", "MWK": "MW",
    "MYR": "MY", "MVR": "MV", "MRU": "MR", "MUR": "MU", "NAD": "NA", "NPR": "NP",
    "NZD": "NZ", "NIO": "NI", "NGN": "NG", "KPW": "KP", "MKD": "MK", "NOK": "NO",
    "OMR": "OM", "PKR": "PK", "PAB": "PA", "PGK": "PG", "PYG": "PY", "PEN": "PE",
    "PHP": "PH", "PLN": "PL", "QAR": "QA", "RON": "RO", "RUB": "RU", "RWF": "RW",
    "WST": "WS", "STN": "ST", "SAR": "SA", "RSD": "RS", "SCR": "SC", "SLE": "SL",
    "SGD": "SG", "SBD": "SB", "SOS": "SO", "ZAR": "ZA", "KRW": "KR", "SSP": "SS",
    "LKR": "LK", "SDG": "SD", "SRD": "SR", "SEK": "SE", "SYP": "SY", "TWD": "TW",
    "TJS": "TJ", "TZS": "TZ", "THB": "TH", "TOP": "TO", "TTD": "TT", "TND": "TN",
    "TRY": "TR", "TMT": "TM", "UGX": "UG", "UAH": "UA", "AED": "AE", "GBP": "GB",
    "UYU": "UY", "UZS": "UZ", "VUV": "VU", "VES": "VE", "VND": "VN", "YER": "YE",
    "ZMW": "ZM", "ZiG": "ZW"
  };

  final Map<String, String> countryNames = {
    "AFN": "Afghanistan (AFN)", "ALL": "Albania (ALL)",
    "AOA": "Angola (AOA)", "XCD": "Antigua & Barbuda / Dominica (XCD)",
    "ARS": "Argentina (ARS)", "AMD": "Armenia (AMD)", "AUD": "Australia / Kiribati (AUD)",
    "AZN": "Azerbaijan (AZN)", "BSD": "Bahamas (BSD)", "BHD": "Bahrain (BHD)",
    "BDT": "Bangladesh (BDT)", "BBB": "Barbados (BBDB)", "BYN": "Belarus (BYN)",
    "BZD": "Belize (BZD)", "XOF": "Benin / Burkina Faso / Guinea-Bissau / Mali / Niger / Senegal / Togo (XOF)",
    "BTN": "Bhutan (BTN)", "BOB": "Bolivia (BOB)", "BAM": "Bosnia & Herzegovina (BAM)",
    "BWP": "Botswana (BWP)", "BRL": "Brazil (BRL)", "BND": "Brunei (BND)",
    "BGN": "Bulgaria (BGN)", "BIF": "Burundi (BIF)", "KHR": "Cambodia (KHR)",
    "XAF": "Cameroon / Central African Republic / Chad / Congo / Gabon (XAF)",
    "CAD": "Canada (CAD)", "CVE": "Cape Verde (CVE)", "CLP": "Chile (CLP)",
    "CNY": "China (CNY)", "COP": "Colombia (COP)", "KMF": "Comoros (KMF)",
    "CRC": "Costa Rica (CRC)", "CUP": "Cuba (CUP)", "CZK": "Czech Republic (CZK)",
    "DKK": "Denmark (DKK)", "DJF": "Djibouti (DJF)", "DOP": "Dominican Republic (DOP)",
    "USD": "USA / Ecuador / El Salvador / Marshall Islands / Palau / Timor-Leste (USD)",
    "EGP": "Egypt (EGP)", "FJD": "Fiji (FJD)", "GMD": "Gambia (GMD)", "GEL": "Georgia (GEL)",
    "GHS": "Ghana (GHS)", "GTQ": "Guatemala (GTQ)", "GNF": "Guinea (GNF)", "GYD": "High (GYD)",
    "HTG": "Haiti (HTG)", "HNL": "Honduras (HNL)", "HUF": "Hungary (HUF)", "ISK": "Iceland (ISK)",
    "INR": "India (INR)", "IDR": "Indonesia (IDR)", "IRR": "Iran (IRR)", "IQD": "Iraq (IQD)",
    "ILS": "Israel (ILS)", "JMD": "Jamaica (JMD)", "JPY": "Japan (JPY)", "JOD": "Jordan (JOD)",
    "KZT": "Kazakhstan (KZT)", "KES": "Kenya (KES)", "KWD": "Kuwait (KWD)", "KGS": "Kyrgyzstan (KGS)",
    "LAK": "Laos (LAK)", "LBP": "Lebanon (LBP)", "LSL": "Lesotho (LSL)", "LRD": "Liberia (LRD)",
    "LYD": "Libya (LYD)", "CHF": "Switzerland / Liechtenstein (CHF)", "MGA": "Madagascar (MGA)",
    "MWK": "Malawi (MWK)", "MYR": "Malaysia (MYR)", "MVR": "Maldives (MVR)", "MUR": "Mauritius (MUR)",
    "NAD": "Namibia (NAD)", "NPR": "Nepal (NPR)", "NZD": "New Zealand (NZD)", "NIO": "Nicaragua (NIO)",
    "NGN": "Nigeria (NGN)", "KPW": "North Korea (KPW)", "MKD": "North Macedonia (MKD)",
    "NOK": "Norway (NOK)", "OMR": "Oman (OMR)", "PKR": "Pakistan (PKR)", "PAB": "Panama (PAB)",
    "PGK": "Papua New Guinea (PGK)", "PYG": "Paraguay (PYG)", "PEN": "Peru (PEN)", "PHP": "Philippines (PHP)",
    "PLN": "Poland (PLN)", "QAR": "Qatar (QAR)", "RON": "Romania (RON)", "RUB": "Russia (RUB)",
    "RWF": "Rwanda (RWF)", "WST": "Samoa (WST)", "STN": "Sao Tome & Principe (STN)",
    "SAR": "Saudi Arabia (SAR)", "RSD": "Serbia (RSD)", "SCR": "Seychelles (SCR)", "SLE": "Sierra Leone (SLE)",
    "SGD": "Singapore (SGD)", "SBD": "Solomon Islands (SBD)", "SOS": "Somalia (SOS)",
    "ZAR": "South Africa (ZAR)", "KRW": "South Korea (KRW)", "SSP": "South Sudan (SSP)",
    "LKR": "Sri Lanka (LKR)", "SDG": "Sudan (SDG)", "SRD": "Suriname (SRD)", "SEK": "Sweden (SEK)",
    "SYP": "Syria (SYP)", "TWD": "Taiwan (TWD)", "TJS": "Tajikistan (TJS)", "TZS": "Tanzania (TZS)",
    "THB": "Thailand (THB)", "TOP": "Tonga (TOP)", "TTD": "Trinidad & Tobago (TTD)",
    "TND": "Tunisia (TND)", "TRY": "Turkey (TRY)", "TMT": "Turkmenistan (TMT)", "UGX": "Uganda (UGX)",
    "UAH": "Ukraine (UAH)", "AED": "United Arab Emirates (AED)", "GBP": "United Kingdom (GBP)",
    "UYU": "Uruguay (UYU)", "UZS": "Uzbekistan (UZS)", "VUV": "Vanuatu (VUV)", "VES": "Venezuela (VES)",
    "VND": "Vietnam (VND)", "YER": "Yemen (YER)", "ZMW": "Zambia (ZMW)", "ZiG": "Zimbabwe (ZiG)"
  };

  String getCurrencySymbol(String currencyCode) {
    final Map<String, String> symbols = {
      "USD": "\$", "INR": "₹", "EUR": "€", "GBP": "£", "JPY": "¥",
      "CNY": "¥", "RUB": "₽", "KRW": "₩", "AFN": "؋", "ALL": "L",
      "AMD": "֏", "ANG": "ƒ", "AOA": "Kz", "ARS": "\$", "AUD": "\$",
      "AWG": "ƒ", "AZN": "₼", "BAM": "KM", "BBD": "\$", "BDT": "৳",
      "BGN": "лв", "BHD": ".د.ب", "BIF": "FBu", "BMD": "\$", "BND": "\$",
      "BOB": "Bs.", "BRL": "R\$", "BSD": "\$", "BTN": "Nu.", "BWP": "P",
      "BYN": "Br", "BZD": "BZ\$", "CAD": "\$", "CDF": "FC", "CHF": "CHF",
      "CLP": "\$", "COP": "\$", "CRC": "₡", "CUP": "₱", "CVE": "\$",
      "CZK": "Kč", "DJF": "Fdj", "DKK": "kr", "DOP": "RD\$", "DZD": "دج",
      "EGP": "E£", "ERN": "Nfk", "ETB": "Br", "FJD": "\$", "FKP": "£",
      "GEL": "₾", "GHS": "₵", "GIP": "£", "GMD": "D", "GNF": "FG",
      "GTQ": "Q", "GYD": "\$", "HKD": "\$", "HNL": "L", "HRK": "kn",
      "HTG": "G", "HUF": "Ft", "IDR": "Rp", "ILS": "₪", "IQD": "ع.د",
      "IRR": "﷼", "ISK": "kr", "JMD": "J\$", "JOD": "د.ا", "KES": "KSh",
      "KGS": "в", "KHR": "៛", "KMF": "CF", "KPW": "₩", "KWD": "د.ك",
      "KYD": "\$", "KZT": "₸", "LAK": "₭", "LBP": "ل.ل", "LKR": "₨",
      "LRD": "\$", "LSL": "M", "LYD": "د.ل", "MAD": "د.م.", "MDL": "L",
      "MGA": "Ar", "MKD": "ден", "MMK": "K", "MNT": "₮", "MOP": "MOP\$",
      "MRU": "UM", "MUR": "₨", "MVR": ".Rf", "MWK": "MK", "MXN": "\$",
      "MYR": "RM", "MZN": "MT", "NAD": "\$", "NGN": "₦", "NIO": "C\$",
      "NOK": "kr", "NPR": "₨", "NZD": "\$", "OMR": "ر.ع.", "PAB": "B/.",
      "PEN": "S/.", "PGK": "K", "PHP": "₱", "PKR": "₨", "PLN": "zł",
      "PYG": "Gs", "QAR": "ر.ق", "RON": "lei", "RSD": "дин.", "RWF": "FRw",
      "SAR": "ر.س", "SBD": "\$", "SCR": "₨", "SDG": "ج.س.", "SEK": "kr",
      "SGD": "\$", "SHP": "£", "SLE": "Le", "SLL": "Le", "SOS": "Sh",
      "SRD": "\$", "SSP": "£", "STN": "Db", "SYP": "£", "SZL": "L",
      "THB": "฿", "TJS": "SM", "TMT": "T", "TND": "د.ت", "TOP": "T\$",
      "TRY": "₺", "TTD": "TT\$", "TWD": "NT\$", "TZS": "TSh", "UAH": "₴",
      "UGX": "USh", "UYU": "\$U", "UZS": "so'm", "VES": "Bs.S", "VND": "₫",
      "VUV": "VT", "WST": "WS\$", "XAF": "FCFA", "XCD": "\$", "XOF": "CFA",
      "XPF": "₣", "YER": "﷼", "ZAR": "R", "ZMW": "ZK", "ZiG": "ZiG"
    };
    return symbols[currencyCode] ?? "";
  }

  String getFlagUrl(String currencyCode) {
    String countryCode = countryCodes[currencyCode] ?? "US";
    return "https://flagcdn.com/w40/${countryCode.toLowerCase()}.png";
  }

  List<String> get countryList => countryNames.values.toList();
  String fromCurrency = "AUD";
  String toCurrency = "INR";
  String result = "Loading...";

  Future<void> convertCurrency() async {
    try {
      final amount = double.tryParse(amountController.text) ?? 1;
      final url = "https://open.er-api.com/v6/latest/$fromCurrency";
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        double rate = (data["rates"][toCurrency] as num).toDouble();
        double convertedAmount = amount * rate;

        String fromSymbol = getCurrencySymbol(fromCurrency);
        String toSymbol = getCurrencySymbol(toCurrency);

        setState(() {
          result = "$fromSymbol$amount $fromCurrency = $toSymbol${convertedAmount.toStringAsFixed(2)} $toCurrency";
        });
      }
    } catch (e) {
      setState(() {
        result = "Something went wrong";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    convertCurrency();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text("Currency Converter"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
              decoration: const InputDecoration(
                labelText: "Enter Amount",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 40),
            Row(
              children: [
                // From Dropdown
                Expanded(
                  child: DropdownSearch<String>(
                    items: (filter, infiniteScrollProps) => countryList,
                    selectedItem: countryNames[fromCurrency],
                    popupProps: PopupProps.dialog(
                      showSearchBox: true,
                      searchFieldProps: const TextFieldProps(
                        decoration: InputDecoration(
                          hintText: "Search country...",
                          prefixIcon: Icon(Icons.search),
                        ),
                      ),
                      itemBuilder: (context, item, isDisabled, isSelected) {
                        String code = countryNames.entries
                            .firstWhere((e) => e.value == item)
                            .key;
                        return ListTile(
                          leading: Image.network(
                              getFlagUrl(code), width: 30, height: 20),
                          title: Text(item),
                          subtitle: Text(code),
                        );
                      },
                    ),
                    dropdownBuilder: (context, selectedItem) {
                      return Row(
                        children: [
                          Image.network(getFlagUrl(fromCurrency), width: 30, height: 20),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              fromCurrency,
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      );
                    },
                    decoratorProps: const DropDownDecoratorProps(
                      decoration: InputDecoration(
                        labelText: "From",
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                      ),
                    ),


                   onChanged: (value) {
                     if (value != null) {
                       setState(() {
                        fromCurrency = countryNames.entries
                        .firstWhere((e) => e.value == value)
                          .key;
                        });
                              convertCurrency();
                      }
                    },
                  ),
                ),

                // Swap Button in the Middle
                IconButton(
                  onPressed: () {
                    setState(() {
                      String temp = fromCurrency;
                      fromCurrency = toCurrency;
                      toCurrency = temp;
                    });
                    convertCurrency();
                  },
                  icon: const Icon(
                    Icons.swap_horiz,
                    size: 30,
                    color: Colors.lightBlueAccent,
                  ),
                ),

                // To Dropdown
                Expanded(
                  child: DropdownSearch<String>(
                    items: (filter, infiniteScrollProps) => countryList,
                    selectedItem: countryNames[toCurrency],
                    popupProps: PopupProps.dialog(
                      showSearchBox: true,
                      searchFieldProps: const TextFieldProps(
                        decoration: InputDecoration(
                          hintText: "Search country...",
                        ),
                      ),
                      itemBuilder: (context, item, isDisabled, isSelected) {
                        String code = countryNames.entries
                            .firstWhere((e) => e.value == item)
                            .key;
                        return ListTile(
                          leading: Image.network(
                              getFlagUrl(code), width: 30, height: 20),
                          title: Text(item),
                          subtitle: Text(code),
                        );
                      },
                    ),

                    dropdownBuilder: (context, selectedItem) {
                      return Row(
                        children: [
                          Image.network(getFlagUrl(toCurrency), width: 30, height: 20),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              toCurrency,
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      );
                    },

                    decoratorProps: const DropDownDecoratorProps(
                      decoration: InputDecoration(
                        labelText: "To",
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                      ),
                    ),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          toCurrency = countryNames.entries
                              .firstWhere((e) => e.value == value)
                              .key;
                        });
                        convertCurrency();
                      }
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 40),

            // Convert Button
            ElevatedButton(
              onPressed: convertCurrency,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                minimumSize: const Size(160, 45),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                "Convert",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 40),

            Text(
              result,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 380),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                SizedBox(width: 8),
                Text(
                  "@_kaushal_yadav_63",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}







