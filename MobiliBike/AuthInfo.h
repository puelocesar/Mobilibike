//
//  AuthInfo.h
//  MobiliBike
//
//  Created by Paulo Cesar on 14/01/17.
//  Copyright © 2017 Paulo Cesar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AuthInfo : NSObject

@property NSString* token;
@property NSString* email;
@property NSString* companyId;
@property NSDate* expirationDate;

+ (AuthInfo *)sharedInstance;

-(void)updateToken:(NSString*)token type:(NSString*)type expiration:(NSDate*)expirationDate;
-(void)updateCompanyInfo:(NSString*)companyId email:(NSString*)email;
-(void)clearToken;

@end
