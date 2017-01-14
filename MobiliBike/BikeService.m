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

@end
