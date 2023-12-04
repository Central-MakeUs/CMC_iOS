//
//  DefaultUserUsecase.swift
//  CMC
//
//  Created by Siri on 12/4/23.
//  Copyright © 2023 com.softsquared.cmc. All rights reserved.
//

import Foundation
import RxSwift

final class DefaultUserUsecase: UserUsecase {
	
	private let userRepository: UserRepository
	
	init(userRepository: UserRepository) {
		self.userRepository = userRepository
	}
	
	func getUser() -> Single<GetUserModel> {
		return userRepository.getUser()
			.map { dto in
				return dto.toDomain()
			}
	}
	
	func deleteUser() -> Single<DeleteUserModel> {
		return userRepository.deleteUser()
			.map { dto in
				return dto.toDomain()
			}
	}
	
}
