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
    private let currentWeekDay: WeekDay = .tuesday
    private var selectedWeekDay: WeekDay?
    private var isProgrammaticScroll = false
    private var isCompactView = false

    var itemWidth = CGFloat(UIScreen.main.bounds.width - 50)
    var itemSpacing = CGFloat(10)

    lazy private var weekDaySC = WeekDaySegmentedControl(
        weekDay: weekDay,
        currentWeekDay: currentWeekDay,
        didTapAllSegment: { [weak self] in
            self?.toggleCollectionWeek()
        },
        didTapSegment: { [weak self] day in
            self?.didTapSC(day: day)
        }
    )

    lazy private var buttonBackWeek: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        button.tintColor = .secondaryLabel
        button.setTitle("", for: .normal)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.secondaryLabel.cgColor
        button.addTarget(self, action: #selector(getBackWeek(_:)), for: .touchUpInside)
        return button
    }()

    lazy private var buttonNextWeek: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "chevron.forward"), for: .normal)
        button.tintColor = .secondaryLabel
        button.setTitle("", for: .normal)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.secondaryLabel.cgColor
        button.addTarget(self, action: #selector(getNextWeek(_:)), for: .touchUpInside)
        return button
    }()

    lazy var collectionWeek: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 25)
        let screenWidth = UIScreen.main.bounds.width
        let itemWidth = screenWidth - 50
        layout.itemSize = CGSize(width: itemWidth, height: 600)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(CellCollectionDay.self)
        collectionView.decelerationRate = UIScrollView.DecelerationRate.fast
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self

        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        collectionView.addGestureRecognizer(panGesture)

        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedWeekDay = currentWeekDay
        view.backgroundColor = .systemBackground

        view.addSubview(weekDaySC)
        view.addSubview(buttonBackWeek)
        view.addSubview(buttonNextWeek)
        view.addSubview(collectionWeek)

        NSLayoutConstraint.activate([
            buttonBackWeek.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            buttonBackWeek.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            buttonBackWeek.heightAnchor.constraint(equalToConstant: 30),
            buttonBackWeek.widthAnchor.constraint(equalToConstant: 20)
        ])

        NSLayoutConstraint.activate([
            buttonNextWeek.topAnchor.constraint(equalTo: buttonBackWeek.topAnchor),
            buttonNextWeek.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            buttonNextWeek.bottomAnchor.constraint(equalTo: buttonBackWeek.bottomAnchor),
            buttonNextWeek.widthAnchor.constraint(equalToConstant: 20)
        ])

        NSLayoutConstraint.activate([
            weekDaySC.topAnchor.constraint(equalTo: buttonBackWeek.topAnchor),
            weekDaySC.bottomAnchor.constraint(equalTo: buttonBackWeek.bottomAnchor),
            weekDaySC.trailingAnchor.constraint(equalTo: buttonNextWeek.leadingAnchor, constant: -4),
            weekDaySC.leadingAnchor.constraint(equalTo: buttonBackWeek.trailingAnchor, constant: 4),
        ])

        NSLayoutConstraint.activate([
            collectionWeek.topAnchor.constraint(equalTo: weekDaySC.bottomAnchor, constant: 10),
            collectionWeek.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionWeek.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionWeek.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        didTapSC(day: currentWeekDay)
    }

    func didTapSC(day: WeekDay) {
        guard let index = weekDay.firstIndex(of: day) else { return }
        isProgrammaticScroll = true
        let indexPath = IndexPath(item: index, section: 0)

        collectionWeek.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }

    func toggleCollectionWeek() {
        isCompactView.toggle()
        updateCollectionWeek()
        collectionWeek.reloadData()
    }

    private func updateCollectionWeek() {
        let layout = UICollectionViewFlowLayout()
        let screenWidth = UIScreen.main.bounds.width
        layout.scrollDirection = .horizontal

        if isCompactView {
            layout.minimumLineSpacing = 5
            let itemWidth = (screenWidth - 50 - CGFloat((weekDay.count - 1) * 5)) / CGFloat(weekDay.count)
            layout.itemSize = CGSize(width: itemWidth, height: 600)

            collectionWeek.isScrollEnabled = false
        } else {
            layout.minimumLineSpacing = 15
            let itemWidth = screenWidth - 50
            layout.itemSize = CGSize(width: itemWidth, height: 600)

            collectionWeek.isScrollEnabled = true
        }

        layout.sectionInset = UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 25)

        collectionWeek.setCollectionViewLayout(layout, animated: true)
    }

    @objc private func getBackWeek(_ sender: UIButton) {
        print("BackWeek")
    }

    @objc private func getNextWeek(_ sender: UIButton) {
        print("NextWeek")
    }





    @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        guard gesture.state == .ended else { return }

        let velocity = gesture.velocity(in: collectionWeek)

        if abs(velocity.x) > 500 {

            let currentIndex = Int(collectionWeek.contentOffset.x / (itemWidth + itemSpacing))

            if velocity.x < 0 {
                if currentIndex < weekDay.count - 1 {
                    let nextIndex = currentIndex + 1
                    let offsetX = CGFloat(nextIndex) * (itemWidth + itemSpacing)
                    collectionWeek.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)

                    selectedWeekDay = weekDay[nextIndex]
                    print("вперед \(selectedWeekDay!)")
                }
            } else {
                if currentIndex > 0 {
                    let prevIndex = currentIndex - 1
                    let offsetX = CGFloat(prevIndex) * (itemWidth + itemSpacing)
                    collectionWeek.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)

                    selectedWeekDay = weekDay[prevIndex]
                    print("назад \(selectedWeekDay!)")
                }
            }
            if let selectedWeekDay { weekDaySC.getSelectedDay(selectedWeekDay) }
        }

    }
}

extension TestVC: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        weekDay.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CellCollectionDay = collectionView.dequeueReusableCell(indexPath: indexPath)
        cell.custom(text: String(indexPath[1]))
        return cell
    }
    

}

extension TestVC: UICollectionViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isProgrammaticScroll = false
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard !isProgrammaticScroll else { return }
        let centerX = scrollView.contentOffset.x + scrollView.bounds.size.width / 2

        let visibleCells = collectionWeek.visibleCells
        var closestCell: UICollectionViewCell?
        var closestDistance = CGFloat.greatestFiniteMagnitude

        for cell in visibleCells {
            let cellCenterX = cell.frame.origin.x + cell.frame.size.width / 2
            let distance = abs(centerX - cellCenterX)

            if distance < closestDistance {
                closestDistance = distance
                closestCell = cell
            }
        }

        if let closestCell = closestCell {
            if let indexPath = collectionWeek.indexPath(for: closestCell) {
                if selectedWeekDay != weekDay[indexPath[1]] {
                    selectedWeekDay = weekDay[indexPath[1]]
                    if let selectedWeekDay { weekDaySC.getSelectedDay(selectedWeekDay) }
                }
            }
        }
    }
}
