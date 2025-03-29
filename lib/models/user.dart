class User extends UserShort {
  final String lastName, firstName;
  final DateTime birthday;
  final String gender;

  final String email;
  final int status;
  final DateTime inscriptionDate;
  final String link;

  final String country;
  final String lang;
  final bool isKid;
  final String explicitContentLevel;
  final List<String> explicitContentLevelsAvailable;

  const User(
      super.id,
      super.name,
      super.picture,
      super.pictureSmall,
      super.pictureMedium,
      super.pictureBig,
      super.pictureXl,
      super.tracklist,
      this.lastName,
      this.firstName,
      this.birthday,
      this.gender,
      this.email,
      this.status,
      this.inscriptionDate,
      this.link,
      this.country,
      this.lang,
      this.isKid,
      this.explicitContentLevel,
      this.explicitContentLevelsAvailable);

  User.fromJson(super.json)
      : lastName = json['lastname'],
        firstName = json['firstname'],
        birthday = DateTime.parse(json['birthday']),
        gender = json['gender'],
        email = json['email'],
        status = json['status'],
        inscriptionDate = DateTime.parse(json['inscription_date']),
        link = json['link'],
        country = json['country'],
        lang = json['lang'],
        isKid = json['is_kid'],
        explicitContentLevel = json['explicit_content_level'],
        explicitContentLevelsAvailable =
            json['explicit_content_levels_available'],
        super.fromJson();
}

class UserShort {
  final int id;
  final String name;
  final String? picture, pictureSmall, pictureMedium, pictureBig, pictureXl;
  final String tracklist;

  const UserShort(this.id, this.name, this.picture, this.pictureSmall,
      this.pictureMedium, this.pictureBig, this.pictureXl, this.tracklist);

  UserShort.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        picture = json['picture'],
        pictureSmall = json['picture_small'],
        pictureMedium = json['picture_medium'],
        pictureBig = json['picture_big'],
        pictureXl = json['picture_xl'],
        tracklist = json['tracklist'];
}
