//
//  CMCBottomDropDownSheet.swift
//  DesignSystem
//
//  Created by Siri on 11/10/23.
//  Copyright © 2023 com.softsquared.cmc. All rights reserved.
//

import RxCocoa
import RxGesture
import RxSwift

import SnapKit

import UIKit

public final class CMCBottomDropDownSheet: UIView{
	
	// MARK: - UI
	private lazy var mainTitle: UILabel = {
		let label = UILabel()
		label.font = DesignSystemFontFamily.Pretendard.bold.font(size: 18)
		label.textColor = DesignSystemAsset.gray50.color
		label.text = title
		label.numberOfLines = 0
		label.textAlignment = .center
		return label
	}()
	
	private lazy var tableView: UITableView = {
		let tableView = UITableView()
		tableView.register(DropDownCell.self, forCellReuseIdentifier: DropDownCell.identifier)
		tableView.backgroundColor = .clear
		tableView.separatorStyle = .none
		return tableView
	}()
	
	public lazy var cancelButton: CMCButton = {
		let button = CMCButton(
			isRound: false,
			iconTitle: nil,
			type: .login(.inactive),
			title: buttonTitle
		)
		return button
	}()
	
	// MARK: - Properties
	
	var disposeBag = DisposeBag()
	
	public var itemSelected = PublishRelay<String>()
	
	private var title: String
	private var dropDownDataSource: [String]
	private var buttonTitle: String
	
	//	public var dismiss = PublishRelay<Bool>()
	
	// MARK: - Initializers
	
	/// 버튼의 `title`, `body`, `cancelTitle`을 설정합니다.
	/// - Parameters:
	///   - title : DropDown의 메인 타이틀을 결정합니다.
	///   - dropDownDataSource : DropDown의 dataSource입니다.
	///   - buttonTitle : BottomSheet의 버튼의 타이틀을 결정합니다.
	public init(title: String, dropDownDataSource: [String], buttonTitle: String) {
		self.title = title
		self.dropDownDataSource = dropDownDataSource
		self.buttonTitle = buttonTitle
		super.init(frame: .zero)
		
		self.backgroundColor = DesignSystemAsset.gray900.color
		self.layer.cornerRadius = 10
		
		self.setAddSubView()
		self.setConstraint()
		self.setDelegate()
		//		self.bind()
		
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	// MARK: - LifeCycle
	
	// MARK: - Methods
	
	private func setAddSubView() {
		self.addSubview(mainTitle)
		self.addSubview(tableView)
		self.addSubview(cancelButton)
	}
	
	private func setConstraint() {
		
		mainTitle.snp.makeConstraints { make in
			make.top.equalToSuperview().offset(30)
			make.centerX.equalToSuperview()
		}
		
		cancelButton.snp.makeConstraints { make in
			make.height.equalTo(56)
			make.leading.equalToSuperview().offset(24)
			make.trailing.equalToSuperview().offset(-24)
			make.bottom.equalToSuperview().offset(-54)
		}
		
		tableView.snp.makeConstraints { make in
			make.top.equalTo(mainTitle.snp.bottom).offset(30)
			make.leading.equalToSuperview().offset(24)
			make.trailing.equalToSuperview().offset(-24)
			make.bottom.equalTo(cancelButton.snp.top).offset(-48)
		}
		
	}
	
	private func setDelegate() {
		self.tableView.dataSource = self
		self.tableView.delegate = self
	}
}

extension CMCBottomDropDownSheet: UITableViewDelegate, UITableViewDataSource {
	public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return dropDownDataSource.count
	}
	
	public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: DropDownCell.identifier, for: indexPath) as! DropDownCell
		cell.centerLabel.text = dropDownDataSource[indexPath.row]
		return cell
	}
	
	public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let selectedItem = dropDownDataSource[indexPath.row]
		itemSelected.accept(selectedItem)
	}
	
	public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 76
	}
	
}

public final class DropDownCell: UITableViewCell {
	
	public lazy var centerLabel: UILabel = {
		let label = UILabel()
		label.textAlignment = .center
		label.font = DesignSystemFontFamily.Pretendard.bold.font(size: 18)
		label.textColor = DesignSystemAsset.gray50.color
		return label
	}()
	
	public lazy var seperator: UIView = {
		let view = UIView()
		view.backgroundColor = DesignSystemAsset.gray800.color
		return view
	}()
	
	static let identifier = "DropDownCell"
	
	override init(
		style: UITableViewCell.CellStyle,
		reuseIdentifier: String?
	) {
		super.init(
			style: style,
			reuseIdentifier: reuseIdentifier
		)
		setupViews()
		
		let backgroundView = UIView()
		backgroundView.backgroundColor = DesignSystemAsset.gray900.color // 배경색 설정
		self.backgroundView = backgroundView
		
		let selectedBackgroundView = UIView()
		selectedBackgroundView.backgroundColor = DesignSystemAsset.gray900.color // 선택됐을 때의 배경색 설정
		self.selectedBackgroundView = selectedBackgroundView
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setupViews() {
		addSubview(centerLabel)
		centerLabel.snp.makeConstraints { make in
			make.edges.equalToSuperview()
		}
		
		addSubview(seperator)
		seperator.snp.makeConstraints { make in
			make.leading.trailing.equalToSuperview()
			make.bottom.equalToSuperview()
			make.height.equalTo(2)
		}
	}
	
	override public func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		
	}
	
	public override func setHighlighted(_ highlighted: Bool, animated: Bool) {
		super.setHighlighted(highlighted, animated: animated)
		
	}
}

/// 아래는 테스트 코드임
/*
 
 override func bind() {
 
	 signInButton.rx.tap
		 .flatMapLatest { _ -> Observable<String> in
			 let dropDownManager = CMCBottomDropDownSheetManager.shared
			 return dropDownManager.bottomDropDownSheetResponse(
				 title: "드랍다운 타이틀임",
				 dataSource: ["1","2","3","4","5","6"],
				 buttonTitle: "취소"
			 )
		 }
		 .bind(to: dropDownRelay)
		 .disposed(by: disposeBag)
	 
	 dropDownRelay
		 .withUnretained(self)
		 .subscribe(onNext: { owner, selectedTitle in
			 print("이 곳에서 드랍다운의 상태 처리: \(selectedTitle)")
			 owner.signInButton.setTitle(title: selectedTitle)
		 })
		 .disposed(by: disposeBag)
	 
 }
 
 private let dropDownRelay = PublishRelay<String>()
 */
