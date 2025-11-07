//IPv4 session
// const String ipv4 = "192.168.80.102"; // ipv4 ของไวไฟ 555G
const String ipv4 = "172.0.0.123"; // ipv4 ของไวไฟ CHOM TA WAN



//Header session
const Map<String, String> headers = {"Access-Control-Allow-Origin": "*",
      'Content-Type': 'application/json',
      'Accept-Language': 'th',
      'Accept': '*/*'};

//Farmer session
const String baseURL = "http://" + ipv4 + ":8081";
// const String baseURL = "http://localhost:8080";