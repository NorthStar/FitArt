//
//  AppDelegate.m
//  FitArt
//
//  Created by Mimee Xu on 10/4/14.
//  Copyright (c) 2014 Mimee Xu. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import "MainViewController.h"
#import "RingScanTableViewController.h"
#import <CoreMotion/CoreMotion.h>
#include <stdlib.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //Parse
    [Parse setApplicationId:@"MvWeblttM2oTson68BzHfKvQgUCKI49y43GvNltv"
                  clientKey:@"nS3zdjyPaFzWr5UaOTdKZu5pP0CeG3DaQcSxlGfy"];
    
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    //Config
    self.motionManager = [[CMMotionManager alloc] init];
    self.motionActivityManager = [[CMMotionActivityManager alloc] init];
    //Start getting/sending data
    [self startMotionSensing];
    [self startJawboneDataPosting];
    // Override point for customization after application launch.
    
    //MainViewController *mainViewController = [[MainViewController alloc] init];

    //[self.window setRootViewController:mainViewController];//ringScanTableViewController];
    //[self.window makeKeyAndVisible];
    return YES;
}

- (void)startMotionSensing {
    //Date Utilities
    // Right now, you can remove the seconds into the day if you want
    NSDate *today = [NSDate date];
    
    // All intervals taken from Google
    NSDate *yesterday = [today dateByAddingTimeInterval: -86400.0];
//    NSDate *thisWeek  = [today dateByAddingTimeInterval: -604800.0];
//    NSDate *lastWeek  = [today dateByAddingTimeInterval: -1209600.0];
    
    // To get the correct number of seconds in each month use NSCalendar
//    NSDate *thisMonth = [today dateByAddingTimeInterval: -2629743.83];
//    NSDate *lastMonth = [today dateByAddingTimeInterval: -5259487.66];

    
    [self.motionManager startAccelerometerUpdates];
    CMPedometer * pedometer = [[CMPedometer alloc] init];
    /*PedometerDataHandler handler = ^void(CMPedometerData *pedometerData, NSError *error) {
        if (error) {
            return;//can't do anything
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"PedometerData: %@",pedometerData);
            });
        }};*/
    
    //handler^(CMPedometerData *pedometerData, NSError *error) =
    if (pedometer) {
        [pedometer startPedometerUpdatesFromDate:yesterday withHandler:^(CMPedometerData *pedometerData, NSError *error){
            //This following block gets called all the time
            if (error) {
                [self handleError:error];//can't do anything
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"PedometerData: %@",pedometerData);
                });
            }
        }];
    }
    //(CMStepUpdateHandler)
    //typedef void (^CMAccelerometerHandler)(CMAccelerometerData *accelerometerData, NSError *error);
    //CMAccelerometerHandler handler =
}

-(void)handleError:(NSError*)error{
    
    NSLog(@"ERROR: %d:%s %@", __LINE__, __PRETTY_FUNCTION__, error.description);
}

- (void)startJawboneDataPosting {
    int a, b;
    a = arc4random_uniform(1280);
    b = arc4random_uniform(768);
    [[UPPlatform sharedPlatform] startSessionWithClientID:@"IUqAan8Y0G8"
                                             clientSecret:@"6632a6ac1252c04422b4d9482c779af8c8ba2f3c"
                                                authScope:(UPPlatformAuthScopeExtendedRead | UPPlatformAuthScopeMoveRead)
                                               completion:^(UPSession *session, NSError *error) {
                                                   NSLog(@"Platform");
                                                   if (session != nil) {
                                                       NSLog(@"With session");
                                                       [UPMoveAPI getMovesWithLimit:10U completion:^(NSArray *moves, UPURLResponse *response, NSError *error) {
                                                           NSLog(@"Getting response");
                                                           for (UPMove * move in moves) {
                                                               NSInteger steps = [[move steps] integerValue];
                                                               NSDate * date = [move date];
                                                               NSLog(@"%ld", (long)steps);
                                                               NSLog(@"%@", date);
                                                               
                                                               NSDictionary *tmp = [[NSDictionary alloc]
                                                                                     initWithObjectsAndKeys:
                                                                                     [NSString stringWithFormat:@"%ld",
                                                                                      [[move steps] longValue] ],
                                                                                     @"Steps",
                                                                [NSString stringWithFormat:@"%@",date],
                                                                                     @"Date",
                                                                [NSString stringWithFormat:@"%d", a],
                                                                                    @"xCoordinate",
                                                                [NSString stringWithFormat:@"%d", b],
                                                                                    @"yCoordinate",
                                                                nil];
                                                               //NSDictionary *tmp = @{@"Date": @"2014-09-30"};
                                                               
                                                               //NSData *postData = [NSJSONSerialization dataWithJSONObject:tmp options:0 error:&error];
                                                               

                                                               /*PFObject *jawboneObject = [PFObject objectWithClassName:@"Jawbone"];
                                                               jawboneObject[@"datestamp"] = [NSString stringWithFormat:@"%@", date];
                                                               jawboneObject[@"steps"] = [NSString stringWithFormat:@"%ld",(long)steps];
                                                               [jawboneObject saveInBackground];*/
                                                               
                                                               [self sendJSONDataFromDictionary:tmp];
                                                           }
                                                           // Your code here to process an array of UPMove objects.
                                                       }];
                                                       
                                                       
                                                       // Your code to start making API requests goes here.
                                                   }
                                               }];
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark private methods
//helper for json sending
- (void)sendJSONDataFromDictionary: (NSDictionary *)dictionary
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary
                                                       options:NSJSONWritingPrettyPrinted
                        // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"json string: %@",jsonString);
        //send point over
        NSString *postLength = [NSString stringWithFormat:@"%@",[[NSNumber numberWithUnsignedInt:jsonData.length] stringValue]];
        
        if ([postLength isEqualToString:@"0"]) {
            NSLog(@"Empty message");
            return;
        }

        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://radiant-heat-6169.firebaseio-demo.com/jawbone.json"]]];
        
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        
        //something: wat
        [request setHTTPBody:jsonData];
        NSURLConnection *conn = [[NSURLConnection alloc]initWithRequest:request delegate:self];
        
        if(conn) {
            NSLog(@"Connection Successful");
        } else {
            NSLog(@"Connection could not be made");
        }
        
    }
}

@end
