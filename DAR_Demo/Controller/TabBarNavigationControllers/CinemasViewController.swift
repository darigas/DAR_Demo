//
//  CinemasViewController.swift
//  DAR_Demo
//
//  Created by Dariga Akhmetova on 8/12/19.
//  Copyright © 2019 Dariga Akhmetova. All rights reserved.
//

import UIKit
import EasyPeasy
import SVProgressHUD

class CinemasViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let cellId = "cinemasCellID"
    var cities = [String]()
    
    let tableView: UITableView = {
        let table = UITableView()
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        
        SVProgressHUD.show()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.easy.layout(
            Top(0).to(view.safeAreaLayoutGuide, .top),
            Bottom(0).to(view.safeAreaLayoutGuide, .bottom),
            Left(0).to(view.safeAreaLayoutGuide, .left),
            Right(0).to(view.safeAreaLayoutGuide, .right)
        )
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
        DispatchQueue.global(qos: .utility).async {
            CinemaService.getCities(url: "http://127.0.0.1:8000/api/cities", success: { (responseCities) in
                self.cities = responseCities
                self.tableView.reloadData()
            }, failure: { (error) in
                SVProgressHUD.showError(withStatus: error.localizedDescription)
            })
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId)
        cell?.textLabel?.textColor = CustomColor.violetDark
        cell?.textLabel?.font = UIFont.boldSystemFont(ofSize: (cell?.textLabel?.font.pointSize)!)
        cell?.textLabel?.text = cities[indexPath.row]
        SVProgressHUD.dismiss()
        return cell!
    }
}
