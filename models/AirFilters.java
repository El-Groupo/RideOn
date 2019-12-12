package Models;

public class AirFilter {
    private String toyNickname;
    private String associatedUsername;
    private float totalHours;
    private float hoursSinceChange;
    private float hoursSinceCleaning;
    private float totalMiles;

    public AirFilter() {

    }

    public String getToyNickname() {
        return toyNickname;
    }

    public String getAssociatedUsername() {
        return associatedUsername;
    }

    public float getTotalHours() {
        return totalHours;
    }

    public float getHoursSinceChange() {
        return hoursSinceChange;
    }

    public float getHoursSinceCleaning() {
        return hoursSinceCleaning;
    }

    public float getTotalMiles() {
        return totalMiles;
    }

    public void setToyNickname(String toyNickname) {
        this.toyNickname = toyNickname;
    }

    public void setAssociatedUsername(String associatedUsername) {
        this.associatedUsername = associatedUsername;
    }

    public void setTotalHours(float totalHours) {
        this.totalHours = totalHours;
    }

    public void setHoursSinceChange(float hoursSinceChange) {
        this.hoursSinceChange = hoursSinceChange;
    }

    public void setHoursSinceCleanig(float hoursSinceCleaning) {
        this.hoursSinceCleaning = hoursSinceCleaning;
    }

    public void setTotalMiles(float totalMiles) {
        this.totalMiles = totalHours;
    }
}