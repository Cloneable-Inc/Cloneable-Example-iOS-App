//
//  Settings.swift
//  Cloneable_Player
//
//  Created by Tyler Collins on 11/29/23.
//

import SwiftUI
import CloneablePlatformiOS

struct Settings: View {
    @EnvironmentObject var cloneable: CloneablePlatform
    @Environment(\.dismiss) var dismiss

    func formattedRole(_ role: String) -> String {
        return role.replacingOccurrences(of: "_", with: " ").capitalized
    }
    
    var body: some View {
        VStack {
            headerView
            ScrollView {
                userInfoSection
                syncedWorkflowObjectsSection
                downloadedFilesSection
                unsyncedFilesSection
                privacyPolicyLink
            }
            .frame(maxWidth: .infinity)
            .padding()
            logoutButton
        }
    }

    private var headerView: some View {
        HStack {
            Text("Settings")
                .font(.largeTitle)
                .fontWeight(.bold)
            Spacer()
            Button("Done") {
                dismiss()
            }
        }
        .padding([.leading, .top, .trailing])
    }

    private var userInfoSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Spacer()
            }
            VStack(alignment: .leading) {
                Text(formattedFullName)
                    .font(.system(size: 24))
                    .fontWeight(.semibold)
            }
            .padding()
        }
    }

    private var syncedWorkflowObjectsSection: some View {
        SectionView(title: "Synced workflow objects", count: cloneable.getNumberOfSyncedObjects(), description: "Objects hold data, which relate to workflows that have been run. In some cases, workflows may depend on existing objects. Those objects are synced to the device.")
    }

    private var downloadedFilesSection: some View {
        SectionView(title: "Downloaded files", count: cloneable.getNumberOfDownloadedFiles(), description: "These are files that are required by workflows such as AI models and PDF templates. You may decline to download required files which will prevent workflows that depend on them from running.")
    }

    private var unsyncedFilesSection: some View {
        VStack {
            if cloneable.numFilesToSync != 0 {
                HStack {
                    Text(String(cloneable.numFilesToSync))
                        .font(.subheadline)
                        .foregroundColor(.red)

                    Text("Un-synced files")
                        .font(.subheadline)
                        .foregroundColor(.red)
                }
                .padding()
                Button("Force file sync", action: { cloneable.forceFileSync() })
            }
        }
    }

    private var privacyPolicyLink: some View {
        Link("Privacy Policy", destination: URL(string: "https://cloneable.ai/privacy-policy")!)
            .font(.subheadline)
            .foregroundColor(.blue)
            .padding(.top)
    }

    private var logoutButton: some View {
        HStack {
            Button("log out") {
                dismiss()
                cloneable.signout()
            }
            .foregroundColor(.red)
        }
        .padding()
    }

    private var formattedFullName: String {
        guard let userInformation = cloneable.userInformation else {
            return ""
        }
        
        let firstName = userInformation.firstName.capitalizingFirstLetter()
        let lastName = userInformation.lastName.capitalizingFirstLetter()
        return "\(firstName) \(lastName)".trimmingCharacters(in: .whitespaces)
    }
}

struct SectionView: View {
    var title: String
    var count: Int
    var description: String

    var body: some View {
        VStack {
            Text(title)
                .font(.title)
                .padding(.top)
                .padding(.bottom, -10)
            HStack {
                VStack {
                    Text(String(count))
                        .fontWeight(.bold)
                        .font(.title3)
                    Text("Objects")
                        .font(.subheadline)
                }
                .padding()
            }
            Text(description)
                .font(.callout)
                .padding(.top, -8)
                .padding()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(.quaternary)
                .opacity(0.5)
        )
        .frame(maxWidth: 400)
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings()
            .environmentObject(CloneablePlatform())
    }
}

// Extension to capitalize the first letter of a string
extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
}
