//
//  UserRepository.swift
//  CMC
//
//  Created by Siri on 12/4/23.
//  Copyright © 2023 com.softsquared.cmc. All rights reserved.
//

import Foundation
import RxSwift

protocol UserRepository {
	func getUser() -> Single<GetUsersDTO>
	func deleteUser() -> Single<DeleteUsersDTO>
}

