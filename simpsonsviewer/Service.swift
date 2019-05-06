//
//  Service.swift
//  simpsonsviewer
//
//  Created by IMCS2 on 5/2/19.
//  Copyright © 2019 Shubroto. All rights reserved.
//

import Foundation
import UIKit

class Service {
    
    #if WIREVIEWER
    static let baseURL: String = "https://api.duckduckgo.com/?q=the+wire+characters&format=json"
    static let appTitle: String = "The Wire Character Viewer"
    #else
    static let appTitle: String = "Simpsons Character Viewer"
    static let baseURL: String = "https://api.duckduckgo.com/?q=simpsons+characters&format=json"
    #endif
    
    static var itemArray: [ImageWithItemModel] = [] // All the Item from the server stored here
    
    static var placeHolderImage: UIImage = #imageLiteral(resourceName: "placeholder-600x400")
    
    private init() {
        
    }
}
