//
//  UIViewController+AlertUtil.m
//  MobiliBike
//
//  Created by Paulo Cesar on 14/01/17.
//  Copyright © 2017 Paulo Cesar. All rights reserved.
//

#import "UIViewController+AlertUtil.h"

@implementation UIViewController (AlertUtil)

-(void)showAlertWithMessage:(NSString*)message {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action) {}]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end
