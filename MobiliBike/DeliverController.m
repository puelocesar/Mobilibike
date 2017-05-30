//
//  DeliverController.m
//  MobiliBike
//
//  Created by Paulo Cesar on 15/01/17.
//  Copyright © 2017 Paulo Cesar. All rights reserved.
//

#import "DeliverController.h"
#import "DeliverForm.h"
#import "BikeService.h"
#import "UIViewController+AlertUtil.h"
#import "AuthInfo.h"
#import "MapController.h"

@implementation DeliverController {
    FXFormController *formController;
    DeliverForm* form;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    form = [[DeliverForm alloc] init];
    
    formController = [[FXFormController alloc] init];
    formController.tableView = self.tableView;
    formController.delegate = self;
    formController.form = form;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)submit:(UITableViewCell<FXFormFieldCell> *)cell {
    if (!form.runDescription || !form.AddressCity1 || !form.AddressNumber1 || !form.AddressStreet1 ||
        !form.AddressCity2 || !form.AddressNumber2 || !form.AddressStreet2) {
        
        [self showAlertWithMessage:@"All fields are mandatory"];
    }
    else
        [self performSegueWithIdentifier:@"showMap" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[MapController class]]) {
        ((MapController*)segue.destinationViewController).deliverInfo = form;
    }
}

@end
