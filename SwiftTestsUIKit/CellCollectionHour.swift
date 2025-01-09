//
//  CellCollectionHour.swift
//  SwiftTestsUIKit
//
//  Created by Глеб Хамин on 08.01.2025.
//

import UIKit

final class CellCollectionHour: UICollectionViewCell, ReuseIdentifying {

    var hour: Int = 0

    private lazy var separatirTop: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .tertiaryLabel
        view.layer.cornerRadius = 4
        view.layer.masksToBounds = true
        return view
    }()

    private lazy var separatirBottom: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .tertiaryLabel
        view.layer.cornerRadius = 4
        view.layer.masksToBounds = true
        return view
    }()

    private lazy var labelHour: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "\(hour):00"
        label.textColor = .label
        label.font = .systemFont(ofSize: 10)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .secondaryLabel
        
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configurationCell() {
        labelHour.text = "\(hour):00"
    }
}

// MARK: - Extension: View Layout

extension CellCollectionHour {
    func setupLayout() {
        contentView.addSubview(separatirTop)
        contentView.addSubview(separatirBottom)
        contentView.addSubview(labelHour)

        NSLayoutConstraint.activate([


            labelHour.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 13),
            labelHour.heightAnchor.constraint(equalToConstant: 10),
            labelHour.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            labelHour.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            separatirTop.topAnchor.constraint(equalTo: labelHour.bottomAnchor),
            separatirTop.heightAnchor.constraint(equalToConstant: 4),
            separatirTop.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            separatirTop.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),

            separatirBottom.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separatirBottom.heightAnchor.constraint(equalToConstant: 2),
            separatirBottom.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            separatirBottom.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
        ])
    }
}
