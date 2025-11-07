//IPv4 session
// const String ipv4 = "192.168.80.102"; // ipv4 ของไวไฟ 555G
// const String ipv4 = "172.0.0.123"; // ipv4 ของไวไฟ CHOM TA WAN
const String ipv4 =
    "10.0.2.2"; // สำหรับ Android Emulator ให้เชื่อมต่อกับ localhost ของเครื่อง

//Header session
const Map<String, String> headers = {
  "Access-Control-Allow-Origin": "*",
  'Content-Type': 'application/json',
  'Accept-Language': 'th',
  'Accept': '*/*'
};

//Farmer session
const String baseURL = "http://" + ipv4 + ":8083";
// const String baseURL = "http://localhost:8080";
