//
//  PlanetsUseCaseTest.swift
//  StarWarsPlannetTests
//
//  Created by Krishantha Sunil Premaretna on 2022-10-23.
//

import XCTest
import Quick
import Nimble
import RxSwift
@testable import StarWarsPlannet

class PlanetsUseCaseTest: QuickSpec {
    override func spec() {
        describe("Planets Usecase") {
            var mockAgent: TestNetworkAgent!
            var sut: StarWarsPlanetsService!
            let disposeBag: DisposeBag = .init()
            beforeEach {
                mockAgent = TestNetworkAgent()
                sut = StarWarsPlanetsService(with: mockAgent)
            }

            context("for successful request") {
                it("should return valid response") {
                    mockAgent.mockFileName = "planets"
                    sut.fetchPlanets(urlToFetch: nil).subscribe { response in
                        expect(response.results).toNot(beNil())
                        expect(response.count) == 60
                        expect(response.next).toNot(beNil())
                        expect(response.next) == "https://swapi.dev/api/planets/?page=2"
                        expect(response.previous).to(beNil())
                    } onFailure: { _ in
                        fail("Expected call to fetchPlanets to succeed with PlanetsResponse, but it failed with error")
                    }.disposed(by: disposeBag)
                    
                    
                }
            }
            
            context("for successful next page request") {
                it("should return valid response") {
                    mockAgent.mockFileName = "page=2"
                    sut.fetchPlanets(urlToFetch: "https://swapi.dev/api/planets/?page=2").subscribe { response in
                        expect(response.results).toNot(beNil())
                        expect(response.count) == 60
                        expect(response.next).toNot(beNil())
                        expect(response.next) == "https://swapi.dev/api/planets/?page=3"
                        expect(response.previous) == "https://swapi.dev/api/planets/?page=1"
                    } onFailure: { _ in
                        fail("Expected call to fetchPlanets to succeed with PlanetsResponse, but it failed with error")
                    }.disposed(by: disposeBag)
                }
            }
            
            context("for failed request") {
                it("should return ServiceError") {
                    mockAgent.mockFileName = "invalid"
                    sut.fetchPlanets(urlToFetch: "https://swapi.dev/api/planets/?page=2").subscribe { _ in
                        fail("Expected call to fetchRecipes to fail with error, but it succeeded")
                    } onFailure: { error in
                        expect(error).notTo(beNil())
                    }.disposed(by: disposeBag)
                }
            }
        }
    }
}

extension PlanetsResponse: Equatable {
    public static func == (lhs: PlanetsResponse, rhs: PlanetsResponse) -> Bool {
        lhs.count == rhs.count
        && lhs.next == rhs.next
        && lhs.previous == rhs.previous
        && lhs.results.count == rhs.results.count
    }
}
