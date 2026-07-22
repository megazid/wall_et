class HomeController {
  static double parseAmount(String amountStr) {
    String clean = amountStr.replaceAll('-', '').replaceAll(',', '').trim();
    return double.tryParse(clean) ?? 0.0;
  }


  static double calculateDayTotal(List<dynamic> invoices){
    return invoices.fold(0.0, (sum,item)=> sum + parseAmount(item["amount"]));
  }

  static double calculateGrandTotal(List<Map<String,dynamic>> daysData){
    return daysData.fold(0.0, (grandSum,day){
      return grandSum + calculateDayTotal(day["invoices"]);
    });
  }
}