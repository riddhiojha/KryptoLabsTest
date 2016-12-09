//
//  MasterViewController.h
//  KryptoLabs_BusApp
//
//  Copyright © 2016 Riddhi Ojha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "BusStopManager.h"

@class DetailViewController;

@interface MasterViewController : UIViewController<MKMapViewDelegate, BusControllerDelegate>
{
    BusStopManager *busStopManager;
}

@property (strong, nonatomic) DetailViewController *detailViewController;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

