import 'package:flutter/material.dart';

double calculateTotalWithoutTax(List<Map<String, dynamic>> items) {
  return items.fold(0.0, (sum, item) {
    return sum + ((item['rate'] - item['discount']) * item['quantity']);
  });
}

double calculateTotalTax(List<Map<String, dynamic>> items) {
  return items.fold(0.0, (sum, item) {
    double base = (item['rate'] - item['discount']) * item['quantity'];
    return sum + (base * item['tax'] / 100);
  });
}

double calculateTotalWithTax(List<Map<String, dynamic>> items) {
  return calculateTotalWithoutTax(items) + calculateTotalTax(items);
}
