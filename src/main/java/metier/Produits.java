package metier;

public class Produits {
	
	private int idpro;
	private String type;
	private String reference;
	private String desc;
	private double prix;
	public int getIdpro() {
		return idpro;
	}
	public void setIdpro(int idpro) {
		this.idpro = idpro;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public String getReference() {
		return reference;
	}
	public void setReference(String reference) {
		this.reference = reference;
	}
	public String getDesc() {
		return desc;
	}
	public void setDesc(String desc) {
		this.desc = desc;
	}
	public double getPrix() {
		return prix;
	}
	public void setPrix(double prix) {
		this.prix = prix;
	}
	public Produits(int idpro, String type, String reference, String desc, double prix) {
		super();
		this.idpro = idpro;
		this.type = type;
		this.reference = reference;
		this.desc = desc;
		this.prix = prix;
	}
	public Produits() {
		super();
	}

}
