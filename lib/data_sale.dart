class Sale {
  final String id;
  final String buyer;
  final String phone;
  final String date;
  final String status;

  Sale({
    required this.id,
    required this.buyer,
    required this.phone,
    required this.date,
    required this.status,
  });

  factory Sale.fromJson(Map<String, dynamic> json) {
    return Sale(
      id: json['id'] ?? '',  // Add default value
      buyer: json['buyer'] ?? 'Unknown Buyer',  // Add default value
      phone: json['phone'] ?? 'Unknown Phone',  // Add default value
      date: json['date'] ?? 'Unknown Date',  // Add default value
      status: json['status'] ?? 'Unknown Status',  // Add default value
    );
  }
}
