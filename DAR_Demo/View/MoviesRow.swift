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

class MoviesRow: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    private let reuseableCell = "movieCell"
    let itemPerRow: CGFloat = 4
    let hardCodedPadding: CGFloat = 5
    let itemsCollection = 12
    
    var booksURLS: [String] = []
    
    let videosCollectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 5
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .black
        return collectionView
    }()
    
    func setupViews() {
        addSubview(videosCollectionView)
        
        videosCollectionView.dataSource = self
        videosCollectionView.delegate = self
        
        videosCollectionView.easy.layout(
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
        super.init(style: style, reuseIdentifier: reuseableCell)
        videosCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseableCell)
        setupViews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //        return itemsCollection
        return booksURLS.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseableCell, for: indexPath) as! UICollectionViewCell
        cell.backgroundColor = .red
        let imageView = UIImageView()
        imageView.easy.layout(
            Top(0),
            Bottom(0),
            Left(0),
            Right(0)
        )
        let url = URL(string: booksURLS[indexPath.row])!
        let data = try? Data(contentsOf: url)
        imageView.image = UIImage(data: data!)
        return cell
    }
}

extension MoviesRow: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow: CGFloat = 4
        let hardCodedPadding: CGFloat = 5
        let itemWidth = (collectionView.bounds.width / itemsPerRow) - hardCodedPadding
        let itemHeight = collectionView.bounds.height - (2 * hardCodedPadding)
        return CGSize(width: itemWidth, height: itemHeight)
    }
}
