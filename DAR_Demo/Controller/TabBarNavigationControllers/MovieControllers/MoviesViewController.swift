//
//  MoviesViewController.swift
//  DAR_Demo
//
//  Created by Dariga Akhmetova on 8/8/19.
//  Copyright © 2019 Dariga Akhmetova. All rights reserved.
//

import UIKit
import SwiftyJSON
import EasyPeasy
import SVProgressHUD

class MoviesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var categories = ["Сегодня в кино", "Скоро в кино"]
    let cellId = "moviesCellID"
    let itemsRows: CGFloat = 2
    let headerHeight: CGFloat = 30
    var movieCategories = [[Movie]]()
    
    let tableView: UITableView = {
        let table = UITableView()
        table.isScrollEnabled = false
        return table
    }()
    
    let headerLabel: CommonLabel = {
        let headerLabel = CommonLabel()
        return headerLabel
    }()
    
    fileprivate func setupTableView() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.easy.layout(
            Top(0).to(view.safeAreaLayoutGuide, .top),
            Bottom(0).to(view.safeAreaLayoutGuide, .bottom),
            Left(0).to(view.safeAreaLayoutGuide, .left),
            Right(0).to(view.safeAreaLayoutGuide, .right)
        )
        tableView.register(MoviesRow.self, forCellReuseIdentifier: cellId)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SVProgressHUD.show()
        DispatchQueue.global(qos: .utility).async {
            MovieService.getMovies(url: "http://127.0.0.1:8000/api/movies", success: { (movies) in
                self.movieCategories.append(movies)
                MovieService.getMovies(url: "http://127.0.0.1:8000/api/coming_soon_movies", success: { (movies) in
                    self.movieCategories.append(movies)
                    DispatchQueue.main.async {
                        self.setupTableView()
                    }
                }, failure: { (error) in
                    print(error.localizedDescription)
                })
            }, failure: { (error) in
                print(error.localizedDescription)
            })
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! MoviesRow
        let rowHeight = tableView.frame.height / itemsRows - headerHeight
        cell.heightAnchor.constraint(equalToConstant: rowHeight).isActive = true
        cell.moviesToPresent = movieCategories[indexPath.section]
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return categories[section]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = .white
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = CustomColor.violetDark
    }
}


