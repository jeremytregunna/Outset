//
//  OutsetFingerTable.m
//  Outset
//
//  Created by Jeremy Tregunna on 10/30/2013.
//  Copyright (c) 2013 Jeremy Tregunna. All rights reserved.
//

#import "OutsetFingerTable.h"

@implementation OutsetFingerTable
{
    id __weak* _data;
    NSUInteger _currentIndex;
}

- (instancetype)initWithCapacity:(NSUInteger)capacity
{
    if((self = [super init]))
    {
        _capacity = capacity;
        _data = (id __weak*)calloc(sizeof(id), sizeof(id) * _capacity);
        _currentIndex = 0;
    }
    return self;
}

- (void)dealloc
{
    // For ARC
    for(NSUInteger i = 0; i < _capacity; ++i)
        _data[i] = 0;
    free(_data);
}

#pragma mark - Operations

- (BOOL)addObject:(id)object
{
    if(_currentIndex >= _capacity)
        return NO;
    
    @synchronized(self)
    {
        _data[_currentIndex] = object;
        _currentIndex++;
    }

    return YES;
}

- (BOOL)setObject:(id)object atIndex:(NSUInteger)idx
{
    if(idx >= _capacity)
        return NO;

    @synchronized(self)
    {
        _data[idx] = object;
    }

    return YES;
}

- (id)objectAtIndex:(NSUInteger)index
{
    NSAssert(index < _capacity, @"Out of bounds");
    return _data[index];
}

@end
