//
//  PlanetsViewModelTest.swift
//  StarWarsPlannetTests
//
//  Created by Krishantha Sunil Premaretna on 2022-10-23.
//

import XCTest
import Quick
import Nimble
import RxSwift
import RxTest
import RxCocoa
@testable import StarWarsPlannet

class PlanetsViewModelTest: QuickSpec {
    private let error = NSError()
    override func spec() {
        describe("Planets viewmodel") {
            let disposeBag = DisposeBag()
            var scheduler: TestScheduler!
            var useCase: MockPlanetUsecase!
            var mockAgent: TestNetworkAgent!
            beforeEach {
                scheduler = TestScheduler(initialClock: 0)
                mockAgent = TestNetworkAgent()
                mockAgent.mockFileName = "emptyplanets"
                useCase = MockPlanetUsecase(with: mockAgent)
            }
            
            context("binding") {
                it("should return correct binding") {
                    let sut = PlanentsViewModel(with: useCase)
                    let outPut = sut.bind(input: .init(didLoad: .just(()),
                                                       willDisplayLastCell: .just(())))
                    
                    let states = scheduler.createObserver(PlanentsViewModel.State?.self)
                    outPut
                        .bind(to: states)
                        .disposed(by: disposeBag)
                    
                    scheduler.createColdObservable([
                        .next(0, PlanentsViewModel.State.loading),
                        .next(10, .loading),
                        .next(20, .loaded([])),
                        .next(30, .loading),
                        .next(40, .nextLoaded([]))
                    ])
                    .bind(to: sut.state)
                    .disposed(by: disposeBag)
                    
                    scheduler.start()
                    expect(states.events) == [.next(0, PlanentsViewModel.State.loading),
                                              .next(10, .loading),
                                              .next(20, .loaded([])),
                                              .next(30, .loading),
                                              .next(40, .nextLoaded([]))
                    ]
                }
            }
            
            context("When view Did load") {
                it("should return loading state") {
                    let sut = PlanentsViewModel(with: useCase)
                    let input = PlanentsViewModel.Input(didLoad: scheduler.createHotObservable([
                        .next(10, ())
                    ]).asObservable(),
                                                        willDisplayLastCell: .just(()))
                    let output = sut.bind(input: input)
                    
                    let states = scheduler.createObserver(PlanentsViewModel.State?.self)
                    output
                        .bind(to: states)
                        .disposed(by: disposeBag)
                    scheduler.start()
                    
                    expect(states.events) == [.next(10, PlanentsViewModel.State.loading)]
                    
                }
                
                it("should return loaded state when fetching completed") {
                    let apiExpecation = self.expectation(description: "apifetch")
                    let sut = PlanentsViewModel(with: useCase)
                    let states = scheduler.createObserver(PlanentsViewModel.State?.self)
                    
                    let input = PlanentsViewModel.Input(didLoad: scheduler.createColdObservable([.next(10, ())]).asObservable(),
                                                        willDisplayLastCell: .just(()))
                    let output = sut.bind(input: input)
                    
                    output.do(onNext: { statee in
                        switch statee {
                        case .loaded([]):
                            apiExpecation.fulfill()
                        default:break
                        }
                    })
                    .bind(to: states)
                        .disposed(by: disposeBag)
                        scheduler.start()
                        
                        
                        self.wait(for: [apiExpecation], timeout: 1)
                        expect(states.events) == [.next(10, PlanentsViewModel.State.loading),
                                                  .next(10, PlanentsViewModel.State.loaded([])) ]
                }
                
                it("should return failed state when fetching failed") {
                    let apiExpecation = self.expectation(description: "apifetch")
                    
                    mockAgent.mockFileName = "invalid"
                    
                    let sut = PlanentsViewModel(with: useCase)
                    let states = scheduler.createObserver(PlanentsViewModel.State?.self)
                    
                    let input = PlanentsViewModel.Input(didLoad: scheduler.createColdObservable([.next(10, ())]).asObservable(),
                                                        willDisplayLastCell: .just(()))
                    let output = sut.bind(input: input)
                    
                    output.do(onNext: { statee in
                        switch statee {
                        case .failed:
                            apiExpecation.fulfill()
                        default:break
                        }
                    })
                    .bind(to: states)
                        .disposed(by: disposeBag)
                        scheduler.start()
                        
                        
                        self.wait(for: [apiExpecation], timeout: 1)
                        expect(states.events) == [.next(10, PlanentsViewModel.State.loading),
                                                  .next(10, PlanentsViewModel.State.failed(ServiceError.inValidData))]
                }

            }
            
            context("When view last cell displayed") {
                it("before fetching next url should update state to loading") {
                    let sut = PlanentsViewModel(with: useCase)
                    sut.nextUrl = "page=4"
                    let input = PlanentsViewModel.Input(didLoad: scheduler.createHotObservable([
                        .next(10, ())
                    ]).asObservable(),
                                                        willDisplayLastCell: scheduler.createHotObservable([
                                                            .next(20, ())
                                                        ]).asObservable())
                    
                    let output = sut.bind(input: input)
                    
                    let states = scheduler.createObserver(PlanentsViewModel.State?.self)
                    output
                        .bind(to: states)
                        .disposed(by: disposeBag)
                    scheduler.start()
                    
                    expect(states.events) == [.next(10, PlanentsViewModel.State.loading),
                                              .next(20, PlanentsViewModel.State.loading)]
                    
                }
                
                it("when nextURL is nil should not fetch more planets") {
                    let sut = PlanentsViewModel(with: useCase)
                    let input = PlanentsViewModel.Input(didLoad: scheduler.createHotObservable([
                        .next(10, ())
                    ]).asObservable(),
                                                        willDisplayLastCell: scheduler.createHotObservable([
                                                            .next(20, ())
                                                        ]).asObservable())
                    
                    let output = sut.bind(input: input)
                    let states = scheduler.createObserver(PlanentsViewModel.State?.self)
                    output
                        .bind(to: states)
                        .disposed(by: disposeBag)
                    scheduler.start()
                    
                    expect(states.events) == [.next(10, PlanentsViewModel.State.loading)]
                }
                
                it("when nextURL fetched should updated state to fetched") {
                    let apiExpecation = self.expectation(description: "apiFetchNext")
                    let sut = PlanentsViewModel(with: useCase)
                    sut.nextUrl = "page=4"
                    let input = PlanentsViewModel.Input(didLoad: scheduler.createHotObservable([
                        .next(10, ())
                    ]).asObservable(),
                                                        willDisplayLastCell: scheduler.createHotObservable([
                                                            .next(20, ())
                                                        ]).asObservable())
                    
                    let output = sut.bind(input: input)
                    let states = scheduler.createObserver(PlanentsViewModel.State?.self)
                    scheduler.advanceTo(20)
                    output.do(onNext: { statee in
                        switch statee {
                        case .nextLoaded:
                            apiExpecation.fulfill()
                        default:break
                        }
                    })
                    .bind(to: states)
                        .disposed(by: disposeBag)
                        scheduler.start()
                        
                    self.wait(for: [apiExpecation], timeout: 1)
                        expect(states.events.last) == .next(20, PlanentsViewModel.State.nextLoaded([]))
                }
            }
        }
    }
}

extension PlanentsViewModel.State: Equatable {
    public static func == (lhs: PlanentsViewModel.State, rhs: PlanentsViewModel.State) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading),
            (.loaded, .loaded),
            (.nextLoaded, .nextLoaded),
            (.failed, .failed):
            return true
        default:
            return false
        }
    }
}
