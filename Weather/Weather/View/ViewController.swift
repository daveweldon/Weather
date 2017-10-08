//
//  ViewController.swift
//  Weather
//
//  Created by David Weldon on 08/10/2017.
//  Copyright © 2017 nsdave. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let config = Realm.Configuration(
            fileURL: Bundle.main.url(forResource: "city.list", withExtension: "realm"),
            readOnly: true)
        let realm = try! Realm(configuration: config)
        
        let results = realm.objects(Location.self).filter("name == 'London'")
        print("number of search results = \(results.count)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

