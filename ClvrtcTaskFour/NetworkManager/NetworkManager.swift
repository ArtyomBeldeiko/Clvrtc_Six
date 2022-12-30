//
//  NetworkManager.swift
//  ClvrtcTaskFour
//
//  Created by Artyom Beldeiko on 30.12.22.
//

import Foundation

struct NetworkManagerConstants {
    static let url = "https://belarusbank.by/api/atm?city"
}

class NetworkManager {
    
    static let shared = NetworkManager()
   
    func getATMData(completion: @escaping (Result<ATMData, Error>) -> Void) {
        guard let url = URL(string: "\(NetworkManagerConstants.url)") else { return }
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
}

