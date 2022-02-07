//
//  AuthBirthView.swift
//  SeSACFriends
//
//  Created by Ahyeonway on 2022/01/23.
//

import UIKit

final class AuthBirthView: AuthCommonView {
    var birthDate: Date = Date() {
        didSet {
            yearTextField.text = birthDate.yearName
            monthTextField.text = birthDate.monthName
            dayTextField.text = birthDate.dayName
        }
    }
    let yearTextField: SeSACTextField = {
        let tf = SeSACTextField()
        tf.text = Date().yearName
        tf.isUserInteractionEnabled = false
        return tf
    }()
    let yearLabel: UILabel = {
        let lb = UILabel()
        lb.font = FontTheme.Title2_R16
        lb.textColor = ColorTheme.black
        lb.text = "년"
        return lb
    }()
    let yearView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 4
        view.distribution = .fill
        return view
    }()
    
    let monthTextField: SeSACTextField = {
        let tf = SeSACTextField()
        tf.text = Date().monthName
        tf.isUserInteractionEnabled = false
        return tf
    }()
    let monthLabel: UILabel = {
        let lb = UILabel()
        lb.font = FontTheme.Title2_R16
        lb.textColor = ColorTheme.black
        lb.text = "월"
        return lb
    }()
    let monthView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 4
        view.distribution = .fill
        return view
    }()
    let dayTextField: SeSACTextField = {
        let tf = SeSACTextField()
        tf.text = Date().dayName
        tf.isUserInteractionEnabled = false
        return tf
    }()
    let dayLabel: UILabel = {
        let lb = UILabel()
        lb.font = FontTheme.Title2_R16
        lb.textColor = ColorTheme.black
        lb.text = "일"
        return lb
    }()
    let dayView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 4
        view.distribution = .fill
        return view
    }()

    let dateButton = UIButton()
    
    lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.backgroundColor = .systemGray6
        picker.locale = Locale(identifier: "ko-KR")
        return picker
    }()
    override func setUpViews() {
        super.setUpViews()
        inputFieldView.addSubview(yearView)
        inputFieldView.addSubview(monthView)
        inputFieldView.addSubview(dayView)
        
        inputFieldView.addSubview(dateButton)
        
        yearView.addArrangedSubview(yearTextField)
        yearView.addArrangedSubview(yearLabel)
        
        monthView.addArrangedSubview(monthTextField)
        monthView.addArrangedSubview(monthLabel)
        
        dayView.addArrangedSubview(dayTextField)
        dayView.addArrangedSubview(dayLabel)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        yearView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
        }
        monthView.snp.makeConstraints {
            $0.leading.equalTo(yearView.snp.trailing).offset(23)
            $0.width.equalTo(yearView.snp.width)
            $0.centerY.equalToSuperview()
        }
        dayView.snp.makeConstraints {
            $0.leading.equalTo(monthView.snp.trailing).offset(23)
            $0.width.equalTo(yearView.snp.width)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-16)
        }
        dateButton.snp.makeConstraints {
            $0.top.bottom.leading.equalTo(yearView)
            $0.trailing.equalTo(dayView)
        }
        dateButton.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
    }
    
    @objc func buttonClicked() {
        addSubview(datePicker)
        datePicker.snp.makeConstraints {
            $0.leading.bottom.trailing.equalToSuperview()
            $0.height.equalTo(200)
        }
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
    }
    
    @objc func dateChanged(_ sender: UIDatePicker) {
        birthDate = sender.date
    }
}
