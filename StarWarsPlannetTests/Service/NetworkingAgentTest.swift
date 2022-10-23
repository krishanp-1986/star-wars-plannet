//
//  NetworkingAgentTest.swift
//  StarWarsPlannetTests
//
//  Created by Krishantha Sunil Premaretna on 2022-10-23.
//

import XCTest
import Quick
import Nimble
import RxSwift
@testable import StarWarsPlannet

class NetworkAgentTests: QuickSpec {
    private let disposeBag: DisposeBag = .init()
    
    private struct MockDecodable: Codable {
        let mockInt: Int
    }
    
    private func mockCall(_ dataProvider: DataProvider, request: URLRequest) -> Single<MockDecodable> {
        dataProvider.execute(request)
    }
    
    override func spec() {
        describe("NetowrkAgent") {
            var sut: DataProvider!
            var request: URLRequest!
            
            beforeEach {
                URLProtocol.registerClass(TestURLProtocol.self)
                sut = NetworkAgent()
                request = URLRequest(url: URL(string: "test-url")!)
            }
            
            context("For response error") {
                it("Should return ServiceError.generalError") {
                    let errorCode = -1000
                    let domain = "com.hellofresh.error.domain"
                    let error = NSError(domain: domain, code: errorCode, userInfo: nil)
                    
                    TestURLProtocol.loadingHandler = { request in
                        let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
                        return (response, .init(), error)
                    }
                    
                    self.mockCall(sut, request: request).subscribe { decodable in
                        fail("Expected call to execute to fail, but it succeeded")
                    } onFailure: { error in
                        let serviceError = error as? ServiceError
                        expect(serviceError).toNot(beNil())
                        expect(serviceError?.errorDescription).to(equal(error.localizedDescription))
                        expect(serviceError).to(equal(ServiceError.generalError(error)))
                        
                        switch serviceError {
                        case .generalError(let customError):
                            expect((customError as NSError).code).to(equal(errorCode))
                            expect((customError as NSError).domain).to(equal(domain))
                        default:
                            fail("Expected general Error with error code \(errorCode) , but got different service error")
                        }
                    }.disposed(by: self.disposeBag)
                }
            }
            
            context("For failed response") {
                it("Should return ServiceError.invalidResponse") {
                    
                    TestURLProtocol.loadingHandler = { _ in
                        return (nil, .init(), nil)
                    }
                    
                    self.mockCall(sut, request: request).subscribe { decodable in
                        fail("Expected call to execute to fail, but it succedded")
                    } onFailure: { error in
                        let serviceError = error as? ServiceError
                        expect(serviceError?.errorDescription).to(equal("Invalid Response"))
                        expect(serviceError).to(equal(ServiceError.invalidResponse))
                    }.disposed(by: self.disposeBag)
                }
            }
            
            context("For non successful response code") {
                it("should return ServiceError.unSuccessfulResponse") {
                    let invalidResponseCode = 500
                    
                    TestURLProtocol.loadingHandler = { request in
                        let response = HTTPURLResponse(url: request.url!, statusCode: invalidResponseCode, httpVersion: nil, headerFields: nil)!
                        return (response, .init(), nil)
                    }
                    
                    self.mockCall(sut, request: request).subscribe { decodable in
                        fail("Expected call to execute to fail, but it succeeded")
                    } onFailure: { error in
                        let serviceError = error as? ServiceError
                        expect(serviceError?.errorDescription).to(equal("Server replied with errorCode : 500"))
                        expect(serviceError).to(equal(ServiceError.unSuccessfulResponse(500)))
                    }.disposed(by: self.disposeBag)
                }
            }
            
            context("For invalid data") {
                it("Should return ServiceError.inValidData") {
                    
                    TestURLProtocol.loadingHandler = { request in
                        let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
                        return (response, .init(), nil)
                    }
                    self.mockCall(sut, request: request).subscribe { decodable in
                        fail("Expected call to execute to fail, but it succeeded")
                    } onFailure: { error in
                        let serviceError = error as? ServiceError
                        expect(serviceError?.errorDescription).to(equal("Server failed to return Data"))
                        expect(serviceError).to(equal(ServiceError.inValidData))
                    }.disposed(by: self.disposeBag)
                }
            }
            
            context("For invalid decodable data") {
                it("Should return ServiceError.generalError") {
                    TestURLProtocol.loadingHandler = { request in
                        let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
                        let data = "{}".data(using: .utf8)
                        return (response, data, nil)
                    }
                    self.mockCall(sut, request: request).subscribe { decodable in
                        fail("Expected call to execute to fail, but it succeeded")
                    } onFailure: { error in
                        let serviceError = error as? ServiceError
                        expect(serviceError?.errorDescription).to(equal(error.localizedDescription))
                        expect(serviceError).to(equal(ServiceError.generalError(error)))
                    }.disposed(by: self.disposeBag)
                }
            }
            
            context("For valid response") {
                it("Should return Decodable object successfully") {
                    let encodable = MockDecodable(mockInt: 1)
                    
                    TestURLProtocol.loadingHandler = { request in
                        let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
                        
                        let data = try? JSONEncoder().encode(encodable)
                        return (response, data, nil)
                    }
                    
                    self.mockCall(sut, request: request).subscribe { mockObject in
                        expect(mockObject).toNot(beNil())
                        let mockInt = mockObject.mockInt
                        expect(mockInt) == encodable.mockInt
                    } onFailure: { _ in
                        fail("Expected call to execute to success, but it succeeded")
                    }.disposed(by: self.disposeBag)
                }
            }
        }
    }
}
