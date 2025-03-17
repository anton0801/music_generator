import Foundation
import FirebaseCore
import FirebaseAnalytics
import FirebaseMessaging
import AdSupport
import AppsFlyerLib
import AppTrackingTransparency

class MusicProGenDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate, AppsFlyerLibDelegate, MessagingDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        Analytics.setAnalyticsCollectionEnabled(true)
        if #available(iOS 10.0, *){
            UNUserNotificationCenter.current().delegate = self
            UNUserNotificationCenter.current().requestAuthorization(
                options: [.alert, .badge, .sound],
                completionHandler: { _, _ in
                    
                }
            )
        } else {
            let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()
        Messaging.messaging().delegate = self
        let shared = AppsFlyerLib.shared()
        shared.appleAppID = "6743251124"
        shared.appsFlyerDevKey = "cs954DA5Leo4KRp46np8T"
        shared.delegate = self
        shared.isDebug = false
        shared.waitForATTUserAuthorization(timeoutInterval: 60)
        NotificationCenter.default.addObserver(self, selector: #selector(ndsajknskadannnnnbbbsdd),
                                               name: UIApplication.didBecomeActiveNotification, object: nil)
        return true
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        messaging.token { token, _ in
            guard let token = token else { return }
            NotificationCenter.default.post(name: Notification.Name("fcm_received"), object: nil, userInfo: ["pushtoken": token])
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    @objc private func ndsajknskadannnnnbbbsdd() {
        AppsFlyerLib.shared().start()
        if #available(iOS 14, *) {
           ATTrackingManager.requestTrackingAuthorization { status in
               self.saveIDFA()
           }
       }
    }
    
    private func saveIDFA() {
        UserDefaults.standard.set(ASIdentifierManager.shared().advertisingIdentifier.uuidString, forKey: "idfa_of_user")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        if let pushId = notification.request.content.userInfo["push_id"] as? String {
            savePushId(pushId: pushId)
        }
        completionHandler([.badge, .sound, .alert])
    }
    
    func onConversionDataFail(_ error: Error) {
        NotificationCenter.default.post(name: Notification.Name("conversion_app"), object: nil, userInfo: [:])
    }
    
    func onConversionDataSuccess(_ conversionData: [AnyHashable: Any]) {
        NotificationCenter.default.post(name: Notification.Name("conversion_app"), object: nil, userInfo: ["data": conversionData])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if let pushId = response.notification.request.content.userInfo["push_id"] as? String {
            savePushId(pushId: pushId)
        }
        completionHandler()
    }
    
    private func savePushId(pushId: String) {
        UserDefaults.standard.set(pushId, forKey: "push_id")
    }
    
}
