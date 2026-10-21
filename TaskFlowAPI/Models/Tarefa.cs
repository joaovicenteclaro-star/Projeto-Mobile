using System.ComponentModel.DataAnnotations;

namespace TaskFlowAPI.Models;

public class Tarefa
{
    public int Id { get; set; }

    [Required]
    [StringLength(200)]
    public string Titulo { get; set; } = string.Empty;

    public bool Concluida { get; set; }

    [Required]
    public string Prioridade { get; set; } = "media";

    public DateTime? DataVencimento { get; set; }
}
