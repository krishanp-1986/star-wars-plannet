//
//  EndPointTest.swift
//  StarWarsPlannetTests
//
//  Created by Krishantha Sunil Premaretna on 2022-10-23.
//

import XCTest
import Quick
import Nimble
@testable import StarWarsPlannet

class EndPointTest: QuickSpec {
    override func spec() {
        describe("EndPoint") {
            context("For loading planets") {
                it("http method should be equal to GET") {
                    expect(EndPoint.loadPlanet(nil).request?.httpMethod) == "GET"
                }
                it("should return valid request") {
                    expect(EndPoint.loadPlanet(nil).request).toNot(beNil())
                    expect(EndPoint.loadPlanet(nil).request?.url?.absoluteString) == "https://swapi.dev/api/planets"
                }
            }
            context("For loading next page") {
                let nextPageUrl = "https://swapi.dev/api/planets/?page=3"
                it("http method should be equal to GET") {
                    expect(EndPoint.loadPlanet(nextPageUrl).request?.httpMethod) == "GET"
                }
                it("should return valid request") {
                    expect(EndPoint.loadPlanet(nextPageUrl).request).toNot(beNil())
                    expect(EndPoint.loadPlanet(nextPageUrl).request?.url?.absoluteString) == "https://swapi.dev/api/planets/?page=3"
                }
            }
        }
    }
}
