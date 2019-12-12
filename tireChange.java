package Models;

public class tireChange {
    /** vehicle's nickname */
    private String toyNickname;
    /** assiciated user*/
    private String associatedUsername;
    /** toy type */
    private String frontSize;
    /** vehicle's year */
    private int hoursSinceChangeFront;
    /** vehicle's make */
    private String rearSize;
    /** vehicle's model */
    private String hoursSinceChangeRear;
    /** vehicle's registration month */
    private String totalMiles;

    public Garage() {
    }


    public void setNickname(String nickname){
        toyNickname = nickname;
    }
    public String getNickname(){ return toyNickname;}
	
	public void setAssociatedUsername(String username){
        associatedUsername = username;
    }
    public String getAssociatedUsername(){ return associatedUsername;}
	
	public void setToyType(String type){
        toyType = type;
    }
    public String getToyType(){ return toyType;}
	
	public void setYear(String year){
        this->year = year;
    }
    public int getYear(){ return year;}
	
	public void setMake(String make){
        this->make = make;
    }
    public String getMake(){ return make;}
	
	public void setModel(String model){
        this->model = model;
    }
    public String getModel(){ return model;}
	
	public void setRegistrationMonth(String month){
        registrationMonth = month;
    }
    public String getRegistrationMonth(){ return registrationMonth;}
	
	public void setDateOfPurchase(Date purchaseDate){
        dateOfPurchase = purchaseDate;
    }
    public Date getDateOfPurchase(){ return dateOfPurchase;}
    

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