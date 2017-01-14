//
//  BikeService.h
//  MobiliBike
//
//  Created by Paulo Cesar on 14/01/17.
//  Copyright © 2017 Paulo Cesar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BikeService : NSObject

+(void)loginWithEmail:(NSString*)email password:(NSString*)password completionHandler:(void (^)(NSString* token, NSString* tokenType, NSDate* expirationDate, NSError *error))completeBlock;

+(void)registerWithParams:(NSDictionary*)params completionHandler:(void (^)(NSString* token, NSString* tokenType, NSDate* expirationDate, NSError *error))completeBlock;

@end
