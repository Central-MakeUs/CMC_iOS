//
//  CMCProgressPager.swift
//  DesignSystem
//
//  Created by Siri on 10/28/23.
//  Copyright © 2023 com.centralMakeusChallenge. All rights reserved.
//

import Foundation

import RxCocoa
import RxSwift

import SnapKit

import UIKit

public final class CMCProgressPager: UIView {
	// MARK: - UI
	
	private lazy var progressView: UIProgressView = {
		let progressView = UIProgressView()
		progressView.progressTintColor = DesignSystemAsset.main1.color
		progressView.trackTintColor = DesignSystemAsset.background.color
		progressView.progress = 0.00
		return progressView
	}()
	
	private lazy var titleLabel: UILabel = {
		let label = UILabel()
		label.text = "default"
		label.font = DesignSystemFontFamily.Pretendard.bold.font(size: 26)
		label.textColor = DesignSystemAsset.gray50.color
		return label
	}()
	
	private lazy var pagerScrollView: UIScrollView = {
		let scrollView = UIScrollView()
		scrollView.isPagingEnabled = true
		scrollView.isScrollEnabled = false
		scrollView.showsHorizontalScrollIndicator = false
		
		return scrollView
	}()
	
	// MARK: - Properties
	
	private let disposeBag = DisposeBag()
	private let currentPage = BehaviorRelay(value: 1)
	
	private var pages: [UIView]
	private let titles: [String]
	private var pagesCount: Int
	
	// MARK: - Initializers
	public init(
		pages: [UIView],
		titles: [String]
	) {
		self.pages = pages
		self.titles = titles
		self.pagesCount = pages.count
		
		super.init(frame: .zero)
		setAddSubView()
		setConstraint()
		bind()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	// MARK: - LifeCycle
	
	// MARK: - Methods
	public override func layoutSubviews() {
		super.layoutSubviews()
		
		for (index, page) in pages.enumerated() {
			pagerScrollView.addSubview(page)
			page.snp.makeConstraints { make in
				make.top.equalTo(titleLabel.snp.bottom).offset(24)
				make.bottom.equalTo(self.snp.bottom)
				make.width.equalTo(self.frame.size.width)
				make.leading.equalToSuperview().offset(CGFloat(index) * self.frame.size.width)
			}
		}
		pagerScrollView.contentSize = CGSize(
			width: self.frame.size.width * CGFloat(pages.count),
			height: self.frame.size.height
		)
	}
	
	private func setAddSubView() {
		self.addSubview(progressView)
		self.addSubview(titleLabel)
		self.addSubview(pagerScrollView)
	}
	
	private func setConstraint() {
		
		self.progressView.snp.makeConstraints{ progressView in
			progressView.top.equalTo(self)
			progressView.height.equalTo(2)
			progressView.leading.trailing.equalTo(self)
		}
		
		self.titleLabel.snp.makeConstraints { titleLabel in
			titleLabel.top.equalTo(progressView.snp.bottom).offset(30)
			titleLabel.leading.equalToSuperview().offset(24)
			titleLabel.height.lessThanOrEqualTo(32)
		}
		
		self.pagerScrollView.snp.makeConstraints { scrollView in
			scrollView.top.equalTo(titleLabel.snp.bottom).offset(24)
			scrollView.leading.trailing.bottom.equalTo(self)
		}
	}
	
	private func bind() {
		currentPage.asObservable()
			.map { Float($0) / Float(self.pagesCount) }
			.withUnretained(self)
			.subscribe(onNext: { owner, progress in
				 owner.progressView.setProgress(progress, animated: true)
			})
			.disposed(by: disposeBag)
		
		currentPage.asObservable()
			.subscribe(onNext: { [weak self] page in
				guard let self = self else { return }
				let xOffset = CGFloat(page - 1) * self.frame.size.width
				self.pagerScrollView.setContentOffset(CGPoint(x: xOffset, y: 0), animated: true)
			})
			.disposed(by: disposeBag)
		
		currentPage.asObservable()
			.withUnretained(self)
			.subscribe(onNext: { owner, page in
				owner.titleLabel.text = owner.titles[page - 1]
			})
			.disposed(by: disposeBag)
		
	}
	
	public func nextPage() {
		currentPage.accept(currentPage.value + 1)
	}
	
	public func previousPage() {
		currentPage.accept(currentPage.value - 1)
	}
	
	public func getCurrentPage() -> Observable<Int> {
		return currentPage.asObservable()
	}
	
	public func totalPages() -> Int {
		return pagesCount
	}
}
