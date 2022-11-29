//
//  ViewController.swift
//  WeatherApp
//
//  Created by Volha Furs on 26.04.22.
//

import UIKit

class ViewController: UIViewController {
    
    var cityNameSelected: String = ""
    var latSelected: Float = 0
    var lonSelected: Float = 0
    let searchController = UISearchController(searchResultsController: nil)
    @IBOutlet weak var tableView: UITableView!
    let networkServicve = NetworkService()
    var search1Response: [SearchResponse]? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSearchBar()
        setUpTableView()
    }
    
    private func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    private func setUpSearchBar() {
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        navigationController?.navigationBar.prefersLargeTitles = true
        searchController.obscuresBackgroundDuringPresentation = false
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let city = search1Response?[indexPath.row]
        guard let city = city else {return cell}
        cell.textLabel?.text = "\(city.name), \(city.country)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return search1Response?.count ?? 0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        cityNameSelected = search1Response![row].name ?? "city is not found"
        latSelected = search1Response![row].lat
        lonSelected = search1Response![row].lon
        let storyboard = UIStoryboard(name: "WeatherViewController", bundle: Bundle.main)
        let vc = storyboard.instantiateInitialViewController() as! WeatherViewController
        vc.cityName = cityNameSelected
        vc.lat = latSelected
        vc.lon = lonSelected
        navigationController?.pushViewController(vc, animated: true)
        print(cityNameSelected)
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        let urlString = "https://api.openweathermap.org/geo/1.0/direct?q=\(searchText)&limit=5&appid=4071dfd02cf6a99c04643a273e442a29"
        networkServicve.request(urlString: urlString) {[weak self] (result) in
            switch result {
            case .success(let searchResponse):
                self?.search1Response = searchResponse
                self?.tableView.reloadData()
                
            case .failure(let error):
                print(error)
            }
    }
    }
}

