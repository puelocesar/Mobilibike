//
//  BikeService.m
//  MobiliBike
//
//  Created by Paulo Cesar on 14/01/17.
//  Copyright © 2017 Paulo Cesar. All rights reserved.
//

#import "BikeService.h"
#import <AFNetworking/AFNetworking.h>
#import "AuthInfo.h"

@implementation BikeService

+(void)executeRequest:(NSURLRequest*)request completionHandler:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completeBlock {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:completeBlock];
    [dataTask resume];
}

+(void)loginWithEmail:(NSString *)email password:(NSString *)password completionHandler:(void (^)(NSString *, NSString *, NSDate *, NSError *))completeBlock {
    
    NSDictionary* params = @{ @"client_id": email,
                              @"client_secret": password,
                              @"grant_type": @"password" };
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:@"http://testemobilibike.azurewebsites.net/api/token" parameters:params error:nil];
    
    [self executeRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            @try {
                NSError *e = [NSError errorWithDomain:@"BikeService" code:142 userInfo:@{ NSLocalizedDescriptionKey: responseObject[@"error_description"]}];
                completeBlock(nil, nil, nil, e);
            }
            @catch (NSException *exception) {
                //uses default error message
                completeBlock(nil, nil, nil, error);
            }
        } else {
            @try {
                NSString* token = responseObject[@"access_token"];
                NSString* token_type = responseObject[@"token_type"];
                long expires_in = [responseObject[@"expires_in"] longValue];
                
                NSDate* expirationDate = [[[NSDate alloc] init] dateByAddingTimeInterval:expires_in];
                
                completeBlock(token, token_type, expirationDate, nil);
            }
            @catch (NSException *exception) {
                NSError *e = [NSError errorWithDomain:@"BikeService" code:142 userInfo:@{ NSLocalizedDescriptionKey: e.localizedDescription}];
                completeBlock(nil, nil, nil, e);
            }
        }
    }];
}

+(void)registerWithParams:(NSDictionary *)params completionHandler:(void (^)(NSString *, NSString *, NSDate *, NSError *))completeBlock {
    
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:@"http://testemobilibike.azurewebsites.net/api/company" parameters:params error:nil];
    
    [self executeRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            @try {
                NSMutableArray* modelErrors = [[NSMutableArray alloc] init];
                for (NSArray* modelError in [responseObject[@"modelState"] allValues]) {
                    for (NSString* mError in modelError) {
                        [modelErrors addObject:mError];
                    }
                }
                
                NSString* errorsMessage = [modelErrors componentsJoinedByString:@"\n"];
                NSError *e = [NSError errorWithDomain:@"BikeService" code:142 userInfo:@{ NSLocalizedDescriptionKey: errorsMessage}];
                completeBlock(nil, nil, nil, e);
            }
            @catch (NSException *exception) {
                //uses default error message
                completeBlock(nil, nil, nil, error);
            }
        } else {
            //tudo ok, vamos logar
            [self loginWithEmail:params[@"email"] password:params[@"password"] completionHandler:completeBlock];
        }
    }];
}

+(void)getCompanyInfoWithCompletionHandler:(void (^)(NSString *, NSString *, NSError *))completeBlock {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://testemobilibike.azurewebsites.net/api/company"]];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[AuthInfo sharedInstance].token forHTTPHeaderField:@"Authorization"];
    
    [self executeRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        
        if (error) {
            @try {
                NSError *e = [NSError errorWithDomain:@"BikeService" code:142 userInfo:@{ NSLocalizedDescriptionKey: responseObject[@"error_description"]}];
                completeBlock(nil, nil, e);
            }
            @catch (NSException *exception) {
                //uses default error message
                completeBlock(nil, nil, error);
            }
        } else {
            @try {
                completeBlock(responseObject[@"id"], responseObject[@"email"], nil);
            }
            @catch (NSException *exception) {
                NSError *e = [NSError errorWithDomain:@"BikeService" code:142 userInfo:@{ NSLocalizedDescriptionKey: e.localizedDescription}];
                completeBlock(nil, nil, e);
            }
        }
    }];
}

+(void)postRace:(NSDictionary *)params completionHandler:(void (^)(NSString *, NSError *))completeBlock {
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:@"http://testemobilibike.azurewebsites.net/api/race" parameters:params error:nil];
    
    [request addValue:[AuthInfo sharedInstance].token forHTTPHeaderField:@"Authorization"];
    
    [self executeRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            @try {
                NSMutableArray* modelErrors = [[NSMutableArray alloc] init];
                for (NSArray* modelError in [responseObject[@"modelState"] allValues]) {
                    for (NSString* mError in modelError) {
                        [modelErrors addObject:mError];
                    }
                }
                
                NSString* errorsMessage = [modelErrors componentsJoinedByString:@"\n"];
                NSError *e = [NSError errorWithDomain:@"BikeService" code:142 userInfo:@{ NSLocalizedDescriptionKey: errorsMessage}];
                completeBlock(nil, e);
            }
            @catch (NSException *exception) {
                //uses default error message
                completeBlock(nil, error);
            }
        } else {
            completeBlock(nil, nil);
        }
    }];
}

+(void)getPriceWithDistance:(int)distance completionHandler:(void (^)(NSNumber *, NSError *))completeBlock {
    
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%d", @"http://testemobilibike.azurewebsites.net/api/raceprice", distance]];
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    
    [self executeRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            @try {
                NSError *e = [NSError errorWithDomain:@"BikeService" code:142 userInfo:@{ NSLocalizedDescriptionKey: responseObject[@"error_description"]}];
                completeBlock(nil, e);
            }
            @catch (NSException *exception) {
                //uses default error message
                completeBlock(nil, error);
            }
        } else {
            @try {
                completeBlock(responseObject[@"price"], nil);
            }
            @catch (NSException *exception) {
                NSError *e = [NSError errorWithDomain:@"BikeService" code:142 userInfo:@{ NSLocalizedDescriptionKey: e.localizedDescription}];
                completeBlock(nil, e);
            }
        }
    }];
}

@end
