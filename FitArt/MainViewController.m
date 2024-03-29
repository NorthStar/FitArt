//
//  MainViewController.m
//  Example App
//
//  Created by Neel Bhoopalam on 6/9/14.
//  Copyright (c) 2014 Nod Labs. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@property int selectedIndex;
@property (nonatomic, strong) OpenSpatialBluetooth *myHIDServ;


@end

@implementation MainViewController

uint8_t mode = POINTER_MODE;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void) didFindNewDevice: (NSArray*) peripherals {
    [self.tableView reloadData];
    return;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.HIDServ = [OpenSpatialBluetooth sharedBluetoothServ];
    self.HIDServ.delegate = self;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, 500) style:UITableViewStylePlain];
    [self.tableView setDelegate: self];
    [self.tableView setDataSource:self];
    [self.view addSubview:self.tableView];
    /*
     * Called to start the bluetooth scan and initialize the central manager
     */
    [self.myHIDServ scanForPeripherals];
}

-(void)startLoop
{
    [self.HIDServ setMode:mode forDeviceNamed:self.lastNodPeripheral.name];
    if(mode == POINTER_MODE)
    {
        mode = THREE_D_MODE;
    }
    else
    {
        mode = POINTER_MODE;
    }
    [self performSelector:@selector(startLoop) withObject:nil afterDelay:5];
}

-(ButtonEvent *)buttonEventFired: (ButtonEvent *) buttonEvent
{
    NSLog(@"This is the value of button event type from %@", [buttonEvent.peripheral name]);
    switch([buttonEvent getButtonEventType])
    {
        case TOUCH0_DOWN:
            NSLog(@"Touch 0 Down");
            break;
        case TOUCH0_UP:
            NSLog(@"Touch 0 Up");
            break;
        case TOUCH1_DOWN:
            NSLog(@"Touch 1 Down");
            break;
        case TOUCH1_UP:
            NSLog(@"Touch 1 Up");
            break;
        case TOUCH2_DOWN:
            NSLog(@"Touch 2 Down");
            break;
        case TOUCH2_UP:
            NSLog(@"Touch 2 Up");
            break;
        case TACTILE0_DOWN:
            NSLog(@"Tactile 0 Down");
            break;
        case TACTILE0_UP:
            NSLog(@"Tactile 0 Up");
            break;
        case TACTILE1_DOWN:
            NSLog(@"Tactile 1 Down");
            break;
        case TACTILE1_UP:
            NSLog(@"Tactile 1 Up");
            break;
    }
    
    return nil;
}

-(PointerEvent *)pointerEventFired: (PointerEvent *) pointerEvent
{
    
    NSLog(@"This is the x value of the pointer event from %@", [pointerEvent.peripheral name]);
    NSLog(@"%hd", [pointerEvent getXValue]);
    
    
    NSLog(@"This is the y value of the pointer event from %@", [pointerEvent.peripheral name]);
    NSLog(@"%hd", [pointerEvent getYValue]);
    
    return nil;
}

-(GestureEvent *)gestureEventFired: (GestureEvent *) gestureEvent
{
    NSLog(@"This is the value of gesture event type from %@", [gestureEvent.peripheral name]);
    switch([gestureEvent getGestureEventType])
    {
        case SWIPE_UP:
            NSLog(@"Gesture Up");
            break;
        case SWIPE_DOWN:
            NSLog(@"Gesture Down");
            break;
        case SWIPE_LEFT:
            NSLog(@"Gesture Left");
            break;
        case SWIPE_RIGHT:
            NSLog(@"Gesture Right");
            break;
        case SLIDER_LEFT:
            NSLog(@"Slider Left");
            break;
        case SLIDER_RIGHT:
            NSLog(@"Slider Right");
            break;
        case CCW:
            NSLog(@"Counter Clockwise");
            break;
        case CW:
            NSLog(@"Clockwise");
            break;
    }
    
    return nil;
}

-(RotationEvent *)rotationEventFired:(RotationEvent *)rotationEvent
{
    NSLog(@"This is the x value of the quaternion from %@", [rotationEvent.peripheral name]);
    NSLog(@"%f", rotationEvent.x);
    
    NSLog(@"This is the y value of the quaternion from %@", [rotationEvent.peripheral name]);
    NSLog(@"%f", rotationEvent.y);

    NSLog(@"This is the z value of the quaternion from %@", [rotationEvent.peripheral name]);
    NSLog(@"%f", rotationEvent.z);

    NSLog(@"This is the roll value of the quaternion from %@", [rotationEvent.peripheral name]);
    NSLog(@"%f", rotationEvent.roll);

    NSLog(@"This is the pitch value of the quaternion from %@", [rotationEvent.peripheral name]);
    NSLog(@"%f", rotationEvent.pitch);

    NSLog(@"This is the yaw value of the quaternion from %@", [rotationEvent.peripheral name]);
    NSLog(@"%f", rotationEvent.yaw);
    
    return nil;
}

- (void) didConnectToNod: (CBPeripheral*) peripheral
{
    NSLog(@"here");
    self.lastNodPeripheral = peripheral;
}

- (void)subscribeEvents:(UIButton *)sender
{
    [self.HIDServ subscribeToButtonEvents:self.lastNodPeripheral.name];
    [self.HIDServ subscribeToGestureEvents:self.lastNodPeripheral.name];
    [self.HIDServ subscribeToPointerEvents:self.lastNodPeripheral.name];
    [self.HIDServ subscribeToRotationEvents:self.lastNodPeripheral.name];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.myHIDServ.foundPeripherals count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DeviceCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:
                             indexPath];
    CBPeripheral *rowElement = [self.myHIDServ.foundPeripherals objectAtIndex:indexPath.row];
    cell.textLabel.text = rowElement.name;
    return cell;
}
/*
- (void)didFindNewDevice:(CBPeripheral*) peripheral
{
    [self.tableView reloadData];
}*/



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
        [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://radiant-heat-6169.firebaseio-demo.com"]]];
        
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
