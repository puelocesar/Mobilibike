//
//  RegisterForm.h
//  MobiliBike
//
//  Created by Paulo Cesar on 14/01/17.
//  Copyright © 2017 Paulo Cesar. All rights reserved.
//

#import <FXForms/FXForms.h>

@interface RegisterForm : NSObject <FXForm>

@property NSString* fullName;
@property NSString* email;
@property NSString* password;
@property NSString* confirmPassword;

@property NSString* CEP;
@property NSString* CNPJ;
@property NSString* city;
@property NSString* state;

@property NSString* about;

@property NSString* ownerFirstName;
@property NSString* ownerLastName;
@property NSString* ownerPhoneNumber;
@property NSString* ownerCPF;
@property NSString* ownerRG;
@property NSDate* ownerBirthday;

@end


