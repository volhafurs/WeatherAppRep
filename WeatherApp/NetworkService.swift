//
//  NetworkService.swift
//  WeatherApp
//
//  Created by Volha Furs on 17.05.22.
//

import Foundation

class NetworkService {
    
    func request(urlString: String, completion: @escaping (Result<[SearchResponse], Error>) -> Void) {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    print("some error")
                    completion(.failure(error))
                    return
                }
                guard let data = data else { return }
//                let someString = String(data: data, encoding: .utf8)
//                print(someString ?? "no data")
                do {
                    let cities = try JSONDecoder().decode([SearchResponse].self, from: data)
                    completion(.success(cities))
                } catch let jsonError {
                    print("Failed to decode JSON", jsonError)
                    completion(.failure(jsonError))
                }
            }
        }.resume()
    }
}
