import 'package:ethread_app/services/client/base_client.dart';
import 'package:ethread_app/services/controller/base_controller.dart';
import 'package:ethread_app/services/models/bin/bin_report.dart';
import 'package:ethread_app/services/models/report/report.dart';
import 'package:ethread_app/utils/helpers/constants.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class BinServiceController extends GetxController {
  var binsList = <Bin>[].obs;
  var isLoading = false.obs;

  //to open and close bin individually
  late RxList<bool> bins = <bool>[].obs ;

  late int totalBinServed = 0 ;

  void createBinsOpen() {
    if(bins.isNotEmpty){bins.clear();}
    bins = List.filled(binsList.length, false).obs;
  }

  Future<void> getBins(int locationId,) async {
    //inorder to show loading indicator while fetching data from server
    isLoading(true);

    var data = await BaseClient()
        .get("driver/getlocationsbins/$locationId")
        .catchError(BaseController.handleError);

    if (data != null) {
      //binData is holding bins which came from server
      List<Bin> binData = binFromJson(data);

      //This variable will be responsible to delete whole location entry if locations entry is not empty and all bin have completed status
      bool pendingDataInLocalDb = false;

      //Retrieve all bins from local db
      Report? reportFromDb = await getBinsFromLocalDb(locationId);

      // checking if report is not empty and also bins are notEmpty
      if (reportFromDb != null && reportFromDb.bins.isNotEmpty) {
      
        for (var element in reportFromDb.bins) {
          // getting any binData having entry in localDb with status not Completed

          Bin? bins =
              binData.firstWhereOrNull((binElement) => element.id == binElement.id && binElement.date == element.date && binElement.status != Constants.completedStatus);
          if (bins != null) {
            binData[binData.indexOf(bins)] = element;
            if(!pendingDataInLocalDb){
              pendingDataInLocalDb = true;
            } 
          }
        }
        // if (binData.isNotEmpty) { // replaced by line 53
          // if(pendingDataInLocalDb.isNotEmpty){//added new line
          //Then retrieve bins from local db

          // saveToLocalDb(Report(
          //     driverRouteId: routeId.toString(),
          //     locationId: locationId.toString(),
          //     bins: pendingDataInLocalDb)
          //     );

          //Then retrieve bins from local db
          // Report? latestBinsFromDb = await getBinsFromLocalDb(locationId);//remove

          // binsList.clear();

          // binsList.addAll(binData);
         if(!pendingDataInLocalDb) {
          // Report? latestBinsFromDb = await getBinsFromLocalDb(locationId);//replace by next line
          deleteFromDb(locationId);
          // binsList.clear();

          // binsList.addAll(binData);
        }
      }
      //In this case we add only unique/new bins data to local storage
      // else {
        //create bins instances in local storage
        // createBins(routeId, locationId, binData);

        //Then retrieve bins from local db
        // Report? latestBinsFromDb = await getBinsFromLocalDb(locationId);


        // binsList.clear();

        // binsList.addAll(binData);
      // }

      binsList.clear();

      binsList.addAll(binData);

      //inorder to hide loading indicator after fetching data from server
       totalBinServed = 0;
        for (var bin in binsList) { 
            if(bin.isBinServed){
              totalBinServed += 1;
            }
         }
      isLoading(false);
    }
    //inorder to hide loading indicator after fetching data from server
    else {
      //inorder to hide loading indicator in case of any sort of error
      isLoading(false);
    }
  }

  void createBins(int driverRouteId, int locationId, List<Bin> binsData) {
    List<Bin> bins = [];
    for (int i = 0; i < binsData.length; i++) {
      // if(binsData[i].status == Constants.completedStatus) continue;//added new line
      bins.add(Bin(
          id: binsData[i].id,
          title: binsData[i].title ?? "",
          startTime: binsData[i].startTime,
          barcodeNum: binsData[i].barcodeNum,
          isBinServed: binsData[i].isBinServed,
          isBinScanned: binsData[i].isBinScanned,
          date: binsData[i].date,
          binFilledStatus: "empty"));
    }

    saveToLocalDb(Report(
        driverRouteId: driverRouteId.toString(),
        locationId: locationId.toString(),
        bins: bins));
  }

  Future<void> saveToLocalDb(Report binReport) async {
    var binReportsBox = Hive.box<Report>(Constants.reportsBox);

    //Store updated data in user box
    await binReportsBox.put(binReport.locationId, binReport);
  }

  Future<Report?> getBinsFromLocalDb(int locationId) async {
    var binReportsBox = Hive.box<Report>(Constants.reportsBox);

    //Retrieve updated data in user box
    return binReportsBox.get(locationId.toString());
  }

  Future<void> deleteFromDb(locationId) async {
    var binReportsBox = Hive.box<Report>(Constants.reportsBox);

    //Store updated data in user box
    await binReportsBox.delete(locationId);
  }

}
