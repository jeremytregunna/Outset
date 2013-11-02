//
//  OutsetMessage.h
//  Outset
//
//  Created by Jeremy Tregunna on 11/1/2013.
//  Copyright (c) 2013 Jeremy Tregunna. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, OutsetMessageType)
{
    OutsetMessageTypeArrival = 1,
    OutsetMessageTypeLeave,
    OutsetMessageTypeGet,
    OutsetMessageTypePut,
};

extern NSString* const OutsetMessagePayloadKeyWhoami;
extern NSString* const OutsetMessagePayloadKeyKey;
extern NSString* const OutsetMessagePayloadKeyValue;

@interface OutsetMessage : NSObject
@property (nonatomic, readonly)         OutsetMessageType type;
@property (nonatomic, readonly, strong) NSUUID*           identifier;
@property (nonatomic, readonly, copy)   NSDictionary*     payload;

+ (instancetype)messageOfType:(OutsetMessageType)type payload:(NSDictionary*)dictionary;

@end
