//
//  AuthInfo.h
//  MobiliBike
//
//  Created by Paulo Cesar on 14/01/17.
//  Copyright © 2017 Paulo Cesar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AuthInfo : NSObject

+(NSString*)token;
+(void)updateToken:(NSString*)token type:(NSString*)type expiration:(NSDate*)expirationDate;
+(void)clearToken;

@end
