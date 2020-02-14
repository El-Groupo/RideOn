package Models;

public class AdditionalMaintenance {
    private String toyNickname;
    private String associatedUsername;
    private String maintenanceType;
    private float totalHours;
    private float totalMiles;
    private String description;

    public AdditionalMaintenance() {

    }

    public String getToyNickname() {
        return toyNickname;
    }

    public String getAssociatedUsername() {
        return associatedUsername;
    }

    public String getMaintenanceType() {
        return maintenanceType;
    }

    public float getTotalHours() {
        return totalHours;
    }

    public float getTotalMiles() {
        return totalMiles;
    }

    public String getDescription() {
        return description;
    }

    public void setToyNickname(String toyNickname) {
        this.toyNickname = toyNickname;
    }

    public void setAssociatedUsername(String associatedUsername) {
        this.associatedUsername = associatedUsername;
    }

    public void setMaintenanceType(String maintenanceType) {
        this.maintenanceType = maintenanceType;
    }

    public void setTotalHours(float totalHours) {
        this.totalHours = totalHours;
    }

    public void setTotalMiles(float totalMiles) {
        this.totalMiles = totalHours;
    }

    public void setDescription(String description) {
        this.description = description;
    }
}