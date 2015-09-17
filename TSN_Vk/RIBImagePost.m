//
//  RIBImagePost.m
//  TSN_Vk
//
//  Created by Roman Ivaniv on 13.09.15.
//  Copyright (c) 2015 Roman Ivaniv. All rights reserved.
//

#import "RIBImagePost.h"

@implementation RIBImagePost

- (id) initWithServerResponse:(NSDictionary*) responseObject;

{
    self = [super initWithServerResponse:responseObject];
    if (self) {
                
        NSString* urlString = [responseObject objectForKey:@"src_big"];
        
        if (urlString) {
            self.postImageURL = [NSURL URLWithString:urlString];
        }
        
        
    }
    return self;
}


@end
