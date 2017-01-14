//
//  AuthInfo.m
//  MobiliBike
//
//  Created by Paulo Cesar on 14/01/17.
//  Copyright © 2017 Paulo Cesar. All rights reserved.
//

#import "AuthInfo.h"

@implementation AuthInfo

+(NSString*)token {
    NSDate* expirationDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"expirationDate"];
    
    if ([expirationDate compare:[[NSDate alloc] init]] == NSOrderedAscending) {
        [self clearToken];
        return nil;
    }
    else
        return [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
}

+(void)updateToken:(NSString *)token type:(NSString *)type expiration:(NSDate *)expirationDate {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSString stringWithFormat:@"%@ %@", type, token] forKey:@"token"];
    [defaults setObject:expirationDate forKey:@"expirationDate"];
    [defaults synchronize];
}

+(void)clearToken {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:nil forKey:@"token"];
    [defaults setObject:nil forKey:@"expirationDate"];
    [defaults synchronize];
}

@end
