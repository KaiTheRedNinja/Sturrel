//
//  SturrelApp.swift
//  Sturrel
//
//  Created by Kai Quan Tay on 27/10/23.
//

import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        Root.load()
        return true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        print("Entered background, saving")
        Root.save()
        FoldersDataManager.shared.save()
        VocabDataManager.shared.save()
    }
}

@main
struct SturrelApp: App {
    @UIApplicationDelegateAdaptor var appDelegate: AppDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
