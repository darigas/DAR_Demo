//
//  Movie.swift
//  DAR_Demo
//
//  Created by Dariga Akhmetova on 8/23/19.
//  Copyright © 2019 Dariga Akhmetova. All rights reserved.
//

import Foundation

class Movie {
    var title: String
    var genre: String
    var premiere: String
    var description: String
    var age: Int
    var poster: String
    
    init(title: String, genre: String, premiere: String, description: String, age: Int, poster: String) {
        self.title = title
        self.genre = genre
        self.premiere = premiere
        self.description = description
        self.age = age
        self.poster = poster
    }
}
