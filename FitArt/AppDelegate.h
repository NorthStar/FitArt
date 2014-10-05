//
//  AppDelegate.h
//  FitArt
//
//  Created by Mimee Xu on 10/4/14.
//  Copyright (c) 2014 Mimee Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UPPlatformSDK/UPPlatformSDK.h>
#import <OpenSpatial/OpenSpatialBluetooth.h>
#import <Parse/Parse.h>
#import <CoreMotion/CoreMotion.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

typedef void (^PedometerDataHandler)(CMPedometerData *pedometerData, NSError *error);

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) CMMotionManager *motionManager;
@property (strong, nonatomic) CMMotionActivityManager *motionActivityManager;

@end

