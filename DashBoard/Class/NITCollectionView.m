//
//  NITCollectionView.m
//  DashBoard
//
//  Created by totyu3 on 17/1/19.
//  Copyright © 2017年 NIT. All rights reserved.
//

#import "NITCollectionView.h"

@implementation NITCollectionView


-(void)setLayoutType:(NSString *)LayoutType{

    UICollectionViewFlowLayout *layout;
    CGSize itemSize;
    if ([LayoutType isEqualToString:@"main"]) {
        layout = [LWLCollectionViewHorizontalLayout new];
        itemSize = CGSizeMake(self.width/3,self.height/2);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }else if([LayoutType isEqualToString:@"paging"]){
        layout = [UICollectionViewFlowLayout new];
        itemSize = CGSizeMake(self.width,self.height);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }else if([LayoutType isEqualToString:@"reusablecv"]){
        layout = [UICollectionViewFlowLayout new];
        itemSize = CGSizeMake(self.width,(self.height/2)/3);
        layout.footerReferenceSize = CGSizeMake(self.width,self.height/2);
    }else if([LayoutType isEqualToString:@"colorselect"]){
        layout = [UICollectionViewFlowLayout new];
        itemSize = CGSizeMake(self.width,self.height/5+(self.height/5*0.1));
    } else {
        layout = [UICollectionViewFlowLayout new];
        itemSize = CGSizeMake(self.width,self.height/[LayoutType intValue]);
    }

    
    layout.itemSize = itemSize;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    self.collectionViewLayout = layout;

}

@end
