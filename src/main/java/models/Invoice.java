package models;

import java.util.Date;

public class Invoice {
    private int id;
    private int idClient;
    private String product;
    private int quantity;
    private double price;
    private double totalPrice;

    public Invoice() {}

    public Invoice(int id, int idClient, String product,int quantity, double price, double totalPrice) {
        this.id = id;
        this.idClient = idClient;
        this.product = product;
        this.quantity = quantity;
        this.price = price;
        this.totalPrice = totalPrice;
    }


    // Getters
    public int getId() { return id; }
    public int getClientId() { return idClient; }
    public String getProduct() { return product; }
    public int getQuantity() { return quantity; }
    public double getPrice() { return price; }
    public double getTotalPrice() { return totalPrice; }

    // Setters
    public void setId(int id) { this.id = id; }
    public void setClientId(int idClient) { this.idClient = idClient; }
    public void setProduct(String status) { this.product = product; }
    public void setPrice(double total) { this.price = price; }
    public void setTotalPrice(double total) { this.totalPrice = totalPrice; }

}
