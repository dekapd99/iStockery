//
//  iStockeryApp.swift
//  iStockery
//
//  Created by Deka Primatio on 03/06/22.
//

import Firebase // mengaktifkan library Firebase
import SwiftUI
import UIKit // mengaktifkan library UIKit

// Collect App Delegate Class
class AppDelegate: NSObject, UIApplicationDelegate{
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        FirebaseApp.configure() // konfigure firebase app (breakpoint)
        
        // konek local Firebase environment ketika target simulator iOS
        let settings = Firestore.firestore().settings
        
        // Conditional Fragment
        #if targetEnvironment(simulator)
        settings.host = "localhost:9000" // targetkan portnya
        settings.isPersistenceEnabled = false // firestore support offline storing sistem tapi karena kita make ini secara lokal maka storing data terjadi hanya ketika kita online saja sehingga dibuat False
        settings.isSSLEnabled = false // karena kita konek ke https
        #endif
        
        // konfigurasi firestore dengan menggunakan setting yang baru yaitu fragment diatas
        Firestore.firestore().settings = settings
        
        return true
    }
}

@main
struct iStockeryApp: App {
    
    // Konek app delegate dengan iStockery app
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
