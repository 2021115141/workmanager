import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:workmanager/constants/images.dart';
import 'package:workmanager/util/extension/dimens.dart';
import 'package:workmanager/util/extension/widget_extension.dart';

import '/util/ui/place_holder/default_shimmer.dart';

class CustomAvatarLoadingImage extends StatelessWidget {
  const CustomAvatarLoadingImage({
    Key? key,
    required this.url,
    required this.imageSize,
  }) : super(key: key);

  final String url;
  final double imageSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: imageSize.w,
      width: imageSize.w,
      child: url == ''
          ? Container(
              height: imageSize.w,
              width: imageSize.w,
              decoration: const BoxDecoration(
                color: Colors.grey,
                image: DecorationImage(
                  image: AssetImage(AppImages.imageNoneAvatar),
                  fit: BoxFit.cover,
                ),
                shape: BoxShape.circle,
              ),
            )
          : CachedNetworkImage(
              imageUrl: url,
              imageBuilder: (context, imageProvider) => Container(
                height: imageSize.w,
                width: imageSize.w,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(url),
                    fit: BoxFit.cover,
                  ),
                ),
              ).inkTap(onTap: () async {
                _showMyDialog(context, url);
              }),
              placeholder: (_, __) => CircleShimmer(
                radius: imageSize.w,
              ),
              errorWidget: (_, __, ___) => Container(
                height: imageSize.w,
                width: imageSize.w,
                decoration: const BoxDecoration(
                  color: Colors.grey,
                  image: DecorationImage(
                    image: AssetImage(AppImages.imgErrorLoadImage),
                    fit: BoxFit.cover,
                  ),
                  shape: BoxShape.circle,
                ),
              ),
            ),
    );
  }

  Future<void> _showMyDialog(BuildContext context, String url) async {
    return showDialog<void>(
      context: context,
      barrierColor: Colors.black,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: const EdgeInsets.all(0),
          actionsPadding: const EdgeInsets.all(0),
          contentPadding: const EdgeInsets.all(0),
          content: Image.network(url),
        );
      },
    );
  }
}
