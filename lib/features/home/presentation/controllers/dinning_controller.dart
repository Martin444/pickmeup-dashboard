import 'package:flutter/material.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pickmeup_dashboard/features/home/data/usescases/get_dinning_usescases.dart';
import 'package:pickmeup_dashboard/features/home/data/usescases/get_menu_dinning.dart';
import 'package:pickmeup_dashboard/features/home/data/usescases/post_menu_item_usescases.dart';
import 'package:pickmeup_dashboard/features/home/data/usescases/upload_file_usescases.dart';
import 'package:pickmeup_dashboard/features/home/models/dinning_model.dart';
import 'package:pickmeup_dashboard/routes/routes.dart';

import '../../models/menu_item_model.dart';
import '../../models/menu_model.dart';

class DinningController extends GetxController {
  DinningModel dinningLogin = DinningModel();

  void getMyDinningInfo() async {
    try {
      var respDinning = await GetDinningUseCase().execute();
      dinningLogin = respDinning;
      getmenuByDining(dinningLogin.id ?? '');
      update();
    } catch (e) {}
  }

  List<MenuModel> menusList = <MenuModel>[];
  MenuItemModel menusToEdit = MenuItemModel();

  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController deliveryController = TextEditingController();
  String photoController = '';

  void setDataToEditItem(MenuItemModel menu) {
    nameController.text = menu.name!;
    priceController.text = menu.price!.toString();
    deliveryController.text = menu.deliveryTime!.toString();
    photoController = menu.photoUrl!;
    update();
  }

  void getmenuByDining(String dinnin) async {
    try {
      var respMenu = await GetMenuUseCase().execute(dinnin);
      menusList.assignAll(respMenu);
      menusToEdit = menusList[0].items![0];
      setDataToEditItem(menusToEdit);
      update();
    } catch (e) {}
  }

  TextEditingController newNameController = TextEditingController();
  TextEditingController newpriceController = TextEditingController();
  TextEditingController newdeliveryController = TextEditingController();
  String newphotoController = '';

  Uint8List? fileTaked;
  Uint8List toSend = Uint8List(1);

  void pickImageDirectory() async {
    final ImagePicker pickerImage = ImagePicker();

    final result = await pickerImage.pickImage(source: ImageSource.gallery);

    if (result != null) {
      Uint8List newFile = await result.readAsBytes();
      toSend = newFile;
      // Upload file
      fileTaked = await result.readAsBytes();
      update();
    }
  }

  bool isLoadMenuItem = false;

  void createMenuItemInServer() async {
    // Primero obtenemos el link de la imagen
    isLoadMenuItem = true;
    update();

    newphotoController = await uploadImage(toSend);
    createItem();

    update();
  }

  Future<String> uploadImage(Uint8List file) async {
    try {
      var responUrl = await UploadFileUsesCase().execute(file);
      return responUrl;
    } catch (e) {
      print('Error al craer imagen: $e');
      rethrow;
    }
  }

  void createItem() async {
    try {
      var newItem = MenuItemModel(
        name: newNameController.text,
        photoUrl: newphotoController,
        deliveryTime: int.tryParse(newdeliveryController.text),
        price: int.tryParse(newpriceController.text),
      );
      var item = await PostMenuItemUsesCases().execute(
        menusList[0].id ?? '',
        newItem,
      );
      print(item);
      Get.toNamed(PURoutes.HOME);
    } catch (e) {
      print('Error creando Item $e');
    }
  }
}
