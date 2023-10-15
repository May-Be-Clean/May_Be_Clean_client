import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:may_be_clean/consts/consts.dart';
import 'package:may_be_clean/consts/font.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StoreList extends StatefulWidget {
  const StoreList({super.key});

  @override
  State<StoreList> createState() => _StoreListState();
}

class _StoreListState extends State<StoreList> {
  final List<Map<String, String>> stores = [
    {
      'title': '제로웨이스터',
      'description': '일상생활 속 즐거운 실천, 제로웨이스터!',
      'hashtag': '#제로웨이스트',
      'link':
          'http://zerowaster.kr/main/html.php?htmid=proc/brand-s.html&myShop',
      'img':
          'https://cdn-pro-web-250-122.cdn-nhncommerce.com/zerowaster_godomall_com/data/skin/front/a_sy07_C/wib/img/icon/login_icom.png',
    },
    {
      'title': '지구샵',
      'description': '지구를 위한 낭비없는 가게 제로웨이스트 전문 편집브랜드',
      'hashtag': '#제로웨이스트 #생활용품',
      'link':
          'https://www.jigushop.co.kr/?NaPm=ct=lmq94ezz%7Cci=checkout%7Ctr=ds%7Ctrx=null%7Chk=847098990b37de18ab1b76a8a3a2951d49910e19',
      'img':
          'https://cf.channel.io/thumb/200x200/pub-file/80220/6375bdc7f2d5aa6b1cf6/_.png',
    },
    {
      'title': '노플라스틱선데이',
      'description': '노플라스틱 선데이는 플라스틱 쓰레기의 지속가능한 순환구조를 만듭니다.',
      'hashtag': '#제로웨이스트 #업사이클링 #굿즈',
      'link': 'https://noplasticsunday.com/',
      'img':
          'https://cf.channel.io/thumb/200x200/pub-file/96435/633532c5e5fd57666f6a/symbol.png',
    },
    {
      'title': '119레오',
      'description': '생명을 구한 옷 소방복 업사이클링 가방',
      'hashtag': '#제로웨이스트 #업사이클링 #패션',
      'link':
          'https://www.119reo.com/?NaPm=ct=lmq9cj1r%7Cci=checkout%7Ctr=ds%7Ctrx=null%7Chk=b91f19aee2038288d2404bbc4abe0e4d0e55a07b',
    },
    {
      'title': '플라썸',
      'description': '새활용 굿즈 제작 - 환경을 저해하는 소재들을 모아 새로운 가치의 사물로 꽃피웁니다.',
      'hashtag': '#업사이클링 #굿즈',
      'link': 'https://www.plasum.co.kr/40',
    },
    {
      'title': '퍼스티아',
      'description':
          '퍼스티아는 100% 생분해 가능한 티백과 못난이 농작물을 이용해 푸드 업사이클링을 실천하는 전문 티 블렌더 브랜드입니다.',
      'hashtag': '#업사이클링 #푸드',
      'link': 'https://www.firstea.co.kr/',
      'img':
          'https://cf.channel.io/thumb/200x200/pub-file/106419/64ae3e1c5b321e159f79/tmp-2511084396',
    },
    {
      'title': '스타스테크',
      'description': '소각 폐기돼야 할 불가사리를 친환경 제설제, 액상 비료, 화장품 원료로 만들어 판매하는 스타트업',
      'hashtag': '#업사이클링 #제로웨이스트',
      'link': 'https://www.starstech.co.kr/',
    },
    {
      'title': '큐클리프',
      'description': '주어진 폐자원으로 또 다른 생각을 디자인합니다.',
      'hashtag': '#업사이클링 #제로웨이스트',
      'link': 'https://cueclyp.com/',
    },
    {
      'title': '플라스틱 방앗간',
      'description':
          '병뚜껑곡물을 가공해서 식재료로 만드는 방앗간처럼 작은 플라스틱 쓰레기를 분쇄해서 새로운 제품의 원료로 사용해요.',
      'hashtag': '#업사이클링 #제로웨이스트 #굿즈',
      'link': 'https://ppseoul.com/mill',
      'img':
          'https://cdn.imweb.me/upload/S20200610f999ac5b4f199/0acff451b169a.png'
    },
    {
      'title': '트레드앤그루브',
      'description':
          '도로를 달리던 타이어를 신발의 밑창에 적용하여 새로운 개념의 비히클 패션문화를 소개하는 서스테이너블 슈즈 브랜드입니다.',
      'hashtag': '#업사이클링 #패션',
      'link':
          'https://www.treadngroove.com/?NaPm=ct=lmrvbm3b%7Cci=checkout%7Ctr=ds%7Ctrx=null%7Chk=ab171a068057ba2077b0d0199b057209b8c31563',
      'img':
          "https://contents.sixshop.com/thumbnails/uploadedFiles/182050/default/image_1662631889138_300.png",
    },
    {
      'title': '리하베스트',
      'description': '푸드업사이클링을 통해, 다양한 ‘헬시플레저’ 식품을 만듭니다',
      'hashtag': '#업사이클링 #제로웨이스트 #푸드',
      'link': 'https://reharvestshop.com/',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(top: 28),
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "깨끗해질 가게",
                  style: FontSystem.subtitleSemiBold,
                ),
                Text(
                  '지구를 깨끗하게 만드는 가게를 온라인에서 만나보세요!',
                  style: FontSystem.body2,
                ),
                Column(
                  children: stores.asMap().entries.map((entry) {
                    int idx = entry.key; // index를 가져옵니다.
                    Map<String, String> store = entry.value; // 상점 정보를 가져옵니다.
                    return StoreContainer(
                      title: store['title']!,
                      description: store['description']!,
                      hashtag: store['hashtag']!,
                      link: store['link']!,
                      index: idx + 1, // 1.png부터 시작하기 때문에 1을 더합니다.
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class StoreContainer extends StatelessWidget {
  final String title;
  final String description;
  final String hashtag;
  final String link;
  final int index; // 인덱스를 추가합니다.

  StoreContainer({
    required this.title,
    required this.description,
    required this.hashtag,
    required this.link,
    required this.index, // 초기화 리스트에 인덱스를 추가합니다.
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (await canLaunch(link)) {
          await launch(link);
        } else {
          throw 'Could not launch $link';
        }
      },
      child: Container(
        padding: EdgeInsets.only(top: 16, bottom: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          children: [
            ClipOval(
              child: Container(
                width: 74,
                height: 74,
                child: Image.asset(
                  'assets/icons/store/${index}.png', // 파일 경로와 인덱스를 사용합니다.
                  fit: BoxFit.cover, // 이미지를 채웁니다.
                ),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Image.asset("assets/images/CloverLeaves4.png"),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.0),
                Container(
                  constraints: BoxConstraints(maxWidth: Get.width - 135),
                  child: Text(
                    description,
                    style: FontSystem.body2,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  hashtag,
                  style: FontSystem.body2.copyWith(
                    color: ColorSystem.gray1,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
