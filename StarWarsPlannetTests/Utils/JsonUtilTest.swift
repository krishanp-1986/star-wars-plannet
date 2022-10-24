//
//  JsonUtilTest.swift
//  StarWarsPlannetTests
//
//  Created by Krishantha Sunil Premaretna on 2022-10-23.
//

import XCTest
import Quick
import Nimble
@testable import StarWarsPlannet

class JsonUtilsTests: QuickSpec {
  private let bundle = Bundle(for: JsonUtilsTests.self)
  override func spec() {
    describe("json utility") {
      context("for valid json") {
        it("should convert into decodable") {
          let decoded = JsonUtils.convertJsonIntoDecodable([String: String].self,
                                                           fileName: "valid",
                                                           bundle: self.bundle, inDirectory: "TestResponse")
          expect(decoded).toNot(beNil())
          expect(decoded?.keys.count) == 2
        }
      }
      
      context("for valid json file") {
        it("should return planets response dto") {
          let decoded = JsonUtils.convertJsonIntoDecodable(PlanetsResponse.self,
                                                           fileName: "planets",
                                                           bundle: self.bundle,
                                                           inDirectory: "TestResponse")
          expect(decoded).toNot(beNil())
        }
      }
      
      
      context("for empty json") {
        it("should convert into decodable ") {
          let decoded = JsonUtils.convertJsonIntoDecodable([String: String].self,
                                                           fileName: "empty",
                                                           bundle: self.bundle, inDirectory: "TestResponse")
          expect(decoded).toNot(beNil())
          expect(decoded?.keys).to(beEmpty())
        }
      }
      
      context("for invalid json") {
        it("should return nil") {
          let decoded = JsonUtils.convertJsonIntoDecodable([String: String].self,
                                                           fileName: "invalid",
                                                           bundle: self.bundle, inDirectory: "TestResponse")
          expect(decoded).to(beNil())
        }
      }
      
    }
  }
}
