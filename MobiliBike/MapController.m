//
//  MapController.m
//  MobiliBike
//
//  Created by Paulo Cesar on 15/01/17.
//  Copyright © 2017 Paulo Cesar. All rights reserved.
//

#import "MapController.h"
#import "BikeService.h"
#import "UIViewController+AlertUtil.h"
#import "AuthInfo.h"

@implementation MapController {
    IBOutlet UILabel *priceLabel;
    IBOutlet UILabel *distanceLabel;
    IBOutlet MKMapView *mapView;
    IBOutlet UIVisualEffectView *loadingView;
    IBOutlet UIActivityIndicatorView *indicator;
    IBOutlet UIButton *confirmButton;
    IBOutlet UIActivityIndicatorView *publishIndicator;
    
    MKMapItem* source;
    MKMapItem* destination;
    
    NSNumber* finalPrice;
    NSNumber* finalDistance;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated {
    loadingView.hidden = NO;
    [indicator startAnimating];
    
    mapView.delegate = self;
    
    confirmButton.alpha = 0.5;
    confirmButton.enabled = NO;
    priceLabel.text = @"";
    distanceLabel.text = @"";
    
    [self searchMapItemForStreet:_deliverInfo.AddressStreet1 number:_deliverInfo.AddressNumber1 city:_deliverInfo.AddressCity1 completionHandler:^(MKMapItem *item) {
        source = item;
        
        if (source)
            [self route];
        else {
            [self hideLoading];
            [self showAlertWithMessage:@"Origem desconhecida"];
        }
    }];
    
    [self searchMapItemForStreet:_deliverInfo.AddressStreet2 number:_deliverInfo.AddressNumber2 city:_deliverInfo.AddressCity2 completionHandler:^(MKMapItem *item) {
        destination = item;
        
        if (destination)
            [self route];
        else {
            [self hideLoading];
            [self showAlertWithMessage:@"Destino não encontrado"];
        }
    }];
}

- (void)route {
    if (source && destination) {
        [mapView removeAnnotations:[mapView annotations]];
        [mapView showAnnotations:@[ source.placemark, destination.placemark ] animated:NO];
        
        MKDirectionsRequest* request = [[MKDirectionsRequest alloc] init];
        request.source = source;
        request.destination = destination;
        request.transportType = MKDirectionsTransportTypeWalking;
        
        MKDirections* directions = [[MKDirections alloc] initWithRequest:request];
        [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse * response, NSError *  error) {
            
            [self hideLoading];
            
            if (error) {
                [self showAlertWithMessage:@"Não foi possível traçar uma rota"];
            }
            else {
                [mapView removeOverlays:mapView.overlays];
                for (MKRoute *route in response.routes) {
                    [mapView insertOverlay:route.polyline atIndex:0 level:MKOverlayLevelAboveRoads];
                    [self getPriceForDistance:route.distance];
                    
                    finalDistance = @(route.distance);
                    distanceLabel.text = [NSString stringWithFormat:@"%0.2f km", [finalDistance floatValue]/1000];
                }
            }
        }];
    }
}

-(void)hideLoading {
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.5 animations:^{
            loadingView.effect = nil;
        } completion:^(BOOL finished) {
            [indicator stopAnimating];
            loadingView.hidden = YES;
        }];
    });
}

-(void)getPriceForDistance:(CLLocationDistance)distance {
    [BikeService getPriceWithDistance:distance completionHandler:^(NSNumber *price, NSError *error) {
        if (error) {
            [self showAlertWithMessage:error.localizedDescription];
        }
        else {
            priceLabel.text = [NSString stringWithFormat:@"R$ %0.2f", [price floatValue]];
            finalPrice = price;
            
            confirmButton.enabled = YES;
            confirmButton.alpha = 1;
        }
    }];
}

-(void)searchMapItemForStreet:(NSString*)street number:(NSNumber*)number city:(NSString*)city completionHandler:(void (^)(MKMapItem* item))completeBlock {
    
    // Create and initialize a search request object.
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = [NSString stringWithFormat:@"%@, %@, %@", street, number, city];
    request.region = mapView.region;
    
    // Create and initialize a search object.
    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
    
    // Start the search and display the results as annotations on the map.
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        if (response.mapItems.count > 0) {
            completeBlock(response.mapItems[0]);
        }
        else {
            completeBlock(nil);
        }
    }];
}

- (IBAction)confirmDelivery:(id)sender {
    
    publishIndicator.hidden = NO;
    [UIView animateWithDuration:0.25 animations:^{
        publishIndicator.alpha = 1;
    } completion:^(BOOL finished) {
        [publishIndicator startAnimating];
    }];
    
    CLLocationCoordinate2D sourceCoord = source.placemark.location.coordinate;
    CLLocationCoordinate2D destCoord = destination.placemark.location.coordinate;
    
    NSDictionary* params = @{
                             @"CompanyId": [AuthInfo sharedInstance].companyId,
                             @"ScheduleType": @"ForNow",
                             @"Description": _deliverInfo.runDescription,
                             @"Price": finalPrice,
                             @"Distance": finalDistance,
                             @"Checkpoints": @[
                                     @{
                                         @"AddressStreet": _deliverInfo.AddressStreet1,
                                         @"AddressNumber": [_deliverInfo.AddressNumber1 stringValue],
                                         @"AddressCity": _deliverInfo.AddressCity1,
                                         @"Latitude": @(sourceCoord.latitude),
                                         @"Longitude": @(sourceCoord.longitude)
                                         },
                                     @{
                                         @"AddressStreet": _deliverInfo.AddressStreet2,
                                         @"AddressNumber": [_deliverInfo.AddressNumber2 stringValue],
                                         @"AddressCity": _deliverInfo.AddressCity2,
                                         @"Latitude": @(destCoord.latitude),
                                         @"Longitude": @(destCoord.longitude)
                                         }
                                     ]
                             };
    
    [BikeService postRace:params completionHandler:^(NSString *raceID, NSError *error) {
        if (error) {
            [self showAlertWithMessage:error.localizedDescription];
        }
        else {
            [UIView animateWithDuration:0.25 animations:^{
                publishIndicator.alpha = 0;
                confirmButton.alpha = 0.5;
            } completion:^(BOOL finished) {
                [publishIndicator stopAnimating];
                publishIndicator.hidden = YES;
                confirmButton.enabled = NO;
            }];
            
            [self showAlertWithTitle:@"Tudo certo!" message:@"Seu pedido de entrega foi enviado e logo que um biker aceitar o pedido, você receberá uma confirmação da entrega"];
        }
    }];
}

#pragma mark mapview delegate

-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolylineRenderer* renderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
        renderer.strokeColor = [UIColor colorWithRed:0.14 green:0.6 blue:0.3 alpha:1];
        renderer.lineWidth = 3;
        return renderer;
    }
    
    return nil;
}

@end
