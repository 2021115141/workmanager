import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '/constants/images.dart';
import '/util/extension/dimens.dart';
import '/util/extension/widget_extension.dart';

import '/util/ui/place_holder/default_shimmer.dart';

class CustomLoadingImage extends StatelessWidget {
  const CustomLoadingImage({
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
          ? SizedBox(
              height: imageSize.w,
              width: imageSize.w,
            )
          : CachedNetworkImage(
              imageUrl: url,
              imageBuilder: (context, imageProvider) => Container(
                width: imageSize.w,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(5.r),
                  image: DecorationImage(
                    image: NetworkImage(url),
                  ),
                ),
              ).inkTap(onTap: () async {
                _showMyDialog(context, url);
              }),
              placeholder: (_, __) => RectangleShimmer(
                width: imageSize.w,
                height: imageSize.w,
              ),
              errorWidget: (_, __, ___) => Container(
                width: imageSize.w,
                decoration: const BoxDecoration(
                  color: Colors.grey,
                  image: DecorationImage(
                    image: AssetImage(AppImages.imgErrorLoadImage),
                    fit: BoxFit.cover,
                  ),
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
