//
//  DetailViewController.swift
//  simpsonsviewer
//
//  Created by IMCS2 on 5/3/19.
//  Copyright © 2019 Shubroto. All rights reserved.
//

import UIKit
import Hero

class DetailViewController: UIViewController {
    
    var imageWithItemModel: ImageWithItemModel?

    @IBOutlet weak var imageHolder: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = imageWithItemModel?.itemModel.title
        imageHolder.image = imageWithItemModel?.image
        titleLabel.text = imageWithItemModel?.itemModel.title
        descriptionTextView.text = imageWithItemModel?.itemModel.Text
        titleLabel.hero.id = "cellTitleAnimation" // Title animation
        imageHolder.hero.id = "cellImageAnimation" // Image animation from collection view cell
    }

}
