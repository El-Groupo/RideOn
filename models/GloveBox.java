package Models;

public class GloveBox {
    private String toyNickname;
    private String associatedUsername;
    private int vin;
    private int insuranceMonth;

    public GloveBox() {

    }

    public String getToyNickname() {
        return toyNickname;
    }

    public String getAssociatedUsername() {
        return associatedUsername;
    }

    public int getVin() {
        return vin;
    }

    public int getInsuranceMonth() {
        return insuranceMonth;
    } 

    public void setToyNickname(String toyNickname) {
        this.toyNickname = toyNickname;
    }

    public void setAssociatedUsername(String associatedUsername) {
        this.associatedUsername = associatedUsername;
    }

    public void setVin() {
        this.vin = vin;
    }

    public void setInsuranceMonth() {
        this.insuranceMonth = insuranceMonth;
    }
}
