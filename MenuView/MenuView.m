//
//  MenuView.m
//  test
//
//  Created by yaoyingtao on 15/9/1.
//  Copyright (c) 2015年 yaoyingtao. All rights reserved.
//

#import "MenuView.h"

static NSInteger cellHeight = 40;

@interface MenuView ()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic)NSMutableArray *tableArray;  //uitableview
@property (assign, nonatomic) NSInteger selectColumn;
@property (strong, nonatomic)NSMutableArray *buttonArray;  //uibutton
@property (strong, nonatomic)NSMutableArray *rowArray;  //selectRow



@end

@implementation MenuView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.userInteractionEnabled = YES;
        self.selectColumn = 1;
    }

    return self;
}

- (void)setDataSource:(id<MenuViewDataSource>)dataSource{
    _dataSource = dataSource;
    NSInteger width =  self.frame.size.width;
    NSInteger height = self.frame.size.height;
    NSInteger column = [_dataSource numberOfColumn];
    for (NSInteger i = 0; i < column; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i * width/column, 0, width/column, height);
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:i];
        [button setTitle:[_dataSource titileOfNsIndexPath:indexPath] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"down_dark"] forState:UIControlStateNormal];
        button.backgroundColor = [UIColor lightGrayColor];
        button.tag = [indexPath section];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        [self.buttonArray addObject:button];
        
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(button.bounds.size.width - 1, 0, 1, button.bounds.size.height)];
        line.backgroundColor = [UIColor grayColor];
        [button addSubview:line];
        
        
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(i * width/column, self.frame.origin.y + button.bounds.size.height, width/column, [_dataSource numberRowsShowOfColumn:i]*cellHeight) style:UITableViewStylePlain];
        tableView.tag = i;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.hidden = YES;
        tableView.backgroundColor = [UIColor lightGrayColor];
        [[self.dataSource containerView] addSubview:tableView];
        [self.tableArray addObject:tableView];

    }
}

- (void)buttonClick:(UIButton *)button{
    for (UITableView *tableView in self.tableArray) {
        self.selectColumn = button.tag + 1;
        if (tableView.tag == button.tag) {
            tableView.hidden = NO;

            [tableView reloadData];
        }else{
            tableView.hidden = YES;
            UIButton *button = self.buttonArray[tableView.tag];
            [button setImage:[UIImage imageNamed:@"down_dark"] forState:UIControlStateNormal];
        }
    }
    UIImage *image = [UIImage imageNamed:@"down_dark"];
    UIImage *down = [UIImage imageWithCGImage:image.CGImage scale:1.0 orientation:UIImageOrientationDown];
    [button setImage:down forState:UIControlStateNormal];
}

- (NSMutableArray *)tableArray{
    if (!_tableArray) {
        _tableArray = [NSMutableArray array];
    }
    return _tableArray;
}

- (NSMutableArray *)buttonArray{
    if (!_buttonArray) {
        _buttonArray = [NSMutableArray array];
    }
    return _buttonArray;
}

- (NSMutableArray *)rowArray{
    if (!_rowArray) {
        _rowArray = [NSMutableArray array];
        [_rowArray addObject:@0];
        [_rowArray addObject:@0];
    }
    return _rowArray;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataSource numberRowsOfColumn:tableView.tag];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSIndexPath *iPath = [NSIndexPath indexPathForRow:[indexPath row] inSection:tableView.tag];
    NSString *title = [self.dataSource titileOfNsIndexPath:iPath];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuse"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuse"];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.textLabel.text = title;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.backgroundColor = [UIColor grayColor];
    if ([indexPath row] == [self.rowArray[self.selectColumn - 1] integerValue]) {
//        UIImageView *accView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico_make"]];
//        cell.accessoryView = accView;
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }

    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSIndexPath *path = [NSIndexPath indexPathForRow:[indexPath row] inSection:self.selectColumn - 1];
    NSString *title = [self.dataSource titileOfNsIndexPath:path];
    UIButton *button = self.buttonArray[self.selectColumn - 1];
    [button setTitle:title forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"down_dark"] forState:UIControlStateNormal];
    self.rowArray[self.selectColumn - 1] = [NSNumber numberWithInteger:[indexPath row]];
    [UIView animateWithDuration:0.5 animations:^(void){
        tableView.hidden = YES;
    }];
    
    if ([self.delegate respondsToSelector:@selector(mentView:didSelectIndexPath:)]) {
        [self.delegate mentView:self didSelectIndexPath:path];
    }
    
}

@end
