//
//  api.swift
//  kavakExercise
//
//  Created by Andrés Abraham Bonilla Gómez on 12/2/19.
//  Copyright © 2019 Andrés Abraham Bonilla Gómez. All rights reserved.
//

import Foundation

class api {
    
    private let key = "79cdbd851e82be1602775b60887c556a"
    private let server = "https://v2.namsor.com/NamSorAPIv2/api2/json/gender/"
    var url: String
    let session = URLSession.shared
    
    static let shared = api(url: "https://raw.githubusercontent.com/rrafols/mobile_test/master/data.json")
    
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
    
    func getGender(name: String, lastName: String, completion: @escaping ((Int,NSDictionary) -> Void))
    {
        print(server+name+"/\(lastName)")
        guard let requestUrl = URL(string:server+name+"/\(lastName)") else { return }
        var request = URLRequest(url:requestUrl)
        request.setValue(key, forHTTPHeaderField: "X-API-KEY")
        request.httpMethod = "GET"
        let task = session.dataTask(with: request) {
            (data, response, error) in
            if let httpResponse = response as? HTTPURLResponse {
                if error == nil{
                    do{
                        let str = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
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
}
