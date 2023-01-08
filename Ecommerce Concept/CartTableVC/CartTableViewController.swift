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
//        viewModel.fetchDataCallback = {[unowned self] viewModel in
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//                self.bottomCartView.configure(with: viewModel.bottomCartViewModel)
//               // self.navigationController?.tabBarItem.badgeValue = viewModel.totalCountString
//            }
//        }
        
//        viewModel.countChangeCallback = {[unowned self] totalPriceString, totalCountString in
//            DispatchQueue.main.async {
//                self.bottomCartView.configureTotalPrice(with: totalPriceString)
//                self.navigationController?.tabBarItem.badgeValue = totalCountString
//            }
//        }
        
        viewModel.cartItemsPublisher.receive(on: DispatchQueue.main)
            .sink { cartViewModel in
                self.tableView.reloadData()
               
            }.store(in: &cancellables)
        
        viewModel.bottomCartViewModelPublisher.receive(on: DispatchQueue.main)
            .sink { [weak self] bottomViewModel in
                self?.bottomCartView.configure(with: bottomViewModel)
            }.store(in: &cancellables)
            
        
        if let tabBarItem = self.navigationController?.tabBarItem {
            viewModel.totalCountStringPublisher
                .receive(on: DispatchQueue.main)
                .assign(to: \.badgeValue, on: tabBarItem)
                .store(in: &cancellables)
        }
        
        viewModel.totalPriceStringPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] totalPriceString in
                self?.bottomCartView.configureTotalPrice(with: totalPriceString)
            }.store(in: &cancellables)
        
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
//        return viewModel.cartItemsPublisher.receive(on: DispatchQueue.main).sink { items in
//            return items.count
//        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CartTVCell.reuseId, for: indexPath) as! CartTVCell
        let cellItem = viewModel.cartItems[indexPath.row]
        //cell.delegate = self
        cell.configure(with: cellItem)
        
        cell.countChangeAction.receive(on: RunLoop.main)
            .sink { [weak self] count in
                print(indexPath)
            self?.viewModel.countChanged(indexOfItem: indexPath.row, count: count)
            }.store(in: &cell.cancellables)

        cell.deleteCellAction.receive(on: RunLoop.main)
            .sink { [weak self] in
                print(indexPath)
            self?.viewModel.deleteItem(at: indexPath.row)
            self?.tableView.deleteRows(at: [indexPath], with: .automatic)
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

//// MARK: - CartTVCellDelegate
//
//extension CartTableViewController: CartTVCellDelegate {
//
//    func countChanged(_ cell: UITableViewCell, count: Int) {
//        guard let indexPath = tableView.indexPath(for: cell) else {return}
//        viewModel.countChanged(indexOfItem: indexPath.row, count: count)
//    }
//
//    func deleteCell(_ cell: UITableViewCell) {
//        guard let indexPath = tableView.indexPath(for: cell) else {return}
//        viewModel.deleteItem(at: indexPath.row)
//        tableView.deleteRows(at: [indexPath], with: .automatic)
//    }
//}

