//
//  RecordFinishedReadingBookView.swift
//  Book2OnNoN
//
//  Created by 여성일 on 3/20/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Cosmos

class RecordFinishedReadingBookView: UIScrollView {
    
    private let disposeBag = DisposeBag()
    private let viewModel: SearchRecordViewModelType
    
    private let contentView: UIView = {
        let view = UIView()
        return view
    }()
    
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
    
    private let finishReadingBookLabel: UILabel = {
        let label = UILabel()
        label.text = "다 읽은 날"
        label.textColor = .white
        label.font = .Pretendard.semibold
        return label
    }()
    
    private lazy var finishReadingBookDateTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .PrestigeBlue
        textField.layer.cornerRadius = 5
        textField.textColor = .white
        textField.tintColor = .clear
        textField.font = .Pretendard.regular
        textField.inputView = finishReadingBookDatePicker
        textField.addLeftViewImage(systemName: "calendar")
        return textField
    }()
    
    private let finishReadingBookDatePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.locale = Locale(identifier:  "ko-KR")
        picker.preferredDatePickerStyle = .wheels
        picker.date = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
        return picker
    }()
    
    private let bookAssessmentLabel: UILabel = {
        let label = UILabel()
        label.text = "나만의 한줄 서평"
        label.textColor = .white
        label.font = .Pretendard.semibold
        return label
    }()
    
    private lazy var bookAssessmentTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .PrestigeBlue
        textField.textColor = .white
        textField.font = .Pretendard.regular
        textField.layer.cornerRadius = 5
        textField.addLeftViewImage(systemName: "square.and.pencil")
        return textField
    }()
    
    private let bookRatingView: CosmosView = {
        let view = CosmosView()
        view.settings.fillMode = .half
        view.settings.filledImage = UIImage(named: "ratingFilledStar")
        view.settings.emptyImage = UIImage(named: "ratingEmptyStar")
        view.settings.starSize = 30
        view.settings.starMargin = 5
        view.text = "2.5점 / 5점"
        view.settings.textColor = .white
        return view
    }()
    
    private let recordSaveButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .PrestigeBlue
        button.setTitle("기록하기", for: .normal)
        button.layer.cornerRadius = 10.0
        return button
    }()
    
    private lazy var accessoryLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 40))
        label.backgroundColor = .PrestigeBlue
        label.font = .Pretendard.medium
        label.textColor = .white
        return label
    }()
    
    // MARK: init

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
    
    // MARK: Set View
    private func setView() {
        addSubview(contentView)
        [startReadingBookLabel, startReadingBookDateTextField, finishReadingBookLabel, finishReadingBookDateTextField, bookAssessmentLabel, bookAssessmentTextField, bookRatingView, recordSaveButton].forEach {
            contentView.addSubview($0)
        }
        
        alwaysBounceVertical = true
        showsVerticalScrollIndicator = false
    }
    
    private func setConfiguration() {
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalToSuperview().offset(75)
        }
        
        startReadingBookLabel.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.top)
            $0.leading.equalTo(contentView.snp.leading)
        }
        
        startReadingBookDateTextField.snp.makeConstraints {
            $0.top.equalTo(startReadingBookLabel.snp.bottom).offset(5)
            $0.horizontalEdges.equalTo(contentView.snp.horizontalEdges)
            $0.height.equalTo(30)
        }
        
        finishReadingBookLabel.snp.makeConstraints {
            $0.top.equalTo(startReadingBookDateTextField.snp.bottom).offset(5)
            $0.leading.equalTo(contentView.snp.leading)
        }
        
        finishReadingBookDateTextField.snp.makeConstraints {
            $0.top.equalTo(finishReadingBookLabel.snp.bottom).offset(5)
            $0.horizontalEdges.equalTo(contentView.snp.horizontalEdges)
            $0.height.equalTo(30)
        }
        
        bookAssessmentLabel.snp.makeConstraints {
            $0.top.equalTo(finishReadingBookDateTextField.snp.bottom).offset(20)
            $0.leading.equalTo(contentView.snp.leading)
        }
        
        bookAssessmentTextField.snp.makeConstraints {
            $0.top.equalTo(bookAssessmentLabel.snp.bottom).offset(5)
            $0.horizontalEdges.equalTo(contentView.snp.horizontalEdges)
            $0.height.equalTo(30)
        }
        
        bookRatingView.snp.makeConstraints {
            $0.top.equalTo(bookAssessmentTextField.snp.bottom).offset(15)
            $0.centerX.equalTo(contentView.snp.centerX)
        }        
        
        recordSaveButton.snp.makeConstraints {
            $0.top.equalTo(bookRatingView.snp.bottom).offset(30)
            $0.height.equalTo(40)
            $0.horizontalEdges.equalTo(contentView.snp.horizontalEdges).inset(50)
        }
    }
    
    private func bind() {
        // View Logic
        bookRatingView.rx.didTouchCosmos
            .onNext { rating in
                self.bookRatingView.text = "\(rating)점 / 5.0점"
            }
        
        bookAssessmentTextField.rx.controlEvent(.editingDidBegin)
            .subscribe(onNext: { [weak self] _ in
                self?.bookAssessmentTextField.inputAccessoryView = self?.accessoryLabel
            })
            .disposed(by: disposeBag)
        
        bookAssessmentTextField.rx.text.orEmpty
            .map { $0.count <= 25 }
            .subscribe(onNext: { [weak self ] isEditable in
                if !isEditable {
                    self?.bookAssessmentTextField.text = String(self?.bookAssessmentTextField.text?.dropLast() ?? "")
                }
            })
            .disposed(by: disposeBag)
        
        startReadingBookDatePicker.rx.date
            .map { [weak self] in
                self?.dateFormatter.string(from: $0)
            }
            .bind(to: startReadingBookDateTextField.rx.text)
            .disposed(by: disposeBag)
        
        finishReadingBookDatePicker.rx.date
            .map { [weak self] in
                self?.dateFormatter.string(from: $0)
            }
            .bind(to: finishReadingBookDateTextField.rx.text)
            .disposed(by: disposeBag)
        
        bookAssessmentTextField.rx.text.orEmpty
            .bind(to: accessoryLabel.rx.text)
            .disposed(by: disposeBag)
        
        // Input
        recordSaveButton.rx.tap
            .map { SaveButtonType.FinishedReadingBooksSaveButton }
            .bind(to: viewModel.didSaveButtonTapped)
            .disposed(by: disposeBag)
        
        startReadingBookDateTextField.rx.text.orEmpty
            .bind(to: viewModel.didFinishedStartReadingBookDateValue)
            .disposed(by: disposeBag)
        
        finishReadingBookDateTextField.rx.text.orEmpty
            .bind(to: viewModel.didFinishedReadingBookDateValue)
            .disposed(by: disposeBag)
        
        bookAssessmentTextField.rx.text.orEmpty
            .bind(to: viewModel.didFinishedReadingAssessmentTextValue)
            .disposed(by: disposeBag)
        
        bookRatingView.rx.didFinishTouchingCosmos
            .onNext { rating in
                self.viewModel.didFinishedReadingBookRatingValue.onNext(rating)
            }
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
