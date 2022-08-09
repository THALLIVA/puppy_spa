import 'package:backendless_sdk/backendless_sdk.dart';
import 'package:intl/intl.dart';
import 'package:puppy_spa/model/waitingListModel.dart';

class AppServices {
  Future<List<WaitingListItem>> getTodayWaitingList() async {
    DateTime dateTime = DateTime.now().toLocal();
    DateTime todayDate = DateTime(dateTime.year, dateTime.month, dateTime.day);
    DateTime tomDate = todayDate.add(const Duration(days: 1));

    String whereClause =
        "pet_arrived_time >= ${todayDate.millisecondsSinceEpoch} AND pet_arrived_time < ${tomDate.millisecondsSinceEpoch} AND is_serviced = false";
    List<WaitingListItem> waitingList = [];
    DataQueryBuilder queryBuilder = DataQueryBuilder()
      ..whereClause = whereClause;
    queryBuilder.sortBy = ["priority ASC", "pet_arrived_time ASC"];
    List<Map?>? response =
        await Backendless.data.of("waitinglist").find(queryBuilder);
    if (response?.isNotEmpty ?? false) {
      response?.forEach((waitingListItem) {
        waitingList.add(WaitingListItem.fromJson(waitingListItem!));
      });
    }

    return waitingList;
  }

  String parseTimeStamp(int value) {
    var date = DateTime.fromMillisecondsSinceEpoch(value);
    var d12 = DateFormat('dd/MM/yyyy, hh:mm a').format(date);
    return d12;
  }

  Future addWaitingList(
      String petName, String ownerName, String utcTime) async {
    final response = await Backendless.data.of('waitinglist').save({
      "pet_name": petName,
      "pet_owner_name": ownerName,
      "pet_arrived_time": DateTime.parse(utcTime).millisecondsSinceEpoch,
    });
    if (response != null) {
      return true;
    }
  }

  Future updateWaitingList(
    String? objectId,
    bool? isServiced,
  ) async {
    final unitOfWork = UnitOfWork();
    Map changes = {
      "objectId": objectId,
      "is_serviced": isServiced,
    };

    unitOfWork.update(changes, "waitinglist");
    await unitOfWork.execute();
  }

  Future changePriority(
    String? objectId,
    int priority,
  ) async {
    final unitOfWork = UnitOfWork();
    if (priority == 2) {
      priority = 1;
    } else if (priority == 1) {
      priority = 0;
    } else if (priority == 0) {
      priority = 2;
    }
    Map changes = {
      "objectId": objectId,
      "priority": priority,
    };

    unitOfWork.update(changes, "waitinglist");
    await unitOfWork.execute();
  }
}
