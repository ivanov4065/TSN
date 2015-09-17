//
//  RIBPostCell.h
//  TSN_Vk
//
//  Created by Roman Ivaniv on 10.09.15.
//  Copyright (c) 2015 Roman Ivaniv. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RIBPostCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel*     postTextLable;
@property (weak, nonatomic) IBOutlet UILabel*     postDateLable;
@property (weak, nonatomic) IBOutlet UIImageView* postImageView;

@property (weak, nonatomic) IBOutlet UILabel*     userNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView* userImageView;


+ (CGFloat) heightForText:(NSString *)text;



@end
