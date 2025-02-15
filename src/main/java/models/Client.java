package models;

public class Client {
    private int id;
    private String name;
    private String lastname;
    private String email;
    private String phone;
    private String adresse;

    public Client() {}

    public Client(int id, String name, String lastname, String email, String phone, String adresse) {
        this.id = id;
        this.name = name;
        this.lastname = lastname;
        this.email = email;
        this.phone = phone;
        this.adresse = adresse;
    }

    // Getters
    public int getId() { return id; }
    public String getName() { return name; }
    public String getLastname() { return lastname; }
    public String getEmail() { return email; }
    public String getPhone() { return phone; }
    public String getAdresse() { return adresse; }

    // Setters
    public void setId(int id) { this.id = id; }
    public void setName(String name) { this.name = name; }
    public void setLastname(String lastname) { this.lastname = lastname; }
    public void setEmail(String email) { this.email = email; }
    public void setPhone(String phone) { this.phone = phone; }
    public void setAdresse(String adresse) { this.adresse = adresse; }
}
