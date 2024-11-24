import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../../generated/locales.g.dart';
import '../controllers/edit_event_controller.dart';

class EditEventView extends GetView<EditEventController> {
  const EditEventView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _fab(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: _appBar(),
      body: Obx(() => _body(context)),
    );
  }

  Widget _fab() {
    return FloatingActionButton(
      onPressed: controller.onSubmit,
      child: const Icon(Icons.check),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title:  Text(LocaleKeys.edit_event_edit_event.tr),
      centerTitle: true,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.blueAccent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          hoverColor: Colors.grey,
          tooltip: LocaleKeys.event_details_go_back.tr,
          color: Colors.white,
          onPressed: Get.back,
        )
    );
  }

  Widget _body(context) {
    if (controller.isLoading.value) {
      return _loading();
    }
    return _success(context);
  }

  Widget _loading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _success(context) {
    return Form(
      key: controller.formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 36),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _imageSection(),
              const SizedBox(height: 32),
              _imagePicker(),
              const SizedBox(height: 32),
              _title(),
              const SizedBox(height: 16),
              _description(),
              const SizedBox(height: 16),
              _price(),
              const SizedBox(height: 16),
              _capacity(),
              const SizedBox(height: 16),
              _timeSelector(),
            ElevatedButton(
              onPressed: () {
                if (controller.participants.value > 0) {
                  controller.showSnackbar(LocaleKeys.edit_event_time_error.tr);
                } else {
                  controller.chooseTime();
                }
              },
              child: Text(LocaleKeys.add_event_select_time.tr),
            ),
              const SizedBox(height: 16),
              _yearMonthDaySelectors(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _imageSection() {
    return Obx(() {
      if (controller.imageBase64.value != null) {
        return Image.memory(
          base64Decode(controller.imageBase64.value!),
          width: 333,
          height: 333,
        );
      } else {
        return  Center(child: Text(LocaleKeys.add_event_no_image.tr));
      }
    });
  }

  Widget _imagePicker() {
    return InkWell(
      onTap: controller.isLoading.value ? null : controller.pickImage,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 12),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: controller.isLoading.value ? Colors.grey : Colors.blueAccent,
        ),
        child:  Text(
          LocaleKeys.add_event_pick_image.tr,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _title() {
    return TextFormField(
      maxLength: 20,
      readOnly: controller.isLoading.value,
      controller: controller.titleController,
      autofocus: true,
      textInputAction: TextInputAction.next,
      validator: controller.validate,
      decoration: InputDecoration(
        counter: const Offstage(),
        prefixIcon: const Icon(Icons.title, color: Colors.grey),
        labelText: LocaleKeys.add_event_title.tr,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _description() {
    return TextFormField(
      maxLength: 50,
      readOnly: controller.isLoading.value,
      controller: controller.descriptionController,
      autofocus: true,
      textInputAction: TextInputAction.next,
      validator: controller.validate,
      decoration: InputDecoration(
        counter: const Offstage(),
        prefixIcon: const Icon(Icons.description, color: Colors.grey),
        labelText: LocaleKeys.add_event_description.tr,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _price() {
    return TextFormField(
      maxLength: 4,
      keyboardType: TextInputType.number,
      readOnly: controller.participants.value > 0,
      onTap: () {
        if (controller.participants.value > 0) {
          controller.showSnackbar(LocaleKeys.edit_event_price_error.tr);
        }
      },
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      controller: controller.priceController,
      textInputAction: TextInputAction.next,
      validator: controller.validatePrice,
      decoration: InputDecoration(
        counter: const Offstage(),
        labelText: LocaleKeys.add_event_price.tr,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _capacity() {
    return TextFormField(
      maxLength: 6,
      keyboardType: TextInputType.number,
      readOnly: controller.participants.value > 0,
      onTap: () {
        if (controller.participants.value > 0) {
          controller.showSnackbar(LocaleKeys.edit_event_capacity_error.tr);
        }
      },
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      controller: controller.capacityController,
      autofocus: true,
      textInputAction: TextInputAction.next,
      validator: controller.validateCapacity,
      decoration: InputDecoration(
        counter: const Offstage(),
        labelText: LocaleKeys.add_event_capacity.tr,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _timeSelector() {
    return Obx(
          () => Text(
        "${controller.selectedTime2.value.hour}:${controller.selectedTime2.value.minute}",
        style: const TextStyle(fontSize: 25),
      ),
    );
  }

  Widget _yearMonthDaySelectors() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _yearDropdown(),
        const SizedBox(width: 8),
        _monthDropdown(),
        const SizedBox(width: 8),
        _dayDropdown(),
      ],
    );
  }

  Widget _yearDropdown() {
    return Obx(() => DropdownButton<String>(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      value: controller.selectedYear.value.isEmpty ||
          !controller.years.contains(controller.selectedYear.value)
          ? null
          : controller.selectedYear.value,
      items: controller.years.map((year) {
        return DropdownMenuItem(
          value: year,
          child: Text(year),
        );
      }).toList(),
      onChanged: controller.participants.value == 0
          ? (value) => controller.selectedYear.value = value ?? ''
          : (value) {
        controller.showSnackbar(LocaleKeys.edit_event_date_error.tr);
      },
    ));
  }
  Widget _monthDropdown() {
    return Obx(() => DropdownButton<String>(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      value: controller.selectedMonth.value.isEmpty ||
          !controller.months.contains(controller.selectedMonth.value)
          ? null
          : controller.selectedMonth.value,
      items: controller.months.map((month) {
        return DropdownMenuItem(
          value: month,
          child: Text(month),
        );
      }).toList(),
      onChanged: controller.participants.value == 0
          ? (value) => controller.selectedMonth.value = value ?? ''
          : (value) {
        controller.showSnackbar(LocaleKeys.edit_event_date_error.tr);
      },
    ));
  }

  Widget _dayDropdown() {
    return Obx(() => DropdownButton<String>(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      value: controller.selectedDay.value.isEmpty ||
          !controller.days.contains(controller.selectedDay.value)
          ? null
          : controller.selectedDay.value,
      items: controller.days.map((day) {
        return DropdownMenuItem(
          value: day,
          child: Text(day),
        );
      }).toList(),
      onChanged: controller.participants.value == 0
          ? (value) => controller.selectedDay.value = value ?? ''
          : (value) {
        controller.showSnackbar(LocaleKeys.edit_event_date_error.tr);
      },
    ));
  }
}
