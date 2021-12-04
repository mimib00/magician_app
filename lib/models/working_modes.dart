enum WorkingMode { add, edit, delete, none }

extension WorkingModeExtension on WorkingMode {
  static const listenableWorkingModes = [
    WorkingMode.add,
    WorkingMode.edit,
    WorkingMode.delete,
  ];

  bool get isAdd => this == WorkingMode.add;

  bool get isNotAdd => !isAdd;

  bool get isEdit => this == WorkingMode.edit;

  bool get isNotEdit => !isEdit;

  bool get isDelete => this == WorkingMode.delete;

  bool get isNotDelete => !isDelete;

  bool get isEditOrDelete => isEdit || isDelete;

  bool get isNotEditOrDelete => !isEditOrDelete;

  bool get isNone => this == WorkingMode.none;

  bool get isNotNone => !isNone;

  bool get isListenable => listenableWorkingModes.contains(this);

  bool get isNotListenable => !isListenable;
}
