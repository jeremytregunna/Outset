//
//  OutsetNode.h
//  Outset
//
//  Created by Jeremy Tregunna on 10/30/2013.
//  Copyright (c) 2013 Jeremy Tregunna. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef uint32_t OutsetNodeID;

@interface OutsetNode : NSObject
@property (nonatomic) OutsetNodeID identifier;

- (id)init NS_UNAVAILABLE;
- (instancetype)initWithID:(OutsetNodeID)identifier;

- (id<NSCoding>)objectForKey:(NSString*)key;
- (void)setObject:(id<NSCoding>)object forKey:(NSString*)key;

- (void)joinAfterNode:(OutsetNode*)node;
- (void)leave;

@end
