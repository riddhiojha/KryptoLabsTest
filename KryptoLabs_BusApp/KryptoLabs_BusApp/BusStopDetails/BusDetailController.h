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

@interface BusDetailController : UIViewController<BusControllerDelegate>
{
    
    __weak IBOutlet UILabel *nameLabel;
    __weak IBOutlet UILabel *busNumber;
    __weak IBOutlet UILabel *destinationLabel;
    __weak IBOutlet UILabel *descriptionLabel;
    __weak IBOutlet MKMapView *routeMapView;
        BusStopManager *busStopManager;
        NSMutableArray *busRouteArray;
        NSIndexPath *indexPathSelected;
}
- (void)setBusId:(NSString *)busId;
    
@end
