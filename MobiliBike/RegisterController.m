//
//  RegisterController.m
//  MobiliBike
//
//  Created by Paulo Cesar on 14/01/17.
//  Copyright © 2017 Paulo Cesar. All rights reserved.
//

#import "RegisterController.h"
#import "RegisterForm.h"
#import "UIViewController+AlertUtil.h"
#import "BikeService.h"
#import "AuthInfo.h"

@implementation RegisterController {
    FXFormController *formController;
    RegisterForm* form;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    form = [[RegisterForm alloc] init];
    
    formController = [[FXFormController alloc] init];
    formController.tableView = self.tableView;
    formController.delegate = self;
    formController.form = form;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)registerUser:(UITableViewCell<FXFormFieldCell> *)cell {
    
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    
    //dinamically get params from fxforms
    //too many of them to type manually...
    
    for (int i=0; i<formController.numberOfSections; i++) {
        for (int j=0; j<[formController numberOfFieldsInSection:i]; j++) {
            FXFormField* field = [formController fieldForIndexPath:[NSIndexPath indexPathForRow:j inSection:i]];
            
            if ([form respondsToSelector:NSSelectorFromString(field.key)]) {
                id value = [form performSelector:NSSelectorFromString(field.key)];
            
                if (value != nil) {
                    if ([value isKindOfClass:[NSDate class]]) {
                        NSDate* date = (NSDate*)value;
                        
                        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                        [dateFormatter setDateFormat:@"dd/MM/yyyy"];
                        
                        [params setObject:[dateFormatter stringFromDate:date] forKey:field.key];
                        [params setObject:[dateFormatter stringFromDate:date] forKey:@"birthday"];
                    }
                    else
                        [params setObject:value forKey:field.key];
                }
            }
        }
    }
    
    [BikeService registerWithParams:params completionHandler:^(NSString *token, NSString *tokenType, NSDate *expirationDate, NSError *error) {
        if (error) {
            [self showAlertWithMessage:error.localizedDescription];
        }
        else {
            [AuthInfo updateToken:token type:tokenType expiration:expirationDate];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            });
        }
    }];
}

@end
