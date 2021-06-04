//
//  LearningApp.swift
//  LearningApp
//
//  Created by Maximilian Kerling on 03.06.21.
//

import SwiftUI

@main
struct LearningApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(ContentModel())
        }
    }
}
