//
//  MyPageViewController.swift
//  CMC
//
//  Created by Siri on 12/6/23.
//  Copyright © 2023 com.softsquared.cmc. All rights reserved.
//

import SafariServices
import Foundation

import RxCocoa
import RxSwift

import DesignSystem
import SnapKit

import UIKit

class MyPageViewController: BaseViewController {
	
	// MARK: - UI
	private lazy var navigationBar: CMCNavigationBar = {
		let navigationBar = CMCNavigationBar(
			accessoryLabelHidden: false
		)
		navigationBar.accessoryLabel.text = ""
		navigationBar.translatesAutoresizingMaskIntoConstraints = false
		return navigationBar
	}()
	
	private lazy var navigationLabel: UILabel = {
		let label = UILabel()
		label.text = "설정"
		label.font = CMCFontFamily.Pretendard.bold.font(size: 18)
		label.textColor = CMCAsset.gray50.color
		return label
	}()
	
	private lazy var MyPageCells: [UIView] = {
		let views: [UIView] = [
			UIView(),
			UIView(),
			UIView(),
			UIView(),
			UIView()
		]
		views.forEach{ $0.backgroundColor = .clear }
		return views
	}()
	
	private lazy var buttonLabels: [UILabel] = {
		var labels: [UILabel] = []
		let texts = [
			"내정보",
			"동아리 회칙",
			"개인정보처리방침",
			"비밀번호 변경",
			"로그아웃"
		]
		texts.enumerated().forEach { index, text in
			let label = UILabel()
			label.font = CMCFontFamily.Pretendard.medium.font(size: 17)
			label.textColor = CMCAsset.gray50.color
			label.text = text
			labels.append(label)
		}
		return labels
	}()
	
	private lazy var accessoryDetailButtons : [CMCTouchArea] = {
		let image = CMCAsset._24x24arrowRight.image
		let buttons = [
			CMCTouchArea(image: image),
			CMCTouchArea(image: image),
			CMCTouchArea(image: image),
			CMCTouchArea(image: image),
			CMCTouchArea(image: image)
		]
		return buttons
	}()
	
	private lazy var separeteBars: [UIView] = {
		let views: [UIView] = [
			UIView(),
			UIView(),
			UIView(),
			UIView(),
			UIView()
		]
		views.forEach{ $0.backgroundColor = DesignSystemAsset.gray800.color }
		return views
	}()
	
	private lazy var authOutLabel: UILabel = {
		let label = UILabel()
		let text = "회원탈퇴"
		let attributedString = NSMutableAttributedString(string: text)
		let underLineAttributes: [NSAttributedString.Key: Any] = [
			.underlineStyle: NSUnderlineStyle.single.rawValue,
			.baselineOffset : NSNumber(value: 4)
		]
		attributedString.addAttributes(underLineAttributes, range: NSRange(location: 0, length: text.count))
		label.attributedText = attributedString
		label.font = CMCFontFamily.Pretendard.bold.font(size: 13)
		label.textColor = CMCAsset.gray700.color
		return label
	}()
	
	// MARK: - Properties
	private let viewModel: MyPageViewModel
	
	// MARK: - Initializers
	init(
		viewModel: MyPageViewModel
	) {
		self.viewModel = viewModel
		super.init()
	}
	
	// MARK: - Methods
	override func setAddSubView() {
		view.addSubview(navigationBar)
		navigationBar.addSubview(navigationLabel)
		MyPageCells.forEach{ view.addSubview($0) }
		MyPageCells.enumerated().forEach { idx, cell in
			cell.addSubview(buttonLabels[idx])
			cell.addSubview(accessoryDetailButtons[idx])
			cell.addSubview(separeteBars[idx])
		}
		view.addSubview(authOutLabel)
	}
	
