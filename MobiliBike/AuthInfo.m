//
//  AuthInfo.m
//  MobiliBike
//
//  Created by Paulo Cesar on 14/01/17.
//  Copyright © 2017 Paulo Cesar. All rights reserved.
//

#import "AuthInfo.h"

@implementation AuthInfo

+ (AuthInfo *)sharedInstance
{
    static AuthInfo * sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[AuthInfo alloc] init];
        [sharedInstance setup];
    });
    return sharedInstance;
}

-(void)setup {
    self.expirationDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"expirationDate"];
    
    if ([self.expirationDate compare:[[NSDate alloc] init]] == NSOrderedAscending) {
        [self clearToken];
    }
    else {
        self.token = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
        self.email = [[NSUserDefaults standardUserDefaults] stringForKey:@"email"];
        self.companyId = [[NSUserDefaults standardUserDefaults] stringForKey:@"companyId"];
    }
}

-(void)updateCompanyInfo:(NSString*)companyId email:(NSString*)email {
    self.companyId = companyId;
    self.email = email;
    
    [self syncData];
}

-(void)updateToken:(NSString *)token type:(NSString *)type expiration:(NSDate *)expirationDate {
    self.token = [NSString stringWithFormat:@"%@ %@", type, token];
    self.expirationDate = expirationDate;
    
    [self syncData];
}

-(void)clearToken {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"companyId"];
    [defaults removeObjectForKey:@"email"];
    [defaults removeObjectForKey:@"token"];
    [defaults removeObjectForKey:@"expirationDate"];
    [defaults synchronize];
}

-(void)syncData {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.companyId forKey:@"companyId"];
    [defaults setObject:self.email forKey:@"email"];
    [defaults setObject:self.token forKey:@"token"];
    [defaults setObject:self.expirationDate forKey:@"expirationDate"];
    [defaults synchronize];
}

@end
