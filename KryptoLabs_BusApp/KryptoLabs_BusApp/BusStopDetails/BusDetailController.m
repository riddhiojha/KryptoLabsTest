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
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
