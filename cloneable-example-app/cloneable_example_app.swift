//
//  cloneable_example_appApp.swift
//  cloneable-example-app
//
//  Created by Tyler Collins on 11/27/23.
//

import SwiftUI
import CloneablePlatformiOS

@main
struct cloneable_example_app: App {
    // instantiate the CloneablePlatform as a StateObject to use throughout our app
    @StateObject private var cloneable = CloneablePlatform(authType: .email, backend_env: .dev)
    
    var body: some Scene {
        WindowGroup {
            ContentView()
            // add the CloneablePlatform as an environment object so that we can access it throughout the app
                .environmentObject(cloneable)
        }
    }
}
