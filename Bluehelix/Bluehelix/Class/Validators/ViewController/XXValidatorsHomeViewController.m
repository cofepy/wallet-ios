//
//  XXValidatorsHomeViewController.m
//  Bluehelix
//
//  Created by xu Lance on 2020/4/13.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXValidatorsHomeViewController.h"
#import "XXValidatorDetailViewController.h"
/**views*/
#import "XXValidatorCell.h"
#import "XXValidatorHeader.h"
#import "XXValidatorGripSectionHeader.h"
/**models*/
#import "XXValidatorListModel.h"
static NSString *KValidatorsListReuseCell = @"validatorsListReuseCell";
static NSString *KValidatorGripSectionHeader = @"XXValidatorGripSectionHeader";
@interface XXValidatorsHomeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *validatorsListTableView;
/**汇总数据源*/
@property (nonatomic, strong) NSMutableArray *validatorsDataArray;
/**过滤数据源*/
@property (nonatomic, strong) NSMutableArray *filtValidatorsDataArray;
/**过滤数据源*/
/**tableview header*/
@property (nonatomic, strong) XXValidatorHeader *bigHeaderView;
/**section header*/
@property (nonatomic, strong) XXValidatorGripSectionHeader *sectionHeader;
/**有效或者无效*/
@property (nonatomic, copy) NSString *validOrInvalid;
/**是否在搜索*/
@property (nonatomic, assign) BOOL isFilting;
@end

@implementation XXValidatorsHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self layoutViews];
    self.validOrInvalid = @"1";
    [self loadData];
}
#pragma mark UI
- (void)setupUI{
    self.leftButton.hidden = YES;
    [self.rightButton setTitle:LocalizedString(@"ValidatorNewCreate") forState:UIControlStateNormal];
    [self.view addSubview:self.validatorsListTableView];
    self.validatorsListTableView.tableHeaderView = self.bigHeaderView;
    
}
#pragma mark 数据
- (void)loadData{
    if (self.validatorsDataArray.count>0) {
        [self.validatorsDataArray removeAllObjects];
        [self.filtValidatorsDataArray removeAllObjects];
    }
    [self requestValidatorsList];
}
- (void)searchLoadData:(NSString*)inputSting{
    if (inputSting.length ==0) {
        self.isFilting = NO;
        [self.filtValidatorsDataArray removeAllObjects];
        self.filtValidatorsDataArray = [self.validatorsDataArray mutableCopy];
        [self.validatorsListTableView reloadData];
        return;
    }
    NSMutableArray *tempArray = [NSMutableArray array];
    for (XXValidatorListModel*model in self.filtValidatorsDataArray) {
        if ([[model.validatorDescription.moniker lowercaseString] containsString:[inputSting lowercaseString]]) {
            [tempArray addObject:model];
        }
    }
    self.isFilting = YES;
    [self.filtValidatorsDataArray removeAllObjects];
    [self.filtValidatorsDataArray addObjectsFromArray:tempArray];
    [self.validatorsListTableView reloadData];
}

#pragma mark 请求
/// 请求资产信息
- (void)requestValidatorsList {
    MJWeakSelf
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:self.validOrInvalid forKey:@"valid"];
    NSString *path = [NSString stringWithFormat:@"/api/v1/validators"];
    [HttpManager getWithPath:path params:dic andBlock:^(id data, NSString *msg, NSInteger code) {
        [weakSelf.validatorsListTableView.mj_header endRefreshing];
        if (code == 0) {
            NSLog(@"%@",data);
            NSArray *listArray = [XXValidatorListModel mj_objectArrayWithKeyValuesArray:data];
            [self.validatorsDataArray addObjectsFromArray:listArray];
            [self.filtValidatorsDataArray addObjectsFromArray:listArray];
            [self.validatorsListTableView reloadData];
        } else {
            Alert *alert = [[Alert alloc] initWithTitle:msg duration:kAlertDuration completion:^{
                       }];
            [alert showAlert];
        }
    }];
}

#pragma mark UITableViewDelegate UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.isFilting ? self.filtValidatorsDataArray.count : self.validatorsDataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 92;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    XXValidatorGripSectionHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:KValidatorGripSectionHeader];
    MJWeakSelf
    header.selectValidOrInvalidCallBack = ^(NSInteger index) {
        NSNumber *number = [NSNumber numberWithInteger:index];
        self.validOrInvalid = number.integerValue == 1 ? @"0" : @"1";
        [self loadData];
    };
    header.textfieldValueChangeBlock = ^(NSString * _Nonnull textfiledText) {
        [weakSelf searchLoadData:textfiledText];
    };
    return header;
}
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    if ([view isKindOfClass:[UITableViewHeaderFooterView class]]) {
        ((UITableViewHeaderFooterView *)view).backgroundView.backgroundColor = [UIColor clearColor];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 130;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XXValidatorCell *cell = [tableView dequeueReusableCellWithIdentifier:KValidatorsListReuseCell];
    if (!cell) {
        cell = [[XXValidatorCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:KValidatorsListReuseCell];
    }
    cell.backgroundColor = kWhite100;
    XXValidatorListModel *model = self.isFilting ? self.filtValidatorsDataArray[indexPath.row] : self.validatorsDataArray[indexPath.row];
    cell.validOrInvalid = [self.validOrInvalid isEqualToString:@"1"] ? YES :NO;
    [cell loadData:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XXValidatorDetailViewController *detailValidator = [[XXValidatorDetailViewController alloc]init];
    detailValidator.validatorModel = self.isFilting ? self.filtValidatorsDataArray[indexPath.row] : self.validatorsDataArray[indexPath.row];
    [self.navigationController pushViewController:detailValidator animated:YES];
}
#pragma mark layout
- (void)layoutViews{

}
#pragma mark lazy load
- (UITableView *)validatorsListTableView {
    MJWeakSelf
    if (_validatorsListTableView == nil) {
        _validatorsListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreen_Width, kScreen_Height - kNavHeight) style:UITableViewStylePlain];
        _validatorsListTableView.dataSource = self;
        _validatorsListTableView.delegate = self;
        _validatorsListTableView.backgroundColor = kWhite100;
        _validatorsListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _validatorsListTableView.showsVerticalScrollIndicator = NO;
        [_validatorsListTableView registerClass:[XXValidatorCell class] forCellReuseIdentifier:KValidatorsListReuseCell];
        [_validatorsListTableView registerClass:[XXValidatorGripSectionHeader class] forHeaderFooterViewReuseIdentifier:KValidatorGripSectionHeader];
        if (@available(iOS 11.0, *)) {
            _validatorsListTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _validatorsListTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf requestValidatorsList];
        }];
    }
    return _validatorsListTableView;
}
- (XXValidatorHeader*)bigHeaderView{
    if (!_bigHeaderView) {
        _bigHeaderView = [[XXValidatorHeader alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 82)];
    }
    return _bigHeaderView;;
}
#pragma mark lazy load data
- (NSMutableArray *)validatorsDataArray{
    if (!_validatorsDataArray) {
        _validatorsDataArray = [NSMutableArray array];
    }
    return _validatorsDataArray;
}
- (NSMutableArray*)filtValidatorsDataArray{
    if (!_filtValidatorsDataArray) {
        _filtValidatorsDataArray = [NSMutableArray array];
    }
    return _filtValidatorsDataArray;
}
@end