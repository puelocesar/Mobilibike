//
//  LoginForm.m
//  MobiliBike
//
//  Created by Paulo Cesar on 14/01/17.
//  Copyright © 2017 Paulo Cesar. All rights reserved.
//

#import "LoginForm.h"

@implementation LoginForm

-(NSArray *)fields {
    return @[ @"client_id", @"client_secret", @"login_button", @"sign_up_button" ];
}

- (NSDictionary *)client_idField {
    return @{ FXFormFieldHeader: @"Login",
              FXFormFieldTitle: @"Email",
              FXFormFieldType: @"email" };
}

- (NSDictionary *)client_secretField {
    return @{ FXFormFieldTitle: @"Senha",
              FXFormFieldType: @"password" };
}


- (NSDictionary *)login_buttonField {
    return @{ FXFormFieldHeader: @"",
              FXFormFieldTitle: @"Login",
              FXFormFieldAction: @"login:" };
}

- (NSDictionary *)sign_up_buttonField {
    return @{ FXFormFieldHeader: @"Ainda não tenho login",
              FXFormFieldTitle: @"Cadastrar-se",
              FXFormFieldSegue: @"sign_up" };
}

@end
