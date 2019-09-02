//
//  MoviesRow.swift
//  DAR_Demo
//
//  Created by Dariga Akhmetova on 8/8/19.
//  Copyright © 2019 Dariga Akhmetova. All rights reserved.
//

import UIKit
import SwiftyJSON
import EasyPeasy
import SVProgressHUD

class MoviesRow: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    private let reuseableCollectionCellID = "movieCellID"
    var moviesToPresent = [Movie]()
    
    let moviesCollectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = CustomColor.sunset
        return collectionView
    }()
    
    func setupViews() {
        addSubview(moviesCollectionView)
        
        moviesCollectionView.dataSource = self
        moviesCollectionView.delegate = self
        
        moviesCollectionView.easy.layout(
            Top(0),
            Bottom(0),
            Left(0),
            Right(0)
        )
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseableCollectionCellID)
        moviesCollectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: reuseableCollectionCellID)
        self.setupViews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return moviesToPresent.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseableCollectionCellID, for: indexPath) as! MovieCollectionViewCell
        let url = URL(string: moviesToPresent[indexPath.row].poster)!
        let title = moviesToPresent[indexPath.row].title
        let data = try? Data(contentsOf: url)
        let image = UIImage(data: data!)
        cell.instantiate(image: image!, title: title )
        SVProgressHUD.dismiss()
        cell.layer.cornerRadius = 5
        cell.layer.masksToBounds = true
        return cell
    }
}

extension MoviesRow: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow: CGFloat = 2
        let hardCodedPadding: CGFloat = 10
        let itemWidth = (collectionView.bounds.width / itemsPerRow) - (1.5 * hardCodedPadding)
        let itemHeight = collectionView.bounds.height - (2 * hardCodedPadding)
        return CGSize(width: itemWidth, height: itemHeight)
    }
}
