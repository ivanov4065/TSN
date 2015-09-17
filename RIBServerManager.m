//
//  RIBServerManager.m
//  TSN_Vk
//
//  Created by Roman Ivaniv on 08.09.15.
//  Copyright (c) 2015 Roman Ivaniv. All rights reserved.
//

#import "RIBServerManager.h"
#import "AFNetworking.h"
#import "RIBUser.h"
#import "RIBWall.h"
#import "RIBImagePost.h"

@implementation RIBServerManager



+ (RIBServerManager*) sharedManager {
    
    
    static RIBServerManager* manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[RIBServerManager alloc] init];
    });
    
    return manager;
    
}

- (void) getGroupWall:(NSString *)groupID
           withOffset:(NSInteger) offset
                count:(NSInteger) count
            onSuccess:(void (^)(NSArray* posts, NSArray* posts2, NSArray* posts3)) success
            onFailure:(void (^)(NSError* error, NSInteger statusCode)) failure {
    
    if (![groupID hasPrefix:@"-"]) {
        groupID = [@"-" stringByAppendingString:groupID];
    }
    
    NSDictionary* params =
    [NSDictionary dictionaryWithObjectsAndKeys:
     groupID,       @"owner_id",
     @(count),      @"count",
     @(offset),     @"offset",
     @"all",        @"filter",
     @"1",          @"extended", nil];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"http://api.vk.com/method/wall.get"
      parameters:params
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             NSLog(@"JSON: %@", responseObject);
             
             NSArray* groupsDictsArray = [[responseObject objectForKey:@"response"] objectForKey:@"groups"];
             
             NSMutableArray* groupsObjectsArray = [NSMutableArray array];
             
             for (NSDictionary* dict in groupsDictsArray) {
                 RIBUser* user = [[RIBUser alloc] initWithServerResponse:dict];
                 [groupsObjectsArray addObject:user];
             }
             
             NSArray* wallDictsArray = [[responseObject objectForKey:@"response"] objectForKey:@"wall"];
             
             if ([wallDictsArray count] > 1) {
                 wallDictsArray = [wallDictsArray subarrayWithRange:NSMakeRange(1, (int)[wallDictsArray count] - 1)];
             } else {
                 wallDictsArray = nil;
             }
             
             NSMutableArray* wallObjectsArray = [NSMutableArray array];
             
             for (NSDictionary* dict in wallDictsArray) {
                 RIBWall* wall = [[RIBWall alloc] initWithServerResponse:dict];
                 [wallObjectsArray addObject:wall];
             }
             

             NSArray* photoDictsArray = [[wallDictsArray valueForKey:@"attachment"] valueForKey:@"photo"];
             
             NSMutableArray* photoObjectsArray = [NSMutableArray array];
             
             for (NSDictionary* dict3 in photoDictsArray) {
                 
                 RIBImagePost* image = [[RIBImagePost alloc] initWithServerResponse:dict3];

                 [photoObjectsArray addObject:image];
             }
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 
                 if (success) {
                     success(groupsObjectsArray, wallObjectsArray, photoObjectsArray);
                 }
             });

         }

         failure:^(AFHTTPRequestOperation *operation, NSError *error) {

            if (failure) {
            failure(error, operation.response.statusCode);
            }
             
             NSLog(@"Error: %@", error);
         }];

    
}

@end
