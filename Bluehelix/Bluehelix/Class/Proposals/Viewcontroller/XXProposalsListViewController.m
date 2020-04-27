//
//  XXProposalsListViewController.m
//  Bluehelix
//
//  Created by xu Lance on 2020/4/23.
//  Copyright © 2020 Bhex. All rights reserved.
//
/**ViewController*/
#import "XXProposalsListViewController.h"
#import "XXVoteProposalViewController.h"
#import "XXProposalDetailViewController.h"
/**Views*/
#import "XXProposalTableViewCell.h"
#import "XXProposalListHeader.h"
#import "XXProposalGripSectionHeader.h"
/**model*/
#import "XXProposalListModel.h"

static NSString *KProposalTableViewCell = @"XXProposalTableViewCell";
static NSString *KProposalGripSectionHeader = @"ProposalGripSectionHeader";
static NSInteger pageCount = 20;
@interface XXProposalsListViewController ()<UITableViewDelegate,UITableViewDataSource>
/**列表*/
@property (nonatomic, strong) UITableView *proposalsTableView;
/**原有数据源*/
@property (nonatomic, strong) NSMutableArray *proposalListArray;
/**搜索后的数据源*/
@property (nonatomic, strong) NSMutableArray *filtProposalsArray;
/**tableview header*/
@property (nonatomic, strong) XXProposalListHeader *bigHeaderView;
/**seciton header*/
@property (nonatomic, strong) XXProposalGripSectionHeader *sectionHeader;
/**当前第几页*/
@property (nonatomic, assign) NSInteger pageNumber;
/**是否在搜索*/
@property (nonatomic, assign) BOOL isFilting;
@end

@implementation XXProposalsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self loadData];
}
#pragma mark UI
- (void)setupUI{
    self.leftButton.hidden = YES;
    [self.rightButton setTitle:LocalizedString(@"Voting") forState:UIControlStateNormal];
    [self.view addSubview:self.proposalsTableView];
    self.proposalsTableView.tableHeaderView = self.bigHeaderView;
    
}

