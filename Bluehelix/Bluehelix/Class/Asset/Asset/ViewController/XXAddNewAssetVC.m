//
//  XXAddNewAssetVC.m
//  Bluehelix
//
//  Created by Bhex on 2020/04/03.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXAddNewAssetVC.h"
#import "XXTokenModel.h"
#import "XXAddAssetCell.h"
#import "XXAssetSearchHeaderView.h"
#import "XXFailureView.h"
#import "XXEmptyView.h"

@interface XXAddNewAssetVC () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *tokenList; //资产币列表
@property (nonatomic, strong) XXAssetSearchHeaderView *headerView;
@property (nonatomic, strong) NSMutableArray *showArray; //展示的列表
@property (nonatomic, strong) XXFailureView *failureView; //无网络
@property (nonatomic, strong) XXEmptyView *emptyView;

@end

@implementation XXAddNewAssetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
    [self requestTokenList];
}

- (void)setupUI {
    self.titleLabel.text = LocalizedString(@"AddNewAsset");
    [self.view addSubview:self.tableView];
    self.tableView.separatorColor = KLine_Color;
    self.tableView.tableHeaderView = self.headerView;
}

/// 请求币列表
- (void)requestTokenList {
    MJWeakSelf
    [MBProgressHUD showActivityMessageInView:@""];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"page"] = @"1";
    param[@"size"] = @"2000";
    [HttpManager getWithPath:@"/api/v1/tokens" params:param andBlock:^(id data, NSString *msg, NSInteger code) {
        [MBProgressHUD hideHUD];
        if (code == 0) {
            NSLog(@"%@",data);
            weakSelf.tokenList = [XXTokenModel mj_objectArrayWithKeyValuesArray:data[@"items"]];
            weakSelf.showArray = [NSMutableArray arrayWithArray:weakSelf.tokenList];
            [[XXSqliteManager sharedSqlite] insertTokens:weakSelf.tokenList];
            [weakSelf.tableView reloadData];
        } else {
            Alert *alert = [[Alert alloc] initWithTitle:msg duration:kAlertDuration completion:^{
            }];
            [alert showAlert];
        }
    }];
}

- (void)reloadData {
    NSString *searchStr = self.headerView.searchTextField.text;
    
    if (searchStr.length) {
        [self.showArray removeAllObjects];
        for (XXTokenModel *model in self.tokenList) {
            if ([model.name containsString:searchStr]) {
                [self.showArray addObject:model];
            }
        }
    } else {
        self.showArray = [NSMutableArray arrayWithArray:self.tokenList];
    }
    [self.tableView reloadData];
}

- (void)textFieldValueChange:(UITextField *)textField {
    [self reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.showArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.showArray.count == 0) {
        if ([KUser.netWorkStatus isEqualToString:@"notReachable"]) {
            return self.failureView.height;
        } else {
            return self.emptyView.height;
        }
    } else {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.showArray.count == 0) {
        if ([KUser.netWorkStatus isEqualToString:@"notReachable"]) {
            return self.failureView;
        } else {
            return self.emptyView ;
        }
        return self.emptyView ;
    } else {
        return [UIView new];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [XXAddAssetCell getCellHeight];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XXAddAssetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XXAddAssetCell"];
    if (!cell) {
        cell = [[XXAddAssetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"XXAddAssetCell"];
    }
    XXTokenModel *model = self.showArray[indexPath.row];
    [cell configData:model];
    cell.backgroundColor = kWhiteColor;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreen_Width, kScreen_Height - kNavHeight) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = kWhiteColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _tableView;
}

- (XXAssetSearchHeaderView  *)headerView {
    if (!_headerView) {
        _headerView = [[XXAssetSearchHeaderView alloc] initWithFrame:CGRectMake(K375(16), 0, kScreen_Width - K375(32), 32 + 16)];
        [_headerView.searchTextField addTarget:self action:@selector(textFieldValueChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _headerView;
}

- (XXEmptyView *)emptyView {
    if (_emptyView == nil) {
        _emptyView = [[XXEmptyView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, self.tableView.height - K375(32)) iamgeName:@"noData" alert:LocalizedString(@"NoData")];
    }
    return _emptyView;
}

- (XXFailureView *)failureView {
    if (_failureView == nil) {
        _failureView = [[XXFailureView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, self.tableView.height - K375(32))];
        MJWeakSelf
        _failureView.reloadBlock = ^{
            [weakSelf requestTokenList];
        };
    }
    return _failureView;
}

@end
