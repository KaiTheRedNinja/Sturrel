//
//  ChineseWordSearchTestApp.swift
//  ChineseWordSearchTest
//
//  Created by Kai Quan Tay on 18/10/23.
//

import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    func applicationDidEnterBackground(_ application: UIApplication) {
        print("Entered background, saving")
        RootDataManager.shared.save()
        FoldersDataManager.shared.save()
        VocabDataManager.shared.save()
    }
}

@main
struct ChineseWordSearchTestApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
