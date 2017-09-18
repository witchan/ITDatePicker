//
//  ITAlertBox.h
//  ITAlertBox
//
//  Created by Wit on 2017/9/15.
//  Copyright © 2017年 Wit. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ITAlertBox;

typedef NS_ENUM(NSUInteger, ITAlertBoxType) {
    ITAlertBoxTypeDatePicker,
};

@protocol ITAlertBoxDelegate <NSObject>

@optional
- (void)alertBox:(ITAlertBox *)alertBox didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)alertBox:(ITAlertBox *)alertBox didSelectedResult:(id)result;

@end

@interface ITAlertBox : UIView <ITAlertBoxDelegate>

@property (weak, nonatomic) id<ITAlertBoxDelegate> delegate;

+ (instancetype)alertBoxWithType:(ITAlertBoxType)type;

- (void)viewDidLoad;

- (void)autoLayoutSubviews;

@end
