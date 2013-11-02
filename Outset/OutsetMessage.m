//
//  OutsetMessage.m
//  Outset
//
//  Created by Jeremy Tregunna on 11/1/2013.
//  Copyright (c) 2013 Jeremy Tregunna. All rights reserved.
//

#import "OutsetMessage.h"

NSString* const OutsetMessagePayloadKeyWhoami = @"whoami";
NSString* const OutsetMessagePayloadKeyKey    = @"key";
NSString* const OutsetMessagePayloadKeyValue  = @"value";

@interface OutsetMessage ()
@property (nonatomic)         OutsetMessageType type;
@property (nonatomic, strong) NSUUID*           identifier;
@property (nonatomic, copy)   NSDictionary*     payload;
@end

@implementation OutsetMessage

+ (instancetype)messageOfType:(OutsetMessageType)type payload:(NSDictionary*)dictionary
{
    if(type < OutsetMessageTypeArrival || type > OutsetMessageTypePut)
        return nil;

    OutsetMessage* msg = [[self alloc] init];
    msg.type       = type;
    msg.identifier = [NSUUID UUID];
    msg.payload    = [dictionary copy];
    return msg;
}

@end
