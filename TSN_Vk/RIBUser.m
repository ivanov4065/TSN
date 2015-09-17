//
//  RIBUser.m
//  TSN_Vk
//
//  Created by Roman Ivaniv on 08.09.15.
//  Copyright (c) 2015 Roman Ivaniv. All rights reserved.
//

#import "RIBUser.h"

@implementation RIBUser


- (id) initWithServerResponse:(NSDictionary*) responseObject;

{
    self = [super initWithServerResponse:responseObject];
    if (self) {
        
        self.name = [responseObject objectForKey:@"name"];
        
        
        NSString* urlString = [responseObject objectForKey:@"photo_big"];
        
        if (urlString) {
            self.imageURL = [NSURL URLWithString:urlString];
        }
        
        
        
    }
    return self;
}


@end
