import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controllers/add_event_controller.dart';

class AddEventView extends GetView<AddEventController> {
  const AddEventView({super.key});

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
    return (controller.isLoading.value)
        ? const FloatingActionButton(
            onPressed: null,
            child: CircularProgressIndicator(),
          )
        : FloatingActionButton(
            onPressed: controller.onSubmit,
            child: const Icon(Icons.check),
          );
  }

  AppBar _appBar() {
    return AppBar(
      title: const Text("Add Event"),
      centerTitle: true,
      automaticallyImplyLeading: false,
    );
  }

  Widget _body(context) {
    return Form(
      key: controller.formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 36),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Obx(() {
                if (controller.imageBase64.value != null) {
                  return Image.memory(
                    base64Decode(controller.imageBase64.value!),
                    width: 333,
                    height: 333,
                  );
                } else {
                  const SizedBox(height: 32);
                  return const Text("No image selected");
                }
              }),
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
              Obx(
                () => Text(
                  "${controller.selectedTime2.value.hour}:${controller.selectedTime2.value.minute}",
                  style: const TextStyle(fontSize: 25),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  controller.chooseTime();
                },
                child: const Text('Select Time'),
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Obx(() => DropdownButton<String>(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 8),
                        hint: const Text("year"),
                        value: controller.selectedYear.value.isEmpty
                            ? null
                            : controller.selectedYear.value,
                        items: controller.years.map((year) {
                          return DropdownMenuItem(
                            value: year,
                            child: Text(year),
                          );
                        }).toList(),
                        onChanged: (value) =>
                            controller.selectedYear.value = value ?? '',
                      )),
                  Obx(() => DropdownButton<String>(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 8),
                        hint: const Text("month"),
                        value: controller.selectedMonth.value.isEmpty
                            ? null
                            : controller.selectedMonth.value,
                        items: controller.months.map((month) {
                          return DropdownMenuItem(
                            value: month,
                            child: Text(month),
                          );
                        }).toList(),
                        onChanged: (value) =>
                            controller.selectedMonth.value = value ?? '',
                      )),
                  Obx(() => DropdownButton<String>(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 8),
                        hint: const Text("day"),
                        value: controller.selectedDay.value.isEmpty
                            ? null
                            : controller.selectedDay.value,
                        items: controller.days.map((day) {
                          return DropdownMenuItem(
                            value: day,
                            child: Text(day),
                          );
                        }).toList(),
                        onChanged: (value) =>
                            controller.selectedDay.value = value ?? '',
                      )),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget _title() {
    return TextFormField(
      maxLength: 20,
      readOnly: (controller.isLoading.value ? true : false),
      controller: controller.titleController,
      autofocus: true,
      textInputAction: TextInputAction.next,
      validator: controller.validate,
      decoration: InputDecoration(
        counter: const Offstage(),
        prefixIcon: const Icon(
          Icons.person_pin,
          color: Colors.grey,
        ),
        labelText: "title",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _description() {
    return TextFormField(
      maxLength: 50,
      readOnly: (controller.isLoading.value ? true : false),
      controller: controller.descriptionController,
      autofocus: true,
      textInputAction: TextInputAction.next,
      validator: controller.validate,
      decoration: InputDecoration(
        counter: const Offstage(),
        prefixIcon: const Icon(
          Icons.person_pin,
          color: Colors.grey,
        ),
        labelText: "description",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _price() {
    return TextFormField(
      maxLength: 6,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      controller: controller.priceController,
      textInputAction: TextInputAction.next,
      validator: controller.validatePrice,
      decoration: InputDecoration(
        counter: const Offstage(),
        labelText: "Price",
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
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      controller: controller.capacityController,
      autofocus: true,
      textInputAction: TextInputAction.next,
      validator: controller.validateCapacity,
      decoration: InputDecoration(
        counter: const Offstage(),
        labelText: "Capacity",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _datePicker(context) {
    return TextField(
      controller: controller.dateController,
      decoration: const InputDecoration(
        labelText: 'DATE',
        filled: true,
        prefixIcon: Icon(Icons.calendar_today),
        enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
        focusedBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
      ),
      readOnly: true,
      onTap: () {
        controller.selectDate(context);
      },
    );
  }

  Widget _imagePicker() {
    return InkWell(
      onTap: (controller.isLoading.value) ? null : controller.pickImage,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 12),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: (controller.isLoading.value) ? Colors.grey : Colors.blueAccent,
        ),
        child: const Text(
          "Pick Image",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
