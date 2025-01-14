//
//  MoviesView.swift
//  SwiftTestsUIKit
//
//  Created by Глеб Хамин on 13.01.2025.
//

import UIKit

final class MoviesView: UIViewController {

    private var networkManager = NetworkManager.shared

    lazy private var textView: UITextView = {
        let text = UITextView()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.textAlignment = .left
        return text
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        getMovies()
        view.backgroundColor = .white
        view.addSubview(textView)

        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    func getMovies() {
        networkManager.fetchMovies { result in
            switch result {
            case .success(let movies):
                let strMovies = movies.map { $0.name }.joined(separator: "\n")
                DispatchQueue.main.async() {
                    self.textView.text = strMovies
                    self.textView.layoutIfNeeded()
                }
            case .failure(let networkError):
                print("failure \(networkError)")
            }
        }
    }
}
