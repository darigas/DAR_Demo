//
//  Cinema.swift
//  DAR_Demo
//
//  Created by Dariga Akhmetova on 8/23/19.
//  Copyright © 2019 Dariga Akhmetova. All rights reserved.
//

import Foundation

class Cinema {
    var title: String
    var poster: String
    var address: String
    var phone: String
    var description: String
    
    init(title: String, poster: String, address: String, phone: String, description: String) {
        self.title = title
        self.poster = poster
        self.address = address
        self.phone = phone
        self.description = description
    }
}
