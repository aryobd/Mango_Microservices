using Mango.Services.AuthAPI.Models;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;

namespace Mango.Services.AuthAPI.Data
{
    public class AppDbContext : IdentityDbContext<ApplicationUser>
    {
        public AppDbContext(DbContextOptions<AppDbContext> options) : base(options)
        {
        }

        public DbSet<ApplicationUser> ApplicationUsers { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            modelBuilder.Entity<ApplicationUser>().ToTable( // ChatGPT-20260722WED-01.pdf
                tb =>
                {
                    //tb.HasTrigger("TG_AspNetUsers");
                    tb.HasTrigger("xxx"); // ABDP | 20260722WED | TIDAK BOLEH STRING KOSONG, HANYA MEMBERITAHU ENTITY FRAMEWORK BAHWA DI DATABASE INI ADA TRIGGER
                }
            );
        }
    }
}
