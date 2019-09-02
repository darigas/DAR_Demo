//
//  MovieCollectionViewCell.swift
//  DAR_Demo
//
//  Created by Dariga Akhmetova on 8/31/19.
//  Copyright © 2019 Dariga Akhmetova. All rights reserved.
//

import UIKit
import EasyPeasy

class MovieCollectionViewCell: UICollectionViewCell {
    let movieTitle: UILabel = {
        let movieTitle = UILabel()
        movieTitle.backgroundColor = CustomColor.violetDark
        movieTitle.font = UIFont.boldSystemFont(ofSize: movieTitle.font.pointSize)
        movieTitle.textColor = .white
        movieTitle.numberOfLines = 3
        movieTitle.textAlignment = .center
        movieTitle.layer.cornerRadius = 5
        movieTitle.layer.masksToBounds = true
        return movieTitle
    }()
    
    let movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.layer.cornerRadius = 5
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = CustomColor.violetLight
        return imageView
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    func instantiate(image: UIImage, title: String){
        movieTitle.text = title
        movieImageView.image = image
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func setupSubviews(){
        addSubview(movieTitle)
        addSubview(movieImageView)
        
        movieTitle.easy.layout(
            Top(0),
            Left(0),
            Right(0),
            Height(70)
        )
        
        movieImageView.easy.layout(
            Top(5).to(movieTitle),
            Left(0),
            Right(0),
            Bottom(0)
        )
    }
}
