//
//  CellsReusingUtils.swift
//  SwiftTestsUIKit
//
//  Created by Глеб Хамин on 07.01.2025.
//

import UIKit

protocol ReuseIdentifying {
    static var defaultReuseIdentifier: String { get }
}

extension ReuseIdentifying where Self: UITableViewCell {
    static var defaultReuseIdentifier: String {
        NSStringFromClass(self).components(separatedBy: ".").last ?? NSStringFromClass(self)
    }
}

extension ReuseIdentifying where Self: UICollectionViewCell {
    static var defaultReuseIdentifier: String {
        NSStringFromClass(self).components(separatedBy: ".").last ?? NSStringFromClass(self)
    }
}

extension ReuseIdentifying where Self: UICollectionReusableView {
    static var defaultReuseIdentifier: String {
        NSStringFromClass(self).components(separatedBy: ".").last ?? NSStringFromClass(self)
    }
}

extension UITableView {
    func register<T: UITableViewCell>(_: T.Type) where T: ReuseIdentifying {
        register(T.self, forCellReuseIdentifier: T.defaultReuseIdentifier)
    }

    func dequeueReusableCell<T: UITableViewCell>() -> T where T: ReuseIdentifying {
        guard let cell = dequeueReusableCell(withIdentifier: T.defaultReuseIdentifier) as? T else {
            assertionFailure("Could not dequeue cell with identifier: \(T.defaultReuseIdentifier)")
            return T()
        }
        return cell
    }
}

extension UICollectionView {
    func register<T: UICollectionViewCell>(_: T.Type) where T: ReuseIdentifying {
        register(T.self, forCellWithReuseIdentifier: T.defaultReuseIdentifier)
    }

    func dequeueReusableCell<T: UICollectionViewCell>(indexPath: IndexPath) -> T where T: ReuseIdentifying {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.defaultReuseIdentifier, for: indexPath) as? T else {
            assertionFailure("Could not dequeue cell with identifier: \(T.defaultReuseIdentifier) for: \(indexPath)")
            return T()
        }
        return cell
    }
}

extension UICollectionView {
    func registerHeader<T: UICollectionReusableView>(_: T.Type) where T: ReuseIdentifying {
        register(T.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                 withReuseIdentifier: T.defaultReuseIdentifier)
    }

    func dequeueReusableHeader<T: UICollectionReusableView>(indexPath: IndexPath) -> T where T: ReuseIdentifying {
        guard let header = dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                            withReuseIdentifier: T.defaultReuseIdentifier,
                                                            for: indexPath) as? T else {
            assertionFailure("Could not dequeue header with identifier: \(T.defaultReuseIdentifier) for: \(indexPath)")
            return T()
        }
        return header
    }
}