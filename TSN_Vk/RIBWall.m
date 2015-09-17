//
//  RIBWall.m
//  TSN_Vk
//
//  Created by Roman Ivaniv on 09.09.15.
//  Copyright (c) 2015 Roman Ivaniv. All rights reserved.
//

#import "RIBWall.h"

@implementation RIBWall

- (id) initWithServerResponse:(NSDictionary*) responseObject;

{
    self = [super initWithServerResponse:responseObject];
    if (self) {
        
        NSDateFormatter *dateFormater = [[NSDateFormatter alloc]init];
        [dateFormater setDateFormat:@"dd MMM yyyy "];
        NSDate *dateTime = [NSDate dateWithTimeIntervalSince1970:[[responseObject objectForKey:@"date"] floatValue]];
        NSString *date = [dateFormater stringFromDate:dateTime];
        self.date = date;
        
        self.text = [responseObject objectForKey:@"text"];
        self.text = [self.text stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
        self.text = [self.text stringByReplacingOccurrencesOfString:@":" withString:@"."];

        NSRange cleanString = [self.text rangeOfString:@"http"];
        NSString* newText =[self.text substringFromIndex:cleanString.location];
        self.text = [self.text stringByReplacingOccurrencesOfString:newText withString:@" "];



    }
    return self;
}



@end
