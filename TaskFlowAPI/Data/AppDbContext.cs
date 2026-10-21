using Microsoft.EntityFrameworkCore;
using TaskFlowAPI.Models;

namespace TaskFlowAPI.Data;

public class AppDbContext : DbContext
{
    public AppDbContext(DbContextOptions<AppDbContext> options)
        : base(options)
    {
    }

    public DbSet<Tarefa> Tarefas => Set<Tarefa>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);

        modelBuilder.Entity<Tarefa>(entity =>
        {
            entity.ToTable("Tarefas", table =>
            {
                table.HasCheckConstraint(
                    "CK_Tarefas_Prioridade",
                    "[Prioridade] IN ('baixa', 'media', 'alta')");

                table.HasCheckConstraint(
                    "CK_Tarefas_Titulo",
                    "LEN(LTRIM(RTRIM([Titulo]))) > 0");
            });

            entity.HasKey(t => t.Id);
            entity.Property(t => t.Titulo).HasMaxLength(200).IsRequired();
            entity.Property(t => t.Prioridade).HasMaxLength(10).IsRequired();
            entity.Property(t => t.Concluida).HasDefaultValue(false);
            entity.Property(t => t.Prioridade).HasDefaultValue("media");
        });
    }
}