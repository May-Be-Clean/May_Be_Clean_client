class Review {
  final int reviewId;
  final int userId;
  final String nickname;
  final int point;
  final int storeId;
  final String storeName;
  final List<String> storeCategories;
  final int clover;
  final String content;
  final List<String> imageUrls;
  final List<String> reviewCategories;
  final ReviewFilterCount reviewFilterCount;
  final DateTime createdAt;

  Review({
    required this.reviewId,
    required this.userId,
    required this.nickname,
    required this.point,
    required this.storeId,
    required this.storeName,
    required this.storeCategories,
    required this.clover,
    required this.content,
    required this.imageUrls,
    required this.reviewCategories,
    required this.createdAt,
    required this.reviewFilterCount,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      reviewId: json['reviewId'],
      userId: json['userId'],
      nickname: json['nickname'],
      point: json['point'],
      storeId: json['storeId'],
      storeName: json['storeName'],
      storeCategories: json['storeCategories'].cast<String>(),
      clover: json['clover'],
      content: json['content'],
      imageUrls: json['imageUrls'].cast<String>(),
      reviewCategories: json['reviewCategories'].cast<String>(),
      createdAt: DateTime.parse(json['createdAt']),
      reviewFilterCount: ReviewFilterCount.fromJson(json['reviewFilterCount']),
    );
  }
}

class ReviewFilterCount {
  final int clean;
  final int large;
  final int parking;
  final int mood;
  final int variant;
  final int valuable;
  final int quality;
  final int effective;
  final int kind;

  ReviewFilterCount({
    required this.clean,
    required this.large,
    required this.parking,
    required this.mood,
    required this.variant,
    required this.valuable,
    required this.quality,
    required this.effective,
    required this.kind,
  });

  factory ReviewFilterCount.fromJson(Map<String, dynamic> json) {
    return ReviewFilterCount(
      clean: json['countOfCleanStore'],
      large: json['countOfLargeStore'],
      parking: json['countOfParking'],
      mood: json['countOfMood'],
      variant: json['countOfVariant'],
      valuable: json['countOfValuable'],
      quality: json['countOfQuality'],
      effective: json['countOfPrice'],
      kind: json['countOfKindness'],
    );
  }
}

final emptyReviewData = Review(
  reviewId: 0,
  userId: 0,
  nickname: '',
  storeId: 0,
  point: 0,
  storeName: "덕분애",
  storeCategories: ['UPCYCLE', 'CAFE'],
  content: '',
  imageUrls: [
    'https://play-lh.googleusercontent.com/kgl_WvLEG-FjkVMJQmw8oWw8-PAKuy2BFHjCQ9pcGRL3S2Yk6usC-h5Cjn7Efkyq2-I',
    'https://play-lh.googleusercontent.com/kgl_WvLEG-FjkVMJQmw8oWw8-PAKuy2BFHjCQ9pcGRL3S2Yk6usC-h5Cjn7Efkyq2-I'
  ],
  clover: 4,
  reviewCategories: [
    'CLEAN',
    'LARGE',
    'PARKING',
    'MOOD',
    'VARIANT',
  ],
  reviewFilterCount: ReviewFilterCount(
    clean: 0,
    large: 0,
    parking: 0,
    mood: 0,
    variant: 0,
    valuable: 0,
    quality: 0,
    effective: 0,
    kind: 0,
  ),
  createdAt: DateTime.now(),
);
