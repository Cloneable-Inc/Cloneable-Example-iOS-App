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
        if cloneable.userAuthed {
            ZStack {
                // We wrap our app views in the CloneableWrapper
                // This may wrap views at a higher level in your app
                // The Cloneable Wrapper allows Cloneable to take over rendering when a workflow starts
                CloneableWorkflowWrapper(cloneablePlatform: cloneable) {
                    VStack {
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
                    .navigationViewStyle(.stack)
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
            .sheet(isPresented: $showingSettingsSheet) {
                Settings()
            }
        } else {
            CloneableLoginView(cloneable: cloneable)
                .preferredColorScheme(.dark
            )
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
