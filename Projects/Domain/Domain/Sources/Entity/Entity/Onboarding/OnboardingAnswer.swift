//
//  OnboardingAnswer.swift
//  Domain
//
//  Created by JDeoks on 7/14/25.
//


/// 서버에 온보딩 선택 결과 보낼 때 사용
public struct OnboardingAnswer {
  
  public let questionType: String // e.g. "EXPLOSIVE_STRENGTH"
  public let answer: String // e.g. "YES" or "NO"
  
  public init(questionType: String, answer: String) {
    self.questionType = questionType
    self.answer = answer
  }
}
