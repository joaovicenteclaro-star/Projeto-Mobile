using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using TaskFlowAPI.Data;
using TaskFlowAPI.Models;

namespace TaskFlowAPI.Controllers;

[ApiController]
[Route("api/[controller]")]
public class TarefasController : ControllerBase
{
    private readonly AppDbContext _context;

    public TarefasController(AppDbContext context)
    {
        _context = context;
    }

    [HttpGet]
    public async Task<ActionResult<IEnumerable<Tarefa>>> Listar()
    {
        return Ok(await _context.Tarefas
            .AsNoTracking()
            .OrderBy(t => t.Id)
            .ToListAsync());
    }

    [HttpGet("{id:int}")]
    public async Task<ActionResult<Tarefa>> Buscar(int id)
    {
        var tarefa = await _context.Tarefas.FindAsync(id);

        if (tarefa is null)
            return NotFound();

        return Ok(tarefa);
    }

    [HttpPost]
    public async Task<ActionResult<Tarefa>> Criar(Tarefa tarefa)
    {
        tarefa.Id = 0;

        if (!PrioridadeValida(tarefa.Prioridade))
            return BadRequest("Prioridade inválida.");

        _context.Tarefas.Add(tarefa);
        await _context.SaveChangesAsync();

        return CreatedAtAction(
            nameof(Buscar),
            new { id = tarefa.Id },
            tarefa);
    }

    [HttpPut("{id:int}")]
    public async Task<IActionResult> Atualizar(int id, Tarefa dados)
    {
        if (!PrioridadeValida(dados.Prioridade))
            return BadRequest("Prioridade inválida.");

        var tarefa = await _context.Tarefas.FindAsync(id);

        if (tarefa is null)
            return NotFound();

        tarefa.Titulo = dados.Titulo;
        tarefa.Concluida = dados.Concluida;
        tarefa.Prioridade = dados.Prioridade;
        tarefa.DataVencimento = dados.DataVencimento;

        await _context.SaveChangesAsync();

        return NoContent();
    }

    [HttpDelete("{id:int}")]
    public async Task<IActionResult> Excluir(int id)
    {
        var tarefa = await _context.Tarefas.FindAsync(id);

        if (tarefa is null)
            return NotFound();

        _context.Tarefas.Remove(tarefa);
        await _context.SaveChangesAsync();

        return NoContent();
    }

    private static bool PrioridadeValida(string? prioridade) =>
        prioridade is "baixa" or "media" or "alta";
}