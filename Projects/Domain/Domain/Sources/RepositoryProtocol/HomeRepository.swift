//
//  HomeRepository.swift
//  Domain
//
//  Created by JDeoks on 7/19/25.
//

import RxSwift


public protocol HomeRepository {
  func fetchHomeData() -> Single<HomeInfo>
}
