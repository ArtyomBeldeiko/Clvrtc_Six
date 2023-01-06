//
//  CardsFormatter.swift
//  ClvrtcTaskFour
//
//  Created by Artyom Beldeiko on 7.01.23.
//

import Foundation

func cardsFormatter(_ cards: [Card]) -> String {
    var outputString = ""
    
    for item in cards {
        outputString += "\(item.rawValue), "
    }
    
    outputString = String(outputString.dropLast(2))
    
    return outputString
}
