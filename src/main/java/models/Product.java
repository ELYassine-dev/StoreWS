package models;

public class Product {
    private int idpro;
    private String type;
    private String reference;
    private String description;
    private double price;
    private String image;

    public Product() {}

    public Product(int idpro, String type, String reference, String description, double price, String image) {
        this.idpro = idpro;
        this.type = type;
        this.reference = reference;
        this.description = description;
        this.price = price;
        this.image = image;
    }

    // Getters
    public int getIdpro() { return idpro; }
    public String getType() { return type; }
    public String getReference() { return reference; }
    public String getDescription() { return description; }
    public double getPrice() { return price; }
    public String getImage() { return image; }

    // Setters
    public void setIdpro(int idpro) { this.idpro = idpro; }
    public void setType(String type) { this.type = type; }
    public void setReference(String reference) { this.reference = reference; }
    public void setDescription(String description) { this.description = description; }
    public void setPrice(double price) { this.price = price; }
    public void setImage(String image) { this.image = image; }
}
