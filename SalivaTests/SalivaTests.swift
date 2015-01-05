//
//  SalivaTests.swift
//  SalivaTests
//
//  Created by Ben Taylor on 11/12/2014.
//  Copyright (c) 2014 Ben Taylor. All rights reserved.
//

import UIKit
import XCTest
import Saliva

class SalivaTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testSimpleBindingCase() {
		let expectation = expectationWithDescription("Simple Binding")
		var a: Int = 0
		
		bind(from: { 10 }, to: { (value: Int) in
			a = value
			expectation.fulfill()
		})
		
		
		NSOperationQueue().addOperationWithBlock { () -> Void in
			sharedBindingCollection.handleDisplayLinkTick()
		}
		
		waitForExpectationsWithTimeout(5.0, handler: { (error: NSError!) in
			XCTAssert(a == 10, "Binding should have updated values")
		})
    }
    
}
