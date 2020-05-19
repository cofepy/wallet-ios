//
//  XXUserHeaderItemView.m
//  Bluehelix
//
//  Created by 袁振 on 2020/5/18.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXUserHeaderItemView.h"

@implementation XXUserHeaderItemView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
         self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
        [self.layer insertSublayer:self.shadowLayer atIndex:0];
        [self addSubview:self.nameLabel];
        [self addSubview:self.icon];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)tap {
    if (self.block) {
        self.block();
    }
}

- (CALayer *)shadowLayer {
    if (!_shadowLayer) {
        _shadowLayer = [CALayer layer];
        _shadowLayer.frame = CGRectMake(0, 0, self.width, self.height -4);
        _shadowLayer.cornerRadius = 10;
        _shadowLayer.backgroundColor = [kWhiteColor CGColor];
        _shadowLayer.shadowColor = [kGray200 CGColor];
        _shadowLayer.shadowOffset = CGSizeMake(0, 2);
        _shadowLayer.shadowOpacity = 0.8;
        _shadowLayer.shadowRadius = 2;
    }
    return _shadowLayer;
}

- (XXLabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [XXLabel labelWithFrame:CGRectMake(16, 24, self.width - 60, self.height - 48) font:kFontBold(15) textColor:kGray700];
        _nameLabel.numberOfLines = 0;
    }
    return _nameLabel;
}

- (UIImageView *)icon {
    if (!_icon) {
        _icon = [[UIImageView alloc] initWithFrame:CGRectMake(self.width - 48, (self.height - 36)/2, 36, 36)];
    }
    return _icon;
}

@end
