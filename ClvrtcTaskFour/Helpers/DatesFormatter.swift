//
//  DatesFormatter.swift
//  ClvrtcTaskFour
//
//  Created by Artyom Beldeiko on 4.01.23.
//

import Foundation

func atmDatesFormatter(_ days: [Day]) -> String {
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

func branchBankDatesFormatter(_ days: [BankDayElement]) -> String {
    var output: String = ""
    var monday: String = ""
    var tuesday: String = ""
    var wednesday: String = ""
    var thursday: String = ""
    var friday: String = ""
    var saturday: String = ""
    var sunday: String = ""
        
    for item in days {
        if item.dayCode == 01 {
            if item.openingTime.rangeOfCharacter(from: .decimalDigits) != nil && item.closingTime.rangeOfCharacter(from: .decimalDigits) != nil {
                monday = "Пн: \(item.openingTime.components(separatedBy: "+")[0].dropLast(3)) - \(item.closingTime.components(separatedBy: "+")[0].dropLast(3)) (перерыв: \(item.dayBreak.breakFromTime.components(separatedBy: "+")[0].dropLast(3)) - \(item.dayBreak.breakToTime.components(separatedBy: "+")[0].dropLast(3))); "
                output += monday
            } else {
                monday = "Пн: выходной; "
                output += monday
            }
        } else if item.dayCode == 02 {
            if item.openingTime.rangeOfCharacter(from: .decimalDigits) != nil && item.closingTime.rangeOfCharacter(from: .decimalDigits) != nil {
                tuesday = "Вт: \(item.openingTime.components(separatedBy: "+")[0].dropLast(3)) - \(item.closingTime.components(separatedBy: "+")[0].dropLast(3)) (перерыв: \(item.dayBreak.breakFromTime.components(separatedBy: "+")[0].dropLast(3)) - \(item.dayBreak.breakToTime.components(separatedBy: "+")[0].dropLast(3))); "
                output += tuesday
            } else {
                tuesday = "Вт: выходной; "
                output += tuesday
            }
        } else if item.dayCode == 03 {
            if item.openingTime.rangeOfCharacter(from: .decimalDigits) != nil && item.closingTime.rangeOfCharacter(from: .decimalDigits) != nil {
                wednesday = "Cр: \(item.openingTime.components(separatedBy: "+")[0].dropLast(3)) - \(item.closingTime.components(separatedBy: "+")[0].dropLast(3)) (перерыв: \(item.dayBreak.breakFromTime.components(separatedBy: "+")[0].dropLast(3)) - \(item.dayBreak.breakToTime.components(separatedBy: "+")[0].dropLast(3))); "
                output += wednesday
            } else {
                wednesday = "Cр: выходной; "
                output += wednesday
            }
        } else if item.dayCode == 04 {
            if item.openingTime.rangeOfCharacter(from: .decimalDigits) != nil && item.closingTime.rangeOfCharacter(from: .decimalDigits) != nil {
                thursday = "Чт: \(item.openingTime.components(separatedBy: "+")[0].dropLast(3)) - \(item.closingTime.components(separatedBy: "+")[0].dropLast(3)) (перерыв: \(item.dayBreak.breakFromTime.components(separatedBy: "+")[0].dropLast(3)) - \(item.dayBreak.breakToTime.components(separatedBy: "+")[0].dropLast(3))); "
                output += thursday
            } else {
                thursday = "Чт: выходной; "
                output += thursday
            }
        } else if item.dayCode == 05 {
            if item.openingTime.rangeOfCharacter(from: .decimalDigits) != nil && item.closingTime.rangeOfCharacter(from: .decimalDigits) != nil {
                friday = "Пт: \(item.openingTime.components(separatedBy: "+")[0].dropLast(3)) - \(item.closingTime.components(separatedBy: "+")[0].dropLast(3)) (перерыв: \(item.dayBreak.breakFromTime.components(separatedBy: "+")[0].dropLast(3)) - \(item.dayBreak.breakToTime.components(separatedBy: "+")[0].dropLast(3))); "
                output += friday
            } else {
                friday = "Пт: выходной; "
                output += friday
            }
        } else if item.dayCode == 06 {
            if item.openingTime.rangeOfCharacter(from: .decimalDigits) != nil && item.closingTime.rangeOfCharacter(from: .decimalDigits) != nil {
                saturday = "Cб: \(item.openingTime.components(separatedBy: "+")[0].dropLast(3)) - \(item.closingTime.components(separatedBy: "+")[0].dropLast(3)) (перерыв: \(item.dayBreak.breakFromTime.components(separatedBy: "+")[0].dropLast(3)) - \(item.dayBreak.breakToTime.components(separatedBy: "+")[0].dropLast(3)))"
                output += "; " + saturday
            } else {
                saturday = "Cб: выходной"
                output += "; " + saturday
            }
        } else if item.dayCode == 07 {
            if item.openingTime.rangeOfCharacter(from: .decimalDigits) != nil && item.closingTime.rangeOfCharacter(from: .decimalDigits) != nil {
                sunday = "Вс: \(item.openingTime.components(separatedBy: "+")[0].dropLast(3)) - \(item.closingTime.components(separatedBy: "+")[0].dropLast(3)) (перерыв: \(item.dayBreak.breakFromTime.components(separatedBy: "+")[0].dropLast(3)) - \(item.dayBreak.breakToTime.components(separatedBy: "+")[0].dropLast(3)))"
                output += "; " + sunday
            } else {
                sunday = "Вс: выходной"
                output += "; " + sunday
            }
        }
    }
    return output
}



