//
//  CellCollectionDay.swift
//  SwiftTestsUIKit
//
//  Created by Глеб Хамин on 07.01.2025.
//

import UIKit

final class CellCollectionDay: UICollectionViewCell, ReuseIdentifying {

    private var startTime: Int = 9
    private var endTime: Int = 20

    lazy private var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var collectionHour: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        let screenWidth = UIScreen.main.bounds.width
        let itemWidth = screenWidth - 50
        layout.itemSize = CGSize(width: itemWidth, height: 50)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(CellCollectionHour.self)
        collectionView.decelerationRate = UIScrollView.DecelerationRate.fast
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self

        return collectionView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .quaternaryLabel
        layer.cornerRadius = 10
        layer.masksToBounds = true
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func custom(text: String) {
        label.text = text
    }


}

// MARK: - Extension: View Layout

extension CellCollectionDay {

    private func setupLayout() {
//        contentView.addSubview(collectionHour)
//
//        NSLayoutConstraint.activate([
//            collectionHour.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            collectionHour.topAnchor.constraint(equalTo: contentView.topAnchor),
//            collectionHour.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//            collectionHour.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
//        ])
        contentView.addSubview(label)

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }


}

extension CellCollectionDay: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CellCollectionHour = collectionView.dequeueReusableCell(indexPath: indexPath)
        cell.hour = startTime + indexPath[1]
        cell.configurationCell()
        return cell
    }
    

}

extension CellCollectionDay: UICollectionViewDelegate {

}
