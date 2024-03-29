//
//  StatusView.swift
//  CalTest
//
//  Created by Jamie McAllister on 09/01/2018.
//  Copyright © 2018 Jamie McAllister. All rights reserved.
//

import UIKit

class StatusView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var statuses: [Status] = []
    var event: Event? = nil
    var hasPropogatedAdverts = false
    
    var rootView: EventViewController? = nil
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        backgroundColor = UIColor(rgb:0xD1D1D1)
        translatesAutoresizingMaskIntoConstraints = false
        delegate = self
        dataSource = self
        
        isPagingEnabled = true
        
        register(StatusViewCell.self, forCellWithReuseIdentifier: "StatusCell")
        register(NewStatusViewCell.self, forCellWithReuseIdentifier: "NewStatusCell")
        register(AdMobCollectionViewCell.self, forCellWithReuseIdentifier: "AdvertStatusCell")
        
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.lightGray.cgColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func doLoad(){
       
        statusHandler.getStatus(forEvent: event!.id, { (statuses) in
            self.statuses = statuses
            self.collectionViewLayout.collectionView?.reloadData()
        })
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return statuses.count + 1
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(indexPath.row == 0){
            let cell = dequeueReusableCell(withReuseIdentifier: "NewStatusCell", for: indexPath) as! NewStatusViewCell
            
            cell.event = self.event
            
            return cell
        }else{
            if(statuses[indexPath.row - 1].isAd != nil){
            }else{
                statuses[indexPath.row - 1].isAd = false
            }
            if(statuses[indexPath.row - 1].isAd!){
                let cell = dequeueReusableCell(withReuseIdentifier: "AdvertStatusCell", for: indexPath) as! AdMobCollectionViewCell
                return cell
            }else{
                let cell = dequeueReusableCell(withReuseIdentifier: "StatusCell", for: indexPath) as! StatusViewCell
                
                cell.backgroundColor = .white
                cell.message.text = statuses[indexPath.row - 1].message
                cell.poster.text = statuses[indexPath.row - 1].poster?.name()
                cell.picture.image = statuses[indexPath.row - 1].poster?.picture
                
                return cell
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if(indexPath.row > 0){
            if(statuses[indexPath.row - 1].isAd!){
                return CGSize(width: frame.width, height: frame.height)
            }else{
                return CGSize(width: frame.width, height: frame.height)
            }
        }else{
            return CGSize(width: frame.width, height: frame.height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) ->()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }

}

