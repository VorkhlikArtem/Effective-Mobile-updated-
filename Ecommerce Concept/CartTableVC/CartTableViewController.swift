//
//  CartTableViewController.swift
//  EcommerceConcept
//
//  Created by Артём on 08.12.2022.
//

import UIKit
import Combine

class CartTableViewController: UIViewController {
    
    var tableView: UITableView!
    var viewModel: CombineCartViewModelProtocol!
    let bottomCartView = CartBottomView()
    
    private var cancellables: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CartTVCell.self, forCellReuseIdentifier: CartTVCell.reuseId)
        tableView.backgroundColor = .blackTextColor
        
        self.navigationController?.tabBarItem.badgeColor = .blackTextColor
        setConstraints()
        setupBindings()
        viewModel.getData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if viewModel.cartItems.isEmpty {
            viewModel.getData()
        }
    }
    
    // MARK: - Setup Binding
    private func setupBindings() {
        viewModel.cartItemsPublisher.receive(on: DispatchQueue.main)
            .sink { _ in
                self.tableView.reloadData()
            }.store(in: &cancellables)
        
        viewModel.bottomCartViewModelPublisher.receive(on: DispatchQueue.main)
            .sink { [weak self] bottomViewModel in
                self?.bottomCartView.configure(with: bottomViewModel)
            }.store(in: &cancellables)
        
        viewModel.totalCountAndPriceStringPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (totalPrice, totalCount) in
                self?.bottomCartView.configureTotalPrice(with: totalPrice)
                self?.navigationController?.tabBarItem.badgeValue = totalCount
            }.store(in: &cancellables)
    }
    
    private func handleCellEvent(indexPath: IndexPath, event: CartCellEvent) {
        switch event {
        case .quantityChanged(value: let value):
            viewModel.countChanged(indexOfItem: indexPath.row, count: value)
        case .deleteItem:
            viewModel.deleteItem(at: indexPath.row)
       //     tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    private func setConstraints() {
        let tabBarHeight = tabBarController?.tabBar.frame.height ?? 0
        view.addSubviewAtTheBottom(subview: bottomCartView, bottomOffset: tabBarHeight)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomCartView.topAnchor),])
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
        cell.configure(with: cellItem)
        
        cell.eventPublisher.receive(on: RunLoop.main)
            .sink { [weak self] cartCellEvent in
                self?.handleCellEvent(indexPath: indexPath, event: cartCellEvent)
            }.store(in: &cell.cancellables)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
