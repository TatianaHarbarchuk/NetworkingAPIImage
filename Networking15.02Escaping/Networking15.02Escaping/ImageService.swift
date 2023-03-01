//
//  ImageService.swift
//  Networking15.02Escaping
//
//  Created by Tania Harbarchuk on 16.02.2023.
//

import Foundation

var images: Image?

struct ImageService {
    
    func fetchingAPIImages(matching query: String, completion: @escaping () -> ()) {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "pixabay.com"
        urlComponents.path = "/api"
        urlComponents.queryItems = [
            URLQueryItem(name: "key", value: "32828521-f057d7007ce70179fd3955d93"),
            URLQueryItem(name: "q", value: query),
            //                URLQueryItem(name: "image_type", value: query)
        ]
        let url = urlComponents.url
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: url!) { data, response, error in
            if error == nil {
                do {
                    images = try JSONDecoder().decode(Image.self, from: data!)
                    //completion(fetchingData)
                    DispatchQueue.main.async {
                        completion()
                    }
                } catch {
                    print("Parsing Error")
                }
            }
        }
        dataTask.resume()
    }
    
}
