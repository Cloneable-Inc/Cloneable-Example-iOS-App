//
//  WorkflowCellView.swift
//  Cloneable_Player
//
//  Created by Tyler Collins on 11/29/23.
//

import SwiftUI
import CloneablePlatformiOS

struct WorkflowCellView: View {
    @State var workflow: Workflow
    var cloneable: CloneablePlatform
    
    var body: some View {
        HStack {
            workflowInfo
            Spacer()
            chevronIndicator
        }
        .contentShape(Rectangle())
        .onTapGesture {
            if workflow.readyToRun {
                cloneable.selectStartWorkflow(workflow: workflow)
            }
        }
    }

    private var workflowInfo: some View {
        VStack(alignment: .leading) {
            Text(workflow.workflowName)
                .font(.headline)
                .opacity(workflow.readyToRun ? 1.0 : 0.3)
            
            Text(workflow.workflowDescription)
                .multilineTextAlignment(.leading)
                .opacity(workflow.readyToRun ? 1.0 : 0.3)
            
            readinessIndicator
                .padding(.top, 2)
        }
    }

    private var readinessIndicator: some View {
        HStack {
            if workflow.readyToRun {
                Text("Ready")
                    .foregroundColor(.green)
            } else {
                Text(workflow.reasonNotReady)
                    .foregroundColor(.red)
            }
        }
    }

    private var chevronIndicator: some View {
        Image(systemName: "chevron.right")
            .foregroundColor(.gray)
            .opacity(workflow.readyToRun ? 1.0 : 0.3)
    }
}


