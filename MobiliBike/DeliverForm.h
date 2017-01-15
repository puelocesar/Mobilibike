//
//  DeliverForm.h
//  MobiliBike
//
//  Created by Paulo Cesar on 15/01/17.
//  Copyright © 2017 Paulo Cesar. All rights reserved.
//

#import <FXForms/FXForms.h>

@interface DeliverForm : NSObject <FXForm>

@property NSString* runDescription;
@property NSString* AddressStreet1;
@property NSNumber* AddressNumber1;
@property NSString* AddressCity1;

@property NSString* AddressStreet2;
@property NSNumber* AddressNumber2;
@property NSString* AddressCity2;

@end
