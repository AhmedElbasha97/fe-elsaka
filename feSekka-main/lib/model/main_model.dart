class MainCategory {
  String? mainCategoryId;
  String? titlear;
  String? titleen;
  String? categoryType;
  String? picpath;
  String? picpathEn;

  MainCategory(
      {this.mainCategoryId,
      this.titlear,
      this.titleen,
      this.categoryType,
      this.picpath,
      this.picpathEn});

  MainCategory.fromJson(Map<String, dynamic> json) {
    mainCategoryId = json['main_category_id'];
    titlear = json['titlear'];
    titleen = json['titleen'];
    categoryType = json['category_type'];
    picpath = json['picpath'];
    picpathEn = json['picpath_en'];
  }

}