	override func setConstraint() {
		navigationBar.snp.makeConstraints{ navigationBar in
			navigationBar.top.equalTo(self.view.safeAreaLayoutGuide)
			navigationBar.leading.trailing.equalToSuperview()
			navigationBar.height.equalTo(68)
		}
		
		navigationLabel.snp.makeConstraints { navigationLabel in
			navigationLabel.centerX.centerY.equalToSuperview()
		}
		
		MyPageCells[0].snp.makeConstraints{ cell in
			cell.top.equalTo(navigationBar.snp.bottom)
			cell.leading.trailing.equalToSuperview()
			cell.height.equalTo(85)
		}
		
		MyPageCells[1].snp.makeConstraints{ cell in
			cell.top.equalTo(MyPageCells[0].snp.bottom)
			cell.leading.trailing.equalToSuperview()
			cell.height.equalTo(85)
		}
		
		MyPageCells[2].snp.makeConstraints{ cell in
			cell.top.equalTo(MyPageCells[1].snp.bottom)
			cell.leading.trailing.equalToSuperview()
			cell.height.equalTo(85)
		}
		
		MyPageCells[3].snp.makeConstraints{ cell in
			cell.top.equalTo(MyPageCells[2].snp.bottom)
			cell.leading.trailing.equalToSuperview()
			cell.height.equalTo(85)
		}
		
		MyPageCells[4].snp.makeConstraints{ cell in
			cell.top.equalTo(MyPageCells[3].snp.bottom)
			cell.leading.trailing.equalToSuperview()
			cell.height.equalTo(85)
		}
		
		MyPageCells.enumerated().forEach{ idx, cell in
			cell.snp.makeConstraints{ cell in
				accessoryDetailButtons[idx].snp.makeConstraints{ button in
					button.trailing.equalToSuperview().offset(-6)
					button.top.equalToSuperview().offset(20)
					button.width.height.equalTo(48)
				}
				
				buttonLabels[idx].snp.makeConstraints{ label in
					label.leading.equalToSuperview().offset(24)
					label.centerY.equalTo(accessoryDetailButtons[idx])
				}
				
				separeteBars[idx].snp.makeConstraints{ bar in
					bar.leading.trailing.equalToSuperview()
					bar.bottom.equalToSuperview()
					bar.height.equalTo(1)
				}
			}
		}
		
		authOutLabel.snp.makeConstraints{ label in
			label.top.equalTo(MyPageCells[4].snp.bottom).offset(12)
			label.leading.equalToSuperview().offset(24)
		}
		
	}
	
	override func bind() {
		
        MyPageCells[1].rx.tapped()
			.withUnretained(self)
			.observe(on: MainScheduler.instance)
			.subscribe(onNext: { owner, _ in
				let rullesURL = "https://makeus-challenge.notion.site/43da7aedefaf4eb5a227dd9a1c66be5b?pvs=4"
				guard let url = URL(string: rullesURL) else { return }
				let sfVC = SFSafariViewController(url: url)
				sfVC.modalPresentationStyle = .overFullScreen
				owner.present(sfVC, animated: true)
			})
			.disposed(by: disposeBag)
		
        MyPageCells[2].rx.tapped()
			.withUnretained(self)
			.observe(on: MainScheduler.instance)
			.subscribe(onNext: { owner, _ in
				let handlePersonalInfoURL = "https://makeus-challenge.notion.site/be7d5901cf834befafe088e03e362c96?pvs=4"
				guard let url = URL(string: handlePersonalInfoURL) else { return }
				let sfVC = SFSafariViewController(url: url)
				sfVC.modalPresentationStyle = .overFullScreen
				owner.present(sfVC, animated: true)
			})
			.disposed(by: disposeBag)
		
		let isLogoutTapped = MyPageCells[4].rx.tapped()
			.asObservable()
			.flatMapLatest { _ -> Observable<Bool> in
				return CMCBottomSheetWithActionManager.shared.showBottomSheet(
					title: "정말 로그아웃 하시겠어요?",
					body: nil,
					buttonTitle: "돌아가기",
					actionTitle: "로그아웃"
				)
			}
		
		let isAuthOutTapped = authOutLabel.rx.tapGesture().when(.recognized)
			.asObservable()
			.flatMapLatest { _ -> Observable<Bool> in
				return CMCBottomSheetWithActionManager.shared.showBottomSheet(
					title: "정말 탈퇴하시겠어요?",
					body: "현 기수 CMC활동중이라면, 불이익이 발생할 수 있습니다.",
					buttonTitle: "돌아가기",
					actionTitle: "탈퇴하기"
				)
			}
		
		let input = MyPageViewModel.Input(
			backBtnTapped: navigationBar.backButton.rx.tapped().asObservable(),
			myInfoBtnTapped: MyPageCells[0].rx.tapped().asObservable(),
            changePasswordBtnTapped: MyPageCells[3].rx.tapped().asObservable(),
			isLogoutTapped: isLogoutTapped,
			isAuthOutTapped: isAuthOutTapped
		)
		
		let _ = viewModel.transform(input: input)
		
		
	
	}
	
}
