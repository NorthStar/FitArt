//
//  RingScanTableViewController.h
//  Example App
//
//  Created by Neel Bhoopalam on 6/9/14.
//  Copyright (c) 2014 Nod Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OpenSpatial/OpenSpatialBluetooth.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "MainViewController.h"

@interface RingScanTableViewController : UITableViewController <OpenSpatialBluetoothDelegate>

@property CBPeripheral *lastNodPeripheral;

@end