//
//  ObservableTest.swift
//  StarWarsPlannetTests
//
//  Created by Krishantha Sunil Premaretna on 2022-10-23.
//

import XCTest
import Quick
import Nimble
import RxTest
import RxSwift
@testable import StarWarsPlannet

class ObservableTest: QuickSpec {
    override func spec() {
        describe("Observable extension") {
            context("unwrapped") {
                it("should return non nil sequence") {
                    let scheduler = TestScheduler(initialClock: 0)
                    let unwrappedStringObserver = scheduler.createObserver(String.self)
                    
                    _ = Observable
                        .from(["abc", nil, "def", "4"])
                        .unwrapped()
                        .subscribe(unwrappedStringObserver)
            
                    expect(unwrappedStringObserver.events.count) == 4
                    
                    let correctValues = Recorded.events([
                                .next(0, "abc"),
                                .next(0, "def"),
                                .next(0, "4"),
                                .completed(0)
                            ])
                    expect(unwrappedStringObserver.events) == correctValues
                }
            }
        }
    }
}
