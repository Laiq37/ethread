import 'package:ethread_app/services/client/base_client.dart';
import 'package:ethread_app/services/controller/base_controller.dart';
import 'package:ethread_app/services/models/route/location_response.dart';
import 'package:get/get.dart';


class TaskListingScreenController extends GetxController {
  var locationList = <Location>[].obs;
  var isLoading = false.obs;
  late int currentLocationId;

  Future<void> getLocations(int routeId) async {

    //inorder to show loading indicator while fetching data from server
    isLoading(true);

    var data = await BaseClient()
        .get("driver/getroutelocations/$routeId")
        .catchError(BaseController.handleError);

    if (data != null) {

      //inorder to clear previous data from the list
      locationList.clear();

      //then add fresh data in the observable locations list
      locationList.addAll(locationFromJson(data));

      //inorder to hide loading indicator after fetching data from server
      isLoading(false);
    } else {
      //inorder to hide loading indicator after fetching data from server
      isLoading(false);
    }
  }

}
