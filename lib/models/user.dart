class User {
  final int id;
  final String name, lastName, firstName;
  final DateTime birthday;
  final String gender;

  final String email;
  final int status;
  final DateTime inscriptionDate;
  final String link;

  final String picture, pictureSmall, pictureMedium, pictureBig, pictureXl;

  final String country;
  final String lang;
  final bool isKid;
  final String explicitContentLevel;
  final List<String> explicitContentLevelsAvailable;
  final String tracklist;

  const User(
      this.id,
      this.name,
      this.lastName,
      this.firstName,
      this.birthday,
      this.gender,
      this.email,
      this.status,
      this.inscriptionDate,
      this.link,
      this.picture,
      this.pictureSmall,
      this.pictureMedium,
      this.pictureBig,
      this.pictureXl,
      this.country,
      this.lang,
      this.isKid,
      this.explicitContentLevel,
      this.explicitContentLevelsAvailable,
      this.tracklist);

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        lastName = json['lastname'],
        firstName = json['firstname'],
        birthday = DateTime.parse(json['birthday']),
        gender = json['gender'],
        email = json['email'],
        status = json['status'],
        inscriptionDate = DateTime.parse(json['inscription_date']),
        link = json['link'],
        picture = json['picture'],
        pictureSmall = json['picture_small'],
        pictureMedium = json['picture_medium'],
        pictureBig = json['picture_big'],
        pictureXl = json['picture_xl'],
        country = json['country'],
        lang = json['lang'],
        isKid = json['is_kid'],
        explicitContentLevel = json['explicit_content_level'],
        explicitContentLevelsAvailable =
            json['explicit_content_levels_available'],
        tracklist = json['tracklist'];
}
