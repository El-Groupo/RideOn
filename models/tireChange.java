package Models;

public class tireChange {
    /** vehicle's nickname */
    private String toyNickname;
    /** assiciated user*/
    private String associatedUsername;
    /** toy type */
    private int frontSize;
    /** vehicle's year */
    private int hoursSinceChangeFront;
    /** vehicle's make */
    private int rearSize;
    /** vehicle's model */
    private int hoursSinceChangeRear;
    /** vehicle's registration month */
    private int totalMiles;

    public Garage() {
    }


    public void setToyNickname(String nickname){
        toyNickname = nickname;
    }
    public String getToyNickname(){ return toyNickname;}
	
	public void setAssociatedUsername(String username){
        associatedUsername = username;
    }
    public String getAssociatedUsername(){ return associatedUsername;}
	
	public void setFrontSize(int size){
        frontSize = size;
    }
    public String getFrontSize(){ return frontSize;}
	
	public void setHoursSinceChangeFront(int hours){
        hoursSinceChangeFront = hours;
    }
    public int getHoursSinceChangeFront(){ return hoursSinceChangeFront;}
	
	public void setHoursSinceChangeRear(int hours){
        hoursSinceChangeRear = hours;
    }
    public String getHoursSinceChangeRear(){ return hoursSinceChangeRear;}
	
	public void setTotalMiles(int miles){
        totalMiles = miles;
    }
    public String getTotalMiles(){ return totalMiles;}


    /**
     *checks to see if two garage entries are equal
     *@param o the object that is being compared
     *@return true if equal, false if not
     */
    @Override
    public boolean equals(Object o){
        if (o == null) {
            return false;
        }
        if (o instanceof Garage) {
            Garage oGarage = (Garage) o;
            return oGarage.getNickname().equals(getNickname()) &&
                    oGarage.getAssociatedUsername().equals(getAssociatedUsername()) &&
                    oGarage.getToyType().equals(getToyType()) &&
                    oGarage.getYear().equals(getYear()) &&
                    oGarage.getMake().equals(getMake()) &&
                    oGarage.getModel().equals(getModel()) &&
					oGarage.getRegistrationMonth().equals(getRegistrationMonth()) &&
					oGarage.getDateOfPurchase().equals(getDateOfPurchase());
        }
        else {
            return false;
        }
    }
}