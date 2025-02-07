import Flutter
import UIKit
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate {

  func loadGoogleMapsAPIKey() -> String? {
      if let path = Bundle.main.path(forResource: "appkey", ofType: "plist"),
         let dict = NSDictionary(contentsOfFile: path),
         let apiKey = dict["GOOGLE_MAPS_API_KEY"] as? String {
          return apiKey
      }
      print("⚠️ appkey.plist 파일에서 GOOGLE_MAPS_API_KEY를 찾을 수 없습니다.")
      return nil
  }

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    if let apiKey = loadGoogleMapsAPIKey() {
        GMSServices.provideAPIKey(apiKey)
    } else {
        print("⚠️ Google Maps API Key가 설정되지 않았습니다!")
    }

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

//import Flutter
//import UIKit
//import GoogleMaps
//
//@main
//@objc class AppDelegate: FlutterAppDelegate {
//  override func application(
//    _ application: UIApplication,
//    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
//  ) -> Bool {
//    GMSServices.provideAPIKey("AIzaSyDwxN1ovzf72AcXl6A6WCwWytCLcu5f6Rs")
//    GeneratedPluginRegistrant.register(with: self)
//    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
//  }
//}
