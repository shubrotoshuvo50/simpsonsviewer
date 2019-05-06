//
//  Router.swift
//  simpsonsviewer
//
//  Created by IMCS2 on 5/3/19.
//  Copyright © 2019 Shubroto. All rights reserved.
//

import Foundation
import UIKit

class Router {
    
    // Route to the DetailViewController
    static func detailRoute() -> DetailViewController {
        let storyboard = UIStoryboard(name: "DetailStoryboard", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "detailStoryboardId") as! DetailViewController
        return controller
    }
    
    private init(){
        
    }
}
