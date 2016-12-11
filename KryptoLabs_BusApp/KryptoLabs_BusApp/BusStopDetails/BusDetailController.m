//
//  BusDetailController.m
//  KryptoLabs_BusApp
//
//  Created by Riddhi Ojha on 12/11/16.
//  Copyright © 2016 Riddhi Ojha. All rights reserved.
//

#import "BusDetailController.h"

@interface BusDetailController ()

@end

@implementation BusDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Bus details";
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setBusId:(NSString *)busId {
    busStopManager = [[BusStopManager alloc] init];
    busStopManager.m_BusControllerDelegate = self;
    [busStopManager fetchBusRoute:busId];
}

#pragma mark - Busstopmanager delegate
- (void) busStopRequestCallback : (NSDictionary *)responseDictionary
{
    NSDictionary *busData = responseDictionary[@"response"][@"bus"];
    nameLabel.text = busData[@"name"];
    busNumber.text = busData[@"number"];
    descriptionLabel.text = busData[@"description"];
    destinationLabel.text = busData[@"destination"];
    
    NSMutableArray * coordinatesArray = responseDictionary[@"response"][@"points"];
    [self performSelector:@selector(drawPolylineOnMap:) withObject:coordinatesArray afterDelay:0.02];
}

- (void) drawPolylineOnMap : (NSMutableArray *)coordinatesArray
{
    NSMutableArray * cordArray = [[NSMutableArray alloc]init];
    for (int i = 0;i < coordinatesArray.count; i++)
    {
        double latitude = [[[coordinatesArray objectAtIndex:i]objectAtIndex:1]doubleValue];
        double longitude = [[[coordinatesArray objectAtIndex:i]objectAtIndex:0]doubleValue];
        CLLocation * location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
        [cordArray addObject:location];
    }
    
    CLLocationCoordinate2D coordinates[cordArray.count];
    //int i = 0;
    int numPoints = [cordArray count];
    for (int i = 0; i<numPoints;i++)
    {
        CLLocation * current = [cordArray objectAtIndex:i];
        coordinates[i] = current.coordinate;
    }
    MKPolyline *polyline = [MKPolyline polylineWithCoordinates:coordinates count:numPoints];
    [routeMapView setDelegate:self];
    [routeMapView addOverlay:polyline];
    [self zoomToPolyLine:routeMapView polyline:polyline animated:YES];
}


- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    [activityMapIndicator stopAnimating];
    if ([overlay isKindOfClass:[MKPolyline class]])
    {
        MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
        renderer.strokeColor = [UIColor colorWithRed:253.0/255.0 green:116.0/255.0 blue:118.0/255.0 alpha:0.8];
        renderer.lineWidth   = 5;
        return renderer;
    }
    
    return nil;
}



-(void)zoomToPolyLine: (MKMapView*)map polyline: (MKPolyline*)polyline animated: (BOOL)animated
{
    [map setVisibleMapRect:[polyline boundingMapRect] edgePadding:UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0) animated:animated];
}

@end
