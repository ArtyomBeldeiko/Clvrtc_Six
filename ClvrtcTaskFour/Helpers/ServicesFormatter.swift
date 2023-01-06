//
//  ServicesFormatter.swift
//  ClvrtcTaskFour
//
//  Created by Artyom Beldeiko on 6.01.23.
//

import Foundation

func servicesFormatter(_ services: [Service]) -> String {
    var outputString = ""
    
    for item in services {
        outputString += "\(item.serviceType.rawValue.lowercased()), "
    }
    
    outputString = String(outputString.dropLast(2))
    
    return outputString
}
