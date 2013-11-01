//
//  OutsetNodeTests.m
//  Outset
//
//  Created by Jeremy Tregunna on 10/31/2013.
//  Copyright (c) 2013 Jeremy Tregunna. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "OutsetNode.h"
#import "OutsetFingerTable.h"

@interface OutsetNode (PrivateMethods)
@property (nonatomic, strong) NSMutableDictionary* storage;
@property (nonatomic, strong) OutsetFingerTable*   fingerTable;
@property (nonatomic, strong) OutsetNode*          next;
@property (nonatomic, weak)   OutsetNode*          previous;
@end

@interface OutsetNodeTests : XCTestCase
@property (nonatomic, strong) OutsetNode* bootstrap;
@end

@implementation OutsetNodeTests

- (void)setUp
{
    [super setUp];

    self.bootstrap = [[OutsetNode alloc] initWithID:1];
}

- (void)testBootstrapNextIsItselfWhenCreatedWithoutAnExplicitNextNode
{
    XCTAssertNotNil(self.bootstrap, @"Must be able to create a node with not linked to anything.");
    XCTAssertEqualObjects(self.bootstrap.next, self.bootstrap, @"Next object should be equal to itself");
}

- (void)testCircularRingWithMoreThanOneNode
{
    OutsetNode* second = [[OutsetNode alloc] initWithID:2];
    OutsetNode* third  = [[OutsetNode alloc] initWithID:3];
    [second joinAfterNode:self.bootstrap];
    [third joinAfterNode:second];

    XCTAssertEqualObjects(self.bootstrap.next, second, @"Next object must be second");
    XCTAssertEqualObjects(self.bootstrap.previous, third, @"Previous object must be third");
    XCTAssertEqualObjects(self.bootstrap, second.previous, @"Previous object must be bootstrap");
    XCTAssertEqualObjects(self.bootstrap, third.next, @"Next object must be bootstrap");
    XCTAssertEqualObjects(second.next, third, @"Next object must be third");
    XCTAssertEqualObjects(third.previous, second, @"Previous must be second");
    XCTAssertEqualObjects(third.next, self.bootstrap, @"Next object must be third");
}

- (void)testCircularRingAfterOneNodeLeaves
{
    OutsetNode* second = [[OutsetNode alloc] initWithID:2];
    OutsetNode* third  = [[OutsetNode alloc] initWithID:3];
    [second joinAfterNode:self.bootstrap];
    [third joinAfterNode:second];

    XCTAssertEqualObjects(self.bootstrap.next, second, @"Next object must be second");
    XCTAssertEqualObjects(second.next, third, @"Next object must be third");

    [second leave];

    XCTAssertEqualObjects(self.bootstrap.next, third, @"Next object must be third");
    XCTAssertEqualObjects(self.bootstrap.previous, third, @"Previous object must be third");
    XCTAssertEqualObjects(third.next, self.bootstrap, @"Next object must be bootstrap");
    XCTAssertEqualObjects(third.previous, self.bootstrap, @"Previous object must be bootstrap");
}

- (void)testStoringAndFindingAValue
{
    [self.bootstrap setObject:@42 forKey:@"forty-two"];
    XCTAssertEqualObjects(self.bootstrap.storage[@"forty-two"], @42, @"Value must have been stored properly");
}

- (void)testStoringAndNotFindingAnInvalidKey
{
    [self.bootstrap setObject:@42 forKey:@"forty-two"];
    XCTAssertNil(self.bootstrap.storage[@"dummy"], @"Must return nil");
}

- (void)testLookingUpAStoredValue
{
    [self.bootstrap setObject:@42 forKey:@"forty-two"];
    XCTAssertEqualObjects([self.bootstrap objectForKey:@"forty-two"], @42, @"Must return the proper value");
}

- (void)testLookingUpAStoredValueOnARemoteNode
{
    OutsetNode* second = [[OutsetNode alloc] initWithID:2];
    [second joinAfterNode:self.bootstrap];

    [second setObject:@42 forKey:@"forty-two"];

    XCTAssertEqualObjects([self.bootstrap objectForKey:@"forty-two"], @42, @"Must return the proper value");
}

- (void)testLookingUpAStoredValueOnAReallyRemoteNode
{
    OutsetNode* second = [[OutsetNode alloc] initWithID:(OutsetNodeID)[@"2" hash]];
    OutsetNode* third  = [[OutsetNode alloc] initWithID:(OutsetNodeID)[@"3" hash]];
    OutsetNode* fourth = [[OutsetNode alloc] initWithID:(OutsetNodeID)[@"4" hash]];
    OutsetNode* fifth  = [[OutsetNode alloc] initWithID:(OutsetNodeID)[@"5" hash]];
    [second joinAfterNode:self.bootstrap];
    [third joinAfterNode:second];
    [fourth joinAfterNode:third];
    [fifth joinAfterNode:fourth];

    [fourth setObject:@42 forKey:@"forty-two"];

    XCTAssertEqualObjects([second objectForKey:@"forty-two"], @42, @"Must return the proper value from a really remote object");
}

- (void)testRetrievingMultipleValues
{
    OutsetNode* second = [[OutsetNode alloc] initWithID:2];
    OutsetNode* third  = [[OutsetNode alloc] initWithID:3];
    [second joinAfterNode:self.bootstrap];
    [third joinAfterNode:second];

    [second setObject:@42 forKey:@"forty-two"];
    [third setObject:@23 forKey:@"twenty-three"];

    XCTAssertEqualObjects([self.bootstrap objectForKey:@"forty-two"], @42, @"Must retrieve the proper value for key forty-two");
    XCTAssertEqualObjects([self.bootstrap objectForKey:@"twenty-three"], @23, @"Must retrieve the proper value for key twenty-three");
}

@end
