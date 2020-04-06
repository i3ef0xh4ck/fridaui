//
//  FridaUtil.m
//  fridaui
//
//  Created by 袁东明 on 2020/4/2.
//  Copyright © 2020 袁东明. All rights reserved.
//

#import "FridaUtil.h"
#import <Cocoa/Cocoa.h>

@implementation FridaUtil

+ (FridaUtil*) sharedInstance {
    static FridaUtil *instance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[self.class alloc] init];
    });
    return instance;
}

-(instancetype)init{
    self = [super init];
    frida_init();
    manager = frida_device_manager_new();
    return self;
}

-(NSMutableArray*) getDevices{
    NSMutableArray *devs = [[NSMutableArray alloc] init];
    FridaDeviceList *devices = frida_device_manager_enumerate_devices_sync(manager, NULL, &error);
    int num_devices = frida_device_list_size(devices);
    for(int i = 0; i < num_devices; i++){
        FridaDevice * device = frida_device_list_get(devices, i);
        const char *dev_name = frida_device_get_name(device);
        NSString *_dev_name = [NSString stringWithCString:dev_name encoding:NSUTF8StringEncoding];
        [devs addObject:_dev_name];
        g_object_unref(device);
    }
    frida_unref(devices);
    return devs;
}

-(FridaDevice*) getDeviceByName: (NSString*)device_name {
    error = nil;
    FridaDevice* dev_by_name = nil;
    FridaDeviceList *devices = frida_device_manager_enumerate_devices_sync(manager, NULL, &error);
    int num_devices = frida_device_list_size(devices);
    for(int i = 0; i < num_devices; i++){
        FridaDevice * device = frida_device_list_get(devices, i);
        const char *dev_name = frida_device_get_name(device);
        NSString *_dev_name = [NSString stringWithCString:dev_name encoding:NSUTF8StringEncoding];
        if([_dev_name isEqualToString:device_name]){
//            NSLog(@"found device: %@", _dev_name);
            dev_by_name = g_object_ref(device);
            current_device = g_object_ref(device);
        }
        g_object_unref(device);
    }
    frida_unref(devices);
    
    return dev_by_name;
}

-(NSMutableDictionary*) getApplications{
    error = nil;
    NSMutableDictionary *app_with_id = [[NSMutableDictionary alloc] init];
    FridaApplicationList* app_list = frida_device_enumerate_applications_sync(current_device, NULL, &error);
    if(error == nil){
        int num_app = frida_application_list_size(app_list);
        for(int i = 0; i < num_app; i++){
            FridaApplication *app = frida_application_list_get(app_list, i);
            const char *_app_id = frida_application_get_identifier(app);
            const char *_app_name = frida_application_get_name(app);
            NSString *app_id = [NSString stringWithCString:_app_id encoding:NSUTF8StringEncoding];
            NSString *app_name = [NSString stringWithCString:_app_name encoding:NSUTF8StringEncoding];
            [app_with_id setObject:app_name forKey:app_id];
//            NSLog(@"app id: %@, app name: %@", app_id, app_name);
            g_object_unref(app);
        }
        frida_unref(app_list);
    } else {
        NSLog(@"failed enumerate applications: %s", error->message);
        NSString *err_msg = [NSString stringWithCString:error->message encoding:NSUTF8StringEncoding];
        [self showErrorMessage:err_msg];
    }
    
    return app_with_id;
}

-(void) showErrorMessage: (NSString*)message{
    NSAlert *alert = [[NSAlert alloc] init];
    alert.messageText = message;
    [alert addButtonWithTitle:@"确定"];
    // https://www.jianshu.com/p/ee3c9b75d5f7
    // https://www.jianshu.com/p/717f40c62f7c
    NSWindow *window = [[NSApplication sharedApplication] keyWindow];
    [alert beginSheetModalForWindow:window completionHandler:^(NSModalResponse returnCode){}];
}

@end
