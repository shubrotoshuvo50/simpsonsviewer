//
//  ViewController.swift
//  simpsonsviewer
//
//  Created by IMCS2 on 5/2/19.
//  Copyright © 2019 Shubroto. All rights reserved.
//

import UIKit
import Hero

class ViewController: UIViewController {
    
    let tableCellId: String = "itemTableCellId"
    let collectionCellId: String = "itemCollectionCellId"
    var layout: String = "None" // The present layout format
    
    private let itemViewModel: ItemViewModel = ItemViewModel() // View Model Instance

    @IBOutlet weak var layoutButtonItem: UIBarButtonItem!
    
    var messageView: LoaderView = LoaderView()
    
    var dataTableView: UITableView = { // Table View to view images in grid style
        let tableView = UITableView()
        return tableView
    }()
    
    
    var dataCollectionView: UICollectionView = { // Collection view to view images in grid style
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout.init())
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableViewLayout() // Setup table View on first load
        setupIntialUI() // Setup all the intial UI Stuffs
        registerCells() // Register all the necessary cells
        getAllData()
    }
    
    @IBAction func layoutChangeButtonAction(_ sender: Any) {
        switch layout {
        case "Table":
            layout = "Cell" // Change the layout for display to the cell
            layoutButtonItem.image = #imageLiteral(resourceName: "list") // Change the button icon
            dataTableView.removeFromSuperview() // Remove the Table View
            setupCollectionViewLayout()
        case "Cell":
            layout = "Table" // Change the layout for dipslay to table
            layoutButtonItem.image = #imageLiteral(resourceName: "grid") // Change the button Icon
            dataCollectionView.removeFromSuperview() // Remove the collection view
            setupTableViewLayout()
        default:
            print("Nothing")
        }
    }
}

// All private functions
extension ViewController {
    
    // Setup intial UI when app loaded
    private func setupIntialUI() {
        self.hero.isEnabled = true
        self.title = Service.appTitle // Set the app title depending on version
        messageView.setUpView(parentView: view, message: "Please wait while data is loading")
        messageView.enableSpinner = true // Show the spinner animation
    }
    
    // Registers all the necessary cells for use
    private func registerCells() {
        dataTableView.register(UINib(nibName: "dataTableViewCell", bundle: nil), forCellReuseIdentifier: tableCellId) // Register the table view cell
        dataCollectionView.register(UINib(nibName: "dataCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: collectionCellId) // Register the collection view cell
    }
    
    // Make a server request and get all ItemModel
    private func getAllData() {
        itemViewModel.getItemFromServer(completionHander: {[weak self] () in
            guard let self = self else { return }
            self.layout = "Table" // Intial loading style
            switch self.layout {
            case "Table":
                self.dataTableView.reloadData()
            case "Cell":
                self.dataCollectionView.reloadData()
            default:
                print("Nothing")
            }
            DispatchQueue.main.async {[weak self] () in
                guard let self = self else { return }
                self.messageView.removeFromSuperview()
            }
        }) { (message, code) in
            DispatchQueue.main.async {[weak self] () in
                guard let self = self else { return }
                self.messageView.enableSpinner = false // Disable the spinner
                self.messageView.textLabel.text = "Opps cannot load anything"
            }
        }
    }
    
    private func navigateToDetailView(indexPath: IndexPath) {
        let imageWithItemModel = Service.itemArray[indexPath.row]
        let controller = Router.detailRoute() // Get the detail view controller route
        controller.imageWithItemModel = imageWithItemModel
        self.navigationController?.show(controller, sender: nil)
    }
}

// All manual UI Setup Goes Here
extension ViewController {
    // Setup Collection View UI
    private func setupCollectionViewLayout() {
        setupCollectionCellSize()
        dataCollectionView.delegate = self
        dataCollectionView.dataSource = self
        view.addSubview(dataCollectionView) // Add table to the sub view
        setConstraintTo(dataCollectionView) // Set the necessary constraint to the table view
    }
    
    // Setup the size of the collection
    private func setupCollectionCellSize() {
        let itemInOneLine: CGFloat = 2 // Total Item in one line
        let itemSpacing: CGFloat = 10 // Space in the sides of the cell
        let itemLineSpacing: CGFloat = 15 // Space between the cells
        let sideInset: CGFloat = 10 // Space beside the side of the collection View
        
        let rowWidth = view.frame.width - itemSpacing * CGFloat(itemInOneLine - 1) - (sideInset * 2) // Determine the width of the row eliminating all the spaces
        let cellWidth = rowWidth/itemInOneLine // Determine the Width of a particular cell
        
        let layout = UICollectionViewFlowLayout.init() // Setup Layout
        layout.sectionInset = UIEdgeInsets(top: 20, left: sideInset, bottom: 20, right: sideInset) // Set the inset
        layout.itemSize = CGSize(width: floor(cellWidth), height: 200) // Set the size of the cell
        layout.minimumLineSpacing = itemLineSpacing // Set the line spacing
        layout.minimumInteritemSpacing = itemSpacing // Set the spacing between items
        dataCollectionView.setCollectionViewLayout(layout, animated: false)
    }
    
    // Setup Table View UI
    private func setupTableViewLayout() {
        dataTableView.delegate = self
        dataTableView.dataSource = self
        view.addSubview(dataTableView) // Add table view to the sub view
        setConstraintTo(dataTableView) // Set the necessary constraint to the table view
    }
    
    // Set constraint to the view: collectionview or tableview
    private func setConstraintTo(_ dataView: UIView) {
        dataView.translatesAutoresizingMaskIntoConstraints = false
        let viewSafeArea = view.safeAreaLayoutGuide // Only from safe area
        NSLayoutConstraint.activate([
            dataView.topAnchor.constraint(equalTo: viewSafeArea.topAnchor, constant: 0),
            dataView.bottomAnchor.constraint(equalTo: viewSafeArea.bottomAnchor, constant: 0),
            dataView.leadingAnchor.constraint(equalTo: viewSafeArea.leadingAnchor, constant: 0),
            dataView.trailingAnchor.constraint(equalTo: viewSafeArea.trailingAnchor, constant: 0)
        ])
    }
    
}

// Extension for table view configuration
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Service.itemArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableCellId, for: indexPath) as! dataTableViewCell
        cell.selectionStyle = .none // change the selection highlighting to none
        let item = Service.itemArray[indexPath.row]
        cell.titleLabel.text = item.itemModel.title
        cell.titleLabel.hero.id = "cellTitleAnimation"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigateToDetailView(indexPath: indexPath)
    }
}

// Extension for collection view configuration
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Service.itemArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionCellId, for: indexPath) as! dataCollectionViewCell
        let item = Service.itemArray[indexPath.row]
        cell.imageHolder.image = item.image
        cell.imageHolder.hero.id = "cellImageAnimation"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        navigateToDetailView(indexPath: indexPath)
    }
    
}
