//
//  ChineseWordSearchTestApp.swift
//  ChineseWordSearchTest
//
//  Created by Kai Quan Tay on 18/10/23.
//

import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    func applicationWillTerminate(_ application: UIApplication) {
        VocabDataManager.shared.saveRoot()
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
