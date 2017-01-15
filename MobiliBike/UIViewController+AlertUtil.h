//
//  UIViewController+AlertUtil.h
//  MobiliBike
//
//  Created by Paulo Cesar on 14/01/17.
//  Copyright © 2017 Paulo Cesar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (AlertUtil)

-(void)showAlertWithTitle:(NSString*)title message:(NSString*)message;
-(void)showAlertWithMessage:(NSString*)message;

@end
