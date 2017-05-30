//
//  RegisterForm.m
//  MobiliBike
//
//  Created by Paulo Cesar on 14/01/17.
//  Copyright © 2017 Paulo Cesar. All rights reserved.
//

#import "RegisterForm.h"

@implementation RegisterForm

-(NSArray *)extraFields {
    return @[ @"registerUser" ];
}

-(NSDictionary*)emailField {
    return @{ FXFormFieldHeader: @"Login Information",
              FXFormFieldType: FXFormFieldTypeEmail };
}

-(NSDictionary*)CEPField {
    return @{ FXFormFieldHeader: @"Other data" };
}

-(NSDictionary*)ownerFirstNameField {
    return @{ FXFormFieldHeader: @"Owner Data" };
}

-(NSDictionary*)passwordField {
    return @{ FXFormFieldType: FXFormFieldTypePassword };
}

-(NSDictionary*)confirmPasswordField {
    return @{ FXFormFieldType: FXFormFieldTypePassword };
}

-(NSDictionary*)stateField {
    return @{ FXFormFieldOptions: @[@"AC", @"AL", @"AP", @"AM", @"BA", @"CE", @"DF", @"ES", @"GO", @"MA", @"MT", @"MS", @"MG", @"PA", @"PB", @"PR", @"PE", @"PI", @"RJ", @"RN", @"RS", @"RO", @"RR", @"SC", @"SP", @"SE", @"TO"] };
}

-(NSDictionary*)ownerBirthdayField {
    return @{ FXFormFieldType: FXFormFieldTypeDate };
}

-(NSDictionary*)registerUserField {
    return @{ FXFormFieldAction: @"registerUser:",
              FXFormFieldHeader: @"" };
}

@end
