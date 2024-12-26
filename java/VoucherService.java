public class VoucherService {
    public String calculateVoucher(int familyIncome, int distance) {
        if (familyIncome < 30000 && distance > 3) {
            return "Eligible for a $50 transfortation voucher";
        } else {
            return "Not eligible for a voucher";
        }
    }

    public String init() {

        // Initialization code here
        return "Voucher service initialized";
    }
}
