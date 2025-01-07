//
//  TestVC.swift
//  SwiftTestsUIKit
//
//  Created by Глеб Хамин on 28.12.2024.
//

import UIKit

enum WeekDay: String {
    case monday = "Пн"
    case tuesday = "Вт"
    case wednesday = "Ср"
    case thursday = "Чт"
    case friday = "Пт"
    case saturday = "Сб"
    case sunday = "Вс"
}

class TestVC: UIViewController {

    private let weekDay: [WeekDay] = [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]

    private let currentWeekDay: WeekDay = .wednesday

    lazy private var weekDaySC = WeekDaySegmentedControl(weekDay: weekDay, currentWeekDay: currentWeekDay)

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        self.view.addSubview(weekDaySC)

        NSLayoutConstraint.activate([
            weekDaySC.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            weekDaySC.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            weekDaySC.heightAnchor.constraint(equalToConstant: 40),
            weekDaySC.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
        ])
    }

//    @objc func segmentChanged(segmentedControl: UISegmentedControl) {
//        let selectedIndex = segmentedControl.selectedSegmentIndex
//        print("Выбран день недели: \(weekDay[selectedIndex].rawValue)")
//    }
}


