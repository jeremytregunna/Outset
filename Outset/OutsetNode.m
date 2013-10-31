//
//  OutsetNode.m
//  Outset
//
//  Created by Jeremy Tregunna on 10/30/2013.
//  Copyright (c) 2013 Jeremy Tregunna. All rights reserved.
//

#import "OutsetNode.h"
#import "OutsetFingerTable.h"

// Must be a power of 2.
static NSUInteger OutsetFingerTableSpaceSize = 4;

static inline OutsetNodeID OutsetMaxID(void)
{
    return 1 << OutsetFingerTableSpaceSize;
}

static inline NSUInteger OutsetHashForKey(NSString* key)
{
    return [key hash] % OutsetMaxID();
}

@interface OutsetNode ()
@property (nonatomic, strong) NSMutableDictionary* storage;
@property (nonatomic, strong) OutsetFingerTable*   fingerTable;
@property (nonatomic, strong) OutsetNode*          next;
@property (nonatomic, weak)   OutsetNode*          previous;
@end

@implementation OutsetNode

- (instancetype)initWithID:(OutsetNodeID)identifier
{
    if((self = [super init]))
    {
        _identifier  = identifier;
        _next        = self;
        _previous    = self;
        _storage     = [NSMutableDictionary dictionary];
        _fingerTable = [[OutsetFingerTable alloc] initWithCapacity:OutsetFingerTableSpaceSize];
    }
    return self;
}

#pragma mark - Distance

- (NSUInteger)distanceFromKey:(NSUInteger)keyHash
{
    return keyHash ^ self.identifier;
}

#pragma mark - Looking up

- (OutsetNode*)nodeForKey:(NSString*)key
{
    OutsetNode* currentNode = self;
    for(NSUInteger i = 0; i < OutsetFingerTableSpaceSize; ++i)
    {
        OutsetNode* possibleNode = [self.fingerTable objectAtIndex:i];
        if(possibleNode == nil)
            continue;

        NSUInteger keyHash = OutsetHashForKey(key);
        if([currentNode distanceFromKey:keyHash] > [possibleNode distanceFromKey:keyHash])
            currentNode = possibleNode;
    }
    return currentNode;
}

- (id<NSCoding>)objectForKey:(NSString*)key
{
    OutsetNode* currentNode = [self nodeForKey:key];
    OutsetNode* nextNode    = [currentNode nodeForKey:key];
    NSUInteger  keyHash     = OutsetHashForKey(key);
    while([currentNode distanceFromKey:keyHash] > [nextNode distanceFromKey:keyHash])
    {
        currentNode = nextNode;
        nextNode    = [currentNode nodeForKey:key];
    }

    [currentNode update];
    return currentNode.storage[key];
}

#pragma mark - Storing

- (void)setObject:(id<NSCoding>)object forKey:(NSString*)key
{
    OutsetNode* node = [self nodeForKey:key];
    self.storage[key] = object;
    node.storage[key] = object;
}

#pragma mark - Updating

- (void)update
{
    for(NSUInteger i = 0; i < OutsetFingerTableSpaceSize; ++i)
    {
        OutsetNode* oldEntry = [self.fingerTable objectAtIndex:i];
        if(![oldEntry isEqual:self])
        {
            OutsetNode* node = [self _slowNodeForKey:self.identifier + (2 ^ i) % OutsetMaxID()];
            [self.fingerTable setObject:node atIndex:i];
        }
    }
}

#pragma mark - Joining/Leaving

- (void)joinAfterNode:(OutsetNode*)previous
{
    @synchronized(self)
    {
        __weak OutsetNode* oldNext = previous.next;
        previous.next        = self;
        self.next        = oldNext;
        self.previous    = previous;
        oldNext.previous = self;
        [previous update];
        [oldNext update];
        [self update];
    }
}

- (void)leave
{
    @synchronized(self)
    {
        OutsetNode* next = self.next;
        next.previous = self.previous;
        self.previous.next = next;
    }
}

#pragma mark - Private helpers

- (OutsetNode*)_slowNodeForKey:(NSUInteger)keyHash
{
    OutsetNode* currentNode = self;
    while(currentNode.next != nil && [currentNode distanceFromKey:keyHash] > [currentNode.next distanceFromKey:keyHash])
        currentNode = currentNode.next;
    return currentNode.next;
}

@end
