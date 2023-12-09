//
//  CheckMyAttendanceViewController.swift
//  CMC
//
//  Created by Siri on 12/9/23.
//  Copyright © 2023 com.softsquared.cmc. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa
import RxGesture

import SnapKit

import UIKit
import DesignSystem

final class CheckMyAttendanceViewController: BaseViewController {
	
	// MARK: - UI
	private lazy var navigationBar: CMCNavigationBar = {
		let navigationBar = CMCNavigationBar(
			accessoryLabelHidden: true
		)
		return navigationBar
	}()
	
	
	
	private lazy var tableView: UITableView = {
		let tableView = UITableView()
		tableView.translatesAutoresizingMaskIntoConstraints = false
		tableView.backgroundColor = .clear
		tableView.separatorStyle = .none
		tableView.register(CheckMyAttendanceCell.self, forCellReuseIdentifier: CheckMyAttendanceCell.reuseIdentifier)
		return tableView
	}()
	
	// MARK: - Properties
	private let viewModel: CheckMyAttendanceViewModel
	
	// MARK: - Initialize
	init(
		viewModel: CheckMyAttendanceViewModel
	) {
		self.viewModel = viewModel
		super.init()
	}
	
	// MARK: - Methods
	
	override func setAddSubView() {
		super.setAddSubView()
	}
	
	override func setConstraint() {
		super.setConstraint()
	}
	
	override func bind() {
		super.bind()
		
		
		tableView.rx.setDelegate(self)
			.disposed(by: disposeBag)
		
		tableView.rx.modelSelected(CheckMyAttendanceModel.self)
			.withUnretained(self)
			.do(onDispose: {
				CSIndecatorManager.shared.hide()
			})
			.subscribe(onNext: { owner, eventModel in
				CSIndecatorManager.shared.show()
				EffectsModel.shared.removeLocalCSEffects()
				if eventModel.isCaption {
					var info = EffectInfoWeb.DetailInfo(folder: .cameraFiStudio)
					info.url = eventModel.captionOverlayUrl
					info.position = "0.00:0.00:1.00:1.00:170"
					info.CameraFiStudioOverlayImage = UIImage(named: "_24x24Caption")
					info.name = eventModel.captionOverlayUrl
					info.privacyEffect = false
					let cameraFi_Studio_Info = EffectInterpreter.interpreit(with: info)
					EffectsModel.shared.effectsWeb.data.append(cameraFi_Studio_Info)
					let dbsWebDetailInfo = DBSEffect(detailInfo: cameraFi_Studio_Info)
					let realm = RealmManager.realm()
					try? realm.write {
						realm.add(dbsWebDetailInfo, update: .modified)
					}
					owner.delegate?.reloadEffectsDataCollectionView()
					owner.dismiss(animated: true)
				} else {
					owner.matchUidRelay.accept(eventModel.matchUid)
				}
			})
			.disposed(by: disposeBag)
		
		
		let input = CheckMyAttendanceViewModel.Input(
			backBtnTapped: navigationBar.backButton.rx.tapped().asObservable()
		)
		let output = viewModel.transform(input: input)
		
		//MARK: - 우선 첫번째로, 이벤트 통짜 데이터를 다뤄봅시다
		output.eventList
			.do(onSubscribe: {
				CSIndecatorManager.shared.show()
			}, onDispose: {
				CSIndecatorManager.shared.hide()
			})
			.bind(to: tableView.rx.items) { tableView, row, model in
				let cell = tableView.dequeueReusableCell(withIdentifier: CSEventTableViewCell.reuseIdentifier) as! CSEventTableViewCell
				cell.configureCell(eventList: model)
				return cell
			}
			.disposed(by: disposeBag)
		
		//MARK: - 동시에, 받아온 이벤트가 없을 경우 뒤에 화면을 채워줍시다
		output.eventList
			.observe(on: MainScheduler.instance)
			.withUnretained(self)
			.subscribe(onNext: { owner, elements in
				if elements.isEmpty {
					owner.tableView.setEmptyViewForCS()
				} else {
					owner.tableView.restoreEmptyView()
				}
			})
			.disposed(by: disposeBag)
		
		
		//MARK: - 매치의 경우는, 서브젝트로 처리된 matchUid를 통해 위젯들을 가져오자
		output.matchDetail
			.observe(on: MainScheduler.instance)
			.withUnretained(self)
			.subscribe(onNext: { owner, matchDetails in
				let sortedMatches = matchDetails.sorted(by: { $0.overlayIndex < $1.overlayIndex })
				var arrForSaveDBSEffect = [EffectInfoWeb.DetailInfo]()
				let sortedImages = sortedMatches.map {
					if let data = $0.overlayImage {
						return UIImage(data: data)
					}
					return UIImage(named: "_scoreboard_info_default")
				}
				sortedMatches.enumerated().forEach { idx, sortedMatch in
					var info = EffectInfoWeb.DetailInfo(folder: .cameraFiStudio)
					info.url = sortedMatch.url
					info.position = "0.00:0.00:1.00:1.00:170"
					info.CameraFiStudioOverlayImage = sortedImages[idx]
					info.name = sortedMatch.url
					info.privacyEffect = false
					let cameraFi_Studio_Info = EffectInterpreter.interpreit(with: info)
					EffectsModel.shared.effectsWeb.data.append(cameraFi_Studio_Info)
					arrForSaveDBSEffect.append(cameraFi_Studio_Info)
				}
				let dbsWebDetailInfo = arrForSaveDBSEffect.map { DBSEffect(detailInfo: $0) }
				let realm = RealmManager.realm()
				try? realm.write {
					realm.add(dbsWebDetailInfo, update: .modified)
				}
				owner.delegate?.reloadEffectsDataCollectionView()
				owner.dismiss(animated: true)
			})
			.disposed(by: disposeBag)
	}
	
}


extension CheckMyAttendanceViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 120
	}
}
