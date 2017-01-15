//
//  ViewController.m
//  MobiliBike
//
//  Created by Paulo Cesar on 14/01/17.
//  Copyright © 2017 Paulo Cesar. All rights reserved.
//

#import "ViewController.h"
#import "AuthInfo.h"
#import "LoginForm.h"
#import "BikeService.h"
#import "UIViewController+AlertUtil.h"

@implementation ViewController {
    IBOutlet UILabel *loggedLabel;
}

- (void)viewDidAppear:(BOOL)animated {
    if ([AuthInfo sharedInstance].token && [AuthInfo sharedInstance].email) {
        loggedLabel.text = [NSString stringWithFormat:@"Logged as: %@", [AuthInfo sharedInstance].email];
    }
    else if ([AuthInfo sharedInstance].token) {
        [BikeService getCompanyInfoWithCompletionHandler:^(NSString *companyId, NSString *email, NSError *error) {
            if (error) {
                [self showAlertWithMessage:error.localizedDescription];
            }
            else {
                [[AuthInfo sharedInstance] updateCompanyInfo:companyId email:email];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    loggedLabel.text = [NSString stringWithFormat:@"Logged as: %@", email];
                });
            }
        }];
    }
    else {
        [self performSegueWithIdentifier:@"auth" sender:self];
    }
}

- (IBAction)lougout:(id)sender {
    [[AuthInfo sharedInstance] clearToken];
    [self performSegueWithIdentifier:@"auth" sender:self];
}

@end
