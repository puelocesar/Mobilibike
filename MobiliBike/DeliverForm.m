//
//  DeliverForm.m
//  MobiliBike
//
//  Created by Paulo Cesar on 15/01/17.
//  Copyright © 2017 Paulo Cesar. All rights reserved.
//

#import "DeliverForm.h"

@implementation DeliverForm

-(NSArray *)fields {
    return @[
                @{ FXFormFieldKey: @"runDescription",
                   FXFormFieldTitle: @"Description" },
                
                @{ FXFormFieldHeader: @"Starting point",
                   FXFormFieldKey: @"AddressStreet1",
                   FXFormFieldTitle: @"Address" },
                
                @{ FXFormFieldKey: @"AddressNumber1",
                   FXFormFieldTitle: @"Number" },
                
                @{ FXFormFieldKey: @"AddressCity1",
                   FXFormFieldTitle: @"City" },
                
                @{ FXFormFieldHeader: @"Delivery Address",
                   FXFormFieldKey: @"AddressStreet2",
                   FXFormFieldTitle: @"Address" },
                
                @{ FXFormFieldKey: @"AddressNumber2",
                   FXFormFieldTitle: @"Number" },
                
                @{ FXFormFieldKey: @"AddressCity2",
                   FXFormFieldTitle: @"City" },
                
                @{ FXFormFieldKey: @"Calculate route",
                   FXFormFieldHeader: @"",
                   FXFormFieldAction: @"submit:" }
            ];
}

@end
