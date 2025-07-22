//
//  Settings.swift
//  Cloneable_Player
//
//  Created by Tyler Collins on 9/19/22.
//

import SwiftUI
import CloneableCore
import CloneablePlatformiOS

struct Settings: View {
    @EnvironmentObject var cloneable: CloneablePlatform
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) private var colorScheme

    // Restoring @AppStorage variables
    @AppStorage("downloadPermissionPrompted") var downloadPermissionPrompted: Bool = false
    @AppStorage("onboardingCompleted") var onboardingCompleted: Bool = false
    @State private var components: [(AnyView, String)] = []
    @State private var showingClearErrorsConfirmation = false
    @State private var showingLogoutConfirmation = false

    var body: some View {
        NavigationStack {
            ZStack {
                // Background color
                (colorScheme == .dark ? Color.black : Color(.systemGroupedBackground))
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 0) {
                    // Header
                    HStack {
                        Text("Settings")
                            .font(.system(.largeTitle, design: .rounded, weight: .bold))
                        Spacer()
                        Button(action: { dismiss() }) {
                            Text("Done")
                                .font(.system(.body, design: .rounded, weight: .semibold))
                                .foregroundColor(.blue)
                        }
                    }
                    .padding([.horizontal, .top])
                    .padding(.bottom, 10)

                    ScrollView {
                        VStack(spacing: 24) {
                            // Component Settings Section
                            if !components.isEmpty {
                                VStack(alignment: .leading, spacing: 16) {
                                    Text("Component Settings")
                                        .font(.system(.title2, design: .rounded, weight: .bold))
                                        .padding(.horizontal, 4)
                                    
                                    VStack(spacing: 0) {
                                        ForEach(components.indices, id: \.self) { index in
                                            let setting = components[index]
                                            NavigationLink(destination: setting.0) {
                                                HStack {
                                                    Text(setting.1)
                                                        .font(.system(.body, design: .rounded))
                                                        .foregroundColor(.primary)

                                                    Spacer()
                                                    Image(systemName: "chevron.right")
                                                        .foregroundColor(.gray)
                                                        .font(.system(.body, design: .rounded))
                                                }
                                                .padding(.vertical, 14)
                                                .padding(.horizontal)
                                            }
                                            
                                            if index != components.count - 1 {
                                                Divider()
                                                    .padding(.leading)
                                            }
                                        }
                                    }
                                    .background(colorScheme == .dark ? Color(.systemGray6) : Color(.systemBackground))
                                    .cornerRadius(16)
                                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                                }
                                .padding(.horizontal)
                            }
                            
                            // Synced Workflow Objects
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Data")
                                    .font(.system(.title2, design: .rounded, weight: .bold))
                                    .padding(.horizontal, 4)
                                
                                // Synced objects card
                                VStack(alignment: .leading, spacing: 16) {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text("Synced workflow objects")
                                                .font(.system(.headline, design: .rounded, weight: .semibold))
                                            
                                            Text("Data synced to the device, representing collected information for objects like poles, spans, midspans, guys, etc.")
                                                .font(.system(.subheadline, design: .rounded))
                                                .foregroundColor(.secondary)
                                                .fixedSize(horizontal: false, vertical: true)
                                        }
                                        
                                        Spacer()
                                        
                                        VStack(alignment: .center, spacing: 2) {
                                            Text("\(cloneable.getNumberOfSyncedObjects())")
                                                .font(.system(.title, design: .rounded, weight: .bold))
                                                .foregroundColor(.blue)
                                            
                                            Text("Objects")
                                                .font(.system(.caption, design: .rounded))
                                                .foregroundColor(.secondary)
                                        }
                                        .padding(12)
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(Color.blue.opacity(0.1))
                                        )
                                    }
                                }
                                .padding()
                                .background(colorScheme == .dark ? Color(.systemGray6) : Color(.systemBackground))
                                .cornerRadius(16)
                                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                                
                                // Downloaded files card
                                VStack(alignment: .leading, spacing: 16) {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 4) {
                                            HStack {
                                                Text("Downloaded files")
                                                    .font(.system(.headline, design: .rounded, weight: .semibold))
                                                
                                                if cloneable.numFilesWithErrors > 0 {
//                                                    NavigationLink(destination: FileList()) {
//                                                        Image(systemName: "exclamationmark.arrow.triangle.2.circlepath")
//                                                            .foregroundColor(.red)
//                                                            .font(.system(size: 18))
//                                                            .bold()
//                                                    }
                                                }
                                            }
                                            
                                            Text("Files required by workflows, such as AI models for pole measurements or PDF templates.")
                                                .font(.system(.subheadline, design: .rounded))
                                                .foregroundColor(.secondary)
                                                .fixedSize(horizontal: false, vertical: true)
                                        }
                                        
                                        Spacer()
                                        
                                        VStack(alignment: .center, spacing: 2) {
                                            Text("\(cloneable.getNumberOfDownloadedFiles())")
                                                .font(.system(.title, design: .rounded, weight: .bold))
                                                .foregroundColor(.green)
                                            
                                            Text("Files")
                                                .font(.system(.caption, design: .rounded))
                                                .foregroundColor(.secondary)
                                        }
                                        .padding(12)
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(Color.green.opacity(0.1))
                                        )
                                    }
                                    
                                    Button(action: {
                                        downloadPermissionPrompted = false
                                        dismiss()
                                    }) {
                                        Text("Reset Download Permission")
                                            .font(.system(.body, design: .rounded, weight: .semibold))
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 10)
                                            .frame(maxWidth: .infinity)
                                            .background(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .fill(Color.blue.opacity(0.2))
                                            )
                                            .foregroundColor(.blue)
                                    }
                                }
                                .padding()
                                .background(colorScheme == .dark ? Color(.systemGray6) : Color(.systemBackground))
                                .cornerRadius(16)
                                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                            }
                            .padding(.horizontal)
                            
                            // Sync status and actions
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Sync Status")
                                    .font(.system(.title2, design: .rounded, weight: .bold))
                                    .padding(.horizontal, 4)
                                
                                VStack(spacing: 16) {
                                    // Sync errors
                                    if cloneable.numFilesWithErrors > 0 {
                                        Button(action: {
                                            showingClearErrorsConfirmation = true
                                        }) {
                                            HStack {
                                                Image(systemName: "exclamationmark.triangle")
                                                    .foregroundColor(.white)
                                                
                                                Text("Clear Sync Errors (\(cloneable.numFilesWithErrors))")
                                                    .font(.system(.body, design: .rounded, weight: .semibold))
                                                    .foregroundColor(.white)
                                            }
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 12)
                                            .frame(maxWidth: .infinity)
                                            .background(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .fill(Color.red)
                                            )
                                        }
                                        .alert("Confirm Clear Errors", isPresented: $showingClearErrorsConfirmation) {
                                            Button("Clear Errors", role: .destructive) {
                                                cloneable.clearSyncErrors()
                                            }
                                            Button("Cancel", role: .cancel) {}
                                        } message: {
                                            Text("Are you sure you want to clear all sync errors? This action cannot be undone.")
                                        }
                                    }
                                    
                                    // Unsynced files
                                    if cloneable.numFilesToSync != 0 {
                                        VStack(spacing: 8) {
                                            HStack {
                                                Image(systemName: "arrow.triangle.2.circlepath")
                                                    .foregroundColor(.orange)
                                                
                                                Text("\(cloneable.numFilesToSync) Un-synced files")
                                                    .font(.system(.subheadline, design: .rounded))
                                                    .foregroundColor(.orange)
                                                
                                                Spacer()
                                            }
                                            
                                            Button(action: { cloneable.forceFileSync() }) {
                                                Text("Force File Sync")
                                                    .font(.system(.body, design: .rounded, weight: .semibold))
                                                    .padding(.horizontal, 16)
                                                    .padding(.vertical, 10)
                                                    .frame(maxWidth: .infinity)
                                                    .background(
                                                        RoundedRectangle(cornerRadius: 12)
                                                            .fill(Color.orange.opacity(0.2))
                                                    )
                                                    .foregroundColor(.orange)
                                            }
                                        }
                                        .padding()
                                        .background(colorScheme == .dark ? Color(.systemGray6) : Color(.systemBackground))
                                        .cornerRadius(16)
                                    }
                                }
                            }
                            .padding(.horizontal)
                            
                            // Diagnostic and Privacy
                            VStack(spacing: 20) {
//                                DiagnosticUploadButton()
//                                    .padding(.horizontal, 20)
                                
                                Link(destination: URL(string: "https://cloneable.ai/privacy-policy")!) {
                                    Text("Privacy Policy")
                                        .font(.system(.subheadline, design: .rounded))
                                        .foregroundColor(.blue)
                                        .underline()
                                }
                                .padding(.bottom, 10)
                            }
                            .padding(.top, 10)
                        }
                        .padding(.bottom, 20)
                    }
                }
            }
            // Logout button at the bottom
            .safeAreaInset(edge: .bottom) {
                Button(action: {
                    showingLogoutConfirmation = true
                }) {
                    HStack {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                        Text("Log Out")
                            .font(.system(.body, design: .rounded, weight: .semibold))
                    }
                    .foregroundColor(.red)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.red, lineWidth: 1.5)
                    )
                    .padding()
                }
                .background(colorScheme == .dark ? Color.black : Color(.systemGroupedBackground))
            }
            .alert("Confirm Logout", isPresented: $showingLogoutConfirmation) {
                Button("Log Out", role: .destructive) {
                    dismiss()
                    //cloneable.signout(clearCache: true, signoutByButton: true)
                    cloneable.signout(clearCache: true, signoutByButton: true)
                    //cloneable.signout()
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("Are you sure you want to log out? Any unsynced data may be lost.")
            }
        }
        .toolbar(.hidden)
        .onAppear {
            components = Components.getSettingsComponents()
        }
    }
}

// Extension to capitalize the first letter of a string
extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
}
