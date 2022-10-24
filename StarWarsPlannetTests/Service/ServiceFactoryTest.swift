//
//  ServiceFactoryTest.swift
//  StarWarsPlannetTests
//
//  Created by Krishantha Sunil Premaretna on 2022-10-23.
//

import XCTest
import Quick
import Nimble
@testable import StarWarsPlannet

class ServiceFactoryTests: QuickSpec {
  struct MockUseCase: Service {
    var dataProvider: DataProvider! = MockNetworkAgent()
    let isCreated: Bool = true
  }
  
  override func spec() {
    describe("service factory") {
      context("for valid service type") {
        it("should return valid usecase") {
          let planetsUseCase = ServiceFactory.useCaseFor(StarWarsPlanetsService.self)
          expect(planetsUseCase).toNot(beNil())
          
          let mockUseCase = ServiceFactory.useCaseFor(MockUseCase.self)
          expect(mockUseCase).toNot(beNil())
          expect(mockUseCase.isCreated).to(beTrue())
        }
      }
    }
  }
}
