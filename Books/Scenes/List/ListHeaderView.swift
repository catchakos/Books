//
//  ListHeaderView.swift
//  Books
//
//  Created by Alexis Katsaprakakis on 29/10/22.
//

import UIKit

class ListHeaderView: UIView {

    lazy var dateField: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.date = Date()
        picker.maximumDate = Date()
        return picker
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.backgroundColor = .clear
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .right
        label.text = NSLocalizedString("Select date", comment: "")
        return label
    }()

    
    lazy var stack = UIStackView.horizontal(
        with: [
            label,
            dateField
        ],
        alignment: .center
    )
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        commonInit()
    }
    
    private func commonInit() {
        setup()
        setupConstraints()
    }
    
    private func setup() {
        backgroundColor = .lightGray.withAlphaComponent(0.2)
        addSubview(stack)
    }
    
    private func setupConstraints() {
        stack.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
    }

}
