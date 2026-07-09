//
//  cloneable_example_appApp.swift
//  cloneable-example-app
//
//  Created by Tyler Collins on 11/27/23.
//

import SwiftUI
import CloneableCore
import CloneablePlatformiOS

// Get your API key at https://app.cloneable.ai/settings/api-keys
let YOUR_API_KEY = "PUT_YOUR_API_KEY_HERE"

@main
struct cloneable_example_app: App {
    // instantiate the CloneablePlatform as a StateObject to use throughout our app
    
    @StateObject private var cloneable = CloneablePlatform(authType: .api, apiKey: YOUR_API_KEY)
    
    
    init() {
        // Optional: enable AI attachment/scale-target detection. When set
        // (before CloneablePlatform is first constructed) the SDK downloads
        // the detection models and runs them on-device during pole workflows.
        // CloneablePlatform.setRoboflowAPIKey("YOUR_ROBOFLOW_API_KEY")

        // Register our custom components
        Components.addComponent(component: CloneableComponent(id: "504a23c1-9710-4881-8c24-a870ea2b69ef", type: ComponentType.logical, runtimes: [.cloud, .ios, .edge_linux], processingType: CountComponent.self))
        Components.registerUIComponent(component:         
                                        CloneableComponent(id: "52808a5e-3126-44e1-9d4c-86b41dcdccae", type: ComponentType.ui, runtimes: [.ios]),
                                       view: PdfViewComponent.self)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
            // add the CloneablePlatform as an environment object so that we can access it throughout the app
                .environmentObject(cloneable)
        }
    }
}
