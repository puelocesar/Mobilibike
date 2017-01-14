//
//  LoginController.m
//  MobiliBike
//
//  Created by Paulo Cesar on 14/01/17.
//  Copyright © 2017 Paulo Cesar. All rights reserved.
//

#import "LoginController.h"
#import "LoginForm.h"
#import "BikeService.h"
#import "AuthInfo.h"
#import "UIViewController+AlertUtil.h"

@implementation LoginController {
    FXFormController *formController;
    LoginForm* form;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    form = [[LoginForm alloc] init];
    
    formController = [[FXFormController alloc] init];
    formController.tableView = self.tableView;
    formController.delegate = self;
    formController.form = form;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)login:(UITableViewCell<FXFormFieldCell> *)cell {
    
    NSMutableArray* errors = [[NSMutableArray alloc] init];
    
    if (!form.client_id || [form.client_id isEqualToString:@""]) {
        [errors addObject:@"Email não pode estar vazio"];
    }
    
    if (!form.client_secret || [form.client_secret length] < 6) {
        [errors addObject:@"Senha inválida"];
    }
    
    if (errors.count > 0) {
        [self showAlertWithMessage:[errors componentsJoinedByString:@"\n"]];
        return;
    }
    
    [BikeService loginWithEmail:form.client_id password:form.client_secret completionHandler:^(NSString *token, NSString *tokenType, NSDate *expirationDate, NSError *error) {
        
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
