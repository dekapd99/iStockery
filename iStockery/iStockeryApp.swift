//
//  iStockeryApp.swift
//  iStockery
//
//  Created by Deka Primatio on 03/06/22.
//

import SwiftUI
import UIKit    // mengaktifkan library UIKit
import Firebase // mengaktifkan library Firebase

// AppDelegate: Konfirgurasi Firestore
class AppDelegate: NSObject, UIApplicationDelegate{
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        FirebaseApp.configure() // Mengaktifkan Konfigurasi FirebaseApp
        
        // Mengakses Konfigurasi Firestore Settings
        let settings = Firestore.firestore().settings
        
        // Conditional Fragment: Konfigurasi Firestore Settings
        #if targetEnvironment(simulator)
        settings.host = "localhost:9000" // sesuaikan dengan port yang digunakan di Firebase CLI
        // PersistenceEnabled: Firestore support offline storing sistem
        settings.isPersistenceEnabled = false // False karena Storing Data terjadi ketika Online saja
        settings.isSSLEnabled = false // karena kita konek ke https
        #endif
        
        // Simpan Konfigurasi Firestore Settings yang Baru
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
            NavigationView{
                ContentView()
            }
        }
    }
}
