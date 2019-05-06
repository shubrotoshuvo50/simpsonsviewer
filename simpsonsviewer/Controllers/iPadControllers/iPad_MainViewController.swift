//
//  iPad_MainViewController.swift
//  simpsonsviewer
//
//  Created by IMCS2 on 5/3/19.
//  Copyright © 2019 Shubroto. All rights reserved.
//

import UIKit

class iPad_MainViewController: UIViewController {

    let cellId: String = "dataCellId"
    let itemViewModel: ItemViewModel = ItemViewModel()
    
    var intialDetailView: LoaderView = LoaderView() // Loader View Class
    var loaderScreen: LoaderView = LoaderView() // Screen for loading sign
    
    @IBOutlet weak var dataTableView: UITableView!
    @IBOutlet weak var imageHolder: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var detailWidthConst: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupIntialDetailView() // Set a intial detail view
        self.title = Service.appTitle // Set title of the app depend on version
        setupIntialUI() // Intial UI Setup
        getDataFromServer()
    }
}

// All private function goes here
extension iPad_MainViewController {
    
    // Intial UI Setup
    private func setupIntialUI() {
        setTableWidth(widthPercent: 40) // Set table width based on screen size
        loaderScreen.setUpView(parentView: view, message: "Please wait while the data is loading")
        loaderScreen.enableSpinner = true // Show spinner animation
    }
    
    // Get all the necessary data from the server
    private func getDataFromServer() {
        itemViewModel.getItemFromServer(completionHander: { [weak self] () in
            guard let self = self else { return }
            self.dataTableView.reloadData()
            DispatchQueue.main.async { [weak self] () in
                guard let self = self else { return }
                self.loaderScreen.removeFromSuperview() // Remove the entire loader screen
            }
        }) { [weak self] (message, code) in
            guard let self = self else { return }
            DispatchQueue.main.async { [weak self] () in
                guard let self = self else { return }
                self.loaderScreen.removeFromSuperview() // Remove the loader screen first
                self.intialDetailView.enableSpinner = false // Turn off the spinner if present
                self.intialDetailView.textLabel.text = "Something Went Wrong. Please Try again later"
            }
        }
    }
    
    // Draw a Intial View when app launches first time.
    private func setupIntialDetailView() {
        intialDetailView.setUpView(parentView: detailView, message: "Select a character from the left")
    }
    
    // Set width of the table based on the screen size
    private func setTableWidth(widthPercent: CGFloat) {
        let screenWidth = view.frame.width
        detailWidthConst.constant = screenWidth * (widthPercent/100) // Takes 40 percent of the screen
    }
}

// Extension for table view setup
extension iPad_MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Service.itemArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let itemModel = Service.itemArray[indexPath.row]
        cell.textLabel?.text = itemModel.itemModel.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let itemModel = Service.itemArray[indexPath.row] // Get the selected item model object
        imageHolder.image = itemModel.image
        titleLabel.text = itemModel.itemModel.title
        descriptionTextView.text = itemModel.itemModel.Text
        intialDetailView.removeFromSuperview() // Remove the intial detail view to show the content
    }
    
}
