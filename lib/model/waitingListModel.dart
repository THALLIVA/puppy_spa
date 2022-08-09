class WaitingListItem {
  bool? isServiced;
  String? petName;
  int? created;
  String? sClass;
  String? petOwnerName;
  String? ownerId;
  int? petArrivedTime;
  int? updated;
  String? objectId;
  int? priority;

  WaitingListItem(
      {this.isServiced,
      this.petName,
      this.created,
      this.sClass,
      this.petOwnerName,
      this.ownerId,
      this.petArrivedTime,
      this.updated,
      this.priority,
      this.objectId});

  WaitingListItem.fromJson(Map<dynamic, dynamic> json) {
    isServiced = json['is_serviced'];
    petName = json['pet_name'];
    created = json['created'];
    sClass = json['___class'];
    petOwnerName = json['pet_owner_name'];
    ownerId = json['ownerId'];
    petArrivedTime = json['pet_arrived_time'];
    updated = json['updated'];
    priority = json['priority'];
    objectId = json['objectId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['is_serviced'] = isServiced;
    data['pet_name'] = petName;
    data['created'] = created;
    data['___class'] = sClass;
    data['pet_owner_name'] = petOwnerName;
    data['ownerId'] = ownerId;
    data['pet_arrived_time'] = petArrivedTime;
    data['updated'] = updated;
    data['priority'] = priority;
    data['objectId'] = objectId;
    return data;
  }
}
