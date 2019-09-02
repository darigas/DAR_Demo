//
//  MovieService.swift
//  DAR_Demo
//
//  Created by Dariga Akhmetova on 8/23/19.
//  Copyright © 2019 Dariga Akhmetova. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class MovieService {
    static func getMovies(url: String, success: @escaping([Movie]) -> Void, failure: @escaping(Error) -> Void){
        Alamofire.request(url).validate().responseJSON { (response) in
            guard response.result.isSuccess else {
                failure(response.result.error!)
                return
            }
            let swiftyJSON = JSON(response.result.value)
            var movies = [Movie]()
            for (key, value) in swiftyJSON {
                let title = value["title"].string
                let genre = value["genre"].string
                let premiere = value["premiere"].string
                let description = value["description"].string
                let age = value["age"].int
                let poster = value["poster"].string
                let movie = Movie(title: title!, genre: genre!, premiere: premiere!, description: description!, age: age!, poster: poster!)
                movies.append(movie)
            }
            success(movies)
        }
    }
}
