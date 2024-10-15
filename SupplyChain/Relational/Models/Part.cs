namespace Models;

public class Product
{
    public int Id { get; set; }
    public string Name { get; set; }
    public Product? ParentProduct { get; set; }
    public Supplier Supplier { get; set; }
}
