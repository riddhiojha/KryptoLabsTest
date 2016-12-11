//
//  BusDetailController.h
//  KryptoLabs_BusApp
//
//  Created by Riddhi Ojha on 12/11/16.
//  Copyright © 2016 Riddhi Ojha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "BusStopManager.h"
#define THEME_COLOR [UIColor colorWithRed:253.0/255.0 green:116.0/255.0 blue:118.0/255.0 alpha:0.8]


@interface BusDetailController : UIViewController<BusControllerDelegate, MKMapViewDelegate>
{
    
    __weak IBOutlet UILabel *nameLabel;
    __weak IBOutlet UILabel *busNumber;
    __weak IBOutlet UILabel *destinationLabel;
    __weak IBOutlet UILabel *descriptionLabel;
    __weak IBOutlet MKMapView *routeMapView;
    __weak IBOutlet UIActivityIndicatorView *activityMapIndicator;
        BusStopManager *busStopManager;
        NSMutableArray *busRouteArray;
        NSIndexPath *indexPathSelected;
}
- (void)setBusId:(NSString *)busId;
    
@end
