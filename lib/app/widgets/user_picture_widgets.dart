import 'package:cached_network_image/cached_network_image.dart';
import 'package:commons_flutter/utils/app_string_utils.dart';
import 'package:commons_flutter/utils/regex_utils.dart';
import 'package:creator_activity/app/lib_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

abstract class UserPictureWidgets {
  static Widget userPicture() {
    var pictureUrl =
        RegexUtils.isStringMatch(LibSession.loggedUserPicture, "(https|http)")
            ? LibSession.loggedUserPicture
            : null;

    return loadPicture(pictureUrl);
  }

  static Widget loadPicture(String? url) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: AppStringUtils.isEmptyOrNull(url)
            ? _getPlaceHoldPictureImage()
            : _getNetworkImage(url!));
  }

  static Widget _getPlaceHoldPictureImage() {
    return Image.asset(
      "assets/images/picture_placeholder.png",
      height: 50,
      width: 50,
    );
  }

  static Widget _getNetworkImage(String url) {
    return CachedNetworkImage(
      imageUrl: url,
      placeholder: (context, url) => const CircularProgressIndicator(),
      errorWidget: (context, url, error) {
        return _getPlaceHoldPictureImage();
      },
      height: 50,
      width: 50,
    );
  }
}
