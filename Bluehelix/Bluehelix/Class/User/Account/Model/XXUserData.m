//
//  XXUserData.m
//  Bluehelix
//
//  Created by Bhex on 2020/03/16.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXUserData.h"


@implementation XXUserData

static XXUserData *_sharedUserData = nil;
+ (XXUserData *)sharedUserData {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedUserData = [[XXUserData alloc] init];
    });
    return _sharedUserData;
}

// 夜间模式
- (void)setIsNightType:(BOOL)isNightType {
    [self saveValeu:@(isNightType) forKey:@"isNightType"];
}

- (BOOL)isNightType {
    return [[self getValueForKey:@"isNightType"] boolValue];
}

// 手动设置夜间模式 非系统默认
- (void)setIsSettedNightType:(BOOL)isSettedNightType {
    [self saveValeu:@(isSettedNightType) forKey:@"isSettedNightTypeKey"];
}

- (BOOL)isSettedNightType {
    return [[self getValueForKey:@"isSettedNightTypeKey"] integerValue];
}

// 隐藏小额币种
- (void)setIsHideSmallCoin:(BOOL)isHideSmallCoin {
    [self saveValeu:@(isHideSmallCoin) forKey:@"isHideSmallCoin"];
}

- (BOOL)isHideSmallCoin {
    return [[self getValueForKey:@"isHideSmallCoin"] integerValue];
}

// 是否隐藏资产
- (void)setIsHideAsset:(BOOL)isHideAsset {
    [self saveValeu:@(isHideAsset) forKey:@"isHideAsset"];
}

- (BOOL)isHideAsset {
    return [[self getValueForKey:@"isHideAsset"] integerValue];
}

// 是否阅读协议
- (void)setAgreeService:(BOOL)agreeService {
    [self saveValeu:@(agreeService) forKey:@"agreeService"];
}

- (BOOL)agreeService {
    return [[self getValueForKey:@"agreeService"] integerValue];
}

// 临时用户名
- (void)setLocalUserName:(NSString *)localUserName {
    [self saveValeu:localUserName forKey:@"localUserName"];
}

- (NSString *)localUserName {
    return [self getValueForKey:@"localUserName"];
}

- (void)setRatesKey:(NSString *)ratesKey {
    [self saveValeu:ratesKey forKey:@"ratesKey"];
}

- (NSString *)ratesKey {
    
    if ([self getValueForKey:@"ratesKey"] == nil) {
        if ([[[LocalizeHelper sharedLocalSystem] getLanguageCode] hasPrefix:@"zh-"]) {
            [self setRatesKey:@"cny"];
            return @"cny";
        } else if ([[[LocalizeHelper sharedLocalSystem] getLanguageCode] hasPrefix:@"ko"]) {
            [self setRatesKey:@"krw"];
            return @"krw";
        } else if ([[[LocalizeHelper sharedLocalSystem] getLanguageCode] hasPrefix:@"ja"]) {
            [self setRatesKey:@"jpy"];
            return @"jpy";
        } else if ([[[LocalizeHelper sharedLocalSystem] getLanguageCode] hasPrefix:@"vi"]) {
            [self setRatesKey:@"vnd"];
            return @"vnd";
        } else {
            [self setRatesKey:@"usd"];
            return @"usd";
        }
    }
    return [self getValueForKey:@"ratesKey"];
}

- (void)setIsFaceIDLockOpen:(BOOL)isFaceIDLockOpen {
//    if (isFaceIDLockOpen) {
//        KUser.shouldVerify = NO;
//    }
//    NSDictionary *userLockDic = [BHUserDefaults objectForKey:KUser.address];
//    NSMutableDictionary *saveDic = [NSMutableDictionary dictionaryWithDictionary:userLockDic];
//    [saveDic setObject:@(isFaceIDLockOpen) forKey:@"FaceIDLockOpen"];
//    [BHUserDefaults setObject:saveDic forKey:KUser.address];
    [self saveValeu:@(isFaceIDLockOpen) forKey:@"FaceIDLockOpen"];
}

