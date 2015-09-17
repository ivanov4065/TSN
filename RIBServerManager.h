//
//  RIBServerManager.h
//  TSN_Vk
//
//  Created by Roman Ivaniv on 08.09.15.
//  Copyright (c) 2015 Roman Ivaniv. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RIBServerManager : NSObject


+ (RIBServerManager*) sharedManager;


- (void) getGroupWall:(NSString*) groupID
           withOffset:(NSInteger) offset
                count:(NSInteger) count
            onSuccess:(void(^)(NSArray* posts, NSArray* posts2, NSArray* posts3)) success
            onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;

@end
