//
//  OutsetFingerTable.h
//  Outset
//
//  Created by Jeremy Tregunna on 10/30/2013.
//  Copyright (c) 2013 Jeremy Tregunna. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OutsetFingerTable : NSObject
@property (nonatomic, readonly) NSUInteger capacity;

- (id)init NS_UNAVAILABLE;
- (instancetype)initWithCapacity:(NSUInteger)capacity;

- (BOOL)addObject:(id)object;
- (BOOL)setObject:(id)object atIndex:(NSUInteger)idx;
- (id)objectAtIndex:(NSUInteger)index;

@end
