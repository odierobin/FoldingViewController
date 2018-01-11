# FoldingViewController
横屏4向手势滑动隐藏View,支持delegate

##使用 init FoldingViewController 
参数为[FoldingZoneSetting]，设置方向，大小，是否缩放中心区，是否禁止中心区交互等
加入的内容通过xib添加

##通知 实现FoldingViewDelegate代理
设置FoldingViewController实例的delegate，目前可以获得动画开始和结束的通知，并附带目标区域ViewController

