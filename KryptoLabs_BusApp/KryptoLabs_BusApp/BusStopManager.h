//
//  BusStopManager.h
//  KryptoLabs_BusApp
//
//  Copyright © 2016 Riddhi Ojha. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol BusControllerDelegate <NSObject>
@optional
- (void) busStopRequestCallback : (NSDictionary *)responseDictionary;
@end


@interface BusStopManager : NSObject<NSURLConnectionDelegate, NSURLSessionDelegate>
{
    NSMutableData *responseData;
    
}
@property (nonatomic, assign) id<BusControllerDelegate> m_BusControllerDelegate;

- (void) fetchBusStops :(NSDictionary *)userData;
@end