- (BOOL)isFaceIDLockOpen {
//    NSDictionary *userLockDic = [BHUserDefaults objectForKey:KUser.address];
//    if (!userLockDic) {
//        return NO;
//    } else {
//        return [[userLockDic objectForKey:@"FaceIDLockOpen"] boolValue];
//    }
    return [[self getValueForKey:@"FaceIDLockOpen"] boolValue];
}

- (BOOL)isTouchIDLockOpen {
//    NSDictionary *userLockDic = [BHUserDefaults objectForKey:KUser.address];
//    if (!userLockDic) {
//        return NO;
//    } else {
//        return [[userLockDic objectForKey:@"TouchIDLockOpen"] boolValue];
//    }
     return [[self getValueForKey:@"TouchIDLockOpen"] boolValue];
}

- (void)setIsTouchIDLockOpen:(BOOL)isTouchIDLockOpen {
//    if (isTouchIDLockOpen) {
//        KUser.shouldVerify = NO;
//    }
//    NSDictionary *userLockDic = [BHUserDefaults objectForKey:KUser.address];
//    NSMutableDictionary *saveDic = [NSMutableDictionary dictionaryWithDictionary:userLockDic];
//    [saveDic setObject:@(isTouchIDLockOpen) forKey:@"TouchIDLockOpen"];
//    [BHUserDefaults setObject:saveDic forKey:KUser.address];
     [self saveValeu:@(isTouchIDLockOpen) forKey:@"TouchIDLockOpen"];
}

- (void)setHaveLogged:(BOOL)haveLogged {
//    NSDictionary *userLockDic = [BHUserDefaults objectForKey:KUser.address];
//    NSMutableDictionary *saveDic = [NSMutableDictionary dictionaryWithDictionary:userLockDic];
//    [saveDic setObject:@(haveLogged) forKey:@"HaveLogged"];
//    [BHUserDefaults setObject:saveDic forKey:KUser.address];
    [self saveValeu:@(haveLogged) forKey:@"HaveLogged"];
}

- (BOOL)haveLogged {
//    NSDictionary *userLockDic = [BHUserDefaults objectForKey:KUser.address];
//    if (!userLockDic) {
//        return NO;
//    } else {
//        return [[userLockDic objectForKey:@"HaveLogged"] boolValue];
//    }
     return [[self getValueForKey:@"HaveLogged"] boolValue];
}

- (BOOL)shouldVerify {
    return [[self getValueForKey:@"BHShouldVerify"] boolValue];
}

- (void)setShouldVerify:(BOOL)shouldVerify {
    [self saveValeu:@(shouldVerify) forKey:@"BHShouldVerify"];
}

// 当前账户
- (XXAccountModel *)currentAccount {
   return [[XXSqliteManager sharedSqlite] accountByAddress:KUser.address];
}

// 当前账户地址
- (void)setAddress:(NSString *)address {
    [self saveValeu:address forKey:@"address"];
}

- (NSString *)address {
    return [self getValueForKey:@"address"];
}

// 网络状态
- (void)setNetWorkStatus:(NSString *)netWorkStatus {
    [self saveValeu:netWorkStatus forKey:@"netWorkStatus"];
}

- (NSString *)netWorkStatus {
    return [self getValueForKey:@"netWorkStatus"];
}

//// 账户数组
- (NSArray *)accounts {
    return [[XXSqliteManager sharedSqlite] accounts];
}

-(id)getValueForKey:(NSString*)key{
    id value = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    return value;
}

-(void)saveValeu:(id)value forKey:(NSString *)key{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//- (void)addAccount:(NSDictionary *)account {
//    NSArray *oldArray = [self getValueForKey:@"accounts"];
//    if (!oldArray) {
//        oldArray = [NSMutableArray array];
//    }
//    NSMutableArray *array = [NSMutableArray arrayWithArray:oldArray];
//    [array addObject:account];
//    [self saveValeu:array forKey:@"accounts"];
//}

//- (NSString *)increaseID {
//   NSString *increaseID = [self getValueForKey:@"increaseID"];
//    if (increaseID) {
//        int num = increaseID.intValue +1;
//        [self saveValeu:[NSString stringWithFormat:@"%d",num] forKey:@"increaseID"];
//        return [NSString stringWithFormat:@"%d",num];
//    } else {
//        [self saveValeu:@"0" forKey:@"increaseID"];
//        return @"0";
//    }
//}

@end
