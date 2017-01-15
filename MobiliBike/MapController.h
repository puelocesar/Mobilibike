//
//  MapController.h
//  MobiliBike
//
//  Created by Paulo Cesar on 15/01/17.
//  Copyright © 2017 Paulo Cesar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeliverForm.h"
@import MapKit;

@interface MapController : UIViewController <MKMapViewDelegate>

@property DeliverForm* deliverInfo;

@end
