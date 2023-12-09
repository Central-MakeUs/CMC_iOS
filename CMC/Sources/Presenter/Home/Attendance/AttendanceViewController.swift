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
	public lazy var backButton: CMCTouchArea = {
		let backButton = CMCTouchArea(
			image: CMCAsset._24x24arrowLeft.image
		)
		return backButton
	}()
	
	private var readerView: ReaderView!
	private let disposeBag = DisposeBag()
	
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
		view.addSubview(backButton)
		
		backButton.snp.makeConstraints {
			$0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
			$0.leading.equalToSuperview().offset(16)
			$0.width.height.equalTo(48)
		}
		
		readerView.snp.makeConstraints {
			$0.edges.equalToSuperview()
		}
	}
	
	// MARK: - Methode
	
	private func bind() {
		
		let input = AttendanceViewModel.Input(
			backBtnTapped: backButton.rx.tapped().asObservable(),
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
		backButton.removeFromSuperview()
		readerView = nil
		
		DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
			guard let owner = self else { return }
			// 새로운 ReaderView 생성 및 설정
			let newReaderView = ReaderView(frame: owner.view.bounds)
			owner.view.addSubview(newReaderView)
			owner.view.addSubview(owner.backButton)
			
			owner.backButton.snp.makeConstraints {
				$0.top.equalTo(owner.view.safeAreaLayoutGuide.snp.top).offset(16)
				$0.leading.equalToSuperview().offset(16)
				$0.width.height.equalTo(48)
			}
			
			newReaderView.snp.makeConstraints {
				$0.edges.equalToSuperview()
			}
			// 참조 업데이트
			owner.readerView = newReaderView
			owner.bind()
			
		}
	}
	
	
}
