//
//  ViewController.h
//  fridaui
//
//  Created by 袁东明 on 2020/4/2.
//  Copyright © 2020 袁东明. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FridaUtil.h"

@interface ViewController : NSViewController{
    @private FridaUtil *frida;
    @private FridaDevice *current_device;
}

@property (weak) IBOutlet NSPopUpButtonCell *pop_devices;
@property (weak) IBOutlet NSPopUpButtonCell *pop_applications;

@end

