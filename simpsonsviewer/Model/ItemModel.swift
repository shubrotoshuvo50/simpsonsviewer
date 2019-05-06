//
//  ItemModel.swift
//  simpsonsviewer
//
//  Created by IMCS2 on 5/2/19.
//  Copyright © 2019 Shubroto. All rights reserved.
//

import Foundation

struct ItemModel: Codable {
    var title: String? // This will be calculated through Text
    var Text: String?
    var Result: String?
    var Icon: IconModel?
}
