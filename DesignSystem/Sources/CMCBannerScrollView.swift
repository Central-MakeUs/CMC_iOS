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

public final class CMCBannerScrollView: UIView {
	
	//MARK: - UI
	private lazy var scrollView: UIScrollView = {
		let scrollView = UIScrollView()
		scrollView.isPagingEnabled = true
		scrollView.showsHorizontalScrollIndicator = false
		scrollView.delegate = self
		return scrollView
	}()
	
	//MARK: - Properties
	private var banners: [CMCBannerView] // 실제 배너 뷰들 -> 우선 UIView로 해두자
	private let disposeBag = DisposeBag()
	
	private let currentPage = BehaviorRelay<Int>(value: 1)
	private var autoScrollTimer: Disposable?
	
	public let getBannerUrl = PublishRelay<String>()
	
	//MARK: - Initializer
	public init(
		banners: [CMCBannerView]
	) {
		self.banners = banners
		super.init(frame: .zero)
		self.replaceBanners()
		self.setAddSubViews()
		self.setAddConstraints()
		self.bind()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	public override func layoutSubviews() {
		super.layoutSubviews()
		self.setAfterAddConstraints()
	}
	
	private func replaceBanners() {
		var newBanners: [CMCBannerView] = []
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
	}
	
	private func setAfterAddConstraints() {
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
		scrollView.contentSize.height = self.bounds.height
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
		
		banners.forEach { banner in
			banner.rx.tapGesture()
				.when(.recognized)
				.subscribe(onNext: { [weak self] _ in
					guard let ss = self else { return }
					ss.getBannerUrl.accept(banner.getUrl())
				})
				.disposed(by: disposeBag)
		}
		
		autoScrollTimer?.disposed(by: disposeBag)
	}
	
	private func startAutoScroll() {
		// 기존 타이머가 있으면 중단
		autoScrollTimer?.dispose()
		
		// 새 타이머 시작
		autoScrollTimer = Observable<Int>.interval(RxTimeInterval.seconds(3), scheduler: MainScheduler.instance)
			.subscribe(onNext: { [weak self] _ in
				guard let self = self else { return }
				let newOffset = CGPoint(x: self.scrollView.contentOffset.x + self.bounds.width, y: 0)
				self.scrollView.setContentOffset(newOffset, animated: true)
			})
		autoScrollTimer?.disposed(by: disposeBag)
	}
	
	public func updateBanners(_ newBanners: [CMCBannerView]) {
		/// 1. 기존 배너 제거
		scrollView.subviews.forEach { $0.removeFromSuperview() }
		
		/// 2. 새 배너들 추가
		self.banners = newBanners
		self.replaceBanners()
		
		/// 3. 새 배너들에 대해 뷰와 제스처 바인딩 추가
		banners.forEach { banner in
			scrollView.addSubview(banner)
			banner.rx.tapGesture()
				.when(.recognized)
				.subscribe(onNext: { [weak self] _ in
					self?.getBannerUrl.accept(banner.getUrl())
				})
				.disposed(by: disposeBag)
		}
		
		/// 4. 스크롤뷰와 배너 레이아웃 재설정
		self.setAfterAddConstraints()
		
		/// 5. 오토 스크롤 재시작
		self.startAutoScroll()
	}
	
	deinit {
		autoScrollTimer?.dispose()
	}
}

extension CMCBannerScrollView: UIScrollViewDelegate {
	
	public func scrollViewDidScroll(_ scrollView: UIScrollView) {
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
	
	public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
		autoScrollTimer?.dispose()
	}
	
	public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
		startAutoScroll()
	}
}
