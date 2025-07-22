//
//  ContentView.swift
//  cloneable-example-app
//
//  Created by Tyler Collins on 11/27/23.
//

import SwiftUI
import CloneablePlatformiOS

struct ContentView: View {
    @EnvironmentObject var cloneable: CloneablePlatform
    @State private var showingSettingsSheet = false

    var body: some View {
        if cloneable.authStatus == .authenticated {
            NavigationView {
                ZStack {
                    // We wrap our app views in the CloneableWrapper
                    // This may wrap views at a higher level in your app
                    // The Cloneable Wrapper allows Cloneable to take over rendering when a workflow starts
                    CloneableWorkflowWrapper(cloneablePlatform: cloneable) {
                        VStack {
                            // Utility Workflows Section
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Text("Utility Workflows")
                                        .font(.system(size: 24, weight: .bold))
                                        .foregroundColor(Color.primary)
                                        .padding(.leading, 16)
                                    Spacer()
                                }
                                
                                HStack(spacing: 12) {
                                    // Measure Pole Button
                                    Button(action: {
                                        // Start a pole measuring workflow
                                        Task {
                                            //let poleResult = await cloneable.startUtilityWorkflow(type: .pole(.highAccuracy))
                                            //print(poleResult)
                                            
                                            // EXAMPLE: Start a vertical measurement workflow with custom inventory options
                                            // This demonstrates how to create a VerticalMeasurementConfiguration with pre-defined inventory lists
                                            
                                            // Example 1: Basic configuration with just type and accuracy (backward compatible)
                                            let basicConfig = VerticalMeasurementConfiguration(
                                                type: .pole,
                                                accuracy: .highAccuracy,
                                                inventoryClasses: nil,
                                                wireClasses: nil,
                                                guyWireOptions: nil,
                                                ownerOptions: nil,
                                                shouldCaptureAttachments: nil  // Default behavior (true)
                                            )
                                            
                                            // Example 2: Full configuration with custom inventory options
                                            let customConfig = VerticalMeasurementConfiguration(
                                                type: .pole,
                                                accuracy: .highAccuracy,
                                                
                                                // Custom pole attachments - these will override the default schema-based options
                                                inventoryClasses: [
                                                    InventoryClass(name: "Transformer", subcategories: [
                                                        InventorySubcategory(name: "KVA Rating", options: ["25", "50", "75", "100"], required: true),
                                                        InventorySubcategory(name: "Phase", options: ["Single", "Three"], required: true)
                                                    ]),
                                                    InventoryClass(name: "Capacitor Bank", subcategories: [
                                                        InventorySubcategory(name: "KVAR Rating", options: ["300", "600", "900"], required: true)
                                                    ]),
                                                    InventoryClass(name: "Switch", subcategories: [
                                                        InventorySubcategory(name: "Type", options: ["Manual", "Automatic"], required: false)
                                                    ])
                                                ],
                                                
                                                // Custom wire types
                                                wireClasses: [
                                                    InventoryClass(name: "Primary Wire", subcategories: [
                                                        InventorySubcategory(name: "Conductor", options: ["ACSR", "AAC", "AAAC"], required: true),
                                                        InventorySubcategory(name: "Size", options: ["2/0", "4/0", "336"], required: true)
                                                    ]),
                                                    InventoryClass(name: "Secondary Wire", subcategories: [
                                                        InventorySubcategory(name: "Type", options: ["Triplex", "Quadruplex"], required: true)
                                                    ])
                                                ],
                                                
                                                // Custom guy wire options - simplified to just diameter
                                                guyWireOptions: [
                                                    InventoryClass(name: "3/8\" Guy Wire", subcategories: []),
                                                    InventoryClass(name: "7/16\" Guy Wire", subcategories: []),
                                                    InventoryClass(name: "1/2\" Guy Wire", subcategories: [])
                                                ],
                                                
                                                // Custom owner options
                                                ownerOptions: [
                                                    "City Power & Light",
                                                    "Regional Electric Cooperative", 
                                                    "State Utility Company",
                                                    "Private Utility",
                                                    "Municipal Electric"
                                                ],
                                                
                                                // Control whether to include attachments stage
                                                shouldCaptureAttachments: true  // Set to false to skip attachments documentation
                                            )
                                            
                                            // Example 3: Configuration that skips attachments stage
                                            let quickMeasurementConfig = VerticalMeasurementConfiguration(
                                                type: .pole,
                                                accuracy: .standardAccuracy,
                                                inventoryClasses: nil,
                                                wireClasses: nil,
                                                guyWireOptions: nil,
                                                ownerOptions: ["City Electric"],
                                                shouldCaptureAttachments: false  // Skip attachments stage for quick measurement
                                            )
                                            
                                            // This configuration will capture pole dimensions but skip attachment documentation
                                            // Useful for rapid surveys or when attachments will be documented separately
                                            // Start the workflow with custom configuration
                                            let result = try await cloneable.startVerticalMeasurement(config: customConfig)
                                            if let height = result["pole_information"]["height"].numberValue {
                                                print("Vertical measurement result: \(height)")
                                            }
                                        }
                                    }) {
                                        VStack(spacing: 6) {
                                            Image(systemName: "stop.fill")
                                                .font(.title)
                                                .foregroundColor(.blue)
                                            Text("Measure Pole")
                                                .font(.caption)
                                                .foregroundColor(.primary)
                                                .multilineTextAlignment(.center)
                                        }
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 70)
                                        .background(Color(.systemGray6))
                                        .cornerRadius(12)
                                    }
                                    
                                    // Measure Midspan Button
                                    Button(action: {
                                        Task {
                                            let spanResult = try await cloneable.startVerticalMeasurement(config: VerticalMeasurementConfiguration(
                                                type: .midspan,
                                                accuracy: .highAccuracy,
                                                inventoryClasses: nil,
                                                wireClasses: nil,
                                                guyWireOptions: nil,
                                                ownerOptions: nil,
                                                shouldCaptureAttachments: nil
                                            ))
                                            print(spanResult)
                                        }
                                    }) {
                                        VStack(spacing: 6) {
                                            Image(systemName: "arrow.left.and.right")
                                                .font(.title)
                                                .foregroundColor(.green)
                                            Text("Measure Midspan")
                                                .font(.caption)
                                                .foregroundColor(.primary)
                                                .multilineTextAlignment(.center)
                                        }
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 70)
                                        .background(Color(.systemGray6))
                                        .cornerRadius(12)
                                    }
                                    
                                    // Measure Guy Button
                                    Button(action: {
                                        Task {
                                            let guyResult = try? await cloneable.startGuyWorkflow()
                                            print(guyResult)
                                        }
                                    }) {
                                        VStack(spacing: 6) {
                                            Image(systemName: "triangle.fill")
                                                .font(.title)
                                                .foregroundColor(.orange)
                                            Text("Measure Guy")
                                                .font(.caption)
                                                .foregroundColor(.primary)
                                                .multilineTextAlignment(.center)
                                        }
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 70)
                                        .background(Color(.systemGray6))
                                        .cornerRadius(12)
                                    }
                                }
                                .padding(.horizontal, 16)
                            }
                            .padding(.bottom, 8)
                            
                            if let syncedWorkflows = cloneable.syncedWorkflows, !syncedWorkflows.isEmpty {
                                List {
                                    Section(header: Text("Workflows")
                                        .font(.system(size: 24, weight: .bold))
                                        .foregroundColor(Color.primary)
                                        .textCase(nil)
                                        .padding([.leading], 0)
                                    ) {
                                        ForEach(cloneable.syncedWorkflows!) { workflow in
                                            WorkflowCellView(workflow: workflow, cloneable: cloneable)
                                        }
                                    }
                                }
                            } else {
                                Spacer()
                                Text("Loading Workflows")
                                ProgressView()
                                Spacer()
                            }
                            SyncStatus()
                                .padding()
                        }
                        .navigationBarBackButtonHidden(true)
                        .toolbar {
                            ToolbarItem(placement: .navigationBarLeading) {
                                HStack {
                                    VStack {
                                        Spacer(minLength: 20)
                                        if UITraitCollection.current.userInterfaceStyle == .light {
                                            Image("cloneable_logo_dark")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(height: 50)
                                        } else {
                                            Image("cloneable_logo_white")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(height: 60)
                                        }
                                        Spacer(minLength: 30) // This acts as a bottom padding
                                    }
                                }
                            }

                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button("") {
                                    self.showSheet()
                                }
                                .buttonStyle(SettingsButtonStyle())
                                .scaleEffect(0.9)
                                .padding([.bottom], 20)
                                .padding(.top, 10)
                            }
                        }
                    }
                }
                .navigationViewStyle(.stack)
            }
            .onAppear() {
                //let guys = WorkflowDataManager.shared
            }
            .sheet(isPresented: $showingSettingsSheet) {
                Settings()
            }
        } else {
            Text("Not authenticated")
        }
    }
    
    
    func showSheet() {
        self.showingSettingsSheet = true
    }
}

struct SettingsButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        Image(systemName: "person.crop.circle")
            .font(.title)
            .foregroundColor(.gray)
            .frame(width: 30, height: 30)
    }
}
