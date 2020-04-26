import UIKit
import Flutter
import GoogleMaps
import Firebase


@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate/*, UIResponder, UIApplicationDelegate */
{
    
    var newwindow: UIWindow?
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool 
  {
    FirebaseApp.configure() //inserted from below

    GeneratedPluginRegistrant.register(with: self)
    GMSServices.provideAPIKey("AIzaSyA1yYLr9YgOewrJrfdrvXfQB9faw97GBGM")
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    
  }

    
    /*
    override func application(_ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions:
    [UIApplication.LaunchOptionsKey: Any]?) -> Bool
      {
        FirebaseApp.configure()
        return true
      }
 */
}
