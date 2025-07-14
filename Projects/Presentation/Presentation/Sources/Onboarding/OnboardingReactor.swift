//
//  OnboardingReactor.swift
//  Presentation
//
//  Created by dong eun shin on 7/4/25.
//

import ReactorKit
import RxSwift
import Domain

public final class OnboardingReactor: Reactor {
  public enum Action {
    /// 질문에 대한 답 선택
    case select(question: OnboardingQuestion, index: Int)
    /// 다음으로 이동
    case moveNext
    /// 이전으로 이동
    case moveBack
  }
  
  public enum Mutation {
    case setCurrentStep(Int)
    case setSelection(question: OnboardingQuestion, index: Int)
    case setNextEnabled(Bool)
    case setLoading(Bool)
    case setCompleted(Bool)
    case setError(String?)
  }
  
  public struct State {
    /// 질문 단계
    public fileprivate(set) var currentStep: Int = 0
    /// 답변 상태
    public fileprivate(set) var selections: [OnboardingQuestion: Int] = [:]
    /// 다음 버튼 활성화 상태
    public fileprivate(set) var isNextEnabled: Bool = false
    /// 로딩 여부
    public fileprivate(set) var isLoading: Bool = false
    /// 온보딩 완료. 다음페이지로 이동
    public fileprivate(set) var isCompleted: Bool = false
    /// 에러
    public fileprivate(set) var errorMessage: String?
  }
  
  public var initialState: State = State()
  
  private let saveOnboardingUseCase: SaveOnboardingUseCase
  
  public init(saveOnboardingUseCase: SaveOnboardingUseCase) {
    self.saveOnboardingUseCase = saveOnboardingUseCase
  }
  
  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case let .select(question, index):
      return handleAnswerSelect(question: question, index: index)
    case .moveNext:
      return handleMoveNext()
    case .moveBack:
      return handleMoveBack()
    }
  }
  
  public func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case let .setCurrentStep(newStep):
      newState.currentStep = newStep
      
    case let .setSelection(question, index):
      newState.selections[question] = index
      
    case let .setNextEnabled(isNextEnabled):
      newState.isNextEnabled = isNextEnabled
      
    case let .setLoading(isLoading):
      newState.isLoading = isLoading
      
    case let .setCompleted(isCompleted):
      newState.isCompleted = isCompleted
      
    case let .setError(errorMessage):
      newState.errorMessage = errorMessage
    }
    return newState
  }
  
  private func handleAnswerSelect(
    question: OnboardingQuestion,
    index: Int
  ) -> Observable<Mutation> {
    let updatedSelections = currentState.selections.merging([question: index]) { _, new in new }
    let enabled = canProceed(
      step: currentState.currentStep,
      selections: updatedSelections
    )
    return Observable.concat([
      .just(.setSelection(question: question, index: index)),
      .just(.setNextEnabled(enabled))
    ])
  }
  
  private func handleMoveNext() -> Observable<Mutation> {
    let next = currentState.currentStep + 1
    if next >= OnboardingStep.allCases.count {
      return saveOnboarding()
    }

    let enabled = canProceed(
      step: next,
      selections: currentState.selections
    )
    return Observable.concat([
      .just(.setCurrentStep(next)),
      .just(.setNextEnabled(enabled))
    ])
  }
  
  private func saveOnboarding() -> Observable<Mutation> {
    let answers = OnboardingStep.allCases
      .flatMap { $0.questions }
      .compactMap { question -> OnboardingAnswer? in
        guard let idx: Int = currentState.selections[question] else { return nil }
        let answerChar = ["A","B","C","D"][idx]
        return OnboardingAnswer(
          questionType: question.apiType,
          answer: answerChar
        )
      }
    
    return .concat([
      .just(.setLoading(true)),
      saveOnboardingUseCase.execute(answers)
        .map { success in
          success
            ? Mutation.setCompleted(true)
            : Mutation.setError("서버 응답이 SUCCESS 가 아닙니다.")
        }
        .catch { .just(.setError($0.localizedDescription)) }
        .asObservable(),
      .just(.setLoading(false))
    ])
  }
  
  private func handleMoveBack() -> Observable<Mutation> {
    let prev = currentState.currentStep - 1
    if prev < 0 {
      return .empty()
    }
    let enabled = canProceed(
      step: prev,
      selections: currentState.selections
    )
    return Observable.concat([
      .just(.setCurrentStep(prev)),
      .just(.setNextEnabled(enabled))
    ])
  }
  
  /// 다음버튼의 보이기 여부 결정
  private func canProceed(
    step: Int,
    selections: [OnboardingQuestion: Int]
  ) -> Bool {
    let questions = OnboardingStep.allCases[step].questions
    return questions.allSatisfy { selections[$0] != nil }
  }
}
