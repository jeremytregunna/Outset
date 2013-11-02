//
//  OutsetMessageTests.m
//  Outset
//
//  Created by Jeremy Tregunna on 11/1/2013.
//  Copyright (c) 2013 Jeremy Tregunna. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "OutsetMessage.h"

@interface OutsetMessageTests : XCTestCase

@end

@implementation OutsetMessageTests

- (void)testCanCreateASimpleMessage
{
    OutsetMessage* msg = [OutsetMessage messageOfType:OutsetMessageTypeLeave payload:nil];
    XCTAssertEqualObjects([msg class], [OutsetMessage class], @"Must return a valid instance");
}

- (void)testCannotCreateInvalidMessage
{
    OutsetMessage* msg = [OutsetMessage messageOfType:0 payload:nil];
    XCTAssertNil(msg, @"Invalid messages must be nil");
}

- (void)testMessageHasAUUID
{
    OutsetMessage* msg = [OutsetMessage messageOfType:OutsetMessageTypeArrival payload:nil];
    XCTAssertTrue([msg.identifier isKindOfClass:[NSUUID class]], @"Must have a message identifier");
}

- (void)testPayloadTypesAreValid
{
    XCTAssertEqualObjects(OutsetMessagePayloadKeyWhoami, @"whoami", @"Key for whoami message payload is whoami");
    XCTAssertEqualObjects(OutsetMessagePayloadKeyKey, @"key", @"Key for key message payload is key");
    XCTAssertEqualObjects(OutsetMessagePayloadKeyValue, @"value", @"Key for value message payload is value");
}

- (void)testTypeIsArrival
{
    OutsetMessage* msg = [OutsetMessage messageOfType:OutsetMessageTypeArrival payload:@{
        OutsetMessagePayloadKeyWhoami: @"127.0.0.1"
    }];
    XCTAssertEqual(msg.type, OutsetMessageTypeArrival, @"Type must be arrival");
    XCTAssertEqualObjects(msg.payload[OutsetMessagePayloadKeyWhoami], @"127.0.0.1", @"Must have a whoami payload attribute");
}

- (void)testTypeIsLeave
{
    OutsetMessage* msg = [OutsetMessage messageOfType:OutsetMessageTypeLeave payload:@{
        OutsetMessagePayloadKeyWhoami: @"127.0.0.1"
    }];
    XCTAssertEqual(msg.type, OutsetMessageTypeLeave, @"Type must be leave");
    XCTAssertEqualObjects(msg.payload[OutsetMessagePayloadKeyWhoami], @"127.0.0.1", @"Must have a whoami payload attribute");
}

- (void)testTypeIsGet
{
    OutsetMessage* msg = [OutsetMessage messageOfType:OutsetMessageTypeGet payload:@{
        OutsetMessagePayloadKeyWhoami: @"127.0.0.1",
        OutsetMessagePayloadKeyKey   : @"test"
    }];
    XCTAssertEqual(msg.type, OutsetMessageTypeGet, @"Type must be get");
    XCTAssertEqualObjects(msg.payload[OutsetMessagePayloadKeyWhoami], @"127.0.0.1", @"Must have a whoami payload attribute");
    XCTAssertEqualObjects(msg.payload[OutsetMessagePayloadKeyKey], @"test", @"Key must be test");
}

- (void)testTypeIsPut
{
    OutsetMessage* msg = [OutsetMessage messageOfType:OutsetMessageTypePut payload:@{
        OutsetMessagePayloadKeyWhoami: @"127.0.0.1",
        OutsetMessagePayloadKeyKey   : @"test",
        OutsetMessagePayloadKeyValue : @"abc123"
    }];
    XCTAssertEqual(msg.type, OutsetMessageTypePut, @"Type must be put");
    XCTAssertEqualObjects(msg.payload[OutsetMessagePayloadKeyWhoami], @"127.0.0.1", @"Must have a whoami payload attribute");
    XCTAssertEqualObjects(msg.payload[OutsetMessagePayloadKeyKey], @"test", @"Key must be test");
    XCTAssertEqualObjects(msg.payload[OutsetMessagePayloadKeyValue], @"abc123", @"Value must be abc123");
}

@end
