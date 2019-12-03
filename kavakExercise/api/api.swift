//
//  api.swift
//  kavakExercise
//
//  Created by Andrés Abraham Bonilla Gómez on 12/2/19.
//  Copyright © 2019 Andrés Abraham Bonilla Gómez. All rights reserved.
//

import Foundation

class api {
    
    var url: String
    let session = URLSession.shared
    
    init(url:String) {
        self.url = url
    }
    
    func downloadData(completion: @escaping ((Int,[String:Any]) -> Void))
    {
        guard let requestUrl = URL(string:url) else { return }
        let request = URLRequest(url:requestUrl)
        let task = session.dataTask(with: request) {
            (data, response, error) in
            if let httpResponse = response as? HTTPURLResponse {
                if error == nil{
                    do{
                        let str = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! [String:Any]
                        completion(httpResponse.statusCode,str)
                    }
                    catch {
                        completion(httpResponse.statusCode,["message":"formato de respuesta incorrecto"])
                    }
                } else {
                    completion(httpResponse.statusCode,["message":"información no disponible"])
                }
            }else {
                completion(500,["message":"url no disponible"])
            }
        }
        task.resume()
    }
    
    func cleanGnomes(data : [[String:Any]],completion: @escaping (([gnome]) -> Void))
    {
        var gnomes = [gnome]()
        for oneGnome in data
        {
            let jsonData = oneGnome.json.data(using: .utf8)!
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let uniqueGnome = try! decoder.decode(gnome.self, from: jsonData)
            gnomes.append(uniqueGnome)
        }
        completion(gnomes)
    }
}
