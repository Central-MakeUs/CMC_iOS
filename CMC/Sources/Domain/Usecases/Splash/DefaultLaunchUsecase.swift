//
//  DefaultLaunchUsecase.swift
//  CMC
//
//  Created by Siri on 2023/10/24.
//  Copyright © 2023 com.centralMakeusChallenge. All rights reserved.
//

import Foundation
import RxSwift


class DefaultLaunchUsecase: LaunchUsecase {
	
	private let launchRepository: LaunchRepository
	
	init(launchRepository: LaunchRepository) {
		self.launchRepository = launchRepository
	}
	
	func health() -> Single<LaunchModel> {
		return launchRepository.health()
			.map { dto in
				return dto.toDomain()
			}
	}
}
