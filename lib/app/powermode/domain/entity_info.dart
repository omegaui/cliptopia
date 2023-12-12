import 'package:cliptopia/core/powermode/entity_info_data_store.dart';

class EntityInfo {
  String comment;
  bool sensitive;
  String refID;

  EntityInfo(this.comment, this.refID, this.sensitive);

  EntityInfo.clone(EntityInfo info)
      : comment = info.comment,
        refID = info.refID,
        sensitive = info.sensitive;

  void use(info) {
    comment = info.comment;
    sensitive = info.sensitive;
    EntityInfoStore.update();
  }

  Map<String, dynamic> toMap() {
    return {
      'comment': comment,
      'refID': refID,
      'sensitive': sensitive,
    };
  }

  void remove() {
    sensitive = false;
    comment = "";
    EntityInfoStore.infos.remove(this);
    EntityInfoStore.update();
  }

  bool get isNotEmpty => comment.trim().isNotEmpty || sensitive;

  @override
  bool operator ==(Object other) {
    if (other is EntityInfo) {
      return other.refID == refID &&
          other.sensitive == sensitive &&
          other.comment == comment;
    }
    return super == other;
  }

  @override
  int get hashCode =>
      super.hashCode ^ refID.hashCode ^ sensitive.hashCode ^ comment.hashCode;
}
