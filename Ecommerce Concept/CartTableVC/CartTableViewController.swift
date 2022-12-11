//
//  CartTableViewController.swift
//  EcommerceConcept
//
//  Created by Артём on 08.12.2022.
//

import UIKit

class CartTableViewController: UIViewController {
    
    var tableView: UITableView!
    
    var viewModel: CartTableViewModelProtocol!
    let bottomCartView = CartBottomView()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView = UITableView()
        view.addSubviewWithWholeFilling(subview: tableView)
        self.tableView.dataSource = self
        tableView.delegate = self
        self.navigationController?.tabBarItem.badgeColor = .blackTextColor
        setConstraints()
        tableView.register(CartTVCell.self, forCellReuseIdentifier: CartTVCell.reuseId)
        tableView.backgroundColor = .blackTextColor
        
        setupCallBacks()

        viewModel.getData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if viewModel.cartItems.isEmpty {
            viewModel.getData()
        }
    }
    
    // MARK: - Setup CallBacks
    private func setupCallBacks() {
        viewModel.fetchDataCallback = {[unowned self] viewModel in
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.bottomCartView.configure(with: viewModel.bottomCartViewModel)
                self.navigationController?.tabBarItem.badgeValue = viewModel.totalCountString
                self.tabBarController?.tabBar.items?[1].badgeValue = viewModel.totalCountString
            }
        }
        
        viewModel.countChangeCallback = {[unowned self] totalPriceString, totalCountString in
            DispatchQueue.main.async {
                self.bottomCartView.configureTotalPrice(with: totalPriceString)
                self.navigationController?.tabBarItem.badgeValue = totalCountString
            }
        }
    }
    
    private func setConstraints() {
        let tabBarHeight = tabBarController?.tabBar.frame.height ?? 0
        view.addSubviewAtTheBottom(subview: bottomCartView, bottomOffset: tabBarHeight)
    }
}

// MARK: -  UITableViewDataSource, UITableViewDelegate
extension CartTableViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cartItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CartTVCell.reuseId, for: indexPath) as! CartTVCell
        let cellItem = viewModel.cartItems[indexPath.row]
        cell.delegate = self
        cell.configure(with: cellItem)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - CartTVCellDelegate

extension CartTableViewController: CartTVCellDelegate {
    
    func countChanged(_ cell: UITableViewCell, count: Int) {
        guard let indexPath = tableView.indexPath(for: cell) else {return}
        viewModel.countChanged(indexOfItem: indexPath.row, count: count)
    }
    
    func deleteCell(_ cell: UITableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else {return}
        viewModel.deleteItem(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}

