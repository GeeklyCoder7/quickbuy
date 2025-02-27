import 'package:ecommerce_application/utils/colors/app_colors.dart';
import 'package:flutter/material.dart';

class SelectQuantitySpinnerWidget extends StatefulWidget {
  final List<int>? quantityNumbersList;
  final String? dropdownLabel;
  final Function(int) onQuantitySelected;

  const SelectQuantitySpinnerWidget({
    super.key,
    required this.dropdownLabel,
    required this.onQuantitySelected,
    required this.quantityNumbersList,
  });

  @override
  State<SelectQuantitySpinnerWidget> createState() =>
      _SelectQuantitySpinnerWidgetState();
}

class _SelectQuantitySpinnerWidgetState
    extends State<SelectQuantitySpinnerWidget> {
  int? selectedQuantity = 1;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      margin: EdgeInsets.only(left: 20),
      child: DropdownButtonFormField(
        dropdownColor: AppColors.dropdown_color,
        value: selectedQuantity,
        style: TextStyle(color: AppColors.text),
        decoration: InputDecoration(
          labelText: widget.dropdownLabel,
          labelStyle: TextStyle(
            color: AppColors.text
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: AppColors.dropdown_border_color, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: AppColors.dropdown_border_color, width: 1),
          )
        ),
        items: widget.quantityNumbersList?.map(
          (int quantity) {
            return DropdownMenuItem<int>(
              value: quantity,
              child: Text(
                quantity.toString(),
              ),
            );
          },
        ).toList(),
        onChanged: (int? newQuantity) {
          setState(() {
            selectedQuantity = newQuantity;
          });
          widget.onQuantitySelected(selectedQuantity!);
        },
      ),
    );
  }
}
