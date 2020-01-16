import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'reader.dart';
import 'package:time_formatter/time_formatter.dart';
import 'htmlparse.dart';
import 'feeddb.dart';


class FeedsPage extends StatefulWidget {
  FeedsPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _FeedsPageState createState() => _FeedsPageState();
}

class _FeedsPageState extends State<FeedsPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).backgroundColor,
      child: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            floating: true,
            snap: true,
            title: Text("Feeds", style: Theme.of(context).textTheme.title),
            centerTitle: true,
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.refresh),
                onPressed: (){

                },
              ),
            ],
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                return FeedCard(entry: FeedEntry(
                    id: 1, title: "Title", link: "http://link-to-feed",
                    description: '<h4 id="ss-H4-1571906048311">关于栏目</h4><p>很多读者都会好奇少数派的编辑们到底平时都「装了啥」。我们希望通过「编辑部的新玩意」介绍编辑部成员们最近在用的新奇产品，让他们自己来谈谈这些新玩意的使用体验究竟如何。</p><hr> <h2><font color="#008000">@一只索狗</font>：OPPO Reno3 Pro 和 Enco Free</h2><ul><li>入手渠道：厂商送测</li><li>入手价格：Reno3 Pro 3999 元，Enco Free 699 元</li></ul><p>当我第一次拿起 Reno3 Pro 的时候，我还是熟练自如地发出了「Wow~」的声音，因为它实在是太轻了。由于我最近几个月都处于 iPhone XR（194g）+iQOO Pro 5G（217g）组合使用的状态下，所以面对 Reno3 Pro 171g 的重量，我的手臂真的得到了极大的释放。本次 Reno3 系列的外观舍弃掉了之前两代摄像头中置排列的竖条设计，而这个点在 Reno 一代发布会上官方花了很多时间来解释这个设计的意义，彻底舍弃了家族特征，这还是让我有点遗憾的。</p><figure tabindex="0" draggable="false" class="ss-img-wrapper" contenteditable="false"><img src="https://cdn.sspai.com/2020/01/16/787c6e5189d2f19e392e1a45dfada98a.jpg" alt=""><figcaption class="ss-image-caption">颜值还在，可惜背面设计换了</figcaption></figure><p>在日常的使用中，尽管骁龙 765G 与旗舰 SoC 有差距，但是市面上的在售大部分手机也都早就过了「处理器性能不够导致系统卡顿」的阶段，所以日常需求还是绰绰有余的，ColorOS 7 的审美上线也让我对这个新的系统颇有好感。Reno3 Pro 一个真正的重要改进其实是一个效果很好的超级防抖功能，之前 Reno2 裁切太多，画质也牺牲较多。几天体验下来，这台机子唯一谈不上「Pro」的地方也就也就是一颗转子马达了。</p><p>而 Enco Free 采用了今年流行的类 Airpods TWS 设计，整体摸起来质感一般。音频为 AAC 编码，给我的感觉听起来基本与 AirPods 类似，而其特色功能是在耳机柄上下滑动可以调整音量 / 切换歌曲，测试下来表现非常稳定，在 iOS 或其他智能设备上也可以正常操作。从佩戴方式的角度来讲，Enco Free 为浅入耳的设计（所以物理上无法隔绝噪音），提供了两种耳帽，但实际上更换耳帽对松紧程度影响微乎其微，我甚至觉得这样有点破坏耳机外观的一体性。（也可能是我耳洞太大）</p><figure tabindex="0" draggable="false" class="ss-img-wrapper" contenteditable="false"><img src="https://cdn.sspai.com/2020/01/16/685e92bfaba085edb2afde25ca8677e2.jpg" alt=""><figcaption class="ss-image-caption">R 为大号耳帽，L 为默认耳帽</figcaption></figure><p>但与 Reno3 Pro 类似，遗憾之处大概就是 Enco Free 并不美好的售价，￥699 这个价格有太多的竞品可以选择，加 ￥200 已经可以在某些渠道买到全新 AirPods 二代了，它显然不是一个那么有性价比的选择。</p> <h2 id="ss-H2-1571904410008"><font color="#008000">@SamWanng</font>：海信 A5</h2><ul><li>入手渠道：京东自购</li><li>价格：1199 元</li></ul><p>很早之前有听说过腾讯阅读出过一款叫做「口袋阅」的 E-ink 手机，当时因为自己不用 QQ 阅读，而且觉得设计不是太好看就没有种草。</p><p>但是前段时间在 Twitter 上发现很多人在讨论海信 A5 这款 E-ink 手机，发现手机的设计比「口袋阅」要好看一些，在微信读书推出「墨水屏」版和之前种草 The Light Phone 的推波助澜下，便在京东下单了一台。</p><figure tabindex="0" draggable="false" class="ss-img-wrapper" contenteditable="false"><img src="https://cdn.sspai.com/2020/01/16/07ddc15488c9c5787e1f89b16e7326bc.jpeg" alt=""></figure><p>海信 A5 的定位是一款阅读手机，所以在配置上没有太亮眼。A5 搭载了一块 E-ink 墨水屏，所以在 A5 上所看到的一切都是黑白的，为了较好的呈现效果，A5 的整体 UI 也以黑白色呈现（包括第三方应用）。</p><figure tabindex="0" draggable="false" class="ss-img-wrapper" contenteditable="false"><img src="https://cdn.sspai.com/2020/01/16/ab3e3bc6136d805a3a593905ff20d482.jpg" alt=""></figure><p>它搭载了前后两个摄像头，前置摄像头甚至可以人脸解锁，令人震惊。</p><p>但是黑白色的屏幕基本上也拍不出来什么所以然。想看彩色照片，那你得先把照片传到有彩色屏幕的设备上。要么你就用黑白模式，可能你会成为海信 A5 版的森山大道。</p><figure tabindex="0" draggable="false" class="ss-img-wrapper" contenteditable="false"><img src="https://cdn.sspai.com/2020/01/16/f3fc5415722527072af41b5757c3079f.jpg" alt=""></figure><p>系统方面和其他的 Android 定制版差不多，但还是有不少功能上的亮点。比如通过上滑屏幕进入极简模式，有点只看负一屏的感觉，你可以将想要用的挂件排布在极简模式的桌面上。截屏功能中的长截图、智慧识屏（大爆炸）都还挺有用的，比如现在的微信读书墨水屏版还不能划线收藏，智慧识屏就可以很方便地将屏幕中想要保持的句子识别出来保存到备忘录中。还有清晰模式到流畅模式的切换，在阅读时更显示清晰，非阅读时更好地进行其他操作，看起来没那么卡顿。</p><figure tabindex="0" draggable="false" class="ss-img-wrapper" contenteditable="false"><img src="https://cdn.sspai.com/2020/01/16/5a5858883c7cdb7b3275470349460c09.jpg" alt=""></figure><p>还有令我惊讶的一点是 A5 居然提供了 aptX、LDAC 等音频解码传输，但音质究竟怎样作为木耳的我确实听不出来好坏。</p><p>阅读方面就没什么好说的了，跟 Kindle 的阅读体验差不多，也有智能背景光，如果能给个系统上的音量键翻页功能就好了。</p><p>在使用 A5 的这段时间里，我主要将它作为一个手机大小的阅读器来使用。因为屏幕以及刷新率的问题，想进行一些娱乐活动实在是有些为难，虽然它可以播放视频、查看图片，各种拖影恐怕在你尝试几次后就主动放弃了。从另一方面来讲，这也能让你静心下来更加专注于阅读（这段时间确实比没用 A5 之前多读了很多书）。</p><p>所以如果你想要一台手机大小又可以连接网络、同步数据的阅读器，以及续航时间够久的备用电话（一个星期不充电没什么问题），海信 A5 可能是一个还不错的选择。</p> <h2 id="ss-H2-1571904420569"><font color="#008000">@三羊</font>：Sysmax 阅读架（L 号）&amp; 除静电棒</h2><ul><li>入手渠道：闲鱼/京东 </li><li>价格：129 元/11.9 元</li><li>适合人群：喜欢喝牛奶咖啡的人</li></ul><p>作者样样好，就是爱种草。继最近被 @蛋挞西瓜 种草 Boox Pro 后，又因为用手举 10.3 寸阅读器实在太沉的问题入手了这款吴青峰同款阅读架。</p><p>随着颈椎越来越苍劲，低头看书也渐渐成为负担，而且用手捧 Boox 也实在太沉了，如果把书举高，手腕也会很酸，简言之就是——「颈椎和手腕，你自己选一个吧！」</p><p>这款阅读架是木质的，并不是实木，不过也因此比较轻便。边缘的切角都打磨得比较光滑，没有木刺。书架的压脚灵活有力，而且用了胶垫包住，不会损伤书页。我试了几本比较厚且不太好翻的书（用手压一会儿就会烦的那种），用压脚也能轻轻松松压住。于是，在不想动弹的周末下午，背靠沙发瘫在地板上看的东西变成了书和漫画，顺便还解放了双手和膝盖来撸猫， 喝水也更方便了——这个架子简直把书变成了电视啊！</p><p>支架的重心设计也比较合理，完全不用担心放了比较重的书「翻车」的情况。支架有十几档高度可以调节，不管是瘫在地板还是正襟危坐，都可以找到合适的支架高度。L 号架子可以放下最大 14 寸的屏幕，用作 iPad 架子也很合适。</p><p>但虽然是青峰同款，我也想吐槽这么个三夹板木架子卖 160（原价）是不是有点太贵了……不过根据蛋挞西瓜的反馈，之前她买过比较便宜的同类产品，稳定性和这款支架相差比较远，看来青峰同款还是有过人之处。</p><figure tabindex="0" draggable="false" class="ss-img-wrapper" contenteditable="false"><img src="https://cdn.sspai.com/2020/01/16/836254dd5da395509c671e665b4cba71.jpg" alt=""><figcaption class="ss-image-caption">惬意的周末下午</figcaption></figure><p>想推荐的另一个小东西是除静电棒。我是个冬天经常被电的人，之前也买过除静电喷雾和手环，几乎没用，简直是智商税。之前也在知乎上看到有人回答说可以用手握住钥匙来尖端放电，但我自己试验并没有成功。直到有天被电得忍无可忍，想着应该有什么东西能代替我来尖端放电，就上京东搜了一哈子——果然，之前二十几年都白白被电了。这个小棒就是易导电的金属材质，中间还有一个小灯泡，有电流通过就会发光。只要在触摸自己预计会被电的东西（金属门、毛衣甚至猫）先用小棒划拉一下去放电，就不会被电到了。</p><figure tabindex="0" draggable="false" class="ss-img-wrapper" contenteditable="false"><img src="https://cdn.sspai.com/2020/01/16/774087e4ff2c4e7f0bdb5625ae973f1d.jpeg" alt=""></figure> <p><font color="#008000" style="font-size: 24px; font-family: &quot;PingFang SC&quot;, &quot;Helvetica Neue&quot;, Helvetica, &quot;Hiragino Sans GB&quot;, &quot;Microsoft YaHei&quot;, Arial, sans-serif; font-style: inherit; font-variant-ligatures: inherit; font-variant-caps: inherit;">@waychane</font><span style="font-size: 24px; font-family: &quot;PingFang SC&quot;, &quot;Helvetica Neue&quot;, Helvetica, &quot;Hiragino Sans GB&quot;, &quot;Microsoft YaHei&quot;, Arial, sans-serif;">：U.Sage 3-Way Helmet Bag</span></p><ul><li>入手渠道：淘宝 </li><li>入手价格：499 元</li></ul><p>美军在上世纪 50 年代推出了空军头盔包 (Flyers Helmet Bag)，旨在让飞行员收纳飞行头盔及其它用品。经过半个多世纪的改进，头盔包在设计上经过了多次变化，也因其简洁、便携、容量大等特点，成为了不少服装品牌复刻的单品。我入手的是国内复古男装品牌 U.Sage 在 2019 秋冬第四季推出、以美军 1973 年款头盔包为原型制作的三用空军头盔包，这款包在前侧保留了双大口袋设计，内部夹层可以轻松收纳 MacBook Pro 及少量衣物，可以满足短途短时间的出差和旅行需求。</p><figure tabindex="0" draggable="false" class="ss-img-wrapper" contenteditable="false"><img src="https://cdn.sspai.com/2020/01/16/9835072aa76c3b0d54eb577854078439.jpeg" alt=""></figure><p>顾名思义，「三用」表示这款包有三种背法：单肩、双肩、手拎：这样不仅能根据不同的穿搭风格选择合适的用法，也能满足大部分日常使用场景中的需求；比如，学生可以选择双肩背，上班族可以选择手拎，单肩背的用法则能用于生活中大多数场景。</p><figure tabindex="0" draggable="false" class="ss-img-wrapper" contenteditable="false"><img src="https://cdn.sspai.com/2020/01/16/d1f9e6b9d00f1eabc88c042eba3a3ebe.jpg" alt=""></figure><p>U.Sage 头盔包使用的是 CORDURA 面料：在保持了相对较轻的重量的同时，面料具有的耐磨和耐撕裂等特性也能满足一些户外运动爱好者的需求，唯一的缺点可能是比较粘毛。不过，这款包目前已经售罄，如果你对这类头盔包感兴趣，日本户外生活品牌 <a href="http://fce.tools/" target="_blank" class="insert-link">F/CE.</a> 也有一款包型接近的三用头盔包，同样使用 CORDURA 面料，美中不足是价格贵了一倍多，只能通过代购渠道购买。</p> <h2 id="ss-H2-1571909984599"><font color="#008000">@Clyde</font>：青萍蓝牙闹钟</h2> <ul><li>入手渠道：小米有品 </li><li>价格：59 元</li></ul><p>青萍蓝牙闹钟是那种本来觉得没什么必要，但价格（众筹只要 59 元）实在太美丽让人难以忍住下单冲动的小玩意。虽然一开始我对这种「百元好物」级别的东西并不感冒，到手后还是忍不住对社会主义强大的工业设计和制造能力进行了一波赞叹。</p><figure tabindex="0" draggable="false" class="ss-img-wrapper" contenteditable="false"><img src="https://cdn.sspai.com/2020/01/16/b34193ac82028d5e0a49349008c8fb11.jpg" alt=""></figure><p>和传统观念中长着「小耳朵」的闹钟不太一样，青萍蓝牙闹钟设计上最大的特色就是「没有按键」——闹钟响起之后整个机身就是按键。机身和底座之间的连接方式因为我还没有拆开看所以不得而知，但这种整体按压式设计的确是巧妙又有点……解压。有起床气的时候从被窝里掏出手随手一按再睡十分钟，十分钟后再按一下，十分钟后再按一次……</p><figure tabindex="0" draggable="false" class="ss-img-wrapper" contenteditable="false"><img src="https://cdn.sspai.com/2020/01/16/d6c2534d3fa6ff7b54612ea1298fcc19.gif" alt=""></figure><blockquote>老板我真的不是睡懒觉，你不觉得这闹钟按起来有点带感吗……？</blockquote><p>玩笑归玩笑，之所以感叹青萍的设计和制造能力，是因为这款闹钟除了有意思的按压设计外还整合了温湿度计，不大的显示区域里除了正中央的时间、顶上的闹钟提醒、日期和蓝牙状态之外，底部还会显示当前的室内温湿度。虽然我没办法对数据准确性进行测试，在官网看了看介绍说里面用到的是来自瑞士的 Sensirion 传感器，温度测量精度误差为正负 0.2 摄氏度，湿度测量精度为正负 2% 相对湿度，居家使用算得上是足够灵敏了。</p><figure tabindex="0" draggable="false" class="ss-img-wrapper" contenteditable="false"><img src="https://cdn.sspai.com/2020/01/16/bff08e77f327912ee1175f8214951e42.jpg" alt=""></figure><p>对了，说起温湿度，作为一款来自小米有品的小东西，青萍蓝牙闹钟也毫不意外地能够与米家的其他设备联动：温度低于 20 摄氏度时打开电暖器，湿度低于 20% 打开除菌加湿器……如果你家里已经有其它米家的产品，围绕这么一款百元不到的小闹钟还能实现很多有意思的互动。</p><figure tabindex="0" draggable="false" class="ss-img-wrapper" contenteditable="false"><img src="https://cdn.sspai.com/2020/01/16/7b818782c2d74378aec7a453cf8bb0d7.png" alt=""></figure><p>总体而言这款温度计、湿度计、闹钟三合一的小玩意还是非常划算的，不知不觉它已经成为了我床头柜上的常驻产品。</p><ul></ul> <p><b style="font-family: -apple-system, BlinkMacSystemFont, PingFang-SC-Regular, &quot;Hiragino Sans GB&quot;, &quot;Microsoft Yahei&quot;, Arial, sans-serif; font-style: inherit; font-variant-ligatures: inherit; font-variant-caps: inherit;">如果你也想分享「新玩意」🔉：</b></p><p>很多读者表示自己也有一些希望分享的有趣产品。为了能让更多读者参与，我们决定在「新玩意」栏目最后添加一个新的版块，邀请大家分享你的「新玩意」，你只需要： </p><ul><li>用 500-800 字介绍产品</li><li>配上 1-2 张产品的实拍图片</li></ul><p>成功入选栏目除了获得登上首页的机会，还可以得到 80 元的「剁手抚恤金」🧧。如果你有兴趣参与，就赶紧 <a href="https://jinshuju.net/f/e99ga9" target="_blank" class="insert-link">填写表单</a> 报名吧！</p><p> 下载少数派 <a href="https://sspai.com/page/client">客户端</a>、关注 <a href="https://sspai.com/s/J71e">少数派公众号</a> ，了解更多的新玩意 🆒</p><p> 特惠、好用的硬件产品，尽在 <a href="https://shop549593764.taobao.com/?spm=a230r.7195193.1997079397.2.2ddc7e0bPqKQHc">少数派sspai官方店铺</a> 🛒</p><p><br></p>',
                    author: "Author", getTime: 1579158605, sourceID: 1, readState: 0
                ));
              },
              childCount: 20,
            ),
          )
        ],
      ),
    );
  }
}

class FeedCard extends StatelessWidget {
  FeedCard({Key key, this.entry}) : super(key: key);
  final FeedEntry entry;

  String removeAllHtmlTags(String htmlText) {
    RegExp exp = RegExp(
        r"<[^>]*>",
        multiLine: true,
        caseSensitive: true
    );

    return htmlText.replaceAll(exp, '');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Card(
          elevation: 0,
          child: InkWell(
            splashColor: Colors.blue.withAlpha(30),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => ReaderScreen()));
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 10),
                  child: Text("From source name", style: TextStyle(fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.left)
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 10),
                  child: Text(entry.title, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold), maxLines: 2, overflow: TextOverflow.ellipsis),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: Text(removeAllHtmlTags(entry.description),style: TextStyle(fontSize: 16, fontFamily: "serif"), maxLines: 4, overflow: TextOverflow.ellipsis),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(16, 0, 8, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        formatTime(entry.getTime * 1000),
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
                      ),
                      IconButton(
                        iconSize: 18,
                        icon: Icon(Icons.more_vert),
                        onPressed: (){},
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        Divider()
      ],
    );
  }
}