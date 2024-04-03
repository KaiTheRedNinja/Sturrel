//
//  SturrelApp.swift
//  Sturrel
//
//  Created by Kai Quan Tay on 27/10/23.
//

import SwiftUI
import SturrelModel

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // check if root loads
        do {
            try Root.load()
        } catch {
            StartManager.shared.shown = true
            return true
        }

        // check if theres updates
        DispatchQueue.main.async {
            let changes = Root.checkManifest()

            if !changes.isEmpty {
                StartManager.shared.changes = .init(changes: changes)
            }
        }

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
