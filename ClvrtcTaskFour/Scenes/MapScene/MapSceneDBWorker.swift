//
//  MapSceneDBWorker.swift
//  ClvrtcTaskFour
//
//  Created by Artyom Beldeiko on 22.01.23.
//

import Foundation
import UIKit

class MapSceneDBWorker {
    
    weak var interactor: MapSceneInteractor?
    weak var presenter: MapScenePresenter?
    
    
    func fetchFacilityDataFromDB() {
        DataPersistenceManager.shared.fetchingMKAnnotatedFacilityData { result in
            switch result {
            case .success(let fetchedFacilityData):
                fetchedFacilityData.forEach { self.interactor?.annotatedFacilityData.append(MKAnnotatedFacility(id: $0.id!,
                                                                                      currency: $0.currency!,
                                                                                      townName: $0.townName!,
                                                                                      streetName: $0.streetName!,
                                                                                      buildingNumber: $0.buildingNumber!,
                                                                                      addressLine: $0.addressLine!,
                                                                                      availability: $0.availability!,
                                                                                      latitude: $0.latitude,
                                                                                      longitude: $0.longitude)) }

            case .failure(_): break
            }
        }
    }
    
    func saveDataToDB() {
        presenter?.viewModel.MKAnnotatedATM?.forEach { DataPersistenceManager.shared.storeMKAnnotatedATM(model: $0) { result in
            switch result {
            case .success(): break
            case .failure(let error):
                print(error.localizedDescription)
            }
        }}
                
        presenter?.viewModel.MKAnnotatedBranchBank?.forEach { DataPersistenceManager.shared.storeMKAnnotatedBranchBank(model: $0) { result in
            switch result {
            case .success(): break
            case .failure(let error):
                print(error.localizedDescription)
            }
        }}
                
        presenter?.viewModel.MKAnnotatedServiceTerminal?.forEach { DataPersistenceManager.shared.storeMKAnnotatedServiceTerminal(model: $0) { result in
            switch result {
            case .success(): break
            case .failure(let error):
                print(error.localizedDescription)
            }
        }}
        
    }
    
//    func saveFacilityDatatoDB() {
//        interactor?.annotatedFacilityData.forEach { DataPersistenceManager.shared.storeMKAnnotatedFacility(model: $0) { result in
//            switch result {
//            case .success(): break
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }}
//    }
}
