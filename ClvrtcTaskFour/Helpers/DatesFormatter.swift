//
//  DateFormatter.swift
//  ClvrtcTaskFour
//
//  Created by Artyom Beldeiko on 4.01.23.
//

import Foundation

func dateFormatter(_ days: [Day]) -> String {
    var output: String = ""
    var monday: String = ""
    var tuesday: String = ""
    var wednesday: String = ""
    var thursday: String = ""
    var friday: String = ""
    var saturday: String = ""
    var sunday: String = ""
        
    for item in days {
        if item.dayCode == "01" {
            monday = "Пн: \(item.openingTime.rawValue) - \(item.closingTime.rawValue) (перерыв: \(item.dayBreak.breakFromTime.rawValue) - \(item.dayBreak.breakToTime.rawValue)); "
            output += monday
        } else if item.dayCode == "02" {
            tuesday = "Вт: \(item.openingTime.rawValue) - \(item.closingTime.rawValue) (перерыв: \(item.dayBreak.breakFromTime.rawValue) - \(item.dayBreak.breakToTime.rawValue)); "
            output += tuesday
        } else if item.dayCode == "03" {
            wednesday = "Cр: \(item.openingTime.rawValue) - \(item.closingTime.rawValue) (перерыв: \(item.dayBreak.breakFromTime.rawValue) - \(item.dayBreak.breakToTime.rawValue)); "
            output += wednesday
        } else if item.dayCode == "04" {
            thursday = "Чт: \(item.openingTime.rawValue) - \(item.closingTime.rawValue) (перерыв: \(item.dayBreak.breakFromTime.rawValue) - \(item.dayBreak.breakToTime.rawValue)); "
            output += thursday
        } else if item.dayCode == "05" {
            friday = "Пт: \(item.openingTime.rawValue) - \(item.closingTime.rawValue) (перерыв: \(item.dayBreak.breakFromTime.rawValue) - \(item.dayBreak.breakToTime.rawValue))"
            output += friday
        } else if item.dayCode == "06" {
            saturday = "Cб: \(item.openingTime.rawValue) - \(item.closingTime.rawValue) (перерыв: \(item.dayBreak.breakFromTime.rawValue) - \(item.dayBreak.breakToTime.rawValue))"
            output += "; " + saturday
        } else if item.dayCode == "07" {
            sunday = "Вс: \(item.openingTime.rawValue) - \(item.closingTime.rawValue) (перерыв: \(item.dayBreak.breakFromTime.rawValue) - \(item.dayBreak.breakToTime.rawValue))"
            output += "; " + sunday
        }
    }
    return output
}