#pragma mark 数据
- (void)loadData{
    if (self.proposalListArray.count>0) {
        [self.proposalListArray removeAllObjects];
        [self.filtProposalsArray removeAllObjects];
    }
    self.pageNumber = 1;
    [self requestProposalList];
}
- (void)searchLoadData:(NSString*)inputSting{
    if (inputSting.length ==0) {
        self.isFilting = NO;
        [self.filtProposalsArray removeAllObjects];
        self.filtProposalsArray = [self.proposalListArray mutableCopy];
        [self.proposalsTableView reloadData];
        return;
    }
    NSMutableArray *tempArray = [NSMutableArray array];
    for (XXProposalModel*model in self.filtProposalsArray) {
        if ([[model.title lowercaseString] containsString:[inputSting lowercaseString]]) {
            [tempArray addObject:model];
        }
    }
    self.isFilting = YES;
    [self.filtProposalsArray removeAllObjects];
    [self.filtProposalsArray addObjectsFromArray:tempArray];
    [self.proposalsTableView reloadData];
}
#pragma mark 请求
/// 请求提案列表信息
- (void)requestProposalList {
    @weakify(self)
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@(self.pageNumber) forKey:@"page"];
    [dic setObject:@(pageCount) forKey:@"page_size"];
    NSString *path = [NSString stringWithFormat:@"/api/v1/proposals"];
    [HttpManager getWithPath:path params:dic andBlock:^(id data, NSString *msg, NSInteger code) {
        @strongify(self)
        [self.proposalsTableView.mj_header endRefreshing];
        [self.proposalsTableView.mj_footer endRefreshing];
        [MBProgressHUD hideHUD];
        if (code == 0) {
            NSLog(@"%@",data);
            
            XXProposalListModel *dataModel= [XXProposalListModel mj_objectWithKeyValues:data];
            NSMutableArray *listArray = [NSMutableArray arrayWithArray:dataModel.proposals];
            if (listArray.count < pageCount) {
                [self.proposalsTableView.mj_footer endRefreshingWithNoMoreData];
            }
            [self.proposalListArray addObjectsFromArray:listArray];
            [self.filtProposalsArray addObjectsFromArray:listArray];
            [self.proposalsTableView reloadData];
        } else {
            Alert *alert = [[Alert alloc] initWithTitle:msg duration:kAlertDuration completion:^{
            }];
            [alert showAlert];
        }
    }];
}
#pragma mark
- (void)rightButtonClick:(UIButton *)sender{
    XXVoteProposalViewController *vote = [[XXVoteProposalViewController alloc]init];
    [self.navigationController pushViewController:vote animated:YES];
}
#pragma mark UITableViewDelegate UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.isFilting ? self.filtProposalsArray.count : self.proposalListArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 64;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    self.sectionHeader = [tableView dequeueReusableHeaderFooterViewWithIdentifier:KProposalGripSectionHeader];
    @weakify(self)
    self.sectionHeader.textfieldValueChangeBlock = ^(NSString * _Nonnull textfiledText) {
        @strongify(self)
        [self searchLoadData:textfiledText];
    };
    return self.sectionHeader;
}
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    if ([view isKindOfClass:[UITableViewHeaderFooterView class]]) {
        ((UITableViewHeaderFooterView *)view).backgroundView.backgroundColor = [UIColor clearColor];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return self.proposalsTableView.rowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XXProposalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KProposalTableViewCell];
    if (!cell) {
        cell = [[XXProposalTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:KProposalTableViewCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = kWhiteColor;
    XXProposalModel *model = self.isFilting ? self.filtProposalsArray[indexPath.row] : self.proposalListArray[indexPath.row];
    [cell loadDataWithModel:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XXProposalDetailViewController *detailProposal = [[XXProposalDetailViewController alloc]init];
    XXProposalModel *model = self.isFilting ? self.filtProposalsArray[indexPath.row] : self.proposalListArray[indexPath.row];
    detailProposal.proposalModel = model;
    [self.navigationController pushViewController:detailProposal animated:YES];
}
#pragma mark lazy load
- (UITableView *)proposalsTableView {
    if (_proposalsTableView == nil) {
        @weakify(self)
        _proposalsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreen_Width, kScreen_Height - kNavHeight -kTabbarHeight) style:UITableViewStylePlain];
        _proposalsTableView.dataSource = self;
        _proposalsTableView.delegate = self;
        _proposalsTableView.backgroundColor = kWhiteColor;
        _proposalsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _proposalsTableView.showsVerticalScrollIndicator = NO;
        _proposalsTableView.estimatedRowHeight = 200;
        _proposalsTableView.rowHeight = UITableViewAutomaticDimension;
        [_proposalsTableView registerClass:[XXProposalTableViewCell class] forCellReuseIdentifier:KProposalTableViewCell];
        [_proposalsTableView registerClass:[XXProposalGripSectionHeader class] forHeaderFooterViewReuseIdentifier:KProposalGripSectionHeader];
        if (@available(iOS 11.0, *)) {
            _proposalsTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _proposalsTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            @strongify(self)
            [self loadData];
            [self.proposalsTableView.mj_footer resetNoMoreData];
        }];
        _proposalsTableView.mj_footer = [MJRefreshFooter footerWithRefreshingBlock:^{
            @strongify(self)
            pageCount = pageCount + 1;
            [self requestProposalList];
        }];
    }
    return _proposalsTableView;
}
- (XXProposalListHeader*)bigHeaderView{
    if (!_bigHeaderView) {
        _bigHeaderView = [[XXProposalListHeader alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 122)];
    }
    return _bigHeaderView;;
}
#pragma mark lazy load data
- (NSMutableArray *)proposalListArray{
    if (!_proposalListArray) {
        _proposalListArray = [NSMutableArray array];
    }
    return _proposalListArray;
}
- (NSMutableArray *)filtProposalsArray{
    if (!_filtProposalsArray) {
        _filtProposalsArray = [NSMutableArray array];
    }
    return _filtProposalsArray;
}
@end