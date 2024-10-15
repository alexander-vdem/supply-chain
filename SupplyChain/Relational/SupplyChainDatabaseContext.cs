using Microsoft.EntityFrameworkCore;
using Models;
namespace SupplyChain.Relational;

public class SupplyChainDatabaseContext : DbContext
{
    public DbSet<Product> Products { get; set; }
    public DbSet<Supplier> Suppliers { get; set; }

    public SupplyChainDatabaseContext
    (DbContextOptions<SupplyChainDatabaseContext> options) : base(options) {}

    protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            modelBuilder.Entity<Product>()
                .HasOne(p => p.ParentProduct);

            // Add other entity configurations and seed data here
        }
}