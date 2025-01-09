//
//  WeekDaySegmentedControl.swift
//  SwiftTestsUIKit
//
//  Created by Глеб Хамин on 06.01.2025.
//

import UIKit

final class WeekDaySegmentedControl: UIView {

    private var weekDay: [WeekDay]
    private var currentWeekDay: WeekDay
    private var selectedWeekDay: WeekDay {
        didSet {
            setSelectedIndex()
        }
    }
    private var buttonPadding: CGFloat = 0
    private var isFullWeekSelected: Bool = false
    private var isFirstLaunch: Bool = true
    private var didTapSegment: ((WeekDay) -> ())
    private var didTapAllSegment: (() -> ())

    lazy private var currentIndexView: UIView = UIView(frame: .zero)

    lazy private var stackWeekDay: UIStackView = {
        let stack = UIStackView()
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.axis = .horizontal

        return stack
    }()

    private var activeView: UIView?

    init(weekDay: [WeekDay], currentWeekDay: WeekDay, didTapAllSegment: @escaping (() -> ()), didTapSegment: @escaping ((WeekDay) -> ())) {
        self.weekDay = weekDay
        self.currentWeekDay = currentWeekDay
        self.selectedWeekDay = currentWeekDay
        self.didTapSegment = didTapSegment
        self.didTapAllSegment = didTapAllSegment
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false

        commonInit()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if isFirstLaunch {
            setCurrentIndex()
            isFirstLaunch = false
        }
    }

    func getSelectedDay(_ day: WeekDay) {
        selectedWeekDay = day
    }

    private func commonInit() {
        backgroundColor = .none

        setupStackView()
        addSegments()
        setCurrentIndexView()

        setCornerRadius()
        setButtonCornerRadius()
        setBorderColor()
        setBorderWidth()
    }

    private func setupStackView() {
        addSubview(stackWeekDay)

        stackWeekDay.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
                stackWeekDay.leadingAnchor.constraint(equalTo: leadingAnchor, constant: buttonPadding),
                stackWeekDay.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -buttonPadding),
                stackWeekDay.topAnchor.constraint(equalTo: topAnchor, constant: buttonPadding),
                stackWeekDay.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -buttonPadding)
            ]
        )
    }

    private func addSegments() {

        let titles = weekDay.map { $0.rawValue }

        for index in weekDay.indices {
            let button = UIButton()
            button.tag = index

            if let index = titles.indices.contains(index) ? index : nil {
                button.setTitle(titles[index], for: .normal)
            }

            button.titleLabel?.font = .systemFont(ofSize: 14)
            button.titleLabel?.numberOfLines = 2
            button.setTitleColor(.label, for: .normal)
            button.addTarget(self, action: #selector(segmentTapped(_:)), for: .touchUpInside)

            stackWeekDay.addArrangedSubview(button)
        }
    }

    private func setCurrentIndexView() {
        setCurrentViewBackgroundColor()

        addSubview(currentIndexView)
        sendSubviewToBack(currentIndexView)
    }

    private func setCurrentViewBackgroundColor() {
        currentIndexView.backgroundColor = .lightGray
    }

    private func setCurrentIndex() {
        stackWeekDay.subviews.enumerated().forEach { (index, view) in
            let button: UIButton? = view as? UIButton

            if index == weekDay.firstIndex(of: currentWeekDay) {
                let buttonWidth = (frame.width - (buttonPadding * 2)) / CGFloat(weekDay.count)

                self.currentIndexView.frame =
                CGRect(x: self.buttonPadding + (buttonWidth * CGFloat(index)),
                       y: self.buttonPadding,
                       width: buttonWidth,
                       height: self.frame.height - (self.buttonPadding * 2))

                button?.setTitleColor(.red, for: .normal)
            }
        }
    }

    private func setSelectedIndex(animated: Bool = true) {
        stackWeekDay.subviews.enumerated().forEach { (index, view) in
//            let button: UIButton? = view as? UIButton

            if index == weekDay.firstIndex(of: selectedWeekDay) {
                let buttonWidth = (frame.width - (buttonPadding * 2)) / CGFloat(weekDay.count)

                if animated {
                    UIView.animate(withDuration: 0.3) {
                        self.currentIndexView.frame =
                        CGRect(x: self.buttonPadding + (buttonWidth * CGFloat(index)),
                               y: self.buttonPadding,
                               width: buttonWidth,
                               height: self.frame.height - (self.buttonPadding * 2))
                    }
                } else {
                    self.currentIndexView.frame =
                    CGRect(x: self.buttonPadding + (buttonWidth * CGFloat(index)),
                           y: self.buttonPadding,
                           width: buttonWidth,
                           height: self.frame.height - (self.buttonPadding * 2))
                }

//                button?.setTitleColor(.red, for: .normal)
            } else {
//                button?.setTitleColor(.black, for: .normal)
            }
        }
    }

    private func setSelectedAll() {
//        guard let containerView = self.superview else { return }
        UIView.animate(withDuration: 0.3) {
            self.currentIndexView.frame =
            CGRect(x: self.buttonPadding,
                   y: self.buttonPadding,
                   width: self.stackWeekDay.frame.width,
                   height: self.stackWeekDay.frame.height)
        }
    }

    private func setCornerRadius() {
        layer.cornerRadius = 10
    }

    private func setButtonCornerRadius() {
//        stackWeekDay.subviews.forEach { view in
//            (view as? UIButton)?.layer.cornerRadius = 10
//        }

        currentIndexView.layer.cornerRadius = 8
    }

    private func setBorderColor() {
//        layer.borderColor = CGColor(gray: 10, alpha: 10)
        layer.borderColor = UIColor.secondaryLabel.cgColor
    }

    private func setBorderWidth() {
        layer.borderWidth = 1
    }

    //MARK: - IBActions
    @objc func segmentTapped(_ sender: UIButton) {
        if selectedWeekDay == weekDay[sender.tag],
           !isFullWeekSelected {
            setSelectedAll()
            isFullWeekSelected = true
            didTapAllSegment()
            print("Week All")
        } else {
            selectedWeekDay = weekDay[sender.tag]
            if isFullWeekSelected {
                didTapAllSegment()
            }
            didTapSegment(selectedWeekDay)
            isFullWeekSelected = false
            print(selectedWeekDay.rawValue)
        }
    }
}
