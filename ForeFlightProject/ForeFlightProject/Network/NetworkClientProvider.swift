//
//  NetworkManager.swift
//  ForeFlightProject
//
//  Created by Andy Lindberg on 5/14/22.
//

import Foundation

final class NetworkManager {
    /// Executes the HTTP request and will attempt to decode the JSON
    /// response into a Codable object.
    /// - Parameters:
    ///   - urlString: the url to make the HTTP request to
    ///   - completion: the JSON response converted to the provided Codable
    /// object when successful or a failure otherwise
    class func request<T: Decodable>(urlString: String, completion: @escaping (Result<T, Error>) -> Void) {
        guard let airportURL = URL(string: urlString) else {
            print("URL creation error")
            return
        }

        var request = URLRequest(url: airportURL)
        request.httpMethod = "GET"
        request.setValue("1", forHTTPHeaderField: "ff-coding-exercise")

        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                print("Unknown error", error)
                return
            }
            
            guard response != nil, let data = data else {
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                print ("httpResponse.statusCode: \(httpResponse.statusCode)")
                let error = NSError(domain: "qa.foreflight", code: 404, userInfo: [NSLocalizedDescriptionKey: "Failed"])
                completion(.failure(error))
                return
                
            }
            
            if let responseObject = try? JSONDecoder().decode(T.self, from: data) {
                
                completion(.success(responseObject))
            } else {
                let error = NSError(domain: "qa.foreflight", code: 999, userInfo: [NSLocalizedDescriptionKey: "Failed"])
                completion(.failure(error))
            }
        }

        dataTask.resume()
    }
}
