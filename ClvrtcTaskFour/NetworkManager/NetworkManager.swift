//
//  NetworkManager.swift
//  ClvrtcTaskFour
//
//  Created by Artyom Beldeiko on 30.12.22.
//

import Foundation

struct NetworkManagerConstants {
    static let atmUrl = "https://belarusbank.by/open-banking/v1.0/atms"
    static let branchBankUrl = "https://belarusbank.by/open-banking/v1.0/branches"
    static let serviceTerminalUrl = "https://belarusbank.by/api/infobox"
}

class NetworkManager {
    
    static let shared = NetworkManager()
    
    func getATMData(completion: @escaping (Result<ATMData, Error>) -> Void) {
        guard let url = URL(string: "\(NetworkManagerConstants.atmUrl)") else { return }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else { return }
            do {
                let results = try JSONDecoder().decode(ATMData.self, from: data)
                completion(.success(results))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    func getBranchBankData(completion: @escaping (Result<BranchBankData, Error>) -> Void) {
        guard let url = URL(string: "\(NetworkManagerConstants.branchBankUrl)") else { return }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else { return }
            do {
                let results = try JSONDecoder().decode(BranchBankData.self, from: data)
                completion(.success(results))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    func getServiceTerminalData(completion: @escaping (Result<[ServiceTerminal], Error>) -> Void) {
        guard let url = URL(string: "\(NetworkManagerConstants.serviceTerminalUrl)") else { return }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else { return }
            do {
                let results = try JSONDecoder().decode(ServiceTerminalData.self, from: data)
                completion(.success(results.data))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}

