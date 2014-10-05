//
//  MainViewController.h
//  Example App
//
//  Created by Neel Bhoopalam on 6/9/14.
//  Copyright (c) 2014 Nod Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OpenSpatial/OpenSpatialBluetooth.h>
#import "RingScanTableViewController.h"

@interface MainViewController : UIViewController <OpenSpatialBluetoothDelegate>

@property OpenSpatialBluetooth *HIDServ;
@property CBPeripheral *lastNodPeripheral;

@property UIButton *startPeripheral;
@property UIButton *endPeripheral;
-(void) startLoop;

@end
