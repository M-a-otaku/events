import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/add_event_controller.dart';

class AddEventView extends GetView<AddEventController> {
  const AddEventView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _fab(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // floatingActionButton: Hero(
      //   tag: Obx(() => _fab()),
      //   child: Obx(() => _fab()),
      // ),
      appBar: _appBar(),
      body: _body(context),
    );
  }

  Widget _fab() {
    return (controller.isLoading.value)
        ? FloatingActionButton(
            onPressed: null,
            child: Transform.scale(
              scale: 0.5,
              child: const CircularProgressIndicator(),
            ),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
                "${controller.selectedTime.value.hour}:${controller.selectedTime.value.minute}",
                style: TextStyle(fontSize: 25),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                controller.chooseTime();
              },
              child: const Text('Select Time'),
            ),
            const SizedBox(height: 16),
            _datePicker(context)
            // Obx(() => _register()),
          ],
        ),
      ),
    );
  }

  Widget _title() {
    return TextFormField(
      controller: controller.titleController,
      autofocus: true,
      textInputAction: TextInputAction.next,
      validator: controller.validate,
      decoration: InputDecoration(
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
      controller: controller.descriptionController,
      autofocus: true,
      textInputAction: TextInputAction.next,
      validator: controller.validate,
      decoration: InputDecoration(
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
      controller: controller.priceController,
      textInputAction: TextInputAction.next,
      validator: controller.validatePrice,
      decoration: InputDecoration(
        labelText: "Price",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _capacity() {
    return TextFormField(
      controller: controller.capacityController,
      autofocus: true,
      textInputAction: TextInputAction.next,
      validator: controller.validateCapacity,
      decoration: InputDecoration(
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
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide.none
        ),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue)
        ),
      ),
      readOnly: true,
      onTap: (){
        controller.selectDate(context);
      },
    );
  }

  Widget _imagePicker(){
    return
      MaterialButton(
          color: Colors.blue,
          child: const Text(
              "Pick Image from Gallery",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16
              )
          ),
          onPressed: () {
            controller.pickImageFromGallery();
            // controller.pickImage();
          }
      );
  }
}
