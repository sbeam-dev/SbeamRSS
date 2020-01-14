import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

const kHtml = '''
<p>The security risks inherent in Chinese-made 5G networking equipment are easy to understand. Because the companies that make the equipment are subservient to the Chinese government, they could be forced to include backdoors in the hardware or software to give Beijing remote access. Eavesdropping is also a risk, although efforts to listen in would almost certainly be detectable. More insidious is the possibility that Beijing could use its access to degrade or disrupt communications services in the event of a larger geopolitical conflict. Since the internet, especially the “internet of things,” is expected to rely heavily on 5G infrastructure, potential Chinese infiltration is a serious national security threat.</p><p>But keeping <a href="https://www.economist.com/china/2019/08/08/huawei-is-trying-to-solve-a-hard-problem">untrusted companies</a> like Huawei out of Western infrastructure <a href="https://www.nytimes.com/2019/09/25/opinion/huawei-internet-security.html">isn’t enough</a> to secure 5G. Neither is banning Chinese microchips, software, or programmers. Security vulnerabilities in the standards—the protocols and software for 5G—ensure that vulnerabilities will remain, regardless of who provides the hardware and software. These insecurities are a result of market forces that prioritize costs over security and of governments, including the United States, that want to preserve the option of surveillance in 5G networks. If the United States is serious about tackling the national security threats related to an insecure 5G network, it needs to rethink the extent to which it values corporate profits and government espionage over security.</p><p>To be sure, there are significant <a href="https://www.5gamericas.org/wp-content/uploads/2019/08/5G-Security-White-Paper-07-26-19-FINAL.pdf">security improvements</a> in 5G over 4G—in encryption, authentication, integrity protection, privacy, and network availability. But the enhancements aren’t enough.</p><p><span class="pull-quote-sidebar">This design dramatically increases the points vulnerable to attack.</span></p><p>The 5G security problems are threefold. First, the standards are simply too complex to implement securely. This is true for <a href="https://www.schneier.com/essays/archives/1999/11/a_plea_for_simplicit.html">all software</a>, but the 5G protocols offer particular difficulties. Because of how it is designed, the system blurs the wireless portion of the network connecting phones with base stations and the core portion that routes data around the world. Additionally, much of the network is virtualized, meaning that it will rely on software running on dynamically configurable hardware. This design dramatically increases the points vulnerable to attack, as does the expected massive increase in both things connected to the network and the data flying about it.</p><p>Second, there’s so much backward compatibility built into the 5G network that older vulnerabilities remain. 5G is an evolution of the decade-old 4G network, and most networks will mix generations. Without the ability to do a clean break from 4G to 5G, it will simply be impossible to improve security in some areas. Attackers may be able to force 5G systems to use more vulnerable 4G protocols, for example, and 5G networks will <a href="https://gcn.com/articles/2019/10/21/5g-security.aspx">inherit</a> many existing problems.</p><p><span class="pull-quote-sidebar">Operators even ignored security features defined as mandatory in the standard because implementing them was expensive.</span></p><p>Third, the 5G standards committees missed many opportunities to improve security. Many of the new security features in 5G are optional, and network operators can choose not to implement them. The same <a href="https://www.wired.com/story/5g-more-secure-4g-except-when-not/">happened</a> with 4G; operators even ignored security features defined as mandatory in the standard because implementing them was expensive. But even worse, for 5G, development, performance, cost, and time to market were all prioritized over security, which was treated as an afterthought.</p><p>Already problems are being discovered. In November 2019, researchers <a href="https://techcrunch.com/2019/11/12/5g-flaws-locations-spoof-alerts/">published</a> <a href="http://www.documentcloud.org/documents/6544575-5GReasoner.html">vulnerabilities</a> that allow 5G users to be tracked in real time, be sent fake emergency alerts, or be disconnected from the 5G network altogether. And this wasn’t the first <a href="https://i.blackhat.com/USA-19/Wednesday/us-19-Shaik-New-Vulnerabilities-In-5G-Networks-wp.pdf">reporting</a> to <a href="https://syssec.kaist.ac.kr/pub/2019/kim_sp_2019.pdf">find</a> <a href="https://arxiv.org/abs/1806.10360">issues</a> in 5G protocols and implementations.</p><p>Chinese, Iranians, North Koreans, and Russians have been breaking into U.S. networks for years without having any control over the hardware, the software, or the companies that produce the devices. (And the U.S. National Security Agency, or NSA, has been breaking into foreign networks for years without having to coerce companies into deliberately adding backdoors.) Nothing in 5G prevents these activities from continuing, even increasing, in the future.</p><p>Solutions are few and far between and not very satisfying. It’s really too late to secure 5G networks. Susan Gordon, then-U.S. principal deputy director of national intelligence, had it right when she <a href="https://www.latimes.com/business/technology/la-fi-tn-5g-huawei-security-espionage-20190401-story.html">said</a> last March: “You have to presume a dirty network.” Indeed, the United States needs to accept 5G’s insecurities and build secure systems on top of it. In some cases, doing so isn’t hard: Adding encryption to an iPhone or a messaging system like WhatsApp provides security from eavesdropping, and distributed protocols provide security from disruption—regardless of how insecure the network they operate on is. In other cases, it’s impossible. If your smartphone is vulnerable to a downloaded exploit, it doesn’t matter how secure the networking protocols are. Often, the task will be somewhere in between these two extremes.</p><p><span class="pull-quote" data-pullquote="placeholder">In the long term, the United States needs a <a href="https://scholarcommons.usf.edu/cgi/viewcontent.cgi?article=1058&amp;context=mca">national policy</a> that prioritizes security over both corporate profits and government surveillance.</span> 5G security is just one of the many areas in which near-term corporate profits prevailed against broader social good. In a capitalist free market economy, the only solution is to regulate companies, and the United States has not shown any serious appetite for that.</p><p>What’s more, U.S. intelligence agencies like the NSA rely on inadvertent insecurities for their worldwide data collection efforts, and law enforcement agencies like the FBI have even tried to introduce <a href="https://www.schneier.com/academic/paperfiles/paper-keys-under-doormats-CSAIL.pdf">new ones</a> to make their own data collection efforts easier. Again, near-term self-interest has so far triumphed over society’s long-term best interests.</p><p>In turn, rather than mustering a major effort to fix 5G, what’s most likely to happen is that the United States will muddle along with the problems the network has, as it has done for decades. Maybe things will be different with 6G, which is starting to be discussed in technical standards committees. The U.S. House of Representatives <a href="https://thehill.com/policy/technology/477429-house-passes-bills-to-gain-upper-hand-in-race-to-5g">just passed</a> a bill directing the State Department to participate in the international standards-setting process so that it is just run by telecommunications operators and more interested countries, but there is no chance of that measure becoming law.</p><p>The <a href="https://www.eurasiagroup.net/siteFiles/Media/files/1811-14%205G%20special%20report%20public(1).pdf">geopolitics of 5G</a> are complicated, involving a lot more than security. China is <a href="https://www.wired.co.uk/article/china-hacking-cyber-spies-espionage">subsidizing</a> the purchase of its companies’ networking equipment in countries around the world. The technology will quickly become critical national infrastructure, and security problems will become life-threatening. Both criminal attacks and government cyber-operations will become more common and more damaging. Eventually, Washington will have do so something. That something will be difficult and expensive—let’s hope it won’t also be too late.</p>''';

class ReaderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text('Readerscreen'),
    ),
    body: HtmlWidget(
      kHtml,
      onTapUrl: (url) => showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('onTapUrl'),
          content: Text(url),
        ),
      ),
    ),
  );
}