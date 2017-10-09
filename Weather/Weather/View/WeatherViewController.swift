//
//  WeatherViewController.swift
//  Weather
//
//  Created by David Weldon on 08/10/2017.
//  Copyright © 2017 nsdave. All rights reserved.
//

import UIKit
import PKHUD

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var holdingLabel: UILabel!
    @IBOutlet weak var detailScrollView: UIScrollView!
    
    fileprivate var resultsController   : UITableViewController?
    fileprivate var searchController    : UISearchController?
    fileprivate var locationPresenter   : LocationPresenter?
    fileprivate var weatherPresenter    : WeatherPresenter?
    fileprivate let cellIdentifier      = "identifier"
    fileprivate var locations           = [Location]()
    fileprivate var forecast            : Forecast? {
        didSet {
            holdingLabel.isHidden = (forecast != nil)
            detailScrollView.isHidden = (forecast == nil)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Weather"
        
        locationPresenter = LocationPresenter(locationView: self)
        weatherPresenter = WeatherPresenter(weatherView: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func didSelectSearch(_ sender: UIBarButtonItem) {
        resultsController = UITableViewController(style: .plain)
        resultsController?.tableView.delegate = self
        resultsController?.tableView.dataSource = self
        searchController = UISearchController(searchResultsController: resultsController)
        searchController?.searchResultsUpdater = self
        
        if let searchController = searchController {
            self.present(searchController, animated: true, completion: nil)
        }
    }

}

extension WeatherViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        locationPresenter?.searchTerm(searchController.searchBar.text)
    }

}

extension WeatherViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count < 25 ? locations.count : 25
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        }

        let location = locations[indexPath.row]
        cell!.textLabel?.text = "\(location.name), \(location.country)"

        return cell!
    }
    
}

extension WeatherViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchController?.dismiss(animated: true, completion: nil)
        
        if let locationId = locations[indexPath.row].locationId.value {
            weatherPresenter?.search(locationId: locationId)
        }
    }
    
}

extension WeatherViewController: LocationView {
    
    func set(locations: [Location]) {
        self.locations = locations
        resultsController?.tableView.reloadData()
    }
    
}

extension WeatherViewController: WeatherView {
    
    func startLoading() {
        HUD.show(.progress)
    }
    
    func finishLoading() {
        HUD.hide()
    }
    
    func set(forecast: Forecast?) {
        self.forecast = forecast
    }
    
    func present(_ error: Error) {
        AlertFactory.alert(with: error)
    }
}
