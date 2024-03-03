import 'package:ethread_app/services/client/base_client.dart';
import 'package:ethread_app/services/controller/base_controller.dart';
import 'package:ethread_app/services/models/vehicle/vehicles.dart';
import 'package:ethread_app/utils/helpers/constants.dart';
import 'package:ethread_app/utils/helpers/dart_functions.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class VehiclesController extends GetxController {
  var vehiclesList = <Vehicles>[].obs;
  var selectedVehicleList = <bool>[].obs;
  var isLoading = false.obs;
  var vehiclesBox = Hive.box<Vehicles>(Constants.vehiclesBox);

  // @override
  // void onInit() {
  //   DartFunctions.checkInternetConnection().then(
  //       (value) => value == true ? getVehicles() : fetchVehiclesFromLocalDb());
  //   super.onInit();
  // }

  Future<void> getVehicles() async {
    //inorder to show loading indicator while fetching data from server
    isLoading(true);

    var data = await BaseClient()
        .get("driver/vehicles")
        .catchError(BaseController.handleError);

    if (data != null) {
      //inorder to clear previous data from the list
      if (vehiclesList.isNotEmpty) {
        vehiclesList.clear();
        selectedVehicleList.clear;
      }
      //then add fresh data in the observable vehicles list
      vehiclesList.addAll(vehiclesFromJson(data));

      selectedVehicleList.value =
          List.filled(vehiclesList.length, false, growable: true);

      await saveVehiclesToLocalDb();

      //inorder to hide loading indicator after fetching data from server
      isLoading(false);
    } else {
      //inorder to hide loading indicator in case of any sort of error
      isLoading(false);
    }
  }

  saveVehiclesToLocalDb() async {
    //clear box before adding server data
    vehiclesBox.clear();

    //loop through the whole list of vehicles and add each record in local db
    for (int i = 0; i < vehiclesList.length; i++) {
      vehiclesBox.put(i, vehiclesList[i]);
    }
  }

  fetchVehiclesFromLocalDb() {
    //Conditional to check if local db is empty or not
    isLoading(true);
    if (vehiclesBox.isNotEmpty) {
      if (vehiclesList.isNotEmpty) {
        vehiclesList.clear();
        selectedVehicleList.clear;
      }
      vehiclesList.addAll(vehiclesBox.values.toList());
      selectedVehicleList.value =
          List.filled(vehiclesList.length, false, growable: true);
    } else {
      DartFunctions.showSnackBar(
          "No data found. Please check internet connectivity", "Failure");
    }
    isLoading(false);
  }
}
