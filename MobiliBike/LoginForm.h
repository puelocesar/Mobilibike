//
//  LoginForm.h
//  MobiliBike
//
//  Created by Paulo Cesar on 14/01/17.
//  Copyright © 2017 Paulo Cesar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FXForms/FXForms.h>

@interface LoginForm : NSObject <FXForm>

@property NSString* client_id;
@property NSString* client_secret;

@end
