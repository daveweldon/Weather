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
    @IBOutlet weak var forecastView: UIView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    fileprivate var resultsController   : UITableViewController?
    fileprivate var searchController    : UISearchController?
    fileprivate var locationPresenter   : LocationPresenter?
    fileprivate var weatherPresenter    : WeatherPresenter?
    fileprivate let cellId              = "identifier"
    fileprivate let collectionCellId    = "WeatherCollectionViewCell"
    fileprivate var currentLocation     : Location?
    fileprivate var locations           = [Location]()
    fileprivate var forecast            : Forecast? {
        didSet {
            holdingLabel.isHidden = (forecast != nil)
            forecastView.isHidden = (forecast == nil)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Weather"
        
        locationPresenter = LocationPresenter(locationView: self)
        weatherPresenter = WeatherPresenter(weatherView: self)
        
        if let flowLayout = collectionView.collectionViewLayout as? PagingCollectionViewFlowLayout {
            let cellSize = CGSize(width: collectionView.bounds.size.width,
                                  height: collectionView.bounds.size.height)
            flowLayout.itemSize = cellSize
            flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            flowLayout.minimumLineSpacing = 0.0
            flowLayout.minimumInteritemSpacing = 0.0
        }

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
    
    func updateForecastView() {
        guard let currentLocation = currentLocation else { return }
        locationLabel.text = "\(currentLocation.name) \(currentLocation.country)"
    }

}

// MARK:- Location searching
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
        var cell : UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellId)
        
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: cellId)
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
            currentLocation = locations[indexPath.row]
            weatherPresenter?.search(locationId: locationId)
        }
    }
    
}

// MARK:- Presenter protocols
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
        updateForecastView()
        collectionView.reloadData()
    }
    
    func present(_ error: Error) {
        AlertFactory.alert(with: error)
    }
}

// MARK:- Collection View
extension WeatherViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return forecast?.weather?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionCellId, for: indexPath as IndexPath) as! WeatherCollectionViewCell
        
        if let weathers = forecast?.weather {
            cell.configure(with: weathers[indexPath.row])
        }
        
        return cell
    }
    
}

extension WeatherViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }

}
