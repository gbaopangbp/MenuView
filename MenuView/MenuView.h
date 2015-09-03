//
//  MenuView.h
//  test
//
//  Created by yaoyingtao on 15/9/1.
//  Copyright (c) 2015年 yaoyingtao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MenuView;
@protocol MenuViewDataSource <NSObject>
@required
- (NSInteger) numberOfColumn;
- (NSString *) titileOfNsIndexPath:(NSIndexPath *)indexPath;
- (NSInteger) numberRowsShowOfColumn:(NSInteger)column;
- (NSInteger) numberRowsOfColumn:(NSInteger)column;
- (UIView *) containerView;

@end

@protocol MenuViewDelegate <NSObject>
@optional
- (void)mentView:(MenuView*)menuView didSelectIndexPath:(NSIndexPath*)indexPath;

@end

@interface MenuView : UIView
@property (weak, nonatomic) id<MenuViewDataSource>dataSource;
@property (weak, nonatomic) id<MenuViewDelegate>delegate;
@end



