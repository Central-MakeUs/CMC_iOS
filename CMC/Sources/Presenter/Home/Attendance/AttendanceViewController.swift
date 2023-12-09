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
	}
	
	private func handleScannedCode(_ code: String) {
		print("🍎 코드 확인좀여: \(code) 🍎")
		// 여기에 스캔된 QR 코드를 처리하는 로직을 구현합니다.
		// 예를 들어, 웹뷰를 열거나, 특정 데이터를 화면에 표시하는 등의 작업을 할 수 있습니다.
	}
	
}
