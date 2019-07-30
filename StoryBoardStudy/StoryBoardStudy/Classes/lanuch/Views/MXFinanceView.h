//
//  MXFinanceView.h
//  StoryBoardStudy
//
//  Created by 马霄 on 2019/4/16.
//  Copyright © 2019 马霄. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MXFinanceView : UIView
- (IBAction)button:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@end

NS_ASSUME_NONNULL_END
