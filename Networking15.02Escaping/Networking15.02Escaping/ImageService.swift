//
//  ImageService.swift
//  Networking15.02Escaping
//
//  Created by Tania Harbarchuk on 16.02.2023.
//

import Foundation

struct ImageService {
    
    private struct Constant {
        
        static let scheme = "https"
        static let host = "pixabay.com"
        static let path = "/api"
        static let apiKey = "32828521-f057d7007ce70179fd3955d93"
    }
    
    func fetchingAPIImages(matching query: String, completion: @escaping (Image) -> ())  {
        var urlComponents = URLComponents()
        urlComponents.scheme = Constant.scheme
        urlComponents.host = Constant.host
        urlComponents.path = Constant.path
        urlComponents.queryItems = [
            URLQueryItem(name: "key", value: Constant.apiKey),
            URLQueryItem(name: "q", value: query)
        ]
        let url = urlComponents.url
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: url!) { data, response, error in
            if error == nil {
                do {
                    let imagesJ = try JSONDecoder().decode(Image.self, from: data!)
                    DispatchQueue.main.async {
                        completion(imagesJ)
                    }
                } catch {
                    print("Parsing Error")
                }
            }
        }
        dataTask.resume()
    }
}
