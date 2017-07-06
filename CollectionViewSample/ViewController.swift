//
//  ViewController.swift
//  CollectionViewSample
//
//  Created by ichi on 2017/07/06.
//  Copyright © 2017年 Rhzome Inc. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON

class ViewController: UIViewController {
    
    //FIXME: Enter your API Key.
    let myAPIKey = "+++ Your API Key +++"
    let placeDetailURL = "https://maps.googleapis.com/maps/api/place/details/json"
    let placePhotoURL = "https://maps.googleapis.com/maps/api/place/photo"
    
    @IBOutlet weak var collectionView: UICollectionView!

    var json: JSON!
    let cellIdentifier = "CollectionViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setup() {
        
        let nib:UINib = UINib(nibName: "CollectionViewCell", bundle: nil)
        self.collectionView.register(nib, forCellWithReuseIdentifier: self.cellIdentifier)
        
        let parameters = ["placeid":"ChIJN1t_tDeuEmsRUsoyG83frY4",
                          "key":myAPIKey]
        
        Alamofire.request(self.placeDetailURL,method: .get,parameters: parameters).responseJSON { (response) in
            
            guard let object = response.result.value else {
                return
            }
            
            self.json = JSON(object)
            self.collectionView.dataSource = self
            self.collectionView.delegate = self

        }
        
    }

}

extension ViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        let width: CGFloat = UIScreen.main.bounds.width / 2.0
        let height: CGFloat = width
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, refe indexPath: IndexPath) -> CGSize {
        let width: CGFloat = UIScreen.main.bounds.width / 2.0
        let height: CGFloat = width
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
}

extension ViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let _ = self.json {
            return self.json["result"]["photos"].count
        }else{
            return 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell : CollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellIdentifier, for: indexPath) as! CollectionViewCell
        
        let parameters = ["maxwidth":"800",
                          "photoreference":self.json["result"]["photos"][indexPath.row]["photo_reference"].stringValue,
                          "key":myAPIKey]
        
        Alamofire.request(self.placePhotoURL, method: .get, parameters: parameters).responseImage(completionHandler: { (response) in
            
            guard let image = response.result.value else {
                return
            }
            
            cell.imageView.image = image
            cell.label.text = "Item " + String(indexPath.row + 1)
            
        })
        
        
        return cell
        
    }
    
}


