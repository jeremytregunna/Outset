//
//  OutsetFingerTableTests.m
//  Outset
//
//  Created by Jeremy Tregunna on 10/31/2013.
//  Copyright (c) 2013 Jeremy Tregunna. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "OutsetFingerTable.h"

@interface OutsetFingerTableTests : XCTestCase

@end

@implementation OutsetFingerTableTests

- (void)testCreatesWithCapacity
{
    OutsetFingerTable* table = [[OutsetFingerTable alloc] initWithCapacity:9];
    XCTAssertNotNil(table, @"Must return a valid instance");
    XCTAssertTrue(table.capacity == 9, @"Capacity must be set properly");
}

- (void)testAddingObjectAndRetrievingIt
{
    OutsetFingerTable* table = [[OutsetFingerTable alloc] initWithCapacity:9];
    XCTAssertTrue([table addObject:@1], @"Must succeed in adding");
    XCTAssertEqualObjects([table objectAtIndex:0], @1, @"Object pulled out must equal the object put in");
}

- (void)testFillingTableAndBeingUnableToAddMore
{
    OutsetFingerTable* table = [[OutsetFingerTable alloc] initWithCapacity:1];
    XCTAssertTrue([table addObject:@1], @"Must succeed in adding");
    XCTAssertFalse([table addObject:@2], @"Must fail in adding too many items");
}

@end
