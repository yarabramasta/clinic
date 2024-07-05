import 'package:clinic/features/biodata/biodata.dart';
import 'package:clinic/features/city/city.dart';
import 'package:clinic/services/toast.dart';
import 'package:clinic/widgets/modals/modal_dialog_busy.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fl_query/fl_query.dart';
import 'package:fl_query_hooks/fl_query_hooks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

typedef UpdateBiodataMutationFn
    = Mutation<Biodata, DioException, Map<String, dynamic>>;

UseUpdateBiodata useUpdateBiodata(BuildContext context, WidgetRef ref) {
  final formKey = useMemoized(() => GlobalKey<FormState>());

  final currentBio = useBiodataQuery(ref).data;

  final nameCtrl = useTextEditingController(text: currentBio?.fullName);
  final placeOfBirthCtrl =
      useTextEditingController(text: currentBio?.placeOfBirth);
  final dateOfBirthCtrl =
      useTextEditingController(text: currentBio?.dateOfBirthStr);
  final citiesCtrl = useTextEditingController(text: currentBio?.cityStr);
  final nikCtrl = useTextEditingController(text: currentBio?.nik);
  final addressCtrl = useTextEditingController(text: currentBio?.address);
  final postalCodeCtrl = useTextEditingController(text: currentBio?.postalCode);

  final gender = useState<String?>(currentBio?.gender);
  final responsibleForCosts =
      useState<String?>(currentBio?.responsibleForCosts);
  final bloodType = useState<String?>(currentBio?.bloodType);

  final currentSelectedCity = useState<City?>(currentBio?.city);

  final mutation =
      useMutation<Biodata, DioException, Map<String, dynamic>, dynamic>(
    'biodata/update',
    // ref.read(biodataServiceProvider).updateBiodata,
    (json) async {
      debugPrint(json.toString());
      return const Biodata();
    },
    refreshQueries: ['biodata'],
    onMutate: (_) async {
      await showBusyDialog(context);
    },
    onData: (data, _) {
      if (context.canPop()) context.pop();
      toast('Biodata updated successfully!');
    },
    onError: (e, _) {
      if (context.canPop()) context.pop();
      toast('Cannot update biodata, please try again...');
    },
  );

  return UseUpdateBiodata(
    context: context,
    initialValue: currentBio,
    formKey: formKey,
    nameCtrl: nameCtrl,
    placeOfBirthCtrl: placeOfBirthCtrl,
    dateOfBirthCtrl: dateOfBirthCtrl,
    citiesCtrl: citiesCtrl,
    nikCtrl: nikCtrl,
    addressCtrl: addressCtrl,
    postalCodeCtrl: postalCodeCtrl,
    gender: gender,
    responsibleForCosts: responsibleForCosts,
    bloodType: bloodType,
    currentSelectedCity: currentSelectedCity,
    mutation: mutation,
  );
}

class UseUpdateBiodata {
  const UseUpdateBiodata({
    required this.context,
    required Biodata? initialValue,
    required this.formKey,
    required this.nameCtrl,
    required this.placeOfBirthCtrl,
    required this.dateOfBirthCtrl,
    required this.citiesCtrl,
    required this.nikCtrl,
    required this.addressCtrl,
    required this.postalCodeCtrl,
    required ValueNotifier<String?> gender,
    required ValueNotifier<String?> responsibleForCosts,
    required ValueNotifier<String?> bloodType,
    required ValueNotifier<City?> currentSelectedCity,
    required Mutation<Biodata, DioException, Map<String, dynamic>> mutation,
  })  : _mutation = mutation,
        _initialValue = initialValue,
        _currentSelectedCity = currentSelectedCity,
        _bloodType = bloodType,
        _responsibleForCosts = responsibleForCosts,
        _gender = gender;

  final BuildContext context;
  final Biodata? _initialValue;

  final GlobalKey<FormState> formKey;

  final TextEditingController nameCtrl;
  final TextEditingController placeOfBirthCtrl;
  final TextEditingController dateOfBirthCtrl;
  final TextEditingController citiesCtrl;
  final TextEditingController nikCtrl;
  final TextEditingController addressCtrl;
  final TextEditingController postalCodeCtrl;

  final ValueNotifier<String?> _gender;
  final ValueNotifier<String?> _responsibleForCosts;
  final ValueNotifier<String?> _bloodType;
  final ValueNotifier<City?> _currentSelectedCity;

  final UpdateBiodataMutationFn _mutation;

  void handleDateOfBirthChange() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 120),
      lastDate: DateTime.now(),
      locale: context.locale,
    );
    if (pickedDate != null) {
      dateOfBirthCtrl.text = DateFormat('dd/MM/yyyy').format(pickedDate);
    }
  }

  Biodata get current =>
      _initialValue ??
      Biodata(
        fullName: nameCtrl.text,
        placeOfBirth: placeOfBirthCtrl.text,
        dateOfBirth: DateFormat('dd/MM/yyyy').parse(dateOfBirthCtrl.text),
        city: city,
        nik: nikCtrl.text,
        address: addressCtrl.text,
        postalCode: postalCodeCtrl.text,
        bloodType: bloodType,
        gender: gender,
        responsibleForCosts: responsibleForCosts,
      );

  String? get gender => _gender.value;
  void handleGenderChange(String? value) {
    if (value != null) {
      _gender.value = value;
    }
  }

  String? get responsibleForCosts => _responsibleForCosts.value;
  void handleResponsibleForCostsChange(String? value) {
    if (value != null) {
      _responsibleForCosts.value = value;
    }
  }

  String? get bloodType => _bloodType.value;
  void handleBloodTypeChange(String? value) {
    if (value != null) {
      _bloodType.value = value;
    }
  }

  City? get city => _currentSelectedCity.value;
  void handleCityChange(City? value) {
    if (value != null) {
      _currentSelectedCity.value = value;
    }
  }

  void reset() {
    formKey.currentState!.reset();
  }

  void handleSubmit() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Biodata'),
        content: const Text('Would you like to update your biodata?'),
        actions: [
          OutlinedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(context);
              await _mutation.mutate(current.toJson());
              reset();
            },
            child: const Text('Continue'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  bool get isLoading => _mutation.isMutating;
}
