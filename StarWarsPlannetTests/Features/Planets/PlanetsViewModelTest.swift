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
            beforeEach {
                scheduler = TestScheduler(initialClock: 0)
            }
            
            context("binding") {
                it("should return correct binding") {
                    let sut = PlanentsViewModel(with: MockPlanetUsecase())
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
                it("should return correct binding") {
                    let sut = PlanentsViewModel(with: MockPlanetUsecase())
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
                
                it("should fetch data for planets") {
                    let apiExpecation = self.expectation(description: "apifetch")
                    let sut = PlanentsViewModel(with: MockPlanetUsecase())
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
            }
            
            context("When view last cell displayed") {
                it("for nextUrl should start fetching next") {
                    let sut = PlanentsViewModel(with: MockPlanetUsecase())
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
                    let sut = PlanentsViewModel(with: MockPlanetUsecase())
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
