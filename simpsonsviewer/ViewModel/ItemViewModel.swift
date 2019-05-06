//
//  ItemViewModel.swift
//  simpsonsviewer
//
//  Created by IMCS2 on 5/2/19.
//  Copyright © 2019 Shubroto. All rights reserved.
//

import Foundation
import Kingfisher

// Holds all the Item model from JSON
struct ItemArrayModel: Codable {
    var RelatedTopics: [ItemModel]?
}

class ItemViewModel {
    init() {
        
    }
}

// All private function goes here
extension ItemViewModel {
    // This will extract title from a specific string
    private func extractTitle(from text: String?) -> String {
        guard let text = text else { return "" }
        var title = ""
        let textArray = text.components(separatedBy: " - ") // Text seperated by -
        if textArray.indices.contains(1) { // The title is must present on zero index otherwise not
            title = textArray[0] // The title
        } else {
            title = ""
        }
        return title
    }
    
    // Convert the item model array to getAllImageWithItemModel by Calculating the title value and intializing placeholder image
    private func getAllImageWithItemModel(itemModel: [ItemModel]) -> [ImageWithItemModel] {
        var itemArray: [ImageWithItemModel] = []
        for item in itemModel {
            var newItem = item
            newItem.title = self.extractTitle(from: item.Text) // Get title for the item
            itemArray.append(ImageWithItemModel.init(image: Service.placeHolderImage, itemModel: newItem))
        }
        return itemArray
    }
}

// All Network Call Goes Here
extension ItemViewModel {
    // make data request and get data from server which is [ItemModel] through service
    func getItemFromServer(completionHander: @escaping () -> Void, errorHandler: @escaping (_ message: String, _ messageCode: Int) -> Void ) {
        guard let url = URL(string: Service.baseURL) else {
            errorHandler("URL is wrong", 3) // Error for URL
            return
        }
        let dataTask = URLSession.shared.dataTask(with: url) {[weak self] (data, response, error) in
            guard let self = self else { return }
            guard error == nil else {
                errorHandler("Something went wrong", 2) // An error message
                return
            }
            guard let data = data else {
                errorHandler("Data not found", 3) // Error for not getting data
                return
            }
            let itemModelArray = try? JSONDecoder().decode(ItemArrayModel.self, from: data)
            guard let itemArray = itemModelArray?.RelatedTopics else {
                errorHandler("No Data Found", 5) // No data found code
                return
            }
            let itemWithImageArray = self.getAllImageWithItemModel(itemModel: itemArray) // Item title is calculated here
            self.downloadAllImage(imageWithItemArray: itemWithImageArray, completionHandler: { (imageItemArray) in
                DispatchQueue.main.async {
                    Service.itemArray = imageItemArray // Set Image Item Array to the service 
                    completionHander() // Call the callback function
                }
            })
        }
        dataTask.resume()
    }
    
    // Download all the images required and get new ImageWithItemModel in completion handler
    private func downloadAllImage(imageWithItemArray: [ImageWithItemModel], completionHandler: @escaping (_ imageWithItemArray: [ImageWithItemModel]) -> Void) {
        var imageWithItemArrayCopy = imageWithItemArray // Copy version of imageWithItemArrayCopy
        let dispatchGroup = DispatchGroup() // Intiate Dispatch Group to get image
        for (index, itemWithImage) in imageWithItemArray.enumerated() { // Itterate and download all the images
            let item = itemWithImage.itemModel
            if let imageUrl = URL(string: item.Icon?.URL ?? "") { // URL Found
                dispatchGroup.enter()
                KingfisherManager.shared.retrieveImage(with: imageUrl) { ( result ) in
                    switch result {
                    case .success(let value): // Got the image successfully
                        let image = value.image
                       imageWithItemArrayCopy[index].image = image // Update the placeholder with downloaded image
                    case .failure( _): // Error getting image
                        NSLog("Failed to load images")
                    }
                    dispatchGroup.leave()
                }
            }
        }
        dispatchGroup.notify(queue: .main) {
            completionHandler(imageWithItemArrayCopy) // Call the callback function. Send the ImageWithItemArray new version
        }
    }
}
