# BCKeyboard
这是一个聊天键盘，使用方法
NSArray *array = @[@"chatBar_colorMore_audioCall",@"chatBar_colorMore_location",@"chatBar_colorMore_photoSelected",@"chatBar_colorMore_video@2x.png",@"chatBar_colorMore_video@2x.png",@"chatBar_colorMore_video@2x.png"];更多View的图片\<h1\><br /> 
BCKeyBoard *bc = [[BCKeyBoard alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 46, [UIScreen mainScreen].bounds.size.width,46)];\<h1\><br /> 
bc.delegate = self;\<h1\><br /> 
bc.imageArray = array;\<h1\><br /> 
bc.placeholder = @"";占位文字\<h1\><br /> 
bc.placeholderColor = ;占位文字颜色\<h1\><br /> 
bc.backgroundColor = [UIColor clearColor];\<h1\><br /> 
[self.view addSubview:bc];\<h1\><br /> 