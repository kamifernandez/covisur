//
//  PresentacionViewController.h
//  Covisur
//
//  Created by Christian Fernandez on 7/02/17.
//  Copyright © 2017 Sainet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PresentacionViewController : UIViewController<UITabBarControllerDelegate>

@property(nonatomic,weak)IBOutlet UICollectionView * collection;

@property(nonatomic,weak)IBOutlet UIPageControl * pageCollection;

@property(nonatomic,strong)NSMutableArray * data;

@property(nonatomic,weak)IBOutlet UIButton * btnSaltarPresentacion;

@property(nonatomic,strong)NSString *tokenWeb;


@end
