//
//  cloneable_example_appApp.swift
//  cloneable-example-app
//
//  Created by Tyler Collins on 11/27/23.
//

import SwiftUI
import CloneableCore
import CloneablePlatformiOS

@main
struct cloneable_example_app: App {
    // instantiate the CloneablePlatform as a StateObject to use throughout our app
    @StateObject private var cloneable = CloneablePlatform(authType: .email, backend_env: .dev)
    
    init() {
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
