//
//  PDFViewModel.swift
//  cloneable-example-app
//
//  Created by Tyler Collins on 12/14/23.
//

import Foundation
import PDFKit
import CloneableCore
import CloneablePlatformiOS

final class PDFViewModel: ObservableObject, ComponentSubscriber {
    var staticComponentID: String
    var dynamicComponentID: String
    var component: DeployedWorkflow_components
    
    @Published var pdfData: PDFDocument?
    @Published var title: String?
    
    required init(dynamicComponentID: String, staticComponentID: String, component: DeployedWorkflow_components) {
        self.dynamicComponentID = dynamicComponentID
        self.staticComponentID = staticComponentID

        self.component = component
        self.title = component.title
        
        // subscribe the component
        workflowFramework!.subscribeComponent(subscriber: self, dynamicComponentID: dynamicComponentID, staticComponentID: staticComponentID)
    }
    
    func componentWillDeInit(final: Bool) { }
    
    func nextButtonClick() {
        // create the output array
        var outputs: Array<DataOutput> = []
        
        // get the button click output
        let buttonClickOutputID = component.outputs.first(where: {$0.outputClassification == "user_action"})
        
        // Create the output from the next button
        let buttonOutput = DataOutput(data: CloneableData.boolean(true), staticComponentID: staticComponentID, dynamicComponentID: dynamicComponentID, dynamicOutputID: (buttonClickOutputID?.dynamicOutputId)!, outputComponentType: ComponentType.ui)
        outputs.append(buttonOutput)
        
        // send the outputs to the framework
        workflowFramework?.sendOutputsToFramework(outputs: outputs)
    }
    
    
    func acceptNewInputs(inputs: [DataInput]) {
        let pdfInput = inputs.first(where: { $0.data.getTypeAsString() == "pdf" })
        if pdfInput != nil {
            // Set the PDF which will render it on the view
            pdfData = pdfInput!.data.getRawValue() as? PDFDocument
        }

    }
    
    
}
