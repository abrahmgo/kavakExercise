//
//  apiNames.swift
//  kavakExercise
//
//  Created by Andrés Bonilla on 12/3/19.
//  Copyright © 2019 Andrés Abraham Bonilla Gómez. All rights reserved.
//

import Foundation

class apiNames {
    
    let session = URLSession.shared
    
    private let key = "79cdbd851e82be1602775b60887c556a"
    private let server = "https://v2.namsor.com/api2/json/gender/"
    
//    func getGender(name: String, lastName: String)
//    {
//        guard let requestUrl = URL(string:server+"name"+"/\(lastName)") else { return }
//        let request = URLRequest(url:requestUrl)
//        let task = session.dataTask(with: request) {
//            (data, response, error) in
//            if let httpResponse = response as? HTTPURLResponse {
//                if error == nil{
//                    do{
//                        let str = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! [String:Any]
//                        completion(httpResponse.statusCode,str)
//                    }
//                    catch {
//                        completion(httpResponse.statusCode,["message":"formato de respuesta incorrecto"])
//                    }
//                } else {
//                    completion(httpResponse.statusCode,["message":"información no disponible"])
//                }
//            }else {
//                completion(500,["message":"url no disponible"])
//            }
//        }
//        task.resume()
//    }
}
