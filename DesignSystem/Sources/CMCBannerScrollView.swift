//
//  CMCBannerScrollView.swift
//  DesignSystem
//
//  Created by Siri on 12/2/23.
//  Copyright © 2023 com.softsquared.cmc. All rights reserved.
//

import Foundation
import UIKit

import SnapKit

import RxSwift
import RxCocoa
import RxGesture

final class CMCBannerScrollView: UIView {
	
	//MARK: - UI
	private lazy var scrollView: UIScrollView = {
		let scrollView = UIScrollView()
		scrollView.isPagingEnabled = true
		scrollView.showsHorizontalScrollIndicator = false
		scrollView.delegate = self
		return scrollView
	}()
	
	//MARK: - Properties
	private var banners: [UIView] // 실제 배너 뷰들 -> 우선 UIView로 해두자
	private let disposeBag = DisposeBag()
	
	private let currentPage = BehaviorRelay<Int>(value: 1)
	private var autoScrollTimer: Disposable?
	
	//MARK: - Initializer
	init(
		banners: [UIView]
	) {
		self.banners = banners
		super.init(frame: .zero)
		//1. 먼저, banners 재구성
		self.replaceBanners()
		//2. view 추가
		self.setAddSubViews()
		//3. constraints 추가
		self.setAddConstraints()
		//4. 바인딩
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func replaceBanners() {
		var newBanners: [UIView] = []
		let first = self.banners.first!.clone()
		let last = self.banners.last!.clone()
		newBanners.append(last)
		newBanners.append(contentsOf: self.banners)
		newBanners.append(first)
		self.banners = newBanners
	}
	
	private func setAddSubViews() {
		self.addSubview(scrollView)
		banners.forEach { banner in
			self.scrollView.addSubview(banner)
		}
	}
	
	private func setAddConstraints() {
		scrollView.snp.makeConstraints { make in
			make.edges.equalToSuperview()
		}
		var x: CGFloat = 0
		for banner in banners {
			banner.frame = CGRect(
				x: x,
				y: 0,
				width: self.bounds.width,
				height: self.bounds.height
			)
			x += self.bounds.width
		}
		/// 실제 스크롤뷰 content size 지정
		scrollView.contentSize.width = x
		scrollView.contentSize.height = self.bounds.width
		/// 시작위치 1번 인덱스로 이동
		scrollView.contentOffset.x = self.bounds.width
	}
	
	private func bind() {
		autoScrollTimer = Observable<Int>.interval(RxTimeInterval.seconds(3), scheduler: MainScheduler.instance)
			.subscribe(onNext: { [weak self] _ in
				guard let ss = self else { return }
				let newOffset = CGPoint(x: ss.scrollView.contentOffset.x + ss.bounds.width, y: 0)
				ss.scrollView.setContentOffset(newOffset, animated: true)
			})
		
		autoScrollTimer?.disposed(by: disposeBag)
	}
	
	deinit {
		autoScrollTimer?.dispose()
	}
}

extension CMCBannerScrollView: UIScrollViewDelegate {
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		let nowOffset = CGFloat(scrollView.contentOffset.x / self.bounds.width)
		let realBannerCount = CGFloat(banners.count - 2)
		
		if nowOffset == 0 {
			self.scrollView.contentOffset.x = CGFloat(realBannerCount) * bounds.width // [0] -> [count]
		} else if nowOffset == realBannerCount + 1 {
			self.scrollView.contentOffset.x =  bounds.width // [count+1] -> [1]
		}
		let now = Int(self.scrollView.contentOffset.x / bounds.width) == 0 ? 1 : Int(self.scrollView.contentOffset.x / bounds.width)
		currentPage.accept(now)
	}
	
	func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
		autoScrollTimer?.dispose()
	}
	
	func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
		bind()
	}
}

extension UIView {
		func clone() -> UIView {
				let clonedBanner = UIView()
				return clonedBanner
		}
}
