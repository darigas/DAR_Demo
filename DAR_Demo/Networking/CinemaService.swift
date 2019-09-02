//
//  CinemaService.swift
//  DAR_Demo
//
//  Created by Dariga Akhmetova on 8/31/19.
//  Copyright © 2019 Dariga Akhmetova. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class CinemaService {
    static func getCities(url: String, success: @escaping([String]) -> Void, failure: @escaping(Error) -> Void){
        Alamofire.request(url).validate().responseJSON { (response) in
            guard response.result.isSuccess else {
                failure(response.result.error!)
                return
            }
            let swiftyJSON = JSON(response.result.value)
            var cities = [String]()
            for (key, value) in swiftyJSON {
                let city = value["name"].string
                cities.append(city!)
            }
            success(cities)
        }
    }
}
