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
    
    var categories = ["Сегодня в кино", "Скоро в кино", "Избранные"]
    let cellId = "moviesCell"
    let itemsRows: CGFloat = 5
    let headerHeight: CGFloat = 30
    
    let tableView: UITableView = {
        let table = UITableView()
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return categories[section]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return categories.count
    }
}


