//
//  CountComponent.swift
//  cloneable-example-app
//
//  Created by Tyler Collins on 12/14/23.
//

import Foundation
import CloneablePlatformiOS
import CloneableCore

class CountComponent: ComponentSubscriber {
    var staticComponentID: String
    var dynamicComponentID: String
    var component: DeployedWorkflow_components
    
    // variable to hold the id of the output
    var count_output_id: String? = nil

    required init(dynamicComponentID: String, staticComponentID: String, component: DeployedWorkflow_components) {
        self.dynamicComponentID = dynamicComponentID
        self.staticComponentID = staticComponentID
        self.component = component
        
        // the output id is going to be the first output of the component
        if let output = component.outputs.first {
            count_output_id = output.dynamicOutputId
        }
        
        // Subscribe to the workflow framework once we have initialized the component
        workflowFramework?.subscribeComponent(subscriber: self, dynamicComponentID: dynamicComponentID, staticComponentID: staticComponentID)
    }
    
    func componentWillDeInit(final: Bool) {}
    
    func acceptNewInputs(inputs: [DataInput]) {
        guard let outputId = count_output_id else { return }
        
        let arrayCount = inputs[0].data.getArrayValue()!.count
        
        let output = DataOutput(data: CloneableData.number(Double(arrayCount)), staticComponentID: self.staticComponentID, dynamicComponentID: self.dynamicComponentID, dynamicOutputID: outputId, outputComponentType: ComponentType.logical)
        
        workflowFramework?.sendOutputsToFramework(outputs: [output])
    }
}
