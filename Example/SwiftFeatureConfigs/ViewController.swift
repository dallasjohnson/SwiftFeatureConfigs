//
//  ViewController.swift
//  SwiftFeatureConfigs
//
//  Created by Dallas Johnson on 09/12/2016.
//  Copyright (c) 2016 Dallas Johnson. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var showDetailsButton: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshView()
    }
    
    func refreshView() {
        self.title = ExampleFeatureConfigs.sharedInstance.mainViewTitle
        showDetailsButton.enabled = ExampleFeatureConfigs.sharedInstance.detailsViewEnabled
        self.collectionView.reloadData()
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ExampleFeatureConfigs.sharedInstance.numberOfCellsToDisplay
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCellWithReuseIdentifier("collectionViewCellIdentifier", forIndexPath: indexPath)
    }
}

extension ViewController {
    
    //This function will have no effect while the ExampleFeatureConfigs.plist is added to the target because it will overide the other settings.
    // This is ideal when developing features to ensure the developer can control the configs.
    @IBAction func injectInMemoryConfigs() {
        let json: [String : AnyObject] = ["detailsViewEnabled" : false,
                                    "numberOfCellsToDisplay": 52,
                                    "mainViewTitle": "JSON Injected title"]
        
        ExampleFeatureConfigs.sharedInstance.loadInMemoryFeatures(json)
        refreshView()
    }
    
    //When tapped the configs that can be persisted will be persisted in the UserDefaults and loaded in the future.
    @IBAction func persist() {
        ExampleFeatureConfigs.sharedInstance.persist()
        
    }
}
