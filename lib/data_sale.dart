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
      id: json['id'] ?? '',  
      buyer: json['buyer'] ?? 'Unknown Buyer',  
      phone: json['phone'] ?? 'Unknown Phone',  
      date: json['date'] ?? 'Unknown Date',  
      status: json['status'] ?? 'Unknown Status',  
    );
  }
}
