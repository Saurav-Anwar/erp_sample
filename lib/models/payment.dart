class Payment {
  final String paymentId;
  final int amount;
  final String requestedBy;
  final String requestDate;
  final List<Invoice> invoices;
  final ApprovalFlow approvalFlow;

  Payment({
    required this.paymentId,
    required this.amount,
    required this.requestedBy,
    required this.requestDate,
    required this.invoices,
    required this.approvalFlow,
  });

  factory Payment.fromJson(Map<String, dynamic> data) {
    return Payment(
      paymentId: data['paymentId'],
      amount: data['amount'],
      requestedBy: data['requestedBy'],
      requestDate: data['requestDate'],
      invoices: data['invoices'] == null ? [] : (data['invoices'] as List)
          .map((e) => Invoice.fromJson(e))
          .toList(),
      approvalFlow: ApprovalFlow.fromJson(data['approvalFlow']),
    );
  }
}

class Invoice {
  final String invoiceId;
  final String vendor;
  final double amount;

  Invoice({
    required this.invoiceId,
    required this.vendor,
    required this.amount,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
      invoiceId: json['invoiceId'],
      vendor: json['vendor'],
      amount: json['amount'],
    );
  }
}

class ApprovalFlow {
  final String approvedBy;
  final String approvedDate;
  final String status;

  ApprovalFlow({
    required this.approvedBy,
    required this.approvedDate,
    required this.status,
  });

  factory ApprovalFlow.fromJson(Map<String, dynamic> json) {
    return ApprovalFlow(
      approvedBy: json['approvedBy'],
      approvedDate: json['approvedDate'],
      status: json['status'],
    );
  }
}
