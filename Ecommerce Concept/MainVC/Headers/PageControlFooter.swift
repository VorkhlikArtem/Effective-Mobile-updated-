//
//  PageControlFooter.swift
//  EcommerceConcept
//
//  Created by Артём on 14.12.2022.
//

import UIKit

class PageControlFooter: UICollectionReusableView {
    static let reuseId = "PageControlFooter"
    
    private lazy var pagesStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = circlesDiameter
        return stack
    }()
    
    private lazy var currentPageView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .orangeColor
        return view
    }()
    
    var circlesDiameter: CGFloat = 12
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }
    
    func configure(numberOfPages: Int) {
        pagesStack.arrangedSubviews.forEach{ pagesStack.removeArrangedSubview($0) }
        
        for _ in 1...numberOfPages {
            let pageCircle = UIView()
            pageCircle.backgroundColor = .grayTextColor
            pageCircle.translatesAutoresizingMaskIntoConstraints = false
            pageCircle.heightAnchor.constraint(equalTo: pageCircle.widthAnchor).isActive = true
            pageCircle.layer.cornerRadius = circlesDiameter/2
            pagesStack.addArrangedSubview(pageCircle)
        }
        
        guard let firstPageView = pagesStack.arrangedSubviews.first else {return}

        pagesStack.addSubview(currentPageView)
        NSLayoutConstraint.activate([
            currentPageView.leadingAnchor.constraint(equalTo: firstPageView.leadingAnchor),
            currentPageView.trailingAnchor.constraint(equalTo: firstPageView.trailingAnchor),
            currentPageView.topAnchor.constraint(equalTo: firstPageView.topAnchor),
            currentPageView.bottomAnchor.constraint(equalTo: firstPageView.bottomAnchor)
        ])
    
        currentPageView.layer.cornerRadius = circlesDiameter/2
        
    }

    func changeCurrentPage(to page: CGFloat) {
        guard let firstPage = pagesStack.arrangedSubviews.first else {return}
        let distance = firstPage.frame.width + pagesStack.spacing
        let currentPosition = distance * page
        currentPageView.transform = CGAffineTransform(translationX: currentPosition, y: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    
    func setupConstraints() {
        pagesStack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(pagesStack)
        NSLayoutConstraint.activate([
            pagesStack.centerXAnchor.constraint(equalTo: centerXAnchor),
            pagesStack.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            pagesStack.bottomAnchor.constraint(equalTo: bottomAnchor),
            pagesStack.heightAnchor.constraint(equalToConstant: circlesDiameter)
        ])
    }
}
