import 'package:flutter/material.dart';
import 'package:pu_material/pu_material.dart';
import 'package:pu_material/utils/formaters/currency_converter.dart';
import 'package:pu_material/utils/overflow_text.dart';
import 'package:pu_material/utils/style/pu_style_fonts.dart';

import '../../models/menu_item_model.dart';

class MenuItemTile extends StatelessWidget {
  final MenuItemModel item;
  final bool selected;
  final Function(MenuItemModel) onAddCart;
  const MenuItemTile({
    super.key,
    required this.item,
    required this.selected,
    required this.onAddCart,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          onAddCart(item);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 5,
            horizontal: 10,
          ),
          decoration: BoxDecoration(
            color: selected
                ? PUColors.secundaryBackground
                : PUColors.primaryBackground,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 4),
                color: Colors.black.withOpacity(0.4),
                blurRadius: 4,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Image.network(
                item.photoUrl!,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              const SizedBox(
                height: 4,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    PUOverflowTextDetector(
                      message: item.name!,
                      children: [
                        Text(
                          item.name!,
                          style: selected
                              ? PuTextStyle.title3Withe
                              : PuTextStyle.title3,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: PUOverflowTextDetector(
                            message: item.price!.toString().convertToCorrency(),
                            children: [
                              Text(
                                item.price!.toString().convertToCorrency(),
                                style: selected
                                    ? PuTextStyle.title4
                                    : PuTextStyle.description1,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
