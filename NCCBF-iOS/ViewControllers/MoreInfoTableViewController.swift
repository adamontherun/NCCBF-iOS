//
//  MoreInfoTableViewController.swift
//  NCCBF-iOS
//
//  Created by Keita Ito on 3/21/17.
//  Copyright © 2017 Keita Ito. All rights reserved.
//

import UIKit
import SafariServices

class MoreInfoTableViewController: UITableViewController {
    
    var items = MenuItem.itemsForMoreInfoTableVC()
    
    private let reuseIdentifier = "reuseIdentifier"
    
    override func loadView() {
        super.loadView()
        
        tableView.tableFooterView = FooterLabel(text: "Version \(BuildVersion().string)", fontSize: 14)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupUI()
    }
    
    // MARK: - UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)

        // Configure the cell...
        let item = items[indexPath.row]
        cell.textLabel?.text = item.title

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        if let url = item.url {
            let safariVC = SFSafariViewController(url: url)
            safariVC.title = item.title
            present(safariVC, animated: true)
        } else {
            let storyboard = UIStoryboard(name: "MoreInfoDetailViewController", bundle: Bundle.main)
            guard let moreInfoDetailVC = storyboard.instantiateViewController(withIdentifier: "MoreInfoDetailViewController") as? MoreInfoDetailViewController else {
                return }
            moreInfoDetailVC.item = item
            navigationController?.pushViewController(moreInfoDetailVC, animated: true)
        }
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        title = "More"
    }
    
    private func setupTableView() {
        self.clearsSelectionOnViewWillAppear = true
    }
}
