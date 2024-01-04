//
//  ViewController.swift
//  WalmartTest
//
//  Created by Jorge Garay on 03/01/24.
//

import UIKit
import MapKit

class HomeViewController: UIViewController {
    @IBOutlet weak var excerciseSegmentedControl: UISegmentedControl!
    @IBOutlet weak var sumLabel: UILabel!
    @IBOutlet weak var productsTableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!

    private let viewModel: HomeViewModelType
    private typealias Text = AppStrings.HomeScreen
    private var productsArray: [ProductsData] = []
    private var isLocalProducts: Bool = false

    
    init(viewModel: HomeViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.didChange = { [weak self] in
            self?.configure()
        }
        viewModel.start()
        setupTableView()
        // Do any additional setup after loading the view.
    }
    
    private func configure() {
        switch viewModel.state {
        case .idle:
            makeFirstExcercise()
        case .started(let productsData):
            DispatchQueue.main.async {
                self.productsArray = productsData
                self.productsTableView.reloadData()
            }
        }
    }
    
    private func setupTableView() {
        productsTableView.register(UINib.init(nibName: "ProductTableViewCell", bundle: nil), forCellReuseIdentifier: "ProductTableViewCell")
        productsTableView.delegate = self
        productsTableView.dataSource = self
    }

    @IBAction func segmentedControlTapped(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            makeFirstExcercise()
        case 1:
            makeSecondExcercise()
        case 2:
            makeThirdExcercise()
        case 3:
            makeFourthExcercise()
        default:
            makeFirstExcercise()
        }
    }
    
    func makeFirstExcercise() {
        let sumOfNumbers = getSumIntegers(makeArrayInt(10))
        sumLabel.isHidden = false
        productsTableView.isHidden = true
        mapView.isHidden = true
        sumLabel.text = Text.sumLabel.rawValue.replacingOccurrences(of: "@", with: String(sumOfNumbers))
    }
    
    func makeArrayInt(_ n: Int) -> [Int] {
        return (0..<n).map { _ in .random(in: 1...20) }
    }
    
    func getSumIntegers(_ array: [Int]) -> Int {
        let sum = array.reduce(0, +)
        return sum
    }
    
    func makeSecondExcercise() {
        sumLabel.isHidden = true
        productsTableView.isHidden = false
        mapView.isHidden = true
        isLocalProducts = false
        viewModel.getProducts(self)
    }
    
    func makeThirdExcercise() {
        sumLabel.isHidden = true
        productsTableView.isHidden = false
        mapView.isHidden = true
        isLocalProducts = true
        viewModel.getSavedProducts()
    }
    
    func makeFourthExcercise() {
        // Set the initial location for the map
        sumLabel.isHidden = true
        productsTableView.isHidden = true
        mapView.isHidden = false
        let initialLocation = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
        let regionRadius: CLLocationDistance = 1000
        let region = MKCoordinateRegion(center: initialLocation, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(region, animated: true)
        
        // Add sample annotation
        let annotation = MKPointAnnotation()
        annotation.coordinate = initialLocation
        annotation.title = "Sample Location"
        mapView.addAnnotation(annotation)
    }
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.productsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let productCell = productsTableView.dequeueReusableCell(withIdentifier: "ProductTableViewCell", for: indexPath) as! ProductTableViewCell
        let selectedProduct = productsArray[indexPath.row]
        productCell.nameLabel.text = selectedProduct.title
        productCell.priceLabel.text = selectedProduct.price.formatted(.currency(code: "USD"))//  String(selectedProduct.price)
        return productCell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
        
        let label = UILabel()
        label.frame = CGRect.init(x: 5, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
        label.text = isLocalProducts ? Text.deleteTitle.rawValue : Text.saveTitle.rawValue
        label.font = .systemFont(ofSize: 32)
        label.textColor = .black
        
        headerView.addSubview(label)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedProduct = productsArray[indexPath.row]
        if isLocalProducts {
            viewModel.deleteProduct(product: selectedProduct)
        } else {
            viewModel.saveProduct(product: selectedProduct)
        }
    }
    
    
}

extension HomeViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "customAnnotationView"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
}

