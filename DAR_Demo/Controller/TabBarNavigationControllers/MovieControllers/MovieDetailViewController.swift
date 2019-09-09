//
//  MovieDetailViewController.swift
//  DAR_Demo
//
//  Created by Dariga Akhmetova on 9/2/19.
//  Copyright © 2019 Dariga Akhmetova. All rights reserved.
//

import UIKit
import EasyPeasy

class MovieDetailViewController: UIViewController {
    
    var movie: Movie?
    
    let movieTitle: CommonLabel = {
        let title = CommonLabel()
        return title
    }()
    
    let movieGenre: CommonLabel = {
        let genre = CommonLabel()
        return genre
    }()
    
    let moviePremiere: CommonLabel = {
        let premiere = CommonLabel()
        return premiere
    }()
    
    let movieDescription: CommonLabel = {
        let description = CommonLabel()
        description.numberOfLines = 0
        return description
    }()
    
    let movieAge: CommonLabel = {
        let age = CommonLabel()
        return age
    }()
    
    let moviePoster: UIImageView = {
        let poster = UIImageView()
        poster.contentMode = UIView.ContentMode.scaleAspectFill
        poster.layer.cornerRadius = 5
        poster.layer.masksToBounds = true
        return poster
    }()
    
    let backButton: CommonButton = {
        let button = CommonButton()
        button.setTitle("BACK", for: .normal)
        return button
    }()
    
    static func instantiate(movie: Movie) -> MovieDetailViewController {
        let controller = MovieDetailViewController()
        controller.movie = movie
        return controller
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        
        view.addSubview(moviePoster)
        moviePoster.easy.layout(
            CenterX(),
//            Width(width / 4),
//            Height(width / 4),
            Right(0),
            Left(0),
            Height(height / 3),
            Top(16).to(topLayoutGuide)
        )
        
        view.addSubview(movieTitle)
        movieTitle.easy.layout(
            CenterX(),
            Height(height / 24),
            Top(16).to(moviePoster)
        )
        
        view.addSubview(movieGenre)
        movieGenre.easy.layout(
            CenterX(),
            Height(height / 24),
            Top(16).to(movieTitle)
        )
        
        view.addSubview(moviePremiere)
        moviePremiere.easy.layout(
            CenterX(),
            Height(height / 24),
            Top(16).to(movieGenre)
        )
        
        view.addSubview(movieAge)
        movieAge.easy.layout(
            CenterX(),
            Height(height / 24),
            Top(16).to(moviePremiere)
        )
        
        view.addSubview(movieDescription)
        movieDescription.easy.layout(
            CenterX(),
//            Height(height / 4),
            Right(16),
            Left(16),
            Top(16).to(movieAge)
        )
        
        view.addSubview(backButton)
        backButton.easy.layout(
            CenterX(),
            Height(height / 24),
            Top(16).to(movieDescription)
        )
        backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        
        if let movie = movie {
            let url = URL(string: movie.poster)
            let data = try? Data(contentsOf: url!)
            let image = UIImage(data: data!)
            moviePoster.image = image
            
            movieTitle.text = movie.title
            movieGenre.text = "Жанр: \(movie.genre)"
            moviePremiere.text = "Премьера: \(movie.premiere)"
            movieAge.text = "Возрастной рейтинг: \(String(movie.age))"
            movieDescription.text = "Сюжет: \(movie.description)"
        }
    }
    
    @objc func goBack(){
        let controller = TabBarController()
        self.present(controller, animated: true, completion: nil)
    }
}
