//
//  RecordReadingBookView.swift
//  Book2OnNoN
//
//  Created by 여성일 on 3/20/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class RecordReadingBookView: UIView {
    
    private let disposeBag = DisposeBag()
    private let viewModel: SearchRecordViewModelType
    
    // MARK: UIComponents
    private let startReadingBookLabel: UILabel = {
        let label = UILabel()
        label.text = "읽기 시작한 날"
        label.textColor = .white
        label.font = .Pretendard.semibold
        return label
    }()
    
    private lazy var startReadingBookDateTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .PrestigeBlue
        textField.textColor = .white
        textField.tintColor = .clear
        textField.font = .Pretendard.regular
        textField.layer.cornerRadius = 5
        textField.inputView = startReadingBookDatePicker
        textField.addLeftViewImage(systemName: "calendar")
        return textField
    }()
    
    private let startReadingBookDatePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.locale = Locale(identifier:  "ko-KR")
        picker.preferredDatePickerStyle = .wheels
        return picker
    }()
    
    private let amountOfReadingBookLabel: UILabel = {
        let label = UILabel()
        label.text = "독서량"
        label.textColor = .white
        label.font = .Pretendard.semibold
        return label
    }()
    
    private lazy var amountOfReadingBookTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .PrestigeBlue
        textField.textColor = .white
        textField.tintColor = .clear
        textField.font = .Pretendard.regular
        textField.layer.cornerRadius = 5
        textField.inputView = amountOfReadingBookPicker
        textField.addLeftViewImage(systemName: "book")
        return textField
    }()
    
    private let amountOfReadingBookPicker: UIPickerView = {
        let picker = UIPickerView()
        return picker
    }()
    
    private let recordSaveButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .PrestigeBlue
        button.setTitle("기록하기", for: .normal)
        button.layer.cornerRadius = 10.0
        return button
    }()
    
    init(viewModel: SearchRecordViewModelType) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setView()
        setConfiguration()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setView() {
        [startReadingBookLabel, startReadingBookDateTextField, amountOfReadingBookLabel, amountOfReadingBookTextField, recordSaveButton].forEach {
            addSubview($0)
        }
    }
    
    private func setConfiguration() {
        startReadingBookLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.leading.equalTo(safeAreaLayoutGuide)
        }
        
        startReadingBookDateTextField.snp.makeConstraints {
            $0.top.equalTo(startReadingBookLabel.snp.bottom).offset(5)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide)
            $0.height.equalTo(30)
        }
        
        amountOfReadingBookLabel.snp.makeConstraints {
            $0.top.equalTo(startReadingBookDateTextField.snp.bottom).offset(20)
            $0.leading.equalTo(safeAreaLayoutGuide)
        }
        
        amountOfReadingBookTextField.snp.makeConstraints {
            $0.top.equalTo(amountOfReadingBookLabel.snp.bottom).offset(5)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide)
            $0.height.equalTo(30)
        }
        
        recordSaveButton.snp.makeConstraints {
            $0.top.equalTo(amountOfReadingBookTextField.snp.bottom).offset(30)
            $0.height.equalTo(40)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(50)
        }
    }
    
    private func bind() {
        startReadingBookDatePicker.rx.date
            .map { [weak self] in
                self?.dateFormatter.string(from: $0)
            }
            .bind(to: startReadingBookDateTextField.rx.text)
            .disposed(by: disposeBag)
        
        amountOfReadingBookPicker.rx.itemSelected
            .subscribe(onNext: { index  in
                self.amountOfReadingBookTextField.text = "\(index.row + 1) 쪽"
            }).disposed(by: disposeBag)
        
        // input
        recordSaveButton.rx.tap
            .map { SaveButtonType.ReadingBooksSaveButton }
            .bind(to: viewModel.didSaveButtonTapped)
            .disposed(by: disposeBag)
        
        startReadingBookDateTextField.rx.text.orEmpty
            .bind(to: viewModel.didReadingStartReadingBookDateValue)
            .disposed(by: disposeBag)
        
        amountOfReadingBookTextField.rx.text.orEmpty
            .map{ $0.extractDigitsToInt() }
            .compactMap { $0 }
            .bind(to: viewModel.didReadingAmountOfReadingBookValue)
            .disposed(by: disposeBag)
        
        // output
        viewModel.resultLookUpItem
            .drive(onNext: { item in
                Observable.just(Array(1...item[0].subInfo.itemPage))
                    .bind(to: self.amountOfReadingBookPicker.rx.itemTitles) { _ , item in
                        return "\(item)"
                    }.disposed(by: self.disposeBag)
            }).disposed(by: disposeBag)
    }
    
    // MARK: Method
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter
    }()
    
}

