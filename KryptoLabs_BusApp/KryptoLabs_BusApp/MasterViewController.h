//
//  MasterViewController.h
//  KryptoLabs_BusApp
//
//  Copyright © 2016 Riddhi Ojha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "BusStopManager.h"
#import "BusListController.h"

@interface MasterViewController : UIViewController<MKMapViewDelegate, BusControllerDelegate, CLLocationManagerDelegate>
{
    BusStopManager *busStopManager;
    NSMutableArray *busStopList;
    BOOL isUpdatingLocation;
}
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) BusListController *busListController;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

