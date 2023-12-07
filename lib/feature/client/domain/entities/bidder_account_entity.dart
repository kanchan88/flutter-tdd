class BidderAccountEntity {

  String id;
  String fullName;
  int bidAmount;
  String date;
  String email;

  BidderAccountEntity ({
    required this.id,
    required this.email,
    required this.fullName,
    required this.bidAmount,
    required this.date,
  });

}