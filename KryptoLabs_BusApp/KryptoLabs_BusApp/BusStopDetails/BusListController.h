//
//  BusListController.h
//  KryptoLabs_BusApp
//
//  Created by Riddhi Ojha on 12/10/16.
//  Copyright © 2016 Riddhi Ojha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BusStopManager.h"
#import "BusDetailController.h"

@interface BusListController : UITableViewController<BusControllerDelegate>
{
    BusStopManager *busStopManager;
    NSMutableArray *busListArray;
    NSIndexPath *indexPathSelected;
}
- (void)setBusStopId:(NSString *)busStopId;

@end
