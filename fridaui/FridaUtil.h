//
//  FridaUtil.h
//  fridaui
//
//  Created by 袁东明 on 2020/4/2.
//  Copyright © 2020 袁东明. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "frida-core.h"

NS_ASSUME_NONNULL_BEGIN

@interface FridaUtil : NSObject {
    @private
    GError *error;
    FridaDeviceManager *manager;
    FridaDevice* current_device;
}

+ (FridaUtil*) sharedInstance;
- (NSMutableArray*) getDevices;
-(FridaDevice*) getDeviceByName: (NSString*)device_name;
-(NSMutableDictionary*) getApplications;
-(void) showErrorMessage: (NSString*)message;
@end

NS_ASSUME_NONNULL_END
