//
//  ViewController.m
//  fridaui
//
//  Created by 袁东明 on 2020/4/2.
//  Copyright © 2020 袁东明. All rights reserved.
//

#import "ViewController.h"
#import "FridaUtil.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    frida = [FridaUtil sharedInstance];
    NSMutableArray *frida_devices = [frida getDevices];
    
    [self.pop_devices addItemsWithTitles:frida_devices];
    if([frida_devices count] > 0){
        [self.pop_devices selectItemAtIndex:0];
    }
}
- (IBAction)deviceSelected:(id)sender {
//    NSString *dev_name = self.pop_devices.stringValue;
    NSString *dev_name = self.pop_devices.selectedItem.title;
    [frida getDeviceByName: dev_name];
    NSMutableDictionary* apps = [frida getApplications];
    [self.pop_applications removeAllItems];
    [apps enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop){
//        NSString *item_name = [NSString stringWithFormat:@"%@:%@", key, obj];
//        [self.pop_applications addItemWithTitle:item_name];
        [self.pop_applications addItemWithTitle:obj];
    }];
}
- (IBAction)applicationSelected:(id)sender {
    NSString *app_name = self.pop_applications.selectedItem.title;
}



- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
