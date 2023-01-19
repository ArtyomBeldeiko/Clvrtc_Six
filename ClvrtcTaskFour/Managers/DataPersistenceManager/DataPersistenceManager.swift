//
//  DataPersistenceManager.swift
//  ClvrtcTaskFour
//
//  Created by Artyom Beldeiko on 19.01.23.
//

import Foundation
import CoreData
import UIKit

class DataPersistenceManager {
    
    enum DataBaseError: Error {
        case failedToSaveData
        case failedToFetchData
    }
    
    static let shared = DataPersistenceManager()
    
    func storeMKAnnotatedATM(model: MKAnnotatedATM, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        let item = MKAnnotatedATMPersistenceModel(context: context)
        
        item.access24Hours = model.access24Hours
        item.addressDiscription = model.addressDiscription
        item.addressLine = model.addressLine
        item.atmID = model.atmID
        item.baseCurrency = model.baseCurrency
        item.buildingNumber = model.buildingNumber
        item.cards = model.cards
        item.contactDetails = model.contactDetails
        item.currency = model.currency
        item.currentStatus = model.currentStatus
        item.isRescticted = model.isRescticted
        item.latitude = model.latitude
        item.longitude = model.longitude
        item.sameAsOrganization = model.sameAsOrganization
        item.serviceType = model.serviceType
        item.standardAvailability = model.standardAvailability
        item.streetName = model.streetName
        item.townName = model.townName
        item.type = model.type
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DataBaseError.failedToSaveData))
        }
    }
    
    func storeMKAnnotatedServiceTerminal(model: MKAnnotatedServiceTerminal, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        let item = MKAnnotatedServiceTerminalPersistenceModel(context: context)
        
        item.address = model.address
        item.addressType = model.addressType
        item.cashInExist = model.cashInExist
        item.city = model.city
        item.currency = model.currency
        item.gpsX = model.gpsX
        item.gpsY = model.gpsY
        item.house = model.house
        item.infoID = Int64(model.infoID)
        item.installPlace = model.installPlace
        item.locationNameDesc = model.locationNameDesc
        item.timeLong = model.timeLong
        item.workTime = model.workTime
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DataBaseError.failedToSaveData))
        }
    }
    
    func storeMKAnnotatedBranchBank(model: MKAnnotatedBranchBank, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        let item = MKAnnotatedBranchBankPersistenceModel(context: context)
        
        item.addressDescription = model.addressDescription
        item.addressLine = model.addressLine
        item.branchID = model.branchID
        item.buildingNumber = model.buildingNumber
        item.cbu = model.cbu
        item.currency = model.currency
        item.department = model.department
        item.equeue = Int64(model.equeue)
        item.latitude = model.latitude
        item.longitude = model.longitude
        item.name = model.name
        item.standardAvailability = model.standardAvailability
        item.streetName = model.streetName
        item.townName = model.townName
        item.wifi = Int64(model.wifi)
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DataBaseError.failedToSaveData))
        }
    }
    
    func storeMKAnnotatedFacility(model: MKAnnotatedFacility, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        let item = MKAnnotatedFacilityPersistenceModel(context: context)
        
        item.addressLine = model.addressLine
        item.availability = model.availability
        item.buildingNumber = model.buildingNumber
        item.currency = model.currency
        item.id = model.id
        item.latitude = model.latitude
        item.longitude = model.longitude
        item.streetName = model.streetName
        item.townName = model.townName
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DataBaseError.failedToSaveData))
        }
    }
    
    func fetchingMKAnnotatedATMData(completion: @escaping(Result<[MKAnnotatedATMPersistenceModel], Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        let request: NSFetchRequest<MKAnnotatedATMPersistenceModel>
        request = MKAnnotatedATMPersistenceModel.fetchRequest()
        
        do {
            let atmData = try context.fetch(request)
            completion(.success(atmData))
        } catch {
            completion(.failure(DataBaseError.failedToFetchData))
        }
    }
    
    func fetchingMKAnnotatedServiceTerminalData(completion: @escaping(Result<[MKAnnotatedServiceTerminalPersistenceModel], Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        let request: NSFetchRequest<MKAnnotatedServiceTerminalPersistenceModel>
        request = MKAnnotatedServiceTerminalPersistenceModel.fetchRequest()
        
        do {
            let serviceTerminalData = try context.fetch(request)
            completion(.success(serviceTerminalData))
        } catch {
            completion(.failure(DataBaseError.failedToFetchData))
        }
    }
    
    func fetchingMKAnnotatedBranchBankData(completion: @escaping(Result<[MKAnnotatedBranchBankPersistenceModel], Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        let request: NSFetchRequest<MKAnnotatedBranchBankPersistenceModel>
        request = MKAnnotatedBranchBankPersistenceModel.fetchRequest()
        
        do {
            let branchBankData = try context.fetch(request)
            completion(.success(branchBankData))
        } catch {
            completion(.failure(DataBaseError.failedToFetchData))
        }
    }
    
    func fetchingMKAnnotatedFacilityData(completion: @escaping(Result<[MKAnnotatedFacilityPersistenceModel], Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        let request: NSFetchRequest<MKAnnotatedFacilityPersistenceModel>
        request = MKAnnotatedFacilityPersistenceModel.fetchRequest()
        
        do {
            let facilityData = try context.fetch(request)
            completion(.success(facilityData))
        } catch {
            completion(.failure(DataBaseError.failedToFetchData))
        }
    }
}
