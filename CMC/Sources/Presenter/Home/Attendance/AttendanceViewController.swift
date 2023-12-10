//
//  AttendanceViewController.swift
//  CMC
//
//  Created by Siri on 12/9/23.
//  Copyright © 2023 com.softsquared.cmc. All rights reserved.
//

import Foundation
import UIKit
import DesignSystem

import RxSwift
import RxCocoa

import SnapKit

final class AttendanceViewController: UIViewController {
	
	// MARK: - UI
	private lazy var navigationBar: CMCNavigationBar = {
		let navi = CMCNavigationBar(accessoryLabelHidden: true)
		navi.backgroundColor = .clear
		return navi
	}()
	
	private lazy var selfEnterQRCodeLabel: UILabel = {
		let label = UILabel()
		label.text = "💡 QR코드가 입력되지 않을경우 여기를 클릭해주세요"
		label.font = CMCFontFamily.Pretendard.medium.font(size: 13)
		label.textColor = CMCAsset.gray50.color
		return label
	}()
	
	private var readerView: ReaderView!
	private var disposeBag = DisposeBag()
	
	// MARK: - Properties
	private let viewModel: AttendanceViewModel
	
	// MARK: - Initializers
	init(
		viewModel: AttendanceViewModel
	) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - LifeCycle
	override func viewDidLoad() {
		super.viewDidLoad()
		setupReaderView()
		bind()
		CMCIndecatorManager.shared.hide()
	}
	
	private func setupReaderView() {
		readerView = ReaderView(frame: view.bounds)
		view.addSubview(readerView)
		view.addSubview(navigationBar)
		view.addSubview(selfEnterQRCodeLabel)
		
		navigationBar.snp.makeConstraints { make in
			make.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
			make.height.equalTo(68)
		}
		
		readerView.snp.makeConstraints {
			$0.edges.equalToSuperview()
		}
		
		selfEnterQRCodeLabel.snp.makeConstraints {
			$0.centerX.equalToSuperview()
			$0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-16)
		}
	}
	
	// MARK: - Methode
	
	private func bind() {
		
		
		navigationBar.backButton.rx.tapped()
			.asObservable()
			.withUnretained(self)
			.subscribe(onNext: { owner, _ in
				owner.viewModel.coordinator?.popToRootViewController(animated: true)
			})
			.disposed(by: disposeBag)
		
		
		selfEnterQRCodeLabel.rx.tapped().asObservable()
			.withUnretained(self)
			.subscribe(onNext: { owner, _ in
				let selfEnterQRCodeViewController = SelfEnterQRCodeViewController(
					viewModel: SelfEnterQRCodeViewModel(
						attendanceUsecase: DefaultAttendancesUsecase(
							attendancesRepository: DefaultAttendancesRepository()
						),
						coordinator: self.viewModel.coordinator
					)
				)
				owner.viewModel.coordinator?.pushViewController(
					viewController: selfEnterQRCodeViewController,
					animated: true
				)
			})
			.disposed(by: disposeBag)
		
		
		let input = AttendanceViewModel.Input(
			qrScanResult: readerView.qrCodeResult
		)
		
		let output = viewModel.transform(input: input)
		
		output.qrCode
			.withUnretained(self)
			.subscribe(onError: { error in
				guard let error = error as? NetworkError else { return }
				CMCBottomSheetManager.shared.showBottomSheet(
					title: error.errorDescription,
					body: "하단의 토스트 메세지를 터치하여, 코드를 직접 입력해주세요!",
					buttonTitle: "확인"
				)
			})
			.disposed(by: disposeBag)
		
		output.needToRestartQRScan
			.withUnretained(self)
			.subscribe(onNext: { owner, _ in
				owner.resetReaderView()
			})
			.disposed(by: disposeBag)
	}
	
	private func resetReaderView() {
		// 기존 ReaderView 제거
		readerView?.removeFromSuperview()
		readerView = nil
		disposeBag = DisposeBag()
		
		DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
			guard let owner = self else { return }
			// 새로운 ReaderView 생성 및 설정
			let newReaderView = ReaderView(frame: owner.view.bounds)
			owner.view.addSubview(newReaderView)
			
			newReaderView.snp.makeConstraints {
				$0.edges.equalToSuperview()
			}
			
			owner.view.bringSubviewToFront(owner.navigationBar)
			owner.view.bringSubviewToFront(owner.selfEnterQRCodeLabel)
			
			// 참조 업데이트
			owner.readerView = newReaderView
			owner.bind()
			
		}
	}
	
	
}
