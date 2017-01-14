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

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    if (![AuthInfo token]) {
        [self performSegueWithIdentifier:@"auth" sender:self];
    }
}

- (IBAction)lougout:(id)sender {
    [AuthInfo clearToken];
    [self performSegueWithIdentifier:@"auth" sender:self];
}

@end
