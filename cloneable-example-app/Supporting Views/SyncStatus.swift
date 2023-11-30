//
//  SyncStatus.swift
//  Cloneable_Player
//
//  Created by Tyler Collins on 11/29/23.
//

import SwiftUI
import CloneablePlatformiOS

struct SyncStatus: View {
    @EnvironmentObject var cloneable: CloneablePlatform
    
    var body: some View {
        Group {
            switch cloneable.networkStatus {
            case .disconnected where cloneable.cloneableReady:
                disconnectedView
            case .connecting:
                connectingView
            default:
                syncStatusView
            }
        }
        .onChange(of: cloneable.networkStatus) { oldStatus, newStatus in
            print("Network status changed:", newStatus)
        }
    }

    private var disconnectedView: some View {
        StatusMessageView(iconName: "x.circle", message: "Disconnected - results will save locally", iconColor: .red)
    }

    private var connectingView: some View {
        StatusProgressView(message: "Connecting to platform")
    }

    private var syncStatusView: some View {
        Group { // Wrap the switch statement in a Group
            switch cloneable.syncStatus {
            case .syncing:
                StatusProgressView(message: "Syncing with platform")
            case .synced:
                StatusMessageView(iconName: "checkmark.circle", message: "Synced with platform", iconColor: .green)
            case .sync_error:
                StatusMessageView(iconName: "x.circle", message: "PLATFORM ERROR", iconColor: .red)
            case .not_synced:
                StatusMessageView(iconName: "x.circle", message: "Not synced with platform", iconColor: .red)
            default:
                if let syncError = cloneable.syncError {
                    StatusMessageView(iconName: "x.circle", message: syncError, iconColor: .red)
                } else if cloneable.numFilesToSync != 0 {
                    StatusProgressView(message: "\(cloneable.numFilesToSync) files to sync")
                } else {
                    StatusProgressView(message: "Syncing with platform")
                }
            }
        }
    }

}

struct StatusMessageView: View {
    var iconName: String
    var message: String
    var iconColor: Color

    var body: some View {
        HStack {
            Spacer()
            Image(systemName: iconName)
                .font(.subheadline)
                .foregroundColor(iconColor)
            Text(message)
                .font(.subheadline)
                .foregroundColor(.gray)
            Spacer()
        }
    }
}

struct StatusProgressView: View {
    var message: String

    var body: some View {
        HStack {
            Spacer()
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .foregroundColor(.gray)
                .padding([.trailing], 5)
            Text(message)
                .font(.subheadline)
                .foregroundColor(.gray)
            Spacer()
        }
    }
}

struct SyncStatus_Previews: PreviewProvider {
    static var previews: some View {
        SyncStatus()
            .environmentObject(CloneablePlatform())
    }
}
