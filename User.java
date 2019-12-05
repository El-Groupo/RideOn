package Models;

public class User 
{
    //******************************************** User's member variables ********************************************//
    
    // The user's username
    private String username;

    // The user's password
    private String password;

    // The user's email address
    private String email;

    // The user's first name
    private String firstName;

    // The user's zip code
    private Integer zipCode; 

    //********************************************** User's constructor **********************************************//
    public User() 
    {

    }

    //************************************************ User's getters ************************************************//
    
    // Returns the user's username
    public String getUsername()
    {
        return username;
    }

    // Returns the user's password
    public String getPassword()
    {
        return password;
    }

    // Returns the user's email address
    public String getEmail()
    {
        return email;
    }

    // Returns the user's first name
    public String getFirstName()
    {
        return firstName;
    }

    // Returns the user's zip code
    public Integer getZipCode()
    {
        return zipCode;
    }

    //************************************************ User's setters ************************************************//
    
    // Gives the user a new username
    public void setUsername(String newUsername)
    {
        username = newUsername;
    }

    // Gives the user a new password
    public void setPassword(String newPassword)
    {
        password = newPassword;
    }

    // Gives the user a new email address
    public void setEmail(String newEmail)
    {
        email = newEmail;
    }

    // Gives the user a new first name
    public void setFirstName(String newFirstName)
    {
        firstName = newFirstName;
    }

    // Gives the user a new zip code
    public void setZipCode(Integer newZipCode)
    {
        zipCode = newZipCode;
    }
    

    //******************************************** User's other functions ********************************************//

    // Checks to see if this current user equals another suspected user "o"
    @Override
    public boolean equals(Object o)
    {
        if (o == null) 
        {
            return false;
        }
        if (o instanceof User) 
        {
            User oUser = (User) o;
            return oUser.getUsername().equals(getUsername()) &&
                    oUser.getPassword().equals(getPassword()) &&
                    oUser.getEmail().equals(getEmail()) &&
                    oUser.getFirstName().equals(getFirstName()) &&
                    oUser.getZipCode().equals(getZipCode());
        }
        else 
        {
            return false;
        }
    }
}